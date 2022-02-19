//
//  SearchViewController.swift
//  SampleLinkPresentation
//
//  Created by Noah on 2022/02/19.
//

import UIKit

final class SearchViewController: UIViewController {

    @IBOutlet private weak var stackView: UIStackView?
    @IBOutlet private weak var errorLabel: UILabel?
    @IBOutlet private weak var urlInputTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func searchButtonDidTap(_ sender: Any) {
    }
    
}
