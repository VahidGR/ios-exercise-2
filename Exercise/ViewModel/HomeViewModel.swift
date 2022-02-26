//
//  HomeViewModel.swift
//  Exercise
//
//  Created by Vahid Ghanbarpour on 2/26/22.
//  Copyright © 2022 Matthias Nagel. All rights reserved.
//

import Firebase

class HomeViewModel {
    // controller
    var delegate: Controller?
    
    private let firestore = Firestore.firestore()
    var projects = [[String: Any]]()
    // error message
    private var message: String? {
        didSet {
            guard let message = message else { return }
            delegate?.showError(message: message)
        }
    }
    
    // MARK: - Load projects
    func loadProjects() {
        
        self.projects.removeAll()
//        let year2020 = TimestampGenerator.createTimestamp(year: 2020)
//        let year2019 = TimestampGenerator.createTimestamp(year: 2019)
        firestore.collection("projects")
//            .whereField("timestamp", isLessThan: year2020)
//            .whereField("timestamp", isGreaterThan: year2019)
            .getDocuments { [weak self] snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    for document in (snapshot.documents) {
                        self?.projects.append(document.data())
                    }
                    
                    DispatchQueue.main.async {
                        self?.delegate?.updateUI()
                    }
                    self?.startListening()
                } else {
                    self?.message = "Invalid snapshot"
                }
            }
            else {
                self?.message = error?.localizedDescription
            }
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
        
        firestore.collection("projects").addDocument(data: data)
    }

    // MARK: - Listen to changes
    private func startListening() {
        firestore.collection("projects").addSnapshotListener { [weak self] snapshot, error in
            if error == nil {
                snapshot?.documentChanges.forEach { diff in
                    let document = diff.document.data()
                    if (diff.type == .added) {
                        if let _ = self?.projects.firstIndex(where: { $0["id"] as? String == document["id"] as? String }) { } else {
                            self?.projects.append(document)
                        }
                    }
                    if (diff.type == .modified) {
                        if let index = self?.projects.firstIndex(where: { $0["id"] as? String == document["id"] as? String }) {
                            self?.projects[index] = document
                        }
                    }
                    if (diff.type == .removed) {
                        if let index = self?.projects.firstIndex(where: { $0["id"] as? String == document["id"] as? String }) {
                            self?.projects.remove(at: index)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self?.delegate?.updateUI()
                }
            }
            else {
                self?.message = error?.localizedDescription
            }
        }
    }

}
