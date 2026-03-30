
<cfif isdefined("Url.CFcodigoI") and not isdefined("Form.CFcodigoI")>
	<cfparam name="Form.CFcodigoI" default="#Url.CFcodigoI#">
<cfelse>
	<cfparam name="Form.CFcodigoI" default="-1">
</cfif>
<cfif isdefined("Url.CFcodigoF") and not isdefined("Form.CFcodigoF")>
	<cfparam name="Form.CFcodigoF" default="#Url.CFcodigoF#">
<cfelse>
	<cfparam name="Form.CFcodigoF" default="-1">
</cfif>

<cfif isdefined("Url.formato") and not isdefined("Form.formato")>
	<cfparam name="Form.formato" default="#Url.formato#">
<cfelse >
	<cfparam name="Form.formato" default="pdf">
</cfif>

<cfquery name="reporte" datasource="#Session.DSN#">
	select rtrim(ltrim(cf.CFcodigo)) as CFcodigo, cf.CFdescripcion,
	p.RHPcodigo, p.RHPdescripcion,
	de.DEidentificacion,
	{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )} as nombre
	from CFuncional cf, RHPlazas p, DatosEmpleado de, LineaTiempo lt
	where cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("form.CFcodigoI") and len(trim(form.CFcodigoI)) and isdefined("form.CFcodigoF") and len(trim(form.CFcodigoF))>
	  and cf.CFcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoI#">
	  	and <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoF#">
	<cfelseif isdefined("form.CFcodigoI") and len(trim(form.CFcodigoI))>
		and cf.CFcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoI#">
	<cfelseif isdefined("form.CFcodigoF") and len(trim(form.CFcodigoF))>
		and cf.CFcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigoF#">
	</cfif>
	  and cf.Ecodigo = p.Ecodigo
	  and cf.CFid = p.CFid
	  and p.RHPid = lt.RHPid
	  and getdate() between lt.LTdesde and lt.LThasta
	  and lt.DEid = de.DEid
	order by cf.CFpath, cf.CFdescripcion, nombre
</cfquery>
<!--- <cfif isdefined("reporte") AND reporte.RecordCount NEQ 0> --->
	<cfreport format="#Form.formato#" template= "EmpleadosCF.cfr" query="reporte">
		<cfreportparam name="Edescripcion" value="#Session.Enombre#">
		<cfif isdefined("Form.CFcodigoI") and Len(Trim(Form.CFcodigoI))>
			<cfreportparam name="CFcodigoI" value="#Form.CFcodigoI#">
		<cfelse>
			<cfreportparam name="CFcodigoI" value="-1">
		</cfif>
		<cfif isdefined("Form.CFcodigoF") and Len(Trim(Form.CFcodigoF))>
			<cfreportparam name="CFcodigoF" value="#Form.CFcodigoF#">
		<cfelse>
			<cfreportparam name="CFcodigoF" value="-1">
		</cfif>
		<cfif isdefined("Form.formato") and Len(Trim(Form.formato))>
			<cfreportparam name="formato" value="#Form.formato#">
		</cfif>
	</cfreport>
<!--- </cfif> --->