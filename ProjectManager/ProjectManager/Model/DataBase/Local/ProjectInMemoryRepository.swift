//
//  ProjectInMemoryRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/06.
//

import Foundation

final class ProjectInMemoryRepository {

    // MARK: - Property
    private var projects: [String: Project] = [:]
    private var historyStorage = HistoryStorage()
}

// MARK: - ProjectRepository
extension ProjectInMemoryRepository: ProjectRepository {
    
    var type: Repository {
        get {
            return .inMemory
        }
    }
    
    func create(_ project: Project) {
        guard let identifier = project.identifier else {
            return
        }
        self.projects.updateValue(project, forKey: identifier)
        self.historyStorage.makeHistory(type: .add,
                                        of: identifier,
                                        title: project.title,
                                        status: project.status)
    }
    
    func read(of identifier: String, completion: @escaping (Result<Project?, Error>) -> Void) {
        completion(.success(projects[identifier]))
    }
    
    func read(of group: Status, completion: @escaping (Result<[Project]?, Error>) -> Void) {
        let projects = projects.values.filter { project in project.status == group }
        completion(.success(projects))
    }
    
    func updateContent(of project: Project, with modifiedProject: Project) {
        guard let identifier = project.identifier else {
            return
        }
        
        self.projects.updateValue(modifiedProject, forKey: identifier)
    }
    
    func updateStatus(of project: Project, with status: Status) {
        guard let identifier = project.identifier,
              var updatingProject = projects[identifier] else {
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
   
    func delete(_ project: Project) {
        guard let identifier = project.identifier,
              let deletingProject = projects[identifier] else {
            return
        }
        
        self.projects.removeValue(forKey: identifier)
        
        self.historyStorage.makeHistory(type: .remove,
                                        of: identifier,
                                        title: deletingProject.title,
                                        status: deletingProject.status)
    }
}
