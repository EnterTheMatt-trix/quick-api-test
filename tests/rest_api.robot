*** Settings ***
Documentation                   Example / template for REST API automation
Library                         RequestsLibrary
Resource                        ../resources/common.resource


*** Variables ***
${SEARCH_QUERY}                 the lord of the rings
${EXPECTED_TITLE}               lord of the rings


*** Test Cases ***
Verify Search Returns Lord Of The Rings
    [Documentation]             Verify that Open Library search returns Lord of the Rings results.
    [Tags]                      GET
    &{headers}=                 Create Dictionary    User-Agent=quick-api-test (example@example.com)
    Create Session              openlibrary          https://openlibrary.org    headers=${headers}

    &{params}=                  Create Dictionary    q=${SEARCH_QUERY}

    ${resp}=                    GET On Session       openlibrary    /search.json    params=${params}
    Should Be Equal As Strings  ${resp.status_code}    200
    Log                         ${resp.text}

    Response Should Contain Title    ${resp.text}    ${EXPECTED_TITLE}
