//
//  Extensions.swift
//  Spotify_Music
//
//  Created by Mallikharjun kakarla on 09/12/23.
//

import Foundation
import UIKit

//MARK: Framing
extension UIView {
    
    var width:CGFloat {
        return frame.size.width
    }
    
    var height:CGFloat {
        return frame.size.height
    }
    
    var left:CGFloat {
        return frame.origin.x
    }
    
    var right:CGFloat {
        return left+width
    }
    
    var top:CGFloat {
        return frame.origin.y
    }
    
    var bottom:CGFloat {
        return top+height
    }
}

//MARK: Adding subviews
extension UIView {
    func addSubViews(_ views:UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension UIViewController {
    func showToast(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            alert.dismiss(animated: true)
        }
    }
}
