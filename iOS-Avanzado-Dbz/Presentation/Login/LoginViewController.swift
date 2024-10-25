//
//  LoginViewController.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 20/10/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let token = "eyJraWQiOiJwcml2YXRlIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJleHBpcmF0aW9uIjo2NDA5MjIxMTIwMCwiZW1haWwiOiJrZXZpbl9oZXJlZGlhMTBAaG90bWFpbC5jb20iLCJpZGVudGlmeSI6IkY2QTMyREQ5LTEwREYtNDEzMi1BQTI2LUFENTZEMURGN0U2RSJ9.DjTM9QRu5zFtFftxeti07olNxtBLCJqikI1RE7XlGIU"
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
      
//        let apiProvider = ApiProvider()
//        
//        apiProvider.loadHeroes { result in
//            switch result{
//                
//            case .success(let heros):
//                
//                StoreDataProvider.shared.add(heroes: heros)
//                let bdHeroes = StoreDataProvider.shared.fetchHeroes(filter: nil)
//                debugPrint(bdHeroes)
//            case .failure(let error):
//                debugPrint(error)
//            }
//        }
        
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        SecureDataStore.shared.set(token: token)
        
        present(HeroesListBuilder().build(), animated: true)
        
    }
    
 
    
  
    

}


