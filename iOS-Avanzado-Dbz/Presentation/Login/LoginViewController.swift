//
//  LoginViewController.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 20/10/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet private weak var userNameTextField: UITextField!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var errorLabel: UILabel!
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: LoginViewController.self), bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        viewModel.signIn(userNameTextField.text, passwordTextField.text)
    }
    
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
                
            case .loading:
                self?.renderLoading()
            case .success:
                self?.renderSuccess()
            case .error(reason: let reason):
                self?.renderError(reason)
            }
        }
    }
    
    
    //MARK: - State rendering functions
    
    private func renderLoading(){
        spinner.startAnimating()
        signInButton.isHidden = true
        errorLabel.isHidden = true
    }
    
    private func renderSuccess(){
        spinner.stopAnimating()
        signInButton.isHidden = false
        errorLabel.isHidden = true
    }
    
    private func renderError(_ reason: String) {
        spinner.stopAnimating()
        signInButton.isHidden = false
        errorLabel.isHidden = false
        errorLabel.text = reason
    }
    

}
