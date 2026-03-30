<cfparam name="action" default="PuestosNiveles.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>

<!---			set nocount on--->

			<cfif isdefined("form.Alta")>
		<cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
			insert into RHNiveles ( Ecodigo, RHNcodigo, RHNdescripcion, RHNhabcono, RHNequivalencia, BMusuario, BMfecha)
				 values ( <cfqueryparam value="#session.Ecodigo#"		cfsqltype="cf_sql_integer">,
						  <cfqueryparam value="#ucase(form.RHNcodigo)#"		cfsqltype="cf_sql_char">,
						  <cfqueryparam value="#form.RHNdescripcion#"	cfsqltype="cf_sql_varchar">,
						  <cfqueryparam value="#form.RHNhabcono#"		cfsqltype="cf_sql_char">,
						  <cfqueryparam value="#form.RHNequivalencia#"	cfsqltype="cf_sql_numeric">,
						  <cfqueryparam value="#session.Usucodigo#"		cfsqltype="cf_sql_numeric">,
						  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						)
		</cfquery>
				
			<cfelseif isdefined("form.Cambio")>
			<cfquery name="ABC_Puestos_update" datasource="#session.DSN#">
				update RHNiveles
				set RHNcodigo = <cfqueryparam value="#ucase(form.RHNcodigo)#" cfsqltype="cf_sql_char">,
					RHNdescripcion = <cfqueryparam value="#form.RHNdescripcion#" cfsqltype="cf_sql_varchar">,
					RHNhabcono = <cfqueryparam value="#form.RHNhabcono#"		cfsqltype="cf_sql_char">,
  					RHNequivalencia =  <cfqueryparam value="#form.RHNequivalencia#"	cfsqltype="cf_sql_numeric">,
					BMusumod = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHNid =  <cfqueryparam value="#form.RHNid#" cfsqltype="cf_sql_numeric">
				  <!---and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)--->
			</cfquery>
				  <cfset modo = 'CAMBIO'>
				  
			<cfelseif isdefined("form.Baja")>
				<cfquery name="ABC_Puestos_delete" datasource="#session.DSN#">			
					delete from RHNiveles
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHNid =  <cfqueryparam value="#form.RHNid#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cfif>

<!---		set nocount off	--->		

	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="RHNid" type="hidden" value="#form.RHNid#"></cfif>
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