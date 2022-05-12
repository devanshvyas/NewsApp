//
//  WelcomeTVC.swift
//  NewsApp
//
//  Created by Devansh Vyas on 12/05/22.
//

import UIKit

class WelcomeTVC: UITableViewController {
    
    @IBOutlet weak var fullNameTexView: CustomTextField!
    @IBOutlet weak var usernameTexView: CustomTextField!
    @IBOutlet weak var emailTexView: CustomTextField!
    @IBOutlet weak var dobTexView: CustomTextField!
    @IBOutlet weak var mobileTexView: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = UserDefaultHelper.shared.user
        fullNameTexView.setValues(delegate: self,
                                  textFieldPlaceholder: "Full Name",
                                  keyboardType: .namePhonePad,
                                  bgColor: .clear,
                                  staticText: user?.fullName,
                                  enabled: false)
        usernameTexView.setValues(delegate: self,
                                  textFieldPlaceholder: "Username",
                                  bgColor: .clear,
                                  staticText: user?.username,
                                  enabled: false)
        emailTexView.setValues(delegate: self,
                               textFieldPlaceholder: "Email",
                               keyboardType: .emailAddress,
                               bgColor: .clear,
                               staticText: user?.email,
                               enabled: false)
        dobTexView.setValues(delegate: self,
                             textFieldPlaceholder: "Date of birth",
                             bgColor: .clear,
                             staticText: user?.dob,
                             enabled: false)
        mobileTexView.setValues(delegate: self,
                                textFieldPlaceholder: "Mobile Number",
                                keyboardType: .numberPad,
                                bgColor: .clear,
                                staticText: user?.mobile,
                                enabled: false)
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        UserDefaultHelper.shared.user = nil
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpTVC") as! SignUpTVC
        let navigationController = UINavigationController(rootViewController: nextViewController)
        if let scene = UIApplication.shared.connectedScenes.first {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window.windowScene = windowScene //Make sure to do this
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            if let scene = self.view.window?.windowScene?.delegate as? SceneDelegate {
                scene.window = window
            }
        }
    }
    
    @IBAction func newsPressed(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NewsVC") as? NewsVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension WelcomeTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension WelcomeTVC: CustomTextFieldDelegate {
    
}
