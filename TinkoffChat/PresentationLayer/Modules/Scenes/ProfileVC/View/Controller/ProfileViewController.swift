//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 05/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    let profileView = ProfileView(frame: UIScreen.main.bounds)
    
    private var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .popover
        return imagePicker
    }()
    private var imageWasChanged = false
    private var isSavingMode = false
    
    //Dependencies
    private var presenter: IProfilePresenter
    private let presentationAssembly: IPresentationAssembly
    
    init(profilePresenter: IProfilePresenter, presentationAssembly: IPresentationAssembly) {
        self.presenter = profilePresenter
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        printFrameOfEditButton(in: #function)
        setupDelegates()
        setupKeyboard()
        setupButtons()
        setupAvatarGesture()
        loadMyProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCornerRaidus()
    }
    
    @IBAction func backNavBarItemWasTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    private func loadMyProfile() {
        presenter.loadMyProfile()
    }
    
    private func setupAvatarGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showAlertShit))
        self.profileView.profileImageView.addGestureRecognizer(tap)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setupButtons() {
        profileView.editButton.addTarget(self, action: #selector(editButtonDidTapped(_:)), for: .touchUpInside)
        profileView.addPhotoButton.addTarget(self, action: #selector(addPhotoButtonDidTapped(_:)), for: .touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close-icon").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backNavBarItemWasTapped))
        leftBarButtonItem.tintColor = .gray
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            var position: CGFloat = 0
            if let keyBoardY = endFrame?.origin.y, keyBoardY >= UIScreen.main.bounds.size.height {
                position = 0
            } else {
                position = -(endFrame?.size.height ?? 0.0)
            }
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.view.frame = CGRect(x: 0, y: position, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupCornerRaidus() {
        profileView.addPhotoButton.layer.cornerRadius = profileView.addPhotoButton.bounds.width/2
        profileView.profileImageView.layer.cornerRadius = profileView.addPhotoButton.cornerRadius
    }
    
    private func setupDelegates() {
        imagePicker.delegate = self
//        profileView.someInfoAboutUserTextView.delegate = self
//        profileView.nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printFrameOfEditButton(in: #function)
        /*
         Frames sizes are different because AutoLayout mechanism doesn't change our view sizes immediately, but only when is triggered, that means at a specific time.
         */
    }
    
    private func printFrameOfEditButton( in funcName: String) {
        print("Func name:\(funcName) \nFrame of \"EditButton\": \(profileView.editButton.frame)")
    }
    
    @IBAction func addPhotoButtonDidTapped(_ sender: Any) {
        print("Выбери изображение профиля")
        showAlertShit()
    }
    
    @objc private func showAlertShit() {
        guard isSavingMode == true else {return}
        present(prepareAlertSheet(), animated: true, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func showPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            if UIDevice.current.userInterfaceIdiom == .pad {
                imagePicker.modalPresentationStyle = .popover
                imagePicker.popoverPresentationController?.sourceView = self.view
                present(imagePicker, animated: true, completion: nil)
            } else {
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func editButtonDidTapped(_ sender: UIButton) {
        isSavingMode = !isSavingMode
        
        if isSavingMode {
            makeActiveEditableElements(true)
            turnEditModeUILogic(true)
        } else {
            saveMyProfileInfo()
        }
    }
    
    private func saveMyProfileInfo() {
        makeActiveEditableElements(false)
        showWritingToFileUILogic(true, andShowActivityIndicater: true)
        presenter.saveMyProfile(with: getUpdatedUserModel())
    }
    
    deinit {
        print("Profile deinit")
    }
}

//MARK: - View
extension ProfileViewController: IProfileView {
    
    func displayMessage(title: String, msg: String, withAction: UIAlertAction?) {
        if let action = withAction {
            displayMsg(title: title, msg: msg, style: .alert, additionalAction: action)
        } else {
            displayMsg(title: title, msg: msg)
        }
    }
    
    func getUpdatedUserModel() -> AppUserModel {
        return AppUserModel(name: profileView.nameTextField.text ?? "", someInfoAboutMe: profileView.someInfoAboutUserTextView.text, avatar: UIImageJPEGRepresentation(profileView.profileImageView.image ?? #imageLiteral(resourceName: "placeholder-user"), 1.0))
    }
    
    func makeActiveEditableElements(_ active: Bool) {
        if active {
            profileView.nameTextField.isEnabled = true
            profileView.someInfoAboutUserTextView.isEditable = true
            profileView.addPhotoButton.isEnabled = true
        } else {
            profileView.nameTextField.isEnabled = false
            profileView.someInfoAboutUserTextView.isEditable = false
            profileView.addPhotoButton.isEnabled = false
        }
    }
    
    func turnEditModeUILogic(_ on: Bool) {
        if on {
            profileView.editButton.setTitle("Сохранить", for: .normal)
        } else {
            profileView.activityIndicator.stopAnimating()
            profileView.activityIndicator.isHidden = true
            profileView.editButton.setTitle("Редактировать", for: .normal)
        }
    }
    
    func setupProfile(wtih appUserModel: AppUserModel) {
        self.profileView.profileImageView.image = UIImage(data: appUserModel.avatar ?? Data())
        self.profileView.nameTextField.text = appUserModel.name
        self.profileView.someInfoAboutUserTextView.text = appUserModel.someInfoAboutMe
    }
    
    func showWritingToFileUILogic(_ show: Bool, andShowActivityIndicater: Bool = false) {
        if show {
            if andShowActivityIndicater {
                profileView.activityIndicator.startAnimating()
                profileView.activityIndicator.isHidden = false
            }
            makeActiveEditableElements(false)
        } else {
            makeActiveEditableElements(true)
        }
    }
  
    func prepareAlertSheet() -> UIAlertController {
        let actionSheet = UIAlertController(title: "Please choose a source type", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { (action) in
            print("открываем камеру")
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Выбрать фото", style: .default, handler: { (action) in
            print("выбираем фото")
            self.showPhotoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Загрузить", style: .default, handler: { (action) in
            let imagesLibraryViewController = self.presentationAssembly.imagesLibraryViewController()
            imagesLibraryViewController.delegate = self
            self.present(imagesLibraryViewController, animated: true, completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: "Отменить", style: UIAlertActionStyle.cancel, handler: { (action) in }))
        actionSheet.popoverPresentationController?.sourceView = profileView.addPhotoButton
        actionSheet.popoverPresentationController?.sourceRect = profileView.addPhotoButton.bounds
        return actionSheet
    }
}

//MARK: - TextInputMethods
//extension ProfileViewController: UITextFieldDelegate, UITextViewDelegate {
//    @objc private func textFieldDidChange(_ textField: UITextField) {
//        if presenter.wasModelChanged() {
//            makeActiveEditableElements(true)
//        } else {
//            makeActiveEditableElements(false)
//        }
//    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        if presenter.wasModelChanged() {
//            makeActiveEditableElements(true)
//        } else {
//            makeActiveEditableElements(false)
//        }
//    }
//}

//MARK: - PickerController delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        profileView.profileImageView.image = image
        imageWasChanged = true
        if presenter.wasModelChanged() {
            makeActiveEditableElements(true)
        } else {
            makeActiveEditableElements(false)
        }
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - ProfileModel delegate
extension ProfileViewController: ImagesLybraryDelegate {
    func imageDidTapped(_ image: UIImage) {
        self.profileView.profileImageView.image = image
    }
}
