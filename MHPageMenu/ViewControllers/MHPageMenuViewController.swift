//
//  MHPageMenuViewController.swift
//  MHPageMenu
//
//  Created by Mahabaleshwar Hegde on 18/09/17.
//  Copyright © 2017 Mahabaleshwar Hegde. All rights reserved.
//

import UIKit



@objc
protocol MHPageMenuViewControllerDelegate: class {
   func pageMenuDidMove(to viewController: UIViewController,  at index: Int)
   @objc optional func pageMenuWillMove(from viewController: UIViewController, at index: Int)
}


@IBDesignable
class MHPageMenuViewController: UIPageViewController {
    
    

    var controllers = [UIViewController] () {
        didSet {
            if self.controllers.count > 0 {
                self.setViewControllers([self.controllers.first!], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    weak var slidingMenuDelegate: MHPageMenuViewControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(notification:)), name: notification.name, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refresh(notification: Notification) {
        
        guard let toBeDisplayViewController = notification.object as? UIViewController else { return  }
        
        guard let currentViewController = self.viewControllers?.first,
            let currentViewControllerIndex = self.controllers.index(where: {$0.title == currentViewController.title }),
            let toBeDisplayViewControllerIndex = self.controllers.index(where: {$0.title == toBeDisplayViewController.title }) else {
            self.setViewControllers([toBeDisplayViewController], direction: .forward, animated: true, completion: nil)
            return
        }
        
        
        var direction: UIPageViewControllerNavigationDirection = .forward
        
        if toBeDisplayViewControllerIndex > currentViewControllerIndex {
            direction = .forward
        } else {
            direction = .reverse
        }
        
        self.setViewControllers([toBeDisplayViewController], direction: direction, animated: true, completion: nil)
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


extension MHPageMenuViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.controllers.index(where: {$0.title == viewController.title }) else { return nil }
        
    
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        if !self.controllers.indices.contains(previousIndex) { return nil }
        let previousController = self.controllers[previousIndex]
        
        return previousController
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
       guard let viewControllerIndex = self.controllers.index(where: {$0.title == viewController.title }) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        if !self.controllers.indices.contains(nextIndex) { return nil }
        
        let nextController = self.controllers[nextIndex]
    
        
        return nextController
    
    }
    
}

extension MHPageMenuViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let toBeDisplayViewController = pageViewController.viewControllers?.first, let index = self.viewControllers!.index(of: toBeDisplayViewController) else { return  }
        self.slidingMenuDelegate?.pageMenuWillMove?(from: toBeDisplayViewController, at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            guard let displayedViewController = pageViewController.viewControllers?.first, let index = self.controllers.index(of: displayedViewController) else { return  }
            
            self.slidingMenuDelegate?.pageMenuDidMove(to: displayedViewController, at: index)
        }
    }
}

