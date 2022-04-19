//
//  RockPaperScissors - main.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

enum ExceptionalInput {
    case wrongInput
    case closeInput
    
    var correspondingNumber: Int {
        switch self {
        case .wrongInput:
            return -1
        case .closeInput:
            return 0
        }
    }
}

enum RockPaperScissor: CaseIterable {
    case scissor
    case rock
    case paper
    
    var correspondingNumber: Int {
        switch self {
        case .scissor:
            return 1
        case .rock:
            return 2
        case .paper:
            return 3
        }
    }
    var correspodingMJPNumber: Int {
        switch self {
        case .rock:
            return 1
        case .scissor:
            return 2
        case .paper:
            return 3
        }
    }
}

enum GameResult: String {
    case draw
    case win
    case lose
    
    var result: String {
        switch self {
        case .draw:
            return "비겼습니다!"
        case .win:
            return "이겼습니다!"
        case .lose:
            return "졌습니다!"
        }
    }
}

struct Player {
    var playerName: String
    private var MJPTurn = false
    
    init(playerName: String) {
        self.playerName = playerName
    }
    
    mutating func MJPTurnChange() {
        if self.MJPTurn {
            self.MJPTurn = false
        } else {
            self.MJPTurn = true
        }
    }
    
    func retrieveMJPTurn() -> Bool {
        return self.MJPTurn
    }
}

func printRPSOption() {
    print("가위(1), 바위(2), 보(3)! <종료 : 0> : ", terminator: "")
}

func printMJPOption(player: Player) {
    print("[\(player.playerName) 턴] 묵(1), 찌(2), 빠(3)! <종료 : 0> : ", terminator: "")
}

func makeComputerRandomNumber() -> Int {
    let computerInput = Int.random(in: 1...3)
    return computerInput
}

func inputUserNumber() -> Int {
    var userInput: Int
    let inputNumber = readLine() ?? ""
    userInput = checkUserInputNumber(userInput: inputNumber)
    return userInput
}

func checkUserInputNumber(userInput: String) -> Int {
    var selectedNumber = ExceptionalInput.wrongInput.correspondingNumber
    let rockPaperScissorCases = RockPaperScissor.allCases.map( {$0.correspondingNumber} )
    let closeInputCase = [ExceptionalInput.closeInput.correspondingNumber]
    let verifiedInputCases = rockPaperScissorCases + closeInputCase
    
    if let verifiedUserInput = Int(userInput) {
        switch verifiedUserInput {
        case _ where verifiedInputCases.contains(verifiedUserInput):
            selectedNumber = verifiedUserInput
        default:
            selectedNumber = ExceptionalInput.wrongInput.correspondingNumber
        }
    }
    return selectedNumber
}

func printErrorMessage() {
    print("잘못된 입력입니다. 다시 시도해주세요.")
}

func compareTwoNumbers (userInput: Int, computerInput: Int) -> String {
    let winningNumberCases = [(RockPaperScissor.scissor.correspondingNumber, RockPaperScissor.paper.correspondingNumber),
                              (RockPaperScissor.rock.correspondingNumber, RockPaperScissor.scissor.correspondingNumber),
                              (RockPaperScissor.paper.correspondingNumber, RockPaperScissor.rock.correspondingNumber)]
    var matchResult = GameResult.draw.result
    let comparisonGroup = (userInput, computerInput)
    if userInput == computerInput {
        matchResult = GameResult.draw.result
    } else if winningNumberCases.contains(where: { $0 == comparisonGroup }) {
        matchResult = GameResult.win.result
    } else {
        matchResult = GameResult.lose.result
    }
    return matchResult
}

func compareMJPTwoNumbers (userInput: Int, computerInput: Int) -> String {
    let winningNumberCases = [(RockPaperScissor.rock.correspodingMJPNumber, RockPaperScissor.scissor.correspodingMJPNumber),
                              (RockPaperScissor.scissor.correspodingMJPNumber, RockPaperScissor.paper.correspodingMJPNumber), (RockPaperScissor.paper.correspodingMJPNumber, RockPaperScissor.rock.correspodingMJPNumber)]
    var matchResult = GameResult.draw.result
    let comparisonGroup = (userInput, computerInput)
    if userInput == computerInput {
        matchResult = GameResult.draw.result
    } else if winningNumberCases.contains(where: { $0 == comparisonGroup }) {
        matchResult = GameResult.win.result
    } else {
        matchResult = GameResult.lose.result
    }
    return matchResult
    
}

var user = Player(playerName: "사용자")
var computer = Player(playerName: "컴퓨터")


func startRPSGame() {
    let computerRPSInput = makeComputerRandomNumber()
    while true {
        printRPSOption()
        let userRPSInput = inputUserNumber()
        if userRPSInput == ExceptionalInput.wrongInput.correspondingNumber {
            printErrorMessage()
            continue
        }
        if userRPSInput == ExceptionalInput.closeInput.correspondingNumber{
            print("게임 종료")
            break
        }
        let comparedResult = compareTwoNumbers(userInput: userRPSInput, computerInput: computerRPSInput)
        print(comparedResult)
        if comparedResult == GameResult.draw.result {
            continue
        }
        
        comparedResult == GameResult.win.result ? user.MJPTurnChange() : computer.MJPTurnChange()
        startMJPGame()
        break
    }
}


func startMJPGame() {
    while true {
        let currentWinner = user.retrieveMJPTurn() ? user : computer
        printMJPOption(player: currentWinner)
        let computerMJPInput = makeComputerRandomNumber()
        let userMJPInput = inputUserNumber()
        if userMJPInput == ExceptionalInput.closeInput.correspondingNumber{
            print("게임 종료")
            break
        }
        if currentWinner.playerName == user.playerName && userMJPInput == ExceptionalInput.wrongInput.correspondingNumber {
            printErrorMessage()
            doTurnChange()
            continue
        } else if currentWinner.playerName == computer.playerName && userMJPInput == ExceptionalInput.wrongInput.correspondingNumber {
            printErrorMessage()
            continue
        }
        let matchResult = compareMJPTwoNumbers(userInput: userMJPInput, computerInput: computerMJPInput)
        
        if matchResult == GameResult.draw.result {
            print("\(currentWinner.playerName)의 승리!")
            print("게임 종료")
            break
        } else if currentWinner.playerName == user.playerName && matchResult == GameResult.lose.result {
            doTurnChange()
            print("컴퓨터의 턴입니다")
        } else if currentWinner.playerName == computer.playerName && matchResult == GameResult.win.result {
            doTurnChange()
            print("사용자의 턴입니다")
        }
    }
}

func doTurnChange() {
    computer.MJPTurnChange()
    user.MJPTurnChange()
}

startRPSGame()
