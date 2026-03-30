<cf_templateheader title="Tareas programadas"><cf_web_portlet_start titulo="Tareas programadas">
<cfinclude template="/home/menu/pNavegacion.cfm">


<cfscript>
    factory = CreateObject("java", "coldfusion.server.ServiceFactory");
	rs = factory.getCronService();
	aTasks = duplicate(rs.listAll());

	stTasks = structNew();
	for (i=1; i lte arrayLen(aTasks); i=i+1) { stTasks[i] = aTasks[i]; }
	aSortedKeys = structSort(stTasks, "textnocase", "asc", "task");
</cfscript>

<cfoutput><br>

<form action="exec.cfm" target="_blank" method="post" style="margin:0" name="form1">
<cfif ArrayLen(aSortedKeys) Is 0>
<table cellpadding="2" cellspacing="0" align="center">
<tr><td colspan="3">&nbsp;</td></tr>
<tr><td colspan="3" align="center">
	No hay tareas programadas.</td></tr>
<tr><td colspan="3">&nbsp;</td></tr>
<tr><td colspan="3" align="center">
	<input type="submit" name="programar" value="Programar tareas ahora"></form>
</td></tr>
</table>
<cfelse>
<table cellpadding="2" cellspacing="0" align="center">
<tr class="tituloListas"><td></td><td><strong>Tarea</strong></td><td><strong>Periodicidad</strong></td></tr>
<cfloop from="1" to="#ArrayLen(aSortedKeys)#" index="x">
	<cfset task = aTasks[aSortedKeys[x]]>
	<tr class="lista<cfif x mod 2>Par<cfelse>Non</cfif>" onclick="document.form1.task_radio_#x#.checked=true">
		<td><input type="radio" name="task_name_sel" id="task_radio_#x#" value="#HTMLEditFormat(task.task)#" <cfif x mod 2 is 0>style='background-color:white;'</cfif> > </td>
		<td><label for="task_radio_#x#">#task.task#</label></td>
		<td align="right">
			<cfif isnumeric(task.interval)>
			#NumberFormat(task.interval, ',0')# s
			<cfelse>
				#task.interval#
			</cfif>
		</td>
	</tr>
</cfloop>
<tr><td colspan="3">&nbsp;</td></tr>
<tr><td colspan="3" align="center"><input type="submit" value="Ejecutar ahora"></td></tr>
</table>
</cfif>
</form><br>

</cfoutput>

<cf_web_portlet_end>
<cf_templatefooter>
