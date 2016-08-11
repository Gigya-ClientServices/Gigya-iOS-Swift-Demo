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
            userAction["title"] = "Gigya iOS SDK Demos"
            userAction["description"] = self.shareText.text
            //let userActionData = NSKeyedArchiver.archivedDataWithRootObject(userAction)
            
            var jsonData : NSData?
            jsonData = try? NSJSONSerialization.dataWithJSONObject(userAction, options: .PrettyPrinted )
            if jsonData != nil {
                var jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)!
                
                var request = GSRequest.init(forMethod: "socialize.publishUserAction")
                request.parameters.setObject(jsonString, forKey: "userAction")
                
                request.sendWithResponseHandler({ (response: GSResponse!, error: NSError!) -> Void in
                    if error == nil {
                        print("success")
                    }
                    else {
                        print("error")
                        print(error.description)
                    }
                })
            }
        }
    }
}
