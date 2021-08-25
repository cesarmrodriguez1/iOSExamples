//
//  DetailViewController.swift
//  BookGallery
//
//  Created by César on 19/08/21.
//

import UIKit

class DetailViewController: UIViewController{
    
    @IBOutlet weak var detailImage: UIImageView!
    
    
    @IBOutlet weak var labelName: UILabel!
    
    var detailName:String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Process:
        labelName.text = detailName
        detailImage.image = UIImage(named: detailName!)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
