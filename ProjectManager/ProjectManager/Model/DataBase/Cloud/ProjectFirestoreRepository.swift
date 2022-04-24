//
//  ProjectFirestoreRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/18.
//

import Foundation
import Firebase

enum FirestoreError: Error {
    
    case readFail
    case invalidDeadline
}

final class ProjectFirestoreRepository {
    
    // MARK: - FirestorePath Namespace
    struct FirestorePath {
        static let collection = "projects"
    }
    
    // MARK: - Property
    private let db = Firestore.firestore()
     private var historyStorage = HistoryFirestoreRepository()
    
    // MARK: - Method
    func readAll(completion: @escaping (Result<[[String: Any]?], FirestoreError>) -> Void) {
        db.collection(FirestorePath.collection).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(.failure(.readFail))
            } else {
                var datas: [[String: Any]] = []
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    datas.append(document.data())
                }
                completion(.success(datas))
            }
        }
    }
    
    private func formatProjectToJSONDict(with dict: [String: Any]) -> [String: Any] {
        let project = Project(identifier: dict[ProjectKey.identifier.rawValue] as? String,
                              title: dict[ProjectKey.title.rawValue] as? String,
                              deadline: dict[ProjectKey.deadline.rawValue] as? Date,
                              description: dict[ProjectKey.description.rawValue] as? String,
                              status: dict[ProjectKey.status.rawValue] as? Status)
        
        let dict = project.jsonObjectToDictionary(of: project)
        return dict
    }
}

// MARK: - ProjectRepository
extension ProjectFirestoreRepository: ProjectRepository {
    
    var type: Repository {
        get {
            return .firestore
        }
    }
    
    // MARK: - Method
    func create(_ project: Project) {
        // TODO: - mapping하는 객체 만들기
        guard let identifier = project.identifier,
              let deadline = project.deadline else {
            return
        }
        var dict = project.jsonObjectToDictionary(of: project)
        dict.updateValue(Timestamp(date: deadline), forKey: ProjectKey.deadline.rawValue)
        
        db.collection(FirestorePath.collection).document(identifier).setData(dict) { [weak self] err in
            if let err = err {
                print("☠️Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self?.historyStorage.createHistory(type: OperationType.add,
                                                 of: identifier,
                                                 title: project.title,
                                                 status: project.status)
            }
        }
    }
    
    func read(of identifier: String, completion: @escaping (Result<Project?, Error>) -> Void) {
        let docRef = db.collection(FirestorePath.collection).document(identifier)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let dict = document.data() {
                    guard let deadline = dict[ProjectKey.deadline.rawValue] as? Timestamp else {
                        completion(.failure(FirestoreError.invalidDeadline))
                        return
                    }
                    
                    let deadlineDate = Date(timeIntervalSince1970: TimeInterval(deadline.seconds))
                    let project = Project(identifier: dict[ProjectKey.identifier.rawValue] as? String,
                                          title: dict[ProjectKey.title.rawValue] as? String,
                                          deadline: deadlineDate,
                                          description: dict[ProjectKey.description.rawValue] as? String,
                                          status: dict[ProjectKey.status.rawValue] as? Status)
                    completion(.success(project))
                }
            } else if let err = error {
                print("☠️\(err.localizedDescription)")
                print("Document does not exist")
                completion(.failure(FirestoreError.readFail))
            }
        }
    }
    
    func read(of group: Status, completion: @escaping (Result<[Project]?, Error>) -> Void) {
        db.collection(FirestorePath.collection).whereField(ProjectKey.status.rawValue, isEqualTo: group.rawValue)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("☠️Error getting documents: \(err)")
                    completion(.failure(FirestoreError.readFail))
                } else {
                    var dicts: [[String: Any]] = []
                    for document in querySnapshot!.documents {
                        dicts.append(document.data())
                    }
                    let projects = dicts.compactMap { (dict: [String: Any]) -> Project? in
                        guard let deadline = dict[ProjectKey.deadline.rawValue] as? Timestamp,
                              let status = dict[ProjectKey.status.rawValue] as? String else {
                            completion(.failure(FirestoreError.invalidDeadline))
                            return nil
                        }
                        
                        let deadlineDate = Date(timeIntervalSince1970: TimeInterval(deadline.seconds))
                        return Project(identifier: dict[ProjectKey.identifier.rawValue] as? String,
                                       title: dict[ProjectKey.title.rawValue] as? String,
                                       deadline: deadlineDate,
                                       description: dict[ProjectKey.description.rawValue] as? String,
                                       status: Status(rawValue: status))
                    }
                    completion(.success(projects))
                }
            }
    }
    
    func updateContent(of project: Project, with modifiedProject: Project) {
        guard let identifier = project.identifier,
              let deadlineDate = modifiedProject.deadline,
              let status = modifiedProject.status else {
            return
        }
        let projectRef = db.collection(FirestorePath.collection).document(identifier)
        
        var updatingContent = modifiedProject.jsonObjectToDictionary(of: project)
        updatingContent.updateValue(Timestamp(date: deadlineDate), forKey: ProjectKey.deadline.rawValue)
        updatingContent.updateValue(status.rawValue, forKey: ProjectKey.status.rawValue)
        
        projectRef.updateData(updatingContent) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updateStatus(of project: Project, with status: Status) {
        guard let identifier = project.identifier else {
            return
        }
        let projectRef = db.collection(FirestorePath.collection).document(identifier)
        
        var updatingContent: [String: Any] = [:]
        updatingContent.updateValue(status.rawValue, forKey: ProjectKey.status.rawValue)
        
        projectRef.updateData(updatingContent) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func delete(_ project: Project) {
        guard let identifier = project.identifier else {
            return
        }
        
        self.db.collection(FirestorePath.collection).document(identifier).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.historyStorage.createHistory(type: .remove,
                                                 of: identifier,
                                                 title: project.title,
                                                 status: project.status)
            }
        }
    }
    
}
