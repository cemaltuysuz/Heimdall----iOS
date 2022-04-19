//
//  RegisterVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

/**
 - This ViewController allows the user to register.
   - There is a CollectionView structure in its main logic. With this horizontal orientation.
   - Note: Authentication processes take place in the cell class of the step, whichever step the user is in.
 */

import UIKit
import Mantis

class RegisterVC: BaseVC {

    @IBOutlet weak var registerProgressView: UIProgressView!
    @IBOutlet weak var registerStepLabel: UILabel!
    @IBOutlet weak var registerCollectionView: UICollectionView!
    @IBOutlet weak var registerNextButton: UIButton!
    @IBOutlet weak var registerBackButton: UIButton!
    @IBOutlet weak var registerErrorLabel: UILabel!
        
    var presenter:ViewToPresenterRegister?
    var alert:CustomAlert?
    var confirmMailAdress:String?
    var registerSteps:[RegisterCellType]? {
        didSet {
            guard let registerSteps = registerSteps else {
                return
            }
            registerStepLabel.text = "1/\(registerSteps.count)"
            registerCellsForCollectionView(registerSteps)
        }
    }
    var registerPhotoPickCell:RegisterPhotoChooseCell?
    
    var registerType:RegisterType?
    
    var resultScreenMessage:String?
    var resultScreenAnimName:String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RegisterRouter.createModule(ref: self)
        setupUI()
        
    }
    
    func setupUI(){
        registerNextButton.setTitle("Next".localized(), for: .normal)
        if let registerType = registerType {
            if registerType == .REGISTER_WITH_MAIL {
                presenter?.getRegisterMailSteps()
            }
            else if registerType == .REGISTER_WITH_GOOGLE {
                if FirebaseAuthService.shared.getUUID() != nil {
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
        createAlertNotify(title: "error".localized(),
                         message: "Something went wrong. Please try again later.".localized(),
                         onCompletion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    /**
     - The method that will work when the user presses the continue button when he wants to progress in the registration section.
     In this section, I get the information on which step the user is at that moment.
          
     - The class of each register cell (CollectionView Cell) inherits the protocol related to validation.
     After that, I run the validation function of the collectionviewcell class in that step.
     If the function returns true, I allow the next cell to be passed.
     */
    
    @IBAction func registerNextButton(_ sender: Any) {
        guard let currentRegisterClass = currentRegisterCell(), currentRegisterClass is Registerable else {
            return}
        let currentRegisterProtocol = currentRegisterClass as! Registerable
        
        if currentRegisterCellIndex() != registerSteps!.count - 1 && currentRegisterCellIndex() != registerSteps!.count - 2 {
            // Executes the validation function of the current register cell, the response is of type Validation Response.
            let response = currentRegisterProtocol.validate()
            /**
             If the response status is true, it means that the user has successfully completed the registration step.
             */
            if response.status! {
                registerErrorLabel.textColor = .clear
                scrollToNextItem()
            }else {
                registerErrorLabel.text = response.message
                registerErrorLabel.textColor = .red
            }
        }else if currentRegisterCellIndex() == registerSteps!.count - 2 {
            let response = currentRegisterProtocol.validate()
            if response.status! {
                registerErrorLabel.textColor = .clear
                if registerType == .REGISTER_WITH_MAIL {
                    presenter?.createUserWithEmail()
                }else if registerType == .REGISTER_WITH_GOOGLE {
                    presenter?.setUserInfoForGoogleUsers()
                }
            }else {
                registerErrorLabel.text = response.message
                registerErrorLabel.textColor = .red
            }
        }
        else {
            let vc = LoginVC.instantiate(from: .Welcome)
            vc.incomingMail = confirmMailAdress
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    /**
     - In the registration section, if the user is not in the first step, he uses this button to return to the previous step.
     */
    
    @IBAction func registerBackButton(_ sender: Any) {
        if currentRegisterCellIndex() != 0 {
            scrollToPreviousItem()
        }
    }
}

extension RegisterVC : PresenterToViewRegister {
    func registerFeedBack(response: ValidationResponse) {
        if response.status! {
            if registerType == .REGISTER_WITH_MAIL {
                resultScreenMessage = "We have sent confirmation link to your email address.".localized()
                resultScreenAnimName = "mail_sended"
                confirmMailAdress = response.message!
            }
            else if registerType == .REGISTER_WITH_GOOGLE {
                resultScreenMessage = "Registration Successful".localized()
                resultScreenAnimName = "success"
            }
            scrollToNextItem()
        }else {
            registerErrorLabel.text = response.message!
        }
    }
    
    func registerProgressVisibility(status: Bool) {
        if status {
            showCurtain()
        }else {
            closeCurtain()
        }
    }
    
    func registerStepsToView(steps: [RegisterCellType]) {
        guard !steps.isEmpty else {return}
        registerSteps = steps
    }
}

extension RegisterVC : UICollectionViewDelegate, UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return registerSteps?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = registerSteps![indexPath.row]
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: type.getCurrentIdentifier(), for: indexPath)
        
        if collectionViewCell is RegisterBindable {
            (collectionViewCell as! RegisterBindable).bind(self)
        }
        return collectionViewCell
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
        
        if page == 0 {
            registerBackButton.isHidden = true
        }else if page < registerSteps!.count-1 && page > 0 && page != self.registerSteps!.count - 2 {
            registerNextButton.setTitle("Next".localized(), for: UIControl.State.normal)
            registerBackButton.isHidden = false
        }
        else if page == registerSteps!.count - 2 {
            registerNextButton.setTitle("Finish It".localized(), for: UIControl.State.normal)
            registerBackButton.isHidden = false
        }
        else {
            registerNextButton.setTitle("Log In".localized(), for: UIControl.State.normal)
            registerBackButton.isHidden = true
            if registerType == .REGISTER_WITH_GOOGLE {
                registerNextButton.isHidden = true
            }
        }
        
        // ProgressView
        registerStepLabel.text = "\(page+1)/\(self.registerSteps!.count)"
        registerProgressView.progress = Float(page + 1) / Float(self.registerSteps!.count)
    }
    
}

/**
 - With this extension, I inherit protocols that will allow me to detect dynamic events that occur between the user and the cells in the registration steps.
- The UIImagePickerControllerDelegate and UINavigationControllerDelegate protocols are inherited to receive images from the user.
 */
extension RegisterVC : RegisterPhotoChooseCellProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
     - The method that will work if the user clicks on ImageView during the photo selection stage.
     - With this method, I enable the relevant window to be opened to request a picture from the user.
     - I authorize the reference of the photoPickCell class, which is nullable in the RegisterVC class, with the reference from the requesting class, so that when the photo is selected, I can send the selected photo back to the cell class.
     */
    func photoOnClick(registerCell: RegisterPhotoChooseCell) {
        showCurtain()
        registerPhotoPickCell = registerCell
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: {
                self.closeCurtain()
            })
        }
    }
    /**
     The following method will work as soon as the user interacts with the screen that opens to select a picture.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil) // if the user choosed an image, close the window.
        
        /**
         I'm performing a casting when the user selects an image. If the image is received successfully, in the next step I will pass the image to the cell class for UI part update.
         */
        guard let image = info[.originalImage] as? UIImage else {
            print("Expected a dictionary containing an image, but was provided the following: \(info)")
            return
        }
        // I pass the received image to both the cell class and the interactor class.
        var config = Mantis.Config()
        config.cropShapeType = .square
        config.ratioOptions = [.square]
        let cropViewController = Mantis.cropViewController(image: image,config: config)
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
}

extension RegisterVC : RegisterInformationCellProtocol {
    func informationToView(username: String, userMail: String, userPassword: String) {
        presenter?.setUserInfo(username: username, userMail: userMail, userPassword: userPassword)
    }
    
    func informationRealtimeValidation(response: ValidationResponse) {
        DispatchQueue.main.async {
            if let status = response.status, status {
                self.registerErrorLabel.textColor = .clear
            }else {
                self.registerErrorLabel.text = "\(response.message ?? "") "
                self.registerErrorLabel.textColor = .red
            }
        }
    }
    
}

extension RegisterVC : RegisterBirthDayCellProtocol {
    func birthDaySelected(date: String) {
        presenter?.setUserBirthDay(date: date)
    }
}

extension RegisterVC : RegisterGenderCellProtocol {
    func genderSelected(gender: GenderType) {
        presenter?.setUserGender(gender: gender)
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
        let nextItem: IndexPath = IndexPath(item: currentRegisterCellIndex() + 1, section: 0)
        registerCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
    }

    func scrollToPreviousItem() {
        let previousItem: IndexPath = IndexPath(item: currentRegisterCellIndex() - 1, section: 0)
        registerCollectionView.scrollToItem(at: previousItem, at: .right, animated: true)
    }
    
    func registerCellsForCollectionView(_ cells:[RegisterCellType]){
        for cell in cells {
            registerCollectionView.register(with: cell.getCurrentIdentifier())
        }
    }
    
    func currentRegisterCellIndex() -> Int{
        let scrollView = registerCollectionView as UIScrollView
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        let page = Int(offSet + horizontalCenter) / Int(width) // Current registiration step.
        return page
    }
    
    func currentRegisterCell() -> UICollectionViewCell? {
        guard let cell = registerCollectionView.cellForItem(at: IndexPath(row: currentRegisterCellIndex(), section: 0))
        else {return nil}
        return cell
    }
}

extension RegisterVC : CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
        cropViewController.dismiss(animated: true)
        registerPhotoPickCell?.onPhotoUpload(image: cropped)
        presenter?.setUserImage(image: cropped)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true)
    }
}
