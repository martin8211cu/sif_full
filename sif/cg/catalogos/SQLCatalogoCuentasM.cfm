<cfparam name="modo" default="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery datasource="#Session.DSN#" name="Insert">
				insert INTO CGIC_Catalogo (
											CGICMid, 
											CGICCcuenta, 
											CGICCnombre, 
											CGICinfo1, 
											CGICinfo2, 
											CGICinfo3,
											CGICinfo4,
											CGICinfo5,
											CGICinfo6,
											CGICinfo7,
											CGICinfo8,
											CGICinfo9
											)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">,
					<cfqueryparam cfsqltype="cf_sql_char" 	 value="#form.CGICCcuenta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICCnombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo3#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo4#">,
					<cfif isdefined("form.CGICinfo5")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo5#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("form.CGICinfo6")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo6#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("form.CGICinfo7")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo7#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("form.CGICinfo8")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo8#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("form.CGICinfo9")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo9#">
					<cfelse>
						null
					</cfif>
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="Insert">
		</cftransaction>

		<cfset modo="CAMBIO">
		
	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#session.DSN#">
			delete from CGIC_Catalogo
			where CGICCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICCid#">
		</cfquery>
	  	<cfset modo="ALTA">
	  
	<cfelseif isdefined("Form.Cambio")>
		<cfquery datasource="#session.DSN#">
			update CGIC_Catalogo set
				CGICCcuenta	 = <cfqueryparam cfsqltype="cf_sql_char" 	value="#form.CGICCcuenta#">, 
				CGICCnombre	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICCnombre#">, 
				CGICinfo1 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo1#">, 
				CGICinfo2 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo2#">, 
				CGICinfo3 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo3#">, 
				CGICinfo4 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo4#">, 
				CGICinfo5 	 =
					<cfif isdefined("form.CGICinfo5")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo5#">,
					<cfelse>
						null,
					</cfif>
				CGICinfo6 	 = 
					<cfif isdefined("form.CGICinfo6")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo6#">, 
					<cfelse>
						null,
					</cfif>
				CGICinfo7 	 = 
					<cfif isdefined("form.CGICinfo7")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo7#">, 
					<cfelse>
						null,
					</cfif>
				CGICinfo8 	 = 
					<cfif isdefined("form.CGICinfo8")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo8#">, 
					<cfelse>
						null,
					</cfif>
				CGICinfo9 	 = 
					<cfif isdefined("form.CGICinfo9")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo9#">
					<cfelse>
						null
					</cfif>
			where CGICCid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CGICCid#">
		</cfquery>
	  	<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.BtnAgregar") and len(form.CHK) GT 0>	
		<cfloop list="#form.chk#" delimiters="," index="i">
			<cfquery datasource="#session.DSN#">
				insert into CGIC_Cuentas  (Ccuenta, CGICMid,CGICCid)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CGICMid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CGICCid#">
				)
			</cfquery>
		</cfloop>

		<cfset modo="CAMBIO">
		<script language="JavaScript" type="text/javascript">
			if (window.opener.funcRefrescar) {window.opener.funcRefrescar()}
			window.close();
		</script>
	<cfelseif isdefined("Form.BtnAgregarCuenta") and len(form.ccuenta) GT 0>	

			<cfquery datasource="#session.DSN#">
				insert into CGIC_Cuentas  (Ccuenta, CGICMid,CGICCid)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICCid#">
				)
			</cfquery>
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.BtnAgregarCuenta") and len(form.ccuenta) eq 0>
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.BtnEliminar") and isdefined("form.chk") and len(form.chk)>	
			<cfquery datasource="#session.dsn#">
				delete from CGIC_Cuentas
				where Ccuenta in (#form.chk#)
				  and CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
			</cfquery>
			<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfif isdefined("LvarInfo")>
	<cfset LvarAction = 'CatalogoCuentasMINFO.cfm'>
<cfelse>
	<cfset LvarAction = 'CatalogoCuentasM.cfm'>
</cfif>



<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
<cfif isdefined("Url.CGICMid") and not isdefined("Form.CGICMid")>
	<cfparam name="Form.CGICMid" default="#Url.CGICMid#">
</cfif>
<cfif isdefined("Url.CGICCid") and not isdefined("Form.CGICCid")>
	<cfparam name="Form.CGICCid" default="#Url.CGICCid#">
</cfif>
	<cfoutput>
		<cfif isdefined("form.FILTRO_CDESCRIPCION")>
			<input name="FILTRO_CDESCRIPCION" value="#form.FILTRO_CDESCRIPCION#" type="hidden">
		</cfif>
		<cfif isdefined("form.FILTRO_CFORMATO")>
			<input name="FILTRO_CFORMATO" value="#form.FILTRO_CFORMATO#" type="hidden">
		</cfif>
		<cfif isdefined("form.HFILTRO_CDESCRIPCION")>
			<input name="HFILTRO_CDESCRIPCION" value="#form.HFILTRO_CDESCRIPCION#" type="hidden">
		</cfif>
		<cfif isdefined("form.HFILTRO_CFORMATO")>
			<input name="HFILTRO_CFORMATO" value="#form.HFILTRO_CFORMATO#" type="hidden">
		</cfif>

		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="CGICMid" type="hidden" value="<cfif isdefined("Form.CGICMid")>#Form.CGICMid#</cfif>">
		<cfif isdefined("form.Alta")>
			<input name="CGICCid" type="hidden" value="#Insert.identity#">
		<cfelse>
			<input name="CGICCid" type="hidden" value="<cfif isdefined("Form.CGICCid")>#Form.CGICCid#</cfif>">
		</cfif>
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>