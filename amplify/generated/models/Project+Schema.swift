// swiftlint:disable all
import Amplify
import Foundation

extension Project {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case imageKey
    case description
    case userId
    case imageKeys
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let project = Project.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Projects"
    model.syncPluralName = "Projects"
    
    model.attributes(
      .primaryKey(fields: [project.id])
    )
    
    model.fields(
      .field(project.id, is: .required, ofType: .string),
      .field(project.name, is: .required, ofType: .string),
      .field(project.imageKey, is: .required, ofType: .string),
      .field(project.description, is: .optional, ofType: .string),
      .field(project.userId, is: .required, ofType: .string),
      .field(project.imageKeys, is: .optional, ofType: .embeddedCollection(of: ImageProject.self)),
      .field(project.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(project.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Project: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}