//
//  CustomUITextField.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.04.2022.
//

import Foundation
import UIKit

@IBDesignable
class CustomUITextField : UITextField {
    
    var validate:Validatable?
    var realtimeCompare:CompareSettings? // key & value
    weak var customDelegate:CustomUITextFieldProtocol?
    
    
    // UITextField placeholder color
    @IBInspectable var placeHolderColor:UIColor = Color.gray500 ?? UIColor.darkGray {
        didSet {
            updatePlaceHolder()
        }
    }
    // UITextfield left image
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftView()
        }
    }
    // UITextfield left image tint color
    @IBInspectable var leftImageColor: UIColor = Color.black700 ?? UIColor.black {
        didSet {
           updateLeftView()
        }
    }
    // UITextField space between Left Image and Text
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    
    @IBInspectable var rightImageColor: UIColor = Color.black700 ?? UIColor.black {
        didSet {
           updateRightView()
        }
    }
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateRightView()
        }
    }
    var righButtonActive:Bool?
    
    override func awakeFromNib() {
        commonInit()
    }
    
    func commonInit(){
        addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        return textRect
    }
    
    func setValidate(_ validate:Validatable) {
        self.validate = validate
    }
    
    func setCompare(_ realtimeCompare:CompareSettings) {
        self.realtimeCompare = realtimeCompare
    }
}
// MARK: - Update UI Functions
extension CustomUITextField {
    func updateLeftView(){
        if let image = leftImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = leftImageColor
            
            let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
            iconContainer.addSubview(imageView)
            leftViewMode = .always
            leftView = iconContainer
        } else {
            leftViewMode = .never
            leftView = nil
        }
    }
    
    func updatePlaceHolder(){
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : placeHolderColor])
    }
    
    func updateRightView(){
        if let image = rightImage {
            rightViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: self.frame.width - 20, y: 5, width: 20, height: 20))
            imageView.contentMode = .scaleToFill
            imageView.image = image
            imageView.tintColor = rightImageColor
            // tap gesture
            imageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onRightButtonClick(_:)))
            imageView.addGestureRecognizer(tap)
            
            rightView = imageView
        } else {
            rightViewMode = .never
            rightView = nil
        }
    }
    
    @objc func onRightButtonClick(_ tapGesture:UITapGestureRecognizer) {
        let active = righButtonActive ?? false
        righButtonActive = !active
        customDelegate?.onRightButtonClick(self, isActive: !active)
    }
}

extension CustomUITextField : UITextFieldDelegate {
    
    @objc func textDidChange(_ textField:UITextField){
        if let text = textField.text {
            if let validate = validate {
                let result = validate.changeValueAndReValidate(value: text)
                customDelegate?.onValidateResult(self, validateResult: result)
                if result.isSuccess {
                    // TODO: VALIDATION SUCCESS
                    if let realtimeCompare = realtimeCompare {
                        doCompare(realtimeCompare)
                    }
                }
            }
        }
    }
    
    
    func doCompare(_ setting:CompareSettings){
        
    }
}


