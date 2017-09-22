//
//  TabOneViewController.swift
//  MHPageMenu
//
//  Created by Mahabaleshwar Hegde on 19/09/17.
//  Copyright © 2017 Mahabaleshwar Hegde. All rights reserved.
//

import UIKit

let notification = Notification.init(name: Notification.Name(rawValue: "didChangeMenu"))

class TabOneViewController: UIViewController, UICollectionViewDataSource {
    
    let identifier = String(describing: TopMenuCollectionViewCell.self)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var highlightedView = UIView()
    var flowLayout: UICollectionViewFlowLayout!
    
    var controllers: [UIViewController]  {
        
        get {
            let blueViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: BlueViewController.self))
            let redViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: RedViewController.self))
            let greenViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: GreenViewController.self))
            let grayViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: GrayViewController.self))
            let pagedmo = self.storyboard?.instantiateViewController(withIdentifier: String(describing: PageDemoViewController.self))
            let buttonAction = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ViewController.self))
            let instructions = self.storyboard?.instantiateViewController(withIdentifier: String(describing: InstructionsViewController.self))
            let navigationDemo = self.storyboard?.instantiateViewController(withIdentifier: "NavigationDemoViewControllerNC")
            
            
            let _controllers =  [blueViewController!, redViewController!, greenViewController!, grayViewController!, pagedmo!, buttonAction!, instructions!, navigationDemo!]
            return  _controllers
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: identifier, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        
        self.collectionView.dataSource = self
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 100.0, height: 48.0)
            self.flowLayout = flowLayout
           self.collectionView.reloadData()
        }

        let frame = CGRect(x: 0.0, y: self.collectionView.bounds.height - 3.0, width: flowLayout.itemSize.width, height: 3.0)
        self.highlightedView = UIView(frame: frame)
        self.highlightedView.backgroundColor = .blue
        
        self.collectionView.addSubview(self.highlightedView)
              
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        if self.controllers.count > 0 {
            let firstIndexPath  = IndexPath(row: 0, section: 0)
            guard let firstCell = self.collectionView.cellForItem(at: firstIndexPath) else {
                return
            }
            self.highlightedView.frame.size.width = firstCell.frame.width
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.addBorder(borderPostion: .bottom, borderColor: UIColor.blue.withAlphaComponent(0.12), borderWidth: 0.5)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! MHPageMenuViewController
        destination.slidingMenuDelegate = self
        destination.controllers = self.controllers
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension TabOneViewController  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.controllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TopMenuCollectionViewCell
        cell.menuLabel.text = self.controllers[indexPath.row].title
        return cell
    }
}


extension TabOneViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let controller = self.controllers[indexPath.row]
    
        self.setHighlightedView(at: indexPath)
        
        NotificationCenter.default.post(name: notification.name, object: controller)
        
    }
}


extension TabOneViewController: MHPageMenuViewControllerDelegate {
    
    func pageMenuDidMove(to viewController: UIViewController, at index: Int) {
       
        let indexPath = IndexPath(row: index, section: 0)
        self.setHighlightedView(at: indexPath)
    }
    
    func pageMenuWillMove(from viewController: UIViewController, at index: Int) {
        
    }
    
    func setHighlightedView(at indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        if cell.frame.maxX > self.collectionView.frame.size.width {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: false)
        }
        UIView.animate(withDuration: 0.3) {
            self.highlightedView.frame.origin.x = cell.frame.origin.x
            self.highlightedView.frame.size.width = cell.frame.size.width
        }
    }
    
}
