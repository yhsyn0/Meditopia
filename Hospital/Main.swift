//
//  Home.swift
//  Hospital
//
//  Created by hsyn on 30.11.2021.
//

import UIKit
import SideMenu

class Main: UIViewController {
    
    var menu: SideMenuNavigationController?
    
    var timer = Timer()
    var i = 0
    var imgArr = [UIImage]()
    var qArr = [UIImage]()
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var homeScrollView: UIScrollView!
    
    @IBAction func homeGreenButton(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imgArr.append(UIImage(named: "sl1")!)
        imgArr.append(UIImage(named: "sl2")!)
        imgArr.append(UIImage(named: "sl3")!)
        imgArr.append(UIImage(named: "sl4")!)
        imgArr.append(UIImage(named: "sl5")!)
        qArr.append(UIImage(named: "q1")!)
        qArr.append(UIImage(named: "q2")!)
        qArr.append(UIImage(named: "q3")!)
        
        pageControl.numberOfPages = imgArr.count
        print(imgArr.count)
        pageControl.currentPage = i
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.gray
        imgView.image = imgArr[0]
        
        var contentWidth:CGFloat = 0.0
        
        for j in 0..<(qArr.count)
        {
            let imView = UIImageView(image: qArr[j])
            let xCoord = homeScrollView.frame.width * CGFloat(j)
            contentWidth += homeScrollView.frame.width
            homeScrollView.addSubview(imView)
            imView.frame = CGRect(x: xCoord, y: 0, width: homeScrollView.frame.size.width, height: homeScrollView.frame.size.height)
            imView.contentMode = .scaleToFill
        }
        //homeScrollView.contentMode = .scaleToFill
        homeScrollView.contentSize = CGSize(width: contentWidth, height: homeScrollView.frame.height)
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changePage), userInfo: nil, repeats: true)
        
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapMenu()
    {
        present(menu!, animated: true)
    }
    
    @objc func changePage()
    {
        i += 1
        if i == imgArr.count
        {
            i = 0
        }
        
        UIView.transition(with: imgView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { self.imgView.image = self.imgArr[self.i] },
                          completion: nil)
        pageControl.currentPage = i
    }
    
    @objc func startTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changePage), userInfo: nil, repeats: true)
    }
    
    @IBAction func pageLeft(_ sender: UIButton)
    {
        i -= 1
        if i == -1
        {
            i = imgArr.count-1
        }
        
        UIView.transition(with: imgView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { self.imgView.image = self.imgArr[self.i] },
                          completion: nil)
        pageControl.currentPage = i
        timer.invalidate()
        startTimer()
        
    }
    @IBAction func pageRight(_ sender: UIButton)
    {
        i += 1
        if i == imgArr.count
        {
            i = 0
        }
        
        UIView.transition(with: imgView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { self.imgView.image = self.imgArr[self.i] },
                          completion: nil)
        pageControl.currentPage = i
        timer.invalidate()
        startTimer()
    }
    
}

class MenuListController: UITableViewController
{
    var items = ["Home", "Doctors", "Appointment", "Support"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        /*
        tableView.backgroundColor = UIColor(red: 33/255.0,
                                            green: 33/255.0,
                                            blue: 33/255.0,
                                            alpha: 0.5)
         */
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "sideBackground")!)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 33/255.0,
                                       green: 33/255.0,
                                       blue: 33/255.0,
                                       alpha: 0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

