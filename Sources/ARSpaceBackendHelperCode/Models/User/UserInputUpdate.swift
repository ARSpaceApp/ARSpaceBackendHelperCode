//  UserInputUpdate.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor
import Fluent

/// Used to send a request to server to update user data.
public struct UserInputUpdate: Content {
    public let firstname, lastname, email, password, dob : String?
    public let gender: UserGender?
    public let address: UserAddressInput?
    
    public init (firstname: String? = nil , lastname: String? = nil, email: String? = nil , password: String? = nil, dob: String? = nil,  gender: UserGender? = nil, address: UserAddressInput? = nil) {
        
        self.firstname = firstname
        self.lastname  = lastname
        self.email     = email
        self.password  = password
        self.dob       = dob
        self.gender    = gender
        self.address   = address
    }
}

extension UserInputUpdate : Validatable {
    
    public static func validations(_ validations: inout Validations) {
        
        validations.add("firstname",
                        as: String?.self,
                        required: false
        )
        
        validations.add("lastname",
                        as: String?.self,
                        required: false
        )
        
        validations.add("email",
                        as: String?.self,
                        required: false
        )
        
        validations.add("password",
                        as: String?.self,
                        is: .valid,
                        required: false
        )
        
        validations.add("gender", as: String.self,
                        is: .in(UserGender.male.rawValue,UserGender.female.rawValue),
                        required: false
        )

        
        validations.add("address", as: UserAddressInput.self,
                        is: .valid,
                        required: false
        )
    }
    
    /// Get date from a string.
    /// - Parameter dateString: Date in string value.
    /// - Throws: Error converting string value to date.
    /// - Returns: Error message or date returned from string.
    public func validations(dateString: String?) throws -> Date? {
        if let date = Date.dateFromString(dateString, dateFormat: DateTimeFormats.allCasesDescriptions) {
            return date
        } else {
            throw Abort(.badRequest, reason: "Unable to get date and time from specified string.")
        }
    }
    
    /// Checks all entered fields of user's address and returns generated address tied to user.
    /// - Parameters:
    ///   - address: Entered address information as AddressInput.
    ///   - user: User to bind address.
    /// - Throws: Error filling address fields.
    /// - Returns: An error message or generated address tied to user.
    public func validations(address: UserAddressInput?, user: User) throws -> UserAddress {
        if address?.address != nil, address?.address != "",
           address?.city != nil, address?.city != "",
           address?.region != nil, address?.region != "",
           address?.country  != nil, address?.country != "",
           address?.zip != nil, address?.zip != ""{
            return address!.makeAddress(for: user)
        } else {
            throw Abort (.badRequest, reason: "Not all address fields are completed")
        }
    }
    
    func validations(avatar: UserAvatarInput? ) -> Bool {
        // TODO: Write custom validation
        return true
    }

    /// Checks uniqueness of email in DB.
    /// - Parameters:
    ///   - db: DB to find matches.
    /// - Throws: Error of type UsersServiceErrorHelper.UsersError.userAlreadyRegistered.
    /// - Returns: An error message or boolean true flag indicating the check was successful.
    public func validationValuesForUniqueness (db: Database) throws -> EventLoopFuture<Bool> {
        
        // 1. Check if a new "email" is specified
        if let email = self.email {
            return User.query(on: db)
                .filter(\.$email == email)
                .all()
                .flatMapThrowing {users -> Bool in
                    // 2. If new "email" is not unique, return an error.
                    if users.count > 0 {
                        throw Abort(.badRequest, reason: ARCollabErrorHelper.UsersError.userAlreadyRegistered.localizedDescription)
                    } else {
                        return true
                    }
                }
        // 1.1 If new "email" is not specified, return ok
        } else {
            return db.eventLoop.future(true)
        }
    }
    
    /// Checks passed values against existing regex.
    /// - Parameters:
    ///   - req: Request (for getting DB and forming EventLoopFuture).
    /// - Throws: Errors due to absence of expected regexes in the AppValues entity dictionary or DB, as well as value validation errors with  provision of rules.
    /// - Returns: An error message or boolean true flag indicating the check was successful.
    /// - Remark: Currently, username, password are being checked.
    public func validationValuesAgainstRegexes(req: Request) throws  ->  EventLoopFuture<Bool> {
        // 1. Search for a regex for checking 'password' in AppValues entity dictionary.
        if let passwordRegex = AppValues.shared.regexes.first(where: {$0.key.contains("password")})?.value {
            // 2. Check if the password is specified.
            if let password = self.password {
                // 3. Checking 'password' value against a regex.
                if passwordRegex.matches(password) {
                    return req.eventLoop.future(true)
                } else {
                    // 4. Search for required case in UserRegexName to find values in DB.
                    if let passwordRegex = RegexName.allCases.first(where: {$0.rawValue.contains("password")}) {
                        // 5. Search for a rule in DB for found case.
                        return UserRegex.query(on: req.db).filter(\.$regexName == passwordRegex).first().flatMapThrowing { passwordRegex -> Bool in
                            guard let passwordRegex = passwordRegex else {
                                // 5.1 Error if required value is missing in DB.
                                throw ARCollabErrorHelper.RegexError.regexRequiredMissingFromDB(key: "password")
                            }
                            // 5.1 Error checking 'password' value against regex with rule provision.
                            throw Abort(.badRequest, reason: "\(ARCollabErrorHelper.RegexError.errorCheckingValueAgainstRegex(value: password, rule: passwordRegex.regexRule).localizedDescription)")
                        }
                    } else {
                        // 4.1 Error finding required case in UserRegexName enum.
                        throw ARCollabErrorHelper.UsersError.missingRequiredCaseInUserRegexName(key: "password")
                    }
                }
            } else {
                // 2.1 If no password is specified, return ok.
                return req.eventLoop.future(true)
            }
        } else {
            // Error if there is no regex for checking 'password' in AppValues entity dictionary.
            throw ARCollabErrorHelper.RegexError.requiredRegexNotRegistered(key: "password")
        }
    }
}
