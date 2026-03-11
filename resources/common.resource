*** Settings ***
Library                Collections


*** Keywords ***
Get Field Value From Json
    [Documentation]    Return a top-level field value from a JSON object.
    [Arguments]        ${json}    ${field_name}
    ${object}=         Evaluate    json.loads(r'''${json}''')    modules=json
    Log                ${object}
    ${field_value}=    Get From Dictionary    ${object}    ${field_name}
    [Return]           ${field_value}

Get Book From Search Results By Isbn
    [Documentation]    Return the first search result document that contains the given ISBN.
    [Arguments]        ${json}    ${isbn}
    ${book}=           Evaluate    next((doc for doc in json.loads(r'''${json}''').get("docs", []) if r'''${isbn}''' in doc.get("isbn", [])), None)    modules=json
    Should Not Be Equal    ${book}    ${None}
    [Return]           ${book}
