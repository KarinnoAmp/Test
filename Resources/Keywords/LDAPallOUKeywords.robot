*** Settings ***
Resource    ../../TestSuite/Resource_init.robot

*** Keywords ***
Create URL For Get Token
    Wait Until Network Is Idle
    Get Code From Authentication
    ${url_get_token}     Replace String      ${url_get_token_schema}    _code_    ${CODE}    
    Set Test Variable    ${URL_GET_TOKEN}    ${url_get_token}

Get Code From Authentication
    ${url_authentication_access}    Get Url 
    ${code}    Split String         ${url_authentication_access}    =
    ${code}    Set Variable         ${code}[1]     
    Set Test Variable    ${CODE}    ${code}

Verify Text Access Token 
    ${message}            Get Text    //pre
    @{list_message}       Split String    ${message}    "
    Log Many              @{list_message}
    List Should Contain Value    ${list_message}    access_token
    List Should Contain Value    ${list_message}    id_token    

# Get Token From Text Access Token
#     ${token}    Split String    ${MESSAGE}      "
#     ${token}    Set Variable    ${token}[3]
#     Set Test Variable    ${TOKEN}    ${token}       

Open Browser And Login 
    Open Browser                  ${url_authentication}    ${default_browser}   
    Fill Username And Password    ${username}              ${password}    
    Press Login Button
































































































































































































































































































# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Fill Username And Password
    [Documentation]    Owner: Nakarin
    ...    Recieve Arguments Username and Password 
    ...    Then fill it into text username and password text box
    [Arguments]  ${user}    ${pass}
    [Tags]    keyword_communicate
    Fill Text    ${txt_username}    ${user}
    Fill Text    ${txt_password}    ${pass}

Press Login Button
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_communicate
    Click    ${btn_login}

Verify Login Fail
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_communicate
    Verify Value At Locator    ${lbl_error_title}      ${error_title}
    Verify Value At Locator    ${lbl_error_message}    ${error_message}
    Take Screenshot At Verify Point    Fail Login Message
