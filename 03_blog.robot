*** Settings ***
Library     OperatingSystem
Library     Collections
Library     String
Library     SeleniumLibrary


*** Variables ***
${CSV_FILE}                 bacblog - Sheet1.tsv
&{article_dict}             &{EMPTY}
${URL}                      https://dtinth.github.io/bacblog/
${BROWSER}                  chrome
${duplicate_article}        ${EMPTY}
&{incorrect_word_count}     &{EMPTY}
${wrong_size_article}       ${EMPTY}


*** Test Cases ***
03 : blog
    Read CSV File
    Open Browser    ${URL}    browser=${BROWSER}    options=add_argument("--ignore-certificate-errors")
    FOR    ${page_counter}    IN RANGE    1    21
        Wait Until Element Is Visible    xpath=/html/body/main/div/div/p
        IF    ${page_counter} != ${1}
            Go To    url=https://dtinth.github.io/bacblog/page${page_counter}/
        END
        FOR    ${counter}    IN RANGE    1    16
            Wait Until Element Is Visible    xpath=/html/body/main/div/div/ul/li[${counter}]/h3/a
            ${temp_header}=    Get Text    xpath=/html/body/main/div/div/ul/li[${counter}]/h3/a
            Click Element    xpath=/html/body/main/div/div/ul/li[${counter}]/h3/a

            TRY
                ${articel_size}=    Get From Dictionary    ${article_dict}    ${temp_header}
            EXCEPT    AS    ${error}
                ${duplicate_article}=    Set Variable    ${temp_header}
                Remove From Dictionary    ${article_dict}    ${temp_header}
            ELSE
                Wait Until Element Is Visible    xpath=/html/body/main/div/article/div/p
                ${article_body}=    Get Text    xpath=/html/body/main/div/article/div/p
                @{words}=    Split String    ${article_body}    ${SPACE}
                ${world_count}=    Get Length    ${words}
                IF    ${world_count} != ${articel_size}
                    ${wrong_size_article}=    Set Variable    ${temp_header}
                END
                Remove From Dictionary    ${article_dict}    ${temp_header}
            END
            Go Back
        END
    END
    Log To Console    Duplicate:${duplicate_article}
    Log To Console    Missing:${article_dict}
    Log To Console    Wrong size:${wrong_size_article}


*** Keywords ***
Read CSV File
    ${content}=    Get File    ${CSV_FILE}
    @{rows}=    Split String    ${content}    \n

    FOR    ${row}    IN    @{rows}[1:]
        @{columns}=    Split String    ${row}    \t
        &{temp_dict}=    Create Dictionary    ${columns}[0]=${columns}[1]
        Set To Dictionary    ${article_dict}    &{temp_dict}
    END
