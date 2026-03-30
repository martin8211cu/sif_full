<cfif isdefined("form.botonSel") and len(trim(form.botonSel))>
	<cftransaction>
		<cfquery name="rsSaldos" datasource="#Session.DSN#">
			delete from CGEstrProgFESaldos
			where EPSIano = #form.periodo#
		</cfquery>

		<cfloop from="1" to="12" index="i">
			<cfset chequeI = "ChequeI#i#">
			<cfset chequef = "ChequeF#i#">
			<cfset flcmb = "Fluctuacion#i#">
			<cfset utilP = "UtilPer#i#">
			<cfquery name="rsSaldos" datasource="#Session.DSN#">
				INSERT INTO CGEstrProgFESaldos
			           ([EPSIano]
			           ,[EPSImes]
			           ,[BMUsucodigo]
			           ,[ChequeTranIni]
			           ,[ChequeTranFin]
			           ,[FluctuacionCambiaria]
			           ,[UtilidadPerdida]
			           ,Ecodigo)
			     VALUES
			           (<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.Periodo#">,
			            <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#i#">,
			            <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
			            <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#form[chequeI]#">,
			            <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#form[chequeF]#">,
			            <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#form[flcmb]#">,
			            <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#form[utilP]#">,
			            <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
			</cfquery>
		</cfloop>
	</cftransaction>
</cfif>

<cfoutput>
        <form action="FESaldosIniciales.cfm" method="post" name="sql">
        <cfif isdefined("Form.periodo")>
                <input name="periodo" type="hidden" value="#Form.periodo#">
        </cfif>
       <html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>
        </form>
</cfoutput>
