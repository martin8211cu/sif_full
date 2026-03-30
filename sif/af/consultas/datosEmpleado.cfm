<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<!--- Definición y Llenado de la Tabla de Estados --->
<cfset qryEstadosEmpleado = QueryNew("value,description")>
<cfset QueryAddRow(qryEstadosEmpleado,3)>
<cfset QuerySetCell(qryEstadosEmpleado,"value",-1,1)>
<cfset QuerySetCell(qryEstadosEmpleado,"description","-- todos --",1)>
<cfset QuerySetCell(qryEstadosEmpleado,"value",1,2)>
<cfset QuerySetCell(qryEstadosEmpleado,"description","Activo",2)>
<cfset QuerySetCell(qryEstadosEmpleado,"value",2,3)>
<cfset QuerySetCell(qryEstadosEmpleado,"description","Inactivo",3)>

<!--- Definición de Parámetros --->

<cfif isDefined("url.CFidIni") and not isDefined("form.CFidIni")>
	<cfset form.CFidIni = url.CFidIni>
</cfif>

<cfif isDefined("url.CFidFin") and not isDefined("form.CFidFin")>
	<cfset form.CFidFin = url.CFidFin>
</cfif>

<!--- Filtros para la Consulta de Centros Funcionales --->
<cfif isdefined("form.CFidIni") and len(trim(form.CFidIni)) gt 0>
	<cfquery name="rsCFuncionalIni" datasource="#Session.DSN#">
		select
			  CFid as CFidIni,
			CFcodigo as CFcodigoIni  ,
			CFdescripcion as CFdescripcionIni  
		from CFuncional
		where Ecodigo = #Session.Ecodigo#
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidIni#">
	</cfquery>
</cfif>

<cfif isdefined("form.CFidFin") and len(trim(form.CFidFin)) gt 0>
	<cfquery name="rsCFuncionalFin" datasource="#Session.DSN#">
		select
		
			CFid as CFidFin,
			CFcodigo as CFcodigoFin,
			CFdescripcion as CFdescripcionFin 
		from CFuncional
		where Ecodigo = #Session.Ecodigo#
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidFin#">
	</cfquery>
</cfif>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
			<form name="lista" id="lista" method="post" action="datosEmpleado.cfm" style="margin:0">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="titulolistas" style="margin:0">
					<tr>
						<td><strong>Centro Funcional Inicial:</strong></td>
						<td>
							<cfif isdefined("form.CFidIni") and len(trim(form.CFidIni)) gt 0>
								<cf_rhcfuncional form="lista" size="35" id="CFidIni" name="CFcodigoIni" desc="CFdescripcionIni" query="#rsCFuncionalIni#" frame="frcfuncional" tabindex="1">
							<cfelse>
								<cf_rhcfuncional form="lista" size="35" id="CFidIni" name="CFcodigoIni" desc="CFdescripcionIni" frame="frcfuncional" tabindex="1">
							</cfif>
						</td>
						<td><strong>Centro Funcional Final:</strong></td>
						<td>
							<cfif isdefined("form.CFidFin") and len(trim(form.CFidFin)) gt 0>
								<cf_rhcfuncional form="lista" size="35" id="CFidFin" name="CFcodigoFin" desc="CFdescripcionFin" query="#rsCFuncionalFin#" frame="frcfunciona2" tabindex="2">
							<cfelse>
								<cf_rhcfuncional form="lista" size="35" id="CFidFin" name="CFcodigoFin" desc="CFdescripcionFin" frame="frcfunciona2" tabindex="2">
							</cfif>
						</td>
					</tr>
				</table>
				<!--- Lista de Empleados por Centro Funcional --->
				<cfinclude template="datosEmpleado-lista.cfm">
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>