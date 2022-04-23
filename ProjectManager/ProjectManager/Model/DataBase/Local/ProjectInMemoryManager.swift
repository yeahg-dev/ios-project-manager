//
//  ProjectInMemoryManager.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/06.
//

import Foundation

final class ProjectInMemoryManager {

    // MARK: - Property
    private var projects: [String: Project] = [:]
    private var historyStorage = HistoryStorage()
}

// MARK: - DataSource
extension ProjectInMemoryManager: DataSource {
    
    var type: DataSourceType {
        get {
            return .inMemory
        }
    }
    
    func create(with content: [String: Any]) {
        guard let identifier = content[ProjectKey.identifier.rawValue] as? String else {
            return
        }
        let newProject = Project(identifier: identifier,
                                 title: content[ProjectKey.title.rawValue] as? String,
                                 deadline: content[ProjectKey.deadline.rawValue] as? Date,
                                 description: content[ProjectKey.description.rawValue] as? String,
                                 status: content[ProjectKey.status.rawValue] as? Status)
        self.projects.updateValue(newProject, forKey: identifier)
        self.historyStorage.makeHistory(type: .add,
                                        of: identifier,
                                        title: content[ProjectKey.title.rawValue] as? String,
                                        status: content[ProjectKey.status.rawValue] as? Status)
    }
    
    func read(of identifier: String, completion: @escaping (Result<Project?, Error>) -> Void) {
        completion(.success(projects[identifier]))
    }
    
    func read(of group: Status, completion: @escaping (Result<[Project]?, Error>) -> Void) {
        let projects = projects.values.filter { project in project.status == group }
        completion(.success(projects))
    }
    
    func updateContent(of identifier: String, with content: [String : Any]) {
        guard var updatingProject = projects[identifier] else {
            return
        }
        
        updatingProject.updateContent(with: content)
        self.projects.updateValue(updatingProject, forKey: identifier)
    }
    
    func updateStatus(of identifier: String, with status: Status) {
        guard var updatingProject = projects[identifier] else {
            return
        }
        let currentStatus = updatingProject.status
        
        updatingProject.updateStatus(with: status)
        self.projects.updateValue(updatingProject, forKey: identifier)
        
        self.historyStorage.makeHistory(type: .move(status),
                                        of: identifier,
                                        title: updatingProject.title,
                                        status: currentStatus)
    }
   
    func delete(of identifier: String) {
        guard let deletingProject = projects[identifier] else {
            return
        }
        
        self.projects.removeValue(forKey: identifier)
        
        self.historyStorage.makeHistory(type: .remove,
                                        of: identifier,
                                        title: deletingProject.title,
                                        status: deletingProject.status)
    }
}
