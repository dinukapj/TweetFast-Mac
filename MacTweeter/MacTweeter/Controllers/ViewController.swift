//
//  ViewController.swift
//  MacTweeter
//
//  Created by Shehan on 5/20/18.
//  Copyright © 2018 app360. All rights reserved.
//
import Cocoa
import Accounts
import SwifterMac
import AppKit
import AVFoundation
import SystemConfiguration
import Magnet



class ViewController: NSViewController,NSTextFieldDelegate,NSControlTextEditingDelegate{
    
    ////// Tweet Panel  ////
    @IBOutlet weak var topBar: NSBox!
    @IBOutlet weak var tweetBox: NSBox!
    @IBOutlet weak var bottomBar: NSBox!
    /////////////////
    
    @IBOutlet weak var lblComposeTitle: NSTextField!
    @IBOutlet weak var lblUsername: NSTextField!
    @IBOutlet weak var lbLTilte: NSTextField!
    @IBOutlet weak var lblDes: NSTextField!
    @IBOutlet weak var welcomeBox: NSBox!
    @IBOutlet weak var lblMadeBy: NSTextField!

    @IBOutlet weak var btnWelcomeSetting: NSPopUpButton!
    @IBOutlet weak var btnSettings: NSPopUpButton!
    
    @IBOutlet weak var txtTweet: NSTextField!
    @IBOutlet weak var lblTweetCountStatus: NSTextField!
    @IBOutlet weak var lblTweetStatus: NSTextField!
    let color = NSColor(red:0.11, green:0.58, blue:0.88, alpha:1.0)
    @IBOutlet weak var progressLoad: NSProgressIndicator!
    @IBOutlet weak var lblTweetCount: NSTextField!
    @IBOutlet weak var imgTweetBird: NSImageView!
    
    @IBOutlet weak var btnTerms: NSButton!

    @IBOutlet var tweetView: NSView!
    @IBOutlet weak var btnTweet: NSButton!
    let popover = NSPopover()
    
    
    
    var useACAccount = false

    let swifter = Swifter(consumerKey: "RErEmzj7ijDkJr60ayE2gjSHT", consumerSecret: "SbS0CHk11oJdALARa7NDik0nty4pXvAxdt7aj0R5y1gNzWaNEx")
    let failureHandler: (Error) -> Void = {
        print($0.localizedDescription)
    
    }
  
 
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadperson()
        /*
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) {
            switch $0.modifierFlags.intersection(.deviceIndependentFlagsMask) {
            case [.shift]:
                print("shift key is pressed")
            case [.control]:
                print("control key is pressed")
            case [.option] :
                print("option key is pressed")
            case [.command]:
                print("Command key is pressed")
            case [.control, .shift]:
                print("control-shift keys are pressed")
            case [.option, .shift]:
                print("option-shift keys are pressed")
            case [.command, .shift]:
                print("command-shift keys are pressed")
            case [.control, .option]:
                print("control-option keys are pressed")
            case [.control, .command]:
                print("control-command keys are pressed")
            case [.option, .command]:
                print("option-command keys are pressed")
            case [.shift, .control, .option]:
                print("shift-control-option keys are pressed")
            case [.shift, .control, .command]:
                print("shift-control-command keys are pressed")
            case [.control, .option, .command]:
                print("control-option-command keys are pressed")
            case [.shift, .command, .option]:
                print("shift-command-option keys are pressed")
            case [.shift, .control, .option, .command]:
                print("shift-control-option-command keys are pressed")
            default:
                print("no modifier keys are pressed")
            }
        }
  */
       // guard let keyCombo = KeyCombo(keyCode: 17, carbonModifiers: 4352) else { return }
      //  let hotKey = HotKey(identifier: "CommandControlB",
             //               keyCombo: keyCombo,
                //            target: self,
                //            action: #selector(toggleTweet(_:)))
      //  hotKey.register()
        setupUI()
        
       // changeThem()
        
        
        if fetchUserToken() != nil {
            
            //self.lblUsername = fetchUserToken()?.account.sc
            self.lblMadeBy.isHidden = true
            self.welcomeBox.isHidden = true
            self.tweetView.frame = CGRect(x:0, y:0, width:415, height:self.view.frame.size.height)
            self.view.addSubview(self.tweetView)
        }
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            print("Internet Connection not Available!")
        }
        
    }

    func setupUI() {
        
        lbLTilte.textColor = .white
        lblDes.textColor = .white
        
        txtTweet.textColor = .black
        tweetBox.fillColor = NSColor.white
        tweetBox.borderColor = NSColor.white
        btnTweet.isTransparent = true
        txtTweet.backgroundColor = .white
        lblTweetCountStatus.isHidden = true
        txtTweet.stringValue = ""
        btnTweet.isEnabled = false
        lblTweetStatus.isHidden = true
        progressLoad.isHidden = true
        txtTweet.delegate = self
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        btnTerms.attributedTitle = NSAttributedString(string: "Read Our Privacy Policy & Terms", attributes: [ NSAttributedStringKey.foregroundColor : NSColor.white, NSAttributedStringKey.paragraphStyle : pstyle ])
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        self.lblMadeBy.isHidden = false
    }
    
    override func viewWillAppear() {

        if fetchUserToken() != nil {
             self.lblMadeBy.isHidden = true
            self.welcomeBox.isHidden = true
            self.tweetView.frame = CGRect(x:0, y:0, width:415, height:self.view.frame.size.height)
            self.view.addSubview(self.tweetView)
        }else{
            
             self.lblMadeBy.isHidden = false
            tweetView.removeFromSuperview()
            self.welcomeBox.isHidden = false
        }
        
    }
    func saveUserToken(data: Credential.OAuthAccessToken) -> Bool {
        
        let userdata = UserDefaults.standard
        userdata.set(data.key, forKey: "key")
        userdata.set(data.secret, forKey: "secret")
        userdata.set(data.screenName, forKey: "screenName")
        userdata.set(data.userID, forKey: "userID")
        userdata.set(data.verifier, forKey: "verifier")
        userdata.synchronize()
        
        return true
    }
    
    func fetchUserToken() -> Credential? {
        let userdata = UserDefaults.standard
        
        if let tkey = userdata.object(forKey: "key") as? String {
            if let tsecret = userdata.object(forKey: "secret") as? String {
                lblUsername.stringValue =  "Hello \((userdata.object(forKey: "screenName") as? String)!)!" 
                let access = Credential.OAuthAccessToken(key: tkey , secret: tsecret)
                return Credential(accessToken: access)
            }
        }
        return nil
    }
    
    func loadperson(){
        
   
    }
    
    func fetchUserQData() -> NSDictionary {
        let userdata = UserDefaults.standard
        let data: NSMutableDictionary = NSMutableDictionary()
        data["screenName"] = userdata.object(forKey: "screenName") as! String?
        data["userID"] = userdata.object(forKey: "userID") as! String?
        return data
    }
    
    @IBAction func twitteAction(_ sender: Any) {
        postTweet()
    }
    
    func postTweet()
    {
        
        let failureTweetHandler: (Error) -> Void = {
            print($0.localizedDescription)
            
            if Reachability.isConnectedToNetwork() {
                
                self.tweetView.removeFromSuperview()
                self.welcomeBox.isHidden = false
            }
        }
        
        if(self.txtTweet.stringValue.isEmpty == false){
            btnTweet.isEnabled = true
            self.swifter.postTweet(status: " \(txtTweet.stringValue)" , success: { statuses in
                self.display()
                self.txtTweet.stringValue = ""
                
            }, failure: failureTweetHandler)
        }
        else{
            
            
            
            btnTweet.isEnabled = false
        }
        
    }
    override func awakeFromNib() {
        
        if self.view.layer != nil {
            
    let color : CGColor = CGColor(red: 0.9059, green: 0.9569, blue: 0.9922, alpha: 1.0)
          //  self.view.layer?.backgroundColor = color
            
          //  btnTweet.layer?.backgroundColor = NSColor.red.cgColor
         // btnTweet.layer?.backgroundColor = CGColor.white
            self.tweetView.layer?.backgroundColor = color
            
        }
        
        
    }
    @IBAction func loginAction(_ sender: Any) {
        
        progressLoad.isHidden = false
        progressLoad.startAnimation(nil)
        
        if fetchUserToken() != nil {
            self.swifter.client.credential = fetchUserToken()
            self.progressLoad.stopAnimation(nil)
            self.progressLoad.isHidden = true
        } else {
           self.swifter.authorize(with: URL(string: "swifter://success")!, success: {
               credential, response in
                var tmp = self.swifter.client.credential?.accessToken
                self.saveUserToken(data: tmp!)
               print(tmp!)
                print(credential)
                self.welcomeBox.isHidden = true
                self.tweetView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
                self.view.addSubview(self.tweetView)
                self.progressLoad.stopAnimation(nil)
                self.progressLoad.isHidden = true
                self.displayMain(question: "You have logged in to TweetFast. Let's start Tweeting! 😃", text: "You can close the twitter browser tab now 👋")
            
       
            
           
               // print(self.swifter.client.credential?.account)
                
            },failure: failureHandler
            )
        }
        
        
        
        
    }
  
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
 
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // Do something against ENTER key
            
            var x =  self.txtTweet.stringValue
          x.append("\n")
             self.txtTweet.stringValue = x
            return true
           
        }  /*else if (commandSelector == #selector(NSResponder.deleteForward(_:))) {
            // Do something against DELETE key
            return true
        } else if (commandSelector == #selector(NSResponder.deleteBackward(_:))) {
            // Do something against BACKSPACE key
            return true
        } else if (commandSelector == #selector(NSResponder.insertTab(_:))) {
            // Do something against TAB key
            return true
        } else if (commandSelector == #selector(NSResponder.cancelOperation(_:))) {
            // Do something against ESCAPE key
            return true
        }
        */
        // return true if the action was handled; otherwise false
        return false
    }

    override func controlTextDidChange(_ notification: Notification) {
        if let txtTweet = notification.object as? NSTextField {
            
            let text = "\(txtTweet.stringValue)"
            
            txtTweet.attributedStringValue =  self.getColoredText(text: text)
            
            
            lblTweetCount.stringValue = "\(txtTweet.stringValue.count)/280"
            btnTweet.isEnabled = true
            lblTweetCount.textColor = .black
            if( txtTweet.stringValue.count > 280  && txtTweet.stringValue.trimmingCharacters(in: .whitespaces).isEmpty == false ) {
              //  if(txtTweet.stringValue.count > 280){
                  
              //  }
                
                lblTweetCount.textColor = .red
                btnTweet.isEnabled = false
                
            }
            
        }
        
        if self.txtTweet.stringValue.characters.count > 100 {
        
          txtTweet.isEditable = false
            
        }
    }
    @IBAction func termsAction(_ sender: Any) {
        if let url = URL(string: "https://tweetfast.xyz/terms"), NSWorkspace.shared.open(url) {
            
        }
    }
    func getColoredText(text: String) -> NSMutableAttributedString {
        
        let font = NSFont.systemFont(ofSize: 16)
        let attrs = [NSAttributedStringKey.font: font]
        let string:NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: attrs)
        let words:[String] = text.components(separatedBy: " ")
        var w = ""
        
        for word in words {
            if (word.hasPrefix("#") ) {
                let range:NSRange = (string.string as NSString).range(of: word)
                string.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
                w = word.replacingOccurrences(of: "#", with: "#")
                string.replaceCharacters(in: range, with: w)
            }
            
            if (word.hasPrefix("@") ) {
                let range:NSRange = (string.string as NSString).range(of: word)
                
                string.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
                w = word.replacingOccurrences(of: "@", with: "@")
                string.replaceCharacters(in: range, with: w)
            }
        }
        return string
    }
    
    func display() {
        
        self.lblTweetStatus.isHidden = false
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.lblTweetStatus.isHidden = true
            
        }
    }
    
    
    func displayMain(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Get Started")
        
        return alert.runModal() == .alertFirstButtonReturn
    }
    func MaxTweetCountStatus() {
        
        self.lblTweetCountStatus.isHidden = false
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.lblTweetCountStatus.isHidden = true
            
        }
    }
    
   
    
    @IBAction func settingAction(_ sender: Any) {
        
      
        
        if ( (sender as AnyObject).indexOfSelectedItem == 1) {
            
            if let url = URL(string: "https://tweetfast.xyz"), NSWorkspace.shared.open(url) {
                print("default browser was successfully opened")
            }
        }
        if ( (sender as AnyObject).indexOfSelectedItem == 2) {
            
            txtTweet.stringValue = ""
            resetDefaults()
            tweetView.removeFromSuperview()
            self.welcomeBox.isHidden = false
               self.lblMadeBy.isHidden = false
            
            
        }
        if ( (sender as AnyObject).indexOfSelectedItem == 3) {
            
            txtTweet.stringValue = ""
            resetDefaults()
            tweetView.removeFromSuperview()
            self.welcomeBox.isHidden = false
               self.lblMadeBy.isHidden = false
            NSApplication.shared.terminate(self)
        }
    }
    
    
    func textField(_ textField: NSTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12
        let currentString: NSString = txtTweet.stringValue as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    @IBAction func WelcomeSettingAction(_ sender: Any) {
        
        if ( (sender as AnyObject).indexOfSelectedItem == 1) {
            
            if let url = URL(string: "https://tweetfast.xyz"), NSWorkspace.shared.open(url) {
                print("default browser was successfully opened")
            }
        }
        if ( (sender as AnyObject).indexOfSelectedItem == 2) {
            
            txtTweet.stringValue = ""
            resetDefaults()
            tweetView.removeFromSuperview()
            self.welcomeBox.isHidden = false
            self.lblMadeBy.isHidden = false
        }
        if ( (sender as AnyObject).indexOfSelectedItem == 3) {
            
            txtTweet.stringValue = ""
            resetDefaults()
            tweetView.removeFromSuperview()
            self.welcomeBox.isHidden = false
            self.lblMadeBy.isHidden = false
            NSApplication.shared.terminate(self)
        }
    }
    
    
    @objc func toggleTweet(_ sender: AnyObject?) {
     // if popover.isShown {
      postTweet()
      //  }
    }
    
    func isTextField(inFocus textField: NSTextField) -> Bool {
        var inFocus = false
        inFocus = (textField.window?.firstResponder is NSTextView) && textField.window?.fieldEditor(false, for: nil) != nil && textField.isEqual(to: (textField.window?.firstResponder as? NSTextView)?.delegate)
        return inFocus
    }
    
    @IBAction func themeChanger(_ sender: Any) {
        
        if ( (sender as AnyObject).indexOfSelectedItem == 1) {
            
            if let url = URL(string: "https://tweetfast.xyz"), NSWorkspace.shared.open(url) {
                print("default browser was successfully opened")
            }
        }
        if ( (sender as AnyObject).indexOfSelectedItem == 2) {
            
            txtTweet.stringValue = ""
            resetDefaults()
            tweetView.removeFromSuperview()
            self.welcomeBox.isHidden = false
            self.lblMadeBy.isHidden = false
        }
        
    }
    
    @IBAction func welcomeThemeChanger(_ sender: Any) {
        
        if ( (sender as AnyObject).indexOfSelectedItem == 1) {
            
            if let url = URL(string: "https://tweetfast.xyz"), NSWorkspace.shared.open(url) {
                print("default browser was successfully opened")
            }
        }
        if ( (sender as AnyObject).indexOfSelectedItem == 2) {
            
            txtTweet.stringValue = ""
            resetDefaults()
            tweetView.removeFromSuperview()
            self.welcomeBox.isHidden = false
            self.lblMadeBy.isHidden = false
        }
    }
    
    func changeThem() {
        
        welcomeBox.fillColor = .black //NSColor(red:0.02, green:0.08, blue:0.21, alpha:1.0)
        topBar.fillColor =  .black //NSColor(red:0.02, green:0.08, blue:0.21, alpha:1.0)
        bottomBar.fillColor = .black //NSColor(red:0.02, green:0.08, blue:0.21, alpha:1.0)
        //if self.view.layer != nil {
        
        // let color : CGColor = CGColor(red:0.02, green:0.08, blue:0.21, alpha:1.0)
        // self.view.layer?.backgroundColor = color
        
        
        // self.tweetView.layer?.backgroundColor = color
        
        //}
    }
}


