$formId = "1FAIpQLSfVRf1clm8OVNuLK-4DT6gmXmaA-xCZMnk1N3gTDNu0pk9lCQ"
$formUrl = "https://docs.google.com/forms/d/e/$formId/formResponse"

$scriptUrl = "https://script.google.com/macros/s/AKfycbz1328ehOB8mqUt5TTXWFqZohmigN_5M2qDYFv8etCtYMloSQ6rKXokIw1U8iM1JmU-kw/exec"


# Ask for your nickname once
$userName = Read-Host "Enter your nickname"

Write-Host "--- Chat Started! Type your message and hit Enter ---" -ForegroundColor Yellow

while ($true) {
    $msg = Read-Host "[$userName]"

    switch -Regex ($msg) {

        "^Del$" {
            Invoke-WebRequest -Uri "$scriptUrl?action=deleteLast&user=$userName" -Method Post
            Write-Host "Last message deleted." -ForegroundColor DarkYellow
            continue
        }

        "^Delete all$" {
            $confirm = Read-Host "Are you sure you want to delete the entire conversation?`n[Y] Yes I'm sure. [Enter]/[N] No."

            if ($confirm -eq "Y") {
                Invoke-WebRequest -Uri "$scriptUrl?action=deleteAll&user=$userName" -Method Post
                Write-Host "Conversation wiped." -ForegroundColor Red
            }
            else {
                Write-Host "Cancelled." -ForegroundColor Gray
            }
            continue
        }
    }

    if ($msg -eq "exit") { break }

    # Normal message --> send to Google Form
    $postBody = @{
        "entry.277539506" = $userName
        "entry.617062330" = $msg
    }

    try {
        Invoke-WebRequest -Uri $formUrl -Method Post -Body $postBody -ContentType "application/x-www-form-urlencoded"
        Write-Host "Sent." -ForegroundColor Gray
    }
    catch {
        Write-Host "Failed to send." -ForegroundColor Red
    }
}
