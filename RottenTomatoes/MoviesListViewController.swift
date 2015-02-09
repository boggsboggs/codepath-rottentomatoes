//
//  MoviesListViewController.swift
//  RottenTomatoes
//
//  Created by Nidhi Kulkarni on 2/7/15.
//  Copyright (c) 2015 John Boggs. All rights reserved.
//

import UIKit


class MoviesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    UISearchBarDelegate {
    @IBOutlet weak var moviesTableView: UITableView!

    var refreshControl: UIRefreshControl?
    var errorLabel: UILabel?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var moviesData: NSDictionary?
    let apiKey = "nu2th2vcht82a8t38pgeev2u"
    let rottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey="
    
    override func viewDidLoad() {
        SVProgressHUD.show()
        self.asyncFetchMovies({() in
            SVProgressHUD.dismiss()
        })
        self.moviesTableView.registerNib(
            UINib(nibName: "MovieTableViewCell", bundle: NSBundle.mainBundle()),
            forCellReuseIdentifier: "MovieTableViewCell")
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "onRefresh", forControlEvents: .ValueChanged)
        self.moviesTableView.insertSubview(self.refreshControl!, atIndex: 0)
        
        self.moviesTableView.backgroundColor = UIColor.blackColor();
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let moviesData = self.moviesData {
            return (self.moviesData?.valueForKey("movies")! as NSArray).count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.moviesTableView.dequeueReusableCellWithIdentifier("MovieTableViewCell")! as MovieTableViewCell
        cell.movie = (self.moviesData!.valueForKey("movies") as NSArray)[indexPath.row] as Dictionary
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        println("Begin")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let search = searchBar.text
        self.asyncFetchMovies(nil, search: search)    }
    
    func onRefresh() {
        self.removeError()
        self.asyncFetchMovies({ () in
            self.refreshControl!.endRefreshing()
        })
    }
    
    func asyncFetchMovies(callback: (() -> ())?, search: String? = nil) {
        var url = ""
        if let search = search {
            url = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=\(search)&page_limit=20&page=1&apikey=\(apiKey)"
        } else {
            url = rottenTomatoesURLString + apiKey
        }
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(url))
        println("making request")
        self.removeError()
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
            completionHandler:{ (response, data, error) in
                if let error = error {
                    self.handleError(error)
                } else {
                    var errorValue: NSError? = nil
                    let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                    self.moviesData = dictionary
                    self.moviesTableView.reloadData()
                    println("done making request")
                }
                if let callback = callback {
                    callback()
                }
        })
    }
    
    func handleError(error: NSError) {
        let navigationHeight = self.navigationController!.navigationBar.frame.height
        self.errorLabel = UILabel(frame: CGRectMake(0, navigationHeight, self.view.frame.width, 80))
        self.errorLabel!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.errorLabel!)
        self.errorLabel!.text = "Network Error"
        self.errorLabel!.textAlignment = NSTextAlignment.Center
        self.errorLabel!.textColor = UIColor.blackColor()
    }
    
    func removeError() {
        if let errorLabel = self.errorLabel {
            errorLabel.removeFromSuperview()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as MovieTableViewCell
        let indexPath = self.moviesTableView.indexPathForCell(cell)
        let movie = cell.movie
        (segue.destinationViewController as MovieDetailViewController).movie = movie
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.moviesTableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.performSegueWithIdentifier("showDetail", sender: self.moviesTableView.cellForRowAtIndexPath(indexPath));
        
    }
}
