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
    
    // Kayıt sınıfları
    var registerPhotoPickCell:RegisterPhotoPickCell?
    
    var validation:ValidationProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()

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
       let current = findIndex(list: registerCollectionView) // kullanıcının kayıt kısmında hangi adımda olduğu bilgisini veriyor.
        if current != 2 {
            registerCollectionView.scrollToNextItem() // Bir sonraki adıma geç.
            let response = validation?.validate()
            print(response!.message!)
        }else {
            performSegue(withIdentifier: "registerToHome", sender: nil)
        }
    }
    /**
     - Kullanıcı kayıt kısmında eğer birinci adımda değilse bir önceki adıma dönmek için bu butonu kullanır.
     */
    
    @IBAction func registerBackButton(_ sender: Any) {
        let current = findIndex(list: registerCollectionView)
        
        if current != 0 {
            registerCollectionView.scrollToPreviousItem()
        }
    }
}

extension RegisterVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    /**
     Kullanıcının kayıt kısmı 3 farklı adımdan oluştuğu ve bu sayı bir sabit olduğu için direkt olarak 3 döndürüyorum.
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    /**
     - 0. index'de kullanıcı fotoğraf seçimi yapıyor.
     - 1. index'de kullanıcı kendisi hakkında gereken bilgileri veriyor. (Kullancı adı, e-mail, doğum tarihi vb.)
     - 2. index'de kullanıcının vermiş olduğu iletişim adresinin doğruluğu kontrol ediliyor.
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        if indexPath.row == 0 {
            let photoPickCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoPickRegisterCell", for: indexPath) as! RegisterPhotoPickCell
            validation = photoPickCell
            photoPickCell.initialize()
            photoPickCell.photoProtocol = self
            return photoPickCell
        }
        else if indexPath.row == 1 {
            let informationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "informationRegisterCell", for: indexPath) as! RegisterInformationCell
            validation = informationCell
            return informationCell
        }else {
            let otpCell = collectionView.dequeueReusableCell(withReuseIdentifier: "otpRegisterCell", for: indexPath) as! RegisterOTPCell
            validation = otpCell
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
            let page = Int(offSet + horizontalCenter) / Int(width)
            
        if page == 0 {
            self.registerProgressView.progress = 0.3
            self.registerStepLabel.text = "1/3"
            self.registerNextButton.setTitle("Devam", for: UIControl.State.normal)
            self.registerBackButton.isHidden = true
            
        }
        else if page == 1 {
            self.registerProgressView.progress = 0.6
            self.registerStepLabel.text = "2/3"
            self.registerNextButton.setTitle("Devam", for: UIControl.State.normal)
            self.registerBackButton.isHidden = false
        }
        else {
            self.registerProgressView.progress = 0.9
            self.registerStepLabel.text = "3/3"
            self.registerNextButton.setTitle("Onayla", for: UIControl.State.normal)
            self.registerBackButton.isHidden = false
        }
        }
    
    /**
     - Kullanıcının o anda hangi index'de bulunduğunu döndüren fonksiyon.
     - B
     */
    func findIndex(list:UICollectionView) -> Int{
        let asd = list.visibleCells
        if asd.last is RegisterPhotoPickCell {
            return 0
        }else if asd.last is RegisterInformationCell {
            return 1
        }
        else {
            return 2
        }
    }
}

/**
 - Bu extension ile kullanıcının kayıt adımlarında hücreler ile arasında geçen dinamik olayları algılamamı sağlayacak protokolleri kalıtım olarak alıyorum.
 - UIImagePickerControllerDelegate ve UINavigationControllerDelegate protocolleri kullanıcıdan resim alabilmek adına kalıtım alındılar.
 */
extension RegisterVC : RegisterPhotoCellProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        // resmi hücre sınıfına geri iletiyorum.
        self.registerPhotoPickCell?.onPhotoUpload(image: image)
    }
}

/**
 CollectionView yapısını adım adım bir yapı haline getirebilmek adına bir extension oluşturdum. Böylelikle istediğim zaman ileri veya geri scroll edebiliyorum.
 */
extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
