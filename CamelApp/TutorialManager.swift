//
//  TutorialManager.swift
//  CamelApp
//
//  Created by Igor Ryazancev on 4/25/19.
//  Copyright © 2019 Igor Ryazancev. All rights reserved.
//

import UIKit

protocol TutorialManagerDelegate: class {
    func tutorialManagerDidTappedNextButton(_ viewController: TutorialManager, with counter: Int)
}

class TutorialManager: UIViewController {
    private let nextButton = UIButton()
    private var explainLabel = UILabel()
    private(set) var nextCounter = 0
    
    private let topView = UIView()
    private let bottomView = UIView()
    
    private let attr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold),
                                                       NSAttributedString.Key.foregroundColor: Globals.Colors.orangeColor]
    //UIFont.systemFont(ofSize: 17, weight: .bold), | размер и шрифт текста туториал 
    
    weak var delegate: TutorialManagerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Lifecycle
extension TutorialManager {
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
}

//MARK: - Setups
private extension TutorialManager {
    func setup() {
        view.backgroundColor = .clear
        setupTopView()
        setupBottomView()
        setupButton()
        setupExplainLabel()
    }
    
    func setupTopView() {
        topView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        topView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(topView)
    }
    
    func setupBottomView() {
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        bottomView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(bottomView)
    }
    
    func setupButton() {
        nextButton.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 50, y: UIScreen.main.bounds.height - 70, width: 100, height: 35)
        nextButton.layer.borderColor = UIColor.white.cgColor
        nextButton.layer.borderWidth = 2.0
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.addSubview(nextButton)
    }
    
    func setupExplainLabel() {
        explainLabel.frame.size.width = UIScreen.main.bounds.width - 60
        explainLabel.textAlignment = .center
        explainLabel.numberOfLines = 0
        view.addSubview(explainLabel)
    }
}

//MARK: - Actions
private extension TutorialManager {
    @objc func nextTapped() {
        nextCounter += 1
        delegate?.tutorialManagerDidTappedNextButton(self, with: nextCounter)
    }
}

//MARK: - Public
extension TutorialManager {
    func changePosition(minYPosition: CGFloat, maxYPosition: CGFloat, explainYPosition: CGFloat, explainText: String) {
        topView.frame.origin.y = minYPosition - (UIScreen.main.bounds.height)
        bottomView.frame.origin.y = maxYPosition
        explainLabel.attributedText = NSAttributedString(string: explainText, attributes: attr)
        let labelHeight = textHeight(text: explainText, attributes: attr, containerWidth: UIScreen.main.bounds.width - 60)
        explainLabel.frame.size.height = labelHeight
        changePositionExplainLabel(with: explainYPosition)
    }
}

//MARK: - Private
private extension TutorialManager {
    func changePositionExplainLabel(with yPosition: CGFloat) {
        explainLabel.frame.origin.x = UIScreen.main.bounds.width / 2 - explainLabel.frame.width / 2
        explainLabel.frame.origin.y = yPosition - explainLabel.frame.height
    }
    
    func textHeight(text: String, attributes: [NSAttributedString.Key: Any], containerWidth: CGFloat) -> CGFloat {
        let bounds = CGSize(width: containerWidth, height: .greatestFiniteMagnitude)
        let textBounds = NSString(string: text).boundingRect(with: bounds, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return textBounds.height
    }
}
