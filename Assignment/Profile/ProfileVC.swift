//
//  ProfileVC.swift
//  Assignment
//
//  Created by Ravi Singh on 16/09/23.
//

import UIKit
import GoogleSignIn

class ProfileVC: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstName.text = "Dummy"
        lastName.text = "Singh"
        phone.text = "9876543210"
        email.text = "dummy@yopmail.com"
        gender.text = "Male"
        profileImage.image = UIImage(named: "avatar")
        
        
    }
    
    @IBAction func imagePicker(_ sender: UIButton) {
        
        
    }
    

    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signOut()
        ViewControllerHelper.setupInitialViewController()
        
    }
    
    

}
