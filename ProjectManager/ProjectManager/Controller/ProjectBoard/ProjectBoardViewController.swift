//
//  ProjectManager - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

// MARK: - ProjectBoardViewController
final class ProjectBoardViewController: UIViewController {
    
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
    
    private lazy var tableStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [todoViewController.view,
                                                       doingViewController.view,
                                                       doneViewController.view])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemGray4
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 7
        return stackView
    }()
    
    private lazy var repositorySettingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let cloudImage = UIImage(systemName: "cloud.fill",
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
        self.configureSubviews()
        self.configureNavigationItem()
        self.configureNavigationBarLayout()
        self.configureTableStackViewLayout()
        self.configureRepositorySettingButtonLayout()
        self.projectManager(didChangedRepositoryWith: self.projectManager.repositoryType ?? .coreData)
    }
     
    // MARK: - Configure View
    private func configureView() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .systemGray6
    }
    
    private func configureSubviews() {
        self.view.addSubview(navigationBar)
        self.view.addSubview(tableStackView)
        self.view.addSubview(repositorySettingButton)
    }
    
    private func configureNavigationItem() {
        let navigationItem = UINavigationItem(title: ProjectBoardScene.mainTitle.rawValue)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(presentProjectCreatorViewController))
        navigationItem.rightBarButtonItem = addButton
        
        let historyButton = UIBarButtonItem(title: "History",
                                            style: .plain,
                                            target: self,
                                            action: #selector(presentProjectHistoryViewController))
        navigationItem.leftBarButtonItem = historyButton
        
        navigationBar.items = [navigationItem]
    }
    
    private func configureNavigationBarLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        navigationBar.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    private func configureTableStackViewLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        let tabHeight = self.view.bounds.height * 0.05
        NSLayoutConstraint.activate([
            tableStackView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableStackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            tableStackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            tableStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -tabHeight)
        ])
    }
    
    private func configureRepositorySettingButtonLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        let tabHeiht = self.view.bounds.height * 0.05
        let margin = tabHeiht * 0.4
        NSLayoutConstraint.activate([
            repositorySettingButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            repositorySettingButton.topAnchor.constraint(equalTo: tableStackView.bottomAnchor, constant: margin)])
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
    private func updateRepositorySettingButton(with color: UIColor) {
        let currentImage = self.repositorySettingButton.image(for: .normal)
        let newImage =  currentImage?.withTintColor(color, renderingMode: .alwaysOriginal)

        self.repositorySettingButton.setImage(newImage, for: .normal)
    }
    
    private func presentRepositoryConfigView() {
        let repositoryConfigAlertVC = RepositotyConfigViewController(model: self.projectManager)
        repositoryConfigAlertVC.modalPresentationStyle = .popover
        
        if let popoverPresentationController = repositoryConfigAlertVC.popoverPresentationController {
            popoverPresentationController.sourceView = self.repositorySettingButton
            popoverPresentationController.sourceRect = self.repositorySettingButton.frame(forAlignmentRect: .zero)
        }
        self.present(repositoryConfigAlertVC, animated: false, completion: nil)
    }
    
    // MARK: - @objc Method
    @objc func presentProjectCreatorViewController() {
        let creatorViewController = ProjectViewController(mode: .creation,
                                                          project: nil,
                                                          projectCreationDelegate: self,
                                                          projectEditDelegate: nil)
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
extension ProjectBoardViewController: UINavigationBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

// MARK: - ProjectCreationViewControllerDelegate
extension ProjectBoardViewController: ProjectCreationDelegate {
    
    func createProject(with content: [String : Any]) {
        self.projectManager.create(with: content)
        self.todoViewController.updateView()
    }

}

// MARK: - ProjectListViewControllerDelegate
extension ProjectBoardViewController: ProjectListViewControllerDelegate {
    
    func readProject(of status: Status, completion: @escaping (Result<[Project]?, Error>) -> Void) {
        self.projectManager.readProject(of: status, completion: completion)
    }
    
    func updateProjectStatus(of project: Project, with status: Status) {
        self.projectManager.updateProjectStatus(of: project, with: status)
        self.todoViewController.updateView()
        self.doingViewController.updateView()
        self.doneViewController.updateView()
    }
    
    func updateProject(of project: Project, with content: [String : Any]) {
        self.projectManager.updateProjectContent(of: project, with: content)
        self.todoViewController.updateView()
        self.doingViewController.updateView()
        self.doneViewController.updateView()
    }
    
    func deleteProject(_ project: Project) {
        self.projectManager.delete(project)
    }
}

// MARK: - ProjectManagerDelegate
extension ProjectBoardViewController: ProjectManagerDelegate {
    
    func projectManager(didChangedRepositoryWith repository: Repository) {
        switch repository {
        case .inMemory:
            self.updateRepositorySettingButton(with: .gray)
        case .coreData:
            self.updateRepositorySettingButton(with: .gray)
        case .firestore:
            self.updateRepositorySettingButton(with: .blue)
        }
        self.todoViewController.updateView()
        self.doingViewController.updateView()
        self.doneViewController.updateView()
    }
    
    func projectManager(didChangedNetworkStatusWith with: NetworkStatus) {
        // TODO: - 네트워크 상태 변화에 따른 버튼 이미지 변경
    }
    
}
