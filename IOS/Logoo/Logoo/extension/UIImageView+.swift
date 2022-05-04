//
//  UIImageViewEx.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import Foundation
import Kingfisher
import UIKit
import ImageViewer_swift

extension UIImageView {
    
    func setImage(urlString:String?, radius:CGFloat? = nil, focustStatus:Bool = false){
        if let radius = radius {
            layer.masksToBounds = true
            layer.cornerRadius = radius
        }
        if let urlString = urlString, let url = URL(string: urlString) {
            let processor = DownsamplingImageProcessor(size: self.bounds.size)
            self.kf.indicatorType = .activity
            self.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    if focustStatus {
                        self.setupImageViewer()
                    }
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }else {
            print("Url error")
        }

    }
}


