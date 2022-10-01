//
//  RepositotyConfigViewController.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/22.
//

import CoreData
import UIKit

final class RepositotyConfigViewController: UIViewController {
    
    // MARK: - Property
    
    weak var projectManager: ProjectManager?
    let repositoryTypes: [Repository] = [.inMemory, .coreData, .firestore]
    
    // MARK: - UI Property
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, repositorySegmentedControl])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.titleLabelFont
        label.text = RepositoryConfigScene.title.rawValue
        return label
    }()
    
    private lazy var repositorySegmentedControl: UISegmentedControl = {
        let dataSourceTypeDescriptions = repositoryTypes.map { dataSource in
            return dataSource.userDescription
        }
        let segmentedControl = UISegmentedControl(items: dataSourceTypeDescriptions)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = Design.selectedSegmentTintColor
        segmentedControl.setTitleTextAttributes(
            [.foregroundColor: Design.segmentedControlTitleColor],
            for: .selected
        )
        let action = UIAction { UIAction in
            self.switchDataSource()
        }
        segmentedControl.addAction(action, for: .valueChanged)
        return segmentedControl
    }()
    
    // MARK: - Initializer
    
    init(projectManager: ProjectManager) {
        self.projectManager = projectManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureLayout()
        self.configureContent()
    }
    
    // MARK: - Configure UI
    
    private func configureView() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = Design.backgroundColor
        self.preferredContentSize = CGSize(width: Design.width, height: Design.height)
    }
    
    private func configureLayout() {
        self.view.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(
                equalTo: self.view.topAnchor,
                constant: Design.topPadding),
            contentStackView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor),
            contentStackView.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor,
                constant: -Design.bottomPadding)
        ])
    }
    
    private func configureContent() {
        guard let currentSourceType = projectManager?.repositoryType,
              let index = repositoryTypes.firstIndex(of: currentSourceType) else {
            return
        }
        
        self.repositorySegmentedControl.selectedSegmentIndex = index
    }
    
    private func switchDataSource() {
        let selectedIndex = self.repositorySegmentedControl.selectedSegmentIndex
        self.projectManager?.switchProjectRepository(with: repositoryTypes[selectedIndex])
    }
}

// MARK: - Design

private enum Design {
    
    // padding
    static let topPadding: CGFloat = 30
    static let bottomPadding: CGFloat = 30
    
    // size
    static let width: CGFloat = 300
    static let height: CGFloat = 150
    
    // font
    static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    // color
    static let backgroundColor: UIColor = .systemBackground
    static let selectedSegmentTintColor = ColorPallete.buttonColor
    static let segmentedControlTitleColor: UIColor = .white
    
}
