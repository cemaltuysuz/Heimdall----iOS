//
//  RegisterPhotoPickCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit

class RegisterPhotoPickCell: UICollectionViewCell,ValidationProtocol {
    @IBOutlet weak var registerProfileImage: UIImageView!
    
var photoProtocol:RegisterPhotoCellProtocol?
    
    /**
     - Kullanıcı tarafından UIImageView için bir dokunuş gerçekleştiğinde bunu algılayabilmek adına bir selector yapısı kurdum.
     - Bu yapıyı bir initialize fonksiyonu içerisine yerleştirdim. ViewController kısmında bu hücreyi oluşturduktan sonra bu fonksiyonu çalıştırıyorum.
     */
    func initialize(){
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(photoClicked))
        registerProfileImage.isUserInteractionEnabled = true
        registerProfileImage.addGestureRecognizer(singleTap)
    }
    
    /**
     VC tarafdından doğrulama istendiği zaman bu fonksiyon polymorphism ile çalıştırılır.
     */
    func validate() -> ValidationResponse {
        return ValidationResponse(status: true, message: "foto doğrulama okey")
    }
    
    // Kullanıcı bir fotoğraf seçtiği zaman UI kısmı güncelle.
    func onPhotoUpload(image:UIImage){
        self.registerProfileImage.image = image
    }
    // ImageView bir tıklama aldığı zaman fotoğraf seçim ekranının açılması için VC kısmını tetikle.
    @objc
    func photoClicked(){
        photoProtocol?.photoOnClick(registerCell: self)
    }
}

// VC kısmının tıklanmalardan haberdar olması için oluşturduğum protocol yapısı.
protocol RegisterPhotoCellProtocol {
    func photoOnClick(registerCell:RegisterPhotoPickCell)
}
