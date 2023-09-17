//
//  SignInVC.swift
//  Assignment
//
//  Created by Ravi Singh on 16/09/23.
//

import UIKit
import GoogleSignIn

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
          guard error == nil else { return }
            self.navigationController?.pushViewController(ViewControllerHelper.getObjectOf(of: .imageVC), animated: true)
        }
    }

}
