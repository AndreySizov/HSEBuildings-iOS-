//
//  ViewController.swift
//  HSEBuildings
//
//  Created by Андрей on 09.01.2018.
//  Copyright © 2018 Андрей. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var secondFloorButton: UIButton!
    @IBOutlet weak var firstFloorButton: UIButton!
    @IBOutlet weak var mapScrollView: UIScrollView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    var y = UIImageView()
    var i = 1
    var g = Array<Array<Int>>()
    var gBull = Array<Array<Int>>()
    var helpTableView = UITableView()
    var dictionaryCount = 1
//    var keyboardSize:CGRect?
    var numberOfPoints = 39
    var arrayOfPoints = Array<String>()
    var arrayOfPointsToShow = Array<String>()
    var arrayFromJson = Array<Any>()
    var dictionaryOfPointsFromJson = [Int:CGPoint]()
    var dictionaryOfPoints = ["Вход/Выход":0,
                              "Диспетчерская":23,
                              "Лестница №1":24,
                              "Лестница №2":25,
                              "Лифт №1":28,
                              "Лифт №2":26,
                              "Лифт №3":27,
                              "Лифт №4":29,
                              "Лифт №5":32,
                              "Лифт №6":33,
                              "Туалет женский":30,
                              "Туалет мужской":31,
                              "Камера хранения":34,
                              "Библиотека":35,
                              "Гардероб":36,
                              "Киоск":37,
                              "Пост охраны":38]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromTextField.delegate = self
        toTextField.delegate = self
        arrayOfPoints = Array(dictionaryOfPoints.keys)
        
//        временная подмена переменной, пока не сделаны все этажи
        arrayOfPointsToShow = arrayOfPoints
        arrayOfPointsToShow.append("2-ой этаж")
        
        
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        fromTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
//        mapScrollView.isScrollEnabled = true
//        mapScrollView.isUserInteractionEnabled = true
//        mapScrollView.contentSize = CGSize(width: 414, height: 533)
        mapScrollView.contentSize = CGSize(width: 5000, height: 5000)

        firstFloorButton.isSelected = true

//        заполнение матрицы нулями
        for _ in 0...(numberOfPoints-1) {
            g.append(Array(repeating:Int(), count:numberOfPoints))
        }
//        заполнение матрицы недосягаемыми для алгоритма значениями = 1000000
        for i in 0...(numberOfPoints-1) {
            for j in 0...(numberOfPoints-1){
                if (i != j){
                    g[i][j] = 1000000
                }
            }
        }
        
//        gBull - бинарная матрица, где 1 означает связь, а 0 - отсутствие связи
        gBull = g

//        отрисовка путей первого этажа
        createMapForTheFirstFloor()
        
//        заполнение основной матрицы длинами линий между точками (зеркально относительно главной диагонали)
        for v in y.subviews{
            if let resId = v.restorationIdentifier{
                let splitArr = resId.split(separator: "_")
                if(Int(v.frame.size.height) != 30){
                    g[Int(splitArr[0])!][Int(splitArr[1])!] = Int(v.frame.size.height)
                    g[Int(splitArr[1])!][Int(splitArr[0])!] = Int(v.frame.size.height)
                }else{
                    g[Int(splitArr[0])!][Int(splitArr[1])!] = Int(v.frame.size.width)
                    g[Int(splitArr[1])!][Int(splitArr[0])!] = Int(v.frame.size.width)
                }
            }
        }
//        print(g)
        
        
        
//        заполнение бинарной матрицы конечными значениями
        for i in 0...(numberOfPoints-1) {
            for j in 0...(numberOfPoints-1){
                if (g[i][j] != 0 && g[i][j] != 1000000){
                    gBull[i][j] = 1
                }else{
                    gBull[i][j] = 0
                }
            }
        }
//        print(gBull)
        
        
        
//        подготовка матрицы к передаче в алгоритм
        for i in 1...numberOfPoints{
            for j in 0...(numberOfPoints-1){
                for k in 0...(numberOfPoints-1){
                    if (g[j][k] > g[j][i - 1] + g[i - 1][k]){
                        g[j][k] = g[j][i - 1] + g[i - 1][k]
                    }
                }
            }
        }
        
        
        mapScrollView.delegate = self
        mapScrollView.minimumZoomScale = self.view.frame.width/(UIImage(named:"1_этаж")?.size.width)!
        mapScrollView.maximumZoomScale = 1.0
        mapScrollView.zoomScale = 1.0

    }
    
    
    
    @IBAction func showTheWay(_ sender: UIButton) {

        self.view.endEditing(true)

//        очищение предыдущего маршрута с карты
        for v in y.subviews{
            if(v is UIImageView){
                (v as! UIImageView).tintColor = UIColor.clear
            }else{
                v.backgroundColor = UIColor.clear
            }
        }
        
        
//      многочисленные проверки с вылетающими алертами
        if(toTextField.text == nil){
            showAlertWithMessage(message: "В поле 'От' не указан никакой объект")
        }else if(toTextField.text == nil){
            showAlertWithMessage(message: "В поле 'До' не указан никакой объект")
        }else if(toTextField.text! == fromTextField.text!){
            showAlertWithMessage(message: "В полях 'От' и 'До' не может быть указан один и тот же объект")
        }else{
        
            if(fromTextField.text! == "2-ой этаж"){
                var from:Int!
                if(toTextField.text! == "Лифт №3"){
                    from = dictionaryOfPoints["Лифт №4"]
                }else{
                    from = dictionaryOfPoints["Лифт №3"]
                }
                if var to = dictionaryOfPoints[toTextField.text!]{
                    
//       передача номеров точек От и До в алгоритм и получение массива точек маршрута в обратном порядке
                    var res = algorithmDijkstra(from: from!, tot: to)
                    
//       отрисовка полученного маршрута по точкам
                    paintTheWay(res: res)
                    
                }else{
                    showAlertWithMessage(message: "В поле 'До' допущена ошибка или такого объекта не существует. Проверьте написание и попробуйте построить маршрут еще раз.")
                }
                
                
//       2-ой этаж - это пока заглушка. Смысл в том, чтоб показать, что при необходимости подъема на этажи алгоритм на первом этаже ищет ближайший подъем (лифт или лестницу). После нахождения ближайшего лифта подсвечиваются все лифты, которые находятся в непосредственной близости.
            }else if(toTextField.text! == "2-ой этаж"){
                
                    if var from = dictionaryOfPoints[fromTextField.text!]{
                        
                    var arrayOfRes = Array<Array<Int>>()
                        arrayOfRes.append(algorithmDijkstra(from: from, tot: dictionaryOfPoints["Лифт №1"]!))
                        arrayOfRes.append(algorithmDijkstra(from: from, tot: dictionaryOfPoints["Лифт №2"]!))
                        arrayOfRes.append(algorithmDijkstra(from: from, tot: dictionaryOfPoints["Лифт №3"]!))
                        arrayOfRes.append(algorithmDijkstra(from: from, tot: dictionaryOfPoints["Лифт №4"]!))
                        arrayOfRes.append(algorithmDijkstra(from: from, tot: dictionaryOfPoints["Лифт №5"]!))
                        arrayOfRes.append(algorithmDijkstra(from: from, tot: dictionaryOfPoints["Лифт №6"]!))
                        arrayOfRes.append(algorithmDijkstra(from: from, tot: dictionaryOfPoints["Лестница №1"]!))
                        arrayOfRes.append(algorithmDijkstra(from: from, tot: dictionaryOfPoints["Лестница №2"]!))
                        
                        var way = findTheShortestArray(allArrays: arrayOfRes)
                        print(way)
                        if(way[0] == 26)||(way[0] == 27)||(way[0] == 28)||(way[0] == 29){
                            let res1 = algorithmDijkstra(from: from, tot: 26)
                            paintTheWay(res: res1)
                            let res2 = algorithmDijkstra(from: from, tot: 27)
                            paintTheWay(res: res2)
                            let res3 = algorithmDijkstra(from: from, tot: 28)
                            paintTheWay(res: res3)
                            let res4 = algorithmDijkstra(from: from, tot: 29)
                            paintTheWay(res: res4)
                        }else if(way[0] == 32)||(way[0] == 33){
                            let res5 = algorithmDijkstra(from: from, tot: 32)
                            paintTheWay(res: res5)
                            let res6 = algorithmDijkstra(from: from, tot: 33)
                            paintTheWay(res: res6)
                        }else{
                            paintTheWay(res: way)
                        }
                        
//                        var res = algorithmDijkstra(from: from, tot: to)
//                        paintTheWay(res: res)
                        
                    }else{
                        showAlertWithMessage(message: "В поле 'От' допущена ошибка или такого объекта не существует. Проверьте написание и попробуйте построить маршрут еще раз.")
                    }

                
            }else{
                if var to = dictionaryOfPoints[toTextField.text!]{
                    if var from = dictionaryOfPoints[fromTextField.text!]{
                        
                        var res = algorithmDijkstra(from: from, tot: to)
                        paintTheWay(res: res)
                        
                    }else{
                        showAlertWithMessage(message: "В поле 'От' допущена ошибка или такого объекта не существует. Проверьте написание и попробуйте построить маршрут еще раз.")
                    }
                }else{
                    showAlertWithMessage(message: "В поле 'До' допущена ошибка или такого объекта не существует. Проверьте написание и попробуйте построить маршрут еще раз.")
                }
            }
        }
        
    }
    
// алгоритм
    func algorithmDijkstra(from:Int, tot:Int) -> Array<Int>{
        var to = tot
        var res = Array<Int>()
        res.append(to)
        for j in 1...numberOfPoints{
            for i in 0...(numberOfPoints-1){
                if (gBull[i][to] == 1){
                    if (g[from][to] - g[i][to] == g[from][i]){
                        res.append(i)
                        to = i
                        break
                    }
                }
            }
        }
        print(res)
        return res
    }
    
//   отрисовка маршрута в цвете
    func paintTheWay(res:Array<Int>){
        
        for v in y.subviews{
            if(v.restorationIdentifier == nil){
                
                if (v.tag == res[0]){
                    if(v is UIImageView){
                        (v as! UIImageView).tintColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 0.2)
                    }else{
                        (v as! UIView).backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 0.2)
                    }
                }else if(v.tag == res[res.count-1]){
                    if(v is UIImageView){
                        (v as! UIImageView).tintColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.2)
                    }else{
                        (v as! UIView).backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.2)
                    }
                }
            }
            
            for t in 1...(res.count-1){
                if(((v.tag == res[t])&&(v.tag != res[res.count-1]))||(v.restorationIdentifier == "\(res[t-1])_\(res[t])")||(v.restorationIdentifier == "\(res[t])_\(res[t-1])")){
                    if(v is UIImageView){
                        (v as! UIImageView).tintColor = UIColor.red
                    }else{
                        (v as! UIView).backgroundColor = UIColor.red
                    }
                }
            }
        }
        
    }
    
//    нахождение пути до ближайшего подъема: лифта или лестницы
    func findTheShortestArray(allArrays:Array<Array<Int>>) -> Array<Int>{
        var i = 0
        var length = 0
        var num = 0
        for res in allArrays{
            var q = 0
                for v in y.subviews{
                    for t in 1...(res.count-1){
                        if((v.restorationIdentifier == "\(res[t-1])_\(res[t])")||(v.restorationIdentifier == "\(res[t])_\(res[t-1])")){
                            if(v.frame.size.height != 30){
                                q += Int(v.frame.size.height)
                            }else{
                                q += Int(v.frame.size.width)
                            }
                            
                        }
                    }
            }
            if(i==0){
                length = q
            }
            if(q<length){
                length = q
                num = i
            }
            i+=1
        }
        return allArrays[num]
    }
    
//  кнопка первого этажа
    @IBAction func firstFloorButtonAction(_ sender: UIButton) {
        firstFloorButton.isSelected = true
        secondFloorButton.isSelected = false
        y.image = UIImage(named:"1_этаж")
        createMapForTheFirstFloor()
    }
//    кнопка второго этажа
    @IBAction func secondFloorButtonAction(_ sender: UIButton) {
        firstFloorButton.isSelected = false
        secondFloorButton.isSelected = true
        for v in y.subviews{
            v.removeFromSuperview()
        }
        y.image = UIImage(named:"2_этаж")
      
        //чтение тестового файла json
        readJson(name: "test")
        print(arrayFromJson)

        //отрисовка линий из прочитанного json файла с параллельным запоминанием точек в словарь
        createLinesFromJson()
        
        print(dictionaryOfPointsFromJson)
        
        //отрисовка точек из заполненного словаря по линиям из json файла
        createPointsFromJson()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        y.frame = CGRect(x: 0, y: 30, width: (UIImage(named:"1_этаж")?.size.width)!, height: (UIImage(named:"1_этаж")?.size.height)! )
        y.image = UIImage(named:"1_этаж")
        y.contentMode = .scaleAspectFit
        y.tag = 111111
        mapScrollView.addSubview(y)
        let c = self.view.frame.width/(UIImage(named:"1_этаж")?.size.width)!
        mapScrollView.setZoomScale(c, animated: false)
    }
    

    func showAlertWithMessage(message:String){
        let alert = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
//  добавление промежуточных точек
    func addIntermediatePoint(x1:Int,y1:Int,wid:Int,hei:Int, tag:Int){
        let w = UIView(frame: CGRect(x: x1, y: y1, width: wid, height: hei))
        w.layer.cornerRadius = w.frame.size.width/2
        w.tag = tag
        w.backgroundColor = UIColor.clear
        y.addSubview(w)
    }
    
//    добавление линий
    func addLine(x1:Int,y1:Int,wid:Int,hei:Int, resId:String){
        let w = UIView(frame: CGRect(x: x1, y: y1, width: wid, height: hei))
        w.restorationIdentifier = resId
        w.backgroundColor = UIColor.clear
        y.addSubview(w)
    }
    
//   добавление повернутых линий
    func addRotatedLine(x1:Int,y1:Int,wid:Int,hei:Int,angle:CGFloat, resId:String){
        let w = UIView(frame: CGRect(x: x1, y: y1, width: wid, height: hei))
        w.restorationIdentifier = resId
        w.backgroundColor = UIColor.clear
        setAnchorPoint(anchorPoint: CGPoint(x: 0, y: 0), view: w)
        w.transform = CGAffineTransform(rotationAngle: (CGFloat(Double.pi)/180.0) * angle)
        y.addSubview(w)
    }
    
//    добавление точек нестандартной формы. Такие точки добавляются в виде картинок - вырезок из плана этажа
    func addPicturePoint(x1:Int,y1:Int,wid:Int,hei:Int, tag:Int, image: UIImage){
        let w = UIImageView(frame: CGRect(x: x1, y: y1, width: wid, height: hei))
        w.image = image.withRenderingMode(.alwaysTemplate)
        w.contentMode = .scaleAspectFit
        w.tag = tag
        w.tintColor = UIColor.clear
        y.addSubview(w)
    }
    
//    добавление точек обычной 4-ех угольной формы
    func addViewPoint(x1:Int,y1:Int,wid:Int,hei:Int, tag:Int){
        let w = UIView(frame: CGRect(x: x1, y: y1, width: wid, height: hei))
        w.tag = tag
        w.backgroundColor = UIColor.clear
        y.addSubview(w)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.y
    }

//    задание опорной точки вращения линии
    func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position : CGPoint = view.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
    }
    
    
//    задел на будущее для автоматического предложения похожих вариантов из базы при добавлении каждой новой буквы
    @objc func textFieldDidChange(textField : UITextField){
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        let w = UIView()

        if(textField.restorationIdentifier == "textFieldFrom"){
            w.frame = CGRect(x: textField.frame.origin.x, y: textField.frame.origin.y + textField.frame.size.height, width: textField.frame.size.width, height: 200)
        }else{
            w.frame = CGRect(x: textField.frame.origin.x, y: textField.frame.origin.y + textField.frame.size.height, width: textField.frame.size.width, height: 200)

        }
        w.layer.cornerRadius = 5
        w.layer.borderWidth = 0.5
        w.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha:1).cgColor
        w.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        
//        таблица с подсказками объектов, которые можно внести в поле
        self.helpTableView.frame = CGRect(x: 0, y: 0, width: w.frame.size.width, height: w.frame.size.height)
        helpTableView.register(UITableViewCell.self, forCellReuseIdentifier: "helpCell")
        helpTableView.dataSource = self
        helpTableView.delegate = self
        helpTableView.backgroundColor = UIColor.clear
        w.addSubview(helpTableView)
        w.restorationIdentifier = "helpTableView"
        self.view.addSubview(w)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        for v in self.view.subviews{
            if(v.restorationIdentifier == "helpTableView"){
                v.removeFromSuperview()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPointsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "helpCell", for: indexPath as IndexPath)
        cell.backgroundColor = UIColor.clear
//        if(dictionaryCount <= dictionaryOfPoints.count){
            cell.textLabel!.text = "\(arrayOfPointsToShow[indexPath.row])"
//            dictionaryCount += 1
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(fromTextField.isEditing){
            fromTextField.text = "\(arrayOfPointsToShow[indexPath.row])"
        }else{
            toTextField.text = "\(arrayOfPointsToShow[indexPath.row])"
        }
        self.view.endEditing(true)
    }
    
//    закртытие клавиатуры и исчезновение таблицы подсказок после нажатия Ввода на клаве
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
//    @objc func keyboardWillShow(sender: NSNotification) {
//        keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//    }
    
    
//    отрисовка линий первого этажа
    func createMapForTheFirstFloor(){
    
        
        //   конечные точки
        addPicturePoint(x1: 2577, y1: 2388, wid: 2057, hei: 1402, tag: 35, image: UIImage(named:"library")!)
        addPicturePoint(x1: 1050, y1: 3210, wid: 1509, hei: 585, tag: 36, image: UIImage(named:"cloakroom")!)
        addPicturePoint(x1: 1050, y1: 3070, wid: 276, hei: 342, tag: 37, image: UIImage(named:"kiosk")!)
        addViewPoint(x1: 865, y1: 2605, wid: 182, hei: 235, tag: 38)
        addPicturePoint(x1: 463, y1: 1973, wid: 618, hei: 868, tag: 0, image: UIImage(named:"enter")!)
        addPicturePoint(x1: 683, y1: 702, wid: 390, hei: 665, tag: 23, image: UIImage(named:"controller's_office")!)
        addPicturePoint(x1: 1090, y1: 1340, wid: 299, hei: 610, tag: 24, image: UIImage(named:"stairs1")!)
        addPicturePoint(x1: 4327, y1: 1330, wid: 288, hei: 610, tag: 25, image: UIImage(named:"stairs2")!)
        addViewPoint(x1: 1459, y1: 1694, wid: 216, hei: 192, tag: 28)
        addViewPoint(x1: 1463, y1: 1446, wid: 217, hei: 200, tag: 26)
        addViewPoint(x1: 2030, y1: 1358, wid: 237, hei: 285, tag: 27)
        addViewPoint(x1: 2023, y1: 1648, wid: 240, hei: 282, tag: 29)
        addViewPoint(x1: 2300, y1: 1666, wid: 340, hei: 280, tag: 30)
        addViewPoint(x1: 3085, y1: 1603, wid: 322, hei: 342, tag: 31)
        addViewPoint(x1: 3450, y1: 1336, wid: 206, hei: 442, tag: 34)
        addViewPoint(x1: 4093, y1: 1364, wid: 183, hei: 274, tag: 33)
        addViewPoint(x1: 4091, y1: 1665, wid: 183, hei: 235, tag: 32)
        
        //        линии
        addLine(x1: 790, y1: 2283, wid: 1030, hei: 30, resId: "6_0")
        addLine(x1: 1820, y1: 1820, wid: 30, hei: 463, resId: "6_16")
        addLine(x1: 1820, y1: 2313, wid: 30, hei: 163, resId: "6_5")
        addLine(x1: 1675, y1: 1790, wid: 145, hei: 30, resId: "16_28")
        addLine(x1: 1850, y1: 1790, wid: 173, hei: 30, resId: "16_29")
        addLine(x1: 1820, y1: 1600, wid: 30, hei: 190, resId: "16_17")
        addLine(x1: 1680, y1: 1570, wid: 140, hei: 30, resId: "17_26")
        addLine(x1: 1820, y1: 1480, wid: 30, hei: 90, resId: "17_18")
        addLine(x1: 1850, y1: 1450, wid: 180, hei: 30, resId: "18_27")
        addLine(x1: 1820, y1: 1220, wid: 30, hei: 230, resId: "18_19")
        addLine(x1: 1850, y1: 1190, wid: 2610, hei: 30, resId: "19_20")
        addLine(x1: 4460, y1: 1220, wid: 30, hei: 110, resId: "20_25")
        addLine(x1: 1240, y1: 1190, wid: 580, hei: 30, resId: "19_21")
        addLine(x1: 1210, y1: 1220, wid: 30, hei: 122, resId: "21_24")
        addLine(x1: 1210, y1: 1035, wid: 30, hei: 155, resId: "21_22")
        addLine(x1: 1070, y1: 1005, wid: 140, hei: 30, resId: "22_23")
        addLine(x1: 790, y1: 2475, wid: 440, hei: 30, resId: "1_0")
        addLine(x1: 1260, y1: 2475, wid: 150, hei: 30, resId: "1_3")
        addLine(x1: 1440, y1: 2475, wid: 381, hei: 30, resId: "3_5")
        addLine(x1: 1410, y1: 2505, wid: 30, hei: 466, resId: "3_4")
        addLine(x1: 1230, y1: 2505, wid: 30, hei: 197, resId: "1_2")
        addLine(x1: 1045, y1: 2701, wid: 185, hei: 30, resId: "2_38")
        addLine(x1: 1820, y1: 2504, wid: 30, hei: 660, resId: "5_36")
        addRotatedLine(x1: 1273, y1: 3102, wid: 193, hei: 30, angle: -40, resId: "4_37")
        addRotatedLine(x1: 1840, y1: 2476, wid: 958, hei: 30, angle: -20, resId: "5_7")
        addRotatedLine(x1: 1845, y1: 2284, wid: 906, hei: 30, angle: -8.6, resId: "6_7")
        addLine(x1: 2770, y1: 2147, wid: 180, hei: 30, resId: "7_8")
        addLine(x1: 2950, y1: 1880, wid: 30, hei: 268, resId: "8_10")
        addLine(x1: 2740, y1: 1880, wid: 30, hei: 268, resId: "7_9")
        addLine(x1: 2980, y1: 1850, wid: 105, hei: 30, resId: "10_31")
        addLine(x1: 2640, y1: 1850, wid: 100, hei: 30, resId: "9_30")
        addLine(x1: 2980, y1: 2147, wid: 905, hei: 30, resId: "8_11")
        addLine(x1: 3885, y1: 1800, wid: 30, hei: 347, resId: "11_12")
        addLine(x1: 3915, y1: 1770, wid: 175, hei: 30, resId: "12_32")
        addLine(x1: 3885, y1: 1570, wid: 30, hei: 200, resId: "12_13")
        addLine(x1: 3915, y1: 1540, wid: 177, hei: 30, resId: "13_33")
        addLine(x1: 3885, y1: 1460, wid: 30, hei: 80, resId: "13_14")
        addLine(x1: 3654, y1: 1430, wid: 231, hei: 30, resId: "14_34")
        addLine(x1: 3915, y1: 2147, wid: 395, hei: 30, resId: "11_15")
        addLine(x1: 4310, y1: 2177, wid: 30, hei: 211, resId: "15_35")
        
        //        промежуточные точки
        addIntermediatePoint(x1: 1410, y1: 2971, wid: 30, hei: 30, tag: 4)
        addIntermediatePoint(x1: 1820, y1: 2283, wid: 30, hei: 30, tag: 6)
        addIntermediatePoint(x1: 1230, y1: 2475, wid: 30, hei: 30, tag: 1)
        addIntermediatePoint(x1: 1820, y1: 2475, wid: 30, hei: 30, tag: 5)
        addIntermediatePoint(x1: 1820, y1: 1790, wid: 30, hei: 30, tag: 16)
        addIntermediatePoint(x1: 1820, y1: 1570, wid: 30, hei: 30, tag: 17)
        addIntermediatePoint(x1: 1820, y1: 1450, wid: 30, hei: 30, tag: 18)
        addIntermediatePoint(x1: 1820, y1: 1190, wid: 30, hei: 30, tag: 19)
        addIntermediatePoint(x1: 1210, y1: 1190, wid: 30, hei: 30, tag: 21)
        addIntermediatePoint(x1: 1210, y1: 1005, wid: 30, hei: 30, tag: 22)
        addIntermediatePoint(x1: 4460, y1: 1190, wid: 30, hei: 30, tag: 20)
        addIntermediatePoint(x1: 1230, y1: 2701, wid: 30, hei: 30, tag: 2)
        addIntermediatePoint(x1: 1410, y1: 2475, wid: 30, hei: 30, tag: 3)
        addIntermediatePoint(x1: 2740, y1: 2147, wid: 30, hei: 30, tag: 7)
        addIntermediatePoint(x1: 2740, y1: 1850, wid: 30, hei: 30, tag: 9)
        addIntermediatePoint(x1: 2950, y1: 1850, wid: 30, hei: 30, tag: 10)
        addIntermediatePoint(x1: 2950, y1: 2147, wid: 30, hei: 30, tag: 8)
        addIntermediatePoint(x1: 3885, y1: 2147, wid: 30, hei: 30, tag: 11)
        addIntermediatePoint(x1: 3885, y1: 1430, wid: 30, hei: 30, tag: 14)
        addIntermediatePoint(x1: 3885, y1: 1540, wid: 30, hei: 30, tag: 13)
        addIntermediatePoint(x1: 3885, y1: 1770, wid: 30, hei: 30, tag: 12)
        addIntermediatePoint(x1: 4310, y1: 2147, wid: 30, hei: 30, tag: 15)
    
    
    }
    
    
    
    func readJson(name:String){
        if let filePath = Bundle.main.path(forResource: name, ofType: "json"),
            let data = NSData(contentsOfFile: filePath) {
            do {
                
                let jsonData = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [Any]
                //                print((jsonData[0] as! NSDictionary)["id"]!)
                arrayFromJson = jsonData
            }
            catch {
                //Handle error
            }
        }
    }
    
    //отрисовка линий из прочитанного json файла с параллельным запоминанием точек в словарь
    func createLinesFromJson(){
        
        if arrayFromJson.count != 0{
            
            for i in 0...arrayFromJson.count-1{
                let startX:Double = (arrayFromJson[i] as! NSDictionary)["startX"]! as! Double
                print(startX)
                let endX:Double = (arrayFromJson[i] as! NSDictionary)["endX"]! as! Double
                print(endX)
                let startY:Double = (arrayFromJson[i] as! NSDictionary)["startY"]! as! Double
                print(startY)
                let endY:Double = (arrayFromJson[i] as! NSDictionary)["endY"]! as! Double
                print(endY)
                let length:Double = sqrt((Double(pow(Double(endX-startX),2) + pow(Double(endY-startY),2))))
                print(length)
                
                
                if (startX == endX){
                    
                    if(startY > endY){
                        addLine(x1: Int(round(startX-15.0)), y1: Int(round(startY)), wid: 30, hei: Int(round(length)), resId: "1_2")
                    }else{
                        addLine(x1: Int(round(startX-15.0)), y1: Int(round(endY)), wid: 30, hei: Int(round(length)), resId: "1_2")
                    }
                    
                }else if (startY == endY){
                    
                    if(startX < endX){
                        addLine(x1: Int(round(startX)), y1: Int(round(startY-15.0)), wid: Int(round(length)), hei: 30, resId: "1_2")
                    }else{
                        addLine(x1: Int(round(endX)), y1: Int(round(startY-15.0)), wid: Int(round(length)), hei: 30, resId: "1_2")
                    }
                    
                }else if(endX > startX && endY < startY){
                    
                    let alpha = asin(fabs((endY-startY)/length))
                    
                    addRotatedLine(x1: Int(round(startX-(15.0*sin(alpha)))), y1: Int(round(startY-(15.0*cos(alpha)))), wid: Int(round(length)), hei: 30, angle: CGFloat(-alpha*180/Double.pi), resId: "1_2")
                    
                }else if(endX > startX && endY > startY){
                    
                    let alpha = asin(fabs((endY-startY)/length))
                    
                    addRotatedLine(x1: Int(round(startX+(15.0*sin(alpha)))), y1: Int(round(startY-(15.0*cos(alpha)))), wid: Int(round(length)), hei: 30, angle: CGFloat(alpha*180/Double.pi), resId: "1_2")
                    
                }else if(endX < startX && endY < startY){
                    
                    let alpha = acos(fabs((endY-startY)/length))
                    
                    addRotatedLine(x1: Int(round(startX-(15.0*cos(alpha)))), y1: Int(round(startY+(15.0*sin(alpha)))), wid:Int(round(length)), hei: 30, angle: CGFloat(-alpha*180/Double.pi-90), resId: "1_2")
                    
                }else if(endX < startX && endY > startY){
                    
                    let alpha = acos(fabs((endY-startY)/length))
                    
                    addRotatedLine(x1: Int(round(startX+(15.0*cos(alpha)))), y1: Int(round(startY+(15.0*sin(alpha)))), wid: Int(round(length)), hei: 30, angle: CGFloat(alpha*180/Double.pi+90), resId: "1_2")
                    
                }
                
                savePointToDictionary(point: CGPoint.init(x: round(startX-15.0), y: round(startY-15.0)))
                savePointToDictionary(point: CGPoint.init(x: round(endX-15.0), y: round(endY-15.0)))

            }
        }else{
            print("Json пуст или не прочитан!")
        }
        
    }
    
    //запоминание точек в словарь
    func savePointToDictionary(point:CGPoint){
        if (!dictionaryOfPointsFromJson.values.contains(point)){
            dictionaryOfPointsFromJson[dictionaryOfPointsFromJson.keys.count] = point
        }
    }
    
    //отрисовка точек из заполненного словаря по линиям из json файла
    func createPointsFromJson(){
        
        for i in dictionaryOfPointsFromJson.keys{
            addIntermediatePoint(x1: Int(dictionaryOfPointsFromJson[i]!.x), y1: Int(dictionaryOfPointsFromJson[i]!.y), wid: 30, hei: 30, tag: i)
        }
        
    }
}

