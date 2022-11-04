//
//  DetailedViewController.swift
//  MyMovieList
//
//  Created by Richard Marquez on 3/20/22.
//

import UIKit

class DetailedViewController: UIViewController
{
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var selectedMovie:Movie?
    var movieStr = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        movieTitleLabel.text = selectedMovie?.title
        yearLabel.text = selectedMovie?.releaseYear
        imdbRatingLabel.text = "\(selectedMovie?.imdbRating! ?? 0)"
        descriptionTextView.text = selectedMovie?.description
        var stringUrl = ""
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
}
