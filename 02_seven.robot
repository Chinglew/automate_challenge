*** Settings ***
Library     SeleniumLibrary
Library     String
Library     DateTime
Library     Collections
Library     re
Library     JSONLibrary


*** Variables ***
${URL}                  https://lemon-meadow-0c732f100.5.azurestaticapps.net/ssg
${BROWSER}              chrome
${segment_header}       xpath=//*[@id="app"]/main/div[1]/div[2]/div/div/div[
${segment_a}            ]/div[1]
${segment_f}            ]/div[2]
${segment_b}            ]/div[3]
${segment_g}            ]/div[4]
${segment_e}            ]/div[5]
${segment_c}            ]/div[6]
${segment_d}            ]/div[7]

@{one}                  ${segment_b}
...                     ${segment_c}
@{two}                  ${segment_a}
...                     ${segment_b}
...                     ${segment_g}
...                     ${segment_e}
...                     ${segment_d}
@{tree}                 ${segment_a}
...                     ${segment_b}
...                     ${segment_c}
...                     ${segment_d}
...                     ${segment_g}
@{four}                 ${segment_b}
...                     ${segment_c}
...                     ${segment_f}
...                     ${segment_g}
@{five}
...                     ${segment_a}
...                     ${segment_c}
...                     ${segment_d}
...                     ${segment_f}
...                     ${segment_g}
@{six}
...                     ${segment_a}
...                     ${segment_c}
...                     ${segment_d}
...                     ${segment_e}
...                     ${segment_f}
...                     ${segment_g}
@{seven}                ${segment_a}
...                     ${segment_b}
...                     ${segment_c}
@{eight}
...                     ${segment_a}
...                     ${segment_b}
...                     ${segment_c}
...                     ${segment_d}
...                     ${segment_e}
...                     ${segment_f}
...                     ${segment_g}
@{nine}
...                     ${segment_a}
...                     ${segment_b}
...                     ${segment_c}
...                     ${segment_d}
...                     ${segment_f}
...                     ${segment_g}
@{zero}
...                     ${segment_a}
...                     ${segment_b}
...                     ${segment_c}
...                     ${segment_d}
...                     ${segment_e}
...                     ${segment_f}

&{number_list}          1=@{one}
...                     2=@{two}
...                     3=@{tree}
...                     4=@{four}
...                     5=@{five}
...                     6=@{six}
...                     7=@{seven}
...                     8=@{eight}
...                     9=@{nine}
...                     0=@{zero}


*** Test Cases ***
02 : seven
    Open Browser    ${URL}    browser=${BROWSER}    options=add_argument("--ignore-certificate-errors")
    Wait Until Element Is Visible    xpath=//*[@id="app"]/main/div[1]/div[1]/div
    ${answer}=    Get Text    xpath=//*[@id="app"]/main/div[1]/div[1]/div
    @{segment}=    Get WebElements    xpath=//*[@id="app"]/main/div[1]/div[2]/div/div/div
    Log To Console    ${answer}
    FOR    ${counter}    IN RANGE    0    6
        ${number_set}=    Get From Dictionary    ${number_list}    ${answer}[${counter}]
        FOR    ${each_number}    IN    @{number_set}
            ${array_locator}=    Evaluate    ${counter}+1
            ${segment_locator}=    Catenate
            ...    SEPARATOR=
            ...    ${segment_header}
            ...    ${array_locator}
            ...    ${each_number}
            Wait Until Element Is Enabled    ${segment_locator}
            Click Element    ${segment_locator}
        END
    END
    Element Should Be Visible    xpath=//*[@id="app"]/main/div[2]/p[2]
    Capture Element Screenshot    xpath=//*[@id="app"]/main/div[2]/p[2]
