*** Setting ***
Library    SeleniumLibrary
Library      XvfbRobot

*** Variable ***

*** Test Cases ***
Internet Banking Login
	${list} =    Create List    --headless    --no-sandbox    --disable-dev-shm-usage
	${args} =     Create Dictionary    args=${list}
	${desired caps} =     Create Dictionary    platform=linux     chromeOptions=${args}
	Open Browser    https://www.google.com    browser=chrome    desired_capabilities=${desired caps}
	Capture Page Screenshot
	
Create Headless Browser
    Start Virtual Display    1920    1080
    Open Browser   http://google.com
    Set Window Size    1920    1080
    ${title}=    Get Title
    Should Be Equal    Google    ${title}
    Capture Page Screenshot
    [Teardown]    Close Browser
   
Headless Mode
	Open Browser	http://google.com    browser=headlesschrome
	Capture Page Screenshot
	Close Browser
    
*** Keyword ***