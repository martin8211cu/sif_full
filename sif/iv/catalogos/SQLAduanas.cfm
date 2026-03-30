<!---- *****************************************************************************************************----->
<!---SQL que trae registros cuando el codigo aduanal digitado por el usuario ya existe--->
<cfquery name="rsExiste" datasource="#Session.DSN#">
	select CMAcodigo 
	from CMAduanas
	where CMAcodigo = <cfqueryparam value="#form.CMAcodigo#" cfsqltype="cf_sql_char">
</cfquery>

<cfif isdefined("form.Alta")>
	<cfif rsExiste.recordcount GE 1>
		<cf_errorCode	code = "50394" msg = "El registro que desea ingresar ya existe">
		<cflocation url="formAduanas.cfm">
	</cfif>
</cfif>

<!--- Si la opcion elegida es la de Modificar un Codigo existente verifica que lo que se esta modificando es el codigo el resto no importa--->
<cfif isdefined("form.Cambio") and form.CMAcodigo2 NEQ form.CMAcodigo>
	<cfif rsExiste.recordcount GE 1>
		<cf_errorCode	code = "50394" msg = "El registro que desea ingresar ya existe">
		<cflocation url="formAduanas.cfm">
	</cfif>
</cfif>
<!---- *****************************************************************************************************----->
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cftransaction>
				<cfquery name="insert" datasource="#Session.DSN#">
					insert into CMAduanas(Ecodigo, CMAcodigo,CMAdescripcion,Usucodigo, fechaalta) 
					values ( <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#Form.CMAcodigo#" cfsqltype="cf_sql_char">,
							 <cfqueryparam value="#Form.CMAdescripcion#" cfsqltype="cf_sql_varchar">,
							 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
							 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
						   )
						<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert"> 
			</cftransaction>
			  
			<cfif isdefined('insert')>
				<cfset form.CMAid = insert.identity>		
			</cfif>
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delete" datasource="#session.DSN#">
				delete from CMAduanas
				where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
				  and  CMAid = <cfqueryparam value="#form.CMAid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="CMAduanas"
							redirect="Aduanas.cfm"
							timestamp="#form.ts_rversion#"
							field1="CMAid" 
							type1="numeric" 
							value1="#form.CMAid#"
							>
	
			<cfquery name="update" datasource="#Session.DSN#">
				update CMAduanas set
					   CMAcodigo   = <cfqueryparam value="#Form.CMAcodigo#" cfsqltype="cf_sql_char">,
					   CMAdescripcion   = <cfqueryparam value="#Form.CMAdescripcion#" cfsqltype="cf_sql_varchar">
				where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  CMAid = <cfqueryparam value="#form.CMAid#" cfsqltype="cf_sql_numeric">
			</cfquery> 
		</cfif>
	</cfif>
	
<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.CMAid') and form.CMAid NEQ ''>
		<cfset params= params&'&CMAid='&form.CMAid>	
	</cfif>
</cfif>
<cfif isdefined('form.filtro_CMAcodigo') and form.filtro_CMAcodigo NEQ ''>
	<cfset params= params&'&filtro_CMAcodigo='&form.filtro_CMAcodigo>	
	<cfset params= params&'&hfiltro_CMAcodigo='&form.filtro_CMAcodigo>		
</cfif>
<cfif isdefined('form.filtro_CMAdescripcion') and form.filtro_CMAdescripcion NEQ ''>
	<cfset params= params&'&filtro_CMAdescripcion='&form.filtro_CMAdescripcion>	
	<cfset params= params&'&hfiltro_CMAdescripcion='&form.filtro_CMAdescripcion>		
</cfif>
<cflocation url="Aduanas.cfm?Pagina=#Form.Pagina##params#">

