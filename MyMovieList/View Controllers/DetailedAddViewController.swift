//
//  DetailedAddViewController.swift
//  MyMovieList
//
//  Created by Richard Marquez on 4/22/22.
//

import UIKit
import Firebase
import FirebaseFirestore

class DetailedAddViewController: UIViewController
{
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var db = Firestore.firestore()
    var selectedMovie:Movie?
    var movieStr = ""
    var stringUrl = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Selected Title: " + (selectedMovie?.title)!)
        print("Selected Year: " + (selectedMovie?.releaseYear)!)
        print("Selected Rating: \(selectedMovie?.imdbRating! ?? 0.0)")
        print("Selected Description: " + (selectedMovie?.description)!)
        print("Selected Image: " + (selectedMovie?.image)!)
        movieTitleLabel.text = selectedMovie?.title
        yearLabel.text = selectedMovie?.releaseYear
        imdbRatingLabel.text = "IMDb Rating: \(selectedMovie?.imdbRating! ?? 0)"
        descriptionTextView.text = selectedMovie?.description
        
        if let movieStr = selectedMovie?.image
        {
            self.movieStr = movieStr
        }
        else
        {
            self.movieStr = ""
        }
        if(movieStr != "")
        {
            stringUrl = "https://image.tmdb.org/t/p/original" + movieStr
        }
        else
        {
            //Harry Potter poster image as default :)
            stringUrl = "https://image.tmdb.org/t/p/original/wuMc08IPKEatf9rnMNXvIDxqP4W.jpg"
        }
        let url = URL(string: stringUrl)!
        let data = try? Data(contentsOf: url)
        movieImage.image = UIImage(data: data!)
    }

    @IBAction func addToWatched(_ sender: Any)
    {
        PlanToWatchViewController.shared.movieList.append(selectedMovie!)
        db.collection("users").document(Movies.shared.sharedUID).collection("watchedList").document(selectedMovie?.title! ?? "NoName").setData([
            "title" : selectedMovie?.title! ?? "",
            "description" : selectedMovie?.description! ?? "",
            "releaseYear" : selectedMovie?.releaseYear! ?? "",
            "image" : stringUrl,
            "imdbRating" : selectedMovie?.imdbRating! ?? 0,
            "personalRating" : 0
        ])
    }
    
    @IBAction func addToPlanToWatch(_ sender: Any)
    {
        WatchedViewController.shared.movieList.append(selectedMovie!)
        db.collection("users").document(Movies.shared.sharedUID).collection("planToWatchList").document(selectedMovie?.title! ?? "NoName").setData([
            "title" : selectedMovie?.title! ?? "",
            "description" : selectedMovie?.description! ?? "",
            "releaseYear" : selectedMovie?.releaseYear! ?? "",
            "image" : stringUrl,
            "imdbRating" : selectedMovie?.imdbRating! ?? 0,
            "personalRating" : 0
        ])
    }
    
}
