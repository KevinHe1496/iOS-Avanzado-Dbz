//
//  HeroDetailController.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 25/10/24.
//

import UIKit

import MapKit

enum SectionsTransformation {
    case main
}

class HeroDetailController: UIViewController {
    
    private let viewModel: HeroDetailViewModel
    private var locationManager: CLLocationManager = CLLocationManager()
    private var dataSource: UICollectionViewDiffableDataSource<SectionsTransformation, HeroTransformation>?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: HeroDetailController.self), bundle: Bundle(for: type(of: self)))
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var heroNameLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuraCollectionView()
        configureMap()
        setBiding()
        viewModel.loadData()
        checkLocationAuthorizationStatus()
        
        
    }
    
    func setBiding() {
        viewModel.status.bind { [weak self] status in
            switch status {
                
            case .loading:
                self?.spinner.startAnimating()
                self?.heroNameLabel.isHidden = true
                self?.heroDescriptionLabel.isHidden = true
                self?.mapView.isHidden = true
                
            case .locationUpdated:
                self?.spinner.stopAnimating()
                self?.heroNameLabel.isHidden = false
                self?.heroDescriptionLabel.isHidden = false
                self?.mapView.isHidden = false
                self?.updateMapAnnotations()
                self?.heroNameLabel.text = self?.viewModel.hero.name
                self?.heroDescriptionLabel.text = self?.viewModel.hero.info
                
                var snapshot = NSDiffableDataSourceSnapshot<SectionsTransformation, HeroTransformation>()
                snapshot.appendSections([.main])
                snapshot.appendItems(self?.viewModel.heroTransformations ?? [], toSection: .main)
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
                
                
            case .error(let error):
                let alert = UIAlertController(title: "Drabon Ball Z", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            case .none:
                break
                
            }
        }
        
    }
    
    private func updateMapAnnotations() {
        let odlAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(odlAnnotations)
        self.mapView.addAnnotations(viewModel.annotations)
        
        if let annotation = viewModel.annotations.first {
            mapView.region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        }
    }
    
    private func checkLocationAuthorizationStatus() {
        let autorizationStatus = locationManager.authorizationStatus
        
        switch autorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            mapView.showsUserLocation = false
            mapView.showsUserTrackingButton = false
        case .denied:
            mapView.showsUserLocation = false
            mapView.showsUserTrackingButton = false
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
        
    }
    
}


extension HeroDetailController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? HeroAnnotation else {
            return nil
        }
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: HeroAnnotationView.identifier) {
            return annotationView
        }
        let annotationView = HeroAnnotationView(annotation: annotation, reuseIdentifier: HeroAnnotationView.identifier)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        debugPrint("Call accesory tapped")
        
    }
    
    
    func configuraCollectionView() {
        // Configuración del layout en horizontal
        let layout = UICollectionViewFlowLayout()
        let collectionWidth = collectionView.bounds.width
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionWidth / 2 - 15, height: collectionView.bounds.height) // Ajusta el tamaño según tus necesidades
        layout.minimumLineSpacing = 10 // Espacio entre elementos
        layout.minimumInteritemSpacing = 0
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        
        let cellRegistration = UICollectionView.CellRegistration<HeroDetailCell, HeroTransformation>(cellNib: UINib(nibName: HeroDetailCell.identifier, bundle: nil)) { cell, indexPath, transformation in
            
            cell.transformationLabel.text = transformation.name
            
            if let url = URL(string: transformation.photo) {
                cell.transformationImageView.setImage(url: url)
            } else {
                cell.transformationImageView.image = UIImage(named: "placeholderImage")
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, transformation in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: transformation)
        }
        
    }
    
}
//collectionView.bounds.size.width
extension HeroDetailController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let transformation = viewModel.TransformationAt(index: indexPath.row) else {
            return
        }
        
        
        let viewModel = TransformationDetailViewModel(transformation: transformation)
        let transformationDetailVC = TransformationDetailController(viewModel: viewModel)
        navigationController?.pushViewController(transformationDetailVC, animated: true)
    }
}
