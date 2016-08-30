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
    
    @IBOutlet weak var sessionInfo: UITextView!
    
    
    @IBAction func logout(sender: AnyObject) {
        Gigya.logoutWithCompletionHandler( { (response: GSResponse?, error: NSError?) -> Void in
            self.user = nil
            if (error != nil) {
                let alert = UIAlertController(title: "Gigya Native Mobile Logout",
                    message: "There was a problem logging out off Gigya. Gigya returned error code \(error!.code)",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
                    print("Alert closed")
                    })
                self.presentViewController(alert, animated: true, completion: nil)
                print("logout Error:\(error!.localizedDescription)")
            } else {
                self.updateSessionInfo()
            }
        })
        
    }
    
    @IBAction func nativeLoginButtonAction(sender: AnyObject) {
        if Gigya.isSessionValid() {
            if ( self.user == nil ) {
                // Make Request to 'accounts.getAccountInfo' since we're in a valid session, make sure it's not empty.
                // Step 1 - Create the request and set the parameters
                let request = GSRequest(forMethod: "accounts.getAccountInfo")
                request.sendWithResponseHandler({(response: GSResponse?, error: NSError?) -> Void in
                    if (error == nil) {
                        self.user = response as? GSAccount
                    }
                    else {
                        print("Got error on getAccountInfo: \(error)")
                    }
                })
            }
            let alert = UIAlertController(title: "Gigya Native Login",
                                          message: "You are already logged in",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
                print("Alert closed")
                })
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            // To set parameters, you can use a Swift dictionary instead of an NSMutableDictionary
            var params = [String: AnyObject]()
            params["facebookLoginBehavior"] = Int(FBSDKLoginBehavior.Native.rawValue)
            // Removing the above example parameter due to FB's recent breaking change to the Native Login Behavior
            params.removeAll()
            
            Gigya.showLoginProvidersDialogOver(self,
                                               providers: ["facebook", "twitter", "googleplus", "linkedin"],
                                               parameters: params,
                                               completionHandler:  { (user: GSUser?, error: NSError?) -> Void in
                                                if (error != nil && error!.code != 200001) {
                                                    let alert = UIAlertController(title: "Gigya Native Mobile Login",
                                                        message: "There was a problem logging in with Gigya. Gigya returned error code \(error!.code)",
                                                        preferredStyle: UIAlertControllerStyle.Alert)
                                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
                                                        print("Alert closed")
                                                        })
                                                    self.presentViewController(alert, animated: true, completion: nil)
                                                    print("showLoginProvidersDialogOver Error:\(error!.localizedDescription)")
                                                } else {
                                                    if let json = user!.JSONString() {
                                                        print("User: \(json)")
                                                    }
                                                    self.updateSessionInfo()
                                                }
                }
            )
        }
    }
    
    @IBAction func showScreenSet(sender: AnyObject) {
        print("showScreenSet called")
        var params = [String: AnyObject]()
        params["screenSet"] = "DefaultMobile-RegistrationLogin"
        Gigya.showPluginDialogOver(self,
            plugin: "accounts.screenSet",
            parameters: params,
            completionHandler: {(closedByUser: Bool?, error: NSError?) -> Void in
                if(error == nil) {
                    print("Login was successful")
                    self.updateSessionInfo()
                }
                else {
                    // Handle error
                    let alert = UIAlertController(title: "Error with login",
                        message: error!.localizedDescription,
                        preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
                        print("Alert closed")
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            },
            delegate: self)
    }
    
        
    @IBAction func doneWithView(segue:UIStoryboardSegue) {
        
    }
    
    func updateSessionInfo() {
        if Gigya.isSessionValid() {
            let request = GSRequest(forMethod: "accounts.getAccountInfo")
            request.sendWithResponseHandler({(response: GSResponse?, error: NSError?) -> Void in
                if (error == nil) {
                    self.user = response as? GSAccount
                    self.sessionInfo.text = "User is logged in\n\(response!["profile"]["firstName"]) \(response!["profile"]["lastName"]), \(response!["profile"]["email"])"
                }
                else {
                    self.sessionInfo.text = "Got error on getAccountInfo: \(error)"
                }
            })
        }
        else {
            sessionInfo.text = "Not logged in"
        }
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
        let alert = UIAlertController(title: "Gigya Session Test",
                                      message: "You have logged in",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
            print("Alert closed")
            })
        self.presentViewController(alert, animated: true, completion: nil)
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
        // Is there a Gigya session?
        updateSessionInfo()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


