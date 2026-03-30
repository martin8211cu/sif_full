<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Ejecutar tarea</title>
</head>

<body>

<cfoutput>
<center>
#Now()#

<cfif IsDefined('form.programar')>
	Reprogramando...<br><br>
	<cfinclude template="/sif/tasks/schedule.cfm">
<cfelse>
	Ejecutando #HTMLEditFormat(form.task_name_sel)#...<br><br>
	<cfscript>
		factory = CreateObject("java", "coldfusion.server.ServiceFactory");
		rs = factory.getCronService();
		aTasks = duplicate(rs.listAll());
	
		stTasks = structNew();
		for (i=1; i lte arrayLen(aTasks); i=i+1) { stTasks[i] = aTasks[i]; }
		aSortedKeys = structSort(stTasks, "textnocase", "asc", "task");
	</cfscript>
	<cfloop from="1" to="#ArrayLen(aSortedKeys)#" index="x">
		<cfset task = aTasks[aSortedKeys[x]]>
		<cfif task.task is form.task_name_sel>
			<cfhttp url="#task.url#"></cfhttp>
			<cfoutput>#cfhttp.statuscode#<hr>
			#cfhttp.filecontent#<hr></cfoutput>
		</cfif>
	</cfloop>
</cfif>

#Now()#
Terminado.<br><br>


[ <a href="javascript:window.close()"> &times; cerrar </a> ]<br>

</center>
</cfoutput>

</body>
</html>
