//
//  ViewController.swift
//  Projet4
//
//  Created by Moltes Touvabien on 15/05/2022.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var viewChoosed: UIImageView!
    var buttonPushed: UIButton!
    @IBOutlet weak var principalView: UIView!
    
    //---------- The 4 square views with their buttons and imageview ----------
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var view1Button: UIButton!
    @IBOutlet weak var view2Button: UIButton!
    @IBOutlet weak var view3Button: UIButton!
    @IBOutlet weak var view4Button: UIButton!
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    //---------- The 2 rectangle views with their buttons and imageview ----------
    
    @IBOutlet weak var rectangleView1: UIView!
    @IBOutlet weak var rectangleView2: UIView!
    
    @IBOutlet weak var rectangleView1Button: UIButton!
    @IBOutlet weak var rectangleView2Button: UIButton!
    
    @IBOutlet weak var rectangleImageView1: UIImageView!
    @IBOutlet weak var rectangleImageView2: UIImageView!
    
    //---------- The 3 checked image ----------
    
    @IBOutlet weak var firstSelectedImage: UIImageView!
    @IBOutlet weak var secondSelectedImage: UIImageView!
    @IBOutlet weak var thirdSelectedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondAppearence()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    //---------- Replacing the instagrid portrait view in his superview after rotation ----------
    
    @IBOutlet weak var stackViewMI: UIStackView!
    @IBOutlet weak var instagridPortrait: UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let index = stackViewMI.subviews.firstIndex(of: instagridPortrait) {
            stackViewMI.insertArrangedSubview(instagridPortrait, at: index)
        }
    }
    
    //---------- The method that choose picture and pick it in corresponding place depending on the button ----------
    
    var imagePicker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any]) {
            if let picture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                viewChoosed.image = picture
                if viewChoosed.image != nil{
                    buttonPushed.setTitle("", for: .normal)
                }
            }
            dismiss(animated: true, completion: nil)
        }
    
    func takePicture(source: UIImagePickerController.SourceType){
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
    }
    
    private func addPicture(imageview: UIImageView, viewbutton: UIButton){
        viewChoosed = imageview
        buttonPushed = viewbutton
        takePicture(source: .photoLibrary)
    }
    
    @IBAction func view1Button(_ sender: UIButton) {
        addPicture(imageview: imageView1, viewbutton: view1Button)
    }
    @IBAction func view2Button(_ sender: UIButton) {
        addPicture(imageview: imageView2, viewbutton: view2Button)
    }
    @IBAction func view3Button(_ sender: UIButton) {
        addPicture(imageview: imageView3, viewbutton: view3Button)
    }
    @IBAction func view4Button(_ sender: UIButton) {
        addPicture(imageview: imageView4, viewbutton: view4Button)
    }
    

    
    @IBAction func rectangleView1Button(_ sender: UIButton) {
        addPicture(imageview: rectangleImageView1, viewbutton: rectangleView1Button)
    }
    @IBAction func rectangleView2Button(_ sender: UIButton) {
        addPicture(imageview: rectangleImageView2, viewbutton: rectangleView2Button)
    }
    
    //---------- methods that make the corresponding appearance depending which bouton is selected ----------
    
    private func makeHidden(views: [UIView]){
        for view in views{
            view.isHidden = true
        }
    }
    
    private func makeVisible(views: [UIView]){
        for view in views{
            view.isHidden = false
        }
    }
    
    private func firstAppearence() {
        makeHidden(views: [view1, view2, rectangleView2, secondSelectedImage, thirdSelectedImage])
        makeVisible(views: [view3, view4, rectangleView1, firstSelectedImage])
    }
    @IBAction func layout1Button(_ sender: UIButton) {
        firstAppearence()
    }

    private func secondAppearence() {
        makeHidden(views: [view3, view4, rectangleView1, firstSelectedImage, thirdSelectedImage])
        makeVisible(views: [view1, view2, rectangleView2, secondSelectedImage])

    }
    @IBAction func layout2Button(_ sender: UIButton) {
        secondAppearence()
    }

    private func thirdAppearence() {
        makeHidden(views: [rectangleView1, rectangleView2, firstSelectedImage, secondSelectedImage])
        makeVisible(views: [view1, view2, view3, view4, thirdSelectedImage])
    }

    @IBAction func layout3Button(_ sender: UIButton) {
        thirdAppearence()
    }
    
    //---------- part about swipe ----------
    
    @objc func swipeUp(_ gestureRecognizer : UISwipeGestureRecognizer) {
        guard UIDevice.current.orientation == .portrait else { return }
        guard gestureRecognizer.state == .ended else { return }
        
        swipeHandler()
    }
    
    @objc func swipeLeft(_ gestureRecognizer : UISwipeGestureRecognizer) {
        guard UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight else { return }
        guard gestureRecognizer.state == .ended else { return }
        
        swipeHandler()
    }
    
    @objc func swipeHandler() {
            
        // make an image with the principale uiview
        let renderer = UIGraphicsImageRenderer(size: principalView.bounds.size)
        let image = renderer.image { ctx in
            principalView.drawHierarchy(in: principalView.bounds, afterScreenUpdates: true)
        }
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

