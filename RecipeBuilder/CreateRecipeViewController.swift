//
//  CreateRecipeViewController.swift
//  RecipeBuilder
//
//  Created by Anjani Bhargava on 3/6/16.
//  Copyright © 2016 Cheeeese. All rights reserved.
//

import UIKit

class CreateRecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {

    @IBOutlet weak var recipeInputTableView: UITableView!
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImageView!
    var addImageBtn: UIButton!
    var categoryInputTextField: UITextField!
    var descriptionInputTextView: UITextView!
    
    var categoryData = ["Breakfast", "Lunch", "Dinner", "Salad", "Dessert", "Drinks"]
    var picker = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeInputTableView.dataSource = self
        recipeInputTableView.delegate = self
        //recipeInputTableView.rowHeight = 160
        
        self.recipeInputTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        imagePicker.delegate = self
        
        picker.delegate = self
        picker.dataSource = self
        //categoryInputTextField.inputView = picker
        //categoryInputTextField.text = nil

    }

    // go back to my recipes
    @IBAction func didTapBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let recipeImageInputCell = tableView.dequeueReusableCellWithIdentifier("RecipeImageInputCell") as! RecipeImageInputCell
            
            selectedImage = recipeImageInputCell.recipeImage
            addImageBtn = recipeImageInputCell.addImageBtn
            
            return recipeImageInputCell
            
        } else if indexPath.row == 1  {
            let titleInputCell = tableView.dequeueReusableCellWithIdentifier("TitleInputCell") as! TitleInputCell
            return titleInputCell
            
        } else if indexPath.row == 2 {
            let categoryInputCell = tableView.dequeueReusableCellWithIdentifier("CategoryInputCell") as! CategoryInputCell
            
            categoryInputTextField = categoryInputCell.categoryInputTextField
            categoryInputCell.categoryInputTextField.inputView = picker
            
            return categoryInputCell
            
        } else if indexPath.row == 3 {
            let descriptionInputCell = tableView.dequeueReusableCellWithIdentifier("DescriptionInputCell") as! DescriptionInputCell
            
            descriptionInputTextView = descriptionInputCell.descriptionInputTextView
            //descriptionInputCell.descriptionInputTextView.frame.size.width = descriptionInputTextView.frame.size.width
            
            descriptionInputCell.descriptionInputTextView.delegate = self
            
//            expandTextView()
            
            return descriptionInputCell
        } else {
            let servingsInputCell = tableView.dequeueReusableCellWithIdentifier("ServingsInputCell") as! ServingsInputCell
            return servingsInputCell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 160
        } else if indexPath.row == 1 || indexPath.row == 2 {
            
            return 50
        } else if indexPath.row == 3 {
            if descriptionInputTextView == nil {
                return 145
            } else {
                return descriptionInputTextView.frame.height + 44
            }
        } else {
           return 50 
        }
    }
    
    
    @IBAction func addImageTapped(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        selectedImage.image = image
        
        if addImageBtn == nil {
            addImageBtn.alpha = 1
        } else {
            //addImageBtn.alpha = 0.1
            addImageBtn.setImage(nil, forState: .Normal)
            addImageBtn.setTitle(nil, forState: .Normal)
        }
        
    }
    
    
    //Category Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryData.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryInputTextField.text = categoryData[row]
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryData[row]
    }


    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
        
    }
    
    
    @IBAction func dismissCreateRecipe(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //Hide the status bar
    override func prefersStatusBarHidden() -> Bool {
        
        return true;
    }
    
    //Expanding TextView
    func expandTextView () {
        
        let fixedWidth = descriptionInputTextView.frame.size.width
        descriptionInputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = descriptionInputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = descriptionInputTextView.frame
        
        let height = max(newSize.height + 5, 79)
        
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: height)
        descriptionInputTextView.frame = newFrame
        
        descriptionInputTextView.scrollEnabled = false
        
    }
    
    func textViewDidChange(textView: UITextView) {
        expandTextView()
        
        var height = max(descriptionInputTextView.frame.height + 66, 165)
        //print("height: \(height)")
        
        recipeInputTableView.beginUpdates()
        recipeInputTableView.endUpdates()
        
//        recipeInputTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
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
