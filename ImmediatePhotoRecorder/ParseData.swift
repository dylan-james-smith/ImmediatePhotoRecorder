//
//  ParseData.swift
//  ImmediatePhotoRecorder
//
//  Created by Dylan Smith on 3/6/16.
//  Copyright © 2016 com.heydylan. All rights reserved.
//

import UIKit
import Parse

class ParseData: NSObject {
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?, withProgress progress: PFProgressBlock?) {
        
        let media = PFObject(className: "ParseData")
        
        let image = getPFFileFromImage(image)
        media["media"] = image
        media["author"] = PFUser.currentUser()
        media["caption"] = caption
//        media["bio"] = bio
        media["likesCount"] = 0
        
        image?.saveInBackgroundWithBlock({ (success, error) -> Void in
            media.saveInBackgroundWithBlock(completion)
            }, progressBlock: progress)
        
    }
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }


}
