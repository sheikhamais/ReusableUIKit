//
//  SideMenu.swift
//  
//
//  Created by Amais Sheikh on 09/05/2023.
//

import UIKit

public class SideMenu: UIViewController {
   
    private var backgroundDimView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.backgroundColor = .black.withAlphaComponent(0.4)
        obj.alpha = 0
        return obj
    }()
   
    var contentContainerView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.backgroundColor = .clear
        return obj
    }()
   
    private var safeAreaContentContainerView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.backgroundColor = .clear
        return obj
    }()
   
    private var contentController: UIViewController
   
    init(controller: UIViewController) {
        self.contentController = controller
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut]) {
            self.contentContainerView.transform = .identity
        }
        backgroundDimView.fadeIn(0.2)
    }
   
    private func configureUI() {
       
        //properties
        view.backgroundColor = .clear
       
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        self.backgroundDimView.addGestureRecognizer(dismissGesture)
       
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipedLeft(_:)))
        swipeGesture.direction = .left
        view.addGestureRecognizer(swipeGesture)
       
        let screenWidth = Int.screenBounds.width
        contentContainerView.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
       
        self.addChildByPinning(contentController, toView: safeAreaContentContainerView)
       
        //subviews
        view.addAllSubviews(backgroundDimView,
                            contentContainerView)
       
        contentContainerView.addSubview(safeAreaContentContainerView)
       
        //constraints
        backgroundDimView.pinToSuperview()
        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.82),
           
            safeAreaContentContainerView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            safeAreaContentContainerView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor),
            safeAreaContentContainerView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            safeAreaContentContainerView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor)
        ])
    }
   
    public func show(on parent: UIViewController, completion: (() -> Void)? = nil) {
        parent.present(self, animated: false, completion: completion)
    }
   
    public func hide(completion: (() -> Void)? = nil) {
        self.backgroundDimView.fadeOut(0.1, delay: 0) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) {
                let screenWidth = Int.screenBounds.width
                self.contentContainerView.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
            } completion: { _ in
                self.dismiss(animated: false, completion: completion)
            }
        }
    }
   
    @objc private func didTapBackgroundView() {
        hide()
    }
   
    @objc private func didSwipedLeft(_ sender: UISwipeGestureRecognizer) {
        hide()
    }
}
