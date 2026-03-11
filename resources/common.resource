*** Settings ***
Library                Collections


*** Keywords ***
Response Should Contain Title
    [Documentation]    Verify that at least one returned title contains the expected text.
    [Arguments]        ${json}    ${expected_title}
    ${matching_title}=    Evaluate    next((doc.get("title", "") for doc in json.loads(r'''${json}''').get("docs", []) if r'''${expected_title}'''.lower() in doc.get("title", "").lower()), None)    modules=json
    Should Not Be Equal    ${matching_title}    ${None}
