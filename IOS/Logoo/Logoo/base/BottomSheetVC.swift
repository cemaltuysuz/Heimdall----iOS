//
//  BottomSheetVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 4.04.2022.
//

import Foundation
import UIKit

class BottomSheetVC: UIViewController {
    
    
    // last layer (BottomSheet)
    lazy var container : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // second layer
    lazy var curtain: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = curtainAlpha
        return view
    }()
    
    var curtainAlpha:CGFloat = 0.6
    var animDurarion:CGFloat = 0.4
    
    var defaultHeight:CGFloat = 300
    var maxHeight:CGFloat!
    var minHeight:CGFloat!
    var currentHeight:CGFloat!
        
    
    // Constraints
    var containerViewHeightConstraint:NSLayoutConstraint?
    var containerViewBottomConstraint:NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        calculateConstraints()
        setupUI()
        setupConstraints()
        setupGestures()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateShowCurtain()
        animatePresentContainer()
    }
    
    func calculateConstraints(){
        // Ekran boyutunun %50 lık uzunkuğunu default olarak ayarladım.
        self.defaultHeight = view.frame.height * (1/2)
        self.currentHeight = defaultHeight
        self.maxHeight = view.frame.height - 50
        self.minHeight = view.frame.height * (2/5)
    }
    
    func setupUI(){
        view.backgroundColor = .clear
        
    }
    
    func setupGestures(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.curtainOnClick))
        curtain.addGestureRecognizer(tapRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.containerOnSwipe(gesture:)))
        panRecognizer.delaysTouchesBegan = false
        panRecognizer.delaysTouchesEnded = false
        container.addGestureRecognizer(panRecognizer)
    }
    
    func setupConstraints(){
        
        view.addSubview(curtain)
        view.addSubview(container)
        curtain.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        

        
        NSLayoutConstraint.activate([
            // Set Curtain's Constraints
            curtain.topAnchor.constraint(equalTo: view.topAnchor),
            curtain.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            curtain.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            curtain.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // Set container's constraints with dynamicly (only left and rigth)
            container.leadingAnchor.constraint(equalTo: curtain.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: curtain.trailingAnchor)
        ])
        
        // Set Constraint default height
        containerViewHeightConstraint =  container.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint =  container.bottomAnchor.constraint(equalTo: curtain.bottomAnchor, constant: 0)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
    }
    // Recognizers
    
    @objc
    func curtainOnClick(){
        animateDismissView()
    }
    
    @objc
    func containerOnSwipe(gesture:UIPanGestureRecognizer){
        let translation = gesture.translation(in: view)

        // Kullanıcı parmağını aşağıya doğru mu kaydırıyor ?
        let isDraggingDown = translation.y > 0
        
        // yeni uzunluk = sayfanın o anki uzunluğunun kaydırılan mesafeden çıkarılmış hali.
        let newHeight = currentHeight - translation.y
        

        switch gesture.state {
            
        // Kullanıcı kaydırma yaparken bizde containeri kaydırıyoruz. Böylelikle kullanıcı bir nevi
        // Containeri kendisi taşıyormuş gibi hissediyor.
        case .changed:
            if newHeight < maxHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        // Kullanıcı kaydırmayı bitirdiği zaman containerin hangi uzunlukta kaldığına göre
        // değişiklikleri gerçekleştireceğiz.
        case .ended:

            // minimum büyüklüğün altındaysa dismiss et.
            if newHeight < minHeight {
                self.animateDismissView()
            }
            // default heigth in altinda ise eski haline geri getir.
            else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            }
            // yeni yükselik max ın altında ise ve en son aşağı indiriliyorduysa default.
            else if newHeight < maxHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            }
            // yeni büyüklük def büyüklükten büyük ve en son yukarı çıkartılıyorduysa max.
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maxHeight)
            }
        default:
            break
        }
    }
    
    // anims
    
    // Curtain is visible
    func animateShowCurtain() {
        curtain.alpha = 0
        UIView.animate(withDuration: curtainAlpha) {
            self.curtain.alpha = self.curtainAlpha
        }
    }
    
    // container is visible
    func animatePresentContainer() {
        UIView.animate(withDuration: animDurarion) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // Hide Container and Curtain views
    func animateDismissView() {
        // hide main container view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        
        // hide blur view
        curtain.alpha = curtainAlpha
        UIView.animate(withDuration: 0.4) {
            self.curtain.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false) // close
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentHeight = height
    }
}
