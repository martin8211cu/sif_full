<h3>cfexecute</h3>
<p>This example executes the Windows NT version of the netstat network monitoring program, and places its output in a file.

<cfexecute name = "C:\WinNT\Notepad.exe otro.txt"
	arguments = "" 
	outputFile = ""
	timeout = "1">
</cfexecute>
