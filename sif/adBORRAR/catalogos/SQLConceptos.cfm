<cfset params = "">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
		<cfquery name="insConceptos" datasource="#Session.DSN#">			
			insert into Conceptos (Ecodigo, Ccodigo, Cdescripcion, CCid, Ctipo, Ucodigo, Cimportacion, cuentac, Cformato)
			values (				
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ccodigo#">)),
				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">)), 
				 <cfif len(trim(form.CCid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#"><cfelse>null</cfif>,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ctipo#">,
				 <cfif len(trim(form.Ucodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Ucodigo)#"><cfelse>null</cfif>,
				 <cfif isdefined("form.Cimportacion")>1<cfelse>0</cfif>,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentac#">,
				 <cfif isdefined("form.Cmayor") and len(trim(form.Cmayor)) gt 0 and isdefined("form.Cformato") and len(trim(form.Cformato)) gt 0>
					<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Cmayor) & "-" & trim(form.Cformato)#">
				 <cfelse>
					null
				 </cfif>
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="insConceptos">	
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select Cid
			from Conceptos
			where 1=1 
			  <cfif isdefined('form.filtro_Ccodigo') and LEN(TRIM(form.filtro_Ccodigo))>
			  and upper(Ccodigo) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(form.filtro_Ccodigo)#%">
			  </cfif>
			  <cfif isdefined('form.filtro_Cdescripcion') and LEN(TRIM(form.filtro_Cdescripcion))>
			  and upper(Cdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.filtro_Cdescripcion)#%">
			  </cfif>
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  <cfif isdefined('form.fTipo') and form.fTipo NEQ 'T'>
			  and Ctipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.fTipo#">
			  </cfif>
			  <cfif session.menues.SMcodigo eq 'CC'>
			  and Ctipo = <cfqueryparam cfsqltype="cf_sql_char" value="I">
			  <cfelseif	session.menues.SMcodigo eq 'CP'>
			  and Ctipo = <cfqueryparam cfsqltype="cf_sql_char" value="G">
			  </cfif>
			order by Ccodigo
		</cfquery>
		<cfset params=params&"&Cid="&insConceptos.identity>	
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.Cid EQ insConceptos.identity>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		</cftransaction>
		<cfset form.pagina = Ceiling(row / form.MaxRows)>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delConceptos" datasource="#Session.DSN#">
			delete from CuentasConceptos
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Cid = <cfqueryparam value="#Form.Cid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<cfquery name="delConceptos" datasource="#Session.DSN#">
			delete from Conceptos
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Cid = <cfqueryparam value="#Form.Cid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cf_sifcomplementofinanciero action='delete'
			tabla="Conceptos"
			form = "form"
			llave="#form.Cid#" />	
							
		<cfset form.pagina = 1> 		
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="Conceptos" 
			redirect="Conceptos.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#Session.Ecodigo#"
			field2="Cid,numeric,#form.Cid#">

		<cfquery name="updConceptos" datasource="#Session.DSN#">
			update Conceptos set 
				Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ccodigo#">,
				Cdescripcion=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">, 
				Ctipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ctipo#">,
				Ucodigo = <cfif len(trim(form.Ucodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Ucodigo)#"><cfelse>null</cfif>,
				CCid = <cfif len(trim(form.CCid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#"><cfelse>null</cfif>,
				Cimportacion = <cfif isdefined("form.Cimportacion")>1<cfelse>0</cfif>,
				cuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentac#">,
				Cformato = <cfif isdefined("form.Cmayor") and len(trim(form.Cmayor)) gt 0 and isdefined("form.Cformato") and len(trim(form.Cformato)) gt 0>
										<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Cmayor) & "-" & trim(form.Cformato)#">
									 <cfelse>
										null
									 </cfif>
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Cid = <cfqueryparam value="#Form.Cid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery name="updGEconceptoGasto" datasource="#Session.DSN#">
			update GEconceptoGasto set
				GECdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">
			where Cid = <cfqueryparam value="#Form.Cid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<cf_sifcomplementofinanciero action='update'
			tabla="Conceptos"
			form = "form"
			llave="#form.Cid#" />	
			<cfset params=params&"&Cid="&form.Cid>	 				
	</cfif>
</cfif>

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.Cid') and form.Cid NEQ ''>
		<cfset params= params&'&Cid='&form.Cid>	
	</cfif>
</cfif>
<cfif isdefined('form.filtro_Ccodigo') and form.filtro_Ccodigo NEQ ''>
	<cfset params= params&'&filtro_Ccodigo='&form.filtro_Ccodigo>	
	<cfset params= params&'&hfiltro_Ccodigo='&form.filtro_Ccodigo>		
</cfif>
<cfif isdefined('form.filtro_Cdescripcion') and form.filtro_Cdescripcion NEQ ''>
	<cfset params= params&'&filtro_Cdescripcion='&form.filtro_Cdescripcion>	
	<cfset params= params&'&hfiltro_Cdescripcion='&form.filtro_Cdescripcion>		
</cfif>
<cfif isdefined('form.fTipo') and form.fTipo NEQ ''>
	<cfset params= params&'&fTipo='&form.fTipo>	
	<cfset params= params&'&hfTipo='&form.fTipo>		
</cfif>

<cflocation url="Conceptos.cfm?Pagina=#Form.Pagina##params#">
