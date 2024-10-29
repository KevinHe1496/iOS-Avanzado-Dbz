//
//  LoginViewController.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 20/10/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    //    private let token = "eyJraWQiOiJwcml2YXRlIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJleHBpcmF0aW9uIjo2NDA5MjIxMTIwMCwiZW1haWwiOiJrZXZpbl9oZXJlZGlhMTBAaG90bWFpbC5jb20iLCJpZGVudGlmeSI6IkY2QTMyREQ5LTEwREYtNDEzMi1BQTI2LUFENTZEMURGN0U2RSJ9.DjTM9QRu5zFtFftxeti07olNxtBLCJqikI1RE7XlGIU"
    
    private let viewModel: LoginViewModel
    
    
    @IBOutlet private weak var userNameTextField: UITextField!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var errorLabel: UILabel!
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    
    
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: LoginViewController.self), bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBiding()
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        //        SecureDataStore.shared.set(token: token)
        
        let (valid, message) = viewModel.signIn(userName: userNameTextField.text, password: passwordTextField.text)
        
        if !valid {
            let alert = UIAlertController(title: "Goku And Friends",
                                          message: message,
                                          preferredStyle: .alert)
            let alertAction = UIAlertAction.init(title: "Ok", style: .default)
            alert.addAction(alertAction)
            present(alert, animated: true)
            return
        }
        
        viewModel.login(username: userNameTextField.text!, password: passwordTextField.text!)
        
    }
    
    
    private func setBiding() {
        viewModel.onStateChaged.bind { [weak self] state in
            guard let weakSelf = self else { return }
            switch state {
                
            case .loading:
                weakSelf.spinner.startAnimating()
            case .success:
                weakSelf.clearTextFields()
                weakSelf.spinner.stopAnimating()
                let heroesVC = HeroesListBuilder().build()
                weakSelf.present(heroesVC, animated: true)
            case .error(reason: let reason):
                weakSelf.spinner.stopAnimating()
                let alert = UIAlertController(title: "Goku And Friends",
                                              message: reason,
                                              preferredStyle: .alert)
                let alertAction = UIAlertAction.init(title: "Ok", style: .default)
                alert.addAction(alertAction)
                weakSelf.present(alert, animated: true)
            case .none:
                break
            }
        }
    }
    
    private func clearTextFields() {
        userNameTextField.text = nil
        passwordTextField.text = nil
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return false
    }
}
