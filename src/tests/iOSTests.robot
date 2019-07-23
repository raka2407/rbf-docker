*** Setting ***
Library    AppiumLibrary    
*** Variable ***
${remote_url}    http://docker.for.mac.localhost:4723/wd/hub
*** Test Cases ***
Launch App without Install
    Open Application    ${remote_url}    alias=bmpuls    platformName=iOS    platformVersion=11.2    deviceName=Raka's iPhone    automationName=XCUITest    udid=d1b13f1d9a5977b72479647b588ca6b34ea648a5    xcodeOrgId=2QDU4ARY99    xcodeSigningId=iPhone Developer    bundleId=com.dnb.bmpuls    updatedWDABundleId=test.WebDriverAgentRunner
    # Click Button    Get started
BankID Authentication
    Wait Until Page Contains    BankID
    Click Element    BankID
    Wait Until Page Contains    Next
    Input Text    xpath=//*[contains(@type,'XCUIElementTypeTextField')]    15057120565
    Click Button    Next
    Wait Until Page Contains    Engangskode    15s
    Input Text    xpath=//*[contains(@type,'XCUIElementTypeTextField')]    otp
    Click Button    Neste
    Wait Until Page Contains    Personlig passord    15s
    Input Text    xpath=//*[contains(@type,'XCUIElementTypeSecureTextField')]    qwer1234
    Click Button    Neste
    # Wait Until Page Contains    Terms and conditions
    # Scroll Down    Godkjenn
    # Click Button    Godkjenn
Access Accounts
    Wait Until Page Contains    Accounts    15s
    # ${accountsCheck}=    Run Keyword And Return Status    Page Should Contain Text    We cannot display accounts
    # Swipe By Percent    90    50    10    50
    # Swipe By Percent    90    50    10    50
Access Payments
    Click Button    Payments
    Wait Until Page Contains    Payment    10s
Access Key Figures
    Click Button    Key figures
    Wait Until Page Contains    Operating Margin    10s
Access Profile
    Click Button    Profile
*** Keyword ***
    
