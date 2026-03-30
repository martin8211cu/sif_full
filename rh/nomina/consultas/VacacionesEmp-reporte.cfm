
<!---
	Creado por: Ana Villavicencio
	Fecha: 21 de noviembre del 2005
	Motivo: Nuevo reporte de Vacaciones por empleado
--->

<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.DEidentificacion") and not isdefined("Form.DEidentificacion")>
	<cfparam name="Form.DEidentificacion" default="#Url.DEidentificacion#">
</cfif>
<cfif isdefined("Url.NTIcodigo") and not isdefined("Form.NTIcodigo")>
	<cfparam name="Form.NTIcodigo" default="#Url.NTIcodigo#">
</cfif>
<cfif isdefined("Url.NombreEmp") and not isdefined("Form.NombreEmp")>
	<cfparam name="Form.NombreEmp" default="#Url.NombreEmp#">
</cfif>
<cfif isdefined("Url.Nombre1") and not isdefined("Form.Nombre1")>
	<cfparam name="Form.Nombre1" default="#Url.Nombre1#">
</cfif>
<cfif isdefined("Url.Nombre2") and not isdefined("Form.Nombre2")>
	<cfparam name="Form.Nombre2" default="#Url.Nombre2#">
</cfif>
<cfif isdefined("Url.formato") and not isdefined("Form.formato")>
	<cfparam name="Form.formato" default="#Url.formato#">
<cfelse >
	<cfparam name="Form.formato" default="flashpaper">
</cfif>
<cfquery name="rsReporte" datasource="#Session.DSN#">
	select ev.EVfantig,
		dv.DVEfecha, dv.DVEdescripcion,dv.DVEdisfrutados, dv.DVEcompensados,
		Coalesce(DVEdisfrutados,0) + Coalesce(DVEcompensados,0) as SaldoVac,
		cf.CFdescripcion,cf.CFcodigo,
		<cfif isdefined('form.Nombre1')>
		{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )}as nombre
		<cfelseif isdefined('form.Nombre2')>
		{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre
		</cfif>
	from EVacacionesEmpleado ev
	left outer join DVacacionesEmpleado dv
	   on ev.DEid = dv.DEid
	  and (abs(DVEdisfrutados)+abs(DVEcompensados) > 0)
	  and abs(DVEenfermedad) = 0
	inner join LineaTiempo lt
	   on lt.DEid = ev.DEid
	  and getdate() between LTdesde and LThasta
	inner join RHPlazas p
	   on lt.RHPid = p.RHPid
	  and lt.Ecodigo = p.Ecodigo
	inner join CFuncional cf
	   on p.CFid = cf.CFid
	  and p.Ecodigo = cf.Ecodigo
	inner join DatosEmpleado de
	   on lt.Ecodigo = de.Ecodigo
	  and lt.DEid = de.DEid
	where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and ev.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	  order by DVEfecha
</cfquery>

<cfif isdefined("rsReporte") AND rsReporte.RecordCount NEQ 0>
	<cfreport format="#Form.formato#" template= "VacacionesEmp.cfr" query="rsReporte">
		<cfreportparam name="Edescripcion" value="#Session.Enombre#">
		<cfreportparam name="DEidentificacion" value="#form.DEidentificacion#">
		<cfreportparam name="NombreEmp" value="#rsReporte.nombre#">
		<cfif isdefined("Form.formato") and Len(Trim(Form.formato))>
			<cfreportparam name="formato" value="#Form.formato#">
		</cfif>
	</cfreport>
</cfif>