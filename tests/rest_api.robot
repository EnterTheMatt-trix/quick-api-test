*** Settings ***
Documentation                   Example / template for REST API automation
Library                         RequestsLibrary
Library                         DateTime
Library                         Collections
Resource                        ../resources/common.resource


*** Variables ***
${ISBN_10}                      0201558025
${EXPECTED_TITLE}               Concrete mathematics
${EXPECTED_YEAR}                1994
${EXPECTED_AUTHOR}              Ronald L. Graham


*** Test Cases ***
Verify Book Details
    [Documentation]             Verify book details using the Open Library Search API (https://openlibrary.org/search.json)
    [Tags]                      GET
    &{headers}=                 Create Dictionary    User-Agent=quick-api-test (example@example.com)
    Create Session              openlibrary          https://openlibrary.org    headers=${headers}

    &{params}=                  Create Dictionary
    ...                         q=isbn:${ISBN_10}
    ...                         fields=title,author_name,publish_year,isbn
    ...                         limit=5

    ${resp}=                    GET On Session       openlibrary    /search.json    params=${params}
    Should Be Equal As Strings  ${resp.status_code}    200
    Log                         ${resp.text}

    ${book_info}=               Get Book From Search Results By Isbn    ${resp.text}    ${ISBN_10}
    ${title}=                   Get From Dictionary    ${book_info}    title
    ${authors}=                 Get From Dictionary    ${book_info}    author_name
    ${publish_years}=           Get From Dictionary    ${book_info}    publish_year
    ${main_author}=             Get From List          ${authors}      0

    Should Be Equal As Strings  ${title}    ${EXPECTED_TITLE}
    Should Be Equal As Strings  ${main_author}    ${EXPECTED_AUTHOR}
    List Should Contain Value   ${publish_years}    ${EXPECTED_YEAR}

Verify Unix Timestamp
    [Documentation]             POST example - get date based on Unix timestamp (https://unixtime.co.za/)
    [Tags]                      POST
    Create Session              unixtimestamp    https://showcase.api.linx.twenty57.net/UnixTime

    &{body}=                    Create Dictionary    UnixTimeStamp=1987654321    Timezone=+3

    ${resp}=                    POST On Session    unixtimestamp    /fromunixtimestamp    json=${body}
    Should Be Equal As Strings  ${resp.status_code}    200
    Log                         ${resp.text}

    ${resp_date}=               Get Field Value From Json    ${resp.text}    Datetime
    ${date}=                    Convert Date    ${resp_date}    exclude_millis=yes    result_format=%d.%m.%Y %H:%M
    Should Be Equal             ${date}    26.12.2032 09:12
