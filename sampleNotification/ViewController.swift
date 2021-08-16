import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = CLLocationManager()
                    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(35.7020691, 139.7753269),
                                                               radius: 10,
                                                               identifier: "Base")
        
        locationManager.startMonitoring(for: geoFenceRegion)
    }
    
    // 現在位置を表示
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("緯度: ", location.coordinate.latitude, "経度: ", location.coordinate.longitude)
        }
    }
    
    // 指定エリアに入った時に発火する。
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered: /(region.identifier)")
        setNotification()
    }
    // debug用。指定エリアから出た時に発火する。
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited: /(region.identifier)")
        //setNotification()
    }
    
    func setNotification() {
        let seconds = 5

        // ------------------------------------
        // 通知の発行: タイマーを指定して発行
        // ------------------------------------
        // content
        let content = UNMutableNotificationContent()
        content.title = "お相手が近くにいます"
        //content.subtitle = "通知からアプリを開いて、お相手を探しましょう！！"
        content.body = "通知からアプリを開いて、お相手を探しましょう！！"
        content.sound = UNNotificationSound.default

        // trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(seconds),
                                                        repeats: false)

        // request includes content & trigger
        let request = UNNotificationRequest(identifier: "TIMER\(seconds)",
                                            content: content,
                                            trigger: trigger)

        // schedule notification by adding request to notification center
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
