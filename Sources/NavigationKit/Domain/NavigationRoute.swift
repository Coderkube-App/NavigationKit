//
// Copyright (c) 2026 Coderkube Technologies - NavigationKit. All rights reserved.
//

import Foundation
import SwiftUI

/// A protocol that defines a navigation route.
/// Conforming types can be used for type-safe routing.
public protocol NavigationRoute: Hashable, Identifiable {
    /// The unique identifier for the route, used for Identifiable conformance.
    var id: String { get }
}

public extension NavigationRoute {
    var id: String {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return String(hasher.finalize())
    }
}
