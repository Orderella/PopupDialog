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


    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: Any]?) -> Bool {

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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
