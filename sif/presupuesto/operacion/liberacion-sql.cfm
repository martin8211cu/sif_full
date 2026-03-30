<cfset modo = "ALTA">

<cfif not isdefined("Form.btnNuevo")>
	<cfif isdefined("Form.btnAgregarE")>
		<cfquery name="rsNumeroDoc" datasource="#Session.DSN#">
			select rtrim(CPDEnumeroDocumento) as CPDEnumeroDocumento
			from CPDocumentoE
			where CPDEid = (
				select max(CPDEid)
				from CPDocumentoE
				where Ecodigo = #Session.Ecodigo#
				and CPDEtipoDocumento = 'L'
			)
		</cfquery>
		<cfif rsNumeroDoc.recordCount EQ 0>
			<cfset numero = 1>
		<cfelse>
			<cfset numero = rsNumeroDoc.CPDEnumeroDocumento + 1>
		</cfif>
        <cfinclude template="../../Utiles/sifConcat.cfm">
		<cftransaction>
			
			<cfquery name="selectABC_DocsLiberacion" datasource="#Session.DSN#">
				select a.CPPid, 
					   a.CPCano, 
					   a.CPCmes,
					   ('Liberación de Provisión #trim(Form.CPDEnumeroDocumento)#: ' #_Cat# a.CPDEdescripcion) as CPDEdescripcion, 
					   a.CFidOrigen,
					   a.CPDEid as CPDEidRef,
					   0 as CPDEaplicado,
						CPDEidRef
				from CPDocumentoE a
				where a.Ecodigo = #Session.Ecodigo#
				and a.CPDEnumeroDocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPDEnumeroDocumento#">
				and a.CPDEtipoDocumento = 'R'
				and a.NAP is not null
				and a.CPDEaplicado = 1
			</cfquery>
			<cfquery name="ABC_DocsLiberacion" datasource="#Session.DSN#">
				insert into CPDocumentoE (
				Ecodigo, CPPid, CPDEfechaDocumento, CPCano, 
				CPCmes, CPDEfecha, CPDEtipoDocumento, 
				CPDEnumeroDocumento, CPDEdescripcion, Usucodigo, 
				CFidOrigen, CPDEidRef, CPDEaplicado, CPDEsuficiencia
				)
				VALUES(
				   #session.Ecodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectABC_DocsLiberacion.CPPid#"               	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectABC_DocsLiberacion.CPCano#"              	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectABC_DocsLiberacion.CPCmes#"              	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="L">,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#numero#" 										voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#selectABC_DocsLiberacion.CPDEdescripcion#"     	voidNull>,
				   #session.Usucodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectABC_DocsLiberacion.CFidOrigen#"          	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectABC_DocsLiberacion.CPDEidRef#"           	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#selectABC_DocsLiberacion.CPDEaplicado#"        	voidNull>
				   ,0
			)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_DocsLiberacion">
		</cftransaction>
		<cfset Form.CPDEid = ABC_DocsLiberacion.identity>
		<cfset modo="CAMBIO">

	<cfelseif isdefined("Form.btnBajaE")>
	
		<cftransaction>
			<cfquery name="ABC_DocsLiberacion" datasource="#Session.DSN#">
				delete from CPDocumentoD 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>

			<cfquery name="ABC_DocsLiberacion" datasource="#Session.DSN#">
				delete from CPDocumentoE 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
				and CPDEtipoDocumento = 'L'
			</cfquery>
			<cfset modo="BAJA">
		</cftransaction>
		
	<cfelseif isdefined("Form.btnCambiarE")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CPDocumentoE" 
			redirect="liberacion.cfm"
			timestamp="#form.ts_rversion#"
			field1="CPDEid,numeric,#form.CPDEid#">		
	
		<cfquery name="ABC_DocsLiberacion" datasource="#Session.DSN#">
			update CPDocumentoE set 
				CPDEfechaDocumento = <cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(Form.CPDEfechaDocumento)#">,
				CPDEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDEdescripcion#">,
				CPDEfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				Usucodigo = #session.usucodigo# 
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
		</cfquery>		
		
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.btnGuardarD") or isdefined("Form.btnAplicar")>
		<cftransaction>
			<cfquery name="delDetalle" datasource="#Session.DSN#">
				delete from CPDocumentoD 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>
	
<!--- 			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="CPDocumentoE" 
				redirect="liberacion.cfm"
				timestamp="#form.ts_rversion#"
				field1="CPDEid,numeric,#form.CPDEid#">		 --->
	
			<cfquery name="updEncabezado" datasource="#Session.DSN#">
				update CPDocumentoE set 
					CPDEfechaDocumento = <cfqueryparam cfsqltype="cf_sql_date" value="#LsParseDateTime(Form.CPDEfechaDocumento)#">,
					CPDEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDEdescripcion#">,
					CPDEfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
					Usucodigo = #session.usucodigo# 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			</cfquery>
	
			<!--- Insertar primero los movimientos positivos --->
			<cfloop collection="#Form#" item="elem">
			
				<cfif FindNoCase('CPDDmonto_', elem) EQ 1 and Len(Trim(Form[elem])) and Form[elem] NEQ 0>
					<cfset CPDDid = Mid(elem, Len('CPDDmonto_')+1, Len(elem))>
					
					<cfquery name="rsNextDetail" datasource="#Session.DSN#">
						select coalesce(max(CPDDlinea), 0)+1 as linea
						from CPDocumentoD
						where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
					</cfquery>

					<cfquery name="ABC_DocsLiberacion" datasource="#Session.DSN#">
						insert INTO CPDocumentoD (Ecodigo, CPDEid, CPDDlinea, CPDDtipo, CPPid, CPCano, CPCmes, CPcuenta, CPDDmonto, CPDDsaldo, Ocodigo, CPDDidRef)
						select 
							a.Ecodigo, 
							a.CPDEid, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNextDetail.linea#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
							b.CPPid, 
							b.CPCano,
							b.CPCmes,
							b.CPcuenta,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Form[elem]#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Form[elem]#">,
							b.Ocodigo,
							b.CPDDid
						from CPDocumentoE a, CPDocumentoD b
						where a.Ecodigo = #Session.Ecodigo#
						and a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
						and a.Ecodigo = b.Ecodigo
						and a.CPDEidRef = b.CPDEid
						and b.CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDDid#">
					</cfquery>
				</cfif>
			</cfloop>

			<cfset CPDEid = Form.CPDEid>
			<cfset modo="CAMBIO">
		</cftransaction>

		<!--- -------------------------------------------------- SECCION DE APLICAR ------------------------------------------ --->
		<cfif isdefined("Form.btnAplicar")>
			<!--- Chequear que cada linea de la liberacion sea menor al saldo de la linea de Provisión Presupuestaria referenciada --->
			<cfquery name="checkSaldos" datasource="#Session.DSN#">
				select count(1) as cant
				from CPDocumentoD a, CPDocumentoD b
				where a.Ecodigo = #Session.Ecodigo#
				and a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
				and a.Ecodigo = b.Ecodigo
				and a.CPDDidRef = b.CPDDid
				and a.CPDDmonto > b.CPDDsaldo
			</cfquery>
			<cfif checkSaldos.cant GT 0>
				<cf_errorCode	code = "50494" msg = "Existen montos de liberación mayores al saldo de la linea de Provisión Presupuestaria">
			</cfif>
			
			<cfscript>
				LobjControl = CreateObject("component", "sif.Componentes.PRES_Presupuesto");
				LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true);
			</cfscript>

			<cftransaction>
            	<cfquery datasource="#Session.DSN#" name="rsPeriodoCont">
                	select Pvalor as Periodo from Parametros
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
                    and Pcodigo = 50   
                </cfquery>
                <cfset PeriodoCont = rsPeriodoCont.Periodo>
            
	           	<cfquery datasource="#Session.DSN#" name="rsMesCont">
                	select Pvalor as Mes from Parametros
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
                    and Pcodigo = 60 
                </cfquery>
                <cfset MesCont = rsMesCont.Mes>
                
                <cfquery name="rsInsertarTablaIntPresupuesto" datasource="#Session.DSN#">
					insert into #Request.intPresupuesto# (
						ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						
						NumeroLinea, 
						CPPid, 
						CPCano, 
						CPCmes,
						CPcuenta, 
						Ocodigo,
						TipoMovimiento,
						
						Mcodigo,
						MontoOrigen, 
						TipoCambio, 
						Monto,
						
						NAPreferencia,
						LINreferencia
					)
					
					select 'PRCO' as ModuloOrigen,
						   a.CPDEnumeroDocumento as NumeroDocumento,
						   case a.CPDEtipoDocumento when 'R' then 'Provisión' when 'L' then 'Liberación' when 'T' then 'Traslado' when 'TE' then 'Traslado Aut.Externa' else '' end as NumeroReferencia,
						   a.CPDEfechaDocumento as FechaDocumento,
                     
						   a.CPCano as AnoDocumento,
						   a.CPCmes as MesDocumento,						   
                           
						   b.CPDDlinea as NumeroLinea,
						   b.CPPid,
					       b.CPCano,
						   b.CPCmes,
						   b.CPcuenta,
						   b.Ocodigo,
						   case a.CPDEtipoDocumento when 'R' then 'RP' when 'L' then 'RP' when 'T' then 'T' when 'TE' then 'TE' else '' end as TipoMovimiento,
						   
						   c.Mcodigo,
						   (b.CPDDmonto * -1) as MontoOrigen,
						   1.00 as TipoCambio,
						   (b.CPDDmonto * -1) as Monto,
						   
						   e.NAP as NAPreferencia,
						   d.CPDDlinea as LINreferencia
					from CPDocumentoE a, CPDocumentoD b, CPresupuestoPeriodo c, CPDocumentoD d, CPDocumentoE e
					where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
					and a.Ecodigo = #Session.Ecodigo#
					and a.Ecodigo = b.Ecodigo
					and a.CPDEid = b.CPDEid
					and b.Ecodigo = c.Ecodigo
					and b.CPPid = c.CPPid
					and a.Ecodigo = d.Ecodigo
					and a.CPDEidRef = d.CPDEid
					and b.CPDDidRef = d.CPDDid
					and a.Ecodigo = e.Ecodigo
					and a.CPDEidRef = e.CPDEid
				</cfquery>
				
				<cfquery name="rsEncabezado" datasource="#Session.DSN#">
					select CPDEnumeroDocumento, 
						   CPDEfechaDocumento, 
						   case CPDEtipoDocumento when 'R' then 'Provisión' when 'L' then 'Liberación' when 'T' then 'Traslado' when 'TE' then 'Traslado Aut.Externa' else '' end as NumeroReferencia,
						   CPCano, 
						   CPCmes
					from CPDocumentoE
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
					and Ecodigo = #Session.Ecodigo#
				</cfquery>
				
				<cfscript>
					LvarNAP = LobjControl.ControlPresupuestario('PRCO', rsEncabezado.CPDEnumeroDocumento, rsEncabezado.NumeroReferencia, rsEncabezado.CPDEfechaDocumento, PeriodoCont, MesCont);
				</cfscript>
				
				<cfif LvarNAP LT 0>
					<cfquery name="updDoc" datasource="#Session.DSN#">
						update CPDocumentoE
						set NRP = #-LvarNAP#, 
							CPDEfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
							Usucodigo = #session.usucodigo# 
						where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
						and Ecodigo = #Session.Ecodigo#
					</cfquery>
				<cfelse>
					<!--- Actualizar los saldos de las lineas del Documento de Provisión Presupuestaria --->
					<cfquery name="rsLineasSaldos" datasource="#Session.DSN#">
						select 	d.CPDEid as R_CPDEid, d.CPDDid as R_CPDDid, 
								c.CPDEid as L_CPDEid, c.CPDDid as L_CPDDid, c.CPDDmonto as L_CPDDmonto
						from CPDocumentoE a, CPDocumentoE b, CPDocumentoD c, CPDocumentoD d
						where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
						and a.Ecodigo = #Session.Ecodigo#
						and a.Ecodigo = b.Ecodigo
						and a.CPDEidRef = b.CPDEid
						and a.Ecodigo = c.Ecodigo
						and a.CPDEid = c.CPDEid
						and a.Ecodigo = d.Ecodigo
						and a.CPDEidRef = d.CPDEid
						and c.CPDDidRef = d.CPDDid
					</cfquery>
					<cfloop query="rsLineasSaldos">
						<!--- Actualiza saldo de la Provisión Presupuestaria --->
						<cfquery name="updSaldo" datasource="#Session.DSN#">
							update CPDocumentoD
							   set CPDDsaldo = CPDDsaldo - <cfqueryparam cfsqltype="cf_sql_money" value="#rsLineasSaldos.L_CPDDmonto#">
							 where Ecodigo = #Session.Ecodigo#
							   and CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasSaldos.R_CPDEid#">
							   and CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasSaldos.R_CPDDid#">
						</cfquery>
						<!--- Actualiza saldo de la Liberacion --->
						<cfquery name="updSaldo" datasource="#Session.DSN#">
							update CPDocumentoD
							   set CPDDsaldo = 
							   		(
									select 	CPDDsaldo 
									  from CPDocumentoD
									 where Ecodigo = #Session.Ecodigo#
									   and CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasSaldos.R_CPDEid#">
									   and CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasSaldos.R_CPDDid#">
									)
							  where Ecodigo = #Session.Ecodigo#
							    and CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasSaldos.L_CPDEid#">
							    and CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasSaldos.L_CPDDid#">
						</cfquery>
					</cfloop>
				
					<cfquery name="updDoc" datasource="#Session.DSN#">
						update CPDocumentoE
							set NAP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNAP#"> , 
								CPDEaplicado = 1,
								CPDEfechaAprueba = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								UsucodigoAprueba = #session.usucodigo# 
						where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
						and Ecodigo = #Session.Ecodigo# 
					</cfquery>
				</cfif>
				<cfset modo="ALTA">
			</cftransaction>
			<cfif LvarNAP LT 0>
				<!---
				<cf_errorCode	code = "50495" msg = "RECHAZO DE LIBERACION DE PROVISIÓN PRESUPUESTARIA EN CONTROL DE PRESUPUESTO">
				--->
				<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
			</cfif>
		</cfif>

	</cfif>
</cfif>

<cfoutput>
<form action="liberacion.cfm" method="post" name="sql">
	<cfif modo EQ "CAMBIO">
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


