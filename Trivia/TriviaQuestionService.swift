//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Gabriel Hübner on 10/9/23.
//

import Foundation


class TriviaQuestionService {
    static func fetchQuestions (amount: Int,
                                difficulty: String,
                                category: Int,
                                type: String,
                               completion: (([TriviaQuestion]) -> Void)? = nil){
        let parameters = "type=\(type)&amount=\(amount)&category=\(category)&difficulty=\(difficulty)"
        let url = URL(string: "https://opentdb.com/api.php?\(parameters)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                assertionFailure("Error \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid Response")
                return
            }
            guard (data != nil), httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            let decoder = JSONDecoder()
            let response = try! decoder.decode(TriviaAPIResponse.self, from:data!)
            
            DispatchQueue.main.async {
                completion?(response.questions)
            }
            
            
        }
        task.resume()
    }
    private static func parse(data: Data) -> [TriviaQuestion] {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if let questionResults = json["results"] as? [[String: Any]] {
                    var parsedQuestions: [TriviaQuestion] = []
                    
                    for questionData in questionResults {
                        if let category = questionData["category"] as? String,
                           let correctAnswer = questionData["correct_answer"] as? String,
                           let incorrectAnswers = questionData["incorrect_answers"] as? [String],
                           let question = questionData["question"] as? String {
                            
                            let question = TriviaQuestion(category: category, question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
                            
                            parsedQuestions.append(question)
                        }
                    }
                    
                    return parsedQuestions
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }

            return []
        }
    }

