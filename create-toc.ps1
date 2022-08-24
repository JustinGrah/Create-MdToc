function Get-MarkdownToc {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Indent = "  ",        
        [Parameter()]
        [switch]
        $IncludeTitles
    )  
    
    $Path = Read-Host -Prompt "Please enter the path to the Markdown file"

    #Check if the path is present
    if(Test-Path -Path $Path) {
        $Content = Get-Content -Path $Path

        #Check if the file is valid
        if($Content.Length -gt 1) {
            #Print message that we are now generating the TOC
            Write-Host -ForegroundColor Green "Here is your TOC: ( Do not wonder, the items will enumerate themselfes in Markdown ;) )"

            foreach ($Line in $Content) {
                $TocLine = ""
                #When line starts with "#" we know that this is a heading line
                if($Line -like "#*") {
                    $TmpLine = $Line.Split('#')
                    
                    #Calculate indent level based on "#"
                    $IndentLevel = $TmpLine.length - 1
                    
                    #Our first Heading of the page will always be # - Check if we should include it or not
                    if($IncludeTitles) {
                        $IndentLevel += 1
                    } elseif ($IndentLevel -lt 2) {continue}

                    if($IndentLevel -gt 2) {
                        for($i = 0; $i -lt $IndentLevel; $i++) {
                            $TocLine += $Indent
                        }
                    }
                    
                    $TmpLine = ($TmpLine[-1].Trim()) -replace "([\s]+$)|([#\*])|(\<\w+\>)"
                    $TocLine += ("1. [" + $TmpLine + "](" + ($TmpLine -replace "[#?\{\[\(\)\]\}\'\/]").Replace(" ","-").ToLower() + ")")
                    Write-Host $TocLine
                }
            }
        } else {
            Write-Warning ("Inavlid file size. File has to be larger than 1. File Size: " + $Content.Length)
        }
    } else {
        Write-Warning ("Invalid Path: " + $Path)
    }
}

Get-MarkdownToc