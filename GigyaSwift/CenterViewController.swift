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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
            if let ad = appDelegate {
                if ad.user == nil {
                    let request = GSRequest(forMethod: "accounts.getAccountInfo")
                    request.sendWithResponseHandler({(response: GSResponse?, error: NSError?) -> Void in
                        if (error == nil) {
                            ad.user = response as? GSAccount
                            self.sessionInfo.text = "User is logged in\nFirst Name: \(response!["profile"]["firstName"])\nLast Name: \(response!["profile"]["lastName"])\nEmail: \(response!["profile"]["email"])"
                        }
                        else {
                            self.sessionInfo.text = "Got error on getAccountInfo: \(error)"
                        }
                    })
                }
            }
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
