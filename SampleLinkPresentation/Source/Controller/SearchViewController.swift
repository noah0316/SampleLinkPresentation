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
    private var linkView = LPLinkView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideErrorLabel()
    }
    
    private func hideErrorLabel() {
        errorLabel?.isHidden = true
    }
    
    @IBAction private func searchButtonDidTap(_ sender: Any) {
        hideErrorLabel()
        if let requestUrl = urlInputTextField?.text {
            setupLinkView(for: requestUrl)
        }
    }
    
    private func setupLinkView(for stringUrl: String) {
        guard let url = URL(string: stringUrl) else {
            handleFailureFetchMetaData()
            return
        }
        
        linkView.removeFromSuperview()
        linkView = LPLinkView(url: url)
        
        MetaData.fetchMetaData(for: url) { [weak self] metadata in
            guard let self = self else { return }
            
            switch metadata {
            case .success(let metadata):
                if let imageProvider = metadata.imageProvider {
                    metadata.iconProvider = imageProvider
                }
        
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.linkView.metadata = metadata
                }
            case .failure(let error):
                self.handleFailureFetchMetaData(for: error)
            }
        }
        self.stackView?.insertArrangedSubview(linkView, at: 0)
    }
    
    private func handleFailureFetchMetaData(for error: LPError? = nil) {
        let errorLabelText = error?.prettyString ?? "잘못된 URL입니다. 다시 입력해주세요!"
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.linkView.removeFromSuperview()
            self.errorLabel?.text = errorLabelText
            self.errorLabel?.isHidden = false
        }
    }
}
