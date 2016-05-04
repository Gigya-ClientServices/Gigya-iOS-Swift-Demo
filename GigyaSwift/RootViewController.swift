//
//  RootViewController.swift
//  GigyaSwift
//
//  Created by Evan Ostroski on 5/3/16.
//  Copyright © 2016 NRasool. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, GSPluginViewDelegate, GSAccountsDelegate {
    
    var user: GSAccount?
    
    @IBAction func nativeLoginButtonAction(sender: AnyObject) {
        if (Gigya.session() == nil) {
            // To set parameters, you can use a Swift dictionary instead of an NSMutableDictionary
            var params = [String: AnyObject]()
            //params["facebookLoginBehavior"] = Int(FBSDKLoginBehavior.Native.rawValue)

            Gigya.showLoginProvidersDialogOver(self,
                providers: ["facebook", "twitter", "googleplus", "linkedin"],
                parameters: params,
                completionHandler:  { (user: GSUser!, error: NSError!) -> Void in
                    if (error != nil && error.code != 200001) {
                        let alert = UIAlertView(title: "Gigya Native Mobile Login",
                            message: "There was a problem logging in with Gigya. Gigya returned error code \(error.code)",
                            delegate: nil,
                            cancelButtonTitle:"OK"
                        )
                        alert.show()
                        print("showLoginProvidersDialogOver Error:\(error.localizedDescription)")
                    } else {
                        // Anything?
                        if let json = user.JSONString() {
                            print("User: \(json)")
                        }
                    }
                }
            )
        }
        else {
            if ( self.user == nil ) {
                // Make Request to get User if it's empty.
                // Step 1 - Create the request and set the parameters
                let request = GSRequest(forMethod: "accounts.getAccountInfo")
                request.sendWithResponseHandler({(response: GSResponse!, error: NSError!) -> Void in
                    if (error == nil) {
                        self.user = response as? GSAccount
                    }
                    else {
                        print("Got error on getAccountInfo: \(error)")
                    }
                })
            }
            let alert = UIAlertView(title: "Alert",
                                    message: "You are already logged in!",
                                    delegate: nil,
                                    cancelButtonTitle:"OK"
            )
            alert.show()
        }
    }
    
    @IBAction func showScreenSet(sender: AnyObject) {
        print("showScreenSet called")
        var params = [String: AnyObject]()
        params["screenSet"] = "DefaultMobile-RegistrationLogin"
        Gigya.showPluginDialogOver(self,
            plugin: "accounts.screenSet",
            parameters: params,
            completionHandler: {(closedByUser: Bool!, error: NSError!) -> Void in
                if(error == nil) {
                    print("Login was successful")
                }
                else {
                    // Handle error
                    let alert = UIAlertView(title: "Error with login",
                        message: error.localizedDescription,
                        delegate: nil,
                        cancelButtonTitle:"OK"
                    )
                    alert.show()
                }
            },
            delegate: self)
    }
    
    //
    // GSPluginViewDelegate methods
    //
    func pluginView(pluginView: GSPluginView!, finishedLoadingPluginWithEvent event: [NSObject : AnyObject]!) {
        print("Finished loading plugin with event: \(event)")
    }
    
    func pluginView(pluginView: GSPluginView!, firedEvent event: [NSObject : AnyObject]!) {
        print("Plugin fired event: \(event)")
    }
    
    func pluginView(pluginView: GSPluginView!, didFailWithError error: NSError!) {
        print("Plugin failed with error: \(error)")
    }
    
    //
    // GSAccountsDelegate
    //
    func accountDidLogin(account: GSAccount) -> Void {
        self.user = account
        let alert = UIAlertView(title: "Gigya Session Test",
                                message: "You have logged in!",
                                delegate: nil,
                                cancelButtonTitle:"OK"
        )
        alert.show()
    }
    
    func accountDidLogout() -> Void {
        self.user = nil
    }
    
    //
    // Standard UIViewController method stubs
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


