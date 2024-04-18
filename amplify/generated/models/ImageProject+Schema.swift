// swiftlint:disable all
import Amplify
import Foundation

extension ImageProject {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case imageKey
    case projectId
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let imageProject = ImageProject.keys
    
    model.listPluralName = "ImageProjects"
    model.syncPluralName = "ImageProjects"
    
    model.fields(
      .field(imageProject.imageKey, is: .optional, ofType: .string),
      .field(imageProject.projectId, is: .required, ofType: .string)
    )
    }
}