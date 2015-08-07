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

# In Exchange 2013 due to the changes in the way access to mailboxes is managed
# and how the CAS role is now used: Test-* cmdlets can only be used against a session
# that is local to the Mailbox server role in the case that a DAG member holds the
# passive copy of the database containing the extest mailbox.

# This script could be started from regular powershell if an additional connect is added at the start

# The ExTest account is best hard coded to avoid querying the whole AD every time
$TestMbx = get-mailbox extest_28f54c5e457c4

# Determine the DB which holds the test mbx
$TestDB = Get-MailboxDatabase $TestMbx.Database

# connect to the server holding the active copy of DB
$TestUri = "http://" + $TestDb.Server + "/powershell/"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $TestUri -Authentication Kerberos -AllowRedirection

Import-PSSession $Session -AllowClobber

# Now Enjoy running the Test-CmdLets

# As an alternative to the Test-* Cmdlets please consider:
# get-exchangeserver | Get-ServerHealth | where { $_.AlertValue -like 'unhealthy' }
# or similar...