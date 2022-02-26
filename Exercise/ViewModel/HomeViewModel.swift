//
//  HomeViewModel.swift
//  Exercise
//
//  Created by Vahid Ghanbarpour on 2/26/22.
//  Copyright © 2022 Matthias Nagel. All rights reserved.
//

import Foundation
import Combine
import Firebase

class HomeViewModel {
    // controller
    var delegate: Controller?
    
    private let db = Firestore.firestore()
    var projects = Projects()
    // error message
    private var error: Error? {
        didSet {
            guard let message = error?.localizedDescription else { return }
            delegate?.showError(message: message)
        }
    }
    
    // MARK: - Write project
    func writeProject(_ title: String) {
        let projectId = UUID().uuidString
        let data: [String: Any] = [
            "id": projectId,
            "title": title,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("projects").addDocument(data: data)
    }

    // MARK: - Listen to changes
    func startListening() {
        db.collection("projects").addSnapshotListener { [weak self] snapshot, error in
            if error == nil {
                snapshot?.documentChanges.forEach { diff in
                    let document = diff.document.data()
                    if (diff.type == .added) {
                        self?.projects.update(insert: document)
                    }
                }
                DispatchQueue.main.async {
                    self?.delegate?.updateUI()
                }
            }
            else {
                self?.error = error
            }
        }
    }
    
    class Projects {
        var data: [Project]
        var generator = TimestampGenerator()
        
        init(data: [Project] = [])
        {
            self.data = data
        }
        
        func update(insert document: Project) {
            data.append(document)
        }
        
        func update(insert data: [String: Any]?) {
            if let document = parse(remote: data) {
                update(insert: document)
            }
        }
        
        private func parse(remote: [String: Any]?) -> Project? {
            let id = remote?["id"] as? String
            let title = remote?["title"] as? String
            let timestamp = remote?["timestamp"] as? Timestamp
            
            return Project(id: id, title: title, timestamp: timestamp?.formattedTime)
        }
    }

}
