//
//  ViewController.swift
//  FlickMovie
//
//  Created by Hòa Nguyễn Văn on 5/21/16.
//  Copyright © 2016 SkyUnity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        movieTableView.dataSource = self
        movieTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath)
        cell.textLabel!.text = "Row \(indexPath.row)"
        print("Row \(indexPath.row)")
        return cell
    }

}

