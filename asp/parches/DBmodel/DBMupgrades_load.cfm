<cflock name="DBM_LOAD" throwontimeout="yes" type="exclusive" timeout="10">
	<cfset LvarUPLOAD_File = expandPath("/asp_dbm/upload.txt")>

	<cfset LvarOP = "">
	<cfif fileExists("#LvarUPLOAD_File#.err")>
		<cfset LvarOP = "ERROR">
		<cffile action="read" file="#LvarUPLOAD_File#.err" variable="LvarTxt">
	<cfelseif fileExists("#LvarUPLOAD_File#")>
		<cfset LvarOP = "PROGRESO">
		<cffile action="read" file="#LvarUPLOAD_File#" variable="LvarTxt">
	<cfelse>
		<cfdirectory directory="#expandPath("/asp_dbm")#" action="list" name="rsDir">

		<!--- ATTRIBUTES DATELASTMODIFIED DIRECTORY MODE NAME SIZE TYPE --->
		<cfquery name="rsSQL" dbtype="query">
			select name
			  from rsDir
			 where name like 'V%.xml'
		</cfquery>
		
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarOP = "INICIAR">
			<cfset LvarDatos = "#now()#,#now()#,#rsSQL.name#,1">
			<cffile action="write" file="#LvarUPLOAD_File#" output="#LvarDatos#">
		</cfif>
	</cfif>
</cflock>

<cfif LvarOP EQ "ERROR">
	<cftry>
		<cffile action="delete" file="#LvarUPLOAD_File#.err">
	<cfcatch type="any"></cfcatch></cftry>
	<cftry>
		<cffile action="delete" file="#LvarUPLOAD_File#">
	<cfcatch type="any"></cfcatch></cftry>
	<cfthrow message="#LvarTxt#">
<cfelseif LvarOP EQ "PROGRESO">
	<cfif findNoCase("ABORT",LvarTxT)>
		<cfthrow message="Proceso Cancelado por el usuario">
	<cfelseif findNoCase("IGNORE",LvarTxT)>
		<cfexit>
	</cfif>

	<cfoutput>
	<table align="center">
		<tr>
			<td>Cargando Versión:</td>
			<td>#ListGetAt(LvarTxt,3)#</td>
		</tr>
		<tr>
			<cfset LvarDT = ListGetAt(LvarTxt,1)>
			<td>Inicio de carga:</td>
			<td>#DateFormat(LvarDT,"DD/MM/YYYY")# #TimeFormat(LvarDT,"HH:MM:SS")#</td>
		</tr>
		<tr>
			<cfset LvarPrc = ListGetAt(LvarTxt,4)>

			<td colspan="2">
				<div style="position:relative;top:0px;left:0px;width:400px; height:20px; border:solid ##CCCCCC 1px; overflow:hidden">
					<div style="position:relative;top:0px;left:0px;width:#4 * LvarPrc#px; height:20px; border:none; background-color:##CCCCCC;">
					</div>
					<div style="position:relative;top:-19px;left:0px;width:400px; height:20px; border:none; overflow:hidden; text-align:center;">
					#LvarPrc#%
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<cfset LvarDT = ListGetAt(LvarTxt,2)>
			<td>Ultima actividad:</td>
			<td>#DateFormat(LvarDT,"DD/MM/YYYY")# #TimeFormat(LvarDT,"HH:MM:SS")#</td>
		</tr>
		<cfif datediff("s",LvarDT,now()) GT 120>
		<tr>
			<cfset LvarDT = ListGetAt(LvarTxt,2)>
			<td colspan="2" style="width:500px">
				<font color="##FF0000"><strong>PROCESO DORMIDO:</strong></font><BR>
				El proceso tiene más de 2 minutos sin actividad.  Puede borrar el archivo #LvarUPLOAD_File# para reiniciar el proceso.
			</td>
		</tr>
		</cfif>
	</table>
	</cfoutput>
	<script language="javascript">
		setTimeout("location.href = 'DBMupgrades.cfm';",5000);
	</script>
	<cfabort>
<cfelseif LvarOP EQ "INICIAR">
	<cfthread name="DBM_LOAD">
		<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
		<cfset LvarObj.XML_toVersion(expandPath("/asp_dbm/") & rsSQL.name)>
	</cfthread>
	<cflocation url="DBMupgrades.cfm">
	<cfabort>
</cfif>
