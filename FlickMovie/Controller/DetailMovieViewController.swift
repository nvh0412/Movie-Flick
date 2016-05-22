//
//  DetailMovieViewController.swift
//  FlickMovie
//
//  Created by Hòa Nguyễn Văn on 5/21/16.
//  Copyright © 2016 SkyUnity. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController {

  @IBOutlet weak var posterMovie: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var inforView: UIView!

  var movie: NSDictionary?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: inforView.frame.origin.y + inforView.frame.size.height)
    print("ScrollView: \(scrollView.frame.size.width), height: \(inforView.frame.origin.y + inforView.frame.size.height)")
    if let movie = movie {
      let baseURL = "http://image.tmdb.org/t/p/w500/"
      if let imagePath = movie["poster_path"] as? String {
        let posterUrl = NSURL(string: baseURL + imagePath)
        posterMovie.setImageWithURL(posterUrl!)
      }
      
      let title = movie["title"] as! String
      titleLabel.text = title
    
      let overview = movie["overview"] as! String
      overviewLabel.text = overview
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}
