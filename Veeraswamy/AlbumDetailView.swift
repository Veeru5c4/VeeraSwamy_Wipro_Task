//
//  AlbumDetailView.swift
//  Veeraswamy
//
//  Created by Veeraswamy on 16/09/20.
//  Copyright © 2020 Orbcomm. All rights reserved.
//

import UIKit

class AlbumDetailView: UIViewController {
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    var album_name : String = ""
    var album_artist : String = ""
     var image_url : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAlbum.text = album_name
        lblArtist.text = album_artist
        
        let queue = DispatchQueue.global(qos: .default)
        queue.async { () -> Void in
            let url = NSURL(string:self.image_url)
            let data = NSData(contentsOf: url! as URL)
            
            DispatchQueue.main.async(execute: {
                if data == nil {
                    self.albumImage.image = UIImage.init(named: "bg-loader")
                }
                else{
                    
                    self.albumImage.image = UIImage(data: data! as Data)}
                self.albumImage.layer.cornerRadius = self.albumImage.frame.size.width / 2
                self.albumImage.clipsToBounds = true
            })
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
