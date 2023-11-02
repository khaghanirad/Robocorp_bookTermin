*** Settings ***
Documentation       Playwright template.

Library    RPA.HTTP
Library    OperatingSystem
Library    Process
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.RobotLogListener
Library    RPA.Smartsheet
Library    RPA.Desktop
*** Variables ***
${run}    ${True}
${chrome_options}
${REMOTE_DEBUG_PORT}    9222
${status}    ${True}
${end}    ${False}
${termin}    ${False}
${page_ready}
${url}    https://otv.verwalt-berlin.de
${result}    headless=False
*** Tasks ***
search for appointment
    WHILE    ${run}
        Navigate to select page
        load page
        select country
        select person
        select other
        select request
        select type
        select radiobtn
        click on next
        WHILE    True
            load page
            Log To Console    page loaded
            ${termin}=  Run Keyword And Return Status    Wait For Element   //*[@id="xi-fs-2"]/legend    5s
            ${termin}=    Set Variable    ${True}
            Log To Console    termin is available: ${termin}
            IF    ${termin}
                Run    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
                Sleep    5s
                Sleep    5s
                Sleep    5s
                ${run}=    Set Variable    ${False}
                BREAK
            ELSE
                ${status}=    Is Element Visible    id=applicationForm:managedForm:proceed    timeout=5
                Log To Console    status is: ${status}
                IF    ${status}
                    click on next
                ELSE
                    
                    ${end}=    Is Element Visible    //*[@id="mainForm"]/div    5s
                    IF    ${end}
                        BREAK
                    END
                END
            END
        END
    END

*** Keywords ***
Navigate to select page
    Log To Console    attach browser
    Attach Chrome Browser    9222
    Log To Console    navigate to url
    RPA.Browser.Selenium.Go To    ${url}
    Sleep    10
    Wait Until Element Is Visible    //*[@id="mainForm"]/div/div/div/div/div/div/div/div/div/div[1]/div[1]/div[2]/a    timeout=60
    Wait Until Element Is Enabled    //*[@id="mainForm"]/div/div/div/div/div/div/div/div/div/div[1]/div[1]/div[2]/a    timeout=60
    Log To Console    click on termin buchen
    Click Element    //*[@id="mainForm"]/div/div/div/div/div/div/div/div/div/div[1]/div[1]/div[2]/a
    Wait Until Element Is Visible    //*[@id="xi-cb-1"]    timeout=60
    Log To Console    click on checkbox
    Wait And Click Button    //*[@id="xi-cb-1"]
    Log To Console    message on weiter
    Wait And Click Button    //*[@id="applicationForm:managedForm:proceed"]
load page
    Log To Console   Load page
    Set Selenium Implicit Wait    30    
    FOR    ${i}    IN RANGE    1    120
        ${page_ready} =    Execute JavaScript    return document.readyState
        Run Keyword If    '${page_ready}' in ['complete', 'interactive']    Exit For Loop
    END
select country
    Wait Until Element Is Visible    id:xi-sel-400    timeout=120
    Wait Until Element Is Enabled    id:xi-sel-400    timeout=120
    Select From List By Label    id:xi-sel-400    Iran, Islamische Republik
select person
    Wait Until Element Is Visible    id:xi-sel-422    timeout=60
    Select From List By Label    id:xi-sel-422    eine Person
select other
    Wait Until Element Is Visible    id:xi-sel-427    timeout=60
    Select From List By Label    id:xi-sel-427    nein
select request
    Wait Until Element Is Visible    //*[@id="xi-div-30"]/div[1]    timeout=60
    Wait Until Element Is Enabled    //*[@id="xi-div-30"]/div[1]    timeout=60
    Sleep    3
    Click Element    //*[@id="xi-div-30"]/div[1]
select type
    Wait Until Element Is Visible    //*[@id="inner-439-0-1"]/div/div[1]    timeout=120
    Click Element    //*[@id="inner-439-0-1"]/div/div[1]
select radiobtn
    Wait Until Element Is Visible    //*[@id="SERVICEWAHL_DE439-0-1-3-305244"]    timeout=60
    Click Element   //*[@data-tag0="Aufenthaltserlaubnis zum Studium (§ 16b)"]
click on next
    Wait Until Element Is Visible    id=applicationForm:managedForm:proceed    timeout=60
    Wait Until Element Is Enabled    id=applicationForm:managedForm:proceed    timeout=60
    Run Keyword And Ignore Error    Wait And Click Button    id=applicationForm:managedForm:proceed
    Sleep    8