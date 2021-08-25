//
//  LoginViewController.swift
//  FirebaseASample
//
//  Created by César on 23/08/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController{

    
    @IBOutlet weak var enterEmail: UITextField!
    
    
    @IBOutlet weak var enterPassword: UITextField!
    
    let loginToList = "LoginToList"
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        
        enterEmail.delegate = self
        enterPassword.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        handle = Auth.auth().addStateDidChangeListener{ _, user in
            if user == nil{
                self.navigationController?.popToRootViewController(animated: true)
            }
            else{
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
                self.enterEmail.text = nil
                self.enterPassword.text = nil
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        guard let handle = handle else{return }
        
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    @IBAction func loginDidTouch(_ sender: AnyObject){
        //Login
        guard
            let email = enterEmail.text,
            let password = enterPassword.text,
            !email.isEmpty,
            !password.isEmpty
        else{
            return
        }
        
        //Start login code:
        
        Auth.auth().signIn(withEmail: email, password: password){ user, error in
            if let error = error, user == nil{
                let alert = UIAlertController(
                    title: "Sign in Failed",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpDidTouch(_ sender: AnyObject){
        
        //User registration
        guard
            let email = enterEmail.text,
            let password = enterPassword.text,
            !email.isEmpty,
            !password.isEmpty
        else{
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password){_, error in
            if error == nil{
                Auth.auth().signIn(withEmail: email, password: password)
            }
            else{
                print("Error in createUser: \(error?.localizedDescription ?? "Undefined")")
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == enterEmail{
            enterPassword.becomeFirstResponder()
        }
        if textField == enterPassword{
            textField.resignFirstResponder()
        }
        return true
     }
}
