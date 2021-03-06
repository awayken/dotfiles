# Git functions
# Mark Embling (http://www.markembling.info/)
# http://markembling.info/2009/09/my-ideal-powershell-prompt-with-git-integration

# Is the current directory a git repository/working copy?
function isCurrentDirectoryGitRepository {
    if ((Test-Path ".git") -eq $TRUE) {
        return $TRUE
    }

    # Test within parent dirs
    $checkIn = (Get-Item .).parent
    while ($checkIn -ne $NULL) {
        $pathToTest = $checkIn.fullname + '/.git'
        if ((Test-Path $pathToTest) -eq $TRUE) {
            return $TRUE
        } else {
            $checkIn = $checkIn.parent
        }
    }

    return $FALSE
}

# Get the current branch
function gitBranchName {
    $currentBranch = ''
    git branch | foreach {
        if ($_ -match "^\* (.*)") {
            $currentBranch += $matches[1]
        }
    }
    return $currentBranch
}

# Extracts status details about the repo
function gitStatus {
    $untracked = $FALSE
    $added = 0
    $modified = 0
    $deleted = 0
    $ahead = ''
    $aheadCount = 0

    $output = git status

    $branchbits = $output[0].Split(' ')
    $branch = $branchbits[$branchbits.length - 1]

    $output | foreach {
        if ($_ -match "^\#.*is behind 'origin/.*' by (\d+) commit.*") {
            $aheadCount = $matches[1]
            $ahead = 'behind'
        }
        elseif ($_ -match "^\#.*is ahead of 'origin/.*' by (\d+) commit.*") {
            $aheadCount = $matches[1]
            $ahead = 'ahead'
        }
        elseif ($_ -match "deleted:") {
            $deleted += 1
        }
        elseif (($_ -match "modified:") -or ($_ -match "renamed:")) {
            $modified += 1
        }
        elseif ($_ -match "new file:") {
            $added += 1
        }
        elseif ($_ -match "Untracked files:") {
            $untracked = $TRUE
        }
    }

    return @{"untracked" = $untracked;
             "added" = $added;
             "modified" = $modified;
             "deleted" = $deleted;
             "ahead" = $ahead;
             "aheadCount" = $aheadCount;
             "branch" = $branch}
}
