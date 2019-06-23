//
//  SubscriptionsTableViewController.swift
//  CamelApp
//
//  Created by Igor Ryazancev on 5/9/19.
//  Copyright © 2019 Igor Ryazancev. All rights reserved.
//

import UIKit

class SubscriptionsTableViewController: UITableViewController {
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var oneMonthView: UIView! {
        didSet {
            setView(oneMonthView)
        }
    }
    @IBOutlet weak var threeMonthBigLabel: UILabel!
    @IBOutlet weak var threemonthLabel: UILabel!
    @IBOutlet weak var threeMonthView: UIView! {
        didSet {
            setView(threeMonthView)
        }
    }
    @IBOutlet weak var allBigLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var allView: UIView! {
        didSet {
            setView(allView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        setupPurchase()
        setupGestures()
        
    }
    
    var options: [Subscription]? {
        didSet {
           setupButtons()
        }
    }
    
    @IBAction func privacyAction(_ sender: UIButton) {
        if let url = URL(string: "https://www.freeprivacypolicy.com/privacy/view/86baa6f86203b73fecdb9a180c51070c") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func termsAction(_ sender: Any) {
        if let url = URL(string: "https://policies.google.com/terms") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func restoreAction(_ sender: UIButton) {
        SubscriptionService.shared.restorePurchases()
    }
    
    private func purchase(_ index: Int) {
        guard let option = options?[index] else { return }
        SubscriptionService.shared.purchase(subscription: option)
    }
    
}
//MARK: - Setups
private extension SubscriptionsTableViewController {
    func setupPurchase() {
        options = SubscriptionService.shared.options
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOptionsLoaded(notification:)),
                                               name: SubscriptionService.optionsLoadedNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissController(notification:)),
                                               name: SubscriptionService.dissmissNotification,
                                               object: nil)
    }
    
    func setupGestures() {
        let oneMonthTap  = UITapGestureRecognizer(target: self, action: #selector(oneMonthTapped))
        let threeMonthTap  = UITapGestureRecognizer(target: self, action: #selector(threeMonthTapped))
        let allMonthTap  = UITapGestureRecognizer(target: self, action: #selector(allMonthTapped))
        
        oneMonthView.isUserInteractionEnabled = true
        threeMonthView.isUserInteractionEnabled = true
        allView.isUserInteractionEnabled = true
        
        oneMonthView.addGestureRecognizer(oneMonthTap)
        threeMonthView.addGestureRecognizer(threeMonthTap)
        allView.addGestureRecognizer(allMonthTap)
    }
}

//MARK: - Help functions
private extension SubscriptionsTableViewController {
    func setView(_ monthView: UIView) {
        monthView.backgroundColor = UIColor.clear
        monthView.layer.borderColor = Globals.Colors.orangeColor.cgColor
        monthView.layer.borderWidth = 2.0
    }
    
    func setupButtons() {
        threeMonthBigLabel.text = "\(options?[1].formattedPrice ?? "") / 3 Month"
//        let price = (options?[1].product.price.doubleValue ?? 4.99) / 3
//        let cutPrice = Double(round(100*price)/100)
//        threemonthLabel.text = "at \(cutPrice)/mo."
        allBigLabel.text = "\(options?[2].formattedPrice ?? "") / One-time payment"
    }
}

//MARK: - Actions
private extension SubscriptionsTableViewController {
    @objc func handleOptionsLoaded(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.options = SubscriptionService.shared.options
        }
    }
    
    @objc func dismissController(notification: Notification) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func oneMonthTapped() {
        purchase(0)
    }
    
    @objc func threeMonthTapped() {
        purchase(1)
    }
    
    @objc func allMonthTapped() {
        purchase(2)
    }
}
