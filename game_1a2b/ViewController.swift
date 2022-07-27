//
//  ViewController.swift
//  game_1a2b
//
//  Created by rjjq on 2022/7/27.
//

import UIKit

class ViewController: UIViewController {

    // 紀錄
    @IBOutlet weak var logText: UITextView!
    // 輸入
    @IBOutlet weak var inputText: UITextField!
    // 結果
    @IBOutlet weak var resultText: UILabel!
    // 開始
    @IBOutlet weak var startBtn: UIButton!
    // 使用時間
    @IBOutlet weak var usedTimeText: UILabel!
    
    // 答案
    var answers: [Int]?
    // 已玩次數
    var counts = 0
    // 遊戲計時器
    var gameTimer: Timer?
    // 已玩遊戲時間
    var totalTime: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answers = initGuessNumber()
        // debugPrint(answers!)
    }

    // 初始答案
    func initGuessNumber() -> [Int] {
        var numbers: [Int] = []
        while numbers.count < 4 {
            let num = Int.random(in: 0...9)
            if !numbers.contains(num) {
                numbers.append(num)
            }
        }
        return numbers
    }
    
    // 初始計時器
    func initTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // 更新時間
    @objc func updateTimer() {
        totalTime += 0.1
        usedTimeText.text = String(format: "Used Time: %4.1f s", totalTime)
    }
    
    // 開始遊戲
    @IBAction func start(_ sender: Any) {
        if counts == 0 {
            initTimer()
        }
        
        let inputStrings = inputText.text ?? ""
        
        if inputStrings.count == 4 {
            var guessNumbers: [Int] = []
            inputStrings.forEach { char in
                let num = Int(String(char)) ?? 0
                guessNumbers.append(num)
            }
            // debugPrint(guessNumbers)
            
            counts += 1
            
            let (result, aCount, _) = compareAnswer(with: guessNumbers)
            
            // debugPrint(result, aCount)
            
            logText.text += String(format: "#%3d\t:\t%@\t=>\t %@\n", arguments: [counts, inputStrings, result])
            
            if aCount == 4 {
                resultText.text = "You win :)"
                startBtn.isEnabled = false
                gameTimer?.invalidate()
            }
        } else {
            debugPrint("not 4 digits")
        }
        
        inputText.text = ""
    }
    
    // 比較答案 -> 回傳 (結果, A count, B count)
    func compareAnswer(with guessNumbers: [Int]) -> (String, Int, Int) {
        var aCount: Int = 0
        var bCount: Int = 0
        let answerAry: [Int] = answers ?? [1,2,3,4]
        
        for i in 0...3 {
            let guessNum = guessNumbers[i]
            let answerNum = answerAry[i]
            if guessNum == answerNum {
                aCount += 1
            } else if answerAry.contains(guessNum){
                bCount += 1
            }
        }
        
        return ("\(aCount)A\(bCount)B", aCount, bCount)
    }
    
    // 重新遊戲
    @IBAction func newGame(_ sender: Any) {
        resultText.text = ""
        logText.text = ""
        inputText.text = ""
        startBtn.isEnabled = true
        totalTime = 0.0
        counts = 0
        usedTimeText.text = "Used Time: "
        answers = initGuessNumber()
        // debugPrint(answers)
    }
}

