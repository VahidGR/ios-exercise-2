//
//  RegisterController.swift
//  Exercise
//
//  Created by Matthias Nagel on 03.07.19.
//  Copyright © 2020 myCraftnote Digital GmbH. All rights reserved.
//

import UIKit
import Firebase

final class RegisterController: UIViewController {

	@IBOutlet private weak var emailTextField: UITextField!
	@IBOutlet private weak var passwordTextField: UITextField!

	@IBAction private func doClose(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true)
	}

	@IBAction private func doRegister(_ sender: UIButton) {

		// Here you could register?

		self.performSegue(withIdentifier: "showHome", sender: nil)
	}
}

