//
//  CenterViewController.swift
//  GigyaSwift
//
//  Created by Evan Ostroski on 8/26/16.
//  Copyright © 2016 Gigya. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController {

    var delegate: CenterViewControllerDelegate?
    var appDelegate: AppDelegate?
    var currentState: SlideOutState = .BothCollapsed
    
    @IBOutlet weak var sessionInfo: UITextView!
    
    // MARK: Button actions
    
    @IBAction func actionsTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        delegate?.toggleRightPanel?()
    }
    
    @IBAction func mobileSessionCheckButtonAction(sender: AnyObject) {
        print("mobileSessionCheckButtonAction called")
        
        // Is there a Gigya session?
        if Gigya.isSessionValid() {
            let request = GSRequest(forMethod: "accounts.getAccountInfo")
            request.sendWithResponseHandler({(response: GSResponse?, error: NSError?) -> Void in
                if (error == nil) {
                    self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    self.appDelegate!.user = response as? GSAccount

                    let alert = UIAlertController(title: "Gigya Session Test",
                        message: "User is logged in\n\(response!["profile"]["firstName"]) \(response!["profile"]["lastName"]), \(response!["profile"]["email"])",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
                        print("Alert closed")
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else {
                    print("Got error on getAccountInfo: \(error)")
                }
            })
        }
        else {
            let alert = UIAlertController(title: "Gigya Session Test",
                                          message: "You are not logged in",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
                print("Alert closed")
                })
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Is there a Gigya session?
        updateSessionInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: GIGYA
    func updateSessionInfo() {
        if Gigya.isSessionValid() {
            let request = GSRequest(forMethod: "accounts.getAccountInfo")
            request.sendWithResponseHandler({(response: GSResponse?, error: NSError?) -> Void in
                if (error == nil) {
                    self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    self.appDelegate!.user = response as? GSAccount
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
