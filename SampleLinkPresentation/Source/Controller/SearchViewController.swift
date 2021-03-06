//
//  SearchViewController.swift
//  SampleLinkPresentation
//
//  Created by Noah on 2022/02/19.
//

import LinkPresentation
import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet private weak var stackView: UIStackView?
    @IBOutlet private weak var errorLabel: UILabel?
    @IBOutlet private weak var urlInputTextField: UITextField?
    private let activityIndicator = UIActivityIndicatorView()
    private var linkView = LPLinkView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction private func searchButtonDidTap(_ sender: Any) {
        hideErrorLabel()
        activityIndicator.startAnimating()
        if let requestUrl = urlInputTextField?.text {
            setUpLinkView(for: requestUrl)
        }
    }
    
    private func setUpUI() {
        hideErrorLabel()
        stackView?.insertArrangedSubview(activityIndicator, at: 0)
    }
    
    private func hideErrorLabel() {
        errorLabel?.isHidden = true
    }
    
    private func setUpLinkView(for stringUrl: String) {
        guard let url = URL(string: stringUrl) else {
            handleFailureFetchMetaData()
            return
        }
        
        linkView.removeFromSuperview()
        linkView = LPLinkView(url: url)
        fetchMetaData(for: url)
        self.stackView?.insertArrangedSubview(linkView, at: 0)
    }
    
    private func fetchMetaData(for url: URL) {
        if let existingMetaData = MetaDataCache.retrieve(urlString: url.absoluteString) {
            linkView = LPLinkView(metadata: existingMetaData)
            activityIndicator.stopAnimating()
        } else {
            MetaData.fetchMetaData(for: url) { [weak self] metadata in
                guard let self = self else { return }
                
                switch metadata {
                case .success(let metadata):
                    if let imageProvider = metadata.imageProvider {
                        metadata.iconProvider = imageProvider
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        self.activityIndicator.stopAnimating()
                        self.linkView.metadata = metadata
                    }
                case .failure(let error):
                    self.handleFailureFetchMetaData(for: error)
                }
            }
        }
    }
    
    private func handleFailureFetchMetaData(for error: LPError? = nil) {
        let errorLabelText = error?.prettyString ?? "????????? URL?????????. ?????? ??????????????????!"
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.linkView.removeFromSuperview()
            self.errorLabel?.text = errorLabelText
            self.errorLabel?.isHidden = false
        }
    }
}
