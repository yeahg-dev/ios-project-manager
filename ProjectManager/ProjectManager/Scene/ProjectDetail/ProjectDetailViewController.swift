//
//  ProjectDetailViewController.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/15.
//

import UIKit

final class ProjectDetailViewController: UIViewController {
    
    // MARK: - Mode
    
    enum Mode {
        case creation
        case edit
    }
    
    // MARK: - Property
    
    var mode: Mode?
    var project: Project?
    weak var projectDetailDelegate: ProjectDetailDelegate?
    
    // MARK: - UI Property
    
    private var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [titleTextField, datePicker,
                               descriptionTextViewContainer])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Design.titleTextFieldColor
        textField.font = Design.titleTextFieldFont
        textField.textColor = Design.titleTextFieldTextColor
        textField.placeholder = "Title"
        textField.layer.shadowColor = Design.titleTextFieldShadowColor
        textField.layer.shadowOffset = CGSize(width: 3, height: 3)
        textField.layer.shadowOpacity = Design.titleTextFieldShadowOpacity
        textField.layer.shadowRadius = Design.titleTextFieldShadowRadius
        return textField
    }()
    
    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        var preferredLanguage = Locale.preferredLanguages.first
        let currentRegionIdentifier: Substring? = NSLocale.current.identifier.split(
            separator: "_").last
        if let languageCode = preferredLanguage, let regionCode = currentRegionIdentifier {
            let deviceLocaleIdentifier = "\(languageCode)_\(regionCode)"
            datePicker.locale = Locale(identifier: deviceLocaleIdentifier)
            return datePicker
        }
        return datePicker
    }()
    
    private var descriptionTextViewContainer: UIView = {
        let view = UIView(frame: .zero)
        view.layer.shadowColor = Design.descriptionTextViewShadowColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = Design.descriptionTextViewShadowOpacity
        view.layer.shadowRadius = Design.descriptionTextViewShadowRadius
        view.layer.masksToBounds = false
        return view
    }()
    
    private var descriptionTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Design.descriptionTextViewColor
        textView.font = Design.descriptionTextViewFont
        textView.textColor = Design.descriptionTextViewTextColor
        textView.textContainerInset = UIEdgeInsets(
            top: 8,
            left: 8,
            bottom: 8,
            right: 8)
        textView.layer.masksToBounds = true
        textView.autocorrectionType = .no
        return textView
    }()
    
    var projectContent: [String: Any]{
        var content: [String: Any] = [:]
        switch mode {
        case .creation:
            content.updateValue(
                UUID().uuidString as Any,
                forKey: ProjectKey.identifier.rawValue)
            content.updateValue(
                Status.todo,
                forKey: ProjectKey.status.rawValue)
        default:
            content.updateValue(
                project?.status as Any,
                forKey: ProjectKey.status.rawValue)
        }
        content.updateValue(
            UUID().uuidString as Any,
            forKey: ProjectKey.identifier.rawValue)
        content.updateValue(
            titleTextField.text as Any,
            forKey: ProjectKey.title.rawValue)
        content.updateValue(
            datePicker.date as Any,
            forKey: ProjectKey.deadline.rawValue)
        content.updateValue(
            descriptionTextView.text as Any,
            forKey: ProjectKey.description.rawValue)
        return content
    }
    
    // MARK: - Initializer
    
    init(
        mode: Mode,
        project: Project?,
        projectDetailDelegate: ProjectDetailDelegate?)
    {
        self.mode = mode
        self.project = project
        self.projectDetailDelegate = projectDetailDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureNavigationItems()
        configureMode()
        descriptionTextView.delegate = self
        titleTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotificationObserver()
    }
    
    // MARK: - Configure View
    
    private func configureLayout() {
        configureView()
        configureNavigationBarLayout()
        configureStackViewLayout()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBarLayout() {
        view.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(
                equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(
                equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureStackViewLayout() {
        descriptionTextViewContainer.addSubview(descriptionTextView)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            titleTextField.heightAnchor.constraint(
                equalToConstant: Design.titleTextFieldHeight),
            descriptionTextView.topAnchor.constraint(
                equalTo: descriptionTextViewContainer.topAnchor),
            descriptionTextView.bottomAnchor.constraint(
                equalTo: descriptionTextViewContainer.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(
                equalTo: descriptionTextViewContainer.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: descriptionTextViewContainer.trailingAnchor),
            descriptionTextViewContainer.topAnchor.constraint(
                equalTo: datePicker.bottomAnchor),
            descriptionTextViewContainer.bottomAnchor.constraint(
                equalTo: stackView.bottomAnchor),
            stackView.topAnchor.constraint(
                equalTo: navigationBar.bottomAnchor,
                constant: Design.topPadding),
            stackView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -Design.bottomPadding),
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Design.leadingPadding),
            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Design.trailingPadding)
        ])
    }
    
    private func configureNavigationItems() {
        let navigationItem = UINavigationItem()
        guard let rightBarButtonItem = projectDetailDelegate?.rightBarButtonItem(),
              let leftBarButtonItem = projectDetailDelegate?.leftBarButtonItem(),
              let title = projectDetailDelegate?.barTitle() else {
            return
        }
        
        let rightBarButton = UIBarButtonItem(
            barButtonSystemItem: rightBarButtonItem,
            target: self,
            action: #selector(didTappedRightBarButton))
        rightBarButton.tintColor = Design.leftBarButtonTintColor
        let leftBarButton = UIBarButtonItem(
            barButtonSystemItem: leftBarButtonItem,
            target: self,
            action: #selector(didTappedLefttBarButton))
        leftBarButton.tintColor = Design.rightBarButtonTintColor
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.title = title
        
        navigationBar.items = [navigationItem]
    }
    
    @objc func didTappedRightBarButton() {
        projectDetailDelegate?.didTappedrightBarButtonItem(
            of: project,
            projectContent: self.projectContent)
        dismiss(animated: false)
    }
    
    @objc func didTappedLefttBarButton() {
        switch self.mode {
        case .edit:
            self.enableEdit()
        default:
            dismiss(animated: false)
        }
    }
    
    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?)
    {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard #available(iOS 13, *) else { return }
        
        guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else { return }
        titleTextField.layer.shadowColor = Design.titleTextFieldShadowColor
        descriptionTextView.layer.shadowColor = Design.descriptionTextViewShadowColor
    }
    
    // MARK: - Configure Mode
    
    private func configureMode() {
        switch mode {
        case .creation:
            break
        case .edit:
            configureContentWithProject()
            toggleEditMode()
        default:
            return
        }
    }
    
    // MARK: - Edit mode Method
    
    private func configureContentWithProject() {
        guard self.project != nil else {
            return
        }
        titleTextField.text = project?.title
        datePicker.date = project?.deadline ?? Date()
        descriptionTextView.text = project?.description
    }
    
    private func enableEdit() {
        toggleEditMode()
        titleTextField.becomeFirstResponder()
    }
    
    private func toggleEditMode() {
        titleTextField.isEnabled.toggle()
        datePicker.isEnabled.toggle()
        descriptionTextView.isEditable.toggle()
    }
    
    
    // MARK: - Keyboard Method
    
    private func addKeyboardNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func removeKeyboardNotificationObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        boundsOriginWillIncreaseByKeyboardHeight(sender)
    }
    
    private func boundsOriginWillIncreaseByKeyboardHeight(_ sender: Notification) {
        if descriptionTextView.isFirstResponder {
            if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                view.bounds.origin.y += keyboardHeight * 0.5
            }
        }
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        boundsOriginWillReturnToZero()
    }
    
    private func boundsOriginWillReturnToZero() {
        view.bounds.origin = .zero
    }
    
}

// MARK: - UITextViewDelegate

extension ProjectDetailViewController: UITextViewDelegate {
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String)
    -> Bool
    {
        let limitedCharacterCount = 1000
        let currentText = textView.text ?? ""
        
        guard let rangeToUpdate = Range(range, in: currentText) else {
            return false
        }
        
        let changedText = currentText.replacingCharacters(in: rangeToUpdate, with: text)
        
        return changedText.count <= limitedCharacterCount
    }
    
}

// MARK: - UITextFieldDelegate

extension ProjectDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}

// MARK: - Design

private enum Design {
    
    // size
    static let titleTextFieldHeight: CGFloat = 45
    static let topPadding: CGFloat = 15
    static let bottomPadding: CGFloat = 15
    static let leadingPadding: CGFloat = 15
    static let trailingPadding: CGFloat = 15
    
    // color
    static let titleTextFieldColor: UIColor = .systemBackground
    static let titleTextFieldTextColor: UIColor = .label
    static let descriptionTextViewColor = ColorPallete.backgroundColor
    static let descriptionTextViewTextColor: UIColor = .label
    static let rightBarButtonTintColor = ColorPallete.buttonColor
    static let leftBarButtonTintColor = ColorPallete.buttonColor
    
    // font
    static let titleTextFieldFont: UIFont = .preferredFont(forTextStyle: .body, compatibleWith: nil)
    static let descriptionTextViewFont: UIFont = .preferredFont(forTextStyle: .body)
    
    // shadow
    static let titleTextFieldShadowColor = UIColor.shadowColor.cgColor
    static let titleTextFieldShadowOpacity: Float = 0.3
    static let titleTextFieldShadowRadius: CGFloat = 3
    static let descriptionTextViewShadowColor = UIColor.shadowColor.cgColor
    static let descriptionTextViewShadowOpacity: Float = 0.3
    static let descriptionTextViewShadowRadius: CGFloat = 3
    
}
