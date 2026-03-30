<cfset LvarAction = 'TipoCambioRep.cfm'>
<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset MSG_TCExiste = t.Translate('MSG_TCExiste','El tipo de cambio ya existe para el periodo/mes')>

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="rsins" datasource="#Session.DSN#">
                select 1
                from TipoCambioReporte
                where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                  and Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">                      
                  and TCperiodo = <cfqueryparam value="#Form.TCperiodo#" cfsqltype="cf_sql_numeric">
                  and TCmes = <cfqueryparam value="#Form.TCmes#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfif rsins.RecordCount GT 0>
				 <cf_errorCode	code = "50223" msg = "#MSG_TCExiste#">
			<cfelse>
                <cfquery datasource="#Session.DSN#">
                    insert INTO TipoCambioReporte (Ecodigo, Mcodigo, TCperiodo, TCmes, TCtipocambio,BMUsucodigo)
                    values(
                        <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#Form.TCperiodo#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#Form.TCmes#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#Replace(Form.TCtipocambio,',','','all')#" cfsqltype="cf_sql_float">,
						#Session.Usucodigo#
                        )
                </cfquery>
			</cfif>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Baja")>
            <cfquery datasource="#Session.DSN#">
                delete from TipoCambioReporte
                where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                  and Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
				  and TCperiodo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Form.TCperiodo#">
				  and TCmes = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Form.TCmes#">
            </cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="TipoCambioReporte" 
				redirect="#LvarAction#"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo,integer,#session.Ecodigo#"
				field2="Mcodigo,numeric,#form.Mcodigo#"
				field3="TCperiodo" type3="integer" value3="#form.TCperiodo#"
				field4="TCmes" type4="integer" value4="#form.TCmes#"
                >
			<cfquery datasource="#Session.DSN#">
				update TipoCambioReporte set
					TCtipocambio = <cfqueryparam value="#Replace(Form.TCtipocambio,',','','all')#" cfsqltype="cf_sql_float">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                  and Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
				  and TCperiodo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Form.TCperiodo#">
				  and TCmes = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Form.TCmes#">
			</cfquery>
			<cfset modo="CAMBIO">
		</cfif>
		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>

<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo neq 'ALTA'>
		<input name="Mcodigo" 	type="hidden" value="<cfif isdefined("Form.Mcodigo")>#Form.Mcodigo#</cfif>">
		<input name="TCperiodo" type="hidden" value="<cfif isdefined("Form.TCperiodo")>#TCperiodo#</cfif>">
		<input name="TCmes" 	type="hidden" value="<cfif isdefined("Form.TCmes")>#TCmes#</cfif>">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</cfoutput>
</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


