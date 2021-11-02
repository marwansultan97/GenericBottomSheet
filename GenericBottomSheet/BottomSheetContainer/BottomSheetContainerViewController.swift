//
//  BottomSheetContainerViewController.swift
//  GenericBottomSheet
//
//  Created by Marwan Osama on 02/11/2021.
//

import UIKit


class BottomSheetContainerViewController<Content: UIViewController, BottomSheet: UIViewController>: UIViewController, UIGestureRecognizerDelegate {
    
    let contentViewController: Content
    let bottomSheetViewController: BottomSheet
    let configuration: BottomSheetConfiguration
    var state: BottomSheetState = .initial
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.delegate = self
        pan.addTarget(self, action: #selector(handlePan(_:)))
        return pan
    }()
    
    private var topConstraint = NSLayoutConstraint()
    
    init(contentViewController: Content,
         bottomSheetViewController: BottomSheet,
         configuration: BottomSheetConfiguration) {
        self.contentViewController = contentViewController
        self.bottomSheetViewController = bottomSheetViewController
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurations
    
    struct BottomSheetConfiguration {
        let height: CGFloat
        let initialOffset: CGFloat
    }
    
    enum BottomSheetState {
        case initial
        case full
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        self.addChild(contentViewController)
        self.addChild(bottomSheetViewController)
        self.view.addSubview(contentViewController.view)
        self.view.addSubview(bottomSheetViewController.view)
        
        bottomSheetViewController.view.addGestureRecognizer(panGesture)
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            contentViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            contentViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
        
        contentViewController.didMove(toParent: self)
        
        topConstraint = bottomSheetViewController.view.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -configuration.initialOffset)
        
        NSLayoutConstraint.activate([
            bottomSheetViewController.view.heightAnchor.constraint(equalToConstant: configuration.height),
            bottomSheetViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomSheetViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            topConstraint
        ])
        
        bottomSheetViewController.didMove(toParent: self)
        
    }
    
    // MARK: - Bottom Sheet Actions
    
    func expandSheet(animated: Bool = true) {
        self.topConstraint.constant = -configuration.height
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.state = .full
            }

        } else {
            self.view.layoutIfNeeded()
            self.state = .full
        }
    }
    
    func collapseSheet(animated: Bool = true) {
        self.topConstraint.constant = -configuration.initialOffset
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.state = .initial
            }


        } else {
            self.view.layoutIfNeeded()
            self.state = .initial
        }
    }
    
    
    // MARK: - UIGesture Delegate
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: bottomSheetViewController.view)
        let velocity = sender.velocity(in: bottomSheetViewController.view)
        let yTranslationMagnitude = translation.y.magnitude
        
        switch sender.state {
        case .began, .changed:
            if self.state == .full {
                guard translation.y > 0 else { return }
                topConstraint.constant = -(configuration.height - yTranslationMagnitude)
                self.view.layoutIfNeeded()
            } else {
                let newConst = -(configuration.initialOffset + yTranslationMagnitude)
                guard translation.y < 0 else { return }
                guard newConst.magnitude < configuration.height else {
                    self.expandSheet()
                    return
                }
                topConstraint.constant = newConst
                self.view.layoutIfNeeded()
            }
            
        case .ended:
            if self.state == .full {
                if velocity.y < 0 {
                    self.expandSheet()
                } else if yTranslationMagnitude >= configuration.height / 2 || velocity.y > 1000 {
                    self.collapseSheet()
                } else {
                    self.expandSheet()
                }
                
            } else {
                if yTranslationMagnitude >= configuration.height / 2 || velocity.y < -1000 {
                    self.expandSheet()
                } else {
                    self.collapseSheet()
                }
                
            }
            
        case .failed:
            if self.state == .full {
                self.expandSheet()
            } else {
                self.collapseSheet()
            }
            
        default: break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
