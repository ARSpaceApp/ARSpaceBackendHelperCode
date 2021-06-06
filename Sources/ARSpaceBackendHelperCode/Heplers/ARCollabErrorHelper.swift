//  ARCollabErrorHelper.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Foundation

public struct ARCollabErrorHelper {
    public enum JWTError : Error {
        case missingAuthorizationBearerHeader
    }
    
    public enum RegexError : Error {
        case availableNamesForRegexes (availableNames: String)
        case invalidRegexNameCase
        case invalidKeyValue(key: String)
        case requiredRegexNotRegistered (key: String)
        case regexRequiredMissingFromDB (key: String)
        case errorCheckingValueAgainstRegex(value: String, rule: String)
    }
    
    public enum UsersError : Error {
        case userAlreadyRegistered
        case invalidValueForUserUserRole (key: String)
        case invalidValueForUserUserStatus (key: String)
        case missingRequiredCaseInUserRegexName (key: String)
        case missingRequiredRequestComponent (key: String)
        case incorrectValue(key: String)
        case requiredParameterNotPassed(key: String)
        case valueByPassedParameterWaNotFound(value: String)
        case accessErrorToMakeChange
        case accessErrorToMakeChangeOnlyAdmins
        case accessErrorToMakeChangeOnlySuperadmin
        case oldDataTransferredAsNew (key: String)
        case noDataToUpdate
        case cantChangeOwnSignificantData (key: String)
        case cantChangeRightsOrStatusOfSuperadmin
        case providedDataCantBeUsedToCreateAvatar
        case userIsBlocked (username: String)
        case userIsDeleted (username: String)
    }
}

extension ARCollabErrorHelper.JWTError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .missingAuthorizationBearerHeader:
            return "Missing authorization bearer header"
        }
    }
}

extension ARCollabErrorHelper.RegexError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .availableNamesForRegexes(availableNames: let availableNames):
            return "Available names for regexes: \(availableNames)"
        case .invalidKeyValue(let key):
            return "Invalid key value \(key)"
        case .invalidRegexNameCase:
            return "Сorrect name of regexes must be specified, check cases with a GET to '.../regex/cases'"
        case .requiredRegexNotRegistered(let key):
            return "Regex to validate field '\(key)' is not registered."
        case .errorCheckingValueAgainstRegex(value: let value, rule: let rule):
            return "Value '\(value)' does not match service rule - \(String(describing: rule))."
        case .regexRequiredMissingFromDB(key: let key):
            return "Regex to validate field '\(key)' missing from DB."
        }
    }
}

extension ARCollabErrorHelper.UsersError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userAlreadyRegistered:
            return "User with specified username or email is already registered. Please select other data for registration"
        case .missingRequiredCaseInUserRegexName(key: let key):
            return "Missing required case (in UserRegexName) for \(key)"
        case .incorrectValue(key: let key):
            return "Invalid value for '\(key)'. Please try again."
        case .requiredParameterNotPassed(key: let key):
            return "Required parameter not passed: '\(key)'"
        case .valueByPassedParameterWaNotFound(value: let value):
            return "Value '\(value)' by the passed parameter was not found. Please clarify your request."
        case .missingRequiredRequestComponent(key: let key):
            return "Missing required request component - '\(key)'."
        case .accessErrorToMakeChange:
            return "Only superadmin, admin or profile owner has access to this data."
        case .oldDataTransferredAsNew(key: let key):
            return "You passed the old data for the '\(key)' field as new data."
        case .noDataToUpdate:
            return "No data to update"
        case .accessErrorToMakeChangeOnlyAdmins:
            return "Changes can only be made by superadmin or admin."
        case .accessErrorToMakeChangeOnlySuperadmin:
            return "Changes can only be made by superadmin."
        case .invalidValueForUserUserRole(key: let key):
            return "Invalid value '\(key)' for user role. To view the allowed values, see route ../users/roles"
        case .invalidValueForUserUserStatus(key: let key):
            return "Invalid value '\(key)' for user status. To view the allowed values, see route .../users/statuses"
        case .cantChangeOwnSignificantData(key: let key):
            return "Can't change own significant data: '\(key)'"
        case .cantChangeRightsOrStatusOfSuperadmin:
            return "\u{261D}: You cannot change 'rights' or 'status' of superadmin - settings are set programmatically."
        case .providedDataCantBeUsedToCreateAvatar:
            return "\u{261D}: Provided data cannot be used to create the avatar."
        case .userIsBlocked(username: let username):
            return "User named '\(username)' has been blocked. To continue working, please contact service administration."
        case .userIsDeleted(username: let username):
            return "User named '\(username)' has been deleted. To request to restore profile in system, please contact the service administration."
        }
    }
}
