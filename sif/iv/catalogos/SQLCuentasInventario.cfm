<cfif not isdefined("Form.Nuevo") >
	<cfif isdefined("Form.Alta")>
		<cftransaction>		
			<cfquery name="insert" datasource="#session.DSN#">
				insert into IAContables ( Ecodigo, IACcodigogrupo, IACdescripcion, IACinventario, IACingajuste, IACgastoajuste, IACcompra, IACingventa, IACcostoventa, IACdescventa, IACtransito, CformatoCompras, CformatoIngresos )
							values( #session.Ecodigo#, 
									<cfqueryparam value="#Form.IACcodigogrupo#"   cfsqltype="cf_sql_char">, 
									<cfqueryparam value="#Form.IACdescripcion#"   cfsqltype="cf_sql_varchar">, 
									<cfqueryparam value="#Form.IACinventario#"    cfsqltype="cf_sql_numeric">, 
									<cfqueryparam value="#Form.IACingajuste#"     cfsqltype="cf_sql_numeric">, 
									<cfqueryparam value="#Form.IACgastoajuste#"   cfsqltype="cf_sql_numeric">, 
									<cfqueryparam value="#Form.IACcompra#"        cfsqltype="cf_sql_numeric">, 
									<cfqueryparam value="#Form.IACingventa#"      cfsqltype="cf_sql_numeric">, 
									<cfqueryparam value="#Form.IACcostoventa#"    cfsqltype="cf_sql_numeric">,
									<cfqueryparam value="#Form.IACdescventa#"     cfsqltype="cf_sql_numeric">,
									<cfqueryparam value="#Form.IACtransito#"     cfsqltype="cf_sql_numeric">,
									<cfif isdefined("form.Cmayor8_Cformato8") and len(trim(form.Cmayor8_Cformato8)) gt 0 and isdefined("form.Cmayor8_Cformato8") and len(trim(form.Cmayor8_Cformato8)) gt 0>
										<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Cmayor8_Cformato8) & "-" & trim(form.Cformato8)#">
									 <cfelse>
										null
									 </cfif>,
									 <cfif isdefined("form.Cmayor9_Cformato9") and len(trim(form.Cmayor9_Cformato9)) gt 0 and isdefined("form.Cmayor9_Cformato9") and len(trim(form.Cmayor9_Cformato9)) gt 0>
										<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Cmayor9_Cformato9) & "-" & trim(form.Cformato9)#">
									 <cfelse>
										null
									 </cfif>
									 )
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		</cftransaction>	
			
		<cfif isdefined('insert')>
			<cfset form.IACcodigo=insert.identity>
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from IAContables
			where IACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IACcodigo#" >
			  and Ecodigo   = #Session.Ecodigo#
		</cfquery>					  
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="IAContables" 
			redirect="CuentasInventario.cfm"
			timestamp="#form.ts_rversion#"
			field1="IACcodigo"
			type1="numeric"
			value1="#form.IACcodigo#"
			field2="Ecodigo"
			type2="integer"
			value2="#session.Ecodigo#" >

		<cfquery name="update" datasource="#session.DSN#">
			update IAContables
			set IACcodigogrupo = <cfqueryparam value="#Form.IACcodigogrupo#"   cfsqltype="cf_sql_char">, 
				IACdescripcion = <cfqueryparam value="#Form.IACdescripcion#"   cfsqltype="cf_sql_varchar">, 
				IACinventario  = <cfqueryparam value="#Form.IACinventario#"    cfsqltype="cf_sql_numeric">, 
				IACingajuste   = <cfqueryparam value="#Form.IACingajuste#"     cfsqltype="cf_sql_numeric">, 
				IACgastoajuste = <cfqueryparam value="#Form.IACgastoajuste#"   cfsqltype="cf_sql_numeric">, 
				IACcompra	   = <cfqueryparam value="#Form.IACcompra#"        cfsqltype="cf_sql_numeric">, 
				IACingventa    = <cfqueryparam value="#Form.IACingventa#"      cfsqltype="cf_sql_numeric">, 
				IACcostoventa  = <cfqueryparam value="#Form.IACcostoventa#"    cfsqltype="cf_sql_numeric">,
				IACdescventa   = <cfqueryparam value="#Form.IACdescventa#"     cfsqltype="cf_sql_numeric">,
				IACtransito	   = <cfqueryparam value="#Form.IACtransito#"     cfsqltype="cf_sql_numeric">,
				CformatoCompras = <cfif isdefined("form.Cmayor8_Cformato8") and len(trim(form.Cmayor8_Cformato8)) gt 0 and isdefined("form.Cmayor8_Cformato8") and len(trim(form.Cmayor8_Cformato8)) gt 0>
						<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Cmayor8_Cformato8) & "-" & trim(form.Cformato8)#">
					 <cfelse>
						null
					 </cfif>,
				CformatoIngresos = <cfif isdefined("form.Cmayor9_Cformato9") and len(trim(form.Cmayor9_Cformato9)) gt 0 and isdefined("form.Cmayor9_Cformato9") and len(trim(form.Cmayor9_Cformato9)) gt 0>
						<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Cmayor9_Cformato9) & "-" & trim(form.Cformato9)#">
					 <cfelse>
						null
					 </cfif>

			where IACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IACcodigo#" >
			  and Ecodigo   = #Session.Ecodigo#
		</cfquery>
	</cfif>
</cfif>

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.IACcodigo') and form.IACcodigo NEQ ''>
		<cfset params= params&'&IACcodigo='&form.IACcodigo>	
	</cfif>
</cfif>
<cfif isdefined('form.filtro_IACcodigogrupo') and form.filtro_IACcodigogrupo NEQ ''>
	<cfset params= params&'&filtro_IACcodigogrupo='&form.filtro_IACcodigogrupo>	
	<cfset params= params&'&hfiltro_IACcodigogrupo='&form.filtro_IACcodigogrupo>		
</cfif>
<cfif isdefined('form.filtro_IACdescripcion') and form.filtro_IACdescripcion NEQ ''>
	<cfset params= params&'&filtro_IACdescripcion='&form.filtro_IACdescripcion>	
	<cfset params= params&'&hfiltro_IACdescripcion='&form.filtro_IACdescripcion>		
</cfif>

<cflocation url="CuentasInventario.cfm?Pagina=#Form.Pagina#&Empresa=#session.Ecodigo##params#">