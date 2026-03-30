<cfparam name="action" default="Ocupaciones.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="RHOcupInsert" datasource="#session.DSN#">
				insert into RHOcupaciones ( RHOcodigo, RHOdescripcion ,Ecodigo)
				values ( <cfqueryparam value="#form.RHOcodigo#"       cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#form.RHOdescripcion#"  cfsqltype="cf_sql_varchar">,
						  <cfqueryparam value="#session.Ecodigo#"  cfsqltype="cf_sql_numeric">)
			</cfquery>
		<cfelseif isdefined("form.Cambio")>
			<cfquery name="RHOcupUpdate" datasource="#session.DSN#">
				update RHOcupaciones
				set RHOdescripcion = <cfqueryparam value="#form.RHOdescripcion#"    cfsqltype="cf_sql_varchar">
				where RHOcodigo =  '#trim(form.RHOcodigo)#'
			</cfquery>  
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.Baja")>
			<cfquery name="RHOcupDelete" datasource="#session.DSN#">
				delete from RHOcupaciones
				where RHOcodigo =  '#trim(form.RHOcodigo)#'
			</cfquery>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="RHOcodigo" type="hidden" value="#form.RHOcodigo#"></cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>