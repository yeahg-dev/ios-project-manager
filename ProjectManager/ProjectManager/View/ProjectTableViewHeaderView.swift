//
//  ProjectTableViewHeaderView.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/08.
//

import UIKit

class ProjectTableViewHeaderView: UITableViewHeaderFooterView {

    // MARK: - UIProperty
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        return label
    }()
    
    // TODO: - 동그라미 레이블로 수정
    private let projectCountLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = label.bounds.size.width * 0.5
        label.backgroundColor = .black
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializer
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(statusLabel)
        self.contentView.addSubview(projectCountLabel)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Layout
    private func configureLayout() {
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            statusLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            statusLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate([
            projectCountLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 7),
            projectCountLabel.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor)
        ])
    }
    
    // MARK: - API
    func configureContent(status: String?, projectCount: String? ) {
        self.statusLabel.text = status
        self.projectCountLabel.text = projectCount
    }
}