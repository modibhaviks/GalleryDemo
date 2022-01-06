//
//  RowViewModel.swift
//  GalleryDemo
//
//  Created by Bhavik Modi on 04/01/22.
//

import Foundation

class RowViewModel {
    var cellIdentifier : String?
    var data : Any?
    var action: ((_ actionType: Int?,_ data: Any?) -> (Void))?
    
    internal init(cellIdentifier: String?, data: Any? = nil, action: ((_ type: Int?,_ data: Any?) -> (Void))? = nil) {
        self.cellIdentifier = cellIdentifier
        self.data = data
        self.action = action
    }
}
