//
//  ViewController.swift
//  HSEBuildings
//
//  Created by Андрей on 09.01.2018.
//  Copyright © 2018 Андрей. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var secondFloorButton: UIButton!
    @IBOutlet weak var firstFloorButton: UIButton!
    @IBOutlet weak var mapScrollView: UIScrollView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    var y = UIImageView()
    var i = 1
    var g = Array<Array<Int>>()
    var gBull = Array<Array<Int>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mapScrollView.isScrollEnabled = true
//        mapScrollView.isUserInteractionEnabled = true
        mapScrollView.contentSize = CGSize(width: 414, height: 533)
        firstFloorButton.isSelected = true
        let NumColumns = 20
        let NumRows = 21
        for _ in 0...NumColumns {
            g.append(Array(repeating:Int(), count:NumRows))
        }
        for i in 0...(NumRows-1) {
            for j in 0...NumColumns{
                if (i != j){
                    g[i][j] = 10000
                }
            }
        }
        gBull = g
        g[0][8] = 19
        g[8][0] = 19
        g[8][9] = 24
        g[9][8] = 24
        g[9][18] = 32
        g[18][9] = 32
        g[9][10] = 5
        g[10][9] = 5
        g[1][10] = 38
        g[10][1] = 38
        g[10][11] = 38
        g[11][10] = 38
        g[2][11] = 38
        g[11][2] = 38
        g[11][12] = 24
        g[12][11] = 24
        g[12][3] = 62
        g[3][12] = 62
        g[12][13] = 9
        g[13][12] = 9
        g[13][4] = 31
        g[4][13] = 31
        g[13][14] = 34
        g[14][13] = 34
        g[14][19] = 31
        g[19][14] = 31
        g[14][15] = 21
        g[15][14] = 21
        g[15][5] = 31
        g[5][15] = 31
        g[15][16] = 28
        g[16][15] = 28
        g[16][20] = 31
        g[20][16] = 31
        g[16][17] = 29
        g[17][16] = 29
        g[17][6] = 31
        g[6][17] = 31
        g[17][7] = 79
        g[7][17] = 79
        print(g)
        
        for i in 0...(NumRows-1) {
            for j in 0...NumColumns{
                if (g[i][j] != 0 && g[i][j] != 10000){
                    gBull[i][j] = 1
                }else{
                    gBull[i][j] = 0
                }
            }
        }
        print(gBull)
        
        addLine(x1: 91, y1: 122, wid: 31, hei: 5,tag: 12301)
        addLine(x1: 122, y1: 122, wid: 5, hei: 5, tag: 1200)
        addLine(x1: 127, y1: 122, wid: 9, hei: 5, tag: 1312)
        addLine(x1: 136, y1: 122, wid: 5, hei: 5, tag: 1300)
        addLine(x1: 141, y1: 122, wid: 34, hei: 5, tag: 1413)
        addLine(x1: 175, y1: 122, wid: 5, hei: 5, tag: 1400)
        addLine(x1: 180, y1: 122, wid: 21, hei: 5, tag: 1514)
        addLine(x1: 201, y1: 122, wid: 5, hei: 5, tag: 1500)
        addLine(x1: 206, y1: 122, wid: 28, hei: 5, tag: 1615)
        addLine(x1: 234, y1: 122, wid: 5, hei: 5, tag: 1600)
        addLine(x1: 239, y1: 122, wid: 29, hei: 5, tag: 1716)
        addLine(x1: 268, y1: 122, wid: 5, hei: 5, tag: 1700)
        addLine(x1: 273, y1: 122, wid: 48, hei: 5, tag: 71702)

        addLine(x1: 91, y1: 91, wid: 5, hei: 31, tag: 12302)
        addLine(x1: 136, y1: 91, wid: 5, hei: 31, tag: 134)
        addLine(x1: 201, y1: 91, wid: 5, hei: 31, tag: 155)
        addLine(x1: 268, y1: 91, wid: 5, hei: 31, tag: 176)
        addLine(x1: 316, y1: 91, wid: 5, hei: 31, tag: 71701)
        addLine(x1: 175, y1: 127, wid: 5, hei: 31,tag: 1419)
        addLine(x1: 234, y1: 127, wid: 5, hei: 31, tag: 1620)

        addLine(x1: 122, y1: 127, wid: 5, hei: 24, tag: 1211)
        addLine(x1: 122, y1: 151, wid: 5, hei: 5, tag: 1100)
        addLine(x1: 122, y1: 156, wid: 5, hei: 38, tag: 1110)
        addLine(x1: 122, y1: 194, wid: 5, hei: 5, tag: 1000)
        addLine(x1: 122, y1: 199, wid: 5, hei: 5, tag: 109)
        addLine(x1: 122, y1: 204, wid: 5, hei: 5, tag: 900)
        addLine(x1: 122, y1: 209, wid: 5, hei: 24, tag: 98)
        addLine(x1: 122, y1: 233, wid: 5, hei: 5, tag: 800)

        addLine(x1: 84, y1: 151, wid: 38, hei: 5, tag: 112)
        addLine(x1: 84, y1: 194, wid: 38, hei: 5, tag: 101)
        addLine(x1: 127, y1: 204, wid: 32, hei: 5, tag: 918)
        addLine(x1: 103, y1: 233, wid: 19, hei: 5, tag: 80)
        
        
        
        
//        addCircle(x1: 88, y1: 86)
//        addCircle(x1: 133, y1: 86)
//        addCircle(x1: 198, y1: 86)
//        addCircle(x1: 265, y1: 86)
//        addCircle(x1: 313, y1: 86)
//        addCircle(x1: 322, y1: 127)
//        addCircle(x1: 322, y1: 202)
//        addCircle(x1: 322, y1: 274)
//        addCircle(x1: 313, y1: 320)
//        addCircle(x1: 266, y1: 320)
//        addCircle(x1: 198, y1: 320)
//        addCircle(x1: 133, y1: 320)
//        addCircle(x1: 88, y1: 320)
//        addCircle(x1: 79, y1: 267)
//        addCircle(x1: 79, y1: 192)
//        addCircle(x1: 79, y1: 149)
//        addCircle(x1: 232, y1: 154)
//        addCircle(x1: 173, y1: 154)
//        addCircle(x1: 154, y1: 202)
//        addCircle(x1: 249, y1: 199)
        
        
        
        
        addCircle(x1: 79, y1: 192)
        addCircle(x1: 79, y1: 149)
        addCircle(x1: 88, y1: 86)
        addCircle(x1: 133, y1: 86)
        addCircle(x1: 198, y1: 86)
        addCircle(x1: 265, y1: 86)
        addCircle(x1: 313, y1: 86)
        addCircle(x1: 154, y1: 202)
        addCircle(x1: 173, y1: 154)
        addCircle(x1: 232, y1: 154)
        
        
        
        mapScrollView.delegate = self
        mapScrollView.minimumZoomScale = self.view.frame.width/414
        mapScrollView.maximumZoomScale = 1.5
        mapScrollView.zoomScale = 1.0
//        mapScrollView.zoomScale = 0.8
    }
    @IBAction func showTheWay(_ sender: UIButton) {

        self.view.endEditing(true)
        for val in y.subviews{
                (val as! UIImageView).tintColor = UIColor.lightGray
        }
        for v in y.subviews{
            if ((Int(fromTextField.text!) == v.tag) || (Int(toTextField.text!) == v.tag)){
                (v as! UIImageView).tintColor = UIColor.orange
            }
        }
        var t = Array<Int>()
        for i in 1...21{
            for j in 0...20{
                for k in 0...20{
                    if (g[j][k] > g[j][i - 1] + g[i - 1][k]){
                        g[j][k] = g[j][i - 1] + g[i - 1][k]
                    }
                }
            }
        }
        


        
        var res = Array<Int>()
        var u = Int(toTextField.text!)!
        res.append(u)
        for j in 1...21{
            for i in 0...20{
                if (gBull[i][u] == 1){
                    if (g[Int(fromTextField.text!)!][u] - g[i][u] == g[Int(fromTextField.text!)!][i]){
                        res.append(i)
                        u = i
                        break
                    }
                }
            }
        }
        print(res)
        
        for i in 0...(res.count-2){
            var hg = -1000
            var hg2 = -1000
            if (res[i]<10 && res[i+1]<10){
                if(res[i+1] != 0 && res[i] != 0){
                    hg = res[i+1]*10 + res[i]
                    hg2 = res[i]*10 + res[i+1]
                }else{
                    if( res[i+1] == 0){
                        hg = res[i]*10 + res[i+1]
                    }else{
                        hg = res[i+1]*10 + res[i]
                    }
                }
            }
            if (res[i]<10 && res[i+1]>9){
                if((res[i] != 7 && res[i+1] != 17) && (res[i] != 17 && res[i+1] != 7) && (res[i] != 12 && res[i+1] != 3) && (res[i] != 3 && res[i+1] != 12)){
                    
                    hg = res[i+1]*10 + res[i]
                    hg2 = res[i]*100 + res[i+1]
                    
                }else{
                    if(res[i] == 7 && res[i+1] == 17){
                        hg = (res[i]*100 + res[i+1])*100 + 1
                        hg2 = (res[i]*100 + res[i+1])*100 + 2
                    }
                    if(res[i] == 17 && res[i+1] == 7){
                        hg = (res[i+1]*100 + res[i])*100 + 1
                        hg2 = (res[i+1]*100 + res[i])*100 + 2
                    }
                    if(res[i] == 3 && res[i+1] == 12){
                        hg = (res[i+1]*10 + res[i])*100 + 1
                        hg2 = (res[i+1]*10 + res[i])*100 + 2
                    }
                    if(res[i] == 12 && res[i+1] == 3){
                        hg = (res[i]*10 + res[i+1])*100 + 1
                        hg2 = (res[i]*10 + res[i+1])*100 + 2
                    }
                    if((res[i] == 17 && res[i+1] != 7) || (res[i] != 7 && res[i+1] == 17)){
                        hg = res[i+1]*10 + res[i]
                        hg2 = res[i]*100 + res[i+1]
                        print(hg)
                        print(hg2)
                    }
                }
            }
            if (res[i]>9 && res[i+1]<10){
                if((res[i] != 7 && res[i+1] != 17) && (res[i] != 17 && res[i+1] != 7) && (res[i] != 12 && res[i+1] != 3) && (res[i] != 3 && res[i+1] != 12)){
                    
                hg = res[i+1]*100 + res[i]
                hg2 = res[i]*10 + res[i+1]
                    
                }else{
                    if(res[i] == 7 && res[i+1] == 17){
                        hg = (res[i]*100 + res[i+1])*100 + 1
                        hg2 = (res[i]*100 + res[i+1])*100 + 2
                    }
                    if(res[i] == 17 && res[i+1] == 7){
                        hg = (res[i+1]*100 + res[i])*100 + 1
                        hg2 = (res[i+1]*100 + res[i])*100 + 2
                    }
                    if(res[i] == 3 && res[i+1] == 12){
                        hg = (res[i+1]*10 + res[i])*100 + 1
                        hg2 = (res[i+1]*10 + res[i])*100 + 2
                    }
                    if(res[i] == 12 && res[i+1] == 3){
                        hg = (res[i]*10 + res[i+1])*100 + 1
                        hg2 = (res[i]*10 + res[i+1])*100 + 2
                    }
                    if((res[i] == 17 && res[i+1] != 7) || (res[i] != 7 && res[i+1] == 17)){
                        hg = res[i+1]*100 + res[i]
                        hg2 = res[i]*10 + res[i+1]
                    }
                }
            }
            if (res[i]>9 && res[i+1]>9){
                hg = res[i+1]*100 + res[i]
                hg2 = res[i]*100 + res[i+1]
            }
            
            for val in y.subviews{
                if ((hg == val.tag) || (hg2 == val.tag)){
                    (val as! UIImageView).tintColor = UIColor.green
                }
            }
            
            for i in 1...(res.count-2){
                for val in y.subviews{
                    if ((res[i]*100 == val.tag)){
                        (val as! UIImageView).tintColor = UIColor.green
                    }
                }
            }
        }
    }
    
    @IBAction func firstFloorButtonAction(_ sender: UIButton) {
        firstFloorButton.isSelected = true
        secondFloorButton.isSelected = false
        y.image = UIImage(named:"3")
    }
    @IBAction func secondFloorButtonAction(_ sender: UIButton) {
        firstFloorButton.isSelected = false
        secondFloorButton.isSelected = true
        y.image = UIImage(named:"1")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
//        y.frame = CGRect(x: 0, y: (self.mapScrollView.frame.height - self.mapScrollView.frame.width)/2, width: self.mapScrollView.frame.width, height: self.mapScrollView.frame.width )
        y.frame = CGRect(x: 0, y: 30, width: 414, height: 414 )
        y.image = UIImage(named:"3")
        y.contentMode = .scaleAspectFit
        y.tag = 111111
        mapScrollView.addSubview(y)
        let c = self.view.frame.width/414
        mapScrollView.setZoomScale(c, animated: false)
    }

    func addCircle(x1:Int,y1:Int){
        let w = UIImageView(frame: CGRect(x: x1, y: y1, width: 10, height: 10))
        w.image = UIImage(named:"circle")?.withRenderingMode(.alwaysTemplate)
        w.contentMode = .scaleAspectFit
        if (i<8){
            w.tag = i
        }else{
            w.tag = i+10
        }
        i+=1
        w.tintColor = UIColor.lightGray
        y.addSubview(w)
    }
    func addLine(x1:Int,y1:Int,wid:Int,hei:Int, tag:Int){
        let w = UIImageView(frame: CGRect(x: x1, y: y1, width: wid, height: hei))
        w.image = UIImage(named:"square")?.withRenderingMode(.alwaysTemplate)
        w.contentMode = .scaleToFill
        w.tag = tag
        w.tintColor = UIColor.lightGray
        y.addSubview(w)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.y
    }

}

