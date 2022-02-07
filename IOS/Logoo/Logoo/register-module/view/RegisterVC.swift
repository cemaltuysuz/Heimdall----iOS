//
//  RegisterVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

/**
 - Bu ViewController kullanıcının kayıt olmasına olanak sağlar.
 - Ana mantığında CollectionView yapısı var. Horizontal yapıda olan bu yapı ile kayıt hücrelerimi oluşturarak kullanıcıya
 adım adım kayıt olma imkanı sunuyorum.
 - Not : Doğrulama işlemleri kullanıcı hangi adımda ise o adımın hücre sınıfı içerisinde gerçekleşir.
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
    
    var registerSteps:[UICollectionViewCell]?
    var registerPhotoPickCell:RegisterPhotoPickCell?
    var validation:RegisterProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        currentRegisterClass = 0
        
        RegisterRouter.createModule(ref: self)
        presenter?.getRegisterSteps()

        registerCollectionView.delegate = self
        registerCollectionView.dataSource = self
        
        
    }
    /**
     - Kullanıcı kayıt kısmında ilerlemek istediğinde devam butonuna bastığında çalışacak olan method.
     Bu kısımda kullanıcının o anda hangi adımda olduğu bilgisini ediniyorum.
     
     - Her kayıt hücresinin sınıfı doğrulama ile ilgili protokolü kalıtım olarak alıyor.
     Bunun ardından o adımda bulunan collectionviewcell sınıfının sahip olduğu doğrulama fonksiyonunu çalıştırıyorum.
     Eğer fonksiyon true dönerse bir sonraki hücreye geçiş izni veriyorum.
     
     - Kullanıcı 2. index'e sahip ise son kısımda var sayılıyor. Bu kısımda gerçekleşmesi beklenen durum da gerçekleştiğinde
     kullanıcının kaydı yapılıyor ve home sayfasına yönlendiriliyor.
     */
    
    @IBAction func registerNextButton(_ sender: Any) {
        if currentRegisterClass != self.registerSteps!.count - 1 {
            // Anlık kayıt hücresine validation gonderir, cevap validation response tipinde döner.
            if let response = (registerSteps![self.currentRegisterClass!] as? RegisterProtocol)?.validate() {
                /**
                 Response status bool tipinde olup true dönüyorsa kullanıcı başarılı bir şekilde kayıt adımını tamamlamış anlamına gelir.
                 */
                if response.status! {
                    //registerCollectionView.scrollToNextItem() // Bir sonraki adıma geç.
                    self.registerErrorLabel.isHidden = true
                    scrollToNextItem()
                }else {
                    self.registerErrorLabel.text = response.message
                    self.registerErrorLabel.isHidden = false
                }
            
            }
        }else {
            performSegue(withIdentifier: "registerToHome", sender: nil)
        }
    }
    /**
     - Kullanıcı kayıt kısmında eğer birinci adımda değilse bir önceki adıma dönmek için bu butonu kullanır.
     */
    
    @IBAction func registerBackButton(_ sender: Any) {
        if currentRegisterClass != 0 {
            scrollToPreviousItem()
        }
    }
}

extension RegisterVC : PresenterToViewRegisterMail {
    func registerStepsToView(steps: [UICollectionViewCell]) {
        self.registerSteps = steps
    }
}

extension RegisterVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    /**
     Kullanıcının kayıt kısmı 3 farklı adımdan oluştuğu ve bu sayı bir sabit olduğu için direkt olarak 3 döndürüyorum.
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return registerSteps!.count
    }
    /**
     - 0. index'de kullanıcı fotoğraf seçimi yapıyor.
     - 1. index'de kullanıcı kendisi hakkında gereken bilgileri veriyor. (Kullancı adı, e-mail, doğum tarihi vb.)
     - 2. index'de kullanıcının vermiş olduğu iletişim adresinin doğruluğu kontrol ediliyor.
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = indexPath.row
        if self.registerSteps![count] is RegisterPhotoPickCell {
            let photoPickCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoPickRegisterCell", for: indexPath) as! RegisterPhotoPickCell
            validation = photoPickCell
            photoPickCell.initialize()
            photoPickCell.photoProtocol = self
            self.registerSteps![0] = photoPickCell // init
            return photoPickCell
        }
        else if self.registerSteps![count] is RegisterInformationCell {
            let informationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "informationRegisterCell", for: indexPath) as! RegisterInformationCell
            validation = informationCell
            self.registerSteps![1] = informationCell // init
            informationCell.initialize(informationProtocol: self)
            return informationCell
        }
        else if self.registerSteps![count] is RegisterBirthDayCell {
            let birthDayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "registerBirthDayCell", for: indexPath) as! RegisterBirthDayCell
            birthDayCell.initialize(birthDayCellProtocol: self)
            validation = birthDayCell
            self.registerSteps![2] = birthDayCell // init
            return birthDayCell
        }
        else if self.registerSteps![count] is RegisterGenderCell {
            let genderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "registerGenderCell", for: indexPath) as! RegisterGenderCell
            genderCell.initialize(genderPickerCellProtocol: self)
            validation = genderCell
            self.registerSteps![3] = genderCell // init
            return genderCell
        }
        else {
            let otpCell = collectionView.dequeueReusableCell(withReuseIdentifier: "otpRegisterCell", for: indexPath) as! RegisterOTPCell
            validation = otpCell
            self.registerSteps![4] = otpCell // init
            return otpCell
        }
    }
    
    /**
     - Hücrelerin en ve boy oranlarını collectionView yapısının en ve boy oranı ile bire bir biçimde belirliyorum.
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.registerCollectionView.frame.width, height: self.registerCollectionView.frame.height)
        }
    
    /**
     - Kullanıcı yeni bir adıma geçiş yaptığında (yatayda scroll edildiğinde ve bu scroll yeni ekranı kapsıyorsa) bu fonksiyon içerisinde gerçekleşmesini istediğim yapılar çalışıyor.
     - Bu yapılar tamamen ui kısmı (progress, hide or visible) güncelleme amacı ile oluşturuldu.
     */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let horizontalCenter = width / 2
            let page = Int(offSet + horizontalCenter) / Int(width) // kullanıcının hangi kayıt sayfasında olduğunun bilgisi
        
            /**
             Kullanıcının bulunduğu sayfaya göre yapılacaklar 3 farklı durumda ele alınıyor. Kullanıcı birinci kayıt ekranında, kullanıcı baş ve son arasında ve kullanıcı son adımda.
             */
        self.currentRegisterClass = page
        if page == 0 {
            self.registerBackButton.isHidden = true
        }else if page < self.registerSteps!.count-1 && page > 0 {
            self.registerNextButton.setTitle("Devam", for: UIControl.State.normal)
            self.registerBackButton.isHidden = false
        }else {
            self.registerNextButton.setTitle("Onayla", for: UIControl.State.normal)
        }
        
        // ProgressView
        self.registerStepLabel.text = "\(page+1)/\(self.registerSteps!.count)"
        self.registerProgressView.progress = Float(page + 1) / Float(self.registerSteps!.count)
        
        let rgClass = self.registerSteps![page]
        
        if rgClass is RegisterPhotoPickCell {
            self.validation = rgClass as! RegisterPhotoPickCell
        }
        else if rgClass is RegisterInformationCell {
            self.validation = rgClass as! RegisterInformationCell
        }
        else if rgClass is RegisterBirthDayCell {
            self.validation = rgClass as! RegisterBirthDayCell
        }
        else if rgClass is RegisterGenderCell {
            self.validation = rgClass as! RegisterGenderCell
        }else {
            self.validation = rgClass as! RegisterOTPCell
        }

        }
    
}

/**
 - Bu extension ile kullanıcının kayıt adımlarında hücreler ile arasında geçen dinamik olayları algılamamı sağlayacak protokolleri kalıtım olarak alıyorum.
 - UIImagePickerControllerDelegate ve UINavigationControllerDelegate protocolleri kullanıcıdan resim alabilmek adına kalıtım alındılar.
 */
extension RegisterVC : RegisterPhotoCellProtocol, RegisterInformationCellProtocol, RegisterBirthDayCellProtocol, RegisterGenderCellProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    /**
     - Kullanıcı fotoğraf seçim aşamasında ImageView'a tıklarsa çalışacak method.
     - Bu method ile kullanıcıdan resim istemek için ilgili pencerenin açılmasını sağlıyorum.
     - RegisterVC sınıfında nullable yapıda olan photoPickCell sınıfınının referansını isteği yapan sınıftan gelen referans ile yetkilendiriyorum, böylelikle fotoğraf seçildiği zaman seçilen fotoğrafı hücre sınıfına geri gönderebileceğim.
     */
    func photoOnClick(registerCell: RegisterPhotoPickCell) {
        
        self.registerPhotoPickCell = registerCell // yetkilendirme
        
        let imagePicker = UIImagePickerController()
        // Fotoğraf kaynağı kullanılabilir mi değil mi ?
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false

                // sayfanın açılması.
                present(imagePicker, animated: true, completion: nil)
            }
    }
    
    /**
     Kullanıcı bir resim seçmesi için açılan ekran ile etkileşime geçtiği anda aşağıdaki method çalışacak.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.dismiss(animated: true, completion: nil) // Kullanıcı resim seçince seçim ekranını kapat.
        
        /**
         Kullanıcı resim seçtiğinde bir casting işlemi gerçekleştiriyorum. Eğer resim başarılı ile alındıysa bir sonraki adımda hücre sınıfına UI kısmı güncellemesi için resmi ileteceğim.
         */
        guard let image = info[.originalImage] as? UIImage else {
           print("Expected a dictionary containing an image, but was provided the following: \(info)")
            return
        }
        // Alınan resmi hem hücre sınıfına hemde interactor sınıfına iletiyorum.
        self.registerPhotoPickCell?.onPhotoUpload(image: image)
        self.presenter?.setUserImage(image: image)
    }
    
    /**
     Bu kısımda kullanıcı kendine ait önemli bilgileri (username,mail,password) girdiği ve bu adımı geçmeye çalıştığı zaman eğer bilgiler validation kısmından geçiyor ise interactor katmanına iletilirler.
     */
    func informationToView(username: String, userMail: String, userPassword: String) {
        self.presenter?.setUserInfo(username: username, userMail: userMail, userPassword: userPassword)
    }
    /**
     Kullanıcı doğum tarihinini kayıt sınıfından alıp internactor sınıfına iletiyorum.
     */
    func birthDaySelected(date: String) {
        self.presenter?.setUserBirthDay(date: date)
    }
    
    func genderSelected(gender: GenderType) {
        self.presenter?.setUserGender(gender: gender)
    }
}

/**
 CollectionView yapısını adım adım bir yapı haline getirebilmek adına bir extension oluşturdum. Böylelikle istediğim zaman ileri veya geri scroll edebiliyorum.
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
