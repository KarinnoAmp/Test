*** Settings ***
Resource    ../../TestSuite/Resource_init.robot


*** Keywords ***
Set Content API Header
    [Documentation]    Owner: Nakarin
    ...    Receive [Argument] key and value or append=True to Used in ${API_HEADER}
    ...    append Use for append new key and value in to ${API_HEADER} 
    [Tags]    keyword_command
    [Arguments]    ${key}    ${value}    ${append}=True
    ${status}    Run Keyword And Return Status    Variable Should Exist    ${API_HEADER}
    IF  ${status} == True and ${append} == True
        ${header}    Set Variable    ${API_HEADER}
    ELSE
        ${header}    Create Dictionary
    END
    Set To Dictionary    ${header}    ${key}=${value}
    Log    ${header}
    Set Test Variable    ${API_HEADER}    ${header}

Get API Body From Json File 
    [Documentation]    Owner: Nakarin
    ...    Get json file and convert in to object type then return ${json_object}
    [Tags]    keyword_command
    [Arguments]    ${path}
    ${json_string}    OperatingSystem.Get File             ${path}
    ${json_object}    Convert Variable Type To Dot Dict    ${json_string}
    # Check Variable Type    ${json_object}
    Log    ${json_object}
    [Return]    ${json_object}

Set API Header Login By Client Credential
    [Documentation]    Owner: Nakarin
    ...    Set API Header for send request of Client Credential
    [Tags]    keyword_communicate
    Set Content API Header    key=Content-Type    value=application/json    append=False
    Set Content API Header    key=X-Tid           value=login by client credentials
    Log    ${API_HEADER}
    # Check Variable Type    ${API_HEADER}

Set API Body Login By Client Credential
    [Documentation]    Owner: Nakarin
    ...    Set API Body for send request of Client Credential
    [Tags]    keyword_communicate
    Get Time Nonce
    ${json}    Get API Body From Json File        ${body_validate_token_schema}
    Set To Dictionary    ${json}        client_id=${client_id_OhFw3u_browser}
    Set To Dictionary    ${json.token}      value=${ACCESS_TOKEN_CLIENTCREDENTIAL}
    Set To Dictionary    ${json}            nonce=${DATE_TIME}
    Log    ${json}
    ${json_string}    Convert To String    ${json}
    ${json_string}    Replace String     ${json_string}    '    "
    ${json_string}    Remove String      ${json_string}    \n
    Log    ${json_string}
    Set Test Variable    ${API_BODY}     ${json_string}
    # ${json_string}    OperatingSystem.Get File    ${body_validate_token_schema}
    # ${json_string}    Remove String    ${json_string}    \n
    # Check Variable Type    ${json_string}
    # Set Test Variable    ${API_BODY}    ${json_string}
    # Set Test Variable    ${API_BODY}    ${json_string_var}
    # Set Body Validate Token Test    client_id=${client_id_OhFw3u_browser}    value=${ACCESS_TOKEN_CLIENTCREDENTIAL}    nonce=1234567890
    # ${json_string}    Convert To String    ${json}
    # ${string}    Remove String    ${json_string}    ${\n}
    # Set Test Variable    ${API_BODY}    ${json}

Send Post Request Validate Token
    [Documentation]    Owner: Nakarin
    ...    Send Post request 
    [Tags]    keyword_communicate
    ${message}    Send Request    POST    ${url_validate_token}    headers=${API_HEADER}    body=${API_BODY}
    Set Test Provisioning Data    ${message}
    # Set Test Actual Result    URL: ${RESPONSE.url}
    # Set Test Actual Result    HEADERS: ${RESPONSE.headers}
    # Set Test Actual Result    BODY: ${RESPONSE.json()}
    
Get Access Token ClientCredential
    [Documentation]    Editor: Nakarin
    ...    Get Access Token of Client Credential then Set Test Variable ${ACCESS_TOKEN_CLIENTCREDENTIAL}
    [Tags]    keyword_communicate
    Set Content Header Client Credentials    ${url_client_credentials_${test_site}}
    ...                                      ${content_type_x_www}
    Set Body Client Credentials    ${client_id_OhFw3u_browser}
    ...                            ${client_secret_id_OhFw3u_browser}
    ...                            ${grant_type}
    ...                            ${nonce}
    Send Request Client Credentials
    Log    ${RESPONSE.json()}[access_token]
    Set Test Variable    ${ACCESS_TOKEN_CLIENTCREDENTIAL}    ${RESPONSE.json()}[access_token]

Set Body Validate Token Test
    [Documentation]     Owner : sasipen
    ...    Set client id,grant type, nonce to formate body
    [Arguments]              ${client_id}      ${value}    ${nonce}
    ${body_client_id}        Replace String    ${API_BODY}          _client_id_    ${client_id}
    ${body_value}            Replace String    ${body_client_id}    _value_        ${value}
    ${body_api}              Replace String    ${body_value}        _nonce_        ${nonce}
    Log    ${body_api}
    Set Test Variable        ${API_BODY}       ${body_api}

Fill FBB Username 
    [Documentation]    Owner: Nakarin
    # Fill Text    ${txt_fbb_user}    ${fbb_user}
    Type Text    ${txt_fbb_user}    ${fbb_user}    delay=0.1s

Click Request OTP
    [Documentation]    Owner: Nakarin
    Click    ${btn_fbb_request_otp}
    Wait Until Network Is Idle

Fill FBB OTP Password
    [Documentation]    Owner: Nakarin
    ...    Website can detect character while typing
    # Fill Text    ${txt_fbb_pass}    ${FBB_OTP_PASS}
    Type Text    ${txt_fbb_pass}    ${FBB_OTP_PASS}    delay=0.1s

Press Login Button
    [Documentation]    Owner: Nakarin
    Click    ${btn_fbb_login}
    Wait Until Network Is Idle

Get FBB OTP
    [Documentation]    Owner: Nakarin
    ...    Get OTP Password From Server Log
    ...    Then Set Test Variable ${FBB_OTP_PASS}
    SSH Connect To 10.137.30.22
    ${server_log}        Get Json Log FBB OTP
    ${otp_password}      Get OTP From Json    ${server_log}
    Set Test Variable    ${FBB_OTP_PASS}    ${otp_password}

Get Json Log FBB OTP
    [Documentation]    Owner: Nakarin
    Write    kubectl exec -it ${admd_path} -n admd sh
    Write    cd logs/detail/
    ${mobile_number}    Replace String    ${fbb_user}    0    66    count=1
    Write    cat ${admd_path}_admd.0.detail | grep -E "${mobile_number}.*oneTimePassword"
    ${string}   Read    delay=1s
    ${json_format}    Get Regexp Matches        ${string}    {.*
    Log Many    @{json_format}
    ${json_expect}    Convert String To JSON    ${json_format}[0]
    Log         ${json_expect}
    [Return]    ${json_expect}

Verify Response Success Login Client Credentials
    [Documentation]    Owner: Nakarin
    Verify Value Response By Key    result_code          ${expected_result_code_pass}
    Verify Value Response By Key    developer_message    ${expected_develope_message_pass}
    Append Response Value To Actual Document











































































































































































































Set Content API Body
    [Documentation]    Owner: Nakarin
    ...    Receive [Argument] key and value or append=True to Used in ${API_HEADER}
    ...    append Use for append new key and value in to ${API_HEADER} 
    [Tags]    keyword_command
    [Arguments]    ${key}    ${value}    ${append}=True
    ${status}    Run Keyword And Return Status    Variable Should Exist    ${API_BODY}
    IF  ${status} == True and ${append} == True
        ${body}    Set Variable    ${API_BODY}
    ELSE
        ${body}    Create Dictionary
    END
    Set To Dictionary    ${body}   ${key}=${value}
    Log    ${body}
    Set Test Variable    ${API_BODY}   ${body}

Set API Header Request Otp Validate Token
    [Documentation]    Owner: sasipen
    [Tags]    keyword_communicate
    Set Content API Header    key=${header_content_type}    value=${content_type_json}
    Log    ${API_HEADER}
    Set Test Provisioning Data    Header Request OTP : ${API_HEADER}
    #Check Variable Type    ${API_HEADER}

Set API Body Request Otp Validate Token
    [Documentation]    Owner: sasipen
    [Tags]    keyword_communicate
    # Set Content API Body    key=client_id    value=${client_id_request_otp_validate_token} 
    # Set Content API Body    key=public_id    value=${public_id_request_otp_validate_token}    
    # Set Content API Body    key=reference    value=${reference}  
    ${json}    Get API Body From Json File        ${body_request_otp_validate_token_schema}
    Set To Dictionary    ${json}                  client_id=${client_id_request_otp_validate_token}
    Set To Dictionary    ${json}                  public_id=${public_id_request_otp_validate_token} 
    Set To Dictionary    ${json}                  reference=${reference}  
    Log    ${json}
    ${json_string}    Convert To String    ${json}
    ${json_string}    Replace String    ${json_string}    '    "
    ${json_string}    Remove String     ${json_string}    \n
    Log    ${json_string}
    Set Test Variable    ${API_BODY}    ${json_string}
    Set Test Provisioning Data    Body Request OTP : ${API_BODY} 
Send Post Request Otp Validate Token 
    [Documentation]    Owner: sasipen
    [Tags]    keyword_communicate
    Send Request    POST    ${url_request_otp_validate_token}    headers=${API_HEADER}    body=${API_BODY}
    Set Test Actual Result    Request OTP :\r\n${RESPONSE.json()}
Set API Header Get Token Validate Token
    [Documentation]    Owner: sasipen
    [Tags]    keyword_communicate
    Set Content API Header    key=${header_content_type}    value=${content_type_x_www}    append=False
    Log    ${API_HEADER}
    Set Test Provisioning Data    Header Get Token : ${API_HEADER}
    #Check Variable Type    ${API_HEADER}

Set API Body Get Token Validate Token
    [Documentation]    Owner: sasipen
    [Tags]    keyword_communicate
    ${json}    Get API Body From Json File        ${body_get_token_validate_token_schema}
    Set To Dictionary    ${json}                  client_id=${client_id_request_otp_validate_token} 
    Set To Dictionary    ${json}                  client_secret=${client_secret_get_token_validate_token}     
    Set To Dictionary    ${json}                  grant_type=${grant_type_validate_token}     
    Set To Dictionary    ${json}                  username=${public_id_request_otp_validate_token}    
    Set To Dictionary    ${json}                  password=${EMAIL_OTP_PASSWORD}     
    Set To Dictionary    ${json}                  type=${type_get_token_validate_token}    
    Set To Dictionary    ${json}                  scope=${scope_get_token_validate_token}  
    Set To Dictionary    ${json}                  session_id=${ACTUAL_VALUE_SESSION_ID}  
    Set To Dictionary    ${json}                  transaction_id=${ACTUAL_VALUE_TRANSACTION_ID} 
    Log    ${json}
    ${json_string}    Convert To String    ${json}
    ${json_string}    Replace String    ${json_string}    '    "
    ${json_string}    Remove String    ${json_string}    \n
    Log    ${json_string}
    Set Test Variable    ${API_BODY}    ${json_string}
    Set Test Provisioning Data    Body Get Token : ${API_BODY}
Send Post Request Get Token Validate Token 
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_communicate
    Send Request    POST    ${url_get_token_validate_token}    headers=${API_HEADER}    body=${API_BODY}
    Set Test Actual Result    Get Token :\r\n${RESPONSE.json()}
Get Value Response Get Token By Key Access Token
    ${value_access_token}    Get Value Response By Key     access_token
    Set Test Variable    ${ACTUAL_VALUE_ACCESS_TOKEN}      ${value_access_token}

Set API Header Delete Sub Scriber
    [Documentation]    Owner: sasipen
    [Tags]    keyword_communicate
    Set Content API Header    key=${header_content_type}    value=${content_type_json}    append=False
    Log    ${API_HEADER}
    #Check Variable Type    ${API_HEADER}
    Set Test Provisioning Data    Header Delete Sub Scriber : ${API_HEADER}
Set API Body Delete Sub Scriber
    [Documentation]    Owner: Nakarin
    ...    Set API Body for send request of Client Credential
    [Tags]    keyword_communicate
    ${json}    Get API Body From Json File   ${body_delete_sub_scriber_schema} 
    Set To Dictionary    ${json}              msisdn=${public_id_request_otp_validate_token}
    Log    ${json}
    ${json_string}    Convert To String    ${json}
    ${json_string}    Replace String       ${json_string}    '    "
    ${json_string}    Remove String        ${json_string}    \n
    Log    ${json_string}
    Set Test Variable    ${API_BODY}    ${json_string}
    Set Test Provisioning Data    Body Delete Sub Scriber : ${API_BODY}
Send Post Request Delete Sub Scriber
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_communicate
    Send Request    POST    ${url_delete_sub_scriber}    headers=${API_HEADER}    body=${API_BODY}
    Set Test Actual Result    Delete Sub Scriber :\r\n${RESPONSE.json()}
Set API Header Validate Token
    [Documentation]    Owner: Nakarin
    ...    Set API Header for send request of Client Credential
    [Tags]    keyword_communicate
    Set Content API Header    key=${header_content_type}   value=${content_type_json}    append=False
    Set Content API Header    key=${header_x_tid}          value=validate_2
    Log    ${API_HEADER}
    Set Test Provisioning Data    Header Validate Token : ${API_HEADER}
Set API Body Validate Token
    [Documentation]    Owner: Nakarin
    ...    Set API Body for send request of Client Credential
    [Tags]    keyword_communicate
    ${json}    Get API Body From Json File    ${body_validate_token_schema}
    Set To Dictionary    ${json}              client_id=${client_id_request_otp_validate_token}
    Set To Dictionary    ${json.token}        value=${ACTUAL_VALUE_ACCESS_TOKEN}
    Log    ${json}
    ${json_string}    Convert To String    ${json}
    ${json_string}    Replace String       ${json_string}    '    "
    ${json_string}    Remove String        ${json_string}    \n
    Log    ${json_string}
    Set Test Variable    ${API_BODY}    ${json_string}
    Set Test Provisioning Data    Body Validate Token : ${API_BODY}
Send Post Request Validate Token No Profile
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_communicate
    [Arguments]        ${status_code}
    Send Request    POST    ${url_validate_token}     headers=${API_HEADER}    body=${API_BODY}    expected_status=${status_code}
    Set Test Actual Result    Validate Token No Profile :\r\n${RESPONSE.json()}
Verify Response Validate Token No Profile 
    Verify Value Response By Key    result_code            ${expected_result_code_no_profile}
    Verify Value Response By Key    developer_message      ${error_message_subscriber_not_found}

Set API Header Validate Token Invalid Client Id
    [Documentation]    Owner: Nakarin
    ...    Set API Header for send request of Client Credential
    [Tags]    keyword_communicate
    Set Content API Header    key=${header_content_type}   value=${content_type_json}    append=False
    Set Content API Header    key=${header_x_tid}          value=login msisdn by grant type = password (nowebview)
    Log    ${API_HEADER}
    Set Test Provisioning Data    Header Validate Token Invalid Client Id : ${API_HEADER}
Set API Body Validate Token Invalid Client Id
    [Documentation]    Owner: Nakarin
    ...    Set API Body for send request of Client Credential
    [Tags]    keyword_communicate
    ${json}    Get API Body From Json File    ${body_validate_token_schema}
    Set To Dictionary    ${json}              client_id=${clientid_validate_token_invalid}
    Set To Dictionary    ${json.token}        value=${ACTUAL_VALUE_ACCESS_TOKEN}
    Log    ${json}
    ${json_string}    Convert To String    ${json}
    ${json_string}    Replace String       ${json_string}    '    "
    ${json_string}    Remove String        ${json_string}    \n
    Log    ${json_string}
    Set Test Variable    ${API_BODY}    ${json_string}
    Set Test Provisioning Data    Body Validate Token Invalid Client Id : ${API_BODY}

Send Post Request Validate Token Invalid Client Id
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_communicate
    [Arguments]        ${status_code}
    Send Request    POST    ${url_validate_token}     headers=${API_HEADER}    body=${API_BODY}    expected_status=${status_code}
    Set Test Actual Result    Validate Token Invalid Client Id :\r\n${RESPONSE.json()}
Verify Response Validate Token Invalid Client Id
    Verify Value Response By Key    result_code            ${expected_result_code_invalid_client_id}
    Verify Value Response By Key    developer_message      ${error_message_invalid_client} 

Set API Header Validate Token Invalid Access Token
    [Documentation]    Owner: Nakarin
    ...    Set API Header for send request of Client Credential
    [Tags]    keyword_communicate
    Set Content API Header    key=${header_content_type}   value=${content_type_json}    append=False
    Set Content API Header    key=${header_x_tid}          value=validate_2
    Log    ${API_HEADER}
    Set Test Provisioning Data    Header Validate Token Invalid Access Token : ${API_HEADER}

Set API Body Validate Token Invalid Access Token
    [Documentation]    Owner: Nakarin
    ...    Set API Body for send request of Client Credential
    [Tags]    keyword_communicate
    ${json}    Get API Body From Json File    ${body_validate_token_schema}
    Set To Dictionary    ${json}              client_id=${clientid_validate_token_invalid}
    Set To Dictionary    ${json.token}        value=${test}
    Log    ${json}
    ${json_string}    Convert To String    ${json}
    ${json_string}    Replace String       ${json_string}    '    "
    ${json_string}    Remove String        ${json_string}    \n
    Log    ${json_string}
    Set Test Variable    ${API_BODY}    ${json_string}
    Set Test Provisioning Data    Body Validate Token Invalid Access Token : ${API_BODY} 

Send Post Request Validate Token Invalid Access Token
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_communicate
    [Arguments]        ${status_code}
    Send Request    POST    ${url_validate_token}     headers=${API_HEADER}    body=${API_BODY}    expected_status=${status_code}
    Set Test Actual Result    Validate Token Invalid Access Token :\r\n${RESPONSE.json()}

Verify Response Validate Token Invalid Access Token
    Verify Value Response By Key    result_code            ${expected_result_code_invalid_access_token} 
    Verify Value Response By Key    developer_message      ${error_message_invalid_code}