//
//  LampControl.swift
//  NovaLamp
//
//  Created by Peter K on 4/29/18.
//  Copyright © 2018 Peter K. All rights reserved.
//

import UIKit
import WatchConnectivity
import AVFoundation
import MediaPlayer

class LampControl: NSObject, WCSessionDelegate{
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    override init() {
        super.init()
        
        
       
       
    }
    
    func activate(){
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        UIApplication.shared.isIdleTimerDisabled = true

    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error{
             NSLog("activationDidCompleteWith %@",error.localizedDescription)
        }else{
            NSLog("activationDidCompleteWith %d",activationState.rawValue);
        }
        if activationState == .activated{
            NSLog("Activated!");
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let brightness = message["brightness"] as? CGFloat{
            NSLog("Watch brightness %f", brightness);
            OperationQueue.main.addOperation{
                self.brightness = brightness
            }
        }
        
        if let volume = message["volume"] as? CGFloat{
            NSLog("Watch volume %f", volume);
            OperationQueue.main.addOperation{
                self.volume = volume
            }
        }
        replyHandler([:])
    }
    

    var play: Bool = false{
        didSet{
            if play{
                startPlaying()
            }else{
                self.player?.stop()
            }
        }
    }
    var player: AVAudioPlayer?

    func  startPlaying() {
        guard let url = Bundle.main.url(forResource: "audio/rain", withExtension: "m4a") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            self.player = player
            self.volume = 1
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    typealias BrightnessObserver = (_:CGFloat)->()
    
    var brightnessObservers: [BrightnessObserver] = []
    var volumeObservers: [BrightnessObserver] = []

    

    

    func brightness(change val: CGFloat){
        NSLog("Change %f",val)
        brightness += val
    }
    
    var volume:CGFloat = 0{
        
        didSet{
            if self.player?.isPlaying != true{
                self.startPlaying()
            }
            self.player?.setVolume(Float(volume), fadeDuration: 0.3)
            for observer in self.volumeObservers{
                observer(volume)
            }
        }
    }
    
    func addBrightessObserver(_ observer: @escaping BrightnessObserver)  {
        brightnessObservers.append(observer)
    }
    
    func addVolumeObserver(_ observer: @escaping BrightnessObserver)  {
        volumeObservers.append(observer)
    }
    
    var brightness:CGFloat = 0.5 {
        didSet{
            if brightness > 1.0{
                brightness = 1.0
            }
            if brightness < 0 {
                brightness = 0.0
            }
            
            NSLog("brightness %f",brightness)
            for observer in self.brightnessObservers{
                observer(brightness)
            }
        }
    }
}
