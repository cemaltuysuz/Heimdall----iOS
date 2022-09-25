//
//  LGButton.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.09.2022.
//

import Foundation
import UIKit

class LGButton: UIButton{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI(){
        setRadius(6)
        backgroundColor = .black700
        setTitleColor(.white, for: .normal)
    }
    
    public func setButtonTitle(_ title:String?){
        setTitle(title, for: .normal)
    }
}
