//
//  AppDelegate.swift
//  MacTweeter
//
//  Created by Shehan on 5/20/18.
//  Copyright © 2018 app360. All rights reserved.
//

import Cocoa
import SwifterMac
import Fabric
import Crashlytics
import Magnet


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ notification: Notification) {
        
      ///   NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown, handler: myKeyDownEvent)
      
        
    Fabric.with([Crashlytics.self])
        
       NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        LSSetDefaultHandlerForURLScheme("swifter" as CFString, Bundle.main.bundleIdentifier! as CFString)
        
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "StatusBarButtonImage"))
            button.action = #selector(AppDelegate.togglePopover(_:))
     //       button. = NSImage(named: NSImage.Name(rawValue: "StatusBarButtonImage"))
        }
        
        let mainViewController = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ViewControllerId")) as! ViewController
        
      //  NSApplication.shared.activate(ignoringOtherApps: true)
        NSApp.activate(ignoringOtherApps: true)
        NSApp.activationPolicy()
        popover.behavior =  .transient
        popover.contentViewController = mainViewController
        
        eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [weak self] event in
            if let popover = self?.popover {
                if popover.isShown {
                    self?.closePopover(event)
                }
            }
        }
        eventMonitor?.start()
       
     
        HotKeyCenter.shared.unregisterAll()
        //　Control　Double Tap
        guard let keyCombo5 = KeyCombo(doubledCocoaModifiers: .control) else { return }
        let hotKey5 = HotKey(identifier: "ControlDoubleTap123",
                             keyCombo: keyCombo5,
                             target: self,
                             action: #selector(AppDelegate.togglePopover(_:)))
        hotKey5.register()
    }
    func applicationWillFinishLaunching(_ notification: Notification) {
     
    }
    @objc func handleEvent(_ event: NSAppleEventDescriptor!, withReplyEvent: NSAppleEventDescriptor!) {
        Swifter.handleOpenURL(URL(string: event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!)!)
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        HotKeyCenter.shared.unregisterAll()
    }
    @objc func togglePopover(_ sender: AnyObject?) {
        
     //   NSApp.activate(ignoringOtherApps: true)
       // NSApp.activationPolicy()
      //  popover.behavior = .transient
    
       // eventMonitor?.start()

        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
       }
       
    }
 
    
    func showPopover(_ sender: AnyObject?) {
        
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func myKeyDownEvent(event: NSEvent) -> NSEvent
    {
  
        if event.keyCode == 53 {
            //popover.performClose(sender)
            self.closePopover(event)
            
        }
     
        
      
            return event
    }
    
    @objc func tappedHotKey() {
        
      
        
     //   eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [weak self] event in
           // if let popover = self?.popover {
              //  if popover.isShown {
//self?.closePopover(event)
              //  }
            //}
       // }
      //  eventMonitor?.start()
    }

}
