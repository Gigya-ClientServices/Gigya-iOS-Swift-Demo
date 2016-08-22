//
//  CommentViewController.swift
//  GigyaSwift
//
//  Created by Evan Ostroski on 8/11/16.
//  Copyright © 2016 NRasool. All rights reserved.
//

import UIKit

class CommentViewController : UIViewController, GSPluginViewDelegate {
   
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showCommentsAsDialog(sender: AnyObject) {
        var params : [String : AnyObject] = [:]
        params["categoryID"] = "Comments"
        params["streamID"] = "Gigya-iOS-Demos"
        
        Gigya.showPluginDialogOver(self,
                                   plugin: "comments.commentsUI",
                                   parameters: params,
                                   completionHandler: {(closedByUser : Bool?, error : NSError?) -> Void in
                                    if error == nil {
                                        //success
                                    }
                                    else {
                                        //Handle error
                                    }
        })
    }
    
    @IBAction func showCommentsAsSubView(sender: AnyObject) {
        let statBarHeight = Float(UIApplication.sharedApplication().statusBarFrame.size.height)
        var params : [String : AnyObject] = [:]
        params["categoryID"] = "Comments"
        params["streamID"] = "Gigya-iOS-Demos"
        
        let pluginView = GSPluginView.init(frame: CGRectMake(0,
                                                             UIScreen.mainScreen().applicationFrame.size.height/2,
                                                             UIScreen.mainScreen().applicationFrame.size.width,
                                                             UIScreen.mainScreen().applicationFrame.size.height/2 + CGFloat(statBarHeight)))
        pluginView.delegate = self
        
        pluginView.loadPlugin("comments.commentsUI", parameters: params)
        self.view.addSubview(pluginView)
    }
}

