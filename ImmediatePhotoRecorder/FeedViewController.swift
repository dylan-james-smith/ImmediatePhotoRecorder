//
//  FeedViewController.swift
//  ImmediatePhotoRecorder
//
//  Created by Dylan Smith on 3/6/16.
//  Copyright © 2016 com.heydylan. All rights reserved.
//


import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var photos: [PFObject]?
//    var parseData: [PFObject]?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let photos = photos {
            return photos.count
        } else {
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "photoDidPost:", name: "photoDidPost", object: nil)
        requestData(nil)

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        self.automaticallyAdjustsScrollViewInsets = false
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedCell
        if let photos = photos {
            let photo = photos[indexPath.section]
            cell.captionLabel.text = photo["caption"] as? String
            let file = photo["media"] as? PFFile
            file?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                cell.feedImageView.image = UIImage(data: data!)
            })
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 60))
        headerView.userInteractionEnabled = true
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 45, height: 45))
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 22.5;
        profileImageView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileImageView.layer.borderWidth = 1;
        
        let user = photos![section]["author"] as! PFUser
        
        let imageFile = user["profile"] as? PFFile
        imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            
            profileImageView.image = UIImage(data: data!)
            
        })
        
        let username = UILabel(frame: CGRect(x: 70, y: 25, width: 50, height: 20))
        username.text = user.username
        headerView.addSubview(username)
        
        headerView.addSubview(profileImageView)
        
        headerView.tag = section
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "onHeader:")
        headerView.addGestureRecognizer(tapRecognizer)
        
        // Add a UILabel for the username here
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    
    func requestData(completion: (()-> Void)? ) {
        let query = PFQuery(className: "ParseData")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                self.photos = media
                self.tableView.reloadData()
                if let completion = completion {
                    completion()
                }
                print("By the power of data, I have the DATA")
            } else {
                print("requestData find objets error")
            }
        }
    }
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        requestData { () -> Void in
            refreshControl.endRefreshing()
        }
        
    }
    
    func photoDidPost(notification: NSNotification) {
        requestData(nil)
    }
    
    func onHeader(recognizer: UIGestureRecognizer) {
        performSegueWithIdentifier("showProfile", sender: recognizer.view?.tag)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "showProfile" {
            let tag = sender as! Int
            let user = photos![tag]["author"] as! PFUser
            let vc = segue.destinationViewController as! ProfileViewController
            vc.user = user
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.image = UIImage(named: "Home")
        navigationItem.backBarButtonItem = backItem
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