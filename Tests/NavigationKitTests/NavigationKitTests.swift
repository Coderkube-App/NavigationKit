//
// Copyright (c) 2026 Coderkube Technologies - NavigationKit. All rights reserved.
//

import Testing
@testable import NavigationKit

@Suite
@MainActor
struct NavigationKitTests {
    
    @Test func testPushAndPop() async throws {
        let manager = NavigationManager.shared
        
        manager.popToRoot()
        #expect(manager.path.isEmpty)
        
        manager.push("TestRoute")
        #expect(!manager.path.isEmpty)
        
        manager.pop()
        #expect(manager.path.isEmpty)
    }
    
    @Test func testPresentSheet() async throws {
        let manager = NavigationManager.shared
        manager.dismissAnyModal()
        #expect(manager.presentedSheet == nil)
        
        struct MockRoute: NavigationRoute {
            var id: String = "mock"
        }
        
        manager.present(MockRoute())
        #expect(manager.presentedSheet != nil)
        
        manager.dismissSheet()
        #expect(manager.presentedSheet == nil)
    }
}
