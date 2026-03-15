import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../core/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';


class PostCarousel extends StatefulWidget {
  const PostCarousel({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<PostCarousel> createState() => _PostCarouselState();
}

class _PostCarouselState extends State<PostCarousel> {
  final PhotoViewController _controller = PhotoViewController();
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: PhotoViewGallery.builder(
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  controller: _controller,
                  imageProvider: CachedNetworkImageProvider(widget.imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                );
              },
              scrollPhysics: const ClampingScrollPhysics(),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
            ),
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


class ZoomableImage extends StatefulWidget {
  final String imageUrl;

  const ZoomableImage({super.key, required this.imageUrl});

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage>
    with SingleTickerProviderStateMixin {

  OverlayEntry? _overlayEntry;

  Matrix4 _matrix = Matrix4.identity();

  late AnimationController _resetController;

  Offset _startFocal = Offset.zero;
  Matrix4 _startMatrix = Matrix4.identity();

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
    _resetController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final scale = _matrix.getMaxScaleOnAxis();
        double opacity = (scale - 1).clamp(0, 0.6);

        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(opacity),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Transform(
                  transform: _matrix,
                  child: _buildImage(),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _resetController.stop();

    _startFocal = details.focalPoint;
    _startMatrix = _matrix.clone();

    _showOverlay();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {

    final scale = details.scale;

    final dx = details.focalPoint.dx - _startFocal.dx;
    final dy = details.focalPoint.dy - _startFocal.dy;

    final translation = Matrix4.identity()
      ..translate(dx, dy);

    final scaling = Matrix4.identity()
      ..translate(details.focalPoint.dx, details.focalPoint.dy)
      ..scale(scale)
      ..translate(-details.focalPoint.dx, -details.focalPoint.dy);

    _matrix = translation * scaling * _startMatrix;

    _overlayEntry?.markNeedsBuild();
  }

  void _onScaleEnd(ScaleEndDetails details) {

    final Matrix4 beginMatrix = _matrix;
    final Matrix4 endMatrix = Matrix4.identity();

    _resetController.reset();

    _resetController.addListener(() {

      final t = Curves.easeOut.transform(_resetController.value);

      _matrix = Matrix4Tween(
        begin: beginMatrix,
        end: endMatrix,
      ).transform(t);

      _overlayEntry?.markNeedsBuild();
    });

    _resetController.forward().whenComplete(() {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _matrix = Matrix4.identity();
    });
  }

  Widget _buildImage() {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      panEnabled: true,
      scaleEnabled: true,
      boundaryMargin: EdgeInsets.all(double.infinity),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }
}
