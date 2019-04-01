//
//  CommentViewController.swift
//  rate my course
//
//  Created by chris on 3/31/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pagingScrollView: UIScrollView!
    
    var classNumber = String()
    var slides:[Slide] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagingScrollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages   = slides.count
        pageControl.currentPage     = 0
        view.bringSubviewToFront(pageControl)
    }
    
    @objc func submit(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        
        //adding submit button to slide 1
        let submitButton = UIButton(frame: CGRect.zero)
        submitButton.frame.size.height  = 50
        submitButton.frame.size.width   = 150
        submitButton.center.x           = slide2.center.x
        submitButton.center.y           = slide2.center.y * 1.5
        submitButton.backgroundColor    = UIColor(hexString: "#30323d")
        submitButton.layer.cornerRadius = 10
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Bavro", size: 20)
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        slide2.addSubview(submitButton)
        
        

        return [slide1, slide2]
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        pagingScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100)
        pagingScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height - 100)
        pagingScrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height - 100)
            pagingScrollView.addSubview(slides[i])
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
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
