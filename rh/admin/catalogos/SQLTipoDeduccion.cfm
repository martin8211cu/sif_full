<cfinvoke key="LB_Antes_de_borrar_el_tipo_de_deduccion_debe_eliminar_los_permisos" default="Antes de borrar el tipo de deducci&oacute;n debe eliminar los permisos. " returnvariable="LB_ErrorTipoDed" component="sif.Componentes.Translate" method="Translate"/>	
<cfparam name="action" default="TipoDeduccion.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<!--- Agregar Tipo de Deducción --->
	<cfif isdefined("form.Alta") >
		
		<cftransaction>
		
		<cfif isdefined("Form.TDrenta")>
			<cfquery datasource="#session.DSN#">
				update TDeduccion set 
					TDrenta = 0
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		
		<cfquery datasource="#session.DSN#">
			insert into TDeduccion (Ecodigo, TDcodigo, TDdescripcion, Usucodigo, Ulocalizacion, 
									TDfecha, TDobligatoria, TDprioridad, TDparcial, TDordmonto, TDordfecha, 
									TDfinanciada, BMUsucodigo, Ccuenta, CFcuenta, cuentaint, CFcuentaint, TDrenta,
									TDclave, TDcodigoext,TDley,TDdrenta,TDfoa,SNcodigo,RHCSATid,TDespecie,TDFondoAhorro,TDFondoAhorroEmp)
			values ( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
					 <cfqueryparam value="#form.TDcodigo#" cfsqltype="cf_sql_varchar">, 
					 <cfqueryparam value="#form.TDdescripcion#" cfsqltype="cf_sql_varchar">, 
					 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">, 
					 '00', 
					 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					 <cfif isdefined("Form.TDobligatoria")>
						 <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
					 <cfelse>
						 <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
					 </cfif>
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TDprioridad#">,
					 <cfif isdefined("Form.TDparcial")>
						 <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
					 <cfelse>
						 <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
					 </cfif>
					 <cfif isdefined("Form.TDcriterio") and Form.TDcriterio EQ 1>
						 <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					 <cfelseif isdefined("Form.TDcriterio") and Form.TDcriterio EQ 2>
						 <cfqueryparam cfsqltype="cf_sql_integer" value="2">,
					 <cfelse>
						null,
					 </cfif>
					 <cfif isdefined("Form.TDcriterio") and Form.TDcriterio EQ 3>
						 <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					 <cfelseif isdefined("Form.TDcriterio") and Form.TDcriterio EQ 4>
						 <cfqueryparam cfsqltype="cf_sql_integer" value="2">
					 <cfelse>
						null
					 </cfif>,
					 <cfif isdefined("form.TDfinanciada")>1<cfelse>0</cfif>,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					 ,<cfif isdefined("form.Ccuenta") and len(trim(form.Ccuenta))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#"><cfelse>null</cfif>
					 ,<cfif isdefined("form.CFcuenta") and len(trim(form.CFcuenta))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#"><cfelse>null</cfif>
					 ,<cfif isdefined("form.cuentaint") and len(trim(form.cuentaint))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cuentaint#"><cfelse>null</cfif>
					 ,<cfif isdefined("form.CFcuenta_cuentaint") and len(trim(form.CFcuenta_cuentaint))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta_cuentaint#"><cfelse>null</cfif>							 
					 ,<cfif isdefined("Form.TDrenta")>
						 <cfqueryparam cfsqltype="cf_sql_bit" value="1">
					 <cfelse>
						 <cfqueryparam cfsqltype="cf_sql_bit" value="0">
					 </cfif>
					 ,<cfif isdefined('form.TDclave') and LEN(TRIM(form.TDclave))>
					 	<cfqueryparam cfsqltype="cf_sql_char" value="#form.TDclave#">
					  <cfelse>
					  	null
					  </cfif>
					  ,<cfif isdefined('form.TDcodigoext') and LEN(TRIM(form.TDcodigoext))>
					 	<cfqueryparam cfsqltype="cf_sql_char" value="#form.TDcodigoext#">
					  <cfelse>
					  	null
					  </cfif>,
					  <cfif isdefined("Form.TDley")>
						 <cfqueryparam cfsqltype="cf_sql_bit" value="1">
					 <cfelse>
						 <cfqueryparam cfsqltype="cf_sql_bit" value="0">
					 </cfif>,
					  <cfif isdefined("Form.TDdrenta")>
						 <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					 <cfelse>
						 <cfqueryparam cfsqltype="cf_sql_integer" value="0">
					 </cfif>,
                     <cfif isdefined("Form.TDfoa")>
						 <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					 <cfelse>
						 <cfqueryparam cfsqltype="cf_sql_integer" value="0">
					 </cfif>,
					 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.SNcodigo#" voidNull>
						,<cfif isdefined("form.ConceptoSAT")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ConceptoSAT#"><cfelse>0</cfif>
					,<cfif IsDefined('form.TDespecie')>
						1
					<cfelse>
						0
					</cfif>
					,<cfif IsDefined('form.TDFondoAhorro')>
						1
					<cfelse>
						0
					</cfif>
					,<cfif IsDefined('form.TDFondoAhorroEmp')>
						1
					<cfelse>
						0
					</cfif>
			)
		</cfquery>
		
		</cftransaction>
		
	<cfelseif isdefined("form.Cambio")>
		<!--- Actualizar un Tipo de Deducción --->
		
		<cftransaction>
		
		<cf_dbtimestamp datasource="#session.dsn#"
				table="TDeduccion"
				redirect="formTipodeduccion.cfm"
				timestamp="#form.ts_rversion#"
				field1="TDid" 
				type1="numeric" 
				value1="#form.TDid#">
		
		<cfif isdefined("Form.TDrenta")>
			<cfquery datasource="#session.DSN#">
				update TDeduccion set 
					TDrenta = 0
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and TDid <> <cfqueryparam value="#form.TDid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cfif>
		
		<cfquery datasource="#session.DSN#" name="a">
			select *
			from TDeduccion
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and TDid =  <cfqueryparam value="#form.TDid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	
		<cfquery datasource="#session.DSN#">
			update TDeduccion set 
				TDcodigo = <cfqueryparam value="#form.TDcodigo#" cfsqltype="cf_sql_varchar">,
				TDdescripcion = <cfqueryparam value="#Form.TDdescripcion#" cfsqltype="cf_sql_varchar">,
				<cfif isdefined("Form.TDobligatoria")>
					TDobligatoria = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
				<cfelse>
					TDobligatoria = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
				</cfif>
				TDprioridad = <cfqueryparam value="#form.TDprioridad#" cfsqltype="cf_sql_integer">,
				<cfif isdefined("Form.TDparcial")>
					TDparcial = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
				<cfelse>
					TDparcial = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
				</cfif>
				<cfif isdefined("Form.TDcriterio") and Form.TDcriterio EQ 1>
					TDordmonto = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
				<cfelseif isdefined("Form.TDcriterio") and Form.TDcriterio EQ 2>
					TDordmonto = <cfqueryparam cfsqltype="cf_sql_integer" value="2">,
				<cfelse>
					TDordmonto = null,
				</cfif>
				<cfif isdefined("Form.TDcriterio") and Form.TDcriterio EQ 3>
					TDordfecha = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				<cfelseif isdefined("Form.TDcriterio") and Form.TDcriterio EQ 4>
					TDordfecha = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
				<cfelse>
					TDordfecha = null
				</cfif>,
				TDfinanciada = <cfif isdefined("form.TDfinanciada")>1<cfelse>0</cfif>,
				Ccuenta =  <cfif isdefined("form.Ccuenta") and len(trim(form.Ccuenta))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#"><cfelse>null</cfif>,
				CFcuenta = <cfif isdefined("form.CFcuenta") and len(trim(form.CFcuenta))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#"><cfelse>null</cfif>,
				cuentaint = <cfif isdefined("form.Ccuenta_cuentaint") and len(trim(form.Ccuenta_cuentaint))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta_cuentaint#"><cfelse>null</cfif>,
				CFcuentaint = <cfif isdefined("form.CFcuenta_cuentaint") and len(trim(form.CFcuenta_cuentaint))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta_cuentaint#"><cfelse>null</cfif>,
				TDrenta = <cfif isdefined("Form.TDrenta")>
							 <cfqueryparam cfsqltype="cf_sql_bit" value="1">
						 <cfelse>
							 <cfqueryparam cfsqltype="cf_sql_bit" value="0">
						 </cfif>,
				TDclave = <cfif isdefined("form.TDclave") and len(trim(form.TDclave))><cfqueryparam cfsqltype="cf_sql_char" value="#form.TDclave#"><cfelse>null</cfif>,
				TDcodigoext = <cfif isdefined("form.TDcodigoext") and len(trim(form.TDcodigoext))><cfqueryparam cfsqltype="cf_sql_char" value="#form.TDcodigoext#"><cfelse>null</cfif>,
				TDley =	<cfif isdefined("Form.TDley")>
					 		<cfqueryparam cfsqltype="cf_sql_bit" value="1">
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_bit" value="0">
						</cfif>,
				 TDdrenta = <cfif isdefined("Form.TDdrenta")>
								<cfqueryparam cfsqltype="cf_sql_integer" value="1">
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_integer" value="0">
							</cfif>,
                 TDfoa =    <cfif isdefined("Form.TDfoa")>
								<cfqueryparam cfsqltype="cf_sql_integer" value="1">
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_integer" value="0">
							</cfif>,      
				SNcodigo=	<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.SNcodigo#" voidNull>
        ,RHCSATid  = <cfif isdefined("form.ConceptoSAT")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ConceptoSAT#">
				<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>	
				,TDespecie = <cfif IsDefined('form.TDespecie')>1<cfelse>0</cfif>
				,TDFondoAhorro = <cfif IsDefined('form.TDFondoAhorro')>1<cfelse>0</cfif>
				,TDFondoAhorroEmp = <cfif IsDefined('form.TDFondoAhorroEmp')>1<cfelse>0</cfif>
				,TDesajuste = <cfif isdefined("Form.TDesajuste")>
							 <cfqueryparam cfsqltype="cf_sql_bit" value="1">
						 <cfelse>
							 <cfqueryparam cfsqltype="cf_sql_bit" value="0">
						 </cfif>						
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and TDid =  <cfqueryparam value="#form.TDid#" cfsqltype="cf_sql_numeric">
		</cfquery> 
		
		
		</cftransaction>
		
		<cfset modo = 'CAMBIO'>
		  
	<!--- Borrar un Tipo de Deducción --->
	<cfelseif isdefined("form.Baja")>
		
		<cftry>
		
			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="TDeduccion">		
						<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo#  and TDid = #form.TDid#">
			</cfinvoke>
	
			<cfquery datasource="#session.DSN#">
				delete from TDeduccion
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and TDid =  <cfqueryparam value="#form.TDid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			
			<cfcatch type="any">
			 	<cf_throw message="#LB_ErrorTipoDed#" errorcode="187">
			</cfcatch>
		</cftry>	
	</cfif>
</cfif>	
<cfset args="">
<cfif isdefined('modo') and LEN(TRIM(modo))>
	<cfset args = args & "?modo=#modo#">
</cfif>
<cfif modo eq 'CAMBIO'>
	<cfset args = args & "&TDid=#TDid#">
</cfif>
<cfif isdefined('form.PageNum') and LEN(TRIM(form.PageNum))>
	<cfset args = args & "&PageNum=#form.PageNum#">	
</cfif>

<cflocation url="#action##args#">
