<!---- *****************************************************************************************************----->
<!---SQL que trae registros cuando la agencia aduanal digitada por el usuario ya existe--->
	<cfquery name="rsExiste" datasource="#Session.DSN#">
		select CMAAcodigo 
		from CMAgenciaAduanal
		where CMAAcodigo = <cfqueryparam value="#form.CMAAcodigo#" cfsqltype="cf_sql_char">
	</cfquery>

<cfif isdefined("form.Alta")>
	<cfif rsExiste.recordcount GE 1>
		<cf_errorCode	code = "50394" msg = "El registro que desea ingresar ya existe">
		<cflocation url="formAgenciaAduanal.cfm">
	</cfif>
</cfif>

<!--- Si la opcion elegida es la de Modificar una Agencia existente verifica que lo que se esta modificando es el codigo el resto no importa--->
<cfif isdefined("form.Cambio") and form.CMAAcodigo2 NEQ form.CMAAcodigo>
 	<cfif rsExiste.recordcount GE 1>
		<cf_errorCode	code = "50394" msg = "El registro que desea ingresar ya existe">
		<cflocation url="formAgenciaAduanal.cfm">
	</cfif>
</cfif>
<!---- *****************************************************************************************************----->
<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>	
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into CMAgenciaAduanal(Ecodigo, CMAAcodigo,CMAAdescripcion,SNcodigo,Usucodigo, fechaalta) 
				values ( <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#Form.CMAAcodigo#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.CMAAdescripcion#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">,					 
						 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
					   )
					<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insert"> 
		</cftransaction>
		  
		<cfif isdefined('insert')>
			<cfset form.CMAAid = insert.identity>		
		</cfif>
	<cfelseif isdefined("Form.Baja")>
			<cfquery name="delete" datasource="#session.DSN#">
				delete from CMAgenciaAduanal
				where  CMAAid = <cfqueryparam value="#form.CMAAid#" cfsqltype="cf_sql_numeric">
				  and  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
			</cfquery>
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="CMAgenciaAduanal"
			 			redirect="AgenciaAduanal.cfm"
			 			timestamp="#form.ts_rversion#"
						field1="CMAAid" 
						type1="numeric" 
						value1="#form.CMAAid#"
						>

		<cfquery name="update" datasource="#Session.DSN#">
			update CMAgenciaAduanal set
				   CMAAcodigo   = <cfqueryparam value="#Form.CMAAcodigo#" cfsqltype="cf_sql_char">,
				   CMAAdescripcion   = <cfqueryparam value="#Form.CMAAdescripcion#" cfsqltype="cf_sql_varchar">,
				   SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">					 
			where  CMAAid = <cfqueryparam value="#form.CMAAid#" cfsqltype="cf_sql_numeric">
				and Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.CMAAid') and form.CMAAid NEQ ''>
		<cfset params= params&'&CMAAid='&form.CMAAid>	
	</cfif>
</cfif>
<cfif isdefined('form.filtro_CMAAcodigo') and form.filtro_CMAAcodigo NEQ ''>
	<cfset params= params&'&filtro_CMAAcodigo='&form.filtro_CMAAcodigo>	
	<cfset params= params&'&hfiltro_CMAAcodigo='&form.filtro_CMAAcodigo>		
</cfif>
<cfif isdefined('form.filtro_CMAAdescripcion') and form.filtro_CMAAdescripcion NEQ ''>
	<cfset params= params&'&filtro_CMAAdescripcion='&form.filtro_CMAAdescripcion>	
	<cfset params= params&'&hfiltro_CMAAdescripcion='&form.filtro_CMAAdescripcion>		
</cfif>
<cfif isdefined('form.filtro_SNnombre') and form.filtro_SNnombre NEQ ''>
	<cfset params= params&'&filtro_SNnombre='&form.filtro_SNnombre>	
	<cfset params= params&'&hfiltro_SNnombre='&form.filtro_SNnombre>		
</cfif>
<cflocation url="AgenciaAduanal.cfm?Pagina=#Form.Pagina##params#">

