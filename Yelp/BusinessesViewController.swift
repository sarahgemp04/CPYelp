//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]!
   
    @IBOutlet weak var searchButton: UIButton!
    
    var searchController: UISearchController!
    var searchText = "Thai"
    var initialTitleView: UIView?
    var isDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
  
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialTitleView = self.navItem.titleView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        Business.searchWithTerm(term: "Thai", offset: nil, limit: nil, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses!
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        //Search Bar style and setup.
        searchButton.layer.cornerRadius = 5
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for Businesses"
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    @IBAction func searchClicked(_ sender: AnyObject) {
        navItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        if (searchBar.text != nil) {
            searchText = searchBar.text!
        }
        
        print(searchText)
        
        Business.searchWithTerm(term: self.searchText, offset: nil, limit: nil, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses!
            self.tableView.reloadData()
            for business in businesses! {
                print(business.name!)
                print(business.address!)
            }
        })
        
        navItem.titleView = initialTitleView

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        navItem.titleView = initialTitleView
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //Do nothing since update in searchBarButtonClicked function.
    }
  
   
    //Infinite Scroll Methods.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!isDataLoading) {

            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator before loading.
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                loadMore()
            }
        }
    }
    
    //Load more data function:
    func loadMore() {
        
        Business.searchWithTerm(term: self.searchText, offset: (self.businesses.count), limit: nil) { (businesses2: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses2!
            self.businesses.append(contentsOf: businesses2!)
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            self.isDataLoading = false
            
            self.tableView.reloadData()
            
            for business in self.businesses {
                print(business.name!)
                print(business.address!)
            }
            print(self.businesses.count)
        }

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
        
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        tableCell.business = businesses[indexPath.row]
        
        return tableCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toDetails"
        {
            let cell = sender as! BusinessCell
            let dest = segue.destination as! DetailsViewController
            dest.business = cell.business
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
