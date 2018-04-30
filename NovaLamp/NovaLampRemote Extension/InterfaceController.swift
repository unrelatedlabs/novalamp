//
//  InterfaceController.swift
//  NovaLampRemote Extension
//
//  Created by Peter K on 4/29/18.
//  Copyright © 2018 Peter K. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController,WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("activationDidCompleteWith")
        if activationState == .activated{
            NSLog("Session Activated")
            
        }
        if let error = error{
            NSLog("Error activating %@",error.localizedDescription)
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
    }
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        WCSession.default.delegate = self
        WCSession.default.activate()

    }
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func brightnessSliderChange(_ value: Float) {
        //WCSession.default.activate()
        
        update(["brightness":value])
    }
    func  update(_ values:[String:Float]) {
        WCSession.default.sendMessage(values, replyHandler: {reply in
            NSLog("reply %@",reply)
        }) { (error) in
            NSLog("Error %@",error.localizedDescription)
            OperationQueue.main.addOperation{
                self.presentAlert(withTitle: "Error", message: error.localizedDescription, preferredStyle: .alert, actions: [WKAlertAction(title: "OK", style: .cancel, handler: {
                    
                })])
            }
        }
    }
    
    @IBAction func volumeSliderChange(_ value: Float) {
        update(["volume":value])
    }
}
