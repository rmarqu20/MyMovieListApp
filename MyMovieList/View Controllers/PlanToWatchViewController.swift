//
//  PlanToWatchViewController.swift
//  MyMovieList
//
//  Created by Richard Marquez on 3/20/22.
//

import UIKit
import Firebase
import FirebaseStorage
import SwiftUI

class PlanToWatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var planToWatchTable: UITableView!
    var db = Firestore.firestore()
    static let shared = PlanToWatchViewController()
    var movieList = [Movie]()
    var testArray = ["test1", "test2", "test3"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        planToWatchTable.rowHeight = 100
        self.planToWatchTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        DispatchQueue.main.async
        {
            self.loadData()
            self.planToWatchTable.reloadData()
        }
    }
    
    func loadData()
    {
        movieList = []
        db.collection("users").document(Movies.shared.sharedUID).collection("planToWatchList").getDocuments { (snapshot, error) in
            if let error = error
            {
                print("Error retrieving documents")
            }
            if let snapshot = snapshot
            {
                snapshot.documents.map { d in
                    let title = d["title"] as? String ?? ""
                    let description = d["description"] as? String ?? ""
                    let releaseYear = d["releaseYear"] as? String ?? ""
                    let image = d["image"] as? String ?? ""
                    let imdbRating = d["imdbRating"] as? Double ?? 0.0
                    let personalRating = d["personalRating"] as? Double ?? 0.0
                    
                    let tempMovie = Movie(t: title, d: description, ry: releaseYear, i: image, ir: imdbRating, pr: personalRating)
                    print("Plan to Watch Title: " + tempMovie.title!) //temp
                    self.movieList.append(tempMovie)
                }
                self.planToWatchTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = planToWatchTable.dequeueReusableCell( withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        cell.layer.borderWidth = 0.3
        
        cell.movieTitleLabel.text = "Title: \(movieList[indexPath.row].title!)"
        cell.movieReleaseYearLabel.text = "Release Year: \(movieList[indexPath.row].releaseYear!)"
        cell.moviePersonalRatingLabel.text = "Rating: \(movieList[indexPath.row].imdbRating!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle
    {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let deletedMovie = movieList[indexPath.row].title
        db.collection("users").document(Movies.shared.sharedUID).collection("planToWatchList").document(deletedMovie!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                self.planToWatchTable.reloadData()
                self.viewDidAppear(true)
                print("Document successfully removed!")
            }
        }
        planToWatchTable.reloadData()
    }
    
    //prepare function for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "detailView")
        {
            let selectedIndex: IndexPath = self.planToWatchTable.indexPath(for: sender as! UITableViewCell)!
            if let viewController: DetailedViewController = segue.destination as? DetailedViewController
            {
                //pass selected movie data to model
                let selected = movieList[selectedIndex.row]
                viewController.selectedMovie = selected
            }
        }
    }
    
}
