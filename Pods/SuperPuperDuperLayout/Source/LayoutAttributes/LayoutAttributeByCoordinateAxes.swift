//
// LayoutAttributeByCoordinateAxes.swift
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

import Foundation

open class VerticalLayoutAttribute: LayoutAttribute<VerticalRelatedExtendedElement, VerticalRelatedElement> {}

open class VerticalViewLayoutAttribute: VerticalLayoutAttribute, LayoutAttributeRelatedToSuperView {
    public typealias RelationToSuperview = VerticalRelatedExtendedElement
}

open class HorizontalLayoutAttribute: LayoutAttribute<HorizontalRelatedElement, HorizontalRelatedElement> {}

open class HorizontalViewLayoutAttribute: HorizontalLayoutAttribute, LayoutAttributeRelatedToSuperView {
    public typealias RelationToSuperview = HorizontalRelatedElement
}
