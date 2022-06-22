//
//  B_OnboardingTextTableCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 21.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _B_OnboardingTextTableCell: OldCellData {
    var title : String { get }
    var mainText : NSAttributedString { get }
}

extension _B_OnboardingTextTableCell {
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(B_OnboardingTextTableCell.nib, forCellReuseIdentifier: B_OnboardingTextTableCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: B_OnboardingTextTableCell.identifire, for: indexPath) as? B_OnboardingTextTableCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class B_OnboardingTextTableCell : UITableViewCell {

    @IBOutlet private var textView : UITextView!
    
    @IBOutlet private var mainTitleLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
    }
    
    func configure(data: _B_OnboardingTextTableCell) {
        self.mainTitleLabel.text = data.title
        self.textView.attributedText = data.mainText
        self.layoutSubviews()
    }
}
