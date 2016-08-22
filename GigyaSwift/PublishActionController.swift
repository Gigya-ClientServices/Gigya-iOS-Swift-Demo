//
//  PublishActionController.swift
//  
//
//  Created by Evan Ostroski on 8/9/16.
//
//

import UIKit

class PublishActionController: UIViewController {
    
    @IBOutlet weak var shareText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func publishButtonAction(sender: AnyObject?) {
        if (Gigya.session() == nil) {
            let alert = UIAlertController(title: "Gigya User Action Publish",
                                          message: "You must be logged in to do that!",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
                print("Alert closed")
                })
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            if Gigya.session().lastLoginProvider == "facebook" {
                Gigya.requestNewFacebookPublishPermissions("publish_actions",
                                                           responseHandler: { (granted: Bool, error: NSError!, declinedPermissions: [AnyObject]!) -> Void in
                                                            if granted == false {
                                                                let alert = UIAlertController(title: "Gigya User Action Publish",
                                                                    message: error.description,
                                                                    preferredStyle: UIAlertControllerStyle.Alert)
                                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
                                                                    print("Alert closed")
                                                                    })
                                                                self.presentViewController(alert, animated: true, completion: nil)
                                                                return;
                                                            }
                })
            }
            var userAction : [String: AnyObject] = [:]
            if Gigya.session().lastLoginProvider == "twitter" {
                userAction["title"] = self.shareText.text
            }
            else {
                userAction["title"] = "Gigya iOS SDK Demos"
                userAction["linkback"] = "http://gigya.com"
                userAction["description"] = self.shareText.text
            }
            
            var jsonData : NSData?
            jsonData = try? NSJSONSerialization.dataWithJSONObject(userAction, options: .PrettyPrinted )
            if jsonData != nil {
                let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)!
                
                let request = GSRequest.init(forMethod: "socialize.publishUserAction")
                request.parameters!.setObject(jsonString, forKey: "userAction")
                
                request.sendWithResponseHandler({ (response: GSResponse?, error: NSError?) -> Void in
                    if error == nil {
                        print("success")
                    }
                    else {
                        print("error")
                        print(error!.description)
                    }
                })
            }
        }
    }
}
