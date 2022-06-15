//
//  CellData.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 21.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

@available(*, deprecated, message: "import CoreTableView && use CellData from there")
public protocol OldCellData {
    
    var tintColor: UIColor { get }
    
    var accesoryType: UITableViewCell.AccessoryType? { get }
    
    var accessoryView: UIView? { get }
    
    var onSelect: () -> () { get }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    
    func cell(for collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    
    func didEndDisplaying(for tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath)
    
    func willDisplay(for tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath)
}

extension OldCellData {
    
    var tintColor: UIColor { return .textPrimary }
    
    var accesoryType: UITableViewCell.AccessoryType? { return nil }
    
    var accessoryView: UIView? { return nil }
    
    var onSelect: () -> () { return {} }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return .init()
    }
    
    func cell(for collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return .init()
    }
    
    func didEndDisplaying(for: UITableView, cell: UITableViewCell, indexPath: IndexPath) { }
    
    func willDisplay(for: UITableView, cell: UITableViewCell, indexPath: IndexPath) { }
    
}

#if !APPCLIP
extension OldCellData {
    
    func toElement(id: Int? = nil) -> Element {
        if let id = id {
            return Element(id: id, content: self)
        } else {
            return Element(content: self)
        }   
    }
}
#endif
