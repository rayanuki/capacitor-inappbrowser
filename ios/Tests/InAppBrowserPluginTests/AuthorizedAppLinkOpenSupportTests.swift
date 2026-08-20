import XCTest
@testable import InappbrowserPlugin

final class AuthorizedAppLinkOpenSupportTests: XCTestCase {
    func testUniversalLinkSuccessOpensExternally() {
        XCTAssertEqual(
            AuthorizedAppLinkOpenSupport.resolve(universalLinkOpened: true, systemOpenSucceeded: false),
            .openedExternally
        )
    }

    func testSystemOpenFallbackOpensExternally() {
        XCTAssertEqual(
            AuthorizedAppLinkOpenSupport.resolve(universalLinkOpened: false, systemOpenSucceeded: true),
            .openedExternally
        )
    }

    func testBothExternalAttemptsFailedStayInWebView() {
        XCTAssertEqual(
            AuthorizedAppLinkOpenSupport.resolve(universalLinkOpened: false, systemOpenSucceeded: false),
            .loadInWebView
        )
    }
}

final class CustomSchemeOpenSupportTests: XCTestCase {
    func testOpensWhenCanOpenURLIsTrue() {
        XCTAssertTrue(CustomSchemeOpenSupport.shouldAttemptOpen(scheme: "instagram", canOpenURL: true))
        XCTAssertTrue(CustomSchemeOpenSupport.shouldAttemptOpen(scheme: "mailto", canOpenURL: true))
    }

    func testForcesOpenForMailtoTelSmsWithoutQueriesScheme() {
        XCTAssertTrue(CustomSchemeOpenSupport.shouldAttemptOpen(scheme: "mailto", canOpenURL: false))
        XCTAssertTrue(CustomSchemeOpenSupport.shouldAttemptOpen(scheme: "tel", canOpenURL: false))
        XCTAssertTrue(CustomSchemeOpenSupport.shouldAttemptOpen(scheme: "sms", canOpenURL: false))
        XCTAssertTrue(CustomSchemeOpenSupport.shouldAttemptOpen(scheme: "MAILTO", canOpenURL: false))
    }

    func testDoesNotForceOpenUnknownCustomSchemesWithoutQueriesScheme() {
        XCTAssertFalse(CustomSchemeOpenSupport.shouldAttemptOpen(scheme: "instagram", canOpenURL: false))
        XCTAssertFalse(CustomSchemeOpenSupport.shouldAttemptOpen(scheme: "myapp", canOpenURL: false))
        XCTAssertFalse(CustomSchemeOpenSupport.shouldAttemptOpen(scheme: nil, canOpenURL: false))
    }
}
