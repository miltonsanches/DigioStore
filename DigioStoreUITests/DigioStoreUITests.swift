//
//  DigioStoreUITests.swift
//  DigioStoreUITests
//
//  Created by Milton Leslie Sanches on 22/08/24.
//

import XCTest

class DigioStoreUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testLaunchWithHorizontalScroll() throws {
        let scrollView = app.scrollViews.firstMatch
        let firstSpotlightImage = scrollView.images["Recarga"]

        scrollView.scrollToElement(element: firstSpotlightImage)

        let exists = NSPredicate(format: "exists == true")
        //expectation(for: exists, evaluatedWith: firstSpotlightImage, handler: nil)

        //XCTAssertTrue(firstSpotlightImage.exists, "The first spotlight image should be visible on the launch screen after horizontal scrolling.")
    }

}

extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        var lastSnapshot = self.screenshot()
        var currentSnapshot: XCUIScreenshot
        var attempts = 0

        while !element.visible() && attempts < 5 {
            swipeLeft()
            currentSnapshot = self.screenshot()
            
            if currentSnapshot.pngRepresentation == lastSnapshot.pngRepresentation {
                print("No visual change detected after swipe, stopping.")
                break
            }
            
            lastSnapshot = currentSnapshot
            attempts += 1
            print("Swipe attempt \(attempts): Trying to find element.")
        }

        if !element.visible() {
            print("Element not visible after \(attempts) attempts.")
        } else {
            print("Element visible after \(attempts) attempts.")
        }
    }

    func visible() -> Bool {
        guard exists && !frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.intersects(frame)
    }
}
