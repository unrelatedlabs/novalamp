//
//  ViewController.swift
//  NovaLamp
//
//  Created by Peter K on 4/29/18.
//  Copyright © 2018 Peter K. All rights reserved.
//

import UIKit
import MediaPlayer

class ColorMap{
    class func colorForBrightness(_ brightness: CGFloat) -> UIColor{
        
        return UIColor(hue: 0.1, saturation: 0.1, brightness: CGFloat(brightness), alpha: 1)
    }
}
class ViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var lampControl: LampControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lampControl.addBrightessObserver { (brightness) in
            let treshold:CGFloat = 0.1;
            
            let viewBrightness = max(min(1,brightness/treshold),0)
            self.view.backgroundColor = ColorMap.colorForBrightness( viewBrightness )
            let screenBrightness = (brightness-treshold)*(1.0/(1.0-treshold));
            NSLog("screenBrightness %f %f",screenBrightness,viewBrightness)
            UIScreen.main.brightness = screenBrightness
            UIScreen.main.wantsSoftwareDimming = true
        }
        
        self.lampControl.activate()
        
        
    }
    @IBOutlet var brightnessGestureRecognizer: UIPanGestureRecognizer!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    var locationOfBeganTap: CGPoint = 0
//    var locationOfEndTap: CGPoint

    var prevTranslation:CGFloat = 0;
    
    @IBAction func onTapGesture(_ sender: UITapGestureRecognizer) {
        let margin: CGFloat = 0.2
        var tapLoc = 1+margin-CGFloat(sender.location(in: view).y / view.frame.size.height)*(1+margin*2)
        NSLog("Tap %f",tapLoc)
        lampControl.brightness = tapLoc
    }
    
    @IBAction func rainSwitchChange(_ sender: UISwitch) {
        lampControl.play = sender.isOn
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            
            //locationOfBeganTap = sender.location(in: view)
            prevTranslation = 0;

        } else if sender.state == UIGestureRecognizerState.ended {
            
            //locationOfEndTap = sender.location(in: view)
            //prevTranslation = 0;
        }
        
        let translation = sender.translation(in: view)
        let change = -CGFloat(translation.y / view.frame.size.height) * 1.5
        NSLog("Pan %f",change);
        
        lampControl.brightness(change:change-prevTranslation)
        prevTranslation = change
    }
    

}

