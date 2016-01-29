//
//  DetailsViewController.swift
//  Instagram
//
//  Created by Tejen Hasmukh Patel on 1/28/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var photoURL: String?;
    @IBOutlet weak var browser: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        browser.loadRequest(NSURLRequest(URL: NSURL(string: photoURL!)!));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
