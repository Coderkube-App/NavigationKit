//
// Copyright (c) 2026 Coderkube Technologies - NavigationKit. All rights reserved.
//

import SwiftUI
import Combine

/// A type-erased wrapper for any NavigationRoute to use in sheets and full screen covers.
public struct AnyIdentifiableRoute: Identifiable {
    public let id: String
    public let route: Any
    
    public init<T: NavigationRoute>(_ route: T) {
        self.id = route.id
        self.route = route
    }
}

/// A type-erased wrapper for bottom sheet routes to support detents.
public struct BottomSheetRoute: Identifiable {
    public let id: String
    public let route: Any
    public let detents: Set<PresentationDetent>
    
    public init<T: NavigationRoute>(route: T, detents: Set<PresentationDetent> = [.medium, .large]) {
        self.id = route.id
        self.route = route
        self.detents = detents
    }
}

/// Centralized manager for handling navigation in SwiftUI using modern APIs.
@MainActor
public class NavigationManager: ObservableObject {
    
    /// Global shared instance for easy access.
    public static let shared = NavigationManager()
    
    /// The current navigation path for stack-based navigation.
    @Published public var path = NavigationPath()
    
    /// The currently presented sheet route, if any.
    @Published public var presentedSheet: AnyIdentifiableRoute?
    
    /// The currently presented full screen cover route, if any.
    @Published public var presentedFullScreenCover: AnyIdentifiableRoute?
    
    /// The currently presented bottom sheet route, if any.
    @Published public var presentedBottomSheet: BottomSheetRoute?
    
    /// The active tab index for tab-based navigation.
    @Published public var selectedTab: Int = 0
    
    private init() {}
    
    // MARK: - Stack Navigation
    
    /// Pushes a new route onto the navigation stack.
    public func push<T: Hashable>(_ route: T) {
        path.append(route)
    }
    
    /// Pops the top route from the navigation stack.
    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    /// Pops back to the root of the navigation stack.
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    /// Pops a specific number of routes from the navigation stack.
    public func pop(count: Int) {
        guard path.count >= count else {
            popToRoot()
            return
        }
        path.removeLast(count)
    }
    
    // MARK: - Modals
    
    /// Presents a route as a standard sheet.
    public func present<T: NavigationRoute>(_ route: T) {
        presentedSheet = AnyIdentifiableRoute(route)
    }
    
    /// Dismisses the currently presented sheet.
    public func dismissSheet() {
        presentedSheet = nil
    }
    
    /// Presents a route as a full screen cover.
    public func presentFullScreen<T: NavigationRoute>(_ route: T) {
        presentedFullScreenCover = AnyIdentifiableRoute(route)
    }
    
    /// Dismisses the currently presented full screen cover.
    public func dismissFullScreen() {
        presentedFullScreenCover = nil
    }
    
    /// Presents a route as a bottom sheet with specific detents.
    public func presentBottomSheet<T: NavigationRoute>(_ route: T, detents: Set<PresentationDetent> = [.medium, .large]) {
        presentedBottomSheet = BottomSheetRoute(route: route, detents: detents)
    }
    
    /// Dismisses the currently presented bottom sheet.
    public func dismissBottomSheet() {
        presentedBottomSheet = nil
    }
    
    // MARK: - Global Dismissal
    
    /// Dismisses any currently presented modal (sheet, full screen cover, or bottom sheet).
    public func dismissAnyModal() {
        if presentedSheet != nil { dismissSheet() }
        if presentedFullScreenCover != nil { dismissFullScreen() }
        if presentedBottomSheet != nil { dismissBottomSheet() }
    }
    
    // MARK: - Tab Navigation
    
    /// Switches to the specified tab index.
    public func selectTab(_ index: Int) {
        selectedTab = index
    }
}
