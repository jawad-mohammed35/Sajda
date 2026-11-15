//
//  SajdaUITests.swift
//  SajdaUITests
//
//  Created by Aliyya Nazhifah on 28/08/25.
//

import XCTest

final class SajdaUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSunriseAppearsBetweenFajrAndDhuhrWithoutMuteControl() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = [
            "-showOnboardingAtLaunch", "YES", "-isUsingManualLocation", "NO",
            "-useCustomTimetable", "NO", "-isNotificationsEnabled", "NO",
            "-selectedLanguage", "en", "-showSunnahPrayers", "NO",
            "-accessibilityUppercaseText", "NO"
        ]
        app.launch()
        let manualLocation = app.buttons["Or, Set Location Manually"]
        XCTAssertTrue(manualLocation.waitForExistence(timeout: 10))
        manualLocation.click()
        let search = app.textFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.click()
        search.typeText("40.7128, -74.0060")
        let coordinate = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Custom Coordinate")).firstMatch
        XCTAssertTrue(coordinate.waitForExistence(timeout: 10))
        coordinate.click()
        app.buttons["Done"].click()
        let statusItem = app.descendants(matching: .statusItem).firstMatch
        XCTAssertTrue(statusItem.waitForExistence(timeout: 10))
        statusItem.click()
        let sunrise = app.staticTexts["Sunrise"]
        let hasSunrise = sunrise.waitForExistence(timeout: 10)
        if !hasSunrise { print("Timetable windows: \(app.windows.debugDescription)") }
        XCTAssertTrue(hasSunrise)
        let fajr = app.staticTexts["Fajr"]
        let dhuhr = app.staticTexts["Dhuhr"]
        XCTAssertLessThan(fajr.frame.midY, sunrise.frame.midY)
        XCTAssertLessThan(sunrise.frame.midY, dhuhr.frame.midY)
        for prayer in ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"] {
            XCTAssertTrue(app.staticTexts[prayer].exists)
        }
        XCTAssertEqual(app.buttons.matching(NSPredicate(format: "label == %@ OR label == %@", "Mute Adhan", "Unmute Adhan")).count, 5)
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Sunrise timetable"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
