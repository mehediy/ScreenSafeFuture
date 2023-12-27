//
//  3dScannerAppSurvey.swift
//  SwiftSurvey
//
//  Created by CC Laan on 8/10/21.
//

import Foundation
import SwiftUI
import Combine


typealias MCQ = MultipleChoiceQuestion
typealias MCR = MultipleChoiceResponse



func ImportanceQuestion( _ title : String ) -> MultipleChoiceQuestion {
    return MultipleChoiceQuestion(title: title, answers: [ "Not Important" , "Somewhat Important", "Very Important" ], tag: TitleToTag(title))
}

func loadJson(filename fileName: String) -> [Question]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(QuestionResponse.self, from: data)
            return jsonData.questions
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}

var SampleSurvey: Survey {
    
    var surveyQuestions = [SurveyQuestion]()
    
    if let questions = loadJson(filename: "questionnaire") {
        for question in questions {
            switch question.type {
            case .binary:
                let binaryQuestion = BinaryQuestion(title: question.title,
                                                    answers: question.option,
                                                    tag: question.tag)
                binaryQuestion.required = true
                surveyQuestions.append(binaryQuestion)
            case .mcq:
                let mcqQuestion = MCQ(title: question.title,
                                      items: question.option,
                                      multiSelect: question.multiSelect ?? false,
                                      tag: question.tag)
                mcqQuestion.required = true
                surveyQuestions.append(mcqQuestion)
            }
        }
    }
    
    let survey = Survey(surveyQuestions, version: "001")
    return survey
}



//let SampleSurvey = Survey([
//    workingParent,
//    ageRange
//    contact_form.setVisibleWhenSelected(ask_contact_us.choices.first!),
//
//    ask_comments,
//
//    comments_form.setVisibleWhenSelected(ask_comments.choices.first!),
//
//
//],
//version: "001")

//let workingParent = BinaryQuestion(title: "Are you a working parent?" , answers: ["Yes", "No"],
//                    tag: "working-parent")
//
//let ageRange = MCQ(title: "Select the age range of your child",
//                   items: [
//                    "0-18 months",
//                    "18-36 months"],
//                   multiSelect: false,
//                   tag: "age-range")
//
//let gender = MCQ(title: "What is the gender of your child?",
//                   items: [
//                    "Male",
//                    "Female",
//                    "Prefer not to disclose"
//                   ],
//                   multiSelect: false,
//                   tag: "child-gender")
//
//let contact_form = ContactFormQuestion(title: "Please share your contact info and we will reach out",
//                                       tag: "contact-form")
//
//
//let comments_form = CommentsFormQuestion(title: "Tell us your feedback or feature requests",
//                                         subtitle: "Optionally leave your email",
//                                         tag: "feedback-comments-form")






struct SampleSurvey_Previews: PreviewProvider {
    
    static var previews: some View {

        SurveyView(survey: SampleSurvey).preferredColorScheme(.light)
        
    }
}
