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
        
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText("vahid@gmail.com")
        
        let passwordField = app.secureTextFields["password"]
        passwordField.tap()
        passwordField.typeText("ABSuuhwu881")
        
        app.buttons.matching(identifier: "register-2").firstMatch.tap()
		app.buttons["plus"].tap()

        app.alerts["New project"].textFields.matching(identifier: "new-element").firstMatch.typeText("new")
		app.alerts["New project"].buttons["Save"].tap()
	}
}
