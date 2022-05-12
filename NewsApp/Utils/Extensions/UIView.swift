//
//  UIView.swift
//  NewsApp
//
//  Created by Devansh Vyas on 10/05/22.
//

import Foundation
import UIKit

enum NibNames: String {
    case CustomTextField
}

extension UIView {
    
    func nibSetup(nibName: NibNames) {
        backgroundColor = .clear
        let view = Bundle(for: self.classForCoder).loadNibNamed(nibName.rawValue, owner: self, options: nil)?.first as? UIView
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view?.translatesAutoresizingMaskIntoConstraints = true
        view?.isUserInteractionEnabled = true
        if let view = view {
            addSubview(view)
        }
    }
    
    ///To add line to view:-
    enum LinePosition {
        case top
        case bottom
    }
    
    ///To add line to view (Method)
    func addLineToView(position: LinePosition, color: UIColor, width: Double = 1.0) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)
        let metrics = ["width": NSNumber(value: width)]
        let views = ["lineView": lineView]
        let options = NSLayoutConstraint.FormatOptions(rawValue: 0)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|",
                                                           options: options,
                                                           metrics: metrics,
                                                           views: views))
        switch position {
        case .top:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]",
                                                               options: options,
                                                               metrics: metrics,
                                                               views: views))
        case .bottom:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|",
                                                               options: options,
                                                               metrics: metrics,
                                                               views: views))
        }
    }
    
    /// to add rounded corner with side and radius
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let cgSize = CGSize(width: radius, height: radius)
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cgSize)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    /// to add shadow
    func addShadow(shadowOffSet: CGSize = CGSize(width: 5, height: 5), radius: CGFloat = 10) {
        layer.masksToBounds = false
        layer.shadowOffset = shadowOffSet
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor.lightGray.cgColor
    }
}
