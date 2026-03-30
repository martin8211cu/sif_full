<cfset modoMod = "ALTA">

<cftry>
	<cfif not isdefined("Form.btnNuevo")>
		<cfif isdefined("Form.Alta")>
			<!--- Si ya existe un registro con AFMMcodigo no permite insertarlo --->
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select AFMMcodigo
				from AFMModelos
				where Ecodigo           = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and AFMid            = <cfqueryparam value="#form.AFMid#" cfsqltype="cf_sql_numeric">
				  and upper(AFMMcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(Form.AFMMcodigo))#"> 
			</cfquery>
	
			<cfif #rsVerifica.recordCount# eq 0>	
				<cftransaction>
					<cfquery name="inserta" datasource="#session.DSN#">
						insert into AFMModelos (AFMid, Ecodigo, AFMMcodigo, AFMMdescripcion)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.AFMMcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFMMdescripcion#">
							)			
						<cf_dbidentity1 datasource="#Session.DSN#">										
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="inserta">		
				</cftransaction>	
				<cfset modoMod = "CAMBIO">
				<cfset form.AFMMid = inserta.identity>
			<cfelse>
				<cf_errorCode	code = "50041" msg = "No se puede agregar. Ya existe un modelo asignado.">
			</cfif>		
					
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delete" datasource="#session.DSN#">
				delete from AFMModelos
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and AFMid =  <cfqueryparam value="#form.AFMid#" cfsqltype="cf_sql_char">
					and AFMMid =  <cfqueryparam value="#form.AFMMid#" cfsqltype="cf_sql_numeric">				  
			</cfquery>
			<cfset modo = "ALTA">
		
		<cfelseif isdefined("Form.Cambio")>
			<!--- Si ya existe o soy yo mismo entonces permite modificarlo --->
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				select AFMMcodigo
				from AFMModelos
				where Ecodigo           = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
				  and AFMid            = <cfqueryparam value="#form.AFMid#" cfsqltype="cf_sql_numeric">				
				  and upper(AFMMcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.AFMMcodigo))#"> 
				  and upper(AFMMcodigo) <> <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.AFMMcodigoL))#"> 
			</cfquery>	
			<cfif #rsVerifica.recordCount# eq 0>		
				<cf_dbtimestamp datasource="#session.dsn#"
								table="AFMModelos"
								redirect="ACategoria.cfm"
								timestamp="#form.ts_rversion#"
								field1="AFMid" 
								type1="numeric" 
								value1="#form.AFMid#"
								field2="AFMMid" 
								type2="numeric" 
								value2="#form.AFMMid#"
								field3="Ecodigo" 
								type3="integer" 
								value3="#session.Ecodigo#"
								>
				
				<cfquery name="update" datasource="#session.DSN#">
					update AFMModelos set 
						AFMMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.AFMMcodigo#">,
						AFMMdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFMMdescripcion#">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and AFMid =  <cfqueryparam value="#form.AFMid#" cfsqltype="cf_sql_numeric">
						and AFMMid =  <cfqueryparam value="#form.AFMMid#" cfsqltype="cf_sql_numeric">				  
				</cfquery>
				<cfset modoMod = 'CAMBIO'>
			<cfelse>
				<cf_errorCode	code = "50042" msg = "No se puede modificar. Ya existe un modelo asignado.">
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
	<input name="modo"   type="hidden" value="CAMBIO">
	<input name="modoMod"   type="hidden" value="<cfif isdefined("modoMod")>#modoMod#</cfif>">	
	<input name="AFMid" type="hidden" value="#form.AFMid#">
	<cfif modoMod eq 'CAMBIO'>
		<input name="AFMMid" type="hidden" value="#form.AFMMid#">
	</cfif>	

	<!--- mantiene filtros del detalle --->
	<cfif isdefined("form.fAFMMcodigo") and len(trim(form.fAFMMcodigo))>
		<input type="hidden" name="fAFMMcodigo" value="#form.fAFMMcodigo#">
	</cfif>
	
	<!--- mantiene filtros del encabezado --->
	<cfif isdefined("form.fAFMMdescripcion") and len(trim(form.fAFMMdescripcion))>
		<input type="hidden" name="fAFMMdescripcion" value="#form.fAFMMdescripcion#">
	</cfif>

	<!--- Campos ocultos para mantener el filtro (si existe)--->
	<cfif isdefined("form.fAFMcodigo") and len(trim(form.fAFMcodigo))>
		<input type="hidden" name="fAFMcodigo" value="#trim(form.fAFMcodigo)#">
	</cfif>
	<cfif isdefined("form.fAFMdescripcion") and len(trim(form.fAFMdescripcion))>
		<input type="hidden" name="fAFMdescripcion" value="#trim(form.fAFMdescripcion)#">
	</cfif>
	<input name="Pagina2" type="hidden" value="<cfif isdefined("Form.Pagina2") and len(trim(Form.Pagina2)) and not isDefined("form.Baja")>#Form.Pagina2#<cfelse>1</cfif>">	
</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

