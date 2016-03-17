//
//  ViewController.swift
//  GigyaSwift
//
//  Created by NRasool on 04/03/2016.
//  Copyright © 2016 NRasool. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func myButtonPressed(sender: AnyObject) {
        
        Gigya.showLoginProvidersDialogOver(self,
            providers: ["facebook", "twitter", "googleplus"],
            parameters: nil,
            completionHandler:  {(user: GSUser!, error: NSError!) -> Void in
                if error != nil {
                    print("showLoginProvidersDialogOver Error: \(error.localizedDescription)")
                } else {
                    if let json = user.JSONString() {
                        print("User: \(json)")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewControllerWithIdentifier("CommentViewController") as UIViewController // Explicit cast is required here.
                        viewController.modalTransitionStyle = .CoverVertical
                        self.presentViewController(viewController, animated: true, completion: nil)
                        
                    }
                }
            })
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

