//
//  ViewController.swift
//  HalfCard
//
//  Created by Chris Spradling on 2/28/20.
//  Copyright © 2020 Chris Spradling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let coordinator = TransitionCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView()
        view.backgroundColor = .gray
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(gesture)
        
        let label = UILabel(frame: .zero)
        label.text = "This is some text"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc private func onTap() {
        let vc = PresenterVC()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = coordinator
        present(vc, animated: true, completion: nil)
    }

}
