# InteractivePizza

An interactive pizza builder iOS app built with SwiftUI.

## Features

- Animated splash screen with pizza frame animation
- Horizontal pizza catalog with snap-scroll carousel
- S / M / L size selection with dynamic visual scaling
- Real-time price calculation based on size and quantity
- Fullscreen pinch-to-zoom overlay for pizza images
- Staggered fly-in animations throughout the UI
- Custom theme system (background, highlight, accent, active colors)

## Tech Stack

| Layer | Technology |
|---|---|
| UI | SwiftUI |
| State | `@Observable` (Observation framework) |
| Architecture | Domain-Driven Design (DDD) |
| Navigation | Custom router-based (`AppRouter`) |
| Networking | `URLSession` + `async/await` |
| Persistence | In-memory (protocol-ready for CoreData) |
| DI | Factory-based (`AppContainer`) |

## Requirements

- iOS 17.6+
- Xcode 26.6+

## Getting Started

1. Open `InteractivePizza.xcodeproj` in Xcode
2. Select an iPhone simulator (iOS 17.6+)
3. Press `Cmd+R`

## Project Structure

```
InteractivePizza/
├── Domain/          — Entities, protocols, errors (pure Swift)
├── Infrastructure/  — DataSource implementations
├── Application/     — Managers, DI container
├── Service/         — Networking + image caching
├── Presentation/    — Views, ViewModels, Router, Theme
└── Resources/       — Fonts, assets
```

## Architecture

Layers follow strict dependency rules — dependencies point inward toward Domain:

```
Presentation → Application → Domain ← Infrastructure
```

- Domain never imports CoreData or SwiftUI
- CoreData/API models never leak into Presentation
- ViewModels depend on protocol abstractions, not concrete types
- Business logic lives in Entities or Managers, never in Views

## License

All rights reserved.
