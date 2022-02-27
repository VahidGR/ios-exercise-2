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
    private var loaded1stBatch = false
    func startListening() {
        let collection = db.collection("projects")
        
        let year2020 = projects.generator.createTimestamp(year: 2020)
        let year2019 = projects.generator.createTimestamp(year: 2019)
        let filteredProjects = collection
            .whereField("timestamp", isLessThan: year2020)
            .whereField("timestamp", isGreaterThan: year2019)
            .order(by: "timestamp")

        let observable = collection
            .order(by: "timestamp")
        
        filteredProjects.getDocuments(completion: { snapshot, error in
            handleRequest(snapshot, error)
            observable.addSnapshotListener { snapshot, error in
                    handleRequest(snapshot, error)
            }
            self.loaded1stBatch = true
        })
        
        func handleRequest(_ snapshot: QuerySnapshot?, _ error: Error?) {
            if error == nil {
                snapshot?.documentChanges.forEach { diff in
                    let document = diff.document.data()
                    if (diff.type == .added) {
                        projects.update(insert: document, is1sBatch: !loaded1stBatch)
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.updateUI()
                }
            }
            else {
                self.error = error
            }
        }
    }
    
    class Projects {
        var data: [Project]
        var generator = TimestampGenerator()
        private let createdDate: Date
        
        init(data: [Project] = [])
        {
            self.data = data
            createdDate = Date()
        }
        
        func update(insert document: Project) {
            data.append(document)
        }
        
        func update(insert data: [String: Any]?, is1sBatch: Bool = false) {
            if let document = parse(remote: data) {
                guard let date = document.timestamp?.date else { return }
                if is1sBatch {
                    if date.year == 2019 {
                        update(insert: document)
                    }
                }
                else {
                    let isNewDocument = (date - createdDate) > 0
                    if isNewDocument {
                        update(insert: document)
                    }
                }
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
