//
//  ProjectManager.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/06.
//

import Foundation

final class ProjectManager {
    
    // MARK: - Property
    
    weak var delegate: ProjectManagerDelegate?
    var historyRepository: HistoryRepository? {
        repository?.historyRepository
    }
    
    private let userNotificationHandler = UserNotificationHandler()
    private var repository: ProjectRepository? = ProjectCoreDataRepository()
    
    private (set) var repositoryType: Repository? {
        get {
            return repository?.type
        }
        set
        {
            switch newValue {
            case .coreData:
                repository = ProjectCoreDataRepository()
            case .firestore:
                repository = ProjectFirestoreRepository()
            case .inMemory, .none:
                repository = ProjectInMemoryRepository()
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
        repository?.create(project)
    }
    
    func readProject(
        of identifier: String,
        completion: @escaping (Result<Project?, Error>)
        -> Void)
    {
        repository?.read(of: identifier, completion: completion)
    }
    
    func readProject(
        of status: Status,
        completion: @escaping (Result<[Project]?, Error>)
        -> Void)
    {
        repository?.read(of: status, completion: completion)
    }
    
    func updateProjectContent(
        of project: Project,
        with content: [String: Any])
    {
        var updatingProject = project
        updatingProject.updateContent(with: content)
        repository?.updateContent(of: project, with: updatingProject)
        if let _ = content[ProjectKey.deadline.rawValue],
           let hasUserNotification = content[ProjectKey.hasUserNotification.rawValue] as? Bool,
           hasUserNotification == true {
            modifyUserNotificationDate(of: updatingProject)
        }
    }
    
    func updateProjectStatus(of project: Project, with status: Status) {
        repository?.updateStatus(of: project, with: status)
    }
    
    func delete(_ project: Project) {
        repository?.delete(project)
        removeUserNotification(of: project)
    }
    
    // MARK: - ProjectRepository Configuration Method
    
    func switchProjectRepository(with repository: Repository) {
        repositoryType = repository
        delegate?.projectManager(didChangedRepositoryWith: repository)
    }
    
    // MARK: - UserNotification Method
    
    func registerNewUserNotification(of project: Project) {
        updateProjectContent(
            of: project,
            with: [ProjectKey.hasUserNotification.rawValue: true])
        registerUserNotification(of: project)
    }
    
    func registerUserNotification(of project: Project) {
        guard let identifier = project.identifier,
              let deadline = project.deadline else {
            return
        }
        
        let content = userNotificationContent(project: project)
        let dateComponent = Calendar.current.dateComponents(
            in: .current,
            from: deadline)
        
        userNotificationHandler.requestNotification(
            of: content,
            when: dateComponent,
            identifier: identifier)
    }
    
    private func userNotificationContent(
        project: Project)
    -> UserNotificationContent
    {
        let title = project.title ?? UserNotification.titlePlaceHodler.rawValue
        let body = UserNotification.body.rawValue
        return UserNotificationContent(title: title, body: body)
    }
    
    func removeUserNotification(of project: Project) {
        updateProjectContent(
            of: project,
            with: [ProjectKey.hasUserNotification.rawValue: false])
        guard let identifier = project.identifier else {
            return
        }
        userNotificationHandler.removeNotification(of: identifier)
    }
    
    func modifyUserNotificationDate(of modifiedProject: Project) {
        removeUserNotification(of: modifiedProject)
        registerUserNotification(of: modifiedProject)
    }
    
}
