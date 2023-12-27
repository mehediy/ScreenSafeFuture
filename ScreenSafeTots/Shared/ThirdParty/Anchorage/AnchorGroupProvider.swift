//
//  AnchorGroupProvider.swift
//  Anchorage
//
//  Created by Rob Visentin on 5/1/17.
//
//  Copyright 2016 Rightpoint and other contributors
//  http://rightpoint.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

protocol AnchorGroupProvider {

    var horizontalAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutXAxisAnchor> { get }
    var verticalAnchors: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor> { get }
    var centerAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutYAxisAnchor> { get }
    var sizeAnchors: AnchorPair<NSLayoutDimension, NSLayoutDimension> { get }

}

extension AnchorGroupProvider {

    var edgeAnchors: EdgeAnchors {
        return EdgeAnchors(horizontal: horizontalAnchors, vertical: verticalAnchors)
    }

}

extension XView: AnchorGroupProvider {

    var horizontalAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutXAxisAnchor> {
        return AnchorPair(first: leadingAnchor, second: trailingAnchor)
    }

    var verticalAnchors: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor> {
        return AnchorPair(first: topAnchor, second: bottomAnchor)
    }

    var centerAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutYAxisAnchor> {
        return AnchorPair(first: centerXAnchor, second: centerYAnchor)
    }

    var sizeAnchors: AnchorPair<NSLayoutDimension, NSLayoutDimension> {
        return AnchorPair(first: widthAnchor, second: heightAnchor)
    }

}

extension XViewController: AnchorGroupProvider {

    @available(*, deprecated, message: "Do not set constraints directly on a UIViewController; set them on its root UIView.")
    var horizontalAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutXAxisAnchor> {
        return view.horizontalAnchors
    }

    @available(*, deprecated, message: "Do not set constraints directly on a UIViewController; set them on its root UIView.")
    var verticalAnchors: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor> {
#if os(macOS)
        return view.verticalAnchors
#else
        return AnchorPair(first: topLayoutGuide.bottomAnchor, second: bottomLayoutGuide.topAnchor)
#endif
    }

    @available(*, deprecated, message: "Do not set constraints directly on a UIViewController; set them on its root UIView.")
    var centerAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutYAxisAnchor> {
        return view.centerAnchors
    }

    @available(*, deprecated, message: "Do not set constraints directly on a UIViewController; set them on its root UIView.")
    var sizeAnchors: AnchorPair<NSLayoutDimension, NSLayoutDimension> {
        return view.sizeAnchors
    }

}

extension XLayoutGuide: AnchorGroupProvider {

    var horizontalAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutXAxisAnchor> {
        return AnchorPair(first: leadingAnchor, second: trailingAnchor)
    }

    var verticalAnchors: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor> {
        return AnchorPair(first: topAnchor, second: bottomAnchor)
    }

    var centerAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutYAxisAnchor> {
        return AnchorPair(first: centerXAnchor, second: centerYAnchor)
    }

    var sizeAnchors: AnchorPair<NSLayoutDimension, NSLayoutDimension> {
        return AnchorPair(first: widthAnchor, second: heightAnchor)
    }

}

// MARK: - EdgeAnchors

struct EdgeAnchors: LayoutAnchorType {

    var horizontalAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutXAxisAnchor>
    var verticalAnchors: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor>

}

// MARK: - Axis Group

struct ConstraintPair {

    var first: NSLayoutConstraint
    var second: NSLayoutConstraint

}

// MARK: - ConstraintGroup

struct ConstraintGroup {

    var top: NSLayoutConstraint
    var leading: NSLayoutConstraint
    var bottom: NSLayoutConstraint
    var trailing: NSLayoutConstraint

    var horizontal: [NSLayoutConstraint] {
        return [leading, trailing]
    }

    var vertical: [NSLayoutConstraint] {
        return [top, bottom]
    }

    var all: [NSLayoutConstraint] {
        return [top, leading, bottom, trailing]
    }

}
