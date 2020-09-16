//
//  ViewController.swift
//  Veeraswamy
//
//  Created by Veeraswamy on 16/09/20.
//  Copyright © 2020 Orbcomm. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchActive : Bool = false
    var searchString : String = ""
    var album = [Album]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        showTableView()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func showTableView()  {
        if album.count != 0 {
            tableView.isHidden = false
        }
        else{
            tableView.isHidden = true
        }
    }
    
    // API Call
    
    func albumSearch()  {
        
        SVProgressHUD.show()
        let searchDealsUrl = "http://ws.audioscrobbler.com/2.0/?method=album.search&album=\(searchString)&api_key=aa66054271602a256ce141e3a4868da8&format=json"
       
        print(searchDealsUrl)
        let request = URLRequest.init(url: URL(string: searchDealsUrl)!)
        let urlsession = URLSession.shared
        let task = urlsession.dataTask(with: request, completionHandler:{ (
            data,response,error) -> Void in
            if let error = error{
                print(error)
                return
            }
            SVProgressHUD.dismiss()
            if let data = data{
                self.album = self.parseDeals(data: data as NSData)
                
                
                OperationQueue.main.addOperation({() -> Void in
                    self.showTableView()
                    self.tableView.reloadData()
                    
                })
            }
        })
        task.resume()
    }
   
    // parse JSON data
    
    func parseDeals(data: NSData) -> [Album]{
      var album = [Album]()
        
        do{
            let jsonresult = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? NSDictionary
            
            let jsondeals = jsonresult?["results"]  as AnyObject
            
            let albummatches = jsondeals["albummatches"]  as AnyObject
            
            let album1 = albummatches["album"] as! [AnyObject]
            print(album1)
            for jsondeal in album1{
                    let deal = Album()
                    deal.album_name = jsondeal["name"] as! String
                    deal.album_artst = jsondeal["artist"] as! String
                    deal.image_array = jsondeal["image"] as! [AnyObject]
                   album.append(deal)
                }
        }
        catch{
            print(error)
        }
        return album
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return album.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Acell", for: indexPath) as! AlbumCell
        
        cell.lblAlbum.text = self.album[indexPath.row].album_name
        cell.lblArtist.text = self.album[indexPath.row].album_artst
        
        
        let queue = DispatchQueue.global(qos: .default)
        queue.async { () -> Void in
            let url = NSURL(string: self.album[indexPath.row].image_array[0]["#text"] as! String)
            let data = NSData(contentsOf: url! as URL)
            
            DispatchQueue.main.async(execute: {
                if data == nil {
                    cell.albumImage.image = UIImage.init(named: "bg-loader")
                }
                else{
                    
                    cell.albumImage.image = UIImage(data: data! as Data)}
                cell.albumImage.layer.cornerRadius = cell.albumImage.frame.size.width / 2
                cell.albumImage.clipsToBounds = true
            })
        }
        return cell;
    }
    
   // MARK: - Table view Delegate
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            if let indexpath = tableView.indexPathForSelectedRow {
               let fddVc = segue.destination as! AlbumDetailView
                fddVc.album_name = album[indexpath.row].album_name
                fddVc.album_artist = album[indexpath.row].album_artst
                fddVc.image_url = album[indexpath.row].image_array[0]["#text"] as! String
                
            }
            
        }
    }
    
    // Search Bar Delegates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.view.endEditing(true)
        self.searchBar.text = ""
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchString = searchBar.text!
        print(searchString)
        self.view.endEditing(true)
        albumSearch()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// Model Class

class Album  {
    var album_name : String = ""
    var album_artst : String = ""
    var image_url : String = ""
    var image_array = [AnyObject]()
}

