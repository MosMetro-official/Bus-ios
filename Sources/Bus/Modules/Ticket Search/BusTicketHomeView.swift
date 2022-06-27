//
//  BusTicketHomeView.swift
//  MosmetroNew
//
//  Created by Гусейн on 16.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class BusTicketHomeView : UIView {
    
    @IBOutlet weak var tableView: OldBaseTableView!
    
    @IBOutlet private weak var toView: UIView!
    
    @IBOutlet private weak var toLabel: UILabel!
    
    @IBOutlet private weak var dateView : UIView!
    
    @IBOutlet private weak var fromView : UIView!
    
    @IBOutlet private weak var dateLabel : UILabel!
    
    @IBOutlet private weak var fromLabel : UILabel!
    
    @IBOutlet private weak var stackView : UIStackView!
    
    @IBOutlet private weak var effectView : UIVisualEffectView!

    @IBOutlet private weak var stackViewBottomAnchor : NSLayoutConstraint!
    
    struct ViewState {
        
        var dataState: DataState
        var from: Field
        var to: Field
        var date: Field
        
        enum DataState {
            case initial([OldState])
            case loading(B_MetroLoadingView.ViewState)
            case loaded([OldState])
            case error(FutureNetworkError)
        }
        
        struct Field {
            let placeholder: String
            let text: String?
            let onSelect: () -> ()
        }
        
        struct Placeholder: _B_ImagePlaceholderTableCell {
            var title: String
            var subtitle: String
            var image: UIImage
        }
        
        struct BusTicketData: _BusTicketCell {
            var carrier: String
            var price: String
            var seats: String
            var fromDate: String
            var fromTime: String
            var from: String
            var fromDetailed: String
            var toDate: String
            var toTime: String
            var to: String
            var toDetailed: String
            var duration: String
            var onSelect: () -> ()
        }
        
        struct TitleHeader: _B_TitleHeaderView {
            var title: String
            var style: HeaderTitleStyle
            var backgroundColor: UIColor
            var isInsetGrouped: Bool
        }
        
        static let initial = ViewState.init(dataState: .initial([]), from: .init(placeholder: "", text: nil, onSelect: {}), to: .init(placeholder: "", text: nil, onSelect: {}), date: .init(placeholder: "", text: nil, onSelect: {}))
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.render()
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @IBAction func handleFromTap(_ sender: UITapGestureRecognizer) {
        viewState.from.onSelect()
    }
    
    @IBAction func handleToTap(_ sender: UITapGestureRecognizer) {
        viewState.to.onSelect()
    }
    
    @IBAction func handleDateTap(_ sender: UITapGestureRecognizer) {
        viewState.date.onSelect()
    }
}

extension BusTicketHomeView {
    
    private func setup() {
        stackView.arrangedSubviews.forEach {
            $0.roundCorners(.all, radius: 8)
        }
        
        effectView.roundCorners(.top, radius: 12)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.stackViewBottomAnchor.constant = self.safeAreaInsets.bottom + 16
            self.layoutIfNeeded()
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.effectView.frame.height, right: 0)
        })
        
        tableView.register(BusTicketCell.nib, forCellReuseIdentifier: BusTicketCell.identifire)
        
        tableView.onCellForRow = { tableData in
            switch tableData.element {
            case is ViewState.BusTicketData:
                guard let data = tableData.element as? ViewState.BusTicketData,
                      let cell = tableData.tableView.dequeueReusableCell(withIdentifier: BusTicketCell.identifire, for: tableData.indexPath) as? BusTicketCell else { return .init() }
                cell.configure(data: data)
                return cell
            default:
                return .init()
            }
        }
        
        tableView.onCellSelect = { tableData in
            switch tableData.element {
            case is ViewState.BusTicketData:
                if let data = tableData.element as? ViewState.BusTicketData {
                    data.onSelect()
                }
            default:
                break
            }
        }
    }
    
    private func render() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch self.viewState.dataState {
            case .loading(let loadingState):
                self.parentViewController?.navigationController?.setNavigationBarHidden(true, animated: true)
                self.showLoading(with: loadingState)
            case .loaded(let state):
                self.removeLoading { [weak self] in
                    guard let self = self else { return }
                    self.parentViewController?.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.tableView.viewStateInput = state
                }
            case .error(let error):
                self.removeLoading { [weak self] in
                    self?.parentViewController?.navigationController?.setNavigationBarHidden(false, animated: true)
                    self?.tableView.showError(title: "Error".localized(in: Bus.shared.bundle), desc: error.errorDescription, onRetry: nil)
                }
            case .initial(let state):
                self.tableView.viewStateInput = state
            }
            // from
            self.fromLabel.text = self.viewState.from.text == nil ? self.viewState.from.placeholder : self.viewState.from.text!
            self.fromLabel.textColor = self.viewState.from.text == nil ? .textSecondary : .textPrimary
            // to
            self.toLabel.text = self.viewState.to.text == nil ? self.viewState.to.placeholder : self.viewState.to.text!
            self.toLabel.textColor = self.viewState.to.text == nil ? .textSecondary : .textPrimary
            // date
            self.dateLabel.text = self.viewState.date.text == nil ? self.viewState.date.placeholder : self.viewState.date.text!
            self.dateLabel.textColor = self.viewState.date.text == nil ? .textSecondary : .textPrimary
            // table
        }
    }
}
