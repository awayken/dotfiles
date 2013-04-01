# Alias
Set-Alias subl 'c:\program files\sublime text 2\sublime_text.exe'

# Displays git branch and stats when inside a git repository.
# http://markembling.info/2009/09/my-ideal-powershell-prompt-with-git-integration

. (Resolve-Path ~/Documents/WindowsPowershell/gitutils.ps1)

function prompt {
    $userLocation = $pwd
    $host.UI.RawUi.WindowTitle = $userLocation
    Write-Host($userLocation) -nonewline

    if (isCurrentDirectoryGitRepository) {
        $status = gitStatus
        $currentBranch = $status["branch"]

        Write-Host(' [') -nonewline
        Write-Host($currentBranch) -nonewline -foregroundcolor Yellow
        if ($status["ahead"] -eq 'ahead') {
            # We are ahead of origin
            Write-Host(' (ahead)') -nonewline -foregroundcolor Gray
        }
        elseif ($status["ahead"] -eq 'behind') {
            # We are behind origin
            Write-Host(' (behind)') -nonewline -foregroundcolor DarkGray
        }

        Write-Host(' +' + $status["added"]) -nonewline -foregroundcolor Green
        Write-Host(' ~' + $status["modified"]) -nonewline -foregroundcolor DarkGreen
        Write-Host(' -' + $status["deleted"]) -nonewline -foregroundcolor Red

        if ($status["untracked"] -ne $FALSE) {
            Write-Host(' ??') -nonewline -foregroundcolor Magenta
        }

        Write-Host(']>') -nonewline
    } else {
        Write-Host('>') -nonewline
    }

    return " "
}
