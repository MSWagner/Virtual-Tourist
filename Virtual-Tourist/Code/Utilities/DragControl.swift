//
//  DragControl.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 09.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import ReactiveSwift

@IBDesignable
class DragControl: UIControl {

    // MARK: - Properties

    var lastTouchedPoint = MutableProperty<CGPoint?>(nil)
    var isSingleTouched = MutableProperty<Bool>(false)

    var move = MutableProperty<CGFloat?>(nil)

    // MARK: - Touch Functions

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastTouchedPoint.value = touch.location(in: self)
            move.value = 0
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            guard let lastTouchedPoint = lastTouchedPoint.value, let move = move.value else { return }
            self.move.value = move + lastTouchedPoint.y - touch.location(in: self).y

            self.lastTouchedPoint.value = touch.location(in: self)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil && (move.value == 0 || move.value == nil) {
            isSingleTouched.value = true
        }
        move.value = nil
        isSingleTouched.value = false
    }

    // MARK: - Draw

    override func draw(_ rect: CGRect) {
        //// General Declarations (Made with Paincode)
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }

        //// Subframes
        let group: CGRect = CGRect(x: rect.minX, y: rect.minY, width: fastFloor((rect.width) * 1.00000 + 0.5), height: fastFloor((rect.height) * 1.00000 + 0.5))

        //// Group
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: group.minX + fastFloor(group.width * 0.00000 + 0.5), y: group.minY + fastFloor(group.height * 0.00000 + 0.5), width: fastFloor(group.width * 1.00000 + 0.5) - fastFloor(group.width * 0.00000 + 0.5), height: fastFloor(group.height * 1.00000 + 0.5) - fastFloor(group.height * 0.00000 + 0.5)), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 25, height: 25))
        rectanglePath.close()
        UIColor.darkGray.setFill()
        rectanglePath.fill()


        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRect(x: group.minX + fastFloor(group.width * 0.21667 + 0.5), y: group.minY + fastFloor(group.height * 0.20000 + 0.5), width: fastFloor(group.width * 0.78333 + 0.5) - fastFloor(group.width * 0.21667 + 0.5), height: fastFloor(group.height * 0.22000 + 0.5) - fastFloor(group.height * 0.20000 + 0.5)))
        UIColor.gray.setFill()
        rectangle2Path.fill()


        //// Rectangle 3 Drawing
        let rectangle3Path = UIBezierPath(rect: CGRect(x: group.minX + fastFloor(group.width * 0.21667 + 0.5), y: group.minY + fastFloor(group.height * 0.40000 + 0.5), width: fastFloor(group.width * 0.78333 + 0.5) - fastFloor(group.width * 0.21667 + 0.5), height: fastFloor(group.height * 0.42000 + 0.5) - fastFloor(group.height * 0.40000 + 0.5)))
        UIColor.gray.setFill()
        rectangle3Path.fill()

        //// Rectangle 4 Drawing
        let rectangle4Path = UIBezierPath(rect: CGRect(x: group.minX + fastFloor(group.width * 0.21667 + 0.5), y: group.minY + fastFloor(group.height * 0.60000 + 0.5), width: fastFloor(group.width * 0.78333 + 0.5) - fastFloor(group.width * 0.21667 + 0.5), height: fastFloor(group.height * 0.62000 + 0.5) - fastFloor(group.height * 0.60000 + 0.5)))
        UIColor.gray.setFill()
        rectangle4Path.fill()


        //// Rectangle 5 Drawing
        let rectangle5Path = UIBezierPath(rect: CGRect(x: group.minX + fastFloor(group.width * 0.21667 + 0.5), y: group.minY + fastFloor(group.height * 0.80000 + 0.5), width: fastFloor(group.width * 0.78333 + 0.5) - fastFloor(group.width * 0.21667 + 0.5), height: fastFloor(group.height * 0.82000 + 0.5) - fastFloor(group.height * 0.80000 + 0.5)))
        UIColor.gray.setFill()
        rectangle5Path.fill()


        //// Rectangle 6 Drawing
        let rectangle6Path = UIBezierPath(rect: CGRect(x: group.minX + fastFloor(group.width * 0.21667 + 0.5), y: group.minY + fastFloor(group.height * 0.10000 + 0.5), width: fastFloor(group.width * 0.78333 + 0.5) - fastFloor(group.width * 0.21667 + 0.5), height: fastFloor(group.height * 0.12000 + 0.5) - fastFloor(group.height * 0.10000 + 0.5)))
        UIColor.gray.setFill()
        rectangle6Path.fill()


        //// Rectangle 7 Drawing
        let rectangle7Path = UIBezierPath(rect: CGRect(x: group.minX + fastFloor(group.width * 0.21667 + 0.5), y: group.minY + fastFloor(group.height * 0.30000 + 0.5), width: fastFloor(group.width * 0.78333 + 0.5) - fastFloor(group.width * 0.21667 + 0.5), height: fastFloor(group.height * 0.32000 + 0.5) - fastFloor(group.height * 0.30000 + 0.5)))
        UIColor.gray.setFill()
        rectangle7Path.fill()


        //// Rectangle 8 Drawing
        let rectangle8Path = UIBezierPath(rect: CGRect(x: group.minX + fastFloor(group.width * 0.21667 + 0.5), y: group.minY + fastFloor(group.height * 0.50000 + 0.5), width: fastFloor(group.width * 0.78333 + 0.5) - fastFloor(group.width * 0.21667 + 0.5), height: fastFloor(group.height * 0.52000 + 0.5) - fastFloor(group.height * 0.50000 + 0.5)))
        UIColor.gray.setFill()
        rectangle8Path.fill()


        //// Rectangle 9 Drawing
        let rectangle9Path = UIBezierPath(rect: CGRect(x: group.minX + fastFloor(group.width * 0.21667 + 0.5), y: group.minY + fastFloor(group.height * 0.70000 + 0.5), width: fastFloor(group.width * 0.78333 + 0.5) - fastFloor(group.width * 0.21667 + 0.5), height: fastFloor(group.height * 0.72000 + 0.5) - fastFloor(group.height * 0.70000 + 0.5)))
        UIColor.gray.setFill()
        rectangle9Path.fill()
    }
}
