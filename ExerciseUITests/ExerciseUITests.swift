//
//  ExerciseUITests.swift
//  ExerciseUITests
//
//  Created by Matthias Nagel on 03.07.19.
//  Copyright © 2020 myCraftnote Digital GmbH. All rights reserved.
//

import XCTest

class ExerciseUITests: XCTestCase {

	override func setUp() {
		continueAfterFailure = false

		XCUIApplication().launch()
	}

	func testAddNewProject() {
		let app = XCUIApplication()
		let registerButton = app.buttons["Register"]
		registerButton.tap()
		registerButton.tap()
		app.buttons["plus"].tap()

		let nKey = app/*@START_MENU_TOKEN@*/.keys["n"]/*[[".keyboards.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		nKey.tap()
		nKey.tap()

		let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		eKey.tap()
		eKey.tap()

		let wKey = app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		wKey.tap()
		wKey.tap()
		app.alerts["New project"].buttons["Save"].tap()
	}
}
