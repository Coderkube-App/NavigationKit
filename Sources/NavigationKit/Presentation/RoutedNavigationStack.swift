//
// Copyright (c) 2026 Coderkube Technologies - NavigationKit. All rights reserved.
//

import SwiftUI

/// A custom NavigationStack wrapper that binds to the global NavigationManager.
/// It automatically handles navigation destinations, sheets, full screen covers, and bottom sheets.
public struct RoutedNavigationStack<Route: NavigationRoute, Root: View, Destination: View>: View {
    @StateObject private var manager = NavigationManager.shared
    
    let root: () -> Root
    let destination: (Route) -> Destination
    
    public init(
        @ViewBuilder root: @escaping () -> Root,
        @ViewBuilder destination: @escaping (Route) -> Destination
    ) {
        self.root = root
        self.destination = destination
    }
    
    public var body: some View {
        NavigationStack(path: $manager.path) {
            root()
                .navigationDestination(for: Route.self) { route in
                    destination(route)
                }
        }
        .sheet(item: $manager.presentedSheet) { wrapper in
            if let route = wrapper.route as? Route {
                destination(route)
            } else {
                Text("Unsupported route type for sheet")
            }
        }
#if !os(macOS)
        .fullScreenCover(item: $manager.presentedFullScreenCover) { wrapper in
            if let route = wrapper.route as? Route {
                destination(route)
            } else {
                Text("Unsupported route type for full screen cover")
            }
        }
#endif
        .sheet(item: $manager.presentedBottomSheet) { wrapper in
            if let route = wrapper.route as? Route {
                destination(route)
                    .presentationDetents(wrapper.detents)
            } else {
                Text("Unsupported route type for bottom sheet")
            }
        }
    }
}
