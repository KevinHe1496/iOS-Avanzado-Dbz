//
//  HeroDetailController.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 25/10/24.
//

import UIKit

import MapKit

class HeroDetailController: UIViewController {
    
    private let viewModel: HeroDetailViewModel
    private var locationManager: CLLocationManager = CLLocationManager()
    
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HeroDetailController.self), bundle: Bundle(for: type(of: self)))
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var heroNameLabel: UILabel!
    
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
        configureMap()
        setBiding()
        viewModel.loadData()
        checkLocationAuthorizationStatus()
 
    }

    func setBiding() {
        viewModel.status.bind { [weak self] status in
            switch status {
                
            case .locationUpdated:
                self?.updateMapAnnotations()
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
}
