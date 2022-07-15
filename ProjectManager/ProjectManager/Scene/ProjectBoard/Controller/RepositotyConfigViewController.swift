//
//  RepositotyConfigViewController.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/22.
//

import UIKit
import CoreData

final class RepositotyConfigViewController: UIViewController {
    
    // MARK: - Property
    weak var projectManager: ProjectManager?
    let repositoryTypes: [Repository] = [.inMemory, .coreData, .firestore]
    
    // MARK: - UIProperty
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.text = RepositoryConfigScene.title.rawValue
        return label
    }()
    
    private lazy var sourceSegmentedControl: UISegmentedControl = {
        let dataSourceTypeDescriptions = repositoryTypes.map { dataSource in
            return dataSource.userDescription
        }
        let segmentedControl = UISegmentedControl(items: dataSourceTypeDescriptions)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = ColorPallete.buttonColor
        segmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .selected
        )
        let action = UIAction { UIAction in
            self.switchDataSource()
        }
        segmentedControl.addAction(action, for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, sourceSegmentedControl])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - Initializer
    init(model: ProjectManager) {
        self.projectManager = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureViewHeirachry()
        self.configureContent()
        self.configureLayout()
    }
    
    // MARK: - Method
    private func configureView() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .systemBackground
        self.preferredContentSize = CGSize(width: 300, height: 150)
    }
    
    private func configureViewHeirachry() {
        self.view.addSubview(contentStackView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            contentStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
        ])
    }

    private func configureContent() {
        guard let currentSourceType = projectManager?.repositoryType,
              let index = repositoryTypes.firstIndex(of: currentSourceType) else {
                  return
              }
        self.sourceSegmentedControl.selectedSegmentIndex = index
    }
    
    private func switchDataSource() {
        let selectedIndex = self.sourceSegmentedControl.selectedSegmentIndex
        self.projectManager?.switchProjectSource(with: repositoryTypes[selectedIndex])
    }
}
