
<cfscript>
	runtime = CreateObject("java","java.lang.Runtime").getRuntime();
	totalMemory = runtime.totalMemory() / 1024 / 1024;//currently in use
</cfscript>

<cfset runtime = CreateObject("java","java.lang.Runtime").getRuntime()>
<cfset freeMemory = runtime.freeMemory() / 1024 / 1024>
<cfset totalMemory = runtime.totalMemory() / 1024 / 1024>
<cfset maxMemory = runtime.maxMemory() / 1024 / 1024>
<cfset usedMemory =  (runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024>

<cfoutput>
    Used Memory: #Round(usedMemory)#mb<br>
    Free Allocated Memory: #Round(freeMemory)#mb<br>
    Total Memory Allocated: #Round(totalMemory)#mb<br>
    Max Memory Available to JVM: #Round(maxMemory)#mb<br>
</cfoutput>


<cfset percentFreeAllocated = Round((freeMemory / totalMemory) * 100)>
<cfset percentAllocated = Round((totalMemory / maxMemory ) * 100)>
<cfoutput>
    % of Free Allocated Memory: #percentFreeAllocated#%<br>
    % of Available Memory Allocated: #percentAllocated#%<br>
</cfoutput>

<cfset clear = runtime.gc()> 

<!---


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml"> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> 
<title>Untitled Document</title> 
</head> 
 
<script type="text/javascript"> 
// The function that starts the progress bar, 
// called when the user clicks the Send comment button. 
function startProgress() { 
ColdFusion.ProgressBar.start("mydataProgressbar"); 
}; 
 
// The function called when the progress bar finishes, 
// specified by the cfprogressbar tag onComplete attribute. 
function onfinish() { 
alert("Done"); 
}; 
</script> 
 
<body> 
<!--- Ensure there is no Session.STATUS value, which is used by 
the progress bar bind CFC, when the page displays. --->
<cfif IsDefined("Session.STATUS")> 
<cfscript> 
StructDelete(Session,"STATUS"); 
</cfscript> 
</cfif> 

<cfset _mycfc = createObject("component", "crc.Componentes.common.CRCProgress")>
<cfdump  var="#_mycfc#">

<!--- For code simplicity, formatting is minimal. --->
<cfform name="kitform"> 
<p>To make our service better and to benefit from our special offers, 
take a moment to give us your email address and send us a comment.</p> 
<p>Name: 
&nbsp;<cfinput type="text" name="name"> </p> 
<p>E-mail: 
&nbsp;<cfinput type="text" name="email"> </p> 
<p>Comment: 
&nbsp;<cftextarea name="cmnt"/></p> 
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
<cfinput type="button" name="" value="Send Comment"
onClick=startProgress()></p> 
<!--- The progressbar control --->
<div style="padding-left:3px" > 
<cfprogressbar name="mydataProgressbar"
bind="cfc:mycfc.getstatus()"
interval="1700"
width="200"
oncomplete="onfinish"/> 
</div> 
 
</cfform> 
</body> 
</html>
--->
<!---

 <cfinvoke 	webservice="http://192.168.2.236/Economik/ServiciosWCF_Api/WCFFacturacion.svc?wsdl" 
			method="Obtener_Datos_Ticket_Api" 
			returnvariable="ticket">
	<cfinvokeargument name="Emp_id" value = "1"/>
	<cfinvokeargument name="TipoDoc_id" value = "1"/>
	<cfinvokeargument name="Suc_Id" value = "1"/>
	<cfinvokeargument name="Caja_Id" value = "1"/>
	<cfinvokeargument name="CadenaId" value = "1"/>
	<cfinvokeargument name="Factura_Id" value = "5011"/>
</cfinvoke>

<cf_dump var="#ticket#"> --->
