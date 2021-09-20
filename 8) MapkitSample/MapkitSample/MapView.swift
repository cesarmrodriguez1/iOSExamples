//
//  MapView.swift
//  MapkitSample
//
//  Created by gdaalumno on 20/09/21.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable{
    typealias UIViewType = MKMapView
    
    @Binding var directions: [String]

    class MapViewCoordinator: NSObject, MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 20.68, longitude: -105.3),
                                        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 20.6805184, longitude: -105.2545649))
        
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 20.7339528, longitude: -103.456944))
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            
            guard let route = response?.routes.first else { return }
            
            mapView.addAnnotations([p1, p2])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),animated: true)
            
            self.directions = route.steps.map{$0.instructions}
        }
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
