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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction private func doClose(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true)
	}

	@IBAction private func doRegister(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let validator = Validator()
        validator.user(email: email, password: password) { [weak self] success in
            if success {
                self?.performSegue(withIdentifier: "showHome", sender: nil)
            } else
            {
                self?.alert(title: "Error", message: "Permission denied", action: "OK")
            }
        }
    }
    
    var constraintToChange: NSLayoutConstraint? {
        get {
            return bottomConstraint
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
