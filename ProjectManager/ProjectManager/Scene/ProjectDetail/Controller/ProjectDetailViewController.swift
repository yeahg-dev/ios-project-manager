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
    
    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = .preferredFont(forTextStyle: .body, compatibleWith: nil)
        textField.textColor = .label
        textField.placeholder = "Title"
        textField.layer.shadowColor = UIColor.shadowColor.cgColor
        textField.layer.shadowOffset = CGSize(width: 3, height: 3)
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowRadius = 3
        return textField
    }()
    
    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        var preferredLanguage = Locale.preferredLanguages.first
        let currentRegionIdentifier: Substring? = NSLocale.current.identifier.split(separator: "_").last
        if let languageCode = preferredLanguage, let regionCode = currentRegionIdentifier {
            let deviceLocaleIdentifier = "\(languageCode)_\(regionCode)"
            datePicker.locale = Locale(identifier: deviceLocaleIdentifier)
            return datePicker
        }
        return datePicker
    }()
    
    private var descriptionTextViewContainer: UIView = {
        let view = UIView(frame: .zero)
        view.layer.shadowColor = UIColor.shadowColor.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        return view
    }()
    
    private var descriptionTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = ColorPallete.backgroundColor
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .label
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.layer.masksToBounds = true
        textView.autocorrectionType = .no
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:
                                        [titleTextField, datePicker, descriptionTextViewContainer])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var projectContent: [String: Any]{
        var content: [String: Any] = [:]
        switch self.mode {
        case .creation:
            content.updateValue(UUID().uuidString as Any, forKey: ProjectKey.identifier.rawValue)
            content.updateValue(Status.todo, forKey: ProjectKey.status.rawValue)
        default:
            content.updateValue(self.project?.status as Any, forKey: ProjectKey.status.rawValue)
        }
        content.updateValue(UUID().uuidString as Any, forKey: ProjectKey.identifier.rawValue)
        content.updateValue(titleTextField.text as Any, forKey: ProjectKey.title.rawValue)
        content.updateValue(datePicker.date as Any, forKey: ProjectKey.deadline.rawValue)
        content.updateValue(descriptionTextView.text as Any, forKey: ProjectKey.description.rawValue)
        return content
    }
    
    // MARK: - Initializer
    
    init(mode: Mode,
         project: Project?,
         projectDetailDelegate: ProjectDetailDelegate?) {
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
        self.configureLayout()
        self.configureNavigationItems()
        self.configureMode()
        self.descriptionTextView.delegate = self
        self.titleTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotificationObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotificationObserver()
    }

    // MARK: - Configure View
    private func configureLayout() {
        self.configureView()
        self.configureNavigationBarLayout()
        self.configureStackViewLayout()
    }
    
    private func configureView() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBarLayout() {
        self.view.addSubview(navigationBar)
        navigationBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func configureStackViewLayout() {
        self.descriptionTextViewContainer.addSubview(descriptionTextView)
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([titleTextField.heightAnchor.constraint(equalToConstant: 45)])
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: descriptionTextViewContainer.topAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: descriptionTextViewContainer.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionTextViewContainer.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: descriptionTextViewContainer.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            descriptionTextViewContainer.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            descriptionTextViewContainer.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15)
        ])
    }
    
    private func configureNavigationItems() {
        let navigationItem = UINavigationItem()
        guard let rightBarButtonItem = self.projectDetailDelegate?.rightBarButtonItem(),
              let leftBarButtonItem = self.projectDetailDelegate?.leftBarButtonItem(),
              let title = self.projectDetailDelegate?.barTitle() else {
            return
        }
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: rightBarButtonItem,
                                             target: self,
                                             action: #selector(didTappedRightBarButton))
        rightBarButton.tintColor = ColorPallete.buttonColor
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: leftBarButtonItem,
                                            target: self,
                                            action: #selector(didTappedLefttBarButton))
        leftBarButton.tintColor = ColorPallete.buttonColor
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.title = title
        
        self.navigationBar.items = [navigationItem]
    }
    
    @objc func didTappedRightBarButton() {
        self.projectDetailDelegate?.didTappedrightBarButtonItem(
            of: project,
            projectContent: self.projectContent)
        self.dismiss(animated: false)
    }
    
    @objc func didTappedLefttBarButton() {
        switch self.mode {
        case .edit:
            self.enableEdit()
        default:
            self.dismiss(animated: false)
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard #available(iOS 13, *) else { return }

        guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else { return }
        titleTextField.layer.shadowColor = UIColor.shadowColor.cgColor
        descriptionTextView.layer.shadowColor = UIColor.shadowColor.cgColor
    }
    
    // MARK: - Configure Mode
    
    private func configureMode() {
        switch mode {
        case .creation:
            break
        case .edit:
            self.configureContentWithProject()
            self.toggleEditMode()
        default:
            return
        }
    }
    
    // MARK: - Edit mode Method
    
    private func configureContentWithProject() {
        guard self.project != nil else {
            return
        }
        self.titleTextField.text = self.project?.title
        self.datePicker.date = self.project?.deadline ?? Date()
        self.descriptionTextView.text = self.project?.description
    }
    
    private func enableEdit() {
        toggleEditMode()
        titleTextField.becomeFirstResponder()
    }
    
    private func toggleEditMode() {
        self.titleTextField.isEnabled.toggle()
        self.datePicker.isEnabled.toggle()
        self.descriptionTextView.isEditable.toggle()
    }
    
   
    // MARK: - Keyboard Method
    
    private func addKeyboardNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardNotificationObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        self.boundsOriginWillIncreaseByKeyboardHeight(sender)
    }
    
    private func boundsOriginWillIncreaseByKeyboardHeight(_ sender: Notification) {
        if descriptionTextView.isFirstResponder {
            if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.bounds.origin.y += keyboardHeight * 0.5
            }
        }
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        self.boundsOriginWillReturnToZero()
    }
    
    private func boundsOriginWillReturnToZero() {
        self.view.bounds.origin = .zero
    }

}

// MARK: - UITextViewDelegate

extension ProjectDetailViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
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
        self.titleTextField.resignFirstResponder()
        return true
    }
}
