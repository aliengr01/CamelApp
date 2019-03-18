//
//  UIToolBarExtension.swift
//  CamelApp
//
//  Created by Igor Ryazancev on 2/18/19.
//  Copyright © 2019 Igor Ryazancev. All rights reserved.
//

import UIKit

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector, _ target: Any) -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: target, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
        
    }
    
}
