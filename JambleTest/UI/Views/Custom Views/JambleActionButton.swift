//
//  JambleActionButton.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 13/01/2024.
//

import UIKit
import Foundation

// MARK: - JambleActionButton

class JambleActionButton: UIButton {
    
    // MARK: - Custom Variables
    
    private var myConfiguration = UIButton.Configuration.filled()
    var linkedToMenuBehavior = false
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        myConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = .black
        background.cornerRadius = 16.0
        myConfiguration.background = background
        self.configuration = configuration
        self.setTitleColor(.white, for: .normal)
        
        // Add targets for touch events
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpOutside)
    }

    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Perform any additional layout customization
    }

    // MARK: - UIControl State Handling
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }

    // MARK: - Additional Customization
    
    func setCustomTitle(_ title: String) {
        myConfiguration.title = title
        self.configuration = myConfiguration
    }
    
    func setCustomImage(with image: UIImage, with padding: CGFloat, isMirror: Bool = false) {
        myConfiguration.image = image
        myConfiguration.imagePadding = padding
        if isMirror {
            self.semanticContentAttribute = .forceRightToLeft
        }
        self.configuration = myConfiguration
    }
    
    // MARK: - Button Pressed/Released
    
    @objc private func buttonPressed() {
        if !linkedToMenuBehavior {
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }
    }

    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
        }
    }
}
