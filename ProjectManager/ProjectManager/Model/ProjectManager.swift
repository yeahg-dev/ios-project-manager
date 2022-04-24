//
//  ProjectManager.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/06.
//

import Foundation

// MARK: - Repository 
enum Repository {
    
    case inMemory
    case coreData
    case firestore
    
    var userDescription: String {
        switch self {
        case .inMemory:
            return "휘발성"
        case .coreData:
            return "앱"
        case .firestore:
            return "Cloud"
        }
    }
}

// MARK: - NetworkStatus
enum NetworkStatus {
    
    case online
    case offline
    
}

// MARK: - ProjectManagerDelegate
protocol ProjectManagerDelegate: AnyObject {
    
    func projectManager(didChangedRepositoryWith repositoryType: Repository)
    
    func projectManager(didChangedNetworkStatusWith status: NetworkStatus)
}

// MARK: - ProjectManager
final class ProjectManager {
    
    // MARK: - Property
    weak var delegate: ProjectManagerDelegate?
    private var repository: ProjectRepository? = ProjectCoreDataRepository()
    private (set) var repositoryType: Repository? {
        get {
            return self.repository?.type
        }
        set
        {
            switch newValue {
            case .coreData:
                self.repository = ProjectCoreDataRepository()
            case .firestore:
                self.repository = ProjectFirestoreRepository()
            case .inMemory, .none:
                self.repository = ProjectInMemoryRepository()
            }
        }
    }
    
    // MARK: - Method
    func create(with content: [String: Any]) {
        let project = Project(
            identifier: content[ProjectKey.identifier.rawValue] as? String,
            title: content[ProjectKey.title.rawValue] as? String,
            deadline: content[ProjectKey.deadline.rawValue] as? Date,
            description: content[ProjectKey.description.rawValue] as? String,
            status: content[ProjectKey.status.rawValue] as? Status)
        self.repository?.create(project)
    }
    
    func readProject(
        of identifier: String,
        completion: @escaping (Result<Project?, Error>
        ) -> Void) {
        self.repository?.read(of: identifier, completion: completion)
    }
    
    func readProject(
        of status: Status,
        completion: @escaping (Result<[Project]?, Error>
    ) -> Void)  {
        self.repository?.read(of: status, completion: completion)
    }
    
    func updateProjectContent(of project: Project, with content: [String: Any]) {
        var updatingProject = project
        updatingProject.updateContent(with: content)
        self.repository?.updateContent(of: project, with: updatingProject)
    }
    
    func updateProjectStatus(of project: Project, with status: Status) {
        self.repository?.updateStatus(of: project, with: status)
    }
    
    func delete(_ project: Project) {
        self.repository?.delete(project)
    }
    
    func switchProjectSource(with repository: Repository) {
        self.repositoryType = repository
        self.delegate?.projectManager(didChangedRepositoryWith: repository)
    }
}
