//
//  ViewRecipeViewController.swift
//  RecipeBuilder
//
//  Created by Anjani Bhargava on 3/12/16.
//  Copyright © 2016 Cheeeese. All rights reserved.
//

import Parse
import UIKit

class ViewRecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var ingredients: [PFObject]! = []
    var directions: [PFObject]! = []
    var recipePhoto: [PFObject]! = []
    
    var recipeObject: PFObject!
    var recipeId: String!

    var recipeShoppingListArray: [PFObject]! = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let ingredientsQuery = PFQuery(className: "Ingredients")
        ingredientsQuery.whereKey("recipe", equalTo: recipeObject)
        ingredientsQuery.orderByAscending("order")
        ingredientsQuery.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            self.ingredients = results as [PFObject]!
            self.tableView.reloadData()
            print(self.ingredients)
        }
        
        let directionsQuery = PFQuery(className: "Directions")
        directionsQuery.whereKey("recipe", equalTo: recipeObject)
        directionsQuery.orderByAscending("order")
        directionsQuery.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            self.directions = results as [PFObject]!
            self.tableView.reloadData()
            print(self.directions)
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // photos, deatils
        if section == 0 {
            return 5
        }
        // this is how many rows you want of ingredients (ingredients is section 1)
        else if section == 1 {
            return ingredients.count
        }
        // this is how many rows you want of directions (directions is section 2)
        else {
            return directions.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let recipeImageCell = tableView.dequeueReusableCellWithIdentifier("RecipeImageCell") as! RecipeImageCell
                let recipeImageFile = recipeObject["image"] as! PFFile
                recipeImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            recipeImageCell.recipeImageContainer.image = image
                            UIView.animateWithDuration(0.7, animations: { () -> Void in
                                recipeImageCell.recipeImageContainer.alpha = 1
                            })
                        }
                    }
                }
                return recipeImageCell
            }
            else if indexPath.row == 1 {
                let categoryCell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell
                categoryCell.categoryLabel.text = recipeObject["category"] as? String
                return categoryCell
            }
            else if indexPath.row == 2 {
                let titleCell = tableView.dequeueReusableCellWithIdentifier("TitleCell") as! TitleCell
                titleCell.titleLabel.text = recipeObject["title"] as? String
                return titleCell
            }
            else if indexPath.row == 3 {
                let descriptionCell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell") as! DescriptionCell
                descriptionCell.descriptionLabel.text = recipeObject["description"] as? String
                return descriptionCell
            }
            else {
                let detailsCell = tableView.dequeueReusableCellWithIdentifier("DetailsCell") as! DetailsCell
                detailsCell.servingSizeLabel.text = recipeObject["servings"] as? String
                detailsCell.cookTimeLabel.text = recipeObject["cook_time"] as? String
                detailsCell.prepTimeLabel.text = recipeObject["prep_time"] as? String
                return detailsCell
            }
        }
        
        // ingredients section
        else if indexPath.section == 1 {
            let ingredientsCell = tableView.dequeueReusableCellWithIdentifier("IngredientsCell") as! IngredientsCell
            ingredientsCell.viewRecipeViewController = self
            let currentIndex = ingredients[indexPath.row]
            ingredientsCell.ingredientsLabel.text = currentIndex["name"] as? String
            return ingredientsCell
        }
        
        //directions section
        else {
            let directionsCell = tableView.dequeueReusableCellWithIdentifier("DirectionsCell") as! DirectionsCell
            let currentIndex = directions[indexPath.row]
            directionsCell.directionsLabel.text = currentIndex["name"] as? String
            return directionsCell
        }

    }
    
    //headers go here
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // ingredients is section 1 so set here for section 1 here
        if section == 1 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 50))
            let label = UILabel(frame: CGRect(x: 12, y: 10, width: 300, height: 20))
            headerView.backgroundColor = UIColor(white: 100, alpha: 1)
            label.text = "Ingredients"
            label.textColor = UIColor.blackColor()
            label.font = UIFont(name: "SFUIText-Regular", size: 18)
            headerView.addSubview(label)
            return headerView
        }
            
        // directions is section 2 so set here for section 2 here
        else if section == 2 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 50))
            let label = UILabel(frame: CGRect(x: 12, y: 10, width: 300, height: 20))
            headerView.backgroundColor = UIColor(white: 100, alpha: 1)
            label.text = "Directions"
            label.textColor = UIColor.blackColor()
            label.font = UIFont(name: "SFUIText-Regular", size: 18)
            headerView.addSubview(label)
            return headerView
        }
        
        else {
            return nil
        }
    }
    
    // set heights for headers
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else {
            return 40
        }
    }
    
    
    // heights for rows
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            // photo
            if indexPath.row == 0 {
                return 230
            }
            // category
            else if indexPath.row == 1 {
                return 30
            }
            // title
            else if indexPath.row == 2 {
                return 30
            }
            // description
            else if indexPath.row == 3 {
                return 60
            }
            // details
            else {
                return 40
            }
        }
            
        else if indexPath.section == 1 {
            return 30
        }
        
        else {
            return 60
        }
        
    }
    
    @IBAction func didTapBack(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    func createItem(ingredient: String) {
        let shoppingItem = PFObject(className: "ShoppingItem")
        let currentObject = ingredient
        shoppingItem["name"] = currentObject
        shoppingItem["user"] = PFUser.currentUser()
        
        shoppingItem["checked"] = 0
        
        shoppingItem.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
        }
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
