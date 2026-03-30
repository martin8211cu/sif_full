<cfset LvarAction = 'Htipocambio.cfm'>
<cfif isdefined("LvarQPass")>
	<cfset LvarAction = 'QPassTC.cfm'>
</cfif>

<cfparam name="modo" default="ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>

			<cfquery name="rsins" datasource="#Session.DSN#">
					select 1
					from Htipocambio
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
					  and Hfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Hfecha)#">
			</cfquery>

			<cfif rsins.RecordCount GT 0>
				 <cf_errorCode	code = "50223" msg = "La fecha de tipo de cambio ya existe">
			<cfelse>
				<cfset LvarFechaEncontrada = createdate(6100,1,1)>
				<cftransaction>
					<cfquery name="rsRegistroActual" datasource="#Session.dsn#">
						select Ecodigo, Mcodigo, Hfecha, Hfechah
						from Htipocambio
						where Ecodigo = #session.Ecodigo#
						  and Mcodigo = #Form.Mcodigo#
						  and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Hfecha)#"> 
						  and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Hfecha)#">
					</cfquery>
	
					<cfif rsRegistroActual.recordcount GT 0>
						<cfset LvarFecha  = CreateODBCDateTime(rsRegistroActual.Hfecha)>
						<cfset LvarFechah = CreateODBCDateTime(rsRegistroActual.Hfechah)>

						<cfquery datasource="#Session.dsn#">
							update Htipocambio
							set Hfechah = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Hfecha)#">
							where Ecodigo = #session.Ecodigo#
							  and Mcodigo = #Form.Mcodigo#
							  and Hfecha  = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> 
							  and Hfechah = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechah#"> 
						</cfquery>
						
						<cfset LvarFechaEncontrada = LvarFechah>
					</cfif>
	
					<cfquery datasource="#Session.DSN#">
						insert INTO Htipocambio (Ecodigo, Mcodigo, Hfecha, TCcompra, TCventa, TCpromedio, Hfechah)
						values(
							<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Hfecha)#">,
							<cfqueryparam value="#Replace(Form.TCcompra,',','','all')#" cfsqltype="cf_sql_float">,
							<cfqueryparam value="#Replace(Form.TCventa,',','','all')#" cfsqltype="cf_sql_float">,
							<cfqueryparam value="#Replace(Form.TCpromedio,',','','all')#" cfsqltype="cf_sql_float">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaEncontrada#">)
					</cfquery>
				</cftransaction>
			</cfif>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Baja")>
			<!--- 1.  Buscar el registro que se borra --->
			<cfquery name="rsRegistroActual" datasource="#Session.dsn#">
				select Ecodigo, Mcodigo, Hfecha, Hfechah
				from Htipocambio
				where Ecodigo = #session.Ecodigo#
				  and Mcodigo = #Form.Mcodigo#
				  and Hfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Hfecha)#">
			</cfquery>

			<cfset LvarFecha  = CreateODBCDateTime(rsRegistroActual.Hfecha)>
			<cfset LvarFechah = CreateODBCDateTime(rsRegistroActual.Hfechah)>

			<!--- 2.  Buscar el registro anterior al que se borra --->
			<cfquery name="rsRegistroAnterior" datasource="#Session.dsn#">
				select Ecodigo, Mcodigo, Hfecha, Hfechah
				from Htipocambio
				where Ecodigo = #session.Ecodigo#
				  and Mcodigo = #Form.Mcodigo#
				  and Hfecha  < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> 
				  and Hfechah = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> 
			</cfquery>

			<cftransaction>
				<cfif rsRegistroAnterior.recordcount GT 0>
					
					<cfset LvarFechaAnterior  = CreateODBCDateTime(rsRegistroAnterior.Hfecha)>
					<cfset LvarFechaAnteriorh = CreateODBCDateTime(rsRegistroAnterior.Hfechah)>

					<cfquery datasource="#Session.dsn#">
						update Htipocambio
						set Hfechah = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechah#"> 
						where Ecodigo = #session.Ecodigo#
						  and Mcodigo = #Form.Mcodigo#
						  and Hfecha  = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaAnterior#"> 
						  and Hfechah = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaAnteriorh#"> 
					</cfquery>
				</cfif>
				
				<cfquery datasource="#Session.DSN#">
					delete from Htipocambio
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
					  and Hfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.Hfecha)#">
				</cfquery>

			</cftransaction>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="Htipocambio" 
				redirect="#LvarAction#"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo,integer,#session.Ecodigo#"
				field2="Mcodigo,numeric,#form.Mcodigo#"
				field3="Hfecha" type3="timestamp" value3="#LSParseDateTime(form.Hfecha)#">
			<cfquery datasource="#Session.DSN#">
				update Htipocambio set
					TCcompra = <cfqueryparam value="#Replace(Form.TCcompra,',','','all')#" cfsqltype="cf_sql_float">,
					TCventa = <cfqueryparam value="#Replace(Form.TCventa,',','','all')#" cfsqltype="cf_sql_float">,
					TCpromedio = <cfqueryparam value="#Replace(Form.TCpromedio,',','','all')#" cfsqltype="cf_sql_float">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
				  and Hfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.Hfecha)#">
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
		<input name="Mcodigo" type="hidden" value="<cfif isdefined("Form.Mcodigo")>#Form.Mcodigo#</cfif>">
		<input name="Hfecha" type="hidden" value="<cfif isdefined("Form.Hfecha")>#LSParseDateTime(Form.Hfecha)#</cfif>">
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


