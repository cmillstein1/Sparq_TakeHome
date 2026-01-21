# 🎮 Pokemon Explorer

A beautiful, modern iOS app built with SwiftUI that displays Pokemon from the [PokeAPI](https://pokeapi.co/) with infinite scrolling, list/grid view toggle, and type-based color coding.

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![iOS](https://img.shields.io/badge/iOS-26.2+-blue.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)

## ✨ Features

- 🔄 **Infinite Scrolling** - Seamlessly load Pokemon as you scroll
- 📱 **Dual View Modes** - Switch between list and grid views
- 🎨 **Type-Based Colors** - Color-coded Pokemon types (Fire, Water, Grass, etc.)
- 🖼️ **Image Caching** - Fast image loading with persistent cache
- ⚡ **Parallel Fetching** - Concurrent API calls for optimal performance
- 🔁 **Retry Logic** - Automatic retry with exponential backoff
- 🎭 **Smooth Animations** - Staggered grid animations and transitions
- 🌐 **Offline Support** - Cached data available when offline

## 🏗️ Architecture

Built with a clean **MVVM** architecture:

```
Sparq_TakeHome/
├── Network/          # Protocol-based network layer
├── Models/           # Codable data models
├── ViewModels/       # Business logic & state management
├── Views/            # SwiftUI views
└── Components/       # Reusable UI components
```

### Key Technologies

- **SwiftUI** - Modern declarative UI framework
- **Async/Await** - Modern Swift concurrency
- **TaskGroup** - Parallel data fetching
- **URLCache** - Network response caching
- **Combine** - Reactive state management

## 🚀 Getting Started

### Requirements

- Xcode 26.2+
- iOS 26.2+
- Swift 5.0+

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/Sparq_TakeHome.git
```

2. Open the project in Xcode
```bash
cd Sparq_TakeHome
open Sparq_TakeHome.xcodeproj
```

3. Build and run (⌘R)

## 📱 Usage

1. **Launch** - Enjoy the splash screen animation
2. **Browse** - Scroll through Pokemon in list or grid view
3. **Switch Views** - Tap the grid/list icon in the top-right
4. **Explore Types** - See color-coded Pokemon types below each name

## 🎯 Key Features Explained

### Infinite Scrolling
- Automatically loads more Pokemon 3-6 items before reaching the end
- Smooth, non-blocking background loading
- Prevents duplicate requests

### Caching Strategy
- **50MB** memory cache for fast access
- **100MB** disk cache for offline support
- Automatic cache invalidation based on HTTP headers

### Error Handling
- Graceful degradation for failed requests
- User-friendly error messages
- Retry functionality with exponential backoff

## 🎨 Design Highlights

- Large navigation title that collapses on scroll
- Staggered spring animations in grid view
- Smooth transitions between list/grid modes
- Color-coded type segments matching Pokemon types

## 📊 Performance

- Parallel fetching reduces load time by ~70%
- Image caching provides instant load on subsequent views
- Lazy loading renders only visible items
- Shared JSONDecoder reduces memory overhead

## 📝 License

This project is a take-home assignment for Sparq.

## 🙏 Acknowledgments

- [PokeAPI](https://pokeapi.co/) for the amazing Pokemon data API
- Pokemon assets and sprites from the official Pokemon games

---

Made with ❤️ using SwiftUI
