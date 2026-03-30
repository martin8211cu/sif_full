
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
			insert into CMNDocumentoAdjunto ( CMNid, CMNDAnombre, Usucodigo, CMNDAfechaAlta, CMNDAextension, CMNDAdocumento)
				values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CMNid#">,
						<cfif len(trim(Form.CMNDAnombre))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.CMNDAnombre)#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#extension#">,
						<cfif isdefined("Form.CMNDAdocumento") and len(trim(Form.CMNDAdocumento))><cf_dbupload filefield="CMNDAdocumento" accept="*/*" datasource="#session.DSN#"><cfelse>null</cfif> 
				)		
		</cfquery>
		<cfset form.CMNDAextension = "">
		<cfset modo = "ALTA">	
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from CMNDocumentoAdjunto
			where CMNDAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMNDAid#">
				and CMNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CMNid#">				
		</cfquery>
		<cfset modo = "ALTA">	
		<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.DSN#"
			 			table="CMNDocumentoAdjunto"
			 			redirect="ObjetosCompras.cfm?NotaId=#url.CMNid#"
			 			timestamp="#form.ts_rversion#"				
						field1="CMNDAid" 
						type1="numeric" 
						value1="#form.CMNDAid#"
						field2="CMNid" 
						type2="numeric" 
						value2="#url.CMNid#"
						>
	 	
		<cfset extension1 = listtoarray(form.nArchivo,'.')>
		<cfif (arraylen(extension1)) NEQ 0>
			<cfset extension = extension1[arraylen(extension1)]>
			<cfquery name="UpdateExtension" datasource="#session.DSN#">
				update CMNDocumentoAdjunto set
					CMNDAextension = <cfif len(trim(extension))><cfqueryparam cfsqltype="cf_sql_char" value="#extension#"><cfelse>null</cfif>
				where CMNDAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMNDAid#">
					and CMNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CMNid#">									
			</cfquery>
		</cfif>

		<cfquery name="update" datasource="#session.DSN#">
			update CMNDocumentoAdjunto set
				CMNDAnombre = <cfif len(trim(Form.CMNDAnombre))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.CMNDAnombre)#"><cfelse>null</cfif>
				<cfif len(trim(form.CMNDAdocumento))>, DDAdocumento = <cf_dbupload filefield="CMNDAdocumento" accept="*/*" datasource="#session.DSN#"></cfif>
			where CMNDAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMNDAid#">
				and CMNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CMNid#">
		</cfquery> 

		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="ObjetosCompras.cfm?NotaId=#url.CMNid#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="CMNDAid" type="hidden" value="<cfif isdefined("Form.CMNDAid") and modo NEQ 'ALTA'>#Form.CMNDAid#</cfif>">	
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
