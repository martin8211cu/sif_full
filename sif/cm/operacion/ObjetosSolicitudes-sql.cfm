
<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		
		<cfset extension1 = listtoarray(form.nArchivo,'.')>
		<cfset extension = extension1[arraylen(extension1)]>
		<!--- <cfdump var="#form.nArchivo#">
		<cfdump var="#extension1#">
		<cfdump var="#extension#">
		 <cfabort> --->
		<cfquery name="insert" datasource="#session.DSN#">
			insert into DDocumentosAdjuntos (CMPid, DSlinea, DDAnombre, Usucodigo, fechaalta, DDAextension, DDAdocumento)
				values( 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#" null="#Session.Compras.ProcesoCompra.CMPid EQ ""#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DSLinea1#">,
						<cfif len(trim(Form.DDAnombre))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.DDAnombre)#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#extension#">,
						<cfif isdefined("Form.DDAdocumento") and len(trim(Form.DDAdocumento))><cf_dbupload filefield="DDAdocumento" accept="*/*" datasource="#session.DSN#"><cfelse>null</cfif> 
				)		
		</cfquery>
		<cfset form.DDAextension = "">
		<cfset modo = "ALTA">	
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from DDocumentosAdjuntos
			where DDAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DDAid#">
				and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DSlinea1#">
		</cfquery>
		<cfset modo = "ALTA">	
	
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.DSN#"
			 			table="DDocumentosAdjuntos"
			 			redirect="ObjetosSolicitudes.cfm?DSlinea1=#url.DSlinea1#"
			 			timestamp="#form.ts_rversion#"				
						field1="DDAid" 
						type1="numeric" 
						value1="#form.DDAid#"
						field2="DSlinea" 
						type2="numeric" 
						value2="#url.DSlinea1#"
						>
	 	
		<cfset extension1 = listtoarray(form.nArchivo,'.')>
		<cfif (arraylen(extension1)) NEQ 0>
			<cfset extension = extension1[arraylen(extension1)]>
			<cfquery name="UpdateExtension" datasource="#session.DSN#">
				update DDocumentosAdjuntos set
					DDAextension = <cfif len(trim(extension))><cfqueryparam cfsqltype="cf_sql_char" value="#extension#"><cfelse>null</cfif>
				where DDAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DDAid#">
					and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DSlinea1#">
			</cfquery>
		</cfif>

		<cfquery name="update" datasource="#session.DSN#">
			update DDocumentosAdjuntos set
				DDAnombre = <cfif len(trim(Form.DDAnombre))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.DDAnombre)#"><cfelse>null</cfif>
				<cfif len(trim(form.DDAdocumento))>, DDAdocumento = <cf_dbupload filefield="DDAdocumento" accept="*/*" datasource="#session.DSN#"></cfif>
			where DDAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DDAid#">
				and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DSlinea1#">
		</cfquery> 

		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="ObjetosSolicitudes.cfm?DSlinea1=#url.DSlinea1#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="DDAid" type="hidden" value="<cfif isdefined("Form.DDAid") and modo NEQ 'ALTA'>#Form.DDAid#</cfif>">
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
