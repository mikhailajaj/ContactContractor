// swiftlint:disable all
import Amplify
import Foundation

public struct Project: Model {
  public let id: String
  public var name: String
  public var imageKey: String
  public var description: String?
  public var userId: String
  public var imageKeys: [ImageProject?]?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      imageKey: String,
      description: String? = nil,
      userId: String,
      imageKeys: [ImageProject?]? = nil) {
    self.init(id: id,
      name: name,
      imageKey: imageKey,
      description: description,
      userId: userId,
      imageKeys: imageKeys,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      imageKey: String,
      description: String? = nil,
      userId: String,
      imageKeys: [ImageProject?]? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.imageKey = imageKey
      self.description = description
      self.userId = userId
      self.imageKeys = imageKeys
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}