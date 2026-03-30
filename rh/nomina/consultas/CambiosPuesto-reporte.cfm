<!---
	Creado por: Ana Villavicencio
	Fecha: 03 de enero del 2006	
	Motivo: Nuevo reporte de Empleados por Rango de Salarios
--->

<cfif isdefined("Url.FechaD") and not isdefined("Form.FechaD")>
	<cfparam name="Form.FechaD" default="#Url.FechaD#">
</cfif>
<cfif isdefined("Url.FechaH") and not isdefined("Form.FechaH")>
	<cfparam name="Form.FechaH" default="#Url.FechaH#">
</cfif>
<cfif isdefined("Url.Nombre1") and not isdefined("Form.Nombre1")>
	<cfparam name="Form.Nombre1" default="#Url.Nombre1#">
</cfif>
<cfif isdefined("Url.Nombre2") and not isdefined("Form.Nombre2")>
	<cfparam name="Form.Nombre2" default="#Url.Nombre2#">
</cfif>
<cfif isdefined("Url.Orden") and not isdefined("Form.Orden")>
	<cfparam name="Form.Orden" default="#Url.Orden#">
</cfif>
<cfif isdefined("Url.formato") and not isdefined("Form.formato")>
	<cfparam name="Form.formato" default="#Url.formato#">
<cfelse >
	<cfparam name="Form.formato" default="flashpaper">
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">

	Select distinct dl.DEid, de.DEidentificacion, 
		<cfif isdefined('form.Nombre1')>
		{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )} as nombre,
		<cfelseif isdefined('form.Nombre2')>
		{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre,
		</cfif>
	 	(select RHPdescpuesto from RHPuestos where Ecodigo = dl.Ecodigo and RHPcodigo = dl.RHPcodigoant) as origen,
	 	(select RHPdescpuesto from RHPuestos where Ecodigo = dl.Ecodigo and RHPcodigo = dl.RHPcodigo) as destino
	from DLaboralesEmpleado dl
	inner join DatosEmpleado de
	   on de.DEid = dl.DEid
	where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaD)#"> 
	  					 and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaH)#">
	  and dl.RHPcodigo <> dl.RHPcodigoant
	  and dl.RHPcodigoant is not null
	<cfif isdefined('form.orden')>
		<cfif form.orden EQ 1>
			order by de.DEidentificacion
		<cfelse>
			order by nombre
		</cfif>
	</cfif>
</cfquery>
<cfif isdefined("rsReporte") AND rsReporte.RecordCount NEQ 0>
	<cfreport format="#Form.formato#" template= "CambiosPuesto.cfr" query="rsReporte">
		<cfreportparam name="Edescripcion" value="#Session.Enombre#">
		<cfreportparam name="FechaD" value="#form.FechaD#">
		<cfreportparam name="FechaH" value="#form.FechaH#">
		<cfif isdefined("Form.formato") and Len(Trim(Form.formato))>
			<cfreportparam name="formato" value="#Form.formato#">
		<cfelse>
			<cfreportparam name="formato" value="0">
		</cfif>
	</cfreport>
<cfelse>
	<table width="40%" cellpadding="0" cellspacing="0" border="0" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr><td>------------------  <cf_translate key="LB_NoHayDatosRelacionados">No hay datos relacionados</cf_translate> ------------------</td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</cfif>