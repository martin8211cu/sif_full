
<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>

		 <cfset extension1 = listtoarray(form.nArchivo,'.')>
		 <cfset extension = extension1[arraylen(extension1)]>
		
		<cfquery name="insert" datasource="sifpublica">
			insert into ObjetosListaPrecios ( ELPid, OLPdescripcion, Usucodigo, fechaalta, OLParchivo, OLPextension, OLPdato )
				values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ELPid#">,
						<cfif len(trim(Form.OLPdescripcion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.OLPdescripcion)#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfif len(trim(Form.OLParchivo))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.OLParchivo)#"><cfelse>null</cfif>,		
						<cfqueryparam cfsqltype="cf_sql_char" value="#extension#">,
						<cfif isdefined("Form.OLPdato") and len(trim(Form.OLPdato))><cf_dbupload filefield="OLPdato" accept="*/*" datasource="sifpublica"><cfelse>null</cfif>
				)		
		</cfquery>

		<cfset form.OLPextension = "">
		<cfset modo = "ALTA">	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="sifpublica">
			delete from ObjetosListaPrecios
			where OLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OLPid#">
				and ELPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ELPid#">
		</cfquery>
		<cfset modo = "ALTA">	
	
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="sifpublica"
			 			table="ObjetosListaPrecios"
			 			redirect="ObjetosListaPrecios.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="OLPid" 
						type1="numeric" 
						value1="#form.OLPid#"
						field2="ELPid" 
						type2="numeric" 
						value2="#form.ELPid#"
						>
		
		<cfset extension1 = listtoarray(form.nArchivo,'.')>
		<cfif (arraylen(extension1)) NEQ 0>
			<cfset extension = extension1[arraylen(extension1)]>
			<cfquery name="UpdateExtension" datasource="sifpublica">
				update ObjetosListaPrecios set
					OLPextension = <cfif len(trim(extension))><cfqueryparam cfsqltype="cf_sql_char" value="#extension#"><cfelse>null</cfif>
			</cfquery>
		</cfif>
		<cfquery name="update" datasource="sifpublica">
			update ObjetosListaPrecios set
				OLPdescripcion = <cfif len(trim(Form.OLPdescripcion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.OLPdescripcion)#"><cfelse>null</cfif>,		
				OLParchivo = <cfif len(trim(Form.OLParchivo))><cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.OLParchivo)#"><cfelse>null</cfif>,
				OLPdato = <cf_dbupload filefield="OLPdato" accept="*/*" datasource="sifpublica">
			where OLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OLPid#">
				and ELPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ELPid#">
		</cfquery> 
<!---		OLPextension = <cfif len(trim(extension))><cfqueryparam cfsqltype="cf_sql_char" value="#extension#"><cfelse>null</cfif>, --->

		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="ObjetosListaPrecios.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="OLPid" type="hidden" value="<cfif isdefined("Form.OLPid") and modo NEQ 'ALTA'>#Form.OLPid#</cfif>">
	<input name="ELPid" type="hidden" value="<cfif isdefined("Form.ELPid")>#Form.ELPid#</cfif>">
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
