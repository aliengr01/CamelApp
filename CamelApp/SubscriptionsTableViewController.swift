//
//  SubscriptionsTableViewController.swift
//  CamelApp
//
//  Created by Igor Ryazancev on 5/9/19.
//  Copyright © 2019 Igor Ryazancev. All rights reserved.
//

import UIKit

class SubscriptionsTableViewController: UITableViewController {
    @IBOutlet weak var oneMonthView: UIView! {
        didSet {
            setView(oneMonthView)
        }
    }
    @IBOutlet weak var threeMonthView: UIView! {
        didSet {
            setView(threeMonthView)
        }
    }
    @IBOutlet weak var allView: UIView! {
        didSet {
            setView(allView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

//MARK: - Help functions
private extension SubscriptionsTableViewController {
    func setView(_ monthView: UIView) {
        monthView.backgroundColor = UIColor.clear
        monthView.layer.borderColor = Globals.Colors.orangeColor.cgColor
        monthView.layer.borderWidth = 2.0
    }
}
