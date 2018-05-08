//
//  LoadingView.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/8/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import UIKit

class LoadingView: UIViewController {
    
    private let loadingModal: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSource.secondaryColor
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        view.layer.cornerRadius = 10
        return view
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        act.color = .black
        act.hidesWhenStopped = true
        return act
    }()
    
    var isShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingModal)
        loadingModal.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([loadingModal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingModal.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingModal.widthAnchor.constraint(equalToConstant: 120),
            loadingModal.heightAnchor.constraint(equalToConstant: 120)])
        
        let stack = UIStackView(arrangedSubviews: [activityIndicator, textLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        loadingModal.addSubview(stack)
        stack.anchor(top: loadingModal.topAnchor, left: loadingModal.leftAnchor, bottom: loadingModal.bottomAnchor, right: loadingModal.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
    }
    
    func setupErrorMessage() {
        activityIndicator.stopAnimating()
        textLabel.text = "Error"
    }

    func setupLoadingMessage() {
        activityIndicator.startAnimating()
        textLabel.text = "Loading..."
    }
    
    func dismissLoading() {
        dismiss(animated: true, completion: nil)
    }
}
