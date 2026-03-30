<cfif isdefined("url.CMPid") and not isdefined("form.CMPid") and len(trim(url.CMPid))>
	<cfset form.CMPid = url.CMPid>
</cfif>
<cfif isdefined("url.COEGid") and not isdefined("form.COEGid") and len(trim(url.COEGid))>
	<cfset form.COEGid = url.COEGid>
</cfif>
<cftransaction>

<!---<cfquery name="rsInsertSeguiGarantia" datasource="#Session.DSN#">
	insert into COSeguiGarantia (COEGid,COSGObservación,COSGFecha, COSGUsucodigo, BMUsucodigo)
	values( ,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.COSGObservación#">,
			<cf_dbfunction name="now">,#session.Usucodigo#,#session.Usucodigo# )			
</cfquery>--->
<cfquery name="rsInsertSeguiGarantia" datasource="#Session.DSN#">
	insert into COSeguiGarantia (COEGid,COSGObservacion,COSGFecha, COSGUsucodigo, BMUsucodigo)  
	select b.COEGid,<CF_jdbcquery_param cfsqltype="cf_sql_char" value="#form.COSGObservacion#">,
        	<CF_jdbcquery_param cfsqltype="cf_sql_date" value="#form.Pfecha#">,#session.Usucodigo#, #session.Usucodigo#
        from  COHEGarantia b
			inner join SNegocios c
				on c.SNid = b.SNid
        where b.Ecodigo = #session.Ecodigo#
		and b.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
		and b.COEGVersionActiva=1
							
</cfquery>
</cftransaction>
<form action="SeguimientoGarantias-form.cfm" method="post" name="sql">
	<cfoutput>
		<input type="hidden" name="modo" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input type="hidden" name="CMPid"  value="<cfif isdefined("Form.CMPid")>#Form.CMPid#</cfif>">
		<input type="hidden" name="COEGid"  value="<cfif isdefined("Form.COEGid")>#Form.COEGid#</cfif>">
	</cfoutput>
</form>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>