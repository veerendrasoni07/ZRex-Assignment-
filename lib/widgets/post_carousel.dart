import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class PostCarousel extends StatefulWidget {
  const PostCarousel({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<PostCarousel> createState() => _PostCarouselState();
}

class _PostCarouselState extends State<PostCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return _ZoomableImage(imageUrl: widget.imageUrls[index]);
            },
          ),
        ),
        if (widget.imageUrls.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(widget.imageUrls.length, (index) {
                final bool isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 8 : 6,
                  height: isActive ? 8 : 6,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.blueAccent : AppColors.border,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _ZoomableImage extends StatefulWidget {
  const _ZoomableImage({required this.imageUrl});

  final String imageUrl;

  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage> with TickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset _startFocal = Offset.zero;
  late AnimationController _resetController;
  VoidCallback? _resetTick;
  AnimationStatusListener? _resetStatusListener;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void dispose() {
    if (_resetTick != null) {
      _resetController.removeListener(_resetTick!);
    }
    if (_resetStatusListener != null) {
      _resetController.removeStatusListener(_resetStatusListener!);
    }
    _resetController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final double backdropOpacity = (_scale - 1).clamp(0, 0.6);
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(backdropOpacity),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: false,
                child: Center(
                  child: Transform.translate(
                    offset: _offset,
                    child: Transform.scale(
                      scale: _scale,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: _buildImage(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Pinch-to-zoom uses a temporary Overlay so the image can scale
  // above the rest of the UI and then animate back to its place.
  void _onScaleStart(ScaleStartDetails details) {
    _resetController.stop();
    _scale = 1.0;
    _offset = Offset.zero;
    _startFocal = details.focalPoint;
    _showOverlay();
    _overlayEntry?.markNeedsBuild();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    _scale = details.scale.clamp(1.0, 3.0);
    _offset = details.focalPoint - _startFocal;
    _overlayEntry?.markNeedsBuild();
  }

  void _onScaleEnd(ScaleEndDetails details) {
    final double startScale = _scale;
    final Offset startOffset = _offset;

    _resetController.reset();
    if (_resetTick != null) {
      _resetController.removeListener(_resetTick!);
    }
    if (_resetStatusListener != null) {
      _resetController.removeStatusListener(_resetStatusListener!);
    }

    _resetTick = () {
      final double t = Curves.easeOut.transform(_resetController.value);
      _scale = startScale + (1.0 - startScale) * t;
      _offset = Offset.lerp(startOffset, Offset.zero, t) ?? Offset.zero;
      _overlayEntry?.markNeedsBuild();
    };
    _resetStatusListener = (status) {
      if (status == AnimationStatus.completed) {
        if (_resetTick != null) {
          _resetController.removeListener(_resetTick!);
        }
        if (_resetStatusListener != null) {
          _resetController.removeStatusListener(_resetStatusListener!);
        }
        _removeOverlay();
      }
    };
    _resetController.addListener(_resetTick!);
    _resetController.addStatusListener(_resetStatusListener!);
    _resetController.forward();
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, _) => Container(color: AppColors.shimmerBase),
      errorWidget: (context, _, __) => Container(
        color: AppColors.shimmerBase,
        child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: _buildImage(),
    );
  }
}
