import UIKit
import XCPlayground
import Mapbox

let width: CGFloat = 700
let height: CGFloat = 800

//: A control panel
let panelWidth: CGFloat = 200
let panel = PanelView(frame: CGRect(x: width - panelWidth, y: 0, width: 200, height: 100))

//: # Mapbox Maps

/*:
 Put your access token into a plain text file called `token`. Then select the “token” placeholder below, go to Editor ‣ Insert File Literal, and select the `token` file.
 */
var accessToken = "pk.eyJ1IjoicHZldWdlbiIsImEiOiJjaWhld2Y5Z3EwNDUydHJqN28zM2xzbGdhIn0.5_3DhQrJKHX0K4PDMkqiww"
MGLAccountManager.setAccessToken(accessToken)

class PlaygroundAnnotationView: MGLAnnotationView {
    
    override func prepareForReuse() {
        hidden = panel.hideMarkerSwitchView!.on
    }
    
}

//: Define a map delegate

class MapDelegate: NSObject, MGLMapViewDelegate, PanelViewDelegate {
    
    var mapView: MGLMapView?
    var annotationViewByAnnotation = [MGLPointAnnotation: PlaygroundAnnotationView]()
    
    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("annotation") as? PlaygroundAnnotationView
        
        if (annotationView == nil) {
            let av = PlaygroundAnnotationView(reuseIdentifier: "annotation")
            av.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            //av.centerOffset = CGVector(dx: -15, dy: -15)
            av.flat = true
            av.draggable = true
            let centerView = UIView(frame: CGRectInset(av.bounds, 3, 3))
            centerView.backgroundColor = UIColor.whiteColor()
            av.addSubview(centerView)
            av.backgroundColor = UIColor.purpleColor()
            annotationView = av
        } else {
            annotationView!.subviews.first?.backgroundColor = UIColor.greenColor()
        }
       
        annotationViewByAnnotation[annotation as! MGLPointAnnotation] = annotationView
        
        return annotationView
    }
    
    func mapView(mapView: MGLMapView, didSelectAnnotation annotation: MGLAnnotation) {
        let pointAnnotation = annotation as! MGLPointAnnotation
        let annotationView: PlaygroundAnnotationView  = annotationViewByAnnotation[pointAnnotation]!
        
        for view in annotationViewByAnnotation.values {
            view.layer.zPosition = -1
        }
        
        annotationView.layer.zPosition = 1
        
        UIView.animateWithDuration(1.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: .CurveEaseOut, animations: {
            annotationView.transform = CGAffineTransformMakeScale(1.8, 1.8)
        }) { _ in
            annotationView.transform = CGAffineTransformMakeScale(1, 1)
            
            if panel.deleteMarkerSwitchView!.on {
                mapView.removeAnnotation(pointAnnotation)
                return
            }
            
            if panel.hideMarkerSwitchView!.on {
                annotationView.hidden = true
            }
        }
    }
    
    func handleTap(press: UILongPressGestureRecognizer) {
        let mapView: MGLMapView = press.view as! MGLMapView
        
        if (press.state == .Recognized) {
            let coordiante: CLLocationCoordinate2D = mapView.convertPoint(press.locationInView(mapView), toCoordinateFromView: mapView)
            let annotation = MGLPointAnnotation()
            annotation.title = "Dropped Marker"
            annotation.coordinate = coordiante
            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: true)
        }
    }
    
    func didSwitchPitch(sender: UISwitch) {
        let camera = mapView!.camera
        camera.pitch = sender.on ? 60 : 0
        mapView!.setCamera(camera, animated: false)
    }
}

//: Create a map and its delegate

let lat: CLLocationDegrees = 37.174057
let lng: CLLocationDegrees = -104.490984
let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)

let mapView = MGLMapView(frame: CGRect(x: 0, y: 0, width: width, height: height))
mapView.frame = CGRect(x: 0, y: 0, width: width, height: height)

XCPlaygroundPage.currentPage.liveView = mapView

let mapDelegate = MapDelegate()
mapDelegate.mapView = mapView
panel.delegate = mapDelegate
mapView.delegate = mapDelegate

let tapGesture = UILongPressGestureRecognizer(target: mapDelegate, action: #selector(mapDelegate.handleTap))
mapView.addGestureRecognizer(tapGesture)

//: Zoom in to a location

mapView.setCenterCoordinate(centerCoordinate, zoomLevel: 12, animated: false)

//: Add control panel
mapView.addSubview(panel)
