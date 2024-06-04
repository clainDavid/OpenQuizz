//
//  Game.swift
//  OpenQuizz
//
//  Created by Ambroise COLLON on 13/06/2017.
//  Copyright Â© 2017 OpenClassrooms. All rights reserved.
//

import Foundation


class Game {
    var score = 0

    private var questions = [Question]()
    private var currentIndex = 0

    //  var state: State = .ongoing
    
    var state: State = .over

    enum State {
        case ongoing, over
    }

    /*
        var currentQuestion: Question {
        return questions[currentIndex]
    }*/
    
    var currentQuestion: Question? {
        guard !questions.isEmpty && currentIndex < questions.count else {
            return nil
        }
        return questions[currentIndex]
    }
    

    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        
        QuestionManager.shared.get { (questions) in
            self.questions = questions
            //self.state = .ongoing
            if !questions.isEmpty {
                self.state = .ongoing
            }
            
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }
    }

    func answerCurrentQuestion(with answer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
        }
        goToNextQuestion()
    }

    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }

    private func finishGame() {
        state = .over
    }
}
