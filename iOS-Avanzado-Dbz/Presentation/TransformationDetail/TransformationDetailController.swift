//
//  TransformationDetailController.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 28/10/24.
//

import UIKit

class TransformationDetailController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var transformationDescriptionLabel: UILabel!
    @IBOutlet weak var transformationTitleLabel: UILabel!
    @IBOutlet weak var transformationImageView: UIImageView!
    
    // MARK: - Model
    private let viewModel: TransformationDetailViewModel
    
    //MARK: - Initializers
    init(viewModel: TransformationDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TransformationDetailController.self), bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinding()
        loadData()
        
    }
    
    func loadData() {
        viewModel.transformationStatus.value = .loading
        // Aquí puedes hacer la carga de datos que sea necesaria
        viewModel.transformationStatus.value = .locationUpdated // Actualiza el status solo al final de la carga
        
    }
    
    func setBinding() {
        viewModel.transformationStatus.bind { [weak self] status in
            switch status {
                
            case .loading:
                self?.renderLoading()
            case .locationUpdated:
                self?.renderLocationUpdated()
            case .error(let error):
                self?.renderError(error: error)
            case .none:
                break
            }
        }
    }
    
    private func renderLoading() {
        self.spinner.startAnimating()
        self.transformationDescriptionLabel.isHidden = true
        self.transformationImageView.isHidden = true
        self.transformationTitleLabel.isHidden = true
    }
    
    private func renderLocationUpdated() {
        self.spinner.stopAnimating()
        self.transformationDescriptionLabel.isHidden = false
        self.transformationImageView.isHidden = false
        self.transformationTitleLabel.isHidden = false
        
        self.transformationTitleLabel.text = self.viewModel.transformation.name
        self.transformationDescriptionLabel.text = self.viewModel.transformation.info
        
        if let url = URL(string: self.viewModel.transformation.photo ?? "") {
            self.transformationImageView.setImage(url: url)
        } else {
            self.transformationImageView.image = UIImage(named: "placeholderImage")
        }
        self.viewModel.transformationStatus.value = .none
        
    }
    
    private func renderError(error: String) {
        let alert = UIAlertController(title: "Drabon Ball Z", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}
