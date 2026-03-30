
<cfparam name="modo" default="ALTA">	
<cfif not isdefined("form.btnNuevo")>
<cftransaction>
	<cftry>
<cfset modo = 'CAMBIO'>
			<!---set nocount on--->
			<cfif isdefined("form.Alta")>
				<cfquery name="ABC_Puestos_insert" datasource="#Session.DSN#">
					insert into EDPartidos (EDvid, EDPequipo2, EDPfecha, EDPestadio, EDPtipo, BMUsucodigo, BMfalta, EDPcarbitro, EDPalinea1, EDPalinea2, EDParbitroc)
								 values ( 
								 		  <cfqueryparam value="#form.EDvid#"	cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#form.EDvid2#"	cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#form.EDPfecha#" cfsqltype="cf_sql_date">,
										  <cfqueryparam value="#form.EDPestadio#" cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#form.EDPtipo#" cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										  <cfif isdefined('form.EDPcarbitro') and len(trim(form.EDPcarbitro))>
										  <cfqueryparam value="#form.EDPcarbitro#" cfsqltype="cf_sql_numeric">,
										  <cfelse>
										  null,
										  </cfif>
										  <cfif isdefined('form.EDPalinea1') and len(trim(form.EDPalinea1))>
										  <cfqueryparam value="#form.EDPalinea1#" cfsqltype="cf_sql_numeric">,
										  <cfelse>
										  null,
										  </cfif>
										  <cfif isdefined('form.EDPalinea2') and len(trim(form.EDPalinea2))>
										  <cfqueryparam value="#form.EDPalinea2#" cfsqltype="cf_sql_numeric">,
										  <cfelse>
										  null,
										  </cfif>
										  <cfif isdefined('form.EDParbitroc') and len(trim(form.EDParbitroc))>
										  <cfqueryparam value="#form.EDParbitroc#" cfsqltype="cf_sql_numeric">
										  <cfelse>
										  null
										  </cfif>
										)
					
					<!---select id = @@identity--->
					<cf_dbidentity1 datasource="#Session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_Puestos_insert">	
													
		<cfset modo = 'CAMBIO'>	
		<cfelseif isdefined('form.Cambio')>
			<cfquery name="rsCambio" datasource="#Session.DSN#">
				update EDPartidos
				set
					EDvid = <cfqueryparam value="#form.EDvid#" cfsqltype="cf_sql_numeric">,
					EDPequipo2 = <cfqueryparam value="#form.EDvid2#" cfsqltype="cf_sql_numeric">,
					EDPfecha = <cfqueryparam value="#form.EDPfecha#" cfsqltype="cf_sql_date">,
					EDPtipo = <cfqueryparam value="#form.EDPtipo#" cfsqltype="cf_sql_numeric">
					<cfif isdefined('form.EDPcarbitro') and len(trim(form.EDPcarbitro))>
					,EDPcarbitro = <cfqueryparam value="#form.EDPcarbitro#" cfsqltype="cf_sql_numeric">
					<cfelse>
					,EDPcarbitro = null
					</cfif>
					<cfif isdefined('form.EDPalinea2') and len(trim(form.EDPalinea2))>
					,EDPalinea2 = <cfqueryparam value="#form.EDPalinea2#" cfsqltype="cf_sql_numeric">
					<cfelse>
					,EDPalinea2 = null
					</cfif>
					<cfif isdefined('form.EDPalinea1') and len(trim(form.EDPalinea1))>
					,EDPalinea1 = <cfqueryparam value="#form.EDPalinea1#" cfsqltype="cf_sql_numeric">
					<cfelse>
					,EDPalinea1 = null
					</cfif>
					<cfif isdefined('form.EDParbitroc') and len(trim(form.EDParbitroc))>
					,EDParbitroc = <cfqueryparam value="#form.EDParbitroc#" cfsqltype="cf_sql_numeric">
					<cfelse>
					,EDParbitroc = null
					</cfif>
					,EDPestadio = <cfqueryparam value="#form.EDPestadio#" cfsqltype="cf_sql_varchar">
				
				where EDPrid = <cfqueryparam value="#form.EDPrid#" cfsqltype="cf_sql_numeric"> 
			</cfquery>
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined('form.Baja')>
			<cfquery name="rsDelete" datasource="#Session.DSN#">
				delete EDPartidos
				where EDPrid = <cfqueryparam value="#form.EDPrid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset modo = 'ALTA'>
		</cfif>

<!---		set nocount off --->
<!---		</cfquery>--->
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cftransaction>
</cfif>
<cfoutput>
<form action="registropartidos.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="EDPrid" type="hidden" value="<cfif isdefined('ABC_Puestos_insert.identity')>#ABC_Puestos_insert.identity#<cfelse>#form.EDPrid#</cfif>">
	<input name="EDvid" type="hidden" value="#form.EDvid#">
	<input name="EDPequipo2" type="hidden" value="#form.EDvid2#">
	<input name="Equipo" type="hidden" value="#form.Equipo#">
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
