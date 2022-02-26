//
//  HomeController.swift
//  Exercise
//
//  Created by Matthias Nagel on 03.07.19.
//  Copyright © 2020 myCraftnote Digital GmbH. All rights reserved.
//

import UIKit
import Firebase

final class HomeController: UIViewController, Controller {

	@IBOutlet private weak var tableView: UITableView!

    private var projects: [Project] {
        get {
            return viewModel.projects
        }
        set {
            viewModel.projects = newValue
        }
    }
    private let viewModel = HomeViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.delegate = self
        viewModel.loadProjects()
	}

	@IBAction private func createRandomProject(_ sender: UIBarButtonItem) {
        let title = UUID().uuidString
        viewModel.writeProject(title)
	}

	@IBAction private func doAdd(_ sender: Any) {
		let alert = UIAlertController(title: "New project", message: "Enter a project title", preferredStyle: .alert)
		alert.addTextField { textField in
			textField.keyboardType = .alphabet
            textField.accessibilityIdentifier = "new-element"
		}

		let action = UIAlertAction(title: "Save", style: .default) { action in
			if let text = alert.textFields?.first?.text {
                self.viewModel.writeProject(text)
			}
		}
		alert.addAction(action)

		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(cancel)

		present(alert, animated: true, completion: nil)
	}
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projects.count
    }
    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        let dict = self.projects[indexPath.row]
        
        cell.title = dict.title
        cell.date = dict.timestamp

		return cell
	}
}

extension HomeController {
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showError(message: String) {
        alert(title: "Error", message: message, action: "OK")
    }
}
