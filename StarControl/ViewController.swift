//
//  ViewController.swift
//  StarControl
//
//  Created by Andrew Dhan on 8/28/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func updateRating(_ ratingControl: CustomControl) {
        let stars = ratingControl.value
        if stars > 1 {
            self.title = "User Rating: \(stars) stars"
        } else {
            self.title = "User Rating: \(stars) star"
        }
    }


}

