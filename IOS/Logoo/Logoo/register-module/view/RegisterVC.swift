//
//  RegisterVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

/**
 - This ViewController allows the user to register.
   - There is a CollectionView structure in its main logic. With this horizontal structure, I create my registration cells and offer the user the opportunity to register step by step.
   - Note: Authentication processes take place in the cell class of the step, whichever step the user is in.
 */

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var registerProgressView: UIProgressView!
    @IBOutlet weak var registerStepLabel: UILabel!
    @IBOutlet weak var registerCollectionView: UICollectionView!
    @IBOutlet weak var registerNextButton: UIButton!
    @IBOutlet weak var registerBackButton: UIButton!
    @IBOutlet weak var registerErrorLabel: UILabel!
        
    var presenter:ViewToPresenterRegisterMail?
    var currentRegisterClass:Int?
    var alert:CustomAlert?
    var confirmMailAdress:String?
    var registerSteps:[UICollectionViewCell]?
    var registerPhotoPickCell:RegisterPhotoChooseCell?
    var validation:RegisterProtocol?
    
    var registerType:RegisterType?
    
    var resultScreenMessage:String?
    var resultScreenAnimName:String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        currentRegisterClass = 0
        
        RegisterRouter.createModule(ref: self)
        
        if let registerType = registerType {
            registerCells()
            
            if registerType == .REGISTER_WITH_MAIL {
                presenter?.getRegisterMailSteps()
            }
            else if registerType == .REGISTER_WITH_GOOGLE {
                if getCurrentUserUid() != nil {
                    presenter?.getRegisterGoogleSteps()
                }else {
                    goBackForError()
                }
            }
            
            registerCollectionView.delegate = self
            registerCollectionView.dataSource = self
        }else {
            goBackForError()
        }
    

        
    }
    
    func goBackForError(){
        let alert = UIAlertController(
            title: "error".localized(),
            message: "Something went wrong. Please try again later.".localized(),
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Cancel".localized(),
                                   style: .cancel, handler: {_ in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func registerCells(){
        // Register
        self.registerCollectionView.register(UINib(nibName:"RegisterPhotoChooseCell", bundle: nil), forCellWithReuseIdentifier: RegisterCollectionViewCells.photoPick.rawValue)
        
        self.registerCollectionView.register(UINib(nibName: "RegisterInformationCell", bundle: nil), forCellWithReuseIdentifier: RegisterCollectionViewCells.enterInformation.rawValue)
        
        self.registerCollectionView.register(UINib(nibName: "RegisterBirthDayCell", bundle: nil), forCellWithReuseIdentifier: RegisterCollectionViewCells.enterDateOfBirth.rawValue)
        
        self.registerCollectionView.register(UINib(nibName: "RegisterGenderCell", bundle: nil), forCellWithReuseIdentifier: RegisterCollectionViewCells.enterGender.rawValue)
        
        self.registerCollectionView.register(UINib(nibName: "RegisterConfirmCell", bundle: nil), forCellWithReuseIdentifier: RegisterCollectionViewCells.confirmation.rawValue)
    }
    
    
    /**
     - The method that will work when the user presses the continue button when he wants to progress in the registration section.
     In this section, I get the information on which step the user is at that moment.
          
     - The class of each register cell (CollectionView Cell) inherits the protocol related to validation.
     After that, I run the validation function of the collectionviewcell class in that step.
     If the function returns true, I allow the next cell to be passed.
     */
    
    @IBAction func registerNextButton(_ sender: Any) {
        if currentRegisterClass != self.registerSteps!.count - 1 && currentRegisterClass != self.registerSteps!.count - 2 {
            // Executes the validation function of the current register cell, the response is of type Validation Response.
            if let response = (registerSteps![self.currentRegisterClass!] as? RegisterProtocol)?.validate() {
                /**
                 If the response status is true, it means that the user has successfully completed the registration step.
                 */
                if response.status! {
                    self.registerErrorLabel.isHidden = true
                    scrollToNextItem()
                }else {
                    self.registerErrorLabel.text = response.message
                    self.registerErrorLabel.isHidden = false
                }
            }
        }else if currentRegisterClass == self.registerSteps!.count - 2 {
            if let response = (registerSteps![self.currentRegisterClass!] as? RegisterProtocol)?.validate() {
                if response.status! {
                    self.registerErrorLabel.isHidden = true
                    if self.registerType == .REGISTER_WITH_MAIL {
                        presenter?.createUserWithEmail()
                    }else if self.registerType == .REGISTER_WITH_GOOGLE {
                        presenter?.setUserInfoForGoogleUsers()
                    }
                }else {
                    self.registerErrorLabel.text = response.message
                    self.registerErrorLabel.isHidden = false
                }
            }
        }
        
        else {
            performSegue(
                withIdentifier: RegisterVCSegues
                    .registerToLogin
                    .rawValue,
                sender: self.confirmMailAdress!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RegisterVCSegues.registerToLogin.rawValue {
            if let mail = (sender as? String) {
                let targetVC = segue.destination as! LoginVC
                targetVC.incomingMail = mail
            }
        }
    }
    /**
     - In the registration section, if the user is not in the first step, he uses this button to return to the previous step.
     */
    
    @IBAction func registerBackButton(_ sender: Any) {
        if currentRegisterClass != 0 {
            scrollToPreviousItem()
        }
    }
}

extension RegisterVC : PresenterToViewRegisterMail {
    func registerFeedBack(response: ValidationResponse) {
        if response.status! {
            if registerType == .REGISTER_WITH_MAIL {
                self.resultScreenMessage = "We have sent confirmation link to your email address.".localized()
                self.resultScreenAnimName = "mail_sended"
                self.confirmMailAdress = response.message!
            }
            else if registerType == .REGISTER_WITH_GOOGLE {
                self.resultScreenMessage = "Registration Successful".localized()
                self.resultScreenAnimName = "success"
            }
            scrollToNextItem()
        }else {
            self.registerErrorLabel.text = response.message!
        }
    }
    
    func registerProgressVisibility(status: Bool) {
        if status {
            alert =  CustomAlert()
            alert!.showAlert(with: "title", message: "Lütfen bekleyin.", viewController: self)
        }else {
            alert?.dismissAlert()
        }
    }
    
    func registerStepsToView(steps: [UICollectionViewCell]) {
        self.registerSteps = steps
    }
}

extension RegisterVC : UICollectionViewDelegate, UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return registerSteps?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = indexPath.row
        if self.registerSteps![count] is RegisterPhotoChooseCell {
            let photoPickCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RegisterCollectionViewCells
                    .photoPick
                    .rawValue, for: indexPath) as! RegisterPhotoChooseCell
            validation = photoPickCell
            photoPickCell.initialize()
            photoPickCell.photoProtocol = self
            self.registerSteps![indexPath.row] = photoPickCell // init
            return photoPickCell
        }
        else if self.registerSteps![count] is RegisterInformationCell {
            let informationCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RegisterCollectionViewCells
                    .enterInformation
                    .rawValue,for: indexPath) as! RegisterInformationCell
            self.registerSteps![indexPath.row] = informationCell // init
            informationCell.initialize(informationProtocol: self)
            return informationCell
        }
        else if self.registerSteps![count] is RegisterBirthDayCell {
            let birthDayCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RegisterCollectionViewCells
                    .enterDateOfBirth
                    .rawValue, for: indexPath) as! RegisterBirthDayCell
            birthDayCell.initialize(birthDayCellProtocol: self)
            self.registerSteps![indexPath.row] = birthDayCell // init
            return birthDayCell
        }
        else if self.registerSteps![count] is RegisterGenderCell {
            let genderCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RegisterCollectionViewCells
                    .enterGender
                    .rawValue, for: indexPath) as! RegisterGenderCell
            genderCell.initialize(genderPickerCellProtocol: self)
            self.registerSteps![indexPath.row] = genderCell // init
            return genderCell
        }
        else {
            let otpCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RegisterCollectionViewCells
                    .confirmation
                    .rawValue, for: indexPath) as! RegisterConfirmCell
            self.registerSteps![indexPath.row] = otpCell // init
            return otpCell
        }
    }
    
    /**
     - I set the aspect ratio of the cells to be the same as the collectionview.
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.registerCollectionView.frame.width, height: self.registerCollectionView.frame.height)
        }
    
    /**
     - This function works when the user scroll the registration step.
     */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let horizontalCenter = width / 2
            let page = Int(offSet + horizontalCenter) / Int(width) // Current registiration step.
        
        self.currentRegisterClass = page
        if page == 0 {
            self.registerBackButton.isHidden = true
        }else if page < self.registerSteps!.count-1 && page > 0 && currentRegisterClass != self.registerSteps!.count - 2 {
            self.registerNextButton.setTitle("Next".localized(), for: UIControl.State.normal)
            self.registerBackButton.isHidden = false
        }
        else if currentRegisterClass == self.registerSteps!.count - 2 {
            self.registerNextButton.setTitle("Finish It".localized(), for: UIControl.State.normal)
            self.registerBackButton.isHidden = false
        }
        else {
            self.registerNextButton.setTitle("Log In".localized(), for: UIControl.State.normal)
            self.registerBackButton.isHidden = true
            if registerType == .REGISTER_WITH_GOOGLE {
                self.registerNextButton.isHidden = true
            }
        }
        
        // ProgressView
        self.registerStepLabel.text = "\(page+1)/\(self.registerSteps!.count)"
        self.registerProgressView.progress = Float(page + 1) / Float(self.registerSteps!.count)
        
        let rgClass = self.registerSteps![page]
        
        if rgClass is RegisterPhotoChooseCell {
            self.validation = rgClass as! RegisterPhotoChooseCell
        }
        else if rgClass is RegisterInformationCell {
            self.validation = rgClass as! RegisterInformationCell
        }
        else if rgClass is RegisterBirthDayCell {
            self.validation = rgClass as! RegisterBirthDayCell
        }
        else if rgClass is RegisterGenderCell {
            self.validation = rgClass as! RegisterGenderCell
        }
        else if rgClass is RegisterConfirmCell {
            let convertClass = rgClass as! RegisterConfirmCell
            convertClass.animName = self.resultScreenAnimName!
            convertClass.message = self.resultScreenMessage!
            convertClass.initialize()
        }

    }
    
}

/**
 - With this extension, I inherit protocols that will allow me to detect dynamic events that occur between the user and the cells in the registration steps.
- The UIImagePickerControllerDelegate and UINavigationControllerDelegate protocols are inherited to receive images from the user.
 */
extension RegisterVC : RegisterPhotoCellProtocol, RegisterInformationCellProtocol, RegisterBirthDayCellProtocol, RegisterGenderCellProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    /**
- The method that will work if the user clicks on ImageView during the photo selection stage.
- With this method, I enable the relevant window to be opened to request a picture from the user.
- I authorize the reference of the photoPickCell class, which is nullable in the RegisterVC class, with the reference from the requesting class, so that when the photo is selected, I can send the selected photo back to the cell class.
     */
    func photoOnClick(registerCell: RegisterPhotoChooseCell) {
        
        self.registerPhotoPickCell = registerCell
        let imagePicker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false

                present(imagePicker, animated: true, completion: nil)
            }
    }
    
    /**
     The following method will work as soon as the user interacts with the screen that opens to select a picture.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.dismiss(animated: true, completion: nil) // if the user choosed an image, close the window.
        
        /**
         I'm performing a casting when the user selects an image. If the image is received successfully, in the next step I will pass the image to the cell class for UI part update.
         */
        guard let image = info[.originalImage] as? UIImage else {
           print("Expected a dictionary containing an image, but was provided the following: \(info)")
            return
        }
        // I pass the received image to both the cell class and the interactor class.
        self.registerPhotoPickCell?.onPhotoUpload(image: image)
        self.presenter?.setUserImage(image: image)
    }
    
    /**
     In this section, when the user enters important information (username, mail, password) and tries to pass this step, if the information passes through the validation part, they are transmitted to the interactor layer.
     */
    func informationToView(username: String, userMail: String, userPassword: String) {
        self.presenter?.setUserInfo(username: username, userMail: userMail, userPassword: userPassword)
    }
    /**
     I take the user birthdate from the registration class and pass it to the internactor class.
     */
    func birthDaySelected(date: String) {
        self.presenter?.setUserBirthDay(date: date)
    }
    
    func genderSelected(gender: GenderType) {
        self.presenter?.setUserGender(gender: gender)
    }
}

/**
 I created an extension to make the CollectionView structure a step-by-step structure. So I can scroll forward or backward whenever I want.
 */
extension RegisterVC {
    func scrollToNextItem() {
        /*
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset) */
        let nextItem: IndexPath = IndexPath(item: self.currentRegisterClass! + 1, section: 0)
        self.registerCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
    }

    func scrollToPreviousItem() {
        let previousItem: IndexPath = IndexPath(item: self.currentRegisterClass! - 1, section: 0)
        self.registerCollectionView.scrollToItem(at: previousItem, at: .right, animated: true)
    }
}

enum RegisterVCSegues : String {
    case registerToLogin = "registerToLogin"
}

enum RegisterCollectionViewCells : String {
    case photoPick          = "registerPhotoChooseCell"
    case enterInformation   = "registerInfoCell"
    case enterDateOfBirth   = "registerBirthDayCell"
    case enterGender        = "registerGenderCell"
    case confirmation       = "registerConfirmCell"
}
