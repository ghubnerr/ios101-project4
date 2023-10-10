//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaAPIResponse : Decodable {
    let questions: [TriviaQuestion]
    
    private enum CodingKeys: String, CodingKey {
        case questions = "results"
    }
}

struct TriviaQuestion : Decodable {
  let category: String
  var question: String
  var correctAnswer: String
  var incorrectAnswers: [String]
    
    private enum CodingKeys: String, CodingKey {
        case category = "category"
        case question = "question"
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}
