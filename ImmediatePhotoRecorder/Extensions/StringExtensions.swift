//
//  StringExtensions.swift
//  ImmediatePhotoRecorder
//
//  Created by Dylan Smith on 3/5/16.
//  Copyright © 2016 com.heydylan. All rights reserved.
//

import UIKit

extension String {
    func isWhitespace() -> Bool {
        return (self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty)
    }
}
