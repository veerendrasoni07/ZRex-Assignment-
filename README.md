# Flutter Instagram Feed UI

A Flutter application that replicates a simplified Instagram-style feed with stories, posts, pagination, shimmer loading effects, and interactive post actions.

The goal of this project is to demonstrate clean Flutter architecture, efficient state management, and smooth UI performance.

---

# Features

- Instagram-style **Home Feed UI**
- **Horizontal stories section**
- **Infinite scrolling feed (pagination)**
- **Like / Save interactions**
- **Shimmer loading skeletons**
- **Cached network image loading**
- **Efficient UI rebuilds using Riverpod**
- Modular and scalable code structure

---

# State Management

This project uses **Riverpod** for state management.

Riverpod is a reactive state management library for Flutter that separates business logic from UI and rebuilds widgets only when necessary.

## Why Riverpod

### 1. Reactive UI Updates

Riverpod automatically rebuilds widgets when state changes.

Example:

```dart
final postState = ref.watch(postFeedProvider);
```

Whenever `postFeedProvider` updates (new posts loaded, like toggled, save toggled), only the widgets that depend on it rebuild.

This prevents unnecessary UI rebuilds and improves performance.

---

### 2. Separation of Concerns

Riverpod keeps **business logic separate from UI widgets**.

Architecture used in this project:

```
UI Layer
HomeFeedScreen

State Layer
postFeedProvider

Logic Layer
PostFeedNotifier
```

This keeps the UI clean and improves maintainability.

---

### 3. No Dependency on BuildContext

Riverpod does not depend on Flutter’s `BuildContext`.

Example:

```dart
ref.read(postFeedProvider.notifier).loadMore();
```

This allows state access anywhere in the app logic.

---

### 4. Scalability

Riverpod makes it easier to scale large applications because state can be shared across multiple widgets without prop-drilling.

---

# Tech Stack

- Flutter
- Riverpod
- Cached Network Image
- Google Fonts

---

# Project Structure

```
lib/
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_sizes.dart
│   │
│   └── utils/
│
├── providers/
│   └── post_provider.dart
|
├── models/
│   └── post_model.dart
|   └── story_model.dart
│
├── services/
│   └── port_repository.dart
|
├── screens/
│   └── home_feed_screen.dart
│
├── widgets/
│   ├── post_card.dart
|   ├── post_carousel.dart
|   ├── post_header.dart
|   ├── post_caption.dart
|   ├── post_action.dart
│   ├── story_avatar.dart
│   ├── shimmer_post.dart
│   └── shimmer_story.dart
│
└── main.dart
```

This structure separates:

- UI components
- business logic
- reusable widgets
- core configurations

---

# Getting Started

## Prerequisites

Ensure the following tools are installed:

- Flutter SDK
- Dart SDK
- Android Studio or VS Code

Verify installation:

```bash
flutter doctor
```

---

# Installation

## Clone the repository

```bash
git clone https://github.com/veerendrasoni07/ZRex-Assignment-.git
```

Navigate into the project directory:

```bash
cd ZRex-Assignment-
```

---

## Install dependencies

```bash
flutter pub get
```

---

# Running the Application

Run the project on a connected device or emulator:

```bash
flutter run
```

---

# Build APK

To generate a release APK:

```bash
flutter build apk
```

The APK will be generated at:

```
build/app/outputs/flutter-apk/app-release.apk
```



# Key Concepts Demonstrated

This project demonstrates several important Flutter concepts:

- Riverpod state management
- Infinite scroll pagination
- ScrollController listeners
- Gesture detection
- Reusable widget design
- Shimmer loading placeholders
- Network image caching

---

# Future Improvements

Possible improvements:

- Backend integration
- User authentication
- Comments system
- Realtime updates
- Profile pages

---

# Author

**Veerendra Soni**

Flutter Developer
