//
//  AppDelegate.swift
//
//  Copyright (c) 2016 Orderella Ltd. (http://orderella.co.uk)
//  Author - Martin Wildfeuer (http://www.mwfire.de)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import PopupDialog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Uncomment for a dark theme demo

//        // Customize dialog appearance
//        let pv = PopupDialogDefaultView.appearance()
//        pv.titleFont    = UIFont(name: "HelveticaNeue-Light", size: 16)!
//        pv.titleColor   = UIColor.white
//        pv.messageFont  = UIFont(name: "HelveticaNeue", size: 14)!
//        pv.messageColor = UIColor(white: 0.8, alpha: 1)
//
//        // Customize the container view appearance
//        let pcv = PopupDialogContainerView.appearance()
//        pcv.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
//        pcv.cornerRadius    = 2
//        pcv.shadowEnabled   = true
//        pcv.shadowColor     = UIColor.black
//
//        // Customize overlay appearance
//        let ov = PopupDialogOverlayView.appearance()
//        ov.blurEnabled = true
//        ov.blurRadius  = 30
//        ov.liveBlur    = true
//        ov.opacity     = 0.7
//        ov.color       = UIColor.black
//
//        // Customize default button appearance
//        let db = DefaultButton.appearance()
//        db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
//        db.titleColor     = UIColor.white
//        db.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
//        db.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)
//
//        // Customize cancel button appearance
//        let cb = CancelButton.appearance()
//        cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
//        cb.titleColor     = UIColor(white: 0.6, alpha: 1)
//        cb.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
//        cb.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)

        return true
    }
}
