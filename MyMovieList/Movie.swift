//
//  Movie.swift
//  MyMovieList
//
//  Created by Richard Marquez on 4/19/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class Movies
{   
    static let shared = Movies()
    var db = Firestore.firestore()
    var sharedUID = ""
    var sharedUsername = ""
    var watchedList = [Movie]()
    var planToWatchList = [Movie]()
    
    init()
    {
        
    }
    
    func getWatchedMovies()
    {
        watchedList = []
        db.collection("users").document(Movies.shared.sharedUID).collection("watchedList").getDocuments { (snapshot, error) in
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
                    print("Watched Title: " + tempMovie.title!) //temp
                    self.watchedList.append(tempMovie)
                }
            }
        }
    }
    
    func getPlanToWatchMovies()
    {
        watchedList = []
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
                    print("PlanToWatch Title: " + tempMovie.title!) //temp
                    self.planToWatchList.append(tempMovie)
                }
            }
        }
    }
    
}

class Movie
{
    var title:String?
    var description:String?
    var releaseYear:String?
    var genres:Array<String>?
    var rating:String?
    var length:String?
    var director:String?
    var image:String?
    var imdbRating:Double?
    var personalRating:Double?
    
    init(t:String, d:String, ry:String, i:String, ir:Double, pr:Double)
    {
        self.title = t
        self.description = d
        self.releaseYear = ry
        self.image = i
        self.imdbRating = ir
        self.personalRating = pr
    }
}
