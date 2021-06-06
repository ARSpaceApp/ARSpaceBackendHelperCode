//  UserInputSignUp.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor
import Fluent

/// Used to sign up a new user on service.
public struct UserInputSignUp: Content {
    public let username, email, password : String
    public let firstname, lastname: String?
    public let gender: UserGender?
    public let dob : Date?
    
    public init(username: String, firstname: String? = nil, lastname: String? = nil,
                email: String, password: String, gender: UserGender? = nil, dob: Date? = nil) {
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.password = password
        self.gender = gender
        self.dob = dob
    }
}

extension UserInputSignUp: Validatable {
    
    public func makeUser() throws -> User {
        return try User(username: self.username, password: self.password, email: self.email)
    }
    
    public func makeUserWithFullData() throws -> User {
        return try User(
            username: self.username, firstname: self.firstname, lastname: self.lastname, email: self.email, password: self.password, gender: self.gender, dob: self.dob, avatar: nil, address: nil)
    }
    
    public static func validations(_ validations: inout Validations) {
        validations.add("username",
                        as: String.self,
                        is: !.empty,
                        required: true)
        
        validations.add("email",
                        as: String.self,
                        is: !.empty && .email,
                        required: true)
 
        validations.add("password",
                        as: String.self,
                        is: !.empty,
                        required: true)
    }
    
    /// Checks uniqueness of username and email in DB.
    /// - Parameters:
    ///   - db: DB to find matches.
    /// - Throws: Error of type UsersServiceErrorHelper.UsersError.userAlreadyRegistered.
    /// - Returns: An error message or boolean true flag indicating the check was successful.
    public func validationValuesForUniqueness (db: Database) throws -> EventLoopFuture<Bool> {
        return User.query(on: db)
            .group(.or) { group in
                group.filter(\.$username == self.username).filter(\.$email == self.email)}
            .all()
            .flatMapThrowing {users -> Bool in
                if users.count > 0 {
                    throw Abort(.badRequest, reason: ARCollabErrorHelper.UsersError.userAlreadyRegistered.localizedDescription)
                } else {
                    return true
                }
            }
    }
    
    /// Checks passed values against existing regex.
    /// - Parameters:
    ///   - req: Request (for getting DB and forming EventLoopFuture).
    /// - Throws: Errors due to absence of expected regexes in the AppValues entity dictionary or DB, as well as value validation errors with  provision of rules.
    /// - Returns: An error message or boolean true flag indicating the check was successful.
    /// - Remark: Currently, username, password are being checked.
    public func validationValuesAgainstRegexes(eventLoop: EventLoop, db: Database) throws  ->  EventLoopFuture<Bool> {

        // 1. Search for a regex for checking 'username' in AppValues entity dictionary.
        if let usernameRegex = AppValues.shared.regexes.first(where: {$0.key.contains("username")})?.value {
            // 2. Checking 'username' value against a regex.
            if usernameRegex.matches(self.username) {
                // 3. Search for a regex for checking 'password' in AppValues entity dictionary.
                if let passwordRegex = AppValues.shared.regexes.first(where: {$0.key.contains("password")})?.value {
                    // 4. Checking 'password' value against a regex.
                    if passwordRegex.matches(self.password) {
                        return eventLoop.future(true)
                    } else {
                        // Search for required case in UserRegexName to find values in DB.
                        if let passwordRegex = RegexName.allCases.first(where: {$0.rawValue.contains("password")}) {
                            // Search for a rule in DB for found case.
                            return UserRegex.query(on: db).filter(\.$regexName == passwordRegex).first().flatMapThrowing { passwordRegex -> Bool in
                                guard let passwordRegex = passwordRegex else {
                                    // Error if required value is missing in DB.
                                    throw ARCollabErrorHelper.RegexError.regexRequiredMissingFromDB(key: "password")
                                }
                                // Error checking 'password' value against regex with rule provision.
                                throw Abort(.badRequest, reason: "\(ARCollabErrorHelper.RegexError.errorCheckingValueAgainstRegex(value: self.password, rule: passwordRegex.regexRule).localizedDescription)")
                            }
                        } else {
                            // Error finding required case in UserRegexName enum.
                            throw ARCollabErrorHelper.UsersError.missingRequiredCaseInUserRegexName(key: "password")
                        }
                    }
                } else {
                    // Error if there is no regex for checking 'password' in AppValues entity dictionary.
                    throw ARCollabErrorHelper.RegexError.requiredRegexNotRegistered(key: "password")
                }
            } else {
                // Search for required case in UserRegexName to find values in DB.
                if let userRegexName = RegexName.allCases.first(where: {$0.rawValue.contains("username")}) {
                    // Search for a rule in DB for found case.
                    return UserRegex.query(on: db).filter(\.$regexName == userRegexName).first().flatMapThrowing { userRegex -> Bool in
                        guard let userRegex = userRegex else {
                            // Error if the required value is missing in the database
                            throw ARCollabErrorHelper.RegexError.regexRequiredMissingFromDB(key: "username")
                        }
                        // Error checking 'username' value against regex with rule provision.
                        throw Abort(.badRequest, reason: "\(ARCollabErrorHelper.RegexError.errorCheckingValueAgainstRegex(value: self.username, rule: userRegex.regexRule).localizedDescription)")
                    }
                } else {
                    // Error finding required case in UserRegexName enum.
                    throw ARCollabErrorHelper.UsersError.missingRequiredCaseInUserRegexName(key: "username")
                }
            }
        } else {
            // Error if there is no regex for checking 'password' in AppValues entity dictionary.
            throw ARCollabErrorHelper.RegexError.requiredRegexNotRegistered(key: "username")
        }
    }
}
