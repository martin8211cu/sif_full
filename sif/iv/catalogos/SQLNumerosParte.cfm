
<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<!---- Verificar que no exista un numero de parte con la misma marca ----->	
		<cfquery name="rsExiste" datasource="#Session.DSN#">
			select 1 
			from NumParteProveedor
			where  Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				<cfif isdefined ("form.AFMid") and len(trim(form.AFMid))>
					and AFMid = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Form.AFMid#">
				</cfif>
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		</cfquery>
							
		<cfif rsExiste.RecordCount  GTE 1>				
			<cfset Request.Error.Backs = 1>
			<cf_errorCode	code = "50264" msg = "El registro que desea insertar ya existe">
		</cfif>
		
		<!--- Verificar que el nuevo rango de fechas no esta ya contemplado en otro registro ---->
		<cfquery name="rsExisteRango" datasource="#Session.DSN#">
			select NumeroParte
			from NumParteProveedor
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">	
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				<cfif isdefined ("form.AFMid") and len(trim(form.AFMid))>
					and AFMid = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Form.AFMid#">
				</cfif>				
				and ( 
					(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vdesde#"> between Vdesde  and Vhasta or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vhasta#"> between Vdesde  and Vhasta)
					or (Vdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vdesde#">  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vhasta#"> or Vhasta between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vdesde#">  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vhasta#">)
					)								
		</cfquery>				
		<cfif rsExisteRango.NumeroParte EQ form.NumeroParte>
			<cfset Request.Error.Backs = 1>
			<cf_errorCode	code = "50399" msg = "Las fechas de valides del parte ya se encuentran contempladas en otro registro">
		</cfif>
		<cftransaction>		
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into NumParteProveedor (Aid, AFMid,  Ecodigo, SNcodigo, NumeroParte, Vdesde, Vhasta, BMUsucodigo, fechaalta)
					values(	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.Aid#" >,
							<cfif isdefined("form.AFMid") and len(trim(form.AFMid))>
								<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.AFMid#" >,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#" >,
							<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.SNcodigo#" >,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.NumeroParte#" >,						
							<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(Form.Vdesde)#" >,
							<cfqueryparam cfsqltype="cf_sql_timestamp"  value="#LSParseDateTime(Form.Vhasta)#" >,	
							<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Session.Usucodigo#">,	
							<cfqueryparam cfsqltype="cf_sql_timestamp"	value="#Now()#">																
					)	
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		</cftransaction>	
			
		<cfif isdefined('insert')>
			<cfset form.NPPid=insert.identity>
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from NumParteProveedor
			where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				and NPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.NPPid#">
		</cfquery>						
	<cfelseif isdefined("Form.Cambio")>	
		<!---- Verificar que no exista un numero de parte con la misma marca ----->
		<cfquery name="rsExiste" datasource="#Session.DSN#">
			select 1 
			from NumParteProveedor
			where  Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				and NPPid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.NPPid#">
				<cfif isdefined ("form.AFMid") and len(trim(form.AFMid))>
					and AFMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AFMid#">
				<cfelse>
					and AFMid is null
				</cfif>	
		</cfquery>

		<cfif rsExiste.RecordCount  GTE 1>			
			<cfset Request.Error.Backs = 1>
			<cf_errorCode	code = "50400" msg = "El registro ya existe">
		</cfif>		

		<!--- Verificar que el nuevo rango de fechas no esta ya contemplado en otro registro and NPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.NPPid#">				 --and NumeroParte = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.NumeroParte#">---->
		
		<cfquery name="rsExisteRango" datasource="#Session.DSN#">
			select NumeroParte
			from NumParteProveedor
			where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
				and NPPid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.NPPid#">
				<cfif isdefined ("form.AFMid") and len(trim(form.AFMid))>
					and AFMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AFMid#">
				<cfelse>
					and AFMid is null
				</cfif>				
				and ( 
					(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vdesde#"> between Vdesde  and Vhasta or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vhasta#"> between Vdesde  and Vhasta)
					or (Vdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vdesde#">  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vhasta#"> or Vhasta between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vdesde#">  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Vhasta#">)
					)			
		</cfquery>

		<cfif rsExisteRango.RecordCount GT 0><!----<cfif rsExisteRango.NumeroParte EQ form.NumeroParte>---->
			<cfset Request.Error.Backs = 1>
			<cf_errorCode	code = "50399" msg = "Las fechas de valides del parte ya se encuentran contempladas en otro registro">
		</cfif>
		
		<cf_dbtimestamp datasource="#session.dsn#"
						table="NumParteProveedor"
						redirect="NumerosParte.cfm"
						timestamp="#form.ts_rversion#"				
						field1="Aid" 
						type1="numeric" 
						value1="#form.Aid#"
						field2="Ecodigo" 
						type2="integer" 
						value2="#session.Ecodigo#"
						field3="NPPid" 
						type3="numeric" 
						value3="#form.NPPid#"
					>

		<cfquery name="update" datasource="#Session.DSN#">
			update NumParteProveedor 
			set	AFMid = <cfif isdefined ("form.AFMid") and len(trim(form.AFMid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AFMid#" >,
						<cfelse>
							null,
						</cfif>					
				SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#" >,
				NumeroParte = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Form.NumeroParte#">,
				Vdesde = <cfqueryparam cfsqltype="cf_sql_timestamp"   value="#LSParseDateTime(Form.Vdesde)#">,
				Vhasta = <cfqueryparam cfsqltype="cf_sql_timestamp"   value="#LSParseDateTime(Form.Vhasta)#">
			where NPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.NPPid#" >
			<!---
				Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				and NPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.NPPid#" >
			----->	
				
		</cfquery>		
	</cfif>
</cfif>

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.NPPid') and form.NPPid NEQ ''>
		<cfset params= params&'&NPPid='&form.NPPid>	
	</cfif>
</cfif>
<cfif isdefined("form.Pagina3") and len(trim(form.Pagina3))>
	<cfset params= params&'&Pagina3='&form.Pagina3>		
</cfif>
<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>
	<cfset params= params&'&filtro_Acodigo='&form.filtro_Acodigo>	
	<cfset params= params&'&hfiltro_Acodigo='&form.filtro_Acodigo>		
</cfif>
<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>
	<cfset params= params&'&filtro_Acodalterno='&form.filtro_Acodalterno>	
	<cfset params= params&'&hfiltro_Acodalterno='&form.filtro_Acodalterno>	
</cfif>
<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>
	<cfset params= params&'&filtro_Adescripcion='&form.filtro_Adescripcion>	
	<cfset params= params&'&hfiltro_Adescripcion='&form.filtro_Adescripcion>	
</cfif>

<cfif isdefined('form.Regresar')>
	<cflocation url="articulos-lista.cfm?Pagina=#Form.Pagina##params#">
<cfelse>
	<cflocation url="NumerosParte.cfm?Aid=#form.Aid#&Pagina=#Form.Pagina##params#">
</cfif>

