//
//  AppDelegate.swift
//  Demagnetizer
//
//  Created by sid on 17/03/2020.
//  Copyright © 2020 com.sergiomtzlosa.demagnetizer. All rights reserved.
//

import Cocoa

let SCREEN_WIDTH : CGFloat = 750.0
let SCREEN_HEIGHT : CGFloat = 370.0

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSComboBoxDelegate {

    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var aValue: NSTextField!
    @IBOutlet weak var bValue: NSTextField!
    @IBOutlet weak var cValue: NSTextField!
    @IBOutlet weak var jsValue: NSTextField!
    @IBOutlet weak var axeValue: NSComboBox!
    
    @IBOutlet weak var demagValue: NSTextField!
    @IBOutlet weak var energyDensityValue: NSTextField!
    @IBOutlet weak var energyValue: NSTextField!
    
    @IBOutlet weak var itemAxeValue: NSTextField!

    internal class func sharedDelegate() -> AppDelegate
    {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
          
          return true;
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.window.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isEnabled = false   
        self.window.setFrame(self.windowRect(), display: true)
        self.window.center()
        
        axeValue.delegate = self
        axeValue.selectItem(at: 0)
        
        aValue.focusRingType = .none
        bValue.focusRingType = .none
        cValue.focusRingType = .none
        jsValue.focusRingType = .none
        axeValue.focusRingType = .none
        
        demagValue.focusRingType = .none
        demagValue.isEditable = false
        
        energyDensityValue.focusRingType = .none
        energyDensityValue.isEditable = false
        
        energyValue.focusRingType = .none
        energyValue.isEditable = false
        
        aValue.becomeFirstResponder()
    }

    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        let comboBox: NSComboBox = (notification.object as? NSComboBox)!
   
        let index: Int = comboBox.indexOfSelectedItem
        
        itemAxeValue.stringValue = "Demagnetizing factor on axe \(indexToAxe(index: index)):"
    }

    func indexToAxe(index: Int) -> String {
        
        var str_axe: String = "x"
            
        if index == 1 {

            str_axe = "y"
        }
        
        if index == 2 {
            
            str_axe = "z"
        }
        
        return str_axe
    }
    
    func replaceCommaString(value: String) -> Float {
        
        let result: String = value.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "");
        
        var fValue: Float = 0.0
        
        if result != "" {
            fValue = Float(result)!
        }
        
        return fValue
    }
    
    @IBAction func calculateEnergy(sender: Any) {
    
        let a_value: Float = replaceCommaString(value: aValue?.stringValue ?? "")
        let b_value: Float = replaceCommaString(value: bValue?.stringValue ?? "")
        let c_value: Float = replaceCommaString(value: cValue?.stringValue ?? "")
        let js_value: Float = replaceCommaString(value: jsValue?.stringValue ?? "")
        let demag_axe: Int = axeValue.indexOfSelectedItem;

        var a: Float = 1*a_value
        var b: Float = 1*b_value
        var c: Float = 1*c_value
        var js: Float = 1*js_value
        
        if demag_axe == 1 {
            
            a = 1*c_value
            b = 1*a_value
            c = 1*b_value
            js = 1*js_value
        }
    
        if demag_axe == 2 {
            
            a = 1*b_value
            b = 1*c_value
            c = 1*a_value
            js = 1*js_value
        }
    
        let a2: Float = a*a
        let b2: Float = b*b
        let c2: Float = c*c
        let abc: Float = a*b*c
        let bc: Float = b*c
        let ac: Float = a*c
        let ab: Float = a*b
        let r: Float = sqrt(a2+b2+c2)
        let rab: Float = sqrt(a2+b2)
        let rbc: Float = sqrt(b2+c2)
        let rac: Float = sqrt(a2+c2)
        let pi_axe: Float = ((b2-c2)/(2*bc))*log10((r-a)/(r+a))+((a2-c2)/(2*ac))*log10((r-b)/(r+b))+(b/(2*c))*log10((rab+a)/(rab-a))+(a/(2*c))*log10((rab+b)/(rab-b))+(c/(2*a))*log10((rbc-b)/(rbc+b))+(c/(2*b))*log10((rac-a)/(rac+a))+2*atan2(ab,c*r)+(a2*a+b2*b-2*c2*c)/(3*abc)+((a2+b2-2*c2)/(3*abc))*r+(c/ab)*(rac+rbc)-(rab*rab*rab+rbc*rbc*rbc+rac*rac*rac)/(3*abc)
    
        let demagnitized_factor: Float = pi_axe/3.1415927
    
        let Ms: Float = js/(4*3.1415927*1e-4)
        let energydensity: Float = 2*3.1415927*Ms*Ms*demagnitized_factor/10
        let energy2: Float = 2*a*2*b*2*c*energydensity*1e-6/(1.38*3)

        itemAxeValue.stringValue = "Demagnetizing factor on axe \(indexToAxe(index: demag_axe)):"
        demagValue.floatValue = demagnitized_factor.isNaN ? 0.0 : demagnitized_factor
        energyDensityValue.floatValue = energydensity.isNaN ? 0.0 : energydensity/1000
        energyValue.floatValue = energy2.isNaN ? 0.0 : energy2
        
//        print("")
//        print("          Demagnetizing factor calculation for a prism figure")
//        print("          ---------------------------------------------------")
//        print("")
//        print(" - Demagnetizing factor on axe \(str_axe): \(demagnitized_factor)")
//        print(" - Energy density [kJ/m3]: \(energydensity/1000)")
//        print(" - Energy [kB 300 K]: \(energy2)")
//        print("")
    }
    
    //MARK: -
    //MARK: Other methods
    
    func windowRect() -> NSRect
    {
        return NSMakeRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    }
    
    class func applicationName() -> String
    {
        let dict : Dictionary = (Bundle.main.infoDictionary as Dictionary?)!
           
        return (dict["CFBundleExecutable"] as? String)!
    }
    
    class func currentWindow() -> NSWindow
    {
        return AppDelegate.sharedDelegate().window;
    }
}

