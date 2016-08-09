//
//  GSWebBridgeViewController.swift
//  GigyaSwift
//
//  Created by Evan Ostroski on 5/5/16.
//  Copyright © 2016 NRasool. All rights reserved.
//

import Foundation

class GSWebBridgeViewController:  UIViewController,GSWebBridgeDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var webBridgeWebView: UIWebView!
    
    override func loadView() {
        super.loadView()
        GSWebBridge.registerWebView(webBridgeWebView, delegate: self)
        webBridgeWebView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the web bridge URL
        let urlAddress = "http://demos.gigya-cs.com/main_demo.html"
        if let url = NSURL.init(string: urlAddress) {
            let request = NSURLRequest.init(URL: url)
            webBridgeWebView.loadRequest(request)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        GSWebBridge.unregisterWebView(webBridgeWebView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if GSWebBridge.handleRequest(request, webView: webView) {
            return false
        }
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        GSWebBridge.webViewDidStartLoad(webView)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        let alert = UIAlertController(title: "GSWebBridge Error",
                                      message: error?.description,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
            print("Alert closed")
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }
}