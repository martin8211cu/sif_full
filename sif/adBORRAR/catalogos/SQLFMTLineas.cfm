<cfif not isdefined("Form.btnNuevo")>
	<cftry>
		<cfquery name="Lineas" datasource="#Session.DSN#">
			<cfif isdefined("Form.btnAgregar")>
				insert into FMT009( FMT01COD, FMT09LIN, FMT09COL, FMT09FIL, FMT09CLR, FMT09CFN, FMT09HEI, FMT09WID, FMT09GRS )
				values ( <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.FMT01COD)#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT09LIN#">,
						 <cfqueryparam cfsqltype="cf_sql_float" value="#form.FMT09COL#">,
						 <cfqueryparam cfsqltype="cf_sql_float" value="#form.FMT09FIL#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.FMT09CLR)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.FMT09CFN)#">,
						 <cfqueryparam cfsqltype="cf_sql_float" value="#form.FMT09HEI#">,
						 <cfqueryparam cfsqltype="cf_sql_float" value="#form.FMT09WID#">,
						 <cfqueryparam cfsqltype="cf_sql_float" value="#form.FMT09GRS#">
					   )
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.btnEliminar")>
				delete from FMT009 
				where rtrim(FMT01COD) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.FMT01COD)#">
				  and FMT09LIN        = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT09LIN#">
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.btnModificar")>
				update FMT009 
				set FMT09COL = <cfqueryparam cfsqltype="cf_sql_float" value="#form.FMT09COL#">, 
					FMT09FIL = <cfqueryparam cfsqltype="cf_sql_float" value="#form.FMT09FIL#">, 
					FMT09CLR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.FMT09CLR)#">, 
					FMT09CFN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.FMT09CFN)#">, 
					FMT09HEI = <cfqueryparam cfsqltype="cf_sql_float" value="#form.FMT09HEI#">, 
					FMT09WID = <cfqueryparam cfsqltype="cf_sql_float" value="#form.FMT09WID#">, 
					FMT09GRS = <cfqueryparam cfsqltype="cf_sql_float" value="#form.FMT09GRS#">
				where rtrim(FMT01COD) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.FMT01COD)#">
				  and FMT09LIN        = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT09LIN#">

			<cfset modo="CAMBIO">
			</cfif>
		</cfquery>
		<cfcatch type="database">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<form action="FMTLineas.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="FMT01COD" type="hidden" value="<cfif isdefined("form.FMT01COD")><cfoutput>#form.FMT01COD#</cfoutput></cfif>">
	<cfif modo eq 'CAMBIO' ><input name="FMT09LIN" type="hidden" value="<cfif isdefined("form.FMT09LIN")><cfoutput>#form.FMT09LIN#</cfoutput></cfif>"></cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

