//
//  LoginViewController.swift
//  MacTweeter
//
//  Created by Shehan on 5/26/18.
//  Copyright © 2018 app360. All rights reserved.
//

import Cocoa
   var eventMonitor: EventMonitor?

class LoginViewController: NSViewController {

       let popover = NSPopover()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    override func awakeFromNib() {
        
        
        
        if self.view.layer != nil {
            
            let color : CGColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color

            
        }
        
        
    }
    @IBAction func loginAction(_ sender: Any) {
      
    }
    
    
   
       //
}
