<cfif form.TESTILestado EQ "0">
	<cfset LvarAction = "Transferencias.cfm">
<cfelse>
	<cfset LvarAction = "Pagos.cfm">
</cfif>
<cfparam name="modo" default="ALTA">
<cfparam name="dmodo" default="ALTA">
<cfif isdefined("form.btnGenerarOP") >
	<cftransaction>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
					method="sbGeneraOP_TransferenciasCB"
					returnVariable = "LvarOP"
		>
			<cfinvokeargument name="TESTILid" value="#form.TESTILid#"/>
		</cfinvoke>
	</cftransaction>
	<cflocation addtoken="no" url="#LvarAction#?OPnum=#LvarOP#">
<cfelseif isdefined("form.btnAplicar") >
	<cftransaction>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
					method="sbAplicarLote_TransferenciasCB">
			<cfinvokeargument name="TESTILid" value="#form.TESTILid#"/>
		</cfinvoke>
	</cftransaction>
	<cflocation addtoken="no" url="#LvarAction#">
<cfelseif not isdefined("form.btnNuevoD")>
	<cftry>
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("Form.btnAgregarE")>
			<cftransaction>
				<cfquery name="insert" datasource="#Session.DSN#">
					insert into TEStransfIntercomL 
						(TESid, TESTILtipo, TESTILestado, TESTILfecha, TESTILdescripcion, UsucodigoGenera, TESTILfechaGenera, BMUsucodigo)
					values 
						(
							 #session.Tesoreria.TESid#
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESTILtipo#">
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESTILestado#">
							,<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESTILfecha)#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTILdescripcion#">
							,#session.Usucodigo#
							,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							,#session.Usucodigo#
						)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="insert">
			</cftransaction>

			<cfset modo="CAMBIO">
				
		<!--- Caso 2: Borrar un Lote de Transferencias --->
		<cfelseif isdefined("Form.btnBorrarE")>
			<cfquery datasource="#Session.DSN#">
				delete from TEStransfIntercomD
				 where TESid 	= #session.Tesoreria.TESid#
				   and TESTILid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTILid#">
			</cfquery>				
			<cfquery  datasource="#Session.DSN#">
				delete from TEStransfIntercomL
				 where TESid 	= #session.Tesoreria.TESid#
				   and TESTILid = <cfqueryparam value="#form.TESTILid#" cfsqltype="cf_sql_numeric">
			</cfquery>

			<cfset Form.TESTILid="">
				  
		<!--- Caso 3: Agregar Detalle de Requisicion y opcionalmente modificar el encabezado --->
		<cfelseif isdefined("Form.btnAgregarD")>			
			<cfset LvarOri = listToArray(form.CBidOri)>
			<cfset LvarDst = listToArray(form.CBidDst)>
			<cfquery  datasource="#Session.DSN#">			  
				insert into TEStransfIntercomD 
					(TESid, TESTILid, TESTIDdocumento, TESTIDreferencia,TESTIDdescripcion, 
					 CBidOri, EcodigoOri, Miso4217Ori, 
					 TESTIDmontoOri, TESTIDcomisionOri, TESTIDtipoCambioOri, 
					 CBidDst, EcodigoDst, Miso4217Dst, 
					 TESTIDmontoDst, TESTIDtipoCambioDst, 
					 BMUsucodigo,
                     TESTIDdocumentoDst,TESTIDdescripcionDst,TESTIDreferenciaDst
					)
				values (
					 #session.Tesoreria.TESid#
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  scale="0" value="#form.TESTILid#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_char"     len="20"  value="#form.TESTIDdocumento#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  len="25"  value="#form.TESTIDreferencia#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  len="50"  value="#form.TESTIDdescripcion#" null="#trim(form.TESTIDdescripcion) EQ ''#">
					
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  scale="0" value="#LvarOri[1]#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#LvarOri[2]#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_char" 	 len="3" value="#LvarOri[3]#">
					
					,<cf_jdbcquery_param cfsqltype="cf_sql_money"   value="#Replace(form.TESTIDmontoOri,',','','all')#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_money"  value="#Replace(form.TESTIDcomisionOri,',','','all')#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_float"   value="#Replace(form.TESTIDtipoCambioOri,',','','all')#">

					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarDst[1]#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarDst[2]#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#LvarDst[3]#">
					
					,<cf_jdbcquery_param cfsqltype="cf_sql_money"   value="#Replace(form.TESTIDmontoDst,',','','all')#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_float"   value="#Replace(form.TESTIDtipoCambioDst,',','','all')#">
					
					,#session.Usucodigo#
                    
					,<cf_jdbcquery_param cfsqltype="cf_sql_char"    len="20"  value="#form.TESTIDdocumentoDst#">
					,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="50"  value="#form.TESTIDdescripcionDst#">
                    ,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="25"  value="#form.TESTIDreferenciaDst#" null="#trim(form.TESTIDdescripcion) EQ ''#">
					)
			</cfquery>
			
			<!--- Modificar Encabezado, unicamente si se modifico alguno de los campos --->			
			<cfset form.modo = "CAMBIO">
			<cf_dbtimestamp datasource="#session.dsn#"
					table="TEStransfIntercomL"
					redirect="#LvarAction#"
					timestamp="#form.ts_rversion#"
					field1="TESid" 
					type1="numeric" 
					value1="#session.Tesoreria.TESid#"
					field2="TESTILid" 
					type2="numeric" 
					value2="#form.TESTILid#"
					>
			
			<cfquery  datasource="#Session.DSN#">
				update TEStransfIntercomL
				set TESTILfecha   	  = <cfqueryparam cfsqltype="cf_sql_date"		value="#LSParseDateTime(form.TESTILfecha)#">,
					TESTILdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.TESTILdescripcion#">
				 where TESid 	= #session.Tesoreria.TESid#
				   and TESTILid = <cfqueryparam value="#form.TESTILid#" cfsqltype="cf_sql_numeric">
			  </cfquery>

			<cfset modo="CAMBIO">
			<cfset dmodo="ALTA">

		<!--- Caso 4: Modificar Detalle de Requisicion y opcionalmente modificar el encabezado --->			
		<cfelseif isdefined("Form.btnCambiarD")>				
			<!--- Modificar Encabezado, unicamente si se modifico alguno de los campos --->
			<cfset form.modo = "CAMBIO">
			<cf_dbtimestamp datasource="#session.dsn#"
					table="TEStransfIntercomL"
					redirect="#LvarAction#"
					timestamp="#form.ts_rversion#"
					field1="TESid" 
					type1="numeric" 
					value1="#session.Tesoreria.TESid#"
					field2="TESTILid" 
					type2="numeric" 
					value2="#form.TESTILid#"
					>
				
			<cfquery  datasource="#Session.DSN#">
				update TEStransfIntercomL
				set TESTILfecha   	  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.TESTILfecha)#">,
					TESTILdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTILdescripcion#">
				 where TESid 	= #session.Tesoreria.TESid#
				   and TESTILid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTILid#">
			 </cfquery> 

			 
			 <cf_dbtimestamp datasource="#session.dsn#"
					table="TEStransfIntercomD"
					redirect="#LvarAction#"
					timestamp="#form.dtimestamp#"
					field1="TESid" 
					type1="numeric" 
					value1="#session.Tesoreria.TESid#"
					field2="TESTILid" 
					type2="numeric" 
					value2="#form.TESTILid#"
					field3="TESTIDid" 
					type3="numeric" 
					value3="#form.TESTIDid#"
					>
			
			<cfset LvarOri = listToArray(form.CBidOri)>
			<cfset LvarDst = listToArray(form.CBidDst)>
			<cfquery  datasource="#Session.DSN#">
				update TEStransfIntercomD
				   set	 TESTIDdocumento 	= <cf_jdbcquery_param cfsqltype="cf_sql_char"    len="20" 	value="#trim(form.TESTIDdocumento)#">
						,TESTIDreferencia 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="25" 	value="#form.TESTIDreferencia#">
						,TESTIDdescripcion 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="50"	value="#form.TESTIDdescripcion#" null="#trim(form.TESTIDdescripcion) EQ ''#">

						,CBidOri			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" scale="0"  value="#LvarOri[1]#">
						,EcodigoOri			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 			value="#LvarOri[2]#">
						,Miso4217Ori		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	 len="3" 	value="#LvarOri[3]#">
						
						,TESTIDmontoOri		= <cf_jdbcquery_param cfsqltype="cf_sql_money"   			value="#Replace(form.TESTIDmontoOri,',','','all')#">
						,TESTIDcomisionOri	= <cf_jdbcquery_param cfsqltype="cf_sql_money"  			value="#Replace(form.TESTIDcomisionOri,',','','all')#">
						,TESTIDtipoCambioOri= <cf_jdbcquery_param cfsqltype="cf_sql_float"   			value="#Replace(form.TESTIDtipoCambioOri,',','','all')#">
	
						,CBidDst			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" scale="0"	value="#LvarDst[1]#">
						,EcodigoDst			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 			value="#LvarDst[2]#">
						,Miso4217Dst		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	 len="3" 	value="#LvarDst[3]#">
						
						,TESTIDmontoDst		= <cf_jdbcquery_param cfsqltype="cf_sql_money"   value="#Replace(form.TESTIDmontoDst,',','','all')#">
						,TESTIDtipoCambioDst= <cf_jdbcquery_param cfsqltype="cf_sql_float"   value="#Replace(form.TESTIDtipoCambioDst,',','','all')#">

					<cfif isdefined("form.TESMPcodigo")>
						,TESMPcodigo		= (
												select TESMPcodigo 
												  from TESmedioPago 
												 where TESid		= #session.Tesoreria.TESid#
												   and CBid 		= #LvarOri[1]#
												   and TESMPcodigo	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
											  )
					</cfif>
						,BMUsucodigo		= #session.Usucodigo# 
                        ,TESTIDdocumentoDst   = <cf_jdbcquery_param cfsqltype="cf_sql_char"    len="20"  value="#trim(form.TESTIDdocumentoDst)#">
                        ,TESTIDdescripcionDst = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="50"  value="#form.TESTIDdescripcionDst#">
                        ,TESTIDreferenciaDst  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="25"	 value="#form.TESTIDreferenciaDst#" null="#trim(form.TESTIDreferenciaDst) EQ ''#">
				where TESid		= #session.Tesoreria.TESid#
				  and TESTILid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.TESTILid#">
				  and TESTIDid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.TESTIDid#">
			</cfquery>

			<cfset modo="CAMBIO">
			<cfset dmodo="CAMBIO">

		<!--- Caso 5: Borrar detalle de Requisicion --->
		<cfelseif isdefined("Form.btnBorrarD")>
			<cfquery datasource="#Session.DSN#">
				delete from TEStransfIntercomD
				 where TESTILid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTILid#">
				   and TESTIDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTIDid#">
			</cfquery>

			<cfset modo="CAMBIO">
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset modo   = "CAMBIO" >
</cfif>
	
<cfif isdefined("Form.btnAgregarE")>
	<cfset form.TESTILid = insert.identity >
</cfif>

<cfoutput>
<form action="#LvarAction#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="TESTILid"   type="hidden" value="<cfif isdefined("Form.TESTILid")>#Form.TESTILid#</cfif>">
	<cfif dmodo neq 'ALTA'>
		<input name="dmodo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="TESTIDid"  type="hidden" value="<cfif isdefined("Form.TESTIDid")>#Form.TESTIDid#</cfif>">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<!--- Begin UDF's Definition --->
<!---  Recupera el tipo de transaccion --->
<cffunction name="transaccion" access="public" returntype="query">
	<cfargument name="Pcodigo" type="numeric" required="true" default="0">
	<cfset movimiento = transaccion(160)>
	<input type="hidden" name="BTidori" value="<cfoutput>#movimiento.Pvalor#</cfoutput>" >		
	<cfset movimiento = transaccion(170)>
	<input type="hidden" name="BTiddest" value="<cfoutput>#movimiento.Pvalor#</cfoutput>" >		
	<cfquery name="rsTransaccion" datasource="#session.DSN#" >
		select a.Pvalor, b.BTdescripcion		
		from Parametros a, BTransacciones b 		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#">
		  and a.Mcodigo	= 'MB'
		  and a.Ecodigo	= b.Ecodigo
		  and b.BTid 	= <cf_dbfunction name="to_number" args="a.Pvalor">
	</cfquery>
	<cfreturn #rsTransaccion#>
</cffunction>
