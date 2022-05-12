//
//  SignUpTVC.swift
//  NewsApp
//
//  Created by Devansh Vyas on 10/05/22.
//

import UIKit

class SignUpTVC: UITableViewController {
    @IBOutlet weak var fullNameTexView: CustomTextField!
    @IBOutlet weak var usernameTexView: CustomTextField!
    @IBOutlet weak var emailTexView: CustomTextField!
    @IBOutlet weak var dobTexView: CustomTextField!
    @IBOutlet weak var mobileTexView: CustomTextField!
    @IBOutlet weak var passwordTexView: CustomTextField!
    
    var fullName: String?
    var username: String?
    var email: String?
    var dob: String?
    var mobile: String?
    var password: String?
    var datePickerView: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        fullNameTexView.setValues(delegate: self,
                                  textFieldPlaceholder: "Full Name",
                                  keyboardType: .namePhonePad,
                                  bgColor: .clear)
        usernameTexView.setValues(delegate: self,
                                  textFieldPlaceholder: "Username",
                                  bgColor: .clear)
        emailTexView.setValues(delegate: self,
                               textFieldPlaceholder: "Email",
                               keyboardType: .emailAddress,
                               bgColor: .clear)
        dobTexView.setValues(delegate: self,
                             textFieldPlaceholder: "Date of birth",
                             bgColor: .clear)
        passwordTexView.setValues(delegate: self,
                                  textFieldPlaceholder: "Password",
                                  securedText: true,
                                  bgColor: .clear)
        mobileTexView.setValues(delegate: self,
                                textFieldPlaceholder: "Mobile Number",
                                keyboardType: .numberPad,
                                bgColor: .clear)
        
        fullNameTexView.textField.delegate = self
        usernameTexView.textField.delegate = self
        
        addDatePickerForDOB()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        guard isValidInputs(),
        let vc = storyboard?.instantiateViewController(withIdentifier: "WelcomeTVC")
        else { return }
        
        storeData()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addDatePickerForDOB() {
        datePickerView = UIDatePicker()
        datePickerView.date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePickerView.backgroundColor = .white
        datePickerView.datePickerMode = .date
        dobTexView.textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dobTexView.textField.text = dateFormatter.string(from: sender.date)
        dob = dateFormatter.string(from: sender.date)
    }
    
    private func isValidInputs() -> Bool {
        var isValid = [Bool]()
        
        if fullName?.isEmpty ?? true {
            fullNameTexView.isEmptyErrorShown(true, tableView: tableView)
            isValid.append(false)
        } else {
            fullNameTexView.isErrorShown(false, tableView: tableView)
            isValid.append(true)
        }
        
        if username?.isEmpty ?? true {
            usernameTexView.isEmptyErrorShown(true, tableView: tableView)
            isValid.append(false)
        } else if !(username?.isValidUsername() ?? false) {
            usernameTexView.isErrorShown(true, "Please enter valid Username.", tableView: tableView)
            isValid.append(false)
        } else {
            usernameTexView.isErrorShown(false, tableView: tableView)
            isValid.append(true)
        }
        
        if dob?.isEmpty ?? true {
            dobTexView.isEmptyErrorShown(true,  tableView: tableView)
        }
        
        if mobile?.isEmpty ?? true {
            mobileTexView.isEmptyErrorShown(true,  tableView: tableView)
        } else if !(mobile?.isValidPhoneNumber() ?? false) {
            mobileTexView.isErrorShown(true, "Please enter valid Phone Number.",  tableView: tableView)
            isValid.append(false)
        } else {
            mobileTexView.isErrorShown(false, tableView: tableView)
            isValid.append(true)
        }
        
        if email?.isEmpty ?? true {
            emailTexView.isEmptyErrorShown(true,  tableView: tableView)
            isValid.append(false)
        } else if !(email?.isValidEmail() ?? false) {
            emailTexView.isErrorShown(true, "Please enter valid Email.", tableView: tableView)
            isValid.append(false)
        } else {
            emailTexView.isErrorShown(false, tableView: tableView)
            isValid.append(true)
        }
        
        if password?.isEmpty ?? true {
            passwordTexView.isEmptyErrorShown(true,  tableView: tableView)
            isValid.append(false)
        }  else if !(password?.isValidPassword() ?? false) {
            passwordTexView.isErrorShown(true, "Please enter valid password.", tableView: tableView)
            isValid.append(false)
        } else {
            passwordTexView.isErrorShown(false, tableView: tableView)
            isValid.append(true)
        }
        
        return !isValid.contains(false)
    }
    
    func storeData() {
        let user = User(fullName: fullName, username: username, email: email, dob: dob, mobile: mobile)
        UserDefaultHelper.shared.user = user
        let keychainHelper = KeychainHelper(service: "NewsApp", account: username!)
        try? keychainHelper.savePassword(password!)
    }
}

extension SignUpTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SignUpTVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == fullNameTexView.textField {
            if (fullNameTexView.textField.text?.count ?? 0) >= 50 {
                return false
            }
        } else if textField == usernameTexView.textField {
            if (usernameTexView.textField.text?.count ?? 0) >= 20 {
                return false
            }
        }
        return true
    }
}

extension SignUpTVC: CustomTextFieldDelegate {
    func textDidChanged(sender: CustomTextField) {
        switch sender {
        case fullNameTexView:
            fullName = fullNameTexView.textField.text ?? ""
        case usernameTexView:
            username = usernameTexView.textField.text
        case emailTexView:
            email = emailTexView.textField.text
        case dobTexView:
            dob = dobTexView.textField.text
        case mobileTexView:
            mobile = mobileTexView.textField.text
        case passwordTexView:
            password = passwordTexView.textField.text
        default:
            break
        }
    }
    
    func mainViewTap(sender: CustomTextField) {
        guard sender == dobTexView else { return }
    }
}
