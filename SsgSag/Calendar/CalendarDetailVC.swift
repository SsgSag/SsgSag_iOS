//
//  CalendarDetailVC.swift
//  SsgSag
//
//  Created by admin on 04/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class CalendarDetailVC: UIViewController {

    @IBOutlet var PosterImage: UIImageView!
    var Poster:Posters?
    
    @IBOutlet var outLine: UILabel!
    @IBOutlet var target: UILabel!
    @IBOutlet var benefit: UILabel!
    @IBOutlet var apply: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let photoURL = Poster?.photoUrl {
            if let url = URL(string: photoURL){
                PosterImage.load(url: url)
            }
        }
        
        if let poster = Poster {
            outLine.text = poster.outline
            target.text = poster.target
            benefit.text = poster.benefit
            apply.text = poster.posterWebSite
        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC: ZoomPosterImageVC = segue.destination as? ZoomPosterImageVC else {return}
        nextVC.poster = PosterImage.image ?? #imageLiteral(resourceName: "1")
    }
    
}
