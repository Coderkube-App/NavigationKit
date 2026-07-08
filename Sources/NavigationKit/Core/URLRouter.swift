//
// Copyright (c) 2026 Coderkube Technologies - NavigationKit. All rights reserved.
//

import Foundation

/// A protocol that defines how to parse a URL into a strongly typed navigation route.
public protocol URLRouteParser {
    associatedtype Route: NavigationRoute
    func parse(_ url: URL) -> Route?
}

/// A router to handle deep links and incoming URLs.
@MainActor
public class URLRouter {
    public static let shared = URLRouter()
    
    private var handlers: [(URL) -> Bool] = []
    
    private init() {}
    
    /// Registers a generic handler for URLs.
    public func registerHandler(_ handler: @escaping (URL) -> Bool) {
        handlers.append(handler)
    }
    
    /// Registers a parser that handles incoming URLs and maps them to a specific Route type.
    /// When successfully parsed, it uses `NavigationManager` to navigate.
    public func register<Parser: URLRouteParser>(_ parser: Parser, action: @escaping (Parser.Route) -> Void) {
        handlers.append { url in
            if let route = parser.parse(url) {
                action(route)
                return true
            }
            return false
        }
    }
    
    /// Evaluates the URL against all registered handlers.
    /// - Parameter url: The URL to handle.
    /// - Returns: `true` if a handler processed the URL, `false` otherwise.
    @discardableResult
    public func handle(_ url: URL) -> Bool {
        for handler in handlers {
            if handler(url) {
                return true
            }
        }
        return false
    }
}
