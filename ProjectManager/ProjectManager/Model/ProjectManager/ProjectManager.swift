//
//  ProjectManager.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/06.
//

import Foundation

final class ProjectManager {
    
    // MARK: - Property
    
    private let userNotificationHandler = UserNotificationHandler()
    weak var delegate: ProjectManagerDelegate?
   
    private var repository: ProjectRepository? = ProjectCoreDataRepository()
    var historyRepository: HistoryRepository? {
        return repository?.historyRepository
    }
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
    
    // MARK: - CRUD Method
    
    func create(with content: [String: Any]) {
        let project = Project(
            identifier: content[ProjectKey.identifier.rawValue] as? String,
            title: content[ProjectKey.title.rawValue] as? String,
            deadline: content[ProjectKey.deadline.rawValue] as? Date,
            description: content[ProjectKey.description.rawValue] as? String,
            status: content[ProjectKey.status.rawValue] as? Status,
            hasUserNotification: false)
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
        if let _ = content[ProjectKey.deadline.rawValue],
           let hasUserNotification = content[ProjectKey.hasUserNotification.rawValue] as? Bool,
            hasUserNotification == true {
            self.modifyUserNotificationDate(of: updatingProject)
        }
    }
    
    func updateProjectStatus(of project: Project, with status: Status) {
        self.repository?.updateStatus(of: project, with: status)
    }
    
    func delete(_ project: Project) {
        self.repository?.delete(project)
        self.removeUserNotification(of: project)
    }
    
    // MARK: - ProjectRepository Config Method
    
    func switchProjectRepository(with repository: Repository) {
        self.repositoryType = repository
        self.delegate?.projectManager(didChangedRepositoryWith: repository)
    }
    
    // MARK: - UserNotification Method
    
    func registerNewUserNotification(of project: Project) {
        self.updateProjectContent(of: project, with: [ProjectKey.hasUserNotification.rawValue: true])
        self.registerUserNotification(of: project)
    }
    
    func registerUserNotification(of project: Project) {
        guard let identifier = project.identifier,
              let deadline = project.deadline else {
            return
        }
        
        let content = userNotificationContent(project: project)
        let dateComponent = Calendar.current.dateComponents(in: .current,
                                                            from: deadline)

        self.userNotificationHandler.requestNotification(of: content,
                                                         when: dateComponent,
                                                         identifier: identifier)
    }
    
    private func userNotificationContent(project: Project) -> UserNotificationContent {
        let title = project.title ?? UserNotification.titlePlaceHodler.rawValue
        let body = UserNotification.body.rawValue
        return UserNotificationContent(title: title, body: body)
    }
    
    func removeUserNotification(of project: Project) {
        self.updateProjectContent(of: project, with: [ProjectKey.hasUserNotification.rawValue: false])
        guard let identifier = project.identifier else {
            return 
        }
        self.userNotificationHandler.removeNotification(of: identifier)
    }
    
    func modifyUserNotificationDate(of modifiedProject: Project) {
        self.removeUserNotification(of: modifiedProject)
        self.registerUserNotification(of: modifiedProject)
    }

}
