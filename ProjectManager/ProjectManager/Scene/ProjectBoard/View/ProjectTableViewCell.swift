//
//  ProjectTableViewCell.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/07.
//

import UIKit

final class ProjectTableViewCell: UITableViewCell {
    
    // MARK: - UI Property
    
    var cellContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.cellBackgroundColor
        view.layer.shadowColor = Design.cellShadowColor
        view.layer.shadowOpacity = Design.cellShadowOpacity
        view.layer.shadowOffset = Design.cellShadowOffset
        view.layer.shadowRadius = Design.cellShadowRadius
        view.layer.cornerRadius = Design.cellCornerRadius
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, descpritionLabel, deadlineLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.setCustomSpacing(Design.titleLabelBottomMargin, after: titleLabel)
        stackView.setCustomSpacing(Design.descriptionLabelBottomMargin, after: descpritionLabel)
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelTextColor
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var descpritionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.descriptionLabelFont
        label.textColor = Design.descriptionLabelTextColor
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var deadlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.deadlineLabelFont
        label.textColor = Design.deadlineLabelTextColor
        label.textAlignment = .left
        return label
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
            cellContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.cellMargin),
            cellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Design.cellMargin),
            stackView.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: Design.cellPadding),
            stackView.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor, constant: -Design.cellPadding),
            stackView.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: Design.cellPadding),
            stackView.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -Design.cellPadding)
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

// MARK: - Design

private enum Design {
    
    // background color
    static let cellBackgroundColor: UIColor? = ColorPallete.projectCellColor
    
    // radius
    static let cellCornerRadius: CGFloat = 7
    
    // shadow
    static let cellShadowColor: CGColor = UIColor.shadowColor.cgColor
    static let cellShadowOpacity: Float = 1
    static let cellShadowOffset: CGSize = CGSize(width: 0, height: 1)
    static let cellShadowRadius: CGFloat = 0.5
    
    // margin, padding
    static let cellMargin: CGFloat = 5
    static let cellPadding: CGFloat = 15
    static let titleLabelBottomMargin: CGFloat = 3
    static let descriptionLabelBottomMargin: CGFloat = 7
    
    // font
    static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .headline)
    static let descriptionLabelFont: UIFont = .preferredFont(forTextStyle: .body)
    static let deadlineLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
    
    // text color
    static let titleLabelTextColor: UIColor = .label
    static let descriptionLabelTextColor: UIColor = .systemGray3
    static let deadlineLabelTextColor: UIColor = .black
   
}
