//
//  ProjectTableViewCell.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/07.
//

import UIKit

final class ProjectTableViewCell: UITableViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var descpritionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray2
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var deadlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, descpritionLabel, deadlineLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.setCustomSpacing(3, after: titleLabel)
        stackView.setCustomSpacing(7, after: descpritionLabel)
        return stackView
    }()
    
    var cellContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "projectCellColor")
        view.layer.shadowColor = UIColor.shadowColor.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 0.5
        view.layer.cornerRadius = 7
        return view
    }()
    
    // MARK: - Intiailizerr
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureCellUI()
        self.configureLayout()
    }
    
    // MARK: - Configure View
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard #available(iOS 13, *) else { return }

        guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else { return }
        self.cellContainerView.layer.shadowColor = UIColor.shadowColor.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.textColor = .label
    }
    
    private func configureCellUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    private func configureLayout() {
        self.contentView.addSubview(cellContainerView)
        self.cellContainerView.addSubview(stackView)
    
        NSLayoutConstraint.activate([
            cellContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        let margin = CGFloat(15)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: margin),
            stackView.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor, constant: -margin),
            stackView.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: margin),
            stackView.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -margin)
        ])
    }
    
    // MARK: - API
    
    func updateContent(title: String?,
                       description: String?,
                       deadline: String?,
                       with DeadlineTextColor: UIColor) {
        self.titleLabel.text = title
        self.descpritionLabel.text = description
        self.deadlineLabel.textColor = DeadlineTextColor
        self.deadlineLabel.text = deadline
    }
    
    func setBackgroundColor(color: UIColor?) {
        self.cellContainerView.backgroundColor = color
    }
   
}
