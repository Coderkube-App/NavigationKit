# NavigationKit

`NavigationKit` is a centralized, type-safe navigation framework for SwiftUI using modern `NavigationStack` APIs. It provides state management, routing, modal presentation, bottom sheets, full screen covers, tab navigation, and deep link URL routing.

## Requirements

- iOS 16.0+
- macOS 13.0+
- Swift 6.0+

## Features

- **NavigationStack management:** Easy to use `push`, `pop`, `popToRoot`.
- **Type-safe routing:** Define your routes using the `NavigationRoute` protocol.
- **Deep linking:** Parse and handle incoming URLs using `URLRouter`.
- **Modal presentation:** Present sheets and full screen covers.
- **Bottom sheet routing:** Presentation detents for bottom sheets.
- **Custom transitions:** Supported through standard SwiftUI navigation modifiers.
- **Navigation history:** Accessible via `NavigationPath`.
- **Tab navigation:** Manage active tab states through `NavigationManager`.

## Package Structure

```text
NavigationKit/
 ├── Sources/NavigationKit/
 │   ├── Core/         (NavigationManager, URLRouter)
 │   ├── Domain/       (NavigationRoute)
 │   └── Presentation/ (RoutedNavigationStack)
 ├── Tests/NavigationKitTests/
 └── Package.swift
```

## Usage

### Define Your Routes

Implement the `NavigationRoute` protocol (which requires `Hashable`).

```swift
import NavigationKit

enum AppRoute: NavigationRoute {
    case profile(userID: String)
    case settings
    
    var id: String {
        switch self {
        case .profile(let id): return "profile-\(id)"
        case .settings: return "settings"
        }
    }
}
```

### Setup the Navigation Stack

Use the `RoutedNavigationStack` at the root of your application.

```swift
import SwiftUI
import NavigationKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            RoutedNavigationStack(
                root: {
                    HomeView()
                },
                destination: { (route: AppRoute) in
                    switch route {
                    case .profile(let userID):
                        ProfileView(userID: userID)
                    case .settings:
                        SettingsView()
                    }
                }
            )
        }
    }
}
```

### Perform Navigation

Use the singleton `NavigationManager` from anywhere in your app to push, pop, or present modals.

```swift
import NavigationKit

// Push to the stack
NavigationManager.shared.push(AppRoute.profile(userID: "123"))

// Present a sheet
NavigationManager.shared.present(AppRoute.settings)

// Pop the top view
NavigationManager.shared.pop()

// Pop to the root
NavigationManager.shared.popToRoot()
```

### Handling Deep Links

Register URL handlers with `URLRouter`.

```swift
import NavigationKit

struct AppRouteParser: URLRouteParser {
    typealias Route = AppRoute
    
    func parse(_ url: URL) -> AppRoute? {
        if url.host == "profile" {
            let userID = url.lastPathComponent
            return .profile(userID: userID)
        }
        return nil
    }
}

// In your setup code:
URLRouter.shared.register(AppRouteParser()) { route in
    NavigationManager.shared.push(route)
}

// In your root view:
.onOpenURL { url in
    URLRouter.shared.handle(url)
}
```

## License

This project is licensed under the MIT License.
