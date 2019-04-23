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
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = false
        toolBar.tintColor = Globals.Colors.orangeColor
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString( "Done", comment: "done button"), style: UIBarButtonItem.Style.plain, target: target, action: mySelect)
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)], for: .normal)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}
