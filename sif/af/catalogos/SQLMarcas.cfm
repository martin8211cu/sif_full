<cfset modo = "ALTA">

<cftry>
	<cfif not isdefined("Form.btnNuevo")>
		<cfif isdefined("Form.Alta")>
			<!--- Si ya existe un registro con AFMcodigo no permite insertarlo --->
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select AFMcodigo
				from AFMarcas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
				  and upper(AFMcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(Form.AFMcodigo))#"> 
			</cfquery>	
	
			<cfif #rsVerifica.recordCount# eq 0>
				<cftransaction>
					<cfquery name="inserta" datasource="#session.DSN#">
						insert into AFMarcas (Ecodigo, AFMcodigo, AFMdescripcion, AFMuso)
							values (
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.AFMcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFMdescripcion#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.AFMuso#">
							)
						<cf_dbidentity1 datasource="#Session.DSN#">					
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="inserta">
				</cftransaction>
				<cfset modo = "CAMBIO">
				<cfset form.AFMid = inserta.identity>
			<cfelse>
				<cf_errorCode	code = "50039" msg = "No se puede agregar. Ya existe una marca asignada.">							
			</cfif>			
			
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="rsAFMModelos" datasource="#session.DSN#">
				delete from AFMModelos
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and AFMid =  <cfqueryparam value="#form.AFMid#" cfsqltype="cf_sql_numeric">
			</cfquery>
					
			<cfquery name="rsAFMarcas" datasource="#session.DSN#">
				delete from AFMarcas
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and AFMid =  <cfqueryparam value="#form.AFMid#" cfsqltype="cf_sql_numeric">				  
			</cfquery>
			<cfset modo = "ALTA">
				
		<cfelseif isdefined("Form.Cambio")>
			<!--- Si ya existe o soy yo mismo entonces permite modificarlo --->
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select AFMcodigo
				from AFMarcas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
				  and upper(AFMcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.AFMcodigo))#"> 
				  and upper(AFMcodigo) <> <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.AFMcodigoL))#"> 
			</cfquery>	
			<cfif #rsVerifica.recordCount# eq 0>		
		
				<cf_dbtimestamp datasource="#session.dsn#"
								table="AFMarcas"
								redirect="ACategoria.cfm"
								timestamp="#form.ts_rversion#"
								field1="AFMid" 
								type1="numeric" 
								value1="#form.AFMid#"
								field2="Ecodigo" 
								type2="integer" 
								value2="#session.Ecodigo#"
								>
		
				<cfquery name="update" datasource="#session.DSN#">
					update AFMarcas set 
						AFMcodigo = <cfqueryparam  cfsqltype="cf_sql_char" value="#form.AFMcodigo#">,
						AFMdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFMdescripcion#">,
						AFMuso = <cfqueryparam cfsqltype="cf_sql_char" value="#form.AFMuso#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and AFMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid#" >
				</cfquery>
				<cfset modo = 'CAMBIO'>				  
			<cfelse>
				<cf_errorCode	code = "50040" msg = "No se puede modificar. Ya existe una marca asignada.">
			</cfif>
		</cfif>
	</cfif>

	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cfoutput>
<form action="MarcasMod.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="AFMid" type="hidden" value="<cfif isdefined("Form.AFMid")>#Form.AFMid#</cfif>">
	<input name="Pagina1" type="hidden" value="<cfif isdefined("Form.Pagina1") and len(trim(Form.Pagina1)) and not isDefined("form.Baja")>#Form.Pagina1#<cfelse>1</cfif>">	
			
	<cfif not isdefined("form.Nuevo")>
		<!--- Campos ocultos para mantener el filtro (si existe)--->
		<cfif isdefined("form.fAFMcodigo") and len(trim(form.fAFMcodigo))>
			<input type="hidden" name="fAFMcodigo" value="#trim(form.fAFMcodigo)#">
		</cfif>
		<cfif isdefined("form.fAFMdescripcion") and len(trim(form.fAFMdescripcion))>
			<input type="hidden" name="fAFMdescripcion" value="#trim(form.fAFMdescripcion)#">
		</cfif>
	</cfif>
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

