<cfparam name="action" default="ConsultaCierreCaja.cfm">
<cfif isdefined("form.btnAceptar") or isdefined("form.btnModificar") >
	<cftransaction>
		<cftry>
			<!--- inserta el encabezado del cierre --->
			<cfif isdefined("form.btnAceptar")>
				<cfquery name="sql_ecierre" datasource="#session.DSN#" >
					set nocount on
					insert FACierres ( Ecodigo, FCid, Usucodigo, Ulocalizacion, EUcodigo, FCAfecha )
					values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"	>,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#" >,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#" >,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#" >,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EUcodigo#" >,
							 getDate()
						   )
					select convert(varchar, @@identity) as FACid	   
					set nocount off
				</cfquery>
				<cfset FACid = sql_ecierre.FACid >
			<cfelse>
				<cfset FACid = form.FACid >	
			</cfif>	
				
			<!--- proceso de datos por moneda --->
			<cfloop index="i" list="#form.Mcodigo#" delimiters=",">
				<!--- crea los nombres de los objetos --->
				<cfset FADCminicial    =  Evaluate("form.FADCminicial_" & i ) >
				<cfset FADCcontado     =  Evaluate("form.FADCcontado_" & i ) >
				<cfset FADCfcredito    =  Evaluate("form.FADCfcredito_" & i ) >
				<cfset FADCefectivo    =  Evaluate("form.FADCefectivo_" & i) >
				<cfset FADCcheques     =  Evaluate("form.FADCcheques_" & i ) >
				<cfset FADCvouchers    =  Evaluate("form.FADCvouchers_" & i )>
				<cfset FADCdepositos   =  Evaluate("form.FADCdepositos_" & i ) >
				<cfset FADCncredito    =  Evaluate("form.FADCncredito_" & i ) >
				<cfset FADCtc          =  Evaluate("form.FADCtc_" & i ) >
				
				<cfquery name="rsCount" datasource="#session.DSN#">
					select 1 from FADCierres where FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#"> and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				</cfquery>
				<cfif isdefined("form.btnAceptar") or isdefined("form.btnModificar") >
					<cfquery name="sql_dcierre" datasource="#session.DSN#">
						set nocount on
						<cfif rsCount.RecordCount gt 0 >

								update FADCierres 
								set FADCminicial    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCminicial#">, 
									FADCcontado     = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCcontado#">, 
									FADCfcredito    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCfcredito#">,
									FADCefectivo    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCefectivo#">, 
									FADCcheques     = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCcheques#">, 
									FADCvouchers    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCvouchers#">, 
									FADCdepositos   = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCdepositos#">, 
									FADCncredito    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCncredito#">,
									FADCtc          = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCtc#">
								where FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#">
								  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
						<cfelse>		  
							insert FADCierres ( FACid, Mcodigo, FADCminicial, FADCcontado, FADCcontadosis, FADCfcredito, FADCfcreditosis, 
												FADCefectivo, FADCefectivosis, FADCcheques, FADCchequessis, FADCvouchers, FADCvoucherssis, 
												FADCdepositos, FADCdepositossis, FADCncredito, FADCncreditosis, FADCdiferencias, FADCtc)
							values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#">, 
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">, 
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCminicial#">,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCcontado#">, 
									 0, 
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCfcredito#">,
									 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCefectivo#">, 
									 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCcheques#">,
									 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCvouchers#">, 
									 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCdepositos#">,
									 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCncredito#">,
									 0,
									 0,
									 <cfqueryparam cfsqltype="cf_sql_float" value="#FADCtc#">
									)
						</cfif>		
						set nocount off
					</cfquery>
				</cfif>
			</cfloop>
			
		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	<cftransaction>
<cfelse>
	<cfset action = "CierreCaja.cfm" >
	<cfset modo   = "CAMBIO" >
</cfif>	

<cfif isdefined("form.FACid") AND form.FACid EQ "" >
	<cfset form.FACid = "#sql_ecierre.FACid#">
</cfif>


<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="FACid"  type="hidden" value="<cfif isdefined("Form.FACid")>#Form.FACid#</cfif>">
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