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
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBAction private func doClose(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true)
	}

	@IBAction private func doRegister(_ sender: UIButton) {

		// Here you could register?
        guard let email = emailTextField.text else {
            // throw alert
            return
        }
        
        guard let password = passwordTextField.text else {
            // throw alert
            return
        }
        
        let validator = Validator()
        guard validator.validateEmail(with: email) else {
            // throw alert
            return
        }
        
        guard validator.validatePassword(with: password) else {
            // throw alert
            return
        }

		self.performSegue(withIdentifier: "showHome", sender: nil)
	}
    
    var constraintToChange: NSLayoutConstraint? {
        get {
            return topConstraint
        }
    }
    
    var original_constant: CGFloat?
    
    override func loadView() {
        super.loadView()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboard()
        tap = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
    }
}

extension RegisterController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

extension RegisterController: KeyboardConfigurable, UIGestureRecognizerDelegate {
    @objc
    private func dismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
