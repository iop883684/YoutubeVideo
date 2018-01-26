//
//  SecurityVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/26/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import LocalAuthentication
import PKHUD
import BiometricAuthentication

class SecurityVC: UIViewController {
    
    @IBOutlet weak var switchTouchID: UISwitch!
    @IBOutlet weak var switchPass: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        if Global.shared.getUseTouchID() {
            switchTouchID.isOn = true
        } else {
            switchTouchID.isOn = false
        }
        
        if Global.shared.getUsePass(){
            switchPass.isOn = true
        } else {
            switchPass.isOn = false
        }
    }
    
    @IBAction func switchTouchID(_ sender: UISwitch) {
        
        authenticationWithTouchID()
    }
    
    @IBAction func switchPass(_ sender: UISwitch) {
        
        authenticationWithPass()
    }
    
    func authenticationWithTouchID() {
        
        let myContext = LAContext()
        let myLocalizedReasonString = "AAAAAAAAA"
        
        var authError: NSError?
        if #available(iOS 8.0, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    if success {
                        // User authenticated successfully, take appropriate action
                        
                        
                    } else {
                        // User did not authenticate successfully, look at error and take appropriate action
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
//        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "To access secure data", success: { [weak self] in
//
//            guard let strongSelf = self else { return }
//            // authentication successful
//
//            strongSelf.switchTouchID.isOn = !strongSelf.switchTouchID.isOn
//            Global.shared.addUseTouchID(bool: !strongSelf.switchTouchID.isOn)
//
//        }, failure: { (error) in
//
//            Global.shared.addUseTouchID(bool: !self.switchTouchID.isOn)
//            self.switchTouchID.isOn = !self.switchTouchID.isOn
//            // do nothing on canceled
//            if error == .canceledByUser || error == .canceledBySystem {
//                return
//            }
//
//            let alert = UIAlertController(title: "Error", message: error.message(), preferredStyle: .alert)
//            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alert.addAction(action)
//            self.present(alert, animated: true, completion: nil)
//        })
    }
    
    func authenticationWithPass() {
        
        BioMetricAuthenticator.authenticateWithPasscode(reason: "To access secure data", success: {[weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.switchPass.isOn = !strongSelf.switchPass.isOn
            Global.shared.addUsePass(bool: !strongSelf.switchPass.isOn)
            
        }) { (error) in
            
            Global.shared.addUsePass(bool: self.switchPass.isOn)
            self.switchPass.isOn = self.switchPass.isOn
            
            // do nothing on canceled
            if error == .canceledByUser || error == .canceledBySystem {
                return
            }
            
            let alert = UIAlertController(title: "Error", message: error.message(), preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
 
}


