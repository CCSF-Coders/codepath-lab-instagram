//
//  PhotosViewController.swift
//  Flicks
//
//  CodePath University 2016 - Week 1 Assignment: "Flicks"
//
//  Created by Tejen Patel on 1/23/16.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var photos: [NSDictionary]?;
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var photoTableView: UITableView!
    
    let CellIdentifier = "TableViewCell", HeaderViewIdentifier = "TableViewHeaderView";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        photoTableView.dataSource = self;
        photoTableView.delegate = self;
        photoTableView.rowHeight = 320;
        photoTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        photoTableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)

        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
//                          NSLog("response: \(responseDictionary)")
                            self.photos = responseDictionary["data"] as? [NSDictionary];
                            self.photoTableView.reloadData();
                    }
                }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let photos = photos {
            return photos.count;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell;
        
        if let photos = photos {
            let photoURL = photos[indexPath.section]["images"]!["standard_resolution"]!!["url"] as! String;
            
            cell.photoView.setImageWithURL(NSURL(string: photoURL)!);
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50));
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9);
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 13, width: 30, height: 30));
        profileView.clipsToBounds = true;
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        let usernameView = UILabel(frame: CGRect(x: 50, y: 13, width: 150, height: 30));
//        usernameView.center = CGPointMake(100, 25);
        usernameView.textAlignment = NSTextAlignment.Left;
        usernameView.font = UIFont(name: "Helvetica-Bold", size: 14);
        usernameView.textColor = UIColor(red: 0.247, green: 0.4471, blue: 0.608, alpha: 1.0);
        
        if let photos = photos {
            profileView.setImageWithURL(
                NSURL(string: photos[section]["user"]!["profile_picture"] as! String)!
            );
        
            usernameView.text = photos[section]["user"]!["username"] as? String;
        }
        
        headerView.addSubview(profileView);
        headerView.addSubview(usernameView);
        return headerView;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toDetails") {
            let cell = sender as! UITableViewCell;
            let indexPath = tableView.indexPathForCell(cell);
            let photo = photos![indexPath!.section];
            let detailsViewController = segue.destinationViewController as! DetailsViewController;
            detailsViewController.photoURL = photo["link"]! as! String;
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
