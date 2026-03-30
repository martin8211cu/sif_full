<cfschedule 
	action="delete" 
	task="Afiliacion"
	url="http://localhost/cfmx/sif/tasks/Afiliacion.cfm"
	interval="120"
	operation="httprequest"
	startdate="08/08/2003"
	starttime="12:00:00 PM"> 
El proceso de afiliacion ha sido desprogramado.<br>
<!--- 	--->
<cfset started = Now()>
<!---
<cfinclude template="../framework/tasks/task-expeditoAll.cfm">
--->
<cfset finished = Now()>
<cfoutput>Duracion: #DateDiff("s", started, finished)# s</cfoutput>
