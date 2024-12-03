*** Settings ***
Library     SeleniumLibrary
Library     String


*** Variables ***
${URL}          https://showdownspace-rpa-challenge.vercel.app/challenge-hunting-fed83d58/
${BROWSER}      chrome


*** Test Cases ***
01 : Hunting
    Open Browser    ${URL}    browser=${BROWSER}    options=add_argument("--ignore-certificate-errors")
    Wait Until Element Is Visible    xpath=//*[@id="root"]/div/div[1]/button
    Click Element    xpath=//*[@id="root"]/div/div[1]/button
    ### start challenge ###
    ${cue_1}    Get Text    xpath=//*[@id="root"]/div/div/div[2]/div/div[1]/span[1]
    ${cue_2}    Get Text    xpath=//*[@id="root"]/div/div/div[2]/div/div[1]/span[2]
    ${cue_3}    Get Text    xpath=//*[@id="root"]/div/div/div[2]/div/div[1]/span[3]
    ${cue_4}    Get Text    xpath=//*[@id="root"]/div/div/div[2]/div/div[1]/span[4]
    ${cue_5}    Get Text    xpath=//*[@id="root"]/div/div/div[2]/div/div[1]/span[5]
    @{all_cue}    Create List    ${cue_1}    ${cue_2}    ${cue_3}    ${cue_4}    ${cue_5}
    @{all_box}    Get WebElements    xpath=//*[@id="root"]/div/div/div[2]/div/div[2]/div
    ${count}    Set Variable    ${0}
    FOR    ${box}    IN    @{all_box}
        Mouse Over    ${box}
        Wait Until Element Is Visible    xpath=/html/body/div[3]
        ${box_cue}    Get Text    xpath=/html/body/div[3]
        FOR    ${cue}    IN    @{all_cue}
            ${result}    Run Keyword And Return Status    Should Be Equal As Strings    ${box_cue}    ${cue}
            IF    ${result}
                Click Element    ${box}
                ${count}    Evaluate    ${count} + 1
                IF    ${count} == ${5}
                    Wait Until Element Is Visible    xpath=//*[@id="root"]/div/div/div
                    Pass Execution    Found all box
                ELSE
                    CONTINUE
                END
            END
        END
    END
