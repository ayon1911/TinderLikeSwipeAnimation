//
//  SettingsVC.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 21.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsVCDelegate {
    func didSaveSettings()
}

class SettingsVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK:- Variables
    var delegate: SettingsVCDelegate?
    var user: User?
    let settingsViewModel = SettingsViewModel()

    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    lazy var header: UIView = {
        let header = UIView()
        let padding: CGFloat = 16
        header.addSubview(image1Button)
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }()
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentuser()
    }
    
    //MARK:- TABELVIEW DELEGATE AND DATASOURCE
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = HeaderLabel()
        headerLabel.font = UIFont(name: "AvenirNext-Medium", size: 21)
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Age Range"
        }
        return (section == 0) ? header : headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 300 : 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeRange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeRange), for: .valueChanged)
            
//            let minAge = user?.minAge ?? DEFAULT_MIN_AGE
//            let maxAge = user?.maxAge ?? DEFAULT_MAX_AGE

            ageRangeCell.minLabel.text = "Min \(settingsViewModel.minAge)"
            ageRangeCell.minSlider.value = Float(settingsViewModel.minAge)
            ageRangeCell.maxLabel.text = "Max \(settingsViewModel.maxAge)"
            ageRangeCell.maxSlider.value = Float(settingsViewModel.maxAge)
            return ageRangeCell
        }
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
                cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    //MARK:- SETUP & HELPERS
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
    
    fileprivate func fetchCurrentuser() {
        FetchUserService.shared.fetchCurrentUser { (user, error) in
            if let err = error {
                print("Could not fetch data", err)
                return
            }
            self.user = user
            self.loadUserPhotos()
            self.setupSettingsViewModelObserver()
            self.tableView.reloadData()
        }
    }

    fileprivate func loadUserPhotos() {
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    //MARK:- HANDLER FUNCTIONS
    @objc fileprivate func handleMinAgeRange(slider: UISlider) {
        settingsViewModel.minAge = Int(slider.value)
    }
    
    @objc fileprivate func handleMaxAgeRange(slider: UISlider) {
        settingsViewModel.maxAge = Int(slider.value)
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    @objc fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "minAge": settingsViewModel.minAge,
            "maxAge": settingsViewModel.maxAge
        ]
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving  settings"
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let err = error {
                print(err)
                return
            }
            hud.dismiss(animated: true)
            self.dismiss(animated: true, completion: {
                self.delegate?.didSaveSettings()
            })
        }
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func setupSettingsViewModelObserver() {
        if let user = user {
            settingsViewModel.minAge = user.minAge ?? DEFAULT_MIN_AGE
            settingsViewModel.maxAge = user.maxAge ?? DEFAULT_MAX_AGE
            settingsViewModel.bindableAge.bind { [unowned self] (ageRange) in
                guard let ageRange = ageRange else { return }
                let indexPath = IndexPath(row: 0, section: 5)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? AgeRangeCell else { return }
                let (minAge, maxAge) = (ageRange.min, ageRange.max)
                cell.minLabel.text = "Min \(minAge)"
                cell.maxLabel.text = "Max \(maxAge)"
                cell.minSlider.value = Float(minAge)
                cell.maxSlider.value = Float(maxAge)
            }
        }
    }

    //MARK:- IMAGE PICKER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
        
       setImageToFireStore(selectedImage, imageButton)
    }
    
    fileprivate func setImageToFireStore(_ selectedImage: UIImage?, _ imageButton: UIButton?) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/image/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image...."
        hud.show(in: view)
        
        ref.putData(uploadData, metadata: nil) { (nil, error) in
            if let err = error {
                hud.dismiss(animated: true)
                print("Failed to upload data:", err)
                return
            }
            print("Finished uploading images...")
            ref.downloadURL(completion: { (url, error) in
                hud.dismiss(animated: true)
                if let err = error {
                    print("Failed to retrive", err)
                }
                print("Finished getting the url: ", url?.absoluteString ?? "")
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            })
        }
    }
}
//MARK:- CUSTOM CLASSES
class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}
