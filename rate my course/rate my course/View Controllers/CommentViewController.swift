//
//  CommentViewController.swift
//  rate my course
//
//  Created by chris on 3/31/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pagingScrollView: UIScrollView!
    
    var classNumber = String()
    var slides:[Slide] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagingScrollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        print(classNumber)
    }
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.testImage.backgroundColor = .red
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.testImage.backgroundColor = .orange

        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.testImage.backgroundColor = .yellow

        
        return [slide1, slide2, slide3]
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        pagingScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        pagingScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        pagingScrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            pagingScrollView.addSubview(slides[i])
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
