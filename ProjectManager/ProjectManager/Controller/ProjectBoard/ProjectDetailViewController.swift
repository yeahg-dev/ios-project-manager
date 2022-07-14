//
//  ProjectDetailViewController.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/15.
//

import UIKit

// MARK: - ProjectCreationDelegate
protocol ProjectCreationDelegate: AnyObject {
    
    func createProject(with content: [String: Any])
}

// MARK: - ProjectEditDelegate
protocol ProjectEditDelegate: AnyObject {
    
    func updateProject(of project: Project, with content: [String: Any])
}

// MARK: - ProjectDetailViewController
final class ProjectDetailViewController: UIViewController {
    
    // MARK: - Mode
    enum Mode {
        case creation
        case edit
    }
    
    // MARK: - Property
    var mode: Mode?
    var project: Project?
    weak var projectCreationDelegate: ProjectCreationDelegate?
    weak var projectEditDelegate: ProjectEditDelegate?
    
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
    
    // MARK: - Initializer
    init(mode: Mode,
         project: Project?,
         projectCreationDelegate: ProjectCreationDelegate?,
         projectEditDelegate: ProjectEditDelegate?) {
        self.mode = mode
        self.project = project
        self.projectCreationDelegate = projectCreationDelegate
        self.projectEditDelegate = projectEditDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureNavigationBarLayout()
        self.configureStackViewLayout()
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
    private func configureView() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBarLayout() {
        self.view.addSubview(navigationBar)
        let safeArea = self.view.safeAreaLayoutGuide
        navigationBar.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    private func configureStackViewLayout() {
        self.descriptionTextViewContainer.addSubview(descriptionTextView)
        self.view.addSubview(stackView)
        let safeArea = self.view.safeAreaLayoutGuide
        
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
            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15)
        ])
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
            self.configureNavigationItemWhenCreationMode()
        case .edit:
            self.configureNavigationItemWhenEditMode()
            self.configureContentWithProject()
            self.toggleEditMode()
        default:
            return
        }
    }
    
    private func configureNavigationItemWhenCreationMode() {
        let navigationItem = UINavigationItem()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(dismissWithCreation))
        doneButton.tintColor = ColorPallete.buttonColor
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(dismissWithoutCreation))
        cancelButton.tintColor = ColorPallete.buttonColor
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationBar.items = [navigationItem]
    }
    
    private func configureNavigationItemWhenEditMode() {
        let navigationItem = UINavigationItem()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(dismissWithUpdate))
        doneButton.tintColor = ColorPallete.buttonColor
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                           target: self,
                                           action: #selector(enableEdit))
        editButton.tintColor = ColorPallete.buttonColor
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = editButton
        
        navigationBar.items = [navigationItem]
    }
    
    // MARK: - Creation mode Method
    @objc func dismissWithoutCreation() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func dismissWithCreation() {
        var content: [String: Any] = [:]
        content.updateValue(UUID().uuidString as Any, forKey: ProjectKey.identifier.rawValue)
        content.updateValue(titleTextField.text as Any, forKey: ProjectKey.title.rawValue)
        content.updateValue(datePicker.date as Any, forKey: ProjectKey.deadline.rawValue)
        content.updateValue(descriptionTextView.text as Any, forKey: ProjectKey.description.rawValue)
        content.updateValue(Status.todo, forKey: ProjectKey.status.rawValue)
        projectCreationDelegate?.createProject(with: content)
        dismiss(animated: false, completion: nil)
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
    
    private func toggleEditMode() {
        self.titleTextField.isEnabled.toggle()
        self.datePicker.isEnabled.toggle()
        self.descriptionTextView.isEditable.toggle()
    }
    
    @objc func enableEdit() {
        toggleEditMode()
        titleTextField.becomeFirstResponder()
    }
    
    @objc func dismissWithUpdate() {
        var content: [String: Any] = [:]
        content.updateValue(titleTextField.text as Any, forKey: ProjectKey.title.rawValue)
        content.updateValue(datePicker.date as Any, forKey: ProjectKey.deadline.rawValue)
        content.updateValue(descriptionTextView.text as Any, forKey: ProjectKey.description.rawValue)
        content.updateValue(project?.status as Any, forKey: ProjectKey.status.rawValue)
        guard let projectTableViewController = presentingViewController as?
                ProjectEditDelegate,
              let project = self.project else {
            return
        }
        projectTableViewController.updateProject(of: project, with: content)
        dismiss(animated: false, completion: nil)
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
