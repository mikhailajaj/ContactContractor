// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "3a067a6806eed1a4b8d9c72444c4ceba"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ChatRoom.self)
    ModelRegistry.register(modelType: Message.self)
    ModelRegistry.register(modelType: Project.self)
    ModelRegistry.register(modelType: User.self)
  }
}