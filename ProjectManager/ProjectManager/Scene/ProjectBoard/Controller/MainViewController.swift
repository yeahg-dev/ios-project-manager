//
//  ProjectManager - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Property
    
    private let projectManager = ProjectManager()
    private let todoViewController = ProjectListViewController(status: .todo)
    private let doingViewController = ProjectListViewController(status: .doing)
    private let doneViewController = ProjectListViewController(status: .done)
    
    // MARK: - UI Property
    
    private var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    private lazy var projectListStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [todoViewController.view,doingViewController.view,
                               doneViewController.view])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = Design.projectListStackViewBackgroundColor
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = Design.projectListStackViewSpacing
        return stackView
    }()
    
    private lazy var bottomBar: UIView = {
        let bottomBar = UIView()
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        return bottomBar
    }()
    
    private lazy var repositorySettingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let cloudImage = UIImage(
            systemName: "cloud.fill",
            withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1))
        button.setImage(cloudImage, for: .normal)
        button.addAction(repository, for: .touchUpInside)
        return button
    }()
    
    private lazy var repository: UIAction = {
        let action = UIAction { [weak self] _ in
            self?.presentRepositoryConfigView()
        }
        return action
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureDelegate()
        self.configureLayout()
        self.configureNavigationItem()
        self.projectManager(
            didChangedRepositoryWith: self.projectManager.repositoryType ?? .coreData)
    }
    
    // MARK: - Configure View
    
    private func configureView() {
        self.view.backgroundColor = Design.backgroundColor
    }
    
    private func configureLayout() {
        self.configureNavigationBarLayout()
        self.configureProjectListStackViewLayout()
        self.configureBottomBarLayout()
        self.configureRepositorySettingButtonLayout()
    }
    
    private func configureNavigationBarLayout() {
        self.view.addSubview(navigationBar)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(
                equalTo: safeArea.topAnchor),
            navigationBar.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor),
            navigationBar.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func configureProjectListStackViewLayout() {
        self.view.addSubview(projectListStackView)
        let safeArea = self.view.safeAreaLayoutGuide
        let tabHeight = self.view.bounds.height * 0.05
        NSLayoutConstraint.activate([
            projectListStackView.topAnchor.constraint(
                equalTo: navigationBar.bottomAnchor),
            projectListStackView.leftAnchor.constraint(
                equalTo: safeArea.leftAnchor),
            projectListStackView.rightAnchor.constraint(
                equalTo: safeArea.rightAnchor),
            projectListStackView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -tabHeight)
        ])
    }
    
    private func configureBottomBarLayout() {
        self.view.addSubview(bottomBar)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.bottomBar.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor),
            self.bottomBar.topAnchor.constraint(
                equalTo: projectListStackView.bottomAnchor),
            self.bottomBar.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor),
            self.bottomBar.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func configureRepositorySettingButtonLayout() {
        self.bottomBar.addSubview(repositorySettingButton)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.repositorySettingButton.centerYAnchor.constraint(
                equalTo: bottomBar.centerYAnchor),
            self.repositorySettingButton.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Design.repositorySettingButtonTrailingMargin)
        ])
    }
    
    private func configureNavigationItem() {
        let navigationItem = UINavigationItem(
            title: ProjectBoardScene.mainTitle.rawValue)
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(presentProjectCreatorViewController))
        addButton.tintColor = Design.addButtonTintColor
        navigationItem.rightBarButtonItem = addButton
        
        let historyButton = UIBarButtonItem(
            title: ProjectBoardScene.historyTitle.rawValue,
            style: .plain,
            target: self,
            action: #selector(presentProjectHistoryViewController))
        historyButton.tintColor = Design.historyButtonTintColor
        navigationItem.leftBarButtonItem = historyButton
        
        navigationBar.items = [navigationItem]
    }
    
    
    // MARK: - Configure Controller
    
    private func configureDelegate() {
        self.todoViewController.delegate = self
        self.doingViewController.delegate = self
        self.doneViewController.delegate = self
        self.projectManager.delegate = self
        self.navigationBar.delegate = self
    }
    
    // MARK: - Method
    
    private func presentRepositoryConfigView() {
        let repositoryConfigAlertVC = RepositotyConfigViewController(
            projectManager: self.projectManager)
        repositoryConfigAlertVC.modalPresentationStyle = .popover
        
        if let popoverPresentationController = repositoryConfigAlertVC.popoverPresentationController {
            popoverPresentationController.sourceView = self.repositorySettingButton
            popoverPresentationController.sourceRect = self.repositorySettingButton.frame(forAlignmentRect: .zero)
        }
        self.present(repositoryConfigAlertVC, animated: false, completion: nil)
    }
    
    private func updateRepositorySettingButton(with color: UIColor?) {
        guard let color = color else {
            return
        }
        let currentImage = self.repositorySettingButton.image(for: .normal)
        let newImage = currentImage?.withTintColor(
            color,
            renderingMode: .alwaysOriginal)
        
        self.repositorySettingButton.setImage(newImage, for: .normal)
    }
    
    private func updateProjectListViews() {
        self.todoViewController.updateView()
        self.doingViewController.updateView()
        self.doneViewController.updateView()
    }
    
    
    // MARK: - @objc Method
    
    @objc func presentProjectCreatorViewController() {
        let creatorViewController = ProjectDetailViewController(
            mode: .creation,
            project: nil,
            projectDetailDelegate: self)
        creatorViewController.modalPresentationStyle = .formSheet
        present(creatorViewController, animated: false, completion: nil)
    }
    
    @objc func presentProjectHistoryViewController() {
        let historyViewController = ProjectHistoryViewController()
        historyViewController.historyRepository = self.projectManager.historyRepository
        
        historyViewController.modalPresentationStyle = .popover
        
        guard let historyButton = self.navigationBar.items?.first?.leftBarButtonItem else {
            return
        }
        
        if let popoverPresentationController = historyViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = historyButton
        }
        self.present(historyViewController, animated: false, completion: nil)
    }
}

// MARK: - UINavigationBarDelegate

extension MainViewController: UINavigationBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

// MARK: - ProjectCreationDelegate

extension MainViewController: ProjectCreationDelegate {
    
    func barTitle() -> String {
        return ProjectDetailScene.creationTtile.rawValue
    }
    
    func rightBarButtonItem() -> UIBarButtonItem.SystemItem {
        return .done
    }
    
    func leftBarButtonItem() -> UIBarButtonItem.SystemItem {
        return .cancel
    }
    
    func didTappedrightBarButtonItem(
        of project: Project?,
        projectContent: [String : Any])
    {
        self.projectManager.create(with: projectContent)
        self.todoViewController.updateView()
    }
    
}

// MARK: - ProjectListViewControllerDelegate

extension MainViewController: ProjectListViewControllerDelegate {
    
    func readProject(
        of status: Status,
        completion: @escaping (Result<[Project]?, Error>)
        -> Void)
    {
        self.projectManager.readProject(of: status, completion: completion)
    }
    
    func updateProjectStatus(of project: Project, with status: Status) {
        self.projectManager.updateProjectStatus(of: project, with: status)
        self.updateProjectListViews()
    }
    
    func updateProject(of project: Project, with content: [String : Any]) {
        self.projectManager.updateProjectContent(of: project, with: content)
        self.updateProjectListViews()
    }
    
    func deleteProject(_ project: Project) {
        self.projectManager.delete(project)
    }
    
    func registerUserNotification(of project: Project) {
        if project.hasUserNotification == false {
            self.projectManager.registerNewUserNotification(of: project)
        }
    }
    
    func removeUserNotification(of project: Project) {
        self.projectManager.removeUserNotification(of: project)
    }
    
}

// MARK: - ProjectManagerDelegate

extension MainViewController: ProjectManagerDelegate {
    
    func projectManager(didChangedRepositoryWith repository: Repository) {
        switch repository {
        case .inMemory:
            self.updateRepositorySettingButton(
                with: Design.inMemoryButtonColor)
        case .coreData:
            self.updateRepositorySettingButton(
                with: Design.coreDataButtonColor)
        case .firestore:
            self.updateRepositorySettingButton(
                with: Design.firestoreButtonColor)
        }
        
        self.updateProjectListViews()
    }
    
}

// MARK: - Design

private enum Design {
    
    // spacing
    static let projectListStackViewSpacing: CGFloat = 7
    
    // margin
    static let repositorySettingButtonTrailingMargin: CGFloat = 10
    
    // color
    static let backgroundColor: UIColor = .systemGray6
    static let projectListStackViewBackgroundColor: UIColor = .systemBackground
    static let addButtonTintColor: UIColor? = ColorPallete.buttonColor
    static let historyButtonTintColor: UIColor? = ColorPallete.buttonColor
    static let inMemoryButtonColor = ColorPallete.inMemoryButtonColor
    static let coreDataButtonColor = ColorPallete.coreDataButtonColor
    static let firestoreButtonColor = ColorPallete.firestoreButtonColor
    
}
