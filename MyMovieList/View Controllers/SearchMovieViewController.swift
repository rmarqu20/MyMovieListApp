//
//  SearchMovieViewController.swift
//  MyMovieList
//
//  Created by Richard Marquez on 3/20/22.
//

import UIKit

class SearchMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchTable: UITableView!
    
    var testArray = ["search1", "search2", "search3"]
    var searchList = [Movie]()
    var releaseYear = ""
    var image = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchTable.rowHeight = 100
        self.searchTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        DispatchQueue.main.async
        {
            self.searchTable.reloadData()
        }
    }
    
    @IBAction func searchMovie(_ sender: Any)
    {
        searchList = []
        var searchTitle = searchField.text
        if searchTitle == ""
        {
            //empty field
            self.searchTable.reloadData()
            print("Empty Search TextField!")
        }
        else
        {
            //api search
            searchTitle = searchTitle?.replacingOccurrences(of: " ", with: "%20")
            let urlAsString = "https://api.themoviedb.org/3/search/movie?api_key=2566850440041792b71a9204967a6038&language=en-US&query=" + searchTitle! + "&page=1"
            print("URL: " + urlAsString)
            let url = URL(string: urlAsString)!
            let urlSession = URLSession.shared
            
            let jsonQuery = urlSession.dataTask(with: url, completionHandler: { [self] data, response, error -> Void in
                if(error != nil)
                {
                    print(error!.localizedDescription)
                }
                var err: NSError?
                
                var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                if(err != nil)
                {
                    print("JSON Error \(err!.localizedDescription)")
                }
                print(jsonResult)
                
                let setOne:NSArray = jsonResult["results"] as! NSArray
                for i in setOne
                {
                    let y = i as? [String: AnyObject]
                    let title: String = (y!["title"] as? String)! as String
                    let description: String = (y!["overview"] as? String)! as String
                    if let releaseYear: String = (y!["release_date"] as? String)
                    {
                        self.releaseYear = releaseYear
                    }
                    else
                    {
                        self.releaseYear = ""
                    }
                    let imdbRating: Double = (y!["vote_average"] as? Double)! as Double
                    
                    if let image: String = (y!["poster_path"]! as? String)
                    {
                        self.image = image
                    }
                    else
                    {
                        self.image = "https://image.tmdb.org/t/p/original/wuMc08IPKEatf9rnMNXvIDxqP4W.jpg"
                    }
                    
                    let personalRating = 0.0
                    print("Title: " + title)
                    print("Description: " + description)
                    print("Release Date: " + self.releaseYear)
                    print("IMDb Rating: \(imdbRating)")
                    print("Image: " + self.image)
  
                    let tempMovie = Movie(t: title, d: description, ry: self.releaseYear, i: self.image, ir: imdbRating, pr: personalRating)
                    self.searchList.append(tempMovie)
                    self.searchTable.reloadData()
                    self.viewDidAppear(true)
                }
            })
            self.searchTable.reloadData()
            self.viewDidAppear(true)
            jsonQuery.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = searchTable.dequeueReusableCell( withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        cell.layer.borderWidth = 0.3
        
        cell.movieTitleLabel.text = "Title: \(searchList[indexPath.row].title ?? "NA")"
        cell.movieReleaseYearLabel.text = "Release Year: \(searchList[indexPath.row].releaseYear ?? "NA")"
        cell.moviePersonalRatingLabel.text = "Rating: \(searchList[indexPath.row].imdbRating ?? 0.0)"
        return cell
    }
    
    //prepare function for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "detailAddView")
        {
            let selectedIndex: IndexPath = self.searchTable.indexPath(for: sender as! UITableViewCell)!
            if let viewController: DetailedAddViewController = segue.destination as? DetailedAddViewController
            {
                //pass selected city data to model
                let selected = searchList[selectedIndex.row]
                viewController.selectedMovie = selected
            }
        }
    }
}
