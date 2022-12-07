//
//  AddTypeViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 29.11.2021.
//

import UIKit

class AddTypeViewController: OffsetableViewController {
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameTextField: MainTextField!
    @IBOutlet weak var linkTitleLabel: UILabel!
    @IBOutlet weak var linkTextField: MainTextField!
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var loginTextField: MainTextField!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryTextField: MainTextField!
    @IBOutlet weak var saveButton: MainButton!
    
    private var mainImagePicker: UIImagePickerController!
    private var categories = [String]()
    private var categoriesList = [CategoriesModel]()
    
    var onDismiss: (() -> Void)?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        configureViews()
        configureImageView()
        configureButtons()
        configureTextFields()
        addSwipe()
        getCategories()
        hideKeyboardWhenTappedAround()
    }
    
    override func offsetableTextFields() -> [UITextField] {
        [nameTextField, linkTextField, loginTextField]
    }
    
    // MARK: - Actions
    @IBAction func saveButtonDidTap() {
        guard let title = nameTextField.text, !title.isEmpty, let value = linkTextField.text, !value.isEmpty, let login = loginTextField.text, !login.isEmpty, let cat = categoryTextField.text, !cat.isEmpty else { return }
        var id = 1
        for category in categoriesList where category.name == cat {
            id = category.id
        }
        NetworkManager.shared.createContactTypes(categoryId: id, pattern: value, name: title, isActive: true, image: imageView.image?.jpegData(compressionQuality: 1) ?? Data()) { [self] data in
            guard data.statusCode != 400 else {
                ToastView.show(text: "Не удалось обновить данные", in: self)
                return }
            dismiss(animated: true)
            onDismiss?()
        } failure: { error in
            guard let error = error else { return }
            ToastView.show(text: "Не удалось обновить данные", in: self)
        }
    }
    
    @IBAction func editImageButtonDidTap() {
        let optionMenu = UIAlertController(title: nil, message: "Take photo from:", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "Library", style: .default, handler: { _ in
            self.takePhoto(from: .photoLibrary)
        })
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.takePhoto(from: .camera)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        [library, camera, cancel].forEach {optionMenu.addAction($0)}
        present(optionMenu, animated: true)
    }
    
    // MARK: - Private methods
    private func localize() {
        saveButton.setTitle("Сохранить", for: .normal)
    }
    
    private func configureViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
        imageContainerView.layer.cornerRadius = imageContainerView.frame.height / 2
        addSecondShadow(to: imageContainerView)
    }
    
    private func configureImageView() {
        imageView.layer.cornerRadius = 14
    }
    
    private func configureTextFields() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCategories))
        categoryTextField.addGestureRecognizer(tapGestureRecognizer)
        nameTextField.delegate = self
        linkTextField.delegate = self
        loginTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
    }
    
    private func configureButtons() {
        editImageButton.layer.cornerRadius = editImageButton.frame.height / 2
    }
    
    private func addSwipe() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func closeView() {
        dismiss(animated: true)
    }
    
    private func takePhoto(from type: UIImagePickerController.SourceType) {
        mainImagePicker = UIImagePickerController()
        mainImagePicker.delegate = self
        mainImagePicker.sourceType = type
        present(mainImagePicker, animated: true)
    }
    
    private func addSecondShadow(to view: UIView) {
        addShadow(to: view)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
    }
    
    private func addShadow(to view: UIView) {
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.Colors.buttonBorderColor.cgColor
        view.backgroundColor = Theme.Colors.qrCodeBgColor
        view.layer.masksToBounds = false
    }
    
    @objc private func nameTextFieldDidChange() {
        titleLabel.text = nameTextField.text
    }
    
    private func downloadImage(from url: URL, completion: @escaping (_ image: UIImage) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(UIImage(data: data) ?? UIImage())
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    @objc private func showCategories() {
        let vc = MainStoryboard.categoriesPickerViewController
        let dataProvider = CategoriesPickerDataProvider(categories: categories) { category in
            self.categoryTextField.text = category
        }
        vc.dataProvider = dataProvider
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }
    
    private func getCategories() {
        NetworkManager.shared.getCategoriesList { data in
            self.categoriesList = data
            data.forEach { self.categories.append($0.name) }
        } failure: { error in
            guard let error = error else { return }
            ToastView.show(text: "Не удалось загрузить данные", in: self)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddTypeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        mainImagePicker.dismiss(animated: true)
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddTypeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

