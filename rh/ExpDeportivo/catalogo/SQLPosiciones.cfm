<cfparam name="action" default="Posiciones.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="EDPcupInsert" datasource="#session.DSN#">
				insert into EDPosicion ( EDPcodigo, EDPdescripcion,BMfechaalta,BMUsucodigo)
				values ( <cfqueryparam value="#form.EDPcodigo#"       cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#form.EDPdescripcion#"  cfsqltype="cf_sql_varchar">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,			
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						 )
			</cfquery>
		<cfelseif isdefined("form.Cambio")>
			<cf_dbtimestamp datasource="#session.dsn#"
					table="EDPosicion"
					redirect="Posiciones.cfm"
					timestamp="#form.ts_rversion#"
					field1="EDPid"
					type1="numeric"
					value1="#form.EDPid#">
			<cfquery name="EDPcupUpdate" datasource="#session.DSN#">
				update EDPosicion
				set EDPdescripcion = <cfqueryparam value="#form.EDPdescripcion#"    cfsqltype="cf_sql_varchar">
				where EDPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDPid#">
			</cfquery>  
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.Baja")>
			<cfquery name="EDPcupDelete" datasource="#session.DSN#">
				delete EDPosicion
				where EDPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDPid#">
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
	<cfif modo eq 'CAMBIO'><input name="EDPid" type="hidden" value="#form.EDPid#"></cfif>
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