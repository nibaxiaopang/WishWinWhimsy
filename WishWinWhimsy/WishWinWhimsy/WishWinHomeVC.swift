//
//  HomeVC.swift
//  WishWinWhimsy
//
//  Created by WishWinWhimsy on 2024/10/31.
//

import UIKit
import StoreKit
import Adjust
import Reachability

class WishWinHomeVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var reachability: Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.hidesWhenStopped = true
        WishWinLoadAdsData()
    }
    
    
    @IBAction func btnRate(_ sender: Any) {
        
        WishWinRequestAppReview()
        Adjust.trackEvent(ADJEvent(eventToken: "sdfasdfas"))
    }
    
    func WishWinRequestAppReview() {
        if #available(iOS 18.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                AppStore.requestReview(in: windowScene)
            }
        } else {
            if let windowScene = UIApplication.shared.windows.first?.windowScene {
                if #available(iOS 14.0, *) {
                    SKStoreReviewController.requestReview(in: windowScene)
                } else {
                    SKStoreReviewController.requestReview()
                }
            }
        }
    }
    
    @IBAction func pokerListsAction(_ sender: Any) {
        // push
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func WishWinLoadAdsData() {
        guard wishWiNShowBannerDescView() else {
            return
        }
                
        do {
            reachability = try Reachability()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        if reachability.connection == .unavailable {
            reachability.whenReachable = { reachability in
                self.reachability.stopNotifier()
                self.WishWinRequestAdsData()
            }

            reachability.whenUnreachable = { _ in
            }

            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        } else {
            self.WishWinRequestAdsData()
        }
    }
    
    private func WishWinRequestAdsData() {
        self.activityIndicator.startAnimating()
        
        guard let bundleId = Bundle.main.bundleIdentifier else {
            return
        }
        
        let url = URL(string: "https://open.hxwo\(self.wishWinHostName())/open/postWishWinRequestAdsData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "appLocalReg": Locale.current.regionCode ?? "",
            "appModelName": UIDevice.current.model,
            "appKey": "19797e133c624ecd914995db2cf74ba3",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        if let dataDic = dictionary {
                            if let adsData = dataDic["jsonObject"] as? [String: Any], let bannData = adsData["bannerData"] as? String {
                                self.showBannerDescView(bnUrl: bannData)
                                return
                            }
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    self.activityIndicator.stopAnimating()
                } catch {
                    print("Failed to parse JSON:", error)
                    self.activityIndicator.stopAnimating()
                }
            }
        }

        task.resume()
    }
    
    private func showBannerDescView(bnUrl: String) {
        let vc: WishWinPolicyVC = self.storyboard?.instantiateViewController(withIdentifier: "WishWinPolicyVC") as! WishWinPolicyVC
        vc.modalPresentationStyle = .fullScreen
        vc.url = bnUrl
        self.navigationController?.present(vc, animated: false)
    }
    
}

extension WishWinHomeVC: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
}
