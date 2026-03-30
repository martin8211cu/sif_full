<cfif isdefined('form.Fcorte') and Len(Trim(form.Fcorte)) eq 0>
	<cfset form.Fcorte = LSDateFormat(Now(), 'dd/mm/yyyy')>
</cfif>
<cfif isdefined("url.limitar") and not isdefined("form.limitar")>
	<cfset form.limitar = 1>
</cfif>
<cfif isdefined("form.limitar")>
	<cfset form.Nivel = 1>
<cfelse>
	<cfset form.Nivel = 3>	
</cfif>
<!--- <table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<cfif not isdefined("form.btnConsultar")>
			<cflocation addtoken="no" url="Vacaciones.cfm">
		</cfif>
		<cfif  isdefined("form.formato") and form.formato eq "HTML">
			<cf_templatecss>
			<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
			  <tr align="left"> 
				<td><a href="Vacaciones.cfm">Regresar</a></td>
			  </tr>
			</table>
		</cfif>	
		</td>	
	</tr>
</table> --->	
<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="lb_Consulta_de_Saldos_de_Vacaciones"
    Default="Consulta de Saldos de Vacaciones"
    returnvariable="lb_Consulta_de_Saldos_de_Vacaciones"/>


<cfset LvarFileName = "#lb_Consulta_de_Saldos_de_Vacaciones#-#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
	title="#lb_Consulta_de_Saldos_de_Vacaciones#" 
	filename="#LvarFileName#"
	irA="Vacaciones.cfm" 
	>

<cfinclude template="VacacionesRep-form.cfm">

