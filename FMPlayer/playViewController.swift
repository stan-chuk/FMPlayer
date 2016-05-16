//
//  playViewController.swift
//  FMPlayer
//
//  Created by 祝韶明 on 16/5/10.
//  Copyright © 2016年 祝韶明. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class playViewController: UIViewController, UITableViewDataSource, ChannelProtocol {

    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //默认说唱频道
    var songURL = NSURL(string: "https://douban.fm/j/mine/playlist?type=n&channel=15&from=mainsite")
    var songArray: NSArray = []
    var imageCache:Dictionary = [String: UIImage]()
    var audioPlayer = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取歌曲信息
        let data = NSData(contentsOfURL: self.songURL!)
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            if jsonData["song"] != nil {
                self.songArray = jsonData["song"] as! NSArray
                tableView.reloadData()
            }
        } catch let error as NSError {
            print("\(error.domain)")
        }
        
        let firstSong = songArray[0] as! NSDictionary
        
        //获取第一首歌的歌曲URL
        let firstSongURL = firstSong["url"] as! String
        print("First song URL \(firstSongURL)")
        playSong(firstSongURL)
        
        //获取第一首歌的封面URL
        let firstSongImage = firstSong["picture"] as! String
        print("First song image")
        onSetSongImage(firstSongImage)
        
        // Do any additional setup after loading the view.
    }

    //设置歌曲封面
    func onSetSongImage(url: String) {
        let imageURL = NSURL(string: url)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let dataTask = session.dataTaskWithURL(imageURL!) { (data, response, error) in
            let image = UIImage(data: data!)
            let mainQueue = NSOperationQueue.mainQueue()
            mainQueue.addOperationWithBlock() {
                self.songImage.image = image
            }
        }
        dataTask.resume()
    }
    
    //播放歌曲
    func playSong(url: String) {
        let songURL = NSURL(string: url)
        audioPlayer.player = AVPlayer(URL: songURL!)
        audioPlayer.player?.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //播放按钮控制
    @IBAction func PlayControl(sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "play") {
            sender.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            audioPlayer.player?.play()
        } else {
            sender.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
            audioPlayer.player?.pause()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("song", forIndexPath: indexPath)
        let cellData = self.songArray[indexPath.row] as! NSDictionary
        cell.textLabel?.text = cellData["title"] as? String
        cell.detailTextLabel?.text = cellData["artist"] as? String
        return cell
    }
    
    //实现协议中的方法
    func changeChannel(channel_id: String) {
        let url = NSURL(string: "https://douban.fm/j/mine/playlist?type=n&channel=\(channel_id)&from=mainsite")
        print("\(url!)")
        self.songURL = url
        self.viewDidLoad()
    }
    
    @IBAction func showChannelList(sender: UIButton) {
        performSegueWithIdentifier("showChannelList", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showChannelList" {
            let destination = segue.destinationViewController
            let ctvc = destination as! ChannelListTableViewController
            ctvc.delegate = self
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
