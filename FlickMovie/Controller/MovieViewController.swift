//
//  ViewController.swift
//  FlickMovie
//
//  Created by Hòa Nguyễn Văn on 5/21/16.
//  Copyright © 2016 SkyUnity. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import Foundation

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var movieTableView: UITableView!
  @IBOutlet weak var errorView: UIView!
    
  var movies: [NSDictionary]?
  var endpoint: String!
  let searchController = UISearchController(searchResultsController: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    movieTableView.dataSource = self
    movieTableView.delegate = self
    
    
//    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    movieTableView.tableHeaderView = searchController.searchBar

    let refreshControl = UIRefreshControl()
    loadDataFromNetwork(refreshControl)
    refreshControl.addTarget(self, action: #selector(loadDataFromNetwork(_:)), forControlEvents: UIControlEvents.ValueChanged)
    movieTableView.insertSubview(refreshControl, atIndex: 0)
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
    cell.titleLabel.text = title
    cell.overviewLabel.text = overview
    
    let baseURL = "http://image.tmdb.org/t/p/w500/"
    if let imagePath = movie["poster_path"] as? String {
      let posterUrl = NSURL(string: baseURL + imagePath)
      cell.posterView.setImageWithURL(posterUrl!)
    }

    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let cell = sender as! UITableViewCell
    let indexPath = movieTableView.indexPathForCell(cell)
    let movie = movies![indexPath!.row]
    
    let detailViewController = segue.destinationViewController as! DetailMovieViewController
    detailViewController.movie = movie
  }
  
  func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
      updates()
    }
  }
  
  func loadDataFromNetwork(refreshControl: UIRefreshControl) {
    let clientId = "a33ae33f296507677d1375d6ab54dd5f"
    let url = NSURL(string:"http://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(clientId)")
    let session = NSURLSession.sharedSession()
    
    // Display HUB right before the request is made
    let task : NSURLSessionDataTask = session.dataTaskWithURL(url!, completionHandler: { (dataOrNil, response, error) in
      guard (error == nil) else {
        print("Error")
        self.performUIUpdatesOnMain {
          self.errorView.hidden = false
          refreshControl.endRefreshing()
        }
        return
      }
      
      if error == nil {
        if let data = dataOrNil {
          if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as?NSDictionary {
            self.performUIUpdatesOnMain {
              self.errorView.hidden = true
              self.movies = responseDictionary["results"] as? [NSDictionary]
              self.movieTableView.reloadData()
              refreshControl.endRefreshing()
            }
          }
        }
      }
    });
    NSURLCache.sharedURLCache().removeCachedResponseForDataTask(task)
    task.resume()
  }

}

