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
        self.repository?.create(with: content)
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
    
    func updateProjectContent(of identifier: String, with content: [String: Any]) {
        self.repository?.updateContent(of: identifier, with: content)
    }
    
    func updateProjectStatus(of identifier: String, with status: Status) {
        self.repository?.updateStatus(of: identifier, with: status)
    }
    
    func delete(of identifier: String) {
        self.repository?.delete(of: identifier)
    }
    
    func switchProjectSource(with repository: Repository) {
        self.repositoryType = repository
        self.delegate?.projectManager(didChangedRepositoryWith: repository)
    }
}
