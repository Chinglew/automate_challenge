*** Settings ***
Library             OperatingSystem
Library             Collections
Library             String
Library             SeleniumLibrary
Library             .venv/lib/python3.12/site-packages/AppiumLibrary/__init__.py

Test Setup          Open Browser    ${URL}    browser=${BROWSER}    options=add_argument("--ignore-certificate-errors")
Test Teardown       Sleep    30sec


*** Variables ***
${URL}                      https://showdownspace-rpa-challenge.vercel.app/challenge-robot-d34b4b04/
${BROWSER}                  chrome
${duplicate_article}        ${EMPTY}
&{incorrect_word_count}     &{EMPTY}
${wrong_size_article}       ${EMPTY}

${go_forward_btn}           xpath=//*[@id="wallInFront"]
${turn_left_btn}            xpath=//*[@id="root"]/div[1]/div/div[2]/div/div/div[2]/button[1]
${turn_right_btn}           xpath=//*[@id="root"]/div[1]/div/div[2]/div/div/div[2]/button[2]
${right_way_indicator}      xpath=//*[@id="wallToTheRight"]
${left_way_indicator}       xpath=//*[@id="wallToTheLeft"]


*** Test Cases ***
04 : robot
    Wait Until Element Is Visible    //*[@id="root"]/div/div[1]/button
    Click Element    //*[@id="root"]/div/div[1]/button
    Find the exit


*** Keywords ***
Find the exit
    Wait Until Element Is Visible    ${go_forward_btn}
    WHILE    ${True}
        ${complete_present}    Run Keyword And Return Status    Text Should Be Visible    Challenge completed!
        ${can_go}    Get Element Attribute    ${go_forward_btn}    data-state
        ${can_go_left}    Get Element Attribute    ${left_way_indicator}    data-state
        ${can_go_right}    Get Element Attribute    ${right_way_indicator}    data-state
        IF    '${can_go}' == 'absent'
            Go forward
            ${complete_present}    Run Keyword And Return Status    Text Should Be Visible    Challenge completed!
            IF    ${complete_present}    BREAK
            ${can_go_left}    Get Element Attribute    ${left_way_indicator}    data-state
            IF    '${can_go_left}' == 'absent'    Turn left
        ELSE
            ${complete_present}    Run Keyword And Return Status    Text Should Be Visible    Challenge completed!
            IF    ${complete_present}    BREAK
            ${can_go_left}    Get Element Attribute    ${left_way_indicator}    data-state
            ${can_go_right}    Get Element Attribute    ${right_way_indicator}    data-state
            IF    '${can_go_left}' == 'absent'
                Turn left
            ELSE IF    '${can_go_right}' == 'absent'
                Turn right
            ELSE
                U turn
            END
        END
    END

Go forward
    Click Element    ${go_forward_btn}

Turn left
    Click Element    ${turn_left_btn}

Turn right
    Click Element    ${turn_right_btn}

U turn
    Click Element    ${turn_right_btn}
    Click Element    ${turn_right_btn}
