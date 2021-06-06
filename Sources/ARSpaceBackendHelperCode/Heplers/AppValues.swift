//  AppValues.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor
import Fluent
import S3

public final class AppValues {
    
    public  static let shared = AppValues()
    public var logger = Logger(label: "ARCollab_Backend.AppValues")
    public var regexes = [String : NSRegularExpression]()
    
    // Superadmin (test credentials)
    public static let testSuperAdmin = UserInputSignUp (
        username: "testSuperAdmin",
        firstname: "Test",
        lastname: "SuperAdmin",
        email: "testSuperAdmin@mail.ru",
        password: "o0A5w3f1lfFoq2P",
        gender: UserGender.female,
        dob: Date.dateFromString("1992-11-15T12:10:00+0000",
        dateFormat: [DateTimeFormats.iso8601.description])
    )
    
    // AWS
    public static let awsRegion : Region = .eucentral1
    public static let awsRegionString : String = "eu-central-1"
    public static let awsAvatarsBucketName = "arcollab-prod"
    public static let awsAvatarsBucketNameTest = "arcollab-test"
    public static let maxAvatarFileSizeInMb : ByteCount = "20mb"
    
    // Token lifetime
    public static let accessTokenLifeTime : (component: Calendar.Component, value: Int) = (.hour, 4)
    public static let refreshTokenLifeTime : (component: Calendar.Component, value: Int) = (.day, 7)

    // Reference information for service.
    public static let administrationContactAddress: String = "dummy@dummy.dummy"
    
    // Other
    public static let microserviceHealthMessage : String = "ARCollab_Backend work!"
    
    private init () {}
    
    /// When application starts, gets all available regexes and fills in dictionary for further use.
    /// - Parameter reg: Request to get db.
    /// - Throws: Error forming regex from string pattern.
    private  func getRegexFromDB(dataBase: Database) throws {
        _ = UserRegex.query(on: dataBase).all().flatMapThrowing {userRegexes in
            try userRegexes.forEach {userRegex in
                do {
                    let regex = try NSRegularExpression(userRegex.regexString)
                    self.regexes[userRegex.regexName.rawValue] = regex
                } catch {
                    throw error
                }
            }
            self.logger.info("A dictionary of actual regex for service has been created. Number of values - \(self.regexes.count).")
        }
       
    }
    
    private func getNow() -> TimeInterval {
        return Date().timeIntervalSince1970
    }
}
