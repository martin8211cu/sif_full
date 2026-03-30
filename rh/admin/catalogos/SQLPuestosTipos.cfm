<cfparam name="action" default="PuestosTipos.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
			<cfif isdefined("form.Alta")>
				<cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
					insert into RHTPuestos ( Ecodigo, RHTPcodigo, RHTPdescripcion, BMusuario, BMfecha, RHTinfo)
						 values ( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
								  <cfqueryparam value="#Ucase(form.RHTPcodigo)#" cfsqltype="cf_sql_char">,
								  <cfqueryparam value="#form.RHTPdescripcion#" cfsqltype="cf_sql_varchar">,
								  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
								  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">, 
								  <cfqueryparam value="#form.RHTinfo#" cfsqltype="cf_sql_longvarchar">
								)
				</cfquery>
				
			<cfelseif isdefined("form.Cambio")>
				<cfquery name="ABC_Puestos_update" datasource="#session.DSN#">
					update RHTPuestos
					set RHTPcodigo = <cfqueryparam value="#Ucase(form.RHTPcodigo)#" cfsqltype="cf_sql_char">,
						RHTPdescripcion = <cfqueryparam value="#form.RHTPdescripcion#" cfsqltype="cf_sql_varchar">,
						RHTinfo = <cfqueryparam value="#form.RHTinfo#" cfsqltype="cf_sql_longvarchar">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHTPid =  <cfqueryparam value="#form.RHTPid#" cfsqltype="cf_sql_numeric">
				</cfquery>  
				  <cfset modo = 'CAMBIO'>

			<cfelseif isdefined("form.Baja")>
				<cfquery name="ABC_Puestos_delete" datasource="#session.DSN#">			
					delete from RHTPuestos
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHTPid =  <cfqueryparam value="#form.RHTPid#" cfsqltype="cf_sql_numeric">
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
	<cfif modo eq 'CAMBIO'><input name="RHTPid" type="hidden" value="#form.RHTPid#"></cfif>
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