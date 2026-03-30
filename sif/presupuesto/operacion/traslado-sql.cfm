<cfset modo = "ALTA">

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfset LvarTab = 0>
<cfparam name="form.CPDEtipoDocumento" default="">
<cfif form.CPDEtipoDocumento EQ "E" or isdefined("url.TE")>
	<cfset LvarCPDEtipoDocumento = "E">
	<cfset LvarTrasladoForm = "E">
<cfelse>
	<cfset LvarCPDEtipoDocumento = "T">
	<cfset LvarTrasladoForm = "">
</cfif>

<cfif session.CPformTipo EQ "aprobacion">
	<cfset LvarForm = "traslado-aprobacion-lista.cfm">
<cfelseif isdefined("Form.btnAAprobar")>
	<cfset LvarForm = "traslado#LvarTrasladoForm#-registro-lista.cfm">
<cfelse>
	<cfset LvarForm = "traslado#LvarTrasladoForm#-registro-form.cfm">
</cfif>

<cfif not isdefined("Form.btnNuevo")>
	<cfif isdefined("Form.btnAgregarE")>
		<cfquery name="rsNumeroDoc" datasource="#Session.DSN#">
			select rtrim(CPDEnumeroDocumento) as CPDEnumeroDocumento
			  from CPDocumentoE
			 where CPDEid = (
				select max(CPDEid)
				  from CPDocumentoE
				 where Ecodigo 				= #Session.Ecodigo#
				   and CPDEtipoDocumento 	= '#LvarCPDEtipoDocumento#'
			)
		</cfquery>
		<cfif rsNumeroDoc.recordCount EQ 0>
			<cfset numero = 1>
		<cfelse>
			<cfset numero = rsNumeroDoc.CPDEnumeroDocumento + 1>
		</cfif>
		<cftransaction>
			<cfparam name="form.CPTTid"		default="">
			<cfparam name="form.CPDAEid"	default="">
			<cfquery name="ABC_DocsTraslado" datasource="#Session.DSN#">
				insert into CPDocumentoE (	Ecodigo, CPPid, CPDEfechaDocumento, CPCano, CPCmes, CPDEfecha, 
											CPDEtipoDocumento, CPDEnumeroDocumento, CPDEdescripcion, Usucodigo, CFidOrigen, CFidDestino, CPDEtipoAsignacion, CPDEaplicado,
											CPTTid, CPDAEid
										 )
				values (
					#Session.Ecodigo#, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(Form.CPDEfechaDocumento)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('yyyy', LsParseDateTime(Form.CPDEfechaDocumento))#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', LsParseDateTime(Form.CPDEfechaDocumento))#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
					'#LvarCPDEtipoDocumento#',
					<cfqueryparam cfsqltype="cf_sql_char" value="#numero#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDEdescripcion#">,
					#session.usucodigo#, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFidOrigen#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFidDestino#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPDEtipoAsignacion#">,
					0
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPTTid#" 	null="#Form.CPTTid EQ ''#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDAEid#" 	null="#LvarCPDEtipoDocumento NEQ 'E'#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_DocsTraslado">

			<cfset Form.CPDEid = ABC_DocsTraslado.identity>
			<cfinvoke	component= "sif.presupuesto.Componentes.PRES_Traslados"
						method = "VerificarVerificaciones"
						CPDEid = "#Form.CPDEid#"
						soloCFs = "true"
			/>
		</cftransaction>
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.btnBajaE")>
		<cftransaction>
			<cfquery name="ABC_DocsTraslado" datasource="#Session.DSN#">
				delete from CPDocumentoD 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>
	
			<cfquery name="ABC_DocsTraslado" datasource="#Session.DSN#">
				delete from CPDocumentoE 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
				and CPDEtipoDocumento = '#LvarCPDEtipoDocumento#'
			</cfquery>
			<cfset modo="BAJA">
		</cftransaction>
	<cfelseif isdefined("Form.btnJustificacion")>
		<cfset LvarTab = 1>
		<cfquery datasource="#Session.DSN#">
			update CPDocumentoE 
			   set CPDEjustificacion = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" value="#Form.CPDEjustificacion#" len="1000" null="#trim(Form.CPDEjustificacion) EQ ""#">
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
		</cfquery>
	<cfelseif isdefined("Form.btnDocAdd")>
		<cfset LvarTab = 2>
		<!--- Agregar archivo --->
		<cfquery datasource="#Session.DSN#">
			insert into CPDocumentoEDocs (CPDEid, CPDDdescripcion, CPDDarchivo, CPDDdoc, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDDdescripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDDarchivo1##Form.CPDDarchivo2#">, 
				<cf_dbupload filefield="CPDDdoc" accept="*/*" datasource="#Session.DSN#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
		</cfquery>
	<cfelseif isdefined("url.DocOP")>
		<cfset LvarTab = 2>
		<cfif url.DocOP EQ 1>
			<!--- Eliminar archivo --->
			<cfquery datasource="#Session.DSN#">
				delete from CPDocumentoEDocs
				 where CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">
			</cfquery>
		<cfelseif url.DocOP EQ 2>
			<!--- Download archivo --->
			<cfquery name="rsSQL"datasource="#Session.DSN#">
				select CPDDarchivo, CPDDdoc
				  from CPDocumentoEDocs
				 where CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">
			</cfquery>
			<cfheader name="Content-Disposition"	value="attachment;filename=#rsSQL.CPDDarchivo#">
			<cfcontent type="*" reset="yes" variable="#rsSQL.CPDDdoc#">
		</cfif>
	<cfelseif isdefined("Form.btnModificarT") or isdefined("Form.btnAAprobar")>
		<cftransaction>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="CPDocumentoE" 
				redirect="#LvarForm#"
				timestamp="#form.ts_rversion#"
				field1="CPDEid,numeric,#form.CPDEid#">	
					
			<cfparam name="form.CPTTid"		default="">
			<cfparam name="form.CPDAEid"	default="">
			<cfquery name="ABC_DocsTraslado" datasource="#Session.DSN#">
				update CPDocumentoE set 
					CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">, 
					CPDEfechaDocumento = <cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(Form.CPDEfechaDocumento)#">,
				 	CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('yyyy', LsParseDateTime(Form.CPDEfechaDocumento))#">,
					CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', LsParseDateTime(Form.CPDEfechaDocumento))#">,
					CPDEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDEdescripcion#">,
					CFidOrigen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFidOrigen#">,
					CFidDestino = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFidDestino#">,
					CPDEfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
					Usucodigo = #session.usucodigo#, 
					CPDEtipoAsignacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPDEtipoAsignacion#">
					,CPTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPTTid#" null="#Form.CPTTid EQ ''#">
					,CPDAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDAEid#" null="#Form.CPDAEid EQ ''#">
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>
			<cfset modo="CAMBIO">

			<cfinvoke	component= "sif.presupuesto.Componentes.PRES_Traslados"
						method = "VerificarVerificaciones"
						CPDEid = "#Form.CPDEid#"
						soloCFs = "true"
			/>

			<cfquery name="delDetalle" datasource="#Session.DSN#">
				delete from CPDocumentoD 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>
	
			<!--- Insertar primero los movimientos positivos --->
			<cfloop collection="#Form#" item="elem">
				<cfif FindNoCase('D_CPcuenta', elem) EQ 1 and Len(Trim(Form[elem]))>
					<cfset indexElem = Mid(elem, Len('D_CPcuenta')+1, Len(elem))>
	
					<cfquery name="rsNextDetail" datasource="#Session.DSN#">
						select coalesce(max(CPDDlinea), 0)+1 as linea
						from CPDocumentoD
						where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
					</cfquery>
					<cfset tipoMov = 1>
					<cfset pref = "D_">
					
					<cfquery name="ABC_DocsTraslado" datasource="#Session.DSN#">
						insert INTO CPDocumentoD (Ecodigo, CPDEid, CPDDlinea, CPDDtipo, CPPid, CPCano, CPCmes, CPcuenta, CPDDmonto, CPDDsaldo, CPDDpeso, Ocodigo)
						select 
							a.Ecodigo, 
							a.CPDEid, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#indexElem#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#tipoMov#">,
							a.CPPid, 
							a.CPCano,
							a.CPCmes,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form[elem]#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.'&pref&'CPDDmonto'&indexElem)#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.'&pref&'CPDDmonto'&indexElem)#">,
							<cfif isdefined("Form.CPDEtipoAsignacion") and Len(Trim(Form.CPDEtipoAsignacion)) and Form.CPDEtipoAsignacion EQ 3 and tipoMov EQ 1>
								<cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.'&pref&'CPDDpeso'&indexElem)#">,
							<cfelse>
								null,
							</cfif>
							b.Ocodigo
						from CPDocumentoE a, CFuncional b
						where a.Ecodigo = #Session.Ecodigo#
						and a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
						and a.Ecodigo = b.Ecodigo
						and a.CFidDestino = b.CFid
						and exists(
							select 1
							from CPresupuestoControl x
							where x.Ecodigo = a.Ecodigo
							and x.CPPid = a.CPPid
							and x.CPCano = a.CPCano
							and x.CPCmes = a.CPCmes
							and x.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form[elem]#">
							and x.Ocodigo = b.Ocodigo
						)
					</cfquery>
				</cfif>
			</cfloop>

			<!--- Insertar los movimientos negativos --->
			<cfloop collection="#Form#" item="elem">
				<cfif FindNoCase('O_CPcuenta', elem) EQ 1 and Len(Trim(Form[elem]))>
					<cfset indexElem = Mid(elem, Len('O_CPcuenta')+1, Len(elem))>
	
					<cfquery name="rsNextDetail" datasource="#Session.DSN#">
						select coalesce(max(CPDDlinea), 0)+1 as linea
						from CPDocumentoD
						where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
					</cfquery>
					<cfset tipoMov = -1>
					<cfset pref = "O_">
				
					<cfquery name="ABC_DocsTraslado" datasource="#Session.DSN#">
						insert INTO CPDocumentoD (Ecodigo, CPDEid, CPDDlinea, CPDDtipo, CPPid, CPCano, CPCmes, CPcuenta, CPDDmonto, CPDDsaldo, CPDDpeso, Ocodigo)
						select 
							a.Ecodigo, 
							a.CPDEid, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#-indexElem#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#tipoMov#">,
							a.CPPid, 
							a.CPCano,
							a.CPCmes,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form[elem]#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.'&pref&'CPDDmonto'&indexElem)#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.'&pref&'CPDDmonto'&indexElem)#">,
							<cfif isdefined("Form.CPDEtipoAsignacion") and Len(Trim(Form.CPDEtipoAsignacion)) and Form.CPDEtipoAsignacion EQ 3 and tipoMov EQ 1>
								<cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.'&pref&'CPDDpeso'&indexElem)#">,
							<cfelse>
								null,
							</cfif>
							b.Ocodigo
						from CPDocumentoE a, CFuncional b
						where a.Ecodigo = #Session.Ecodigo#
						and a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
						and a.Ecodigo = b.Ecodigo
						and a.CFidOrigen = b.CFid
						and exists(
							select 1
							from CPresupuestoControl x
							where x.Ecodigo = a.Ecodigo
							and x.CPPid = a.CPPid
							and x.CPCano = a.CPCano
							and x.CPCmes = a.CPCmes
							and x.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form[elem]#">
							and x.Ocodigo = b.Ocodigo
						)
					</cfquery>
				</cfif>
			</cfloop>
			
			<!--- Distribución Equitativa --->
			<cfif isdefined("Form.CPDEtipoAsignacion") and Len(Trim(Form.CPDEtipoAsignacion)) and Form.CPDEtipoAsignacion EQ 1>
				<cfquery name="updMontos" datasource="#Session.DSN#">
					update CPDocumentoD 
							set CPDDmonto = 
								round(
									(
										select coalesce(sum(CPDDmonto), 0.00) 
										from CPDocumentoD 
										where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#"> 
											and CPDDtipo = -1
									)
									/
									(
										select coalesce(count(1), 0.00) 
										from CPDocumentoD 
										where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#"> 
											and CPDDtipo = 1
									)
								,2)
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#"> 
					and CPDDtipo = 1 
				</cfquery>
				<!--- Actualizacion de Decimales por si acaso --->
				<cfquery name="updMontos" datasource="#Session.DSN#">
					update CPDocumentoD
					set CPDDmonto = CPDDmonto +
						(
							(select sum(CPDDmonto) from CPDocumentoD where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#"> and CPDDtipo = -1)
							 -
							(select sum(CPDDmonto) from CPDocumentoD where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#"> and CPDDtipo = 1)
						)
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
					and CPDDtipo = 1
					and CPDDlinea = (select max(CPDDlinea) from CPDocumentoD where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#"> and CPDDtipo = 1)
				</cfquery>
				
	
			<!--- Distribución de Cuenta en Cuenta --->
			<cfelseif isdefined("Form.CPDEtipoAsignacion") and Len(Trim(Form.CPDEtipoAsignacion)) and Form.CPDEtipoAsignacion EQ 0>
				<cfquery name="updMontos" datasource="#Session.DSN#">
					update CPDocumentoD
					set CPDDmonto = coalesce(
									(
										select CPDDmonto 
										  from CPDocumentoD d
										 where d.CPDEid 	= CPDocumentoD.CPDEid
										   and d.CPDDlinea 	= -CPDocumentoD.CPDDlinea
										   and d.CPDDtipo 	= -1
									)
									,0)
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
					and CPDDtipo = 1
				</cfquery>

			<!--- Distribución según Porcentaje --->
			<cfelseif isdefined("Form.CPDEtipoAsignacion") and Len(Trim(Form.CPDEtipoAsignacion)) and Form.CPDEtipoAsignacion EQ 3>
				<cfquery name="updMontos" datasource="#Session.DSN#">
					update CPDocumentoD
					set CPDDmonto = (CPDDpeso * (select coalesce(sum(CPDDmonto), 0.00) from CPDocumentoD where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#"> and CPDDtipo = -1)) / 
									(case when (select coalesce(sum(CPDDpeso), 1.00) from CPDocumentoD where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#"> and CPDDtipo = 1) = 0 then 1.0
									else (select coalesce(sum(CPDDpeso), 1.00) from CPDocumentoD where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#"> and CPDDtipo = 1) end)
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
					and CPDDtipo = 1
				</cfquery>
			</cfif>
			
			<cfset CPDEid = Form.CPDEid>
			<cfset modo="CAMBIO">
		</cftransaction>
		<cftransaction>
			<!--- -------------------------------------------------- ENVIAR A APLICAR ------------------------------------------ --->
			<cfif isdefined("Form.btnAAprobar")>
				<cfinvoke	component= "sif.presupuesto.Componentes.PRES_Traslados"
							method = "EnviarAAprobarTraslado"
							CPDEid = "#Form.CPDEid#"
				/>
				<cfset modo="ALTA">
			</cfif>
		</cftransaction>

	<cfelseif isdefined("Form.btnVerificar")>
		<cfinvoke	component= "sif.presupuesto.Componentes.PRES_Traslados"
					method = "VerificarVerificaciones"
					CPDEid = "#Form.CPDEid#"
		/>
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.btnDuplicar")>
		<cftransaction>
			<cfquery name="rsNumeroDoc" datasource="#Session.DSN#">
				select rtrim(CPDEnumeroDocumento) as CPDEnumeroDocumento
				from CPDocumentoE
				where CPDEid = (
					select max(CPDEid)
					from CPDocumentoE
					where Ecodigo = #Session.Ecodigo#
					and CPDEtipoDocumento = '#LvarCPDEtipoDocumento#'
				)
			</cfquery>
			<cfif rsNumeroDoc.recordCount EQ 0>
				<cfset numero = 1>
			<cfelse>
				<cfset numero = rsNumeroDoc.CPDEnumeroDocumento + 1>
			</cfif>
			<cfquery name="selectABC_DocsTraslado" datasource="#Session.DSN#">
				select CPPid, CPDEfechaDocumento, CPCano, CPCmes, CPDEfecha, CPDEtipoDocumento, '#numero#' as CPDEnumeroDocumento, CPDEdescripcion, Usucodigo, CFidOrigen, CFidDestino, CPDEtipoAsignacion, 0 as CPDEaplicado,0 as CPDErechazado, CPDEmsgRechazo
				  from CPDocumentoE 
				 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>
			<cfquery name="ABC_DocsTraslado" datasource="#Session.DSN#">
				insert into CPDocumentoE 
					  (Ecodigo, CPPid, CPDEfechaDocumento, CPCano, CPCmes, CPDEfecha, CPDEtipoDocumento, CPDEnumeroDocumento, CPDEdescripcion, Usucodigo, CFidOrigen, CFidDestino, CPDEtipoAsignacion, CPDEaplicado, CPDEmsgRechazo)
						VALUES(
					   #session.Ecodigo#,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectABC_DocsTraslado.CPPid#"               voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectABC_DocsTraslado.CPDEfechaDocumento#"  voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectABC_DocsTraslado.CPCano#"              voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectABC_DocsTraslado.CPCmes#"              voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectABC_DocsTraslado.CPDEfecha#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selectABC_DocsTraslado.CPDEtipoDocumento#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectABC_DocsTraslado.CPDEnumeroDocumento#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#selectABC_DocsTraslado.CPDEdescripcion#"     voidNull>,
					   #session.Usucodigo#,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectABC_DocsTraslado.CFidOrigen#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectABC_DocsTraslado.CFidDestino#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selectABC_DocsTraslado.CPDEtipoAsignacion#"  voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#selectABC_DocsTraslado.CPDEaplicado#"        voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#selectABC_DocsTraslado.CPDErechazado#"       voidNull>
					)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_DocsTraslado">
			<cfset CPDEid = ABC_DocsTraslado.identity>
			<cfquery name="ABC_DocsTraslado" datasource="#Session.DSN#">
				update CPDocumentoE 
				   set CPDEidRef = #CPDEid#
				 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>
			<cfquery name="ABC_DocsTraslado" datasource="#Session.DSN#">
				insert INTO CPDocumentoD 
					  (Ecodigo, CPDEid, CPDDlinea, CPDDtipo, CPPid, CPCano, CPCmes, CPcuenta, CPDDmonto, CPDDsaldo, CPDDpeso, Ocodigo)
				select Ecodigo, #CPDEid#, CPDDlinea, CPDDtipo, CPPid, CPCano, CPCmes, CPcuenta, CPDDmonto, CPDDsaldo, CPDDpeso, Ocodigo
				  from CPDocumentoD
				 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>
			<cfset modo="ALTA">
		</cftransaction>
	<!--- -------------------------------------------------- SECCION DE APLICAR ------------------------------------------ --->
	<cfelseif isdefined("Form.btnRechazar")>
		<cftransaction>
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				select CFid, CPDAaplicado, CPDArechazado
				  from CPDocumentoA
				 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>
			<cfif rsSQL.CFid EQ "">
				<cfthrow message="El traslado no está definido en la estructura de aprobación por Centros Funcionales">
			<cfelseif rsSQL.CPDAaplicado EQ "1">
				<cfthrow message="El traslado ya fue aprobado">
			<cfelseif rsSQL.CPDArechazado EQ "1">
				<cfthrow message="El traslado ya fue rechazado">
			</cfif>

			<cfinvoke	component= "sif.presupuesto.Componentes.PRES_Traslados"
						method = "RechazarTraslado"
						CPDEid = "#Form.CPDEid#"
						CPDEmsgRechazo = "#form.CPDEmsgRechazo#"
			/>
		</cftransaction>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.btnAplicar")>
		<cftransaction>
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				select CFid, CPDAaplicado, CPDArechazado
				  from CPDocumentoA
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>
			<cfif rsSQL.CFid EQ "">
				<cfthrow message="El traslado no está definido en la estructura de aprobación por Centros Funcionales">
			<cfelseif rsSQL.CPDAaplicado EQ "1">
				<cfthrow message="El traslado ya fue aprobado">
			<cfelseif rsSQL.CPDArechazado EQ "1">
				<cfthrow message="El traslado ya fue rechazado">
			</cfif>

			<cfinvoke	component	= "sif.presupuesto.Componentes.PRES_Traslados"
						method 		= "AprobarTraslado"
						CPDEid 		= "#Form.CPDEid#"
			/>
		</cftransaction>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.btnNuevoD")>
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
	<form action="#LvarForm#" method="post" name="sql">
	<cfif LvarTab NEQ 0>
	   	<input name="tab" type="hidden" value="#LvarTab#">
	   	<input name="CPDEid" type="hidden" value="#CPDEid#">
	<cfelseif modo EQ "CAMBIO">
	   	<input name="CPDEid" type="hidden" value="#CPDEid#">
	</cfif>
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


