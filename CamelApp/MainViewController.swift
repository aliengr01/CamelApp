//
//  ViewController.swift
//  CamelApp
//
//  Created by Igor Ryazancev on 2/16/19.
//  Copyright © 2019 Igor Ryazancev. All rights reserved.
//

import UIKit
import UserNotifications

class MainViewController: UITableViewController {
    
    //MARK: - IBOutlets
    ////buttons
    @IBOutlet weak var fromButton: UIButton! {
        didSet {
            let count = defaults.integer(forKey: Globals.NotificationsKey.fromDate) == 0 ? 10 : defaults.integer(forKey: Globals.NotificationsKey.fromDate)
            fromButton.setTitle(String(count) + ":00 AM",
                                for: .normal)
        }
    }
    
    @IBOutlet weak var toButton: UIButton! {
        didSet {
            let count = defaults.integer(forKey: Globals.NotificationsKey.toDate) == 0 ? 10 : (defaults.integer(forKey: Globals.NotificationsKey.toDate) - 12)
            toButton.setTitle(String(count) + ":00 PM",
                                for: .normal)
        }
    }
    
    @IBOutlet weak var whiteColorButton: UIButton! {
        didSet {
            setColorButton(whiteColorButton, .white)
        }
    }
    @IBOutlet weak var orangeColorButton: UIButton!{
        didSet {
           setColorButton(orangeColorButton, Globals.Colors.orangeColor)
        }
    }
    @IBOutlet weak var blackColorButton: UIButton!{
        didSet {
           setColorButton(blackColorButton, .black)
        }
    }
    @IBOutlet var remindButtons: [UIButton]!
    @IBOutlet var periodButtons: [UIButton]!
    
    ////Labels
    @IBOutlet weak var countNotificationsLabel: UILabel!
    @IBOutlet weak var descNotifLabel: UILabel!
    @IBOutlet var explainingLabels: [UILabel]!
    @IBOutlet weak var remindesCountLabel: UILabel!
    @IBOutlet weak var periodCountLabel: UILabel!
    
    ////Views
    @IBOutlet var separateViews: [UIView]!
    
    private let pickerYPosition: CGFloat = {
        switch UIScreen.main.bounds.height {
        case 568:
            return 260.0
        case 667:
            return 180.0
        case 736:
            return 110.0
        case 812:
            return 80.0
        default:
            return 0
        }
    }()
    
    private var saveButton: UIBarButtonItem!
    
    //MARK: - properties
    private let defaults = UserDefaults.standard //UserDefaults propertie
    lazy var stack = UIStackView() //stack for date picker and toolbar, function: "setDatePicker()"
    
    ////picker view components
    var pickerArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var picker = UIPickerView()
    
    //MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !defaults.bool(forKey: "first") {
            defaults.set(6, forKey: Globals.NotificationsKey.remindNotif)
            defaults.set(1, forKey: Globals.NotificationsKey.periodNotif)
            defaults.set(true, forKey: "first")
        }
        
        addTargets() //Set targets to edit theme buttons
        setTheme() //Set theme color for app
        
        remindesCountLabel.text = "\(self.defaults.integer(forKey: Globals.NotificationsKey.remindNotif))"
        periodCountLabel.text   = "\(self.defaults.integer(forKey: Globals.NotificationsKey.periodNotif))"
        
        if defaults.integer(forKey: Globals.NotificationsKey.fromDate) == 0 {
            defaults.set(10, forKey: Globals.NotificationsKey.fromDate)
        }
        
        if defaults.integer(forKey: Globals.NotificationsKey.toDate) == 0 {
            defaults.set(22, forKey: Globals.NotificationsKey.toDate)
        }
        
        setupNavigation()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if defaults.bool(forKey: "WasChangedValues") {
            setNotifications() //Set UserNotifications
        }
        
        if defaults.integer(forKey: Globals.AppThemeKey.statusBarColor) == 1 {
            self.setStatusBarStyle(.lightContent)
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        countNotificationsLabel.text = String(defaults.integer(forKey: Globals.NotificationsKey.notifCount))
    }
    
    func setupNavigation(_ show: Bool = false) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = Globals.Colors.orangeColor
        saveButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: "Save") , style: .plain, target: self, action: #selector(addTapped))
        saveButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: .bold),
                                           NSAttributedString.Key.foregroundColor: defaults.colorForKey(key: Globals.AppThemeKey.saveButtonTheme) ?? Globals.Colors.orangeColor],
                                          for: .normal)
        
        if show {
            navigationItem.rightBarButtonItem = saveButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func addTapped() {
        defaults.set(false, forKey: "WasChangedValues")
        setNotifications()
        setupNavigation(false)
    }
    
    
    //MARK: - Notifications
    private func setNotifications() {
        let queue = OperationQueue()
        
        queue.addOperation {
            NotificationManager.shared.removeAllNotifications()
        }
        
        queue.addOperation {
            NotificationManager.shared.showRequestAlert(with: { [weak self] in
                NotificationManager.shared.scheduleNotification(identifier: "indentifier0",
                                                                period: self?.defaults.integer(forKey: Globals.NotificationsKey.periodNotif) ?? 1,
                                                                remindNotif: self?.defaults.integer(forKey: Globals.NotificationsKey.remindNotif) ?? 6,
                                                                startHour: self?.defaults.integer(forKey: Globals.NotificationsKey.fromDate) ?? 10,
                                                                endHour: self?.defaults.integer(forKey: Globals.NotificationsKey.toDate) ?? 22,
                                                                minutes: 0,
                                                                first: true)
                
                NotificationManager.shared.notificationCenter.delegate = self
            })
        }
        
    }
    
    ////Notification if was changed values
    private func changedValues() {
        defaults.set(true, forKey: "WasChangedValues")
        setupNavigation(true)
    }
    
    //MARK: - Help functions
    private func addTargets() {
        
        whiteColorButton.addTarget(self,  action: #selector(whiteButtonTapped),  for: .touchUpInside)
        orangeColorButton.addTarget(self, action: #selector(orangeButtonTapped), for: .touchUpInside)
        blackColorButton.addTarget(self,  action: #selector(blackButtonTapped),  for: .touchUpInside)
        fromButton.addTarget(self,  action: #selector(fromButtonTapped(_:)), for: .touchUpInside)
        toButton.addTarget(self,    action: #selector(toButtonTapped(_ :)),  for: .touchUpInside)
        
        remindButtons[0].addTarget(self, action: #selector(remindTapped(_:)), for: .touchUpInside)
        remindButtons[1].addTarget(self, action: #selector(remindTapped(_:)), for: .touchUpInside)
        
        periodButtons[0].addTarget(self, action: #selector(periodTapped(_:)), for: .touchUpInside)
        periodButtons[1].addTarget(self, action: #selector(periodTapped(_:)), for: .touchUpInside)
        
    }
    
    //MARK: - @objc targets
    lazy var remindCount = defaults.integer(forKey: Globals.NotificationsKey.remindNotif)
    lazy var periodCount = defaults.integer(forKey: Globals.NotificationsKey.periodNotif)
    @objc private func remindTapped(_ sender: UIButton) {
        remindCount = sender.tag == 0 ? remindCount - 1 : remindCount + 1
        if remindCount >= 1 {
            if remindCount <= periodCount * 6 {
                remindesCountLabel.text = String(remindCount)
            } else {
                remindCount = periodCount * 6
            }
        } else {
            remindCount = 1
        }
        
        defaults.set(remindCount, forKey: Globals.NotificationsKey.remindNotif)
        changedValues()
    }
    
    
    @objc private func periodTapped(_ sender: UIButton) {
        
        periodCount = sender.tag == 0 ? periodCount - 1 : periodCount + 1
        let maxCount = defaults.integer(forKey: Globals.NotificationsKey.toDate) - defaults.integer(forKey: Globals.NotificationsKey.fromDate)
        
        if periodCount >= 1 && periodCount <= maxCount {
            periodCountLabel.text = String(periodCount)
            
        } else if periodCount > maxCount {
            periodCount = maxCount
            
        } else {
            periodCount = 1
        }
        
        defaults.set(periodCount, forKey: Globals.NotificationsKey.periodNotif)
        changedValues()
    }
    
    @objc private func datePickerChanged(_ picker: UIDatePicker) {
        
        let title = converteDate(date: picker.date)
        let defaultsTitle = Int(converteDate(date: picker.date, isDefaults: true))
        
        if fromButton.isSelected {
            fromButton.setTitle(title, for: .normal)
            defaults.set(defaultsTitle, forKey: Globals.NotificationsKey.fromDate)
            
        } else {
            toButton.setTitle(title, for: .normal)
            defaults.set(defaultsTitle, forKey: Globals.NotificationsKey.toDate)
        }
        
    }
    
    @objc private func dismissPicker() {
        tableView.isScrollEnabled = true
        setDefaultButtonState(fromButton)
        setDefaultButtonState(toButton)
        animatePicker(false)
        changedValues()
    }
    
    @objc private func fromButtonTapped(_ sender: UIButton) {
        guard !toButton.isSelected else { return }
        setDateButtonsState(sender)
        
    }
    
    @objc private func toButtonTapped(_ sender: UIButton) {
        guard !fromButton.isSelected else { return } 
        setDateButtonsState(sender)
        
    }
    
    @objc private func whiteButtonTapped() {
        self.setStatusBarStyle(.default)
        defaults.setColor(color: .white, forKey: Globals.AppThemeKey.mainThemeKey)
        defaults.setColor(color: .black, forKey: Globals.AppThemeKey.labelsThemeKey)
        defaults.setColor(color: Globals.Colors.orangeColor, forKey: Globals.AppThemeKey.viewsThemeKey)
        defaults.setColor(color: Globals.Colors.orangeColor, forKey: Globals.AppThemeKey.countNotifLabel)
        defaults.setColor(color: .black, forKey: Globals.AppThemeKey.descNotifLabel)
        defaults.setColor(color: .black, forKey: Globals.AppThemeKey.fromButtonTheme)
        defaults.setColor(color: .black, forKey: Globals.AppThemeKey.toButtonTheme)
        defaults.set(false, forKey: Globals.AppThemeKey.plusMinusThemeKey)
        defaults.set(0, forKey: Globals.AppThemeKey.statusBarColor)
        defaults.setColor(color: Globals.Colors.orangeColor, forKey: Globals.AppThemeKey.saveButtonTheme)
        
        setTheme()
        
    }
    
    @objc private func orangeButtonTapped() {
        self.setStatusBarStyle(.lightContent)
        defaults.setColor(color: Globals.Colors.orangeColor, forKey: Globals.AppThemeKey.mainThemeKey)
        defaults.setColor(color: .black, forKey: Globals.AppThemeKey.labelsThemeKey)
        defaults.setColor(color: .white, forKey: Globals.AppThemeKey.viewsThemeKey)
        defaults.setColor(color: .black, forKey: Globals.AppThemeKey.countNotifLabel)
        defaults.setColor(color: .white, forKey: Globals.AppThemeKey.descNotifLabel)
        defaults.setColor(color: .white, forKey: Globals.AppThemeKey.fromButtonTheme)
        defaults.setColor(color: .white, forKey: Globals.AppThemeKey.toButtonTheme)
        defaults.set(true, forKey: Globals.AppThemeKey.plusMinusThemeKey)
        defaults.set(1, forKey: Globals.AppThemeKey.statusBarColor)
        defaults.setColor(color: .white, forKey: Globals.AppThemeKey.saveButtonTheme)
        
        setTheme()
        
    }
    
    @objc private func blackButtonTapped() {
        self.setStatusBarStyle(.lightContent)
        defaults.setColor(color: .black, forKey: Globals.AppThemeKey.mainThemeKey)
        defaults.setColor(color: .white, forKey: Globals.AppThemeKey.labelsThemeKey)
        defaults.setColor(color: Globals.Colors.orangeColor, forKey: Globals.AppThemeKey.viewsThemeKey)
        defaults.setColor(color: Globals.Colors.orangeColor, forKey: Globals.AppThemeKey.countNotifLabel)
        defaults.setColor(color: .white, forKey: Globals.AppThemeKey.descNotifLabel)
        defaults.setColor(color: .white, forKey: Globals.AppThemeKey.fromButtonTheme)
        defaults.setColor(color: .white, forKey: Globals.AppThemeKey.toButtonTheme)
        defaults.set(false, forKey: Globals.AppThemeKey.plusMinusThemeKey)
        defaults.set(1, forKey: Globals.AppThemeKey.statusBarColor)
        defaults.setColor(color: Globals.Colors.orangeColor, forKey: Globals.AppThemeKey.saveButtonTheme)
        
        setTheme()
    }
}

//MARK: - Decorate functions
extension MainViewController {
    private func setColorButton(_ button: UIButton, _ color: UIColor) {
        button.backgroundColor      = color
        button.layer.borderWidth    = 2.0
        button.layer.borderColor    = UIColor.lightGray.cgColor
        button.layer.cornerRadius   = button.frame.height/2
        button.layer.masksToBounds  = true
    }
    
    private func setBorderForButtons(_ button: UIButton) {
        let borderColor = defaults.colorForKey(key: Globals.AppThemeKey.viewsThemeKey)?.cgColor ?? Globals.Colors.orangeColor.cgColor
        button.layer.borderColor = borderColor
        button.layer.borderWidth = 3.0
    }
    
    private func setPlusMinusButtons(_ plusImage: String, _ minusImage: String) {
        remindButtons[0].setImage(UIImage(named: minusImage),   for: .normal)
        remindButtons[1].setImage(UIImage(named: plusImage),    for: .normal)
        periodButtons[0].setImage(UIImage(named: minusImage),   for: .normal)
        periodButtons[1].setImage(UIImage(named: plusImage),    for: .normal)
    }
    
    private func setTheme() {
        UIView.animate(withDuration: 0.8) {
            ////main background color
            self.tableView.backgroundColor = self.defaults.colorForKey(key: Globals.AppThemeKey.mainThemeKey) ?? .white
            
            ////background color for separate views and explaining labels
            for view in self.separateViews {
                view.backgroundColor = self.defaults.colorForKey(key: Globals.AppThemeKey.viewsThemeKey) ?? Globals.Colors.orangeColor
            }
            
            for label in self.explainingLabels {
                label.textColor = self.defaults.colorForKey(key: Globals.AppThemeKey.labelsThemeKey) ?? .black
            }
            
            ////border color for "to" "from" buttons
            self.setBorderForButtons(self.fromButton)
            self.setBorderForButtons(self.toButton)
            
            ////set images for "plus" and "minus" buttons
            let plusImage  = self.defaults.bool(forKey: Globals.AppThemeKey.plusMinusThemeKey) ? "blackPlusButton" : "plusButton"
            let minusImage = self.defaults.bool(forKey: Globals.AppThemeKey.plusMinusThemeKey) ? "minusBlackButton" : "minusButton"
            self.setPlusMinusButtons(plusImage, minusImage)
            
            ////set notification labels and count labels
            self.countNotificationsLabel.textColor = self.defaults.colorForKey(key: Globals.AppThemeKey.countNotifLabel) ?? Globals.Colors.orangeColor
            self.descNotifLabel.textColor          = self.defaults.colorForKey(key: Globals.AppThemeKey.descNotifLabel) ?? .black
            self.periodCountLabel.textColor        = self.defaults.colorForKey(key: Globals.AppThemeKey.descNotifLabel) ?? .black
            self.remindesCountLabel.textColor      = self.defaults.colorForKey(key: Globals.AppThemeKey.descNotifLabel) ?? .black
            self.fromButton.setTitleColor(self.defaults.colorForKey(key: Globals.AppThemeKey.fromButtonTheme) ?? .black, for: .normal)
            self.toButton.setTitleColor(self.defaults.colorForKey(key: Globals.AppThemeKey.toButtonTheme) ?? .black, for: .normal)
        }
        
    }
  
}

//MARK: - Date labels and date picker setup functions
extension MainViewController {
    private func setDateButtonsState(_ button: UIButton) {
        button.isSelected.toggle()
        if button.isSelected {
            button.backgroundColor = Globals.Colors.orangeColor
            button.setTitleColor(.black, for: .selected)
            createPickerView(with: button.tag)
            if button.tag == 0 {
                picker.selectRow(defaults.integer(forKey: Globals.NotificationsKey.fromDate) - 1, inComponent: 0, animated: true)
            } else {
                picker.selectRow(defaults.integer(forKey: Globals.NotificationsKey.toDate) - 13, inComponent: 0, animated: true)
            }
        } else {
            button.backgroundColor = .clear
            dismissPicker()
        }
    }
    
    private func setDefaultButtonState(_ button: UIButton) {
        button.backgroundColor = .clear
        button.isSelected = false
        button.setTitleColor(self.defaults.colorForKey(key: Globals.AppThemeKey.descNotifLabel) ?? .black, for: .normal)
    }
    
    private func animatePicker(_ show: Bool) {
        let lastRow = self.tableView.numberOfRows(inSection: 0) - 1
        if show {
            self.tableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: true)
        }
        UIView.animate(withDuration: 0.3, animations: {
            if !show {
                self.tableView.scrollToRow(at: IndexPath(row: lastRow - 1, section: 0), at: .bottom, animated: false)
            }
            self.stack.frame.origin.y = self.view.frame.maxY - (show ? self.stack.frame.height - 120 : 0) + self.pickerYPosition
        }) { (_) in
            if !show {
                self.stack.removeFromSuperview()
            }
        }
    }
    
    private func converteDate(date: Date, isDefaults: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        if isDefaults {
            dateFormatter.dateFormat = "HH"
            dateFormatter.locale = Locale(identifier: "da_DK")
        }

        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
}

//MARK: - custon picker view
extension MainViewController {
    private func createPickerView(with tag: Int) {
        picker.tag = tag
        picker.delegate = self
        picker.dataSource = self
        picker.tintColor = Globals.Colors.orangeColor
        picker.backgroundColor = UIColor.black
        picker.setValue(Globals.Colors.orangeColor, forKey: "textColor")
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(dismissPicker), self)
        
        stack = UIStackView()
        stack.frame = CGRect(x: 0, y: view.bounds.maxY, width: view.bounds.width, height: 260)
        stack.axis  = .vertical
        stack.addArrangedSubview(toolBar)
        stack.addArrangedSubview(picker)
        
        tableView.isScrollEnabled = false
        self.view.addSubview(stack)
        animatePicker(true)
    }
}

//MARK: - custon picker view
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 12
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return pickerArray[row]
        case 1:
            return "00"
        default:
            return picker.tag == 0 ? "AM" : "PM"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            if fromButton.isSelected {
                fromButton.setTitle(pickerArray[row] + ":00 AM", for: .normal)
                defaults.set(Int(pickerArray[row]), forKey: Globals.NotificationsKey.fromDate)
                
            } else {
                let timeInt = (Int(pickerArray[row]) ?? 0) + 12
                toButton.setTitle(pickerArray[row] + ":00 PM", for: .normal)
                defaults.set(timeInt, forKey: Globals.NotificationsKey.toDate)
            }
        default:
            return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return setLabelForPicker(row, component)
    }
    
    private func  setLabelForPicker(_ row: Int, _ component: Int) -> UILabel {
        var label: UILabel
        
        if let v = view as? UILabel {
            label = v
        } else {
            label = UILabel()
        }
        
        label.textColor = Globals.Colors.orangeColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 21)
        
        switch component {
        case 0:
            label.text = pickerArray[row]
        case 1:
             label.text = "00"
        default:
            label.text = picker.tag == 0 ? "AM" : "PM"
        }
        
        return label
    }
}

//MARK: - UNUserNotificationCenterDelegate
extension MainViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        viewWillLayoutSubviews()
    }
    
}

extension UIViewController {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
        }
    }
}
