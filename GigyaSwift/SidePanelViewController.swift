//
//  SidePanelViewController.swift
//  GigyaSwift
//
//  Created by Evan Ostroski on 8/26/16.
//  Copyright © 2016 Gigya. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController, GSPluginViewDelegate, GSAccountsDelegate {
    
    var appDelegate: AppDelegate?

    override func viewDidLoad() {
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sideDoneWithView(segue:UIStoryboardSegue) {
        let parent = self.parentViewController as! ContainerViewController
            
        parent.centerViewController!.updateSessionInfo()
    }
    
    @IBAction func logout(sender: AnyObject) {
        Gigya.logoutWithCompletionHandler( { (response: GSResponse?, error: NSError?) -> Void in
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
                // Center View updates
            }
        })
        
    }
    
    @IBAction func nativeLoginButtonAction(sender: AnyObject) {
        if Gigya.isSessionValid() {
            if appDelegate?.user == nil {
                // Make Request to 'accounts.getAccountInfo' since we're in a valid session, make sure it's not empty.
                // Step 1 - Create the request and set the parameters
                let request = GSRequest(forMethod: "accounts.getAccountInfo")
                request.sendWithResponseHandler({(response: GSResponse?, error: NSError?) -> Void in
                                                if (error == nil) {
                                                    if let ad = self.appDelegate {
                                                        ad.user = response as? GSAccount
                                                    }
                                                }
                                                else {
                                                    print("Got error on getAccountInfo: \(error)")
                                                }
                })
            }
            
            // Regardless of whether the locally stored user is refreshed
            let alert = UIAlertController(title: "Gigya Native Login",
                                          message: "You are already logged in",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertActionStyle.Default) { (action) -> Void in
                                            print("Alert closed")
            })
            self.presentViewController(alert, animated: true, completion: nil)
        
        } else {
            // No valid session from Gigya, proceed with login
            
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
                                                    if let ad = self.appDelegate {
                                                        if let user = ad.user {
                                                            if let json = user.JSONString() {
                                                                 print ("User: \(json)")
                                                            }
                                                        }
                                                    }
                                                }
                                            })
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
                                    if error == nil && !closedByUser! {
                                        print("Login was successful")
                                    }
                                    else if error != nil {
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
    
    //
    // GSAccountsDelegate
    //
    func accountDidLogin(account: GSAccount) -> Void {
        self.appDelegate!.user = account
        let alert = UIAlertController(title: "Gigya Session Test",
                                      message: "You have logged in",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
            print("Alert closed")
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func accountDidLogout() -> Void {
        self.appDelegate!.user = nil
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
