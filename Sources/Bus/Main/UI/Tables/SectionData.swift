//
//  SectionState.swift
//  MosmetroNew
//
//  Created by Кузин Павел on 06.10.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import CoreTableView

@available(*, deprecated, message: "import CoreTableView && use State from there")
typealias OldState = ArraySection<SectionState, Element>

@available(*, deprecated, message: "import CoreTableView && use Element from there")
struct Element : ContentEquatable, ContentIdentifiable {
    
    var id : Int = Int.random(in: 0..<1000000)
    
    var content : OldCellData
    
    var differenceIdentifier: Int {
        return self.id
    }
    
    func isContentEqual(to source: Element) -> Bool {
        return self.id == source.id
    }
}

@available(*, deprecated, message: "import CoreTableView && use SectionState from there")
struct SectionState : Differentiable, Equatable {
    
    static func == (lhs: SectionState, rhs: SectionState) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int = Int.random(in: 0..<1000000)

    var isCollapsed = false

    var differenceIdentifier: Int {
        return id
    }

    var header: Any?
    var footer: Any?
    
    init(id: Int = Int.random(in: 0..<1000000), isCollapsed: Bool = false, header: Any?, footer: Any?) {
        self.id = id
        self.isCollapsed = isCollapsed
        self.footer = footer
        self.header = header
    }
}

@available(*, deprecated, message: "import CoreTableView && use Style from there")
enum HeaderTitleStyle {
    case small
    case medium
    case large
    
    func font() -> UIFont {
        switch self {
        case .small:
            return .Body_13_Bold
        case .medium:
            return .Body_15_Bold
        case .large:
            return .Headline_2
        }
    }
}

@available(*, deprecated, message: "import CoreTableView && use Style from there")
protocol Header {
    var title: String { get set }
    var attributedTitle: NSAttributedString? { get set }
    var titleStyle: HeaderTitleStyle { get set }
    var edgeInset: CGFloat { get set }
}
