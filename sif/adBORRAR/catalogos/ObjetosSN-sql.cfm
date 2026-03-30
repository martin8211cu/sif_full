<!---  <cf_dump var="#form#">--->

<cfset modo = "ALTA">
<cfif not isdefined("Form.NuevoObjetos")>
	<cfif isdefined("Form.AltaObjetos")>
		
		<cfset extension1 = listtoarray(form.nArchivo,'.')>
		<cfset extension = extension1[arraylen(extension1)]>
		 
		<cfquery name="insSNegociosObjetos" datasource="#session.DSN#">
			insert into SNegociosObjetos (Ecodigo, SNcodigo, SNOdescripcion, SNOarchivo, SNOcontenttype, SNOcontenido, BMfalta, BMUsucodigo)
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNOdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNOarchivo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#extension#">,
						<cfif isdefined("Form.OLPdato") and len(trim(Form.OLPdato))><cf_dbupload filefield="OLPdato" accept="*/*" datasource="#session.DSN#"><cfelse>null</cfif>, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					)		
		</cfquery>
		<cfset form.SNOcontenttype = "">
		<cfset modo = "ALTA">	
		
	<cfelseif isdefined("Form.BajaObjetos")>
		<cfquery name="delSNegociosObjetos" datasource="#session.DSN#">
			delete from SNegociosObjetos
			where SNOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNOid#">
				and SNcodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfset modo = "ALTA">	
	
	<cfelseif isdefined("Form.CambioObjetos")>
		<cf_dbtimestamp datasource="#session.DSN#"
			 			table="SNegociosObjetos"
			 			redirect="ObjetosSN.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="SNOid" type1="numeric" value1="#form.SNOid#"
						field2="SNcodigo" type2="integer" value2="#form.SNcodigo#">
	 	
		<cfset extension1 = listtoarray(form.nArchivo,'.')>
		<cfif (arraylen(extension1)) NEQ 0>
			<cfset extension = extension1[arraylen(extension1)]>
			<cfquery name="UpdateSNegociosObjetos" datasource="#session.DSN#">
				update SNegociosObjetos
					set	SNOcontenttype = <cfif len(trim(extension))><cfqueryparam cfsqltype="cf_sql_char" value="#extension#"><cfelse>null</cfif>
				where SNOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNOid#">
					and SNcodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			</cfquery>
		</cfif>

		<cfquery name="UpdateSNegociosObjetos2" datasource="#session.DSN#">
			update SNegociosObjetos 
			set SNOdescripcion = <cfif len(trim(Form.SNOdescripcion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.SNOdescripcion)#"><cfelse>null</cfif>,		
				SNOarchivo = <cfif len(trim(Form.SNOarchivo))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.SNOarchivo)#"><cfelse>null</cfif>
				<cfif len(trim(OLPdato))>, SNOcontenido = <cf_dbupload filefield="OLPdato" accept="*/*" datasource="#session.DSN#"></cfif>
			where SNOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNOid#">
					and SNcodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		</cfquery> 

		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="Socios.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Pagina" type="hidden"  value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
	<input name="SNcodigo" type="hidden" value="<cfif isdefined("Form.SNcodigo")>#Form.SNcodigo#</cfif>">
	<input name="SNCcodigo" type="hidden" value="<cfif isdefined("Form.SNCcodigo")>#Form.SNCcodigo#</cfif>">
	<input name="SNOid" type="hidden" value="<cfif isdefined("Form.SNOid") and modo NEQ 'ALTA'>#Form.SNOid#</cfif>">
	<input name="tab" type="hidden" value="6">
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
