//
//  PSBorderedTextField.swift
//  ephemera
//
//  Created by Pranjal Satija on 8/28/15.
//  Copyright © 2015 Pranjal Satija. All rights reserved.
//

import UIKit

class EBorderedTextField: UITextField, AlternateColorSchemeForPSBorderedTextField {
    var originalBackgroundColor: UIColor?
    @IBInspectable var alternateBackgroundColor: UIColor?
    
    var originalTextColor: UIColor?
    @IBInspectable var alternateTextColor: UIColor?
    
    @IBInspectable var placeholderColor: UIColor?
    var originalPlaceholderColor: UIColor?
    @IBInspectable var alternatePlaceholderColor: UIColor?
    
    @IBInspectable var borderColor: UIColor?
    var originalBorderColor: UIColor?
    @IBInspectable var alternateBorderColor: UIColor?
    
    var colorSchemeManager: ColorSchemeManager {
        get {
            return universalManager
        }
        
        set {
            if newValue.currentColorScheme == .Alternate {                
                self.backgroundColor = self.alternateBackgroundColor
                self.textColor = self.alternateTextColor
                self.borderColor = self.alternateBorderColor
                self.placeholderColor = self.alternatePlaceholderColor
            }
        }
    }
    
    var border: CALayer?
    
    ///this override sets the `originalBackgroundColor` property, and adds an NSNotificationCenter observer to listen for transitions
    override func awakeFromNib() {
        setUp()
    }
    
    ///this function sets all the properties that PSColorScheme needs to operate, and must be called manually if instantiating this view programmatically.
    func setUp() {
        self.originalBackgroundColor = self.backgroundColor
        self.originalTextColor = self.textColor
        self.originalPlaceholderColor = self.placeholderColor
        self.originalBorderColor = self.borderColor
        
        border = CALayer()
        border?.borderColor = borderColor?.CGColor
        border?.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, self.frame.size.height)
        border?.borderWidth = 1
        
        self.layer.addSublayer(border!)
        self.layer.masksToBounds = true
        
        if let placeholder = self.placeholder, color = self.originalPlaceholderColor {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName : color])
        }
        
        notificationCenter.addObserver(self, selector: "transition", name: colorSchemeNotificationName, object: nil)
    }
    
    ///this function determines which color scheme the view is in, and calls the appropriate animation method to update
    func transition() {
        if self.colorSchemeManager.currentColorScheme == .Main {
            switchToAlternate()
        }
            
        else {
            switchToMain()
        }
    }
    
    ///this function is a helper for `transition()`
    func switchToMain() {
        UIView.animateWithDuration(colorSchemeTransitionDuration) {
            self.backgroundColor = self.originalBackgroundColor
            self.textColor = self.originalTextColor
            self.border?.backgroundColor = self.originalBorderColor?.CGColor
            
            if let placeholder = self.placeholder, color = self.originalPlaceholderColor {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName : color])
            }
        }
    }
    
    ///this function is a helper for `transition()`
    func switchToAlternate() {
        UIView.animateWithDuration(colorSchemeTransitionDuration) {
            self.backgroundColor = self.alternateBackgroundColor
            self.textColor = self.alternateTextColor
            self.border?.backgroundColor = self.alternateBorderColor?.CGColor
            
            if let placeholder = self.placeholder, color = self.alternatePlaceholderColor {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName : color])
            }
        }
    }
    
    ///this function sets the placeholder and clears the field, as `setPlaceholder` is already taken
    func newPlaceholder(string: String) {
        if self.colorSchemeManager.currentColorScheme == .Main {
            if let color = self.originalPlaceholderColor {
                self.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName : color])
            }
        }
        
        else {
            if let color = self.alternatePlaceholderColor {
                self.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName : color])
            }
        }
        
        self.text = ""
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}