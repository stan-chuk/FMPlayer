//
//  playViewController.swift
//  FMPlayer
//
//  Created by 祝韶明 on 16/5/10.
//  Copyright © 2016年 祝韶明. All rights reserved.
//

import UIKit

class playViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    
    let songURL = NSURL(string: "https://douban.fm/j/mine/playlist?type=n&channel=9&from=mainsite")
    var songArray: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = NSData(contentsOfURL: self.songURL!)
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            if jsonData["song"] != nil {
                self.songArray = jsonData["song"] as! NSArray
            }
        } catch let error as NSError {
            print("\(error.domain)")
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlayControl(sender: UIButton) {
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("song", forIndexPath: indexPath)
        let cellData = self.songArray[indexPath.row] as! NSDictionary
        let imageURLString = cellData["picture"] as? String
        let imageURL = NSURL(string: imageURLString!)
        let imageData = NSData(contentsOfURL: imageURL!)
        let image = UIImage(data: imageData!)
        cell.textLabel?.text = cellData["title"] as? String
        cell.detailTextLabel?.text = cellData["artist"] as? String
        cell.imageView?.image = image
        
        return cell
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
