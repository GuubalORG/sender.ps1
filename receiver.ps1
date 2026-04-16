$csvUrl = "https://docs.google.com/spreadsheets/d/e/2PACX-1vQIPYiwOfljQWNUEeItV6Sww80oskcRcCK64RsI3amENG71MrSSBYZlkWVTDQxT8Ll55OPbjfaMcI7g/pub?gid=927750747&single=true&output=csv"

Write-Host "--- Cloud Chat Started (Press Ctrl+C to Exit) ---" -ForegroundColor Yellow

$lastCount = 0

while($true) {
    try {
        $rawText = Invoke-RestMethod -Uri $csvUrl -UseBasicParsing
        $data = $rawText | ConvertFrom-Csv
        
        if ($data.Count -gt $lastCount) {
            # 1. Get ONLY the truly new rows
            $newRows = $data | Select-Object -Skip $lastCount
            
            foreach ($row in $newRows) {
                # Map the headers (Note: Google Forms uses 'Marca temporal' if in Spanish, 
                # or 'Timestamp' if in English. Check your Sheet's Row 1!)
                $time = $row.Timestamp
                $user = $row.User
                $msg  = $row.Message

                Write-Host "[$time] " -NoNewline -ForegroundColor Gray
                Write-Host "${user}: " -NoNewline -ForegroundColor Cyan 
                Write-Host $msg
            }
            # 2. Update count AFTER the loop finishes
            $lastCount = $data.Count
        }
    } catch {
        Write-Warning "Checking for data..."
    }
    Start-Sleep -Seconds 5 
}
