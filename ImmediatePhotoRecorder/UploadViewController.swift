//
//  UploadViewController.swift
//  InstaScratch
//
//  Created by Dylan Smith on 3/1/16.
//  Copyright © 2016 com.heydylan. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var uploadProgress: UIProgressView!
    @IBOutlet weak var captionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onImageButton(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Pick a source", message: nil, preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Take a picture", style: .Default) { (action) -> Void in
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.Camera
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
        let rollAction = UIAlertAction(title: "From Camera roll", style: .Default) { (action) -> Void in
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionSheet.addAction(cancel)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(rollAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imageButton.setBackgroundImage(image, forState: .Normal)
        imageButton.setTitle("", forState: .Normal)
    }
    @IBAction func onUpload(sender: AnyObject) {
        if imageButton.backgroundImageForState(.Normal) != nil {
            ParseData.postUserImage(imageButton.backgroundImageForState(.Normal), withCaption: captionField.text, withCompletion: { (success, error) -> Void in
                self.uploadProgress.hidden = true
                NSNotificationCenter.defaultCenter().postNotificationName("photoDidPost", object: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
                }, withProgress: { (prog) -> Void in
                    self.uploadProgress.hidden = false
                    if prog == 100 {
                        self.uploadProgress.setProgress(100, animated: false)
                    } else {
                        self.uploadProgress.setProgress(Float(prog), animated: true)
                    }
            })
            
        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
