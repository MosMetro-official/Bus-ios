//
//  TicketDetailsView.swift
//  MosmetroNew
//
//  Created by Гусейн on 17.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import ViewAnimator

class TicketDetailsView: UIView {
    
    @IBOutlet private var tableView: OldBaseTableView!
    @IBOutlet private var effectView: UIVisualEffectView!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var payButton: MKButton!
    @IBOutlet var effectViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    private var unauthorizedView: BottomModalView?
    
    lazy var titleStackView: UIStackView = {
        // title label
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "Title"
        titleLabel.font = UIFont(name: "MoscowSans-Bold", size: 17)
        titleLabel.textColor = .textPrimary
        // subtitleLabel
        let subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "main_bus_trip_details".localized(in: .module)
        subtitleLabel.font = UIFont(name: "MoscowSans-Bold", size: 11)
        subtitleLabel.textColor = .grey
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private var hasMadeFirstLoad = false
        
    struct ViewState {
        var title: String
        var subtitle: String
        var price: String = "0 ₽"
        var onPay: (() -> ())?
        var tableItems: [OldState]
        var dataState: DataState
        var unauthorized: ParkingUnauthorizedModel?
        
        enum DataState {
            case loading(MetroLoadingView.ViewState)
            case loaded
            case error(FutureNetworkError)
        }
        
        struct SelectRow: _TicketSelectCell {
            var image: UIImage
            var title: String
            var subtitle: String
            var subtitleColor: UIColor
            var onSelect: () -> ()
        }
        
        struct Attribute: _TicketAttributeCell {
            var image: UIImage
            var name: String
            var value: String
        }
        
        struct StartPoint: _TicketStartCell {
            var title: String
            var subtitle: String
        }
        
        struct EndPoint: _TicketArrivalCell {
            var title: String
            var subtitle: String
        }
        
        struct Header: _TitleHeaderView {
            var title: String
            var style: HeaderTitleStyle
            var backgroundColor: UIColor
            var isInsetGrouped: Bool
        }
        
        static let initial = ViewState.init(title: "", subtitle: "", price: "", onPay: nil, tableItems: [], dataState: .loading(.init(title: "main_bus_loading_race".localized(in: .module), subtitle: "main_bus_please_wait".localized(in: .module))))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            render()
        }
    }
    
    @IBAction func handlePay(_ sender: MKButton) {
        viewState.onPay?()
    }
}

extension TicketDetailsView {
    
    private func setup() {
        tableView.register(TicketStartCell.nib, forCellReuseIdentifier: TicketStartCell.identifire)
        tableView.register(TicketSelectCell.nib, forCellReuseIdentifier: TicketSelectCell.identifire)
        effectView.roundCorners(.top, radius: 12)
        payButton.roundCorners(.all, radius: 8)
    }
    
    private func showUnauthorized(state: ParkingUnauthorizedModel?) {
        if let state = state {
            if let unauthView = self.unauthorizedView {
                unauthView.configure(with: state)
            } else {
                self.unauthorizedView = BottomModalView.loadFromNib()
                self.addSubview(self.unauthorizedView!)
                self.unauthorizedView!.pin(on: self, {[
                    $0.bottomAnchor.constraint(equalTo: effectView.topAnchor, constant: -32),
                    $0.leadingAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                    $0.trailingAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.trailingAnchor, constant: -16)
                ]})
                self.unauthorizedView?.configure(with: state)
                let fromAnimation = AnimationType.from(direction: .bottom, offset: 100)
                UIView.animate(views: [self.unauthorizedView!],
                               animations: [fromAnimation],
                               duration: 0.5)
            }
        } else {
            if let unauthView = self.unauthorizedView {
                unauthView.removeFromSuperview()
                self.unauthorizedView = nil
            }
        }
    }
    
    private func render() {
        DispatchQueue.main.async {
            switch self.viewState.dataState {
            case .loading(let loadingData):
                self.showLoading(with: loadingData)
                self.effectViewHeightAnchor.constant = 0
                self.layoutIfNeeded()
            case .loaded:
                if self.hasMadeFirstLoad {
                    self.tableView.viewStateInput = self.viewState.tableItems
                }
                self.hasMadeFirstLoad = true
                self.removeLoading { [weak self] in
                        guard let self = self else { return }
                        if let titleLabel = self.titleStackView.arrangedSubviews[safe: 0] as? UILabel, let subLabel = self.titleStackView.arrangedSubviews[safe: 1] as? UILabel {
                            titleLabel.text = self.viewState.title
                            subLabel.text = self.viewState.subtitle
                        }
                        self.parentViewController?.navigationItem.titleView = self.titleStackView
                        self.effectViewHeightAnchor.constant = self.safeAreaInsets.bottom + 68
                        UIView.animate(withDuration: 0.2, animations: {
                            self.layoutIfNeeded()
                        })
                        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.effectView.frame.height, right: 0)
                        self.tableView.viewStateInput = self.viewState.tableItems
                }
            case .error(let err):
                self.removeLoading()
                MetroAlertView.showMetroAlert(with: .init(style: .warning, title: err.errorDescription, onRetry: nil), removeAfter: 8 )
                self.effectViewHeightAnchor.constant = self.hasMadeFirstLoad ? (self.safeAreaInsets.bottom + 68) : 0
                    UIView.animate(withDuration: 0.2, animations: {
                        self.layoutIfNeeded()
                    })
            }
            self.showUnauthorized(state: self.viewState.unauthorized)
            self.priceLabel.text = self.viewState.price
            self.payButton.isEnabled = self.viewState.onPay == nil ? false : true
            self.payButton.setTitle("Pay".localized(in: .module), for: .normal)
            self.totalPriceLabel.text = "main_bus_price_total".localized(in: .module)
        }
    }
}

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
