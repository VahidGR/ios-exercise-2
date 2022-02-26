//
//  UIViewController+Alert.swift
//  Exercise
//
//  Created by Vahid Ghanbarpour on 2/26/22.
//  Copyright © 2022 Matthias Nagel. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String, message: String, action: String, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .cancel) { _ in
            completion?()
        })
        present(alert, animated: true){}
    }
}
