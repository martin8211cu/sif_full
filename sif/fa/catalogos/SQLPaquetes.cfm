<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="Paquetes" datasource="#Session.DSN#">
			set nocount on			
			<cfif isdefined("Form.Alta")>
				Insert 	Paquetes(LPlinea, Aid, Cid, Alm_Aid, Pfactor)
						values	(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.LPlinea#">, 
						<cfif Form.Aid GT 0 and Form.Tipo EQ 0>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">, <cfelse> null, </cfif>
						<cfif Form.Cid GT 0 and Form.Tipo EQ 1>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">, <cfelse> null, </cfif>
						<cfif Form.Alm_Aid GT 0 and Form.Tipo EQ 0>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Alm_Aid#">, <cfelse> null, </cfif>
						<cfif Form.Pfactor GT 0>
							<cfqueryparam cfsqltype="cf_sql_float" value="#Form.Pfactor#"> <cfelse> null </cfif>
						)
				Select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				Update 	Paquetes
					set Aid=<cfif Form.Aid GT 0 and Form.Tipo EQ 0>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">, <cfelse> null, </cfif>
						Cid=<cfif Form.Cid GT 0 and Form.Tipo EQ 1>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">, <cfelse> null, </cfif>
						Alm_Aid=<cfif Form.Alm_Aid GT 0 and Form.Tipo EQ 0>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Alm_Aid#">, <cfelse> null, </cfif>
						Pfactor=<cfif Form.Pfactor GT 0>
								<cfqueryparam cfsqltype="cf_sql_float" value="#Form.Pfactor#"> <cfelse> null </cfif>
				where Pid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pid#">
				and LPlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.LPlinea#">
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete Paquetes
				where Pid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pid#">
				and LPlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.LPlinea#">
				<cfset modo="BAJA">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="Paquetes.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Pid" type="hidden" value="<cfif isdefined("Form.Pid")><cfoutput>#Form.Pid#</cfoutput></cfif>">
	<input name="LPid" type="hidden" value="<cfif isdefined("Form.LPid")><cfoutput>#Form.LPid#</cfoutput></cfif>">
	<input name="LPlinea" type="hidden" value="<cfif isdefined("Form.LPlinea")><cfoutput>#Form.LPlinea#</cfoutput></cfif>">
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>