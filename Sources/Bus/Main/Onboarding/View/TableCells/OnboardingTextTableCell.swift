//
//  OnboardingTextTableCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 21.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _OnboardingTextTableCell: OldCellData {
    var title: String { get }
    var mainText: NSAttributedString { get }
}

extension _OnboardingTextTableCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(OnboardingTextTableCell.nib, forCellReuseIdentifier: OnboardingTextTableCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingTextTableCell.identifire, for: indexPath) as? OnboardingTextTableCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class OnboardingTextTableCell: UITableViewCell {

    @IBOutlet private var textView: UITextView!
    @IBOutlet private var mainTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(data: _OnboardingTextTableCell) {
        self.mainTitleLabel.text = data.title
        self.textView.attributedText = data.mainText
        self.layoutSubviews()
    }
    
}
