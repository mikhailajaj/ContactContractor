// swiftlint:disable all
import Amplify
import Foundation

extension LastMessage {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case body
    case datetime
    case projectId
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let lastMessage = LastMessage.keys
    
    model.listPluralName = "LastMessages"
    model.syncPluralName = "LastMessages"
    
    model.fields(
      .field(lastMessage.body, is: .required, ofType: .string),
      .field(lastMessage.datetime, is: .required, ofType: .dateTime),
      .field(lastMessage.projectId, is: .required, ofType: .string)
    )
    }
}