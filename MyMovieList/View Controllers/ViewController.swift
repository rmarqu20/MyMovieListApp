//
//  ViewController.swift
//  MyMovieList
//
//  Created by Richard Marquez on 3/20/22.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var watchedCountLabel: UILabel!
    @IBOutlet weak var plannedToWatchCountLabel: UILabel!
    var db = Firestore.firestore()
    var storage = FirebaseStorage.Storage.storage()
    var image2 = UIImage()
    var profilePic = UIImage()
    var photoPicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.getUsername()
        self.getWatchedCount()
        self.getPlanToWatchCount()
        self.downloadProfilePicture()
    }
    
    func getUsername()
    {
        var usernameStr = ""
        let docRef = db.collection("users").document(Movies.shared.sharedUID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription:String = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                if let range = dataDescription.range(of: "username\":")
                {
                    let range2 = dataDescription.range(of: "]")
                    usernameStr = dataDescription[range.upperBound...range2!.lowerBound].trimmingCharacters(in: .whitespaces)
                    usernameStr = String(usernameStr.dropLast())
                    if usernameStr.count > 30
                    {
                        let range2 = dataDescription.range(of: ",")
                        usernameStr = dataDescription[range.upperBound...range2!.lowerBound].trimmingCharacters(in: .whitespaces)
                        usernameStr = String(usernameStr.dropLast())
                    }
                }
                print("Username:" + usernameStr)
                self.navTitle.title = "Welcome \(usernameStr)!"
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getWatchedCount()
    {
        var watchedCount = 0
        db.collection("users").document(Movies.shared.sharedUID).collection("watchedList").getDocuments { (snapshot, error) in
            if let error = error
            {
                print("Error retrieving documents")
            }
            if let snapshot = snapshot
            {
                snapshot.documents.map { d in
                    watchedCount += 1
                }
                self.watchedCountLabel.text = "\(watchedCount)"
            }
        }
    }
    
    func getPlanToWatchCount()
    {
        var planToWatchCount = 0
        db.collection("users").document(Movies.shared.sharedUID).collection("planToWatchList").getDocuments { (snapshot, error) in
            if let error = error
            {
                print("Error retrieving documents")
            }
            if let snapshot = snapshot
            {
                snapshot.documents.map { d in
                    planToWatchCount += 1
                }
                self.plannedToWatchCountLabel.text = "\(planToWatchCount)"
            }
        }
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            photoPicker.sourceType = UIImagePickerController.SourceType.camera
            photoPicker.allowsEditing = true
            self.present(photoPicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        photoPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        photoPicker.allowsEditing = true
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    @IBAction func loadImage(_ sender: Any)
    {
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
            
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image3 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            picker.dismiss(animated: true, completion: {
                self.profileImage.image = image3
                self.image2 = image3
                self.addImageToStorage()
            })
            print(image2)
        }
    }
    
    func downloadProfilePicture()
    {
        let imagesRef = Storage.storage().reference(withPath: "images/\(Movies.shared.sharedUID)")
        imagesRef.getData(maxSize: 1 * 5024 * 1024) { data, error in
          if let error = error {
              print("PROFILE PIC ERROR: \(error.localizedDescription)")
          } else {
            let image = UIImage(data: data!)
              print("Successful download")
              self.profilePic = image!
              self.profileImage.image = self.profilePic
          }
        }
    }
    
    func addImageToStorage()
    {
        let data = image2.jpegData(compressionQuality: 0.75)
        print(data)
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("images/\(Movies.shared.sharedUID)")
        let upload = imagesRef.putData(data!, metadata: nil) { (metadata, error) in
          if let error = error {
              print("ERROR1: " + error.localizedDescription)
            return
          }
          storageRef.downloadURL(completion: { (url, error) in
            if let error = error
              {
                print("ERROR2: " + error.localizedDescription)
                return }
              print("URL: \(url)")
          })
        }
    }
    
    @IBAction func WatchListButton(_ sender: Any)
    {
        
    }
    @IBAction func PlanToWatchListButton(_ sender: Any)
    {
        
    }
    @IBAction func TheatreLocatorButton(_ sender: Any)
    {
        
    }

}
