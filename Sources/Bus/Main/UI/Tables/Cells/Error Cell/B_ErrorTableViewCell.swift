//
//  B_ErrorTableViewCell.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 20.09.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _ErrorData: OldCellData {
    var title : String { get }
    var descr : String { get }
    var onRetry : (() -> ())? { get }
}

extension _ErrorData {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(B_ErrorTableViewCell.nib, forCellReuseIdentifier: B_ErrorTableViewCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: B_ErrorTableViewCell.identifire, for: indexPath) as? B_ErrorTableViewCell else { return .init() }
        cell.configure(self)
        return cell
    }
}

class B_ErrorTableViewCell : UITableViewCell {
    
    static let reuseID = "B_ErrorTableViewCell"

    @IBOutlet weak var errorTitle       : UILabel!
    @IBOutlet weak var errorDescLabel   : UILabel!
    @IBOutlet weak var errorRetryButton : UIButton!
    
    var onButtonTap: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        errorRetryButton.roundCorners(.all, radius: 8)
        errorRetryButton.setTitle("Retry again".localized(in: Bus.shared.bundle), for: .normal)
    }
    
    public func configure(_ data: _ErrorData) {
        errorTitle.text = data.title
        errorDescLabel.text = data.descr
        if let onRetry = data.onRetry {
            onButtonTap = data.onRetry
            errorRetryButton.isHidden = false
        } else {
            errorRetryButton.isHidden = true
        }
    }
    
    @IBAction func handleRetryTap(_ sender: UIButton) {
        onButtonTap?()
    }
}
