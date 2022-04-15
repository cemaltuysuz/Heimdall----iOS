//
//  String+.swift
//  Logoo
//
//  Created by cemal tüysüz on 8.04.2022.
//

import Foundation

extension String {
    
    func toListByCharacter(_ char:String) -> [Self]{
        return self.components(separatedBy: char)
    }
    
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
    
    func convertStringToDictionary() -> [String:AnyObject]? {
       if let data = self.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
    }
}
