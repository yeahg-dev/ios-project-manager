//
//  DataSourceConfigViewController.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/22.
//

import UIKit
import CoreData

class DataSourceConfigViewController: UIViewController {
    
    // MARK: - Property
    weak var projectManager: ProjectManager?
    
    // MARK: - UIProperty
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.text = DataSourceConfigScene.title.rawValue
        return label
    }()
    
    private lazy var sourceSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [DataSourceConfigScene.inMemory.rawValue,
                                                          DataSourceConfigScene.coredata.rawValue,
                                                          DataSourceConfigScene.firestore.rawValue])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = .black
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
    override func loadView() {
        self.view = .init()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .white
        self.view.isOpaque = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewHeirachry()
        self.configureContent()
        self.configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferredContentSize = self.view.systemLayoutSizeFitting(
            UIView.layoutFittingExpandedSize
        )
    }
    
    // MARK: - Method
    private func configureViewHeirachry() {
        self.view.addSubview(contentStackView)
    }
    
    private func configureLayout() {
        // FIXME: - 제약 충돌 해결
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            contentStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10),
            self.view.heightAnchor.constraint(equalToConstant: 150),
            self.view.widthAnchor.constraint(equalToConstant: 300)
           
        ])
    }

    private func configureContent() {
        self.sourceSegmentedControl.selectedSegmentIndex = projectManager?.projectSourceType?.rawValue ?? .zero
    }
    
    private func switchDataSource() {
        let selectedIndex = self.sourceSegmentedControl.selectedSegmentIndex
        self.projectManager?.switchProjectSource(with: DataSourceType(rawValue:selectedIndex) ?? .coreData)
    }
}