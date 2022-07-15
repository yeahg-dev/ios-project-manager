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
        static let projects = "projects"
    }
    
    // MARK: - Property
    private let db = Firestore.firestore()
    
    // MARK: - Method
    func readAll(completion: @escaping (Result<[[String: Any]?], FirestoreError>) -> Void) {
        db.collection(FirestorePath.projects).getDocuments() { (querySnapshot, err) in
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
  
}

// MARK: - ProjectRepository
extension ProjectFirestoreRepository: ProjectRepository {
    
    var type: Repository {
        get {
            return .firestore
        }
    }
    
    var historyRepository: HistoryRepository {
        return HistoryFirestoreRepository()
    }
    
    // MARK: - Method
    func create(_ project: Project) {
        guard let identifier = project.identifier,
              let deadline = project.deadline else {
            return
        }
        var dict = project.jsonObjectToDictionary(of: project)
        dict.updateValue(Timestamp(date: deadline), forKey: ProjectKey.deadline.rawValue)
        
        db.collection(FirestorePath.projects).document(identifier).setData(dict) { [weak self] err in
            if let err = err {
                print("☠️Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self?.historyRepository.createHistory(type: OperationType.add,
                                                 of: identifier,
                                                 title: project.title,
                                                 status: project.status)
            }
        }
    }
    
    func read(of identifier: String, completion: @escaping (Result<Project?, Error>) -> Void) {
        let docRef = db.collection(FirestorePath.projects).document(identifier)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let dict = document.data() {
                    guard let project = ProjectDTO(dict: dict).toDomain() else {
                        completion(.failure(FirestoreError.invalidDeadline))
                        return
                    }

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
        db.collection(FirestorePath.projects).whereField(ProjectKey.status.rawValue, isEqualTo: group.rawValue)
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
                        guard let project = ProjectDTO(dict: dict).toDomain() else {
                            return nil
                        }
                        
                        return project
                    }
                    completion(.success(projects))
                }
            }
    }
    
    func updateContent(of project: Project, with modifiedProject: Project) {
        guard let identifier = modifiedProject.identifier else {
            return
        }
        
        guard let projectEntity = modifiedProject.toDTO()?.toEntity() else {
            print("entity transform failed")
            return
        }
        let projectRef = db.collection(FirestorePath.projects).document(identifier)
    
        projectRef.updateData(projectEntity) { err in
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
        let projectRef = db.collection(FirestorePath.projects).document(identifier)
        
        var updatingContent: [String: Any] = [:]
        updatingContent.updateValue(status.rawValue, forKey: ProjectKey.status.rawValue)
        
        projectRef.updateData(updatingContent) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.historyRepository.createHistory(type: OperationType.move(status),
                                                 of: identifier,
                                                 title: project.title,
                                                 status: project.status)
            }
        }
    }
    
    func delete(_ project: Project) {
        guard let identifier = project.identifier else {
            return
        }
        
        self.db.collection(FirestorePath.projects).document(identifier).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.historyRepository.createHistory(type: .remove,
                                                 of: identifier,
                                                 title: project.title,
                                                 status: project.status)
            }
        }
    }
    
}
