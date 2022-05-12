//
//  CustomTextField.swift
//  NewsApp
//
//  Created by Devansh Vyas on 10/05/22.
//

import UIKit

@objc protocol CustomTextFieldDelegate {
    @objc optional func mainViewTap(sender: CustomTextField)
    @objc optional func textDidChanged(sender: CustomTextField)
}

class CustomTextField: UIView {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var staticLabel: UILabel!
    weak var delegate: CustomTextFieldDelegate?
    var isSelected = false

    // MARK: - View Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    func sharedInit() {
        nibSetup(nibName: NibNames.CustomTextField)
        updateErrorLabel()
        updateColor()
        updateKeyboard()
    }

    func setValues(delegate: CustomTextFieldDelegate,
                   textFieldPlaceholder: String = "",
                   textFieldText: String = "",
                   isError: Bool = false,
                   errorText: String = "",
                   securedText: Bool = false,
                   isTextField: Bool = true,
                   keyboardType: KeyboardType = .defaultKeyboard,
                   isTopCornerRounded: Bool = false,
                   isBottomCornerRounded: Bool = false,
                   bgColor: UIColor = .white,
                   staticText: String? = nil,
                   enabled: Bool = true) {
        self.textFieldPlaceholder = textFieldPlaceholder
        self.delegate = delegate
        self.isError = isError
        self.errorText = errorText
        self.securedText = securedText
        self.isTextField = isTextField
        self.keyboardType = keyboardType
        self.textFieldText = textFieldText
        self.isTopCornerRounded = isTopCornerRounded
        self.isBottomCornerRounded = isBottomCornerRounded
        self.staticText = staticText
        self.enabled = enabled
        self.bgColor = bgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if isTopCornerRounded {
            roundCorners(corners: [.topLeft, .topRight], radius: 6)
            topConstraint.constant = 10
        }
        if isBottomCornerRounded {
            roundCorners(corners: [.bottomLeft, .bottomRight], radius: 6)
        }
    }

    func setText(_ value: String?) {
        textField.text = value
    }

    func isErrorShown(_ value: Bool = false, _ text: String = "", tableView: UITableView) {
        isError = value
        errorText = text
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    func isEmptyErrorShown(_ value: Bool = false, _ text: String = "", tableView: UITableView) {
        if value {
            isErrorShown(value, "Please enter \(self.textFieldPlaceholder).", tableView: tableView)
        }
    }

    // MARK: - Private setter helper
    func updateErrorLabel() {
        errorLabel.isHidden = !isError
        errorLabel.text = errorText
        if isError {
            topView.addLineToView(position: .bottom, color: .red)
        } else {
            topView.addLineToView(position: .bottom, color: #colorLiteral(red: 0.2999755442, green: 0.3599653244, blue: 0.4404251575, alpha: 0.8470588235))
        }
    }
    
    func updateColor() {
        mainView.backgroundColor = bgColor
    }

    func updateKeyboard() {
        textField.keyboardType = UIKeyboardType(rawValue: keyboardType.rawValue) ?? UIKeyboardType.asciiCapable
    }

    // MARK: - Inspectable properties
    @IBInspectable var textFieldPlaceholder: String = "" {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: textFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2999755442, green: 0.3599653244, blue: 0.4404251575, alpha: 0.8470588235)])
        }
    }

    @IBInspectable var textFieldText: String = "" {
        didSet {
            textField.text = textFieldText
        }
    }

    @IBInspectable var isError: Bool = false {
        didSet {
            updateErrorLabel()
        }
    }

    @IBInspectable var errorText: String = "" {
        didSet {
            updateErrorLabel()
        }
    }
    
    @IBInspectable var securedText: Bool = false {
        didSet {
            textField.isSecureTextEntry = securedText
        }
    }

    @IBInspectable var isTextField: Bool = true {
        didSet {
            textField.isEnabled = isTextField
        }
    }
    
    @IBInspectable var staticText: String? = nil {
        didSet {
            staticLabel.isHidden = staticText == nil
            staticLabel.text = staticText
        }
    }
    
    @IBInspectable var enabled: Bool = false {
        didSet {
            self.isUserInteractionEnabled = enabled
        }
    }

    var keyboardType: KeyboardType = .asciiCapable {
        didSet {
            updateKeyboard()
        }
    }

    @IBInspectable var isTopCornerRounded: Bool = false {
        didSet {
            layoutSubviews()
        }
    }

    @IBInspectable var isBottomCornerRounded: Bool = false {
        didSet {
            layoutSubviews()
        }
    }

    @IBInspectable var bgColor: UIColor = .white {
        didSet {
            updateColor()
        }
    }

    //Functions
    @IBAction func mainViewTapped(_ sender: Any) {
        delegate?.mainViewTap?(sender: self)
    }
    
    @IBAction func editingChange(_ sender: UITextField) {
        delegate?.textDidChanged?(sender: self)
    }
}

// keyboardTypes:-
enum KeyboardType: Int {
    case defaultKeyboard = 0  // Default type for the current input method.
    case asciiCapable = 1  // Displays a keyboard which can enter ASCII characters
    case numbersAndPunctuation = 2  // Numbers and assorted punctuation.
    case URL = 3  // A type optimized for URL entry (shows . / .com prominently).
    case numberPad = 4  // A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.
    case phonePad = 5  // A phone pad (1-9, *, 0, #, with letters under the numbers).
    case namePhonePad = 6  // A type optimized for entering a person's name or phone number.
    case emailAddress = 7  // A type optimized for multiple email address entry (shows space @ . prominently).
    case decimalPad = 8  // A number pad with a decimal point.
    case twitter = 9  // A type optimized for twitter text entry (easy access to @ #)
    case webSearch = 10 // A default keyboard type with URL-oriented addition (shows space . prominently).
    case asciiCapableNumberPad = 11 // A number pad (0-9) that will always be ASCII digits.
}
