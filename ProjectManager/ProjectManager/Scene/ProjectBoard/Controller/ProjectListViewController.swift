//
//  ProjectListViewController.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/15.
//

import UIKit

final class ProjectListViewController: UIViewController {
    
    // MARK: - DiffableDataSource Identfier
    
    enum Section {
        case main
    }
    
    // MARK: - UI Property
    
    private let headerView = ProjectTableViewHeaderView()
    private let projectTableView = UITableView()
    private let longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    // MARK: - Property
    
    var projectStatus: Status!
    private var dataSource: UITableViewDiffableDataSource<Section,Project>!
    weak var delegate: ProjectListViewControllerDelegate?
    
    // MARK: - Initializer
    
    init(status: Status) {
        self.projectStatus = status
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureTableView()
        self.configureLayout()
        self.setupLongGestureRecognizerOnTableView()
        self.configureDataSource()
        self.updateView()
    }
    
    // MARK: - Configure View
    
    private func configureView() {
        self.view.backgroundColor = ColorPallete.backgroundColor
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureTableView() {
        projectTableView.delegate = self
        projectTableView.backgroundColor = ColorPallete.backgroundColor
        projectTableView.register(cellWithClass: ProjectTableViewCell.self)
        projectTableView.translatesAutoresizingMaskIntoConstraints = false
        projectTableView.separatorStyle = .none
    }
    
    private func configureLayout() {
        self.headerView.setLabelColor(with: self.projectStatus.signatureColor)
        self.view.addSubview(headerView)
        self.view.addSubview(projectTableView)
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 60),
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: projectTableView.topAnchor)])
        
        NSLayoutConstraint.activate([
            projectTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            projectTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            projectTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    // MARK: - Configure Controller
    
    private func setupLongGestureRecognizerOnTableView() {
        self.longPressGestureRecognizer.minimumPressDuration = 0.5
        self.longPressGestureRecognizer.delaysTouchesBegan = true
        
        self.projectTableView.addGestureRecognizer(longPressGestureRecognizer)
        self.longPressGestureRecognizer.addTarget(
            self,
            action: #selector(presentStatusMovePopover)
        )
    }
    
    // MARK: - TableView Method
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Project>(
            tableView: projectTableView
        ) {
            (tableView: UITableView, indexPath: IndexPath, project: Project) -> UITableViewCell? in
            let projectCell = self.projectTableView.dequeueReusableCell(
                withClass: ProjectTableViewCell.self,
                for: indexPath
            )
            let backgroundColor = self.projectStatus.cellBackgroundColor
            projectCell.setBackgroundColor(color: backgroundColor)
            projectCell.updateContent(title: project.title,
                                      description: project.description,
                                      deadline: project.deadline?.localeString(),
                                      with: project.deadlineColor)
            return projectCell
        }
    }
    
    func updateView() {
        applySnapshotToCell()
        updateHeaderView()
    }
    
    func applySnapshotToCell() {
        self.delegate?.readProject(of: self.projectStatus) { [weak self] result in
            switch result {
            case .success(let projects):
                DispatchQueue.main.async {
                    var snapShot = NSDiffableDataSourceSnapshot<Section, Project>()
                    snapShot.appendSections([.main])
                    snapShot.appendItems(projects ?? [], toSection: .main)
                    
                    self?.dataSource.apply(snapShot,
                                           animatingDifferences: true,
                                           completion: nil)
                }
            case .failure(_):
                self?.presentErrorAlert()
            }
        }
    }
    
    func updateHeaderView() {
        self.delegate?.readProject(of: self.projectStatus) {[weak self] result in
            switch result {
            case .success(let projects):
                DispatchQueue.main.async {
                    self?.headerView.configureContent(
                        status: String(describing: self?.projectStatus ?? .todo),
                        projectCount: projects?.count ?? .zero
                    )
                }
            case .failure(_):
                self?.presentErrorAlert()
            }
        }
    }
    
    private func presentErrorAlert() {
        let alert = UIAlertController(
            title: ProjectBoardScene.ErrorAlert.title.rawValue,
            message: nil,
            preferredStyle: .alert)
        let confirmAction = UIAlertAction(
            title: ProjectBoardScene.ErrorAlert.confirm.rawValue,
            style: .default)
        alert.addAction(confirmAction)
        self.present(alert, animated: false)
    }
    
    // MARK: - GestureRecongizer Method
    
    @objc func presentStatusMovePopover() {
        let location = longPressGestureRecognizer.location(in: projectTableView)
        guard let project = longPressedProject(at: location) else {
            return
        }
        
        let actionSheetController = UIAlertController(
            title: ProjectBoardScene.projectStatus.rawValue,
            message: nil,
            preferredStyle: .actionSheet)
        let actions = projectStatusMoveUIAlertActionsForCurrentStatus(
            currentProject: project)
        for action in actions {
            actionSheetController.addAction(action)
        }
        
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.sourceView = self.projectTableView
            popoverController.sourceRect = CGRect(origin: location, size: .zero)
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    private func longPressedProject(at point: CGPoint) -> Project? {
        let CellIndexPath = projectTableView.indexPathForRow(at: point)
        guard let indexPath = CellIndexPath else {
            return nil
        }
        
        return self.dataSource.itemIdentifier(for: indexPath)
    }
    
    private func projectStatusMoveUIAlertActionsForCurrentStatus(
        currentProject: Project
    ) -> [UIAlertAction] {
        let currentStatus = currentProject.status
        switch currentStatus {
        case .todo:
            let firstAction = projectStatusMoveUIAlertAction(
                currentProject: currentProject,
                title: ProjectBoardScene.StatusModification.doing.rawValue,
                targetStatus: .doing,
                viewController: self)
            let secondAction = projectStatusMoveUIAlertAction(
                currentProject: currentProject,
                title: ProjectBoardScene.StatusModification.done.rawValue,
                targetStatus: .done,
                viewController: self)
            return [firstAction, secondAction]
        case .doing:
            let firstAction = projectStatusMoveUIAlertAction(
                currentProject: currentProject,
                title: ProjectBoardScene.StatusModification.todo.rawValue,
                targetStatus: .todo,
                viewController: self)
            let secondAction = projectStatusMoveUIAlertAction(
                currentProject: currentProject,
                title: ProjectBoardScene.StatusModification.done.rawValue,
                targetStatus: .done,
                viewController: self)
            return [firstAction, secondAction]
        case .done:
            let firstAction = projectStatusMoveUIAlertAction(
                currentProject: currentProject,
                title: ProjectBoardScene.StatusModification.todo.rawValue,
                targetStatus: .todo,
                viewController: self)
            let secondAction = projectStatusMoveUIAlertAction(
                currentProject: currentProject,
                title: ProjectBoardScene.StatusModification.doing.rawValue,
                targetStatus: .doing,
                viewController: self)
            return [firstAction, secondAction]
        case .none:
            return []
        }
    }
    
    private func projectStatusMoveUIAlertAction(
        currentProject: Project,
        title: String,
        targetStatus: Status,
        viewController: ProjectListViewController
    ) -> UIAlertAction {
        let action = UIAlertAction(
            title: title,
            style: .default) { [weak viewController] _ in
                viewController?.delegate?.updateProjectStatus(of: currentProject,
                                                              with: targetStatus)
                viewController?.updateView()
            }
        return action
    }
}

// MARK: - UITableViewDelegate

extension ProjectListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedProject = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let detailViewController = ProjectDetailViewController(
            mode: .edit,
            project: selectedProject,
            projectDetailDelegate: self)
        detailViewController.modalPresentationStyle = .formSheet
        
        self.present(detailViewController, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = projectTableView.cellForRow(
            at: indexPath) as? ProjectTableViewCell{
            cell.cellContainerView.backgroundColor = ColorPallete.higlightedCellColor
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = projectTableView.cellForRow(
            at: indexPath) as? ProjectTableViewCell{
            cell.cellContainerView.backgroundColor = self.projectStatus.cellBackgroundColor
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) {  [weak self] _, _, _ in
            guard let project = self?.dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            self?.delegate?.deleteProject(project)
            self?.updateView()
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let actionConfigurations = UISwipeActionsConfiguration(actions: [deleteAction])
        return actionConfigurations
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let project = self.dataSource.itemIdentifier(for: indexPath)
        let cellRect = self.projectTableView.rectForRow(at: indexPath)
        let title = project?.hasUserNotification ?? false ? "🔔" : "🔕"
        
        let notificationConfigurationAction = UIContextualAction(
            style: .normal,
            title: title
        ) {  [weak self] _, _, _ in
            self?.presentNotificationConfigurationAlert(of: project, at: cellRect)
        }
        
        let actionConfigurations = UISwipeActionsConfiguration(
            actions: [notificationConfigurationAction])
        return actionConfigurations
    }
    
    private func presentNotificationConfigurationAlert(
        of project: Project?,
        at cellRect: CGRect) {
        guard let project = project else {
            return
        }
        
        let actionSheet = UIAlertController(
            title: ProjectBoardScene.UserNotificationConfig.title.rawValue,
            message: nil,
            preferredStyle: .actionSheet)
            let notConfiguratoinAction = UIAlertAction(
                title: ProjectBoardScene.UserNotificationConfig.none.rawValue,
                style: .destructive) { [weak self] _ in
            self?.delegate?.removeUserNotification(of: project)
            self?.updateView()
            actionSheet.dismiss(animated: false)
        }
        let configurationAction = UIAlertAction(
            title: ProjectBoardScene.UserNotificationConfig.yes.rawValue,
            style: .default) { [weak self] _ in
            self?.delegate?.registerUserNotification(of: project)
            self?.updateView()
            actionSheet.dismiss(animated: false)
        }
        actionSheet.addAction(notConfiguratoinAction)
        actionSheet.addAction(configurationAction)
        actionSheet.modalPresentationStyle = .popover
        
        let cellHeight = cellRect.height
        let cellWidth = cellRect.width
        let sourceRect = CGRect(origin: cellRect.origin, size: CGSize(width: cellWidth/2, height: cellHeight/2))
        
        if let popoverPresentationController = actionSheet.popoverPresentationController {
            popoverPresentationController.sourceView = self.projectTableView
            popoverPresentationController.sourceRect = sourceRect
            popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection.left
        }
        self.present(actionSheet, animated: false, completion: nil)
    }
    
    func tableView(
        _ tableView: UITableView,
        willBeginEditingRowAt indexPath: IndexPath) {
            if let swipeContainerView = tableView.subviews.first(
                where: { String(describing: type(of: $0)) == "_UITableViewCellSwipeContainerView" }) {
                if let swipeActionPullView = swipeContainerView.subviews.first,
                   String(describing: type(of: swipeActionPullView)) == "UISwipeActionPullView" {
                    swipeActionPullView.frame.size.height -= 10
                    swipeActionPullView.frame = swipeActionPullView.frame.offsetBy(dx: 0, dy: 5)
                }
            }
        }
}

// MARK: - ProjectEditDelegate

extension ProjectListViewController: ProjectEditDelegate {
    func barTitle() -> String {
        return ProjectDetailScene.editTitle.rawValue
    }
    
    func rightBarButtonItem() -> UIBarButtonItem.SystemItem {
        return .done
    }
    
    func leftBarButtonItem() -> UIBarButtonItem.SystemItem {
        return .edit
    }
    
    func didTappedrightBarButtonItem(of project: Project?, projectContent: [String : Any]) {
        guard let project = project else {
            return
        }
        self.delegate?.updateProject(of: project, with: projectContent)
    }
    
}
