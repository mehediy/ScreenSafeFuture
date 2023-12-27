//
//  Question.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 9/13/23.
//

import Foundation

struct QuestionResponse: Codable {
    let questions: [Question]
}

// MARK: - Question
struct Question: Codable {
    let type: QuestionType
    let title: String
    let tag: String
    let option: [String]
    let multiSelect: Bool?
}

enum QuestionType: String, Codable {
    case binary = "binary"
    case mcq = "mcq"
}

//
//struct Question {
//
//    let text: String
//    let answers: [String]
//    let isMultiselectable: Bool
//
//    init(text: String, answers: [String], multiselectable: Bool) {
//        self.text = text
//        self.answers = answers
//        isMultiselectable = multiselectable
//    }
//}
