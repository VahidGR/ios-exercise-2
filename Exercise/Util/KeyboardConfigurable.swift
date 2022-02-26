//
//  KeyboardConfigurable.swift
//  Exercise
//
//  Created by Vahid Ghanbarpour on 2/26/22.
//  Copyright © 2022 Matthias Nagel. All rights reserved.
//

import UIKit

protocol KeyboardConfigurable: AnyObject {
    var constraintToChange: NSLayoutConstraint? { get }
    var original_constant: CGFloat? { get set }
    func configureKeyboard()
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide(notification: NSNotification)
}

extension KeyboardConfigurable where Self: UIViewController {
    var tap: UITapGestureRecognizer! {
        get {
            let tap = view.gestureRecognizers?.filter({$0.name == "cancel_keyboard"}).last as? UITapGestureRecognizer
            return tap
        }
        set {
            newValue.delegate = self as? UIGestureRecognizerDelegate
            newValue.name = "cancel_keyboard"
            self.view.addGestureRecognizer(newValue)
        }
    }
    
    var addedTap: Bool? {
        get {
            return tap?.isEnabled ?? false
        }
        set {
            tap?.isEnabled = newValue ?? false
        }
    }
    
    func addTap() {
        if addedTap == false {
            addedTap = true
        }
    }
    
    private func removeTap() {
        if addedTap == true {
            addedTap = false
        }
    }
    
    func configureKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [self] notification in
            keyboardWillShow(notification: notification as NSNotification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [self] notification in
            keyboardWillHide(notification: notification as NSNotification)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        addTap()
        
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

        let keyboardHeight = keyboardSize?.height
        
        if original_constant == nil {
            original_constant = constraintToChange?.constant
        }

        constraintToChange?.constant = keyboardHeight! + 20
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
   }
    
    func keyboardWillHide(notification: NSNotification) {
        removeTap()
        
        constraintToChange?.constant = original_constant ?? 0
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}
