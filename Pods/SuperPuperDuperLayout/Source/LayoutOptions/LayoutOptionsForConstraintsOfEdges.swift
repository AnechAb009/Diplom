//
// LayoutOptionsForConstraintsOfEdges.swift
//
// Copyright (c) 2018-Present Sugar And Candy ( https://github.com/SugarAndCandy )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

open class LayoutOptionsForConstraintsOfEdges: LayoutOptions, LayoutOptionsEditableValueProtocol {
    public typealias ValueType = UIEdgeInsets
    internal convenience init(top: LayoutDescription, bottom: LayoutDescription?, leading: LayoutDescription?, trailing: LayoutDescription?) {
        self.init(layoutDescription: top)
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }
    internal weak var bottom: LayoutDescription?
    internal weak var leading: LayoutDescription?
    internal weak var trailing: LayoutDescription?
    
    public required init(layoutDescription: LayoutDescription) { super.init(layoutDescription: layoutDescription) }
    
    @discardableResult
    open func value(_ value: ValueType) -> Self {
        layoutDescription.constant = value.top
        bottom?.constant = value.bottom
        leading?.constant = value.left
        trailing?.constant = value.right
        return self
    }
    
    @discardableResult
    open override func priority(_ priority: UILayoutPriority) -> Self {
        super.priority(priority)
        bottom?.priority = priority
        leading?.priority = priority
        trailing?.priority = priority
        return self
    }
    
    @discardableResult
    open override func multiplier(_ m: Multiplier) -> Self {
        return multiplier(m.rawValue)
    }
    
    @discardableResult
    open override func multiplier(_ m: Float) -> Self {
        super.multiplier(m)
        bottom?.multiplier = m
        leading?.multiplier = m
        trailing?.multiplier = m
        return self
    }
    
    open var nsTopLayoutConstraint: NSLayoutConstraint? { return layoutDescription.nsLayoutConstraint }
    open var nsBottomLayoutConstraint: NSLayoutConstraint? { return bottom?.nsLayoutConstraint }
    open var nsLeadingLayoutConstraint: NSLayoutConstraint? { return leading?.nsLayoutConstraint }
    open var nsTrailingLayoutConstraint: NSLayoutConstraint? { return trailing?.nsLayoutConstraint }
}
