import Testing
import UIKit
@testable import SwiftUIDrawer

@Suite("DrawerPositionCalculatorTests")
struct DrawerPositionCalculatorTests {
    static let dragHandleHeight = 12.0
    static let expectedPositionAssociatedValue: CGFloat = 33.0
    
    let screenBoundsProvider = ScreenBoundsProvidingMock()
    let safeAreaInsetsProvider = SafeAreaInsetsProvidingMock()
    let tabBarFrameProvider = TabBarFrameProvidingMock()

    var screenBounds: CGRect { screenBoundsProvider.bounds }
    var safeAreaInsets: UIEdgeInsets { safeAreaInsetsProvider.insets }
    var tabBarFrame: CGRect { tabBarFrameProvider.frame }
    
    var subject: DrawerPositionCalculator {
        .init(
            screenBoundsProvider: screenBoundsProvider,
            safeAreaInsetsProvider: safeAreaInsetsProvider,
            tabBarFrameProvider: tabBarFrameProvider,
            dragHandleHeight: Self.dragHandleHeight
        )
    }
    
    @Test(
        "Test returned `paddingTop` CGFloat value for a given `DrawerState`",
        arguments: [
            DrawerState(case: .dragging),
            .init(case: .closed),
            .init(case: .partiallyOpened),
            .init(case: .fullyOpened)
        ]
    )
    func testPaddingTop(for drawerState: DrawerState) {
        let paddingTop = subject.paddingTop(for: drawerState)
        #expect(paddingTop == screenBounds.height - drawerState.currentPosition)
    }
    
    @Test(
        "Test returned `contentBottomPadding` CGFloat value for a given `DrawerState` and `DrawerBottomPosition",
        arguments: ContentBottomPaddingTestArguments.allCombinations
    )
    func contentBottomPadding(arguments: ContentBottomPaddingTestArguments) {
        let state = arguments.drawerState
        let position = arguments.bottomPosition
        let subject = subject
        
        let contentBottomPadding = subject.contentBottomPadding(
            for: state,
            bottomPosition: position
        )
        
        switch state.case {
        case .fullyOpened:
            let sum = subject.paddingTop(for: state) + safeAreaInsets.bottom
            
            if position.isAlignedToTabBar {
                #expect(contentBottomPadding == sum + tabBarFrame.height)
            } else {
                #expect(contentBottomPadding == sum)
            }
        default:
            #expect(contentBottomPadding == 0)
        }
    }
    
    @Test(
        "Test returned absolute CGFloat value for a given `DrawerBottomPosition` cases",
        arguments: [
            DrawerBottomPosition.absolute(expectedPositionAssociatedValue),
            .relativeToSafeAreaBottom(offset: expectedPositionAssociatedValue),
            .relativeToTabBar(offset: expectedPositionAssociatedValue),
            .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight: expectedPositionAssociatedValue),
            .matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight: expectedPositionAssociatedValue)
        ]
    )
    func testAbsoluteValueForBottomPosition(bottomPosition: DrawerBottomPosition) {
        let absoluteValue = subject.absoluteValue(for: bottomPosition)
        
        switch bottomPosition {
        case .absolute(let cGFloat):
            let sum = CGFloat(cGFloat + Self.dragHandleHeight)
            
            #expect(absoluteValue == sum)
        case .relativeToSafeAreaBottom(let offset):
            let sum = CGFloat(safeAreaInsets.bottom + offset + Self.dragHandleHeight)
            
            #expect(absoluteValue == sum)
        case .relativeToTabBar(let offset):
            let sum = CGFloat(safeAreaInsets.bottom + tabBarFrame.height + offset + Self.dragHandleHeight)
            
            #expect(absoluteValue == sum)
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(let stickyHeaderHeight):
            let sum = CGFloat(safeAreaInsets.bottom + stickyHeaderHeight + Self.dragHandleHeight)
            
            #expect(absoluteValue == sum)
        case .matchesStickyHeaderContentHeightAlignedToTabBar(let stickyHeaderHeight):
            let sum = CGFloat(safeAreaInsets.bottom + tabBarFrame.height + stickyHeaderHeight + Self.dragHandleHeight)
            
            #expect(absoluteValue == sum)
        }
    }
    
    @Test(
        "Test returned absolute CGFloat value for a given `DrawerMidPosition` cases",
        arguments: [
            DrawerMidPosition.absolute(Self.expectedPositionAssociatedValue),
            .relativeToSafeAreaBottom(offset: Self.expectedPositionAssociatedValue),
            .relativeToTabBar(offset: Self.expectedPositionAssociatedValue)
        ]
    )
    func testAbsoluteValueForMidPosition(midPosition: DrawerMidPosition) {
        let absoluteValue = subject.absoluteValue(for: midPosition)
    
        switch midPosition {
        case .absolute(let cGFloat):
            #expect(absoluteValue == cGFloat)
        case .relativeToSafeAreaBottom(let offset):
            let sum = CGFloat(safeAreaInsets.bottom + offset + Self.dragHandleHeight)
            
            #expect(absoluteValue == sum)
        case .relativeToTabBar(let offset):
            let sum = CGFloat(safeAreaInsets.bottom + tabBarFrame.height + offset + Self.dragHandleHeight)
            
            #expect(absoluteValue == sum)
        }
    }
    
    @Test(
        "Test returned absolute CGFloat value for a given `DrawerTopPosition` cases",
        arguments: [
            DrawerTopPosition.absolute(Self.expectedPositionAssociatedValue),
            .relativeToSafeAreaTop(offset: Self.expectedPositionAssociatedValue)
        ]
    )
    func testAbsoluteValueForTopPosition(topPosition: DrawerTopPosition) {
        let absoluteValue = subject.absoluteValue(for: topPosition)
    
        switch topPosition {
        case .absolute(let cGFloat):
            #expect(absoluteValue == cGFloat)
        case .relativeToSafeAreaTop(let offset):
            let sum = CGFloat(screenBounds.height - safeAreaInsets.top - offset)
            
            #expect(absoluteValue == sum)
        }
    }
}

// MARK: - Test utils

struct ContentBottomPaddingTestArguments {
    static let expectedPositionAssociatedValue: CGFloat = 33.0
    
    let drawerState: DrawerState
    let bottomPosition: DrawerBottomPosition
    
    static var allCombinations: [ContentBottomPaddingTestArguments] {
        DrawerState.Case.allCases.flatMap {
            [
                .init(
                    drawerState: .init(case: $0),
                    bottomPosition: .absolute(Self.expectedPositionAssociatedValue)
                ),
                .init(
                    drawerState: .init(case: $0),
                    bottomPosition: .relativeToSafeAreaBottom(offset: Self.expectedPositionAssociatedValue)
                ),
                .init(
                    drawerState: .init(case: $0),
                    bottomPosition: .relativeToTabBar(offset: Self.expectedPositionAssociatedValue)
                ),
                .init(
                    drawerState: .init(case: $0),
                    bottomPosition: .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight: Self.expectedPositionAssociatedValue)
                ),
                .init(
                    drawerState: .init(case: $0),
                    bottomPosition: .matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight: Self.expectedPositionAssociatedValue)
                )
            ]
        }
    }
}
