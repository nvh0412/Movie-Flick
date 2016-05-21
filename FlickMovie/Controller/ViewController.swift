//
//  ViewController.swift
//  FlickMovie
//
//  Created by Hòa Nguyễn Văn on 5/21/16.
//  Copyright © 2016 SkyUnity. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var movieTableView: UITableView!
    
  var movies: [NSDictionary]?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    movieTableView.dataSource = self
    movieTableView.delegate = self
    
    let clientId = "a33ae33f296507677d1375d6ab54dd5f"
    let url = NSURL(string:"http://api.themoviedb.org/3/movie/now_playing?api_key=\(clientId)")
    let request = NSURLRequest(URL: url!)
    let session = NSURLSession(
      configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
      delegate:nil,
      delegateQueue:NSOperationQueue.mainQueue()
    )

    let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
      if let data = dataOrNil {
        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as?NSDictionary {
          self.movies = responseDictionary["results"] as! [NSDictionary]
          self.movieTableView.reloadData()
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
    if let movies = movies {
      return movies.count
    } else {
      return 0
    }
  }
    
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
    
    let movie = movies![indexPath.row]
    let title = movie["title"] as? String
    let overview = movie["overview"] as? String
    
    let baseURL = "http://image.tmdb.org/t/p/w500/"
    let imagePath = movie["poster_path"] as! String
    
    let posterUrl = NSURL(string: baseURL + imagePath)
    
    cell.titleLabel.text = title
    cell.overviewLabel.text = overview;
    cell.posterView.setImageWithURL(posterUrl!)
    
    return cell
  }

}

