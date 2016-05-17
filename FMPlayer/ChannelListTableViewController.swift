//
//  ChannelListTableViewController.swift
//  FMPlayer
//
//  Created by 祝韶明 on 16/5/7.
//  Copyright © 2016年 祝韶明. All rights reserved.
//

import UIKit

protocol ChannelProtocol {
    func changeChannel(channel_id: String)
}

class ChannelListTableViewController: UITableViewController {

    let channelURL = NSURL(string: "https://www.douban.com/j/app/radio/channels")
    var channelArray: NSArray = []
    var delegate: ChannelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取频道信息
        let data = NSData(contentsOfURL: self.channelURL!)
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            if jsonData["channels"] != nil {
                self.channelArray = jsonData["channels"] as! NSArray
                print("First print: \(jsonData)")
            }
        } catch let error as NSError {
            print("\(error.domain)")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("\(self.channelArray.count)")
        return self.channelArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("channel", forIndexPath: indexPath)
        let cellData: NSDictionary = self.channelArray[indexPath.row] as! NSDictionary
        print("Second print: \(cellData)")
        
        if cellData["name"] != nil {
            cell.textLabel?.text = cellData["name"] as? String
        }
        

        return cell
    }
    
    //通过代理传递频道的 id 回播放页面
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellData: NSDictionary = self.channelArray[indexPath.row] as! NSDictionary
        let channel_id: String = "\(cellData["channel_id"]!)"
        print(channel_id)
        self.delegate?.changeChannel(channel_id)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
