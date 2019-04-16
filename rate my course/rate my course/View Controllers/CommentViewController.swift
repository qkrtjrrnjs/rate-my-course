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
        
        pagingScrollView.delegate   = self
        textView.delegate           = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages   = slides.count
        pageControl.currentPage     = 0
        view.bringSubviewToFront(pageControl)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func submit(){
        
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
            let comment_data = ["user": username, "comment": textView.text!, "like": 0, "dislike": 0, "date": formattedDate, "id": uniqueId] as [String : Any]
            
            refs.databaseComments.child("\(global.classNumber as String)").childByAutoId().setValue(comment_data)
        }
        
            //write statistics to database if user has not already done so
        let statistics_data = ["quality": Int(self.qualitySlider.sliderTitleText)!, "difficulty": Int(self.difficultySlider.sliderTitleText)!, "usefulness": self.usefulness, "fun": self.fun] as [String : Any]
        refs.databaseStatistics.child("\(global.classNumber as String)").childByAutoId().setValue(statistics_data)
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
        labelCustomization(slide: slide1, question: question1, text: "Question 1. Rate the overall quality of the course on a scale from 0 to 5 (Swipe)", centerY: 3.5)
        
        //label2
        let question2 = UILabel(frame: CGRect.zero)
        labelCustomization(slide: slide1, question: question2, text: "Question 2. Rate the overall difficulty of the course on a scale from 0 to 5 (Swipe)", centerY: 1.6)
        
        //label3
        let question3 = UILabel(frame: CGRect.zero)
        labelCustomization(slide: slide1, question: question3, text: "Question 3. Was this course useful? (tap)", centerY: 1.05)
        
        //label4
        let question4 = UILabel(frame: CGRect.zero)
        labelCustomization(slide: slide1, question: question4, text: "Question 4. Was this course fun? (tap)", centerY: 1.25)
        
        //quality slider
        sliderCustomization(slide: slide1, slider: qualitySlider, centerY: 2.2)
        
        //difficulty slider
        sliderCustomization(slide: slide1, slider: difficultySlider, centerY: 1.28)

        //usefulness switch
        switchCustomization(slide: slide1, smileSwitch: usefulnessSwitch, centerY: 1.1)
        usefulnessSwitch.addTarget(self, action: #selector(usefulnessSwitchChanged), for: UIControl.Event.valueChanged)

        slide1.addSubview(usefulnessSwitch)
        
        //fun switch
        switchCustomization(slide: slide1, smileSwitch: funSwitch, centerY: 1.39)
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
        textView.font                   = UIFont(name: "Noway", size: 18)
        textView.text                   = "Enter your comment here!"
        textView.textColor              = UIColor.lightGray

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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text       = nil
            textView.textColor  = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text       = "Enter your comment here!"
            textView.textColor  = UIColor.lightGray
        }
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
        incrementSlider(slider: slider)
    }
    
    func snappingSliderDidDecrementValue(_ slider: SnappingSlider) {
        decrementSlider(slider: slider)
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
    
    func labelCustomization(slide: Slide, question: UILabel, text: String, centerY: Double){
        question.text = text
        question.frame.size.height     = 40
        question.frame.size.width      = 300
        question.numberOfLines         = 0
        question.center.x              = slide.center.x
        
        if text == "Question 4. Was this course fun? (tap)"{
            question.center.y = slide.center.y * CGFloat(centerY)
        }
        else{
            question.center.y = slide.center.y / CGFloat(centerY)
        }
        
        question.textColor              = UIColor(hexString: "#838383")
        question.font                   = UIFont(name: "Noway", size: 15)
        slide.addSubview(question)
    }
    
    func sliderCustomization(slide: Slide, slider: SnappingSlider, centerY: Double){
        slider.frame.size.height     = 55
        slider.frame.size.width      = 150
        slider.center.x              = slide.center.x
        slider.center.y              = slide.center.y / CGFloat(centerY)
        slider.delegate              = self
        
        slide.addSubview(slider)
    }
    
    func switchCustomization(slide: Slide, smileSwitch: TKSmileSwitch, centerY: Double){
        smileSwitch.frame.size.height      = 55
        smileSwitch.frame.size.width       = 150
        smileSwitch.center.x               = slide.center.x
        smileSwitch.center.y               = slide.center.y * CGFloat(centerY)
        smileSwitch.backgroundColor        = .clear
    }

}
