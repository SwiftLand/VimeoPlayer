//
//  UIViewControllerEx.swift
//  VimoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import UIKit

extension UIViewController : StoryboardIdentifiable {}
extension UIViewController{
    
    func popAlert(title:String,meesage:String,BtnText:String? = nil,onBtnPress:@escaping (UIAlertAction)->()){
        let alert = UIAlertController(title: title, message: meesage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: BtnText ?? StringResource.get(.okay),
                                      style: UIAlertAction.Style.default, handler:onBtnPress))
        alert.addAction(UIAlertAction(title: StringResource.get(.cancel), style: UIAlertAction.Style.cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
}
