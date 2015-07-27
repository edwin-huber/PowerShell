# SAMPLE CODE:
# Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
# PURPOSE. We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and 
# distribute the object code form of the Sample Code, provided that. You agree: (i) to not use Our name, logo, or
# trademarks to market Your software product in which the Sample Code is embedded; (ii) to include a valid copyright
# notice on Your software product in which the Sample Code is embedded; and (iii) to indemnify, hold harmless, and 
# defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or result
# from the use or distribution of the Sample Code  
# ################################
# This script moves all Exchange 2013 public folders in a particular PF MAILBOX
# designated as $sourceMailbox to a target mailbox designated as $targetMailbox
# There is minimal error checking, and the limits of this script have not yet
# been tested.
# The total number of folders is limited by the $FoldersToMove varaiable.
# This has not yet been tested with very high folder counts.
# Use at your own risk.

$targetMailbox = "PFMB2"
$sourceMailbox = "PFMB1" 
$FoldersToMove = 10

# Theoretically this could be extended to use a file based input:
[String[]]$FilterStrings = "mustermann", "mustermann2", "mustermann3"

write-host "Fetching folders from mailbox ... " $sourceMailbox

$FoldersInPFMailbox = Get-PublicFolder -Mailbox $sourceMailbox -ResidentFolders -recurse 

# A hassle to use the List, but makes life easier in the long run
$PFid = new-object Microsoft.Exchange.Configuration.Tasks.PublicFolderIdParameter
$Type = [Type] $PFid.GetType()
$base = [System.Collections.Generic.List``1]
$PFidList = $base.MakeGenericType(@($Type))
$ListO = [Activator]::CreateInstance($PFidList)


# We need a filter to remove folders that are corrupt or causing problems



$i = 0
write-host "Adding folders to list..."

foreach($a in $FoldersInPFMailbox)
{
  
  if($i -lt $FoldersToMove )
  {
    
	# Check to be sure that the folder is valid
    if($a.Identity.ToString().Length -gt 1)
    {
		# reset the filter match
		$filtermatch = $false
		#Check to make sure that ID does not match one of the filter list
		foreach($filterEntry in $FilterStrings)
		{	
			if($a.Identity.ToString().ToLower().Contains($filterEntry.ToLower()))
			{
				write-host $a.Identity.ToString() " matched filter entry " $filterEntry.ToLower()
				$filtermatch = $true
			}
		}
		
		if($filtermatch)
		{
			write-host "Not Adding " $a.Identity.ToString()
		}
		else
		{
			write-host "Adding" $a.Identity.ToString()
			$ListO.Add($a.Identity.ToString())
		}
       
    }
    else
    {
       write-host "Not Adding " $a.Identity.ToString()
    }
  
  }
 $i++

}

write-host "Moving this many folders..."
write-host $ListO.Count

write-host "Creating move request for all folders in " $sourceMailbox " to " $targetMailbox



if ($ListO.Count -gt 0)
{
  read-host "Press any key to continue, ctrl + C to exit without making changes"
  # Turn the List into an array
  [Microsoft.Exchange.Configuration.Tasks.PublicFolderIdParameter[]] $array = $ListO.ToArray() 

  New-PublicFolderMoveRequest -Folders $array -TargetMailbox $targetMailbox
}
else
{
  write-host "No non-system folders found to move..."
}

# The End
