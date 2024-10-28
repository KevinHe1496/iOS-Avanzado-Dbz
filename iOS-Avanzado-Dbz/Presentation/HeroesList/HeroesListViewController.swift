//
//  HeroesListViewController.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import UIKit

enum SectionHeroes{
    case main
}

final class HeroesListViewController: UICollectionViewController {
    
    //MARK: - DataSource
    typealias DataSource = UICollectionViewDiffableDataSource<SectionHeroes, Hero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Hero>
    
    // MARK: - Model
    private let heroes = [Hero]()
    private var dataSource: DataSource?
    private let viewModel: HeroesListViewModel
    private let storeDataProvider = StoreDataProvider()
    private let secureDataStore = SecureDataStore()
    
    
    //MARK: - Initializers
    init(viewModel: HeroesListViewModel = HeroesListViewModel()){
        
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10 // Espaciado entre columnas
        layout.minimumLineSpacing = 20 // Espaciado entre filas
        super.init(collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Crear el botón de logout
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        // Añadir el botón a la derecha de la barra de navegación
        self.navigationItem.rightBarButtonItem = logoutButton
        
        title = "Personajes"
        configureCollecionView()
        setBinding()
        viewModel.loadData(filter: nil)
    }
    
    // MARK: - LogOut
    
    @objc func logoutTapped() {
        
        storeDataProvider.clearBBDD()
        secureDataStore.deleteToken()
        //        navigationController?.popToRootViewController(animated: true)
        let loginViewController = LoginBuilder().build()// Instancia tu controlador de login
        let navController = UINavigationController(rootViewController: loginViewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
        
    }
    
    func setBinding() {
        viewModel.statusHeroes.bind { [weak self] state in
            switch state{
                
            case .dateUpdated:
                var snapshot = NSDiffableDataSourceSnapshot<SectionHeroes, Hero>()
                snapshot.appendSections([.main])
                snapshot.appendItems(self?.viewModel.heroes ?? [], toSection: .main)
                self?.dataSource?.apply(snapshot)
            case .error(let error):
                let alert = UIAlertController(title: "Drabon Ball Z", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
                debugPrint("Informamos del error")
            case .none:
                break
            }
        }
    }
    
    func configureCollecionView() {
        collectionView.delegate = self
        
        let cellRegister = UICollectionView.CellRegistration<HeroCollectionViewCell, Hero>(cellNib: UINib(nibName: HeroCollectionViewCell.identifier, bundle: nil)) { cell, indexPath, hero in
            
            cell.nameLabel.text = hero.name
            
            if let url = URL(string: hero.photo) {
                cell.heroImageView.setImage(url: url)
            } else {
                // Maneja el caso donde la URL es inválida
                cell.heroImageView.image = UIImage(named: "placeholderImage")
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hero in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: indexPath, item: hero)
        })
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HeroesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPorFila: CGFloat = 2
        let espaciado = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 10 * (itemsPorFila - 1)
        let ancho = collectionView.bounds.width - espaciado
        let anchoPorItem = ancho / itemsPorFila
        return CGSize(width: anchoPorItem, height: anchoPorItem) // Mantén la altura igual al ancho para hacerlo cuadrado
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hero = viewModel.heroAt(index: indexPath.row) else {
            return
        }
        
        let viewModel = HeroDetailViewModel(hero: hero)
        let heroDetailVC = HeroDetailController(viewModel: viewModel)
        navigationController?.pushViewController(heroDetailVC, animated: true)
    }
    
}
