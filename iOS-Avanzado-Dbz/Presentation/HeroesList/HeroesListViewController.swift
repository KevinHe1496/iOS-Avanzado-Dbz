//
//  HeroesListViewController.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import UIKit



final class HeroesListViewController: UICollectionViewController {
    
    //MARK: - DataSource
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Hero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Hero>
    
    // MARK: - Model
    private let heroes = [Hero]()
    private var dataSource: DataSource?
    private let viewModel: HeroesListViewModel
    
    //MARK: - Initializers
    init(viewModel: HeroesListViewModel){
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 125)
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let registration = UICollectionView.CellRegistration<HeroCollectionViewCell, Hero>(cellNib: UINib(nibName: HeroCollectionViewCell.identifier, bundle: Bundle(for: type(of: self)))) { cell, indexPath, hero in
            cell.configure(with: hero)
        }
        
        dataSource = DataSource(collectionView: collectionView){ collectionView, indexPath, hero in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: hero)
        }
        
        collectionView.dataSource = dataSource
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(heroes)
        
        dataSource?.apply(snapshot)
    }

}
