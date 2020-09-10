//
//  PaywallViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 10/27/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import Purchases
import FBSDKCoreKit
import MBProgressHUD
import AppsFlyerLib

var refer = String()

var onboarding = Bool()


@objc protocol SwiftPaywallDelegate {
    func purchaseCompleted(paywall: PaywallViewController, transaction: SKPaymentTransaction, purchaserInfo: Purchases.PurchaserInfo)
    @objc optional func purchaseFailed(paywall: PaywallViewController, purchaserInfo: Purchases.PurchaserInfo?, error: Error, userCancelled: Bool)
    @objc optional func purchaseRestored(paywall: PaywallViewController, purchaserInfo: Purchases.PurchaserInfo?, error: Error?)
}


class PaywallViewController: UIViewController {

var delegate : SwiftPaywallDelegate?

    private var offering : Purchases.Offering?
    
    private var offeringId : String?
    
    @IBOutlet weak var termstext: UILabel!
    @IBOutlet weak var disclaimertext: UIButton!
    var purchases = Purchases.configure(withAPIKey: "ryfdDUwKGrQKWbGaaYJjIobqbOruFudh", appUserID: nil)
    
    
    @IBAction func tapRestore(_ sender: Any) {
        
        

          ref?.child("Users").child(uid).updateChildValues(["Purchased" : "True"])
          
          didpurchase = true
        
        
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            //... check purchaserInfo to see if entitlement is now active
            
            if let error = error {
                
                
            } else {
                
                self.logPurchaseSuccessEvent(referrer : referrer)
                //
                ref?.child("Users").child(uid).updateChildValues(["Purchased" : "True"])
                
                didpurchase = true
              
                         
                         self.dismiss(animated: true, completion: nil)

                     
            }
            
        }
    }
    @IBAction func tapBack(_ sender: Any) {
        
  
        referrer = "Paywall"
            
            self.dismiss(animated: true, completion: nil)

        
        
    }

  
    func logNotificationsSettingsTrue(referrer : String) {
                                     AppEvents.logEvent(AppEvents.Name(rawValue: "notifications enabled"), parameters: ["value" : "true"])
                                 }

  
    func logNotificationsSettingsFalse(referrer : String) {
                                     AppEvents.logEvent(AppEvents.Name(rawValue: "notifications enabled"), parameters: ["value" : "false"])
                                 }


    @IBOutlet weak var backimage: UIImageView!
    
    
    @IBAction func tapContinue(_ sender: Any) {
        
        referrer = "Paywall"
        
        logTapSubscribeEvent(referrer : referrer)
        
        AppsFlyerTracker.shared().trackEvent(AFEventInitiatedCheckout, withValues: [
              AFEventParamContentId: referrer,
            
          ]);

        
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)

        
        guard let package = offering?.availablePackages[0] else {
              print("No available package")
            MBProgressHUD.hide(for: view, animated: true)

              return
          }
        
        
        Purchases.shared.purchasePackage(package) { (trans, info, error, cancelled) in
                  
            MBProgressHUD.hide(for: self.view, animated: true)

                  if let error = error {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)

                      if let purchaseFailedHandler = self.delegate?.purchaseFailed {
                          purchaseFailedHandler(self, info, error, cancelled)
                      } else {
                          if !cancelled {
                            
                          }
                      }
                  } else  {
                      if let purchaseCompletedHandler = self.delegate?.purchaseCompleted {
                          purchaseCompletedHandler(self, trans!, info!)
                          
                          self.logPurchaseSuccessEvent(referrer : referrer)
                          //
                          ref?.child("Users").child(uid).updateChildValues(["Purchased" : "True"])
                          
                          didpurchase = true
                        
                        
                              AppsFlyerTracker.shared().trackEvent(AFEventStartTrial, withValues: [
                                    AFEventParamContentId: referrer,
                                  
                                ]);
                        
                        MBProgressHUD.hide(for: self.view, animated: true)

                        
                        
                                   self.dismiss(animated: true, completion: nil)

                               
                          
                      } else {
                          
                          self.logPurchaseSuccessEvent(referrer : referrer)
                          //
                          ref?.child("Users").child(uid).updateChildValues(["Purchased" : "True"])
                          
                        MBProgressHUD.hide(for: self.view, animated: true)


                        AppsFlyerTracker.shared().trackEvent(AFEventStartTrial, withValues: [
                              AFEventParamContentId: referrer,
                            
                          ]);
                          didpurchase = true
                        
                                   
                                   self.dismiss(animated: true, completion: nil)

                               
                          
                      }
                  }
              }
    }
    
    @IBAction func tapTerms(_ sender: Any) {
        
        if let url = NSURL(string: "https://www.aktechnology.info/terms.html"
            ) {
            UIApplication.shared.openURL(url as URL)
        }
        
    }
    
    @IBOutlet weak var leadingtext: UILabel!
    
@IBOutlet weak var headlinelabel: UILabel!
@IBOutlet weak var tapcontinue: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        tapcontinue.layer.cornerRadius = 25.0
        
        tapcontinue.clipsToBounds = true
        
        logPaywallShownEvent(referrer : referrer)
        
                                      let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
                                         let blurEffectView = UIVisualEffectView(effect: blurEffect)
                                         blurEffectView.frame = backimage.bounds
                                         blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                                      backimage.addSubview(blurEffectView)
        
        
        queryforpaywall()
        
        Purchases.shared.offerings { (offerings, error) in
               
               if error != nil {
               }
               if let offeringId = self.offeringId {
                   
                   self.offering = offerings?.offering(identifier: offeringId)
               } else {
                   self.offering = offerings?.current
               }
               
           }
        
 
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var toptext: UILabel!
    
    @IBOutlet weak var value1: UILabel!
    func queryforpaywall() {
                
        ref?.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
     
            
            if let slimey = value?["Slimey"] as? String {

//                slimeybool = true
//
                self.leadingtext.text = slimey

                self.toptext.text = "3 Day FREE Trial"
                self.termstext.alpha = 0
                        self.disclaimertext.alpha = 0
                         self.tapcontinue.setTitle("Try for FREE!", for: .normal)
                
            } else {
//
//                slimeybool = false
                self.leadingtext.text = "$69.99/year"
                
                self.toptext.text = "World Class Presets"
//
                self.termstext.alpha = 1
                  self.disclaimertext.alpha = 1
                  self.tapcontinue.setTitle("Continue", for: .normal)
                self.tapcontinue.setTitle("Continue", for: .normal)
                

            }
            
            if let discountcode = value?["DiscountCode"] as? String {
                
               actualdiscount = discountcode
                
            } else {
                
                
            }
        })
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func logPaywallShownEvent(referrer : String) {
        AppEvents.logEvent(AppEvents.Name(rawValue: "paywall shown"), parameters: ["referrer" : referrer, "bookID" : selectedbookid, "genre" : selectedgenre])
    }
    
    func logTapSubscribeEvent(referrer : String) {
        AppEvents.logEvent(AppEvents.Name(rawValue: "tap subscribe"), parameters: ["referrer" : referrer, "bookID" : selectedbookid, "genre" : selectedgenre])
    }
    
    func logPurchaseSuccessEvent(referrer : String) {
        AppEvents.logEvent(AppEvents.Name(rawValue: "purchase success"), parameters: ["referrer" : referrer, "bookID" : selectedbookid, "genre" : selectedgenre])
    }
    
}
