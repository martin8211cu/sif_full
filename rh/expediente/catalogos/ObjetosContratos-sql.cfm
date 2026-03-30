<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		
		<cfset extension1 = listtoarray(form.nArchivo,'.')>
		<cfset extension = extension1[arraylen(extension1)]>
		 
		<cfquery name="insert" datasource="#session.DSN#">
			insert into ObjetosContrato ( ECid, OCdescripcion, Usucodigo, fechaalta, OCarchivo, OCextension, OCdato )
				values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">,
						<cfif len(trim(Form.OCdescripcion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.OCdescripcion)#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfif len(trim(Form.OCarchivo))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.OCarchivo)#"><cfelse>null</cfif>,		
						<cfqueryparam cfsqltype="cf_sql_char" value="#extension#">,
						<cfif isdefined("Form.OLPdato") and len(trim(Form.OLPdato))><cf_dbupload filefield="OLPdato" accept="*/*" datasource="#session.DSN#"><cfelse>null</cfif> 
				)		
		</cfquery>
		<cfset form.OCextension = "">
		<cfset modo = "ALTA">	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from ObjetosContrato
			where OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCid#">
				and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>
		<cfset modo = "ALTA">	
	
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.DSN#"
			 			table="ObjetosContrato"
			 			redirect="ObjetosContratos.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="OCid" 
						type1="numeric" 
						value1="#form.OCid#"
						field2="ECid" 
						type2="numeric" 
						value2="#form.ECid#"
						>
	 	
		<cfset extension1 = listtoarray(form.nArchivo,'.')>
		<cfif (arraylen(extension1)) NEQ 0>
			<cfset extension = extension1[arraylen(extension1)]>
			<cfquery name="UpdateExtension" datasource="#session.DSN#">
				update ObjetosContrato set
					OCextension = <cfif len(trim(extension))><cfqueryparam cfsqltype="cf_sql_char" value="#extension#"><cfelse>null</cfif>
				where OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCid#">
					and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
					
			</cfquery>
		</cfif>

		<cfquery name="update" datasource="#session.DSN#">
			update ObjetosContrato set
				OCdescripcion = <cfif len(trim(Form.OCdescripcion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.OCdescripcion)#"><cfelse>null</cfif>,		
				OCarchivo = <cfif len(trim(Form.OCarchivo))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.OCarchivo)#"><cfelse>null</cfif>
				<cfif len(trim(OLPdato))>, OCdato = <cf_dbupload filefield="OLPdato" accept="*/*" datasource="#session.DSN#"></cfif>
			where OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCid#">
				and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery> 

		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="ObjetosContratos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="OCid" type="hidden" value="<cfif isdefined("Form.OCid") and modo NEQ 'ALTA'>#Form.OCid#</cfif>">
	<input name="ECid" type="hidden" value="<cfif isdefined("Form.ECid")>#Form.ECid#</cfif>">
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
	<input type="hidden" name="SNcodigo" value="<cfif isdefined("Form.SNCodigo") and modo NEQ 'ALTA'>#Form.SNCodigo#</cfif>">
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
