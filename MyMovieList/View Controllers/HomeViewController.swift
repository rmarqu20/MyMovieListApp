//
//  HomeViewController.swift
//  MyMovieList
//
//  Created by Richard Marquez on 4/19/22.
//

import UIKit

class HomeViewController: UIViewController
{
    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        welcomeLabel.sizeToFit()
    }

}
