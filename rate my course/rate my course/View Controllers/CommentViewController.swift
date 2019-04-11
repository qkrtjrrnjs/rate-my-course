//
//  CommentViewController.swift
//  rate my course
//
//  Created by chris on 3/31/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import TKSwitcherCollection

class CommentViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate, SnappingSliderDelegate{
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pagingScrollView: UIScrollView!

    var slides:[Slide] = []
    
    let textView            = UITextView(frame: CGRect.zero)
    let qualitySlider       = SnappingSlider(frame: CGRect.zero, title: "3")
    let difficultySlider    = SnappingSlider(frame: CGRect.zero, title: "3")
    let usefulnessSwitch    = TKSmileSwitch(frame: CGRect.zero)
    let funSwitch           = TKSmileSwitch(frame: CGRect.zero)

    var usefulness          = "yes"
    var fun                 = "yes"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        pagingScrollView.delegate = self
        textView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages   = slides.count
        pageControl.currentPage     = 0
        view.bringSubviewToFront(pageControl)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func submit(){
        //self.navigationController?.popViewController(animated: true)
        
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailViewController")
        var viewcontrollers = self.navigationController!.viewControllers
        viewcontrollers.removeLast()
        viewcontrollers.removeLast()
        viewcontrollers.append(vc)
        self.navigationController?.setViewControllers(viewcontrollers, animated: true)
        
        //extracting username from email address
        var username = Auth.auth().currentUser!.email! as String
        if let atRange = username.range(of: "@") {
            username.removeSubrange(atRange.lowerBound..<username.endIndex)
        }
        
        //get post date
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "M/d/yyyy"
        let formattedDate = format.string(from: date)
        
        let uniqueId = UUID().uuidString
        
        if !textView.text.isEmpty{
            //writing data to database
            let comment_data = ["user": username, "comment": textView.text, "like": 0, "dislike": 0, "date": formattedDate, "id": uniqueId] as [String : Any]
            
            refs.databaseComments.child("\(global.classNumber as String)").childByAutoId().setValue(comment_data)
        }
        
        let tempUsername    = Auth.auth().currentUser!.email! as String
        let newUsername     = tempUsername.replacingOccurrences(of: ".", with: "")
        
        refs.databaseUsers.child("\(newUsername)").child("submitted").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if !snapshot.hasChild("\(global.classNumber as String)") {
                //write statistics to database
                let statistics_data = ["quality": Int(self.qualitySlider.sliderTitleText)!, "difficulty": Int(self.difficultySlider.sliderTitleText)!, "usefulness": self.usefulness, "fun": self.fun] as [String : Any]
                refs.databaseStatistics.child("\(global.classNumber as String)").childByAutoId().setValue(statistics_data)
            }
        })
        
        
    }
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        
        slide1.backgroundColor = UIColor(hexString: "#d5d5d5")
        slide2.backgroundColor = UIColor(hexString: "#d5d5d5")
        
        //add backdrop view
        let slide1View = UIView(frame: CGRect.zero)
        slide1View.backgroundColor        = .white
        slide1View.frame.size.height      = slide2.frame.size.height / 1.5
        slide1View.frame.size.width       = slide2.frame.size.width / 1.1
        slide1View.center.x               = slide2.center.x
        slide1View.center.y               = slide2.center.y / 1.2
        slide1View.layer.cornerRadius     = 10
        slide1.addSubview(slide1View)
        
        //label1
        let question1 = UILabel(frame: CGRect.zero)
        question1.text = "Question 1. Rate the overall quality of the course on a scale from 0 to 5 (Swipe)"
        question1.frame.size.height     = 40
        question1.frame.size.width      = 300
        question1.numberOfLines         = 0
        question1.center.x              = slide1.center.x
        question1.center.y              = slide1.center.y / 3.5
        question1.textColor             = UIColor(hexString: "#838383")
        question1.font = UIFont(name: "Noway", size: 15)
        
        slide1.addSubview(question1)
        
        //label2
        let question2 = UILabel(frame: CGRect.zero)
        question2.text = "Question 2. Rate the overall difficulty of the course on a scale from 0 to 5 (Swipe)"
        question2.frame.size.height     = 40
        question2.frame.size.width      = 300
        question2.numberOfLines         = 0
        question2.center.x              = slide1.center.x
        question2.center.y              = slide1.center.y / 1.6
        question2.textColor             = UIColor(hexString: "#838383")
        question2.font = UIFont(name: "Noway", size: 15)
        
        slide1.addSubview(question2)
        
        //label3
        let question3 = UILabel(frame: CGRect.zero)
        question3.text = "Question 3. Was this course useful? (tap)"
        question3.frame.size.height     = 40
        question3.frame.size.width      = 300
        question3.numberOfLines         = 0
        question3.center.x              = slide1.center.x
        question3.center.y              = slide1.center.y / 1.05
        question3.textColor             = UIColor(hexString: "#838383")
        question3.font = UIFont(name: "Noway", size: 15)
        
        slide1.addSubview(question3)

        //label4
        let question4 = UILabel(frame: CGRect.zero)
        question4.text = "Question 4. Was this course fun? (tap)"
        question4.frame.size.height     = 40
        question4.frame.size.width      = 300
        question4.numberOfLines         = 0
        question4.center.x              = slide1.center.x
        question4.center.y              = slide1.center.y * 1.25
        question4.textColor             = UIColor(hexString: "#838383")
        question4.font = UIFont(name: "Noway", size: 15)
        
        slide1.addSubview(question4)
        
        //quality slider
        qualitySlider.frame.size.height     = 55
        qualitySlider.frame.size.width      = 150
        qualitySlider.center.x              = slide1.center.x
        qualitySlider.center.y              = slide1.center.y / 2.2
        qualitySlider.delegate              = self
        qualitySlider.tag                   = 0
        
        slide1.addSubview(qualitySlider)
        
        //difficulty slider
        difficultySlider.frame.size.height      = 55
        difficultySlider.frame.size.width       = 150
        difficultySlider.center.x               = slide1.center.x
        difficultySlider.center.y               = slide1.center.y / 1.28
        difficultySlider.delegate               = self
        qualitySlider.tag                       = 1
        
        slide1.addSubview(difficultySlider)
        
        //usefulness switch
        usefulnessSwitch.frame.size.height      = 55
        usefulnessSwitch.frame.size.width       = 150
        usefulnessSwitch.center.x               = slide1.center.x
        usefulnessSwitch.center.y               = slide1.center.y * 1.1
        usefulnessSwitch.backgroundColor        = .clear
        usefulnessSwitch.addTarget(self, action: #selector(usefulnessSwitchChanged), for: UIControl.Event.valueChanged)

        slide1.addSubview(usefulnessSwitch)
        
        //fun switch
        funSwitch.frame.size.height      = 55
        funSwitch.frame.size.width       = 150
        funSwitch.center.x               = slide1.center.x
        funSwitch.center.y               = slide1.center.y * 1.39
        funSwitch.backgroundColor        = .clear
        funSwitch.addTarget(self, action: #selector(funSwitchChanged), for: UIControl.Event.valueChanged)

        slide1.addSubview(funSwitch)
        
        //adding submit button to slide 2
        let submitButton = UIButton(frame: CGRect.zero)
        submitButton.frame.size.height  = 50
        submitButton.frame.size.width   = 150
        submitButton.center.x           = slide2.center.x
        submitButton.center.y           = slide2.center.y * 1.65
        submitButton.backgroundColor    = UIColor(hexString: "#30323d")
        submitButton.layer.cornerRadius = 10
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Bavro", size: 20)
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        slide2.addSubview(submitButton)
        
        //add textview to slide 2
        textView.frame.size.height      = slide2.frame.size.height / 1.5
        textView.frame.size.width       = slide2.frame.size.width / 1.1
        textView.center.x               = slide2.center.x
        textView.center.y               = slide2.center.y / 1.2
        textView.textContainerInset     = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.layer.cornerRadius     = 10
        textView.textAlignment          = NSTextAlignment.justified
        textView.textColor              = .black
        textView.backgroundColor        = .white
        textView.isScrollEnabled        = true
        textView.font = UIFont(name: "Noway", size: 18)
        slide2.addSubview(textView)
        return [slide1, slide2]
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        pagingScrollView.frame = CGRect(x: view.center.x, y: view.center.y, width: view.frame.width, height: view.frame.height - 100)
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
    
    //dismiss keyboard upon return
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func incrementSlider(slider: SnappingSlider){
        if slider.sliderTitleText != "5"{
            slider.sliderTitleText = "\(Int(slider.sliderTitleText)! + 1)"
        }
    }
    
    func decrementSlider(slider: SnappingSlider){
        if slider.sliderTitleText != "0"{
            slider.sliderTitleText = "\(Int(slider.sliderTitleText)! - 1)"
        }
    }
    
    func snappingSliderDidIncrementValue(_ slider: SnappingSlider) {
        if slider.tag == 0{
            incrementSlider(slider: slider)
        }else{
            incrementSlider(slider: slider)
        }
    }
    
    func snappingSliderDidDecrementValue(_ slider: SnappingSlider) {
        if slider.tag == 0{
            decrementSlider(slider: slider)
        }else{
            decrementSlider(slider: slider)
        }
    }
    
    @objc func usefulnessSwitchChanged(){
        if usefulness == "yes"{
            usefulness = "no"
        }else{
            usefulness = "yes"
        }
    }

    @objc func funSwitchChanged(){
        if fun == "yes"{
            fun = "no"
        }else{
            fun = "yes"
        }
    }
    
    

}
