<cfapplication 
sessionmanagement="YES"
name="SIF_ASP">
<cfquery name="Caches" datasource="asp">
	select distinct c.Ccache
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'SIF'
	  and m.SMcodigo = 'AN'
	  and e.Ereferencia is not null
	  and c.Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
</cfquery>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Calcular Anexos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<table width="700" cellpadding="2" cellspacing="0" border="1">
	<tr>
		<td width="50"></td>
		<td width="190"></td>
		<td width="460"></td>
	</tr>
	<cfflush interval="64">
	<cfloop query="Caches">
		<cfset LvarError = "">
		<cfset datasource = Caches.Ccache>
		<cfset cantidad = 0>
		<cfset StartTicks = GetTickCount()>
		<cfquery datasource="#datasource#" name="pend_antes">
			select count(1) as p from AnexoCalculo where ACstatus = 'P'
		</cfquery>
		<cfset cantidad = fnCalculaAnexos()>
		<tr>
			<td colspan="3" style="font-weight:bold;background-color:#CCCCCC"><cfoutput>Datasource:#datasource#</cfoutput></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td valign="top"> Iniciando proceso </td>
			<td valign="top"><cfset start = Now()><cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td valign="top"> Anexos pendientes antes</td>
			<td valign="top"><cfoutput>#pend_antes.p#</cfoutput></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td valign="top"> Anexos calculados</td>
			<td valign="top">
			<cfoutput>#cantidad#</cfoutput></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td valign="top">Anexos pendientes despu&eacute;s</td>
			<td valign="top">
				<cfquery datasource="#datasource#" name="pend">
				   select count(1) as p from AnexoCalculo where ACstatus = 'P'
				</cfquery>
				<cfoutput>#pend.p#</cfoutput>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td valign="top"> Proceso terminado </td>
			<td valign="top">
			<cfset finish = Now()>
			<cfset FinishTicks = GetTickCount()>
			<cfoutput>#TimeFormat(finish,"HH:MM:SS")#</cfoutput></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td valign="top"> Duraci&oacute;n</td>
			<td valign="top"><cfoutput>#(FinishTicks - StartTicks) #</cfoutput> ms</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td valign="top"> Promedio por anexo</td>
			<td valign="top">
			   <cfif cantidad GT 0>
				  <cfoutput>#(FinishTicks - StartTicks) / cantidad #</cfoutput> ms
				  <cfelse>
				  N/A
			   </cfif>
			</td>
		</tr>
	</cfloop>
</table>
</body>
</html>

<cffunction name="fnCalculaAnexos" access="private" returntype="numeric" output="no">
	<cfset cantidad = -1>
	<cfset LvarError = false>
    <cftry>
		<cfinvoke component="sif.an.operacion.calculo.calculo"
			method="procesarCola"
			DataSource="#datasource#"
			MaxRecordCount="10"
			returnvariable="cantidad"> 
		</cfinvoke>
		<cfcatch type="any">
			<cfset LvarError = true>
			<!---
			<cfoutput>
				<span style="color:red;font-weight:bold"> Error en datasource #datasource#: #cfcatch.Message# #cfcatch.Detail# </span>
				<BR>
				#fnGetStackTrace(cfcatch)#
				</td>
				</tr>
			</cfoutput>
			--->
      </cfcatch>
    </cftry>
	<cfif LvarError>
		<cfreturn -1>
	<cfelse>
		<cfreturn cantidad>
	</cfif>
</cffunction>

<!---
<cffunction name="fnGetStackTrace" access="public" returntype="string" output="no">
	<cfargument name="LprmError">
	<cfset TemplateRoot = Replace(ExpandPath(""), "\", "/",'all')>
	<cfset LvarStackTrace = "<BR>">
	<cfif IsDefined("LprmError.TagContext") and IsArray(LprmError.TagContext) and ArrayLen(LprmError.TagContext) NEQ 0>
		<cfset LvarStackTrace = LvarStackTrace & "<strong>Template Stack Trace</strong>:<br>">
		<cfloop from="1" to="#ArrayLen(LprmError.TagContext)#" index="i">
			<cfset TagContextTemplate = LprmError.TagContext[i].Template>
			<cfset TagContextTemplate = Replace(TagContextTemplate, "\", "/", 'all')>
			<cfset TagContextTemplate = ReplaceNoCase(TagContextTemplate, TemplateRoot, "")>
			<cfset LvarStackTrace = LvarStackTrace & " at " & 
				TagContextTemplate & ":" &
				LprmError.TagContext[i].Line>
				<cfset LvarTagContextI = LprmError.TagContext[i]>
				<cfif isdefined('LvarTagContextI.ID')>
					<cfset LvarStackTrace = LvarStackTrace  & " (" & LprmError.TagContext[i].ID & ")">
				</cfif>
			<cfset LvarStackTrace = LvarStackTrace & "<br>" >
		</cfloop>
	</cfif>
	<cfreturn LvarStackTrace>
</cffunction>
--->
