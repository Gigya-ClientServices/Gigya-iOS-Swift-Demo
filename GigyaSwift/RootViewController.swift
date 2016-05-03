//
//  RootViewController.swift
//  GigyaSwift
//
//  Created by Evan Ostroski on 5/3/16.
//  Copyright © 2016 NRasool. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    var user: GSAccount?
    
    @IBAction func nativeLoginButtonAction(sender: AnyObject) {
        if (Gigya.session() == nil) {
            var params: NSMutableDictionary
            Gigya.showLoginProvidersDialogOver(self,
                                               providers: ["facebook", "twitter", "googleplus", "linkedin"],
                                               parameters: nil,
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
                                                    if let json = user.JSONString() {
                                                        print("User: \(json)")
                                                        //let storyboard = UIStoryboard(name: "Root", bundle: nil)
                                                        //let viewController = storyboard.instantiateViewControllerWithIdentifier("CommentViewController") as UIViewController // Explicit cast is required here.
                                                        //viewController.modalTransitionStyle = .CoverVertical
                                                        //self.presentViewController(viewController, animated: true, completion: nil)
                                                    }
                                                }
                                            })
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


