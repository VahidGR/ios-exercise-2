//
//  HomeController.swift
//  Exercise
//
//  Created by Matthias Nagel on 03.07.19.
//  Copyright © 2020 myCraftnote Digital GmbH. All rights reserved.
//

import UIKit
import Firebase

final class HomeController: UIViewController {

	@IBOutlet private weak var tableView: UITableView!

	private let firestore = Firestore.firestore()
	private var projects = [[String: Any]]()

	override func viewDidLoad() {
		super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
		self.loadProjects()
	}

	@IBAction private func createRandomProject(_ sender: UIBarButtonItem) {
        writeProject(UUID().uuidString)
	}

	@IBAction private func doAdd(_ sender: Any) {
		let alert = UIAlertController(title: "New project", message: "Enter a project title", preferredStyle: .alert)
		alert.addTextField { textField in
			textField.keyboardType = .alphabet
		}

		let action = UIAlertAction(title: "Save", style: .default) { action in
			if let text = alert.textFields?.first?.text {
				self.writeProject(text)
			}
		}
		alert.addAction(action)

		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(cancel)

		present(alert, animated: true, completion: nil)
	}
}

extension HomeController {

	private func loadProjects() {

		self.projects.removeAll()
        let year2020 = TimestampGenerator.createTimestamp(year: 2020)
        let year2019 = TimestampGenerator.createTimestamp(year: 2019)
            firestore.collection("projects")
            .whereField("timestamp", isLessThan: year2020)
            .whereField("timestamp", isGreaterThan: year2019)
            .getDocuments { [weak self] snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    for document in (snapshot.documents) {
                        self?.projects.append(document.data())
                    }
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                } else {
                    self?.alert(title: "Error", message: "Invalid snapshot", action: "OK")
                }
            }
            else {
                self?.alert(title: "Error", message: error!.localizedDescription, action: "OK")
            }
        }
	}

	private func writeProject(_ title: String) {

		let projectId = UUID().uuidString
		let data: [String: Any] = [
            "id": projectId,
			"title": title,
			"timestamp": Timestamp(date: Date())
		]

		// Here you could save the project into Firestore
        firestore.collection("projects").addDocument(data: data)
        loadProjects()
	}
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projects.count
    }
    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		cell.textLabel?.text = self.projects[indexPath.row]["title"] as? String

		return cell
	}
}
