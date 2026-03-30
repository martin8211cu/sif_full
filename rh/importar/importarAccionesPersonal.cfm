<!---
	Importador Acciones Personales
	Este archivo asume la existencia de la tabla temporal #table_name# "Datos de Entrada"
 --->
 
<!--- Tabla temporal para almacenar los errorwes --->
<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="text" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>
<cf_dbfunction name="OP_concat"	returnvariable="_CAT" >

<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>

<!--- Valida el código de acción --->
<cfswitch expression="#form.comportamiento#">
	<cfcase value="1">
		<cfset lvarComportamiento = "">
	</cfcase>
	<cfcase value="2">
		<cfset lvarComportamiento = "">
	</cfcase>
	<cfcase value="3">
		<cfset lvarComportamiento = "Vacaciones">
		<cfinclude template="importarVacaciones.cfm">
	</cfcase>
	<cfcase value="4">
		<cfset lvarComportamiento = "">
	</cfcase>
	<cfcase value="5">
		<cfset lvarComportamiento = "Incapacidades">
		<cfinclude template="importarIncapacidades.cfm">
	</cfcase>
	<cfcase value="6">
		<cfset lvarComportamiento = "">
	</cfcase>
	<cfcase value="7">
		<cfset lvarComportamiento = "">
	</cfcase>
	<cfcase value="8">
		<cfset lvarComportamiento = "">
	</cfcase>
	<cfcase value="9">
		<cfset lvarComportamiento = "">
	</cfcase>
	<cfcase value="10">
		<cfset lvarComportamiento = "">
	</cfcase>
	<cfcase value="11">
		<cfset lvarComportamiento = "">
	</cfcase>
	<cfcase value="12">
		<cfset lvarComportamiento = "">
	</cfcase>
	<cfcase value="13">
		<cfset lvarComportamiento = "Ausencias/Faltas">
		<cfinclude template="importarFaltas.cfm">
	</cfcase>
</cfswitch>

<cffunction name="fnInsertarError" access="private">
	<cfargument name="ErrorNum" 		type="numeric" 	required="true">
	<cfargument name="Mensaje" 			type="string" 	required="true">
	
	<cfquery datasource="#session.dsn#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Mensaje#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ErrorNum#">
		)
	</cfquery>
</cffunction>

<cffunction name="fnProcesoGuardar" access="private">
	<cfargument name="DEid" 					type="numeric" 	required="true">
	<cfargument name="RHTid" 					type="numeric" 	required="true">
	<cfargument name="FechaDesde" 				type="date" 	required="true">
	<cfargument name="FechaHasta" 				type="date" 	required="true">
	<cfargument name="DiasVacaciones" 			type="numeric" 	required="true">
	<cfargument name="Observaciones" 			type="string" 	required="true">
	<cfargument name="RHTespecial" 				type="numeric" 	required="true">
	<cfargument name="RHTporcPlazaCHK" 			type="numeric" 	required="true">
	<cfargument name="RHTcsalariofijo" 			type="numeric" 	required="true">
	<cfargument name="RHTporcsal" 				type="numeric" 	required="true">
	<cfargument name="RHTporc" 					type="numeric" 	required="true">
	<cfargument name="usaEstructuraSalarial"	type="numeric" 	required="true">
	<cfargument name="Conexion" 				type="string"	required="false" default="#session.dsn#">	
	<cfargument name="RHItiporiesgo"			type="numeric"	required="false" default="-1">	
	<cfargument name="RHIconsecuencia"			type="numeric"	required="false" default="-1">	
	<cfargument name="RHIcontrolincapacidad"	type="numeric"	required="false" default="-1">	
	<cfargument name="RHfolio" 					type="string"	required="false" default="">	
	
	
	
	<cfset rsSituacionActual = fnSituacionActual(Arguments.DEid, Arguments.FechaDesde)>
	<cfquery name="rsNegociado" datasource="#session.dsn#">
		select a.RHMPnegociado
		from RHLineaTiempoPlaza a
		where a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSituacionActual.RHPid#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaDesde#"> between a.RHLTPfdesde and a.RHLTPfhasta
	</cfquery>
	<cfset LvarNegociado = (rsNegociado.RHMPnegociado EQ 'N')>	
	<cfquery name="rsInsertAV" datasource="#session.DSN#">
		insert into RHAcciones (
			Ecodigo, DEid, RHTid, DLfvigencia, DLffin, RHAvdisf, DLobs, Usucodigo, Ulocalizacion, RHAporcsal, BMUsucodigo, BMfecha,
			Tcodigo, RVid, Dcodigo, Ocodigo, RHPid, RHPcodigo, RHAporc, RHJid, RHAvcomp, RHCPlinea, RHCPlineaP, TcodigoRef,
			Indicador_de_Negociado, RHAdiasenfermedad, BMfechamodif
			<cfif arguments.RHItiporiesgo gte 0 >, RHItiporiesgo</cfif>
			<cfif arguments.RHIconsecuencia gte 0 >, RHIconsecuencia</cfif>
			<cfif arguments.RHIcontrolincapacidad gte 0 >, RHIcontrolincapacidad</cfif>
			<cfif arguments.RHfolio neq "" >, RHfolio</cfif>
		)
		values( 
			<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DEid#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RHTid#">, 
			<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Arguments.FechaDesde#">, 
			<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Arguments.FechaHasta#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DiasVacaciones#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.Observaciones#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#session.Ulocalizacion#">, 
			<cfqueryparam cfsqltype="cf_sql_float" 		value="#iif(Arguments.RHTporcPlazaCHK eq 1, Arguments.RHTporc, rsSituacionActual.LTporcplaza)#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_char" 		value="#rsSituacionActual.Tcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsSituacionActual.RVid#">,
			<cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsSituacionActual.Dcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" 	value="#rsSituacionActual.Ocodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsSituacionActual.RHPid#">,
			<cfqueryparam cfsqltype="cf_sql_char" 		value="#rsSituacionActual.RHPcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_float" 		value="#Arguments.RHTporcsal#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsSituacionActual.RHJid#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="" voidnull>,
		<cfif Arguments.usaEstructuraSalarial EQ 1 and isdefined('Form.RHCPlinea') and Len(Trim(Form.RHCPlinea)) NEQ 0>
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.RHCPlinea#">,
		<cfelse>
			null,
		</cfif>
		<cfif isdefined('Form.RHCPlineaP') and Len(Trim(Form.RHCPlineaP)) NEQ 0>
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.RHCPlineaP#">,
		<cfelse>
			null,
		</cfif>
			null,
		<cfif LvarNegociado>
			1,
		<cfelse>
		 	0,
		</cfif>
			null,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		<cfif arguments.RHItiporiesgo gte 0 >, #arguments.RHItiporiesgo#</cfif>
		<cfif arguments.RHIconsecuencia gte 0 >, #arguments.RHIconsecuencia#</cfif>
		<cfif arguments.RHIcontrolincapacidad gte 0 >, #arguments.RHIcontrolincapacidad#</cfif>
		<cfif arguments.RHfolio neq "" >, '#arguments.RHfolio#'</cfif>
		)
	<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertAV">
	
	<cfset lvarRHAlinea = rsInsertAV.identity>
	<cfset rsAccion = fnAccion(lvarRHAlinea)>
	<!--- ********************************************************************************** --->
	<!--- Aqui se incluye el proceso que se debe realizar para acciones de personal NORMALES --->
	<!--- ********************************************************************************** --->
	<cfif Arguments.RHTespecial eq 0 >
		<cfquery name="rsComponentesAccion" datasource="#Session.DSN#">
			select a.RHDAlinea, a.CSid, b.CSdescripcion, b.CSusatabla, b.CSsalariobase, a.RHDAtabla,  a.RHDAunidad, a.RHDAmontobase, 
				   a.RHDAmontores, a.ts_rversion, coalesce(b.CIid, -1) as CIid,
				   coalesce(c.RHMCcomportamiento, 1) as RHMCcomportamiento, coalesce(c.RHMCvalor, 1.00) as valor
			from RHDAcciones a
				 inner join ComponentesSalariales b 
					on b.CSid = a.CSid
				 left outer join RHMetodosCalculo c
					on c.Ecodigo = b.Ecodigo
					and c.CSid = b.CSid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.rige#"> between c.RHMCfecharige and c.RHMCfechahasta
					and c.RHMCestadometodo = 1
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#" null="#Len(lvarRHAlinea) is 0#">
			order by b.CSorden, b.CScodigo, b.CSdescripcion
		</cfquery>	
		<cfloop query="rsComponentesAccion">
			<cfset unidades = rsComponentesAccion.RHDAunidad>
			<cfset montobase = rsComponentesAccion.RHDAmontobase>
			<cfset monto = rsComponentesAccion.RHDAmontores>
			<cfset metodo = 'M'>
			<cfif Arguments.usaEstructuraSalarial EQ 1 >
				<cfquery name="rsAccionES" datasource="#Session.DSN#">
					select b.DEid,b.DLfvigencia, b.DLffin, coalesce(b.RHCPlinea, 0) as RHCPlinea, a.CSid,a.RHDAmetodoC
					from RHDAcciones a, RHAcciones b
					where a.RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentesAccion.RHDAlinea#">
					and a.RHAlinea = b.RHAlinea
				</cfquery>
				<cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
					<cfinvokeargument name="CSid" value="#rsAccionES.CSid#"/>
					<cfinvokeargument name="fecha" value="#Arguments.FechaDesde#"/>
					<cfinvokeargument name="fechah" value="#Arguments.FechaHasta#"/>
					<cfinvokeargument name="DEid" value="#Arguments.DEid#"/>
					<cfif Len(Trim(rsAccionES.RHCPlinea))>
						<cfinvokeargument name="RHCPlinea" value="#rsAccionES.RHCPlinea#"/>
					</cfif>
					<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
					<cfinvokeargument name="negociado" value="#LvarNegociado#"/>
					<cfinvokeargument name="Unidades" value="#rsComponentesAccion.RHDAunidad#"/>
					<cfinvokeargument name="MontoBase" value="#rsComponentesAccion.RHDAmontobase#"/>
					<cfinvokeargument name="Monto" value="#rsComponentesAccion.RHDAmontores#"/>
					<cfinvokeargument name="Metodo" value="#rsAccionES.RHDAmetodoC#"/>
					<cfinvokeargument name="TablaComponentes" value="RHDAcciones"/>
					<cfinvokeargument name="CampoLlaveTC" value="RHAlinea"/>
					<cfinvokeargument name="ValorLlaveTC" value="#lvarRHAlinea#"/>
					<cfinvokeargument name="CampoMontoTC" value="RHDAmontores"/>
					<cfif isdefined('form.RHTTid') and Len(Trim(form.RHTTid)) and form.RHTTid GT 0>
						<cfinvokeargument name="RHTTid" value="#form.RHTTid#">
					</cfif>
					<cfif isdefined('form.RHCid') and Len(Trim(form.RHCid)) and form.RHCid GT 0>
						<cfinvokeargument name="RHCid" value="#form.RHCid#">
					</cfif>
					<cfif isdefined('form.RHMPPid') and Len(Trim(form.RHMPPid)) and form.RHMPPid GT 0>
						<cfinvokeargument name="RHMPPid" value="#form.RHMPPid#">
					</cfif>
				</cfinvoke>
				<cfset unidades = calculaComponenteRet.Unidades>
				<cfset montobase = calculaComponenteRet.MontoBase>
				<cfset monto = calculaComponenteRet.Monto>
				<cfset metodo = calculaComponenteRet.Metodo>
			</cfif>
			<cfif Len(Trim(unidades)) EQ 0 or Len(Trim(montobase)) EQ 0 or Len(Trim(monto)) EQ 0>
				<cf_throw message="#MSG_NoPuedeAplicarAccion#">
			</cfif>
			<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
				update RHDAcciones
					set RHDAunidad = <cfqueryparam cfsqltype="cf_sql_float" value="#unidades#">,
					RHDAmontobase= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(montobase, ',','','all')#">,
					RHDAmontores = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(monto, ',','','all')#">,
					RHDAmetodoC = <cfqueryparam cfsqltype="cf_sql_char" value="#metodo#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentesAccion.RHDAlinea#">
			</cfquery>
		</cfloop>

		<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
			delete RHConceptosAccion 
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
		</cfquery>

		<cfquery name="checkMaxLTid" datasource="#session.DSN#">
			select max (LThasta) as Fhasta
			from LineaTiempo 
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">						
		</cfquery>
		
		<cfif isdefined("checkMaxLTid") or (checkMaxLTid.recordcount GT 0) >
			<cfset Fhasta= "#checkMaxLTid.Fhasta#">	
		<cfelse>
			<cfset Fhasta = '01/01/6100'>
		</cfif>
		<cfquery datasource="#session.DSN#">
			update RHAcciones
			set DLffin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
			Where RHAlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
			and DLffin is null 
		</cfquery>								
		
		<!--- Procesamiento de los Conceptos de Pago --->
		<cfquery name="rsConceptos" datasource="#Session.DSN#">
			select a.DLfvigencia, 
				   a.DLffin, 
				   a.DEid, 
				   a.Ecodigo,
				   a.RHTid, 
				   a.RHAlinea, 
				   coalesce(a.RHJid, 0) as RHJid, 
				   c.CIid, 
				   c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo, c.CIdia, c.CImes
				   ,CIsprango, coalesce(CIspcantidad,0) as CIspcantidad, coalesce(CImescompleto,0) as CImescompleto
			from RHAcciones a, ConceptosTipoAccion b, CIncidentesD c
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
			and a.RHTid = b.RHTid
			and b.CIid = c.CIid
		</cfquery>
		<cfloop query="rsConceptos">					
			<cfset FVigencia = LSDateFormat(rsConceptos.DLfvigencia, 'DD/MM/YYYY')>
			<cfset FFin = LSDateFormat(rsConceptos.DLffin, 'DD/MM/YYYY')>
			<cfset current_formulas = rsConceptos.CIcalculo>
			<cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
										   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
										   rsConceptos.CIcantidad,
										   rsConceptos.CIrango,
										   rsConceptos.CItipo,
										   rsConceptos.DEid,
										   rsConceptos.RHJid,
										   rsConceptos.Ecodigo,
										   rsConceptos.RHTid,
										   rsConceptos.RHAlinea,
										   rsConceptos.CIdia,
										   rsConceptos.CImes,
										   "", <!--- Tcodigo solo se requiere si no va RHAlinea--->
										   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
										   'false',
										   '',
										   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
										   , 0
										   , '' 
										   ,rsConceptos.CIsprango
										   ,rsConceptos.CIspcantidad
										   ,rsConceptos.CImescompleto)>
			<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
			<cfset calc_error = RH_Calculadora.getCalc_error()>
			<cfif Not IsDefined("values")>
				<cfif isdefined("presets_text")>
					<cf_throw message="#presets_text# & '----' & #current_formulas# & '-----' & #calc_error#">
				<cfelse>
					<cf_throw message="#calc_error#" >
				</cfif>
			</cfif>
			<cfquery name="updConceptos" datasource="#Session.DSN#">
				insert into RHConceptosAccion(RHAlinea, CIid, RHCAimporte, RHCAres, RHCAcant, CIcalculo,BMUsucodigo,BMfecha)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.CIid#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('importe').toString()#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#values.get('cantidad').toString()#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#presets_text & ';' & current_formulas#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
			</cfquery> 
		</cfloop>
	<cfelseif Arguments.RHTespecial eq 1>
		<!--- ************************************************************************************ --->
		<!--- aqui se incluye el proceso que se debe realizar para acciones de personal ESPECIALES --->
		<!--- ************************************************************************************ --->
		<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
			update RHAcciones set
				BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				 BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
		</cfquery>	
	</cfif>
</cffunction>

<cffunction name="fnAccion" access="private" returntype="query">
	<cfargument name="RHAlinea" 		type="numeric" 	required="true">

	<cfquery name="rsAccion" datasource="#session.dsn#">
		select a.RHAlinea, 
			   a.RHCPlineaP,
			   a.DEid, 
			   a.RHTid, 
			   a.Ecodigo, 
			   coalesce(a.EcodigoRef,a.Ecodigo) as EcodigoRef, 
			   rtrim(a.Tcodigo) as Tcodigo, 
			   a.RVid, 
			   a.Dcodigo,
			   a.Ocodigo,				    
			   a.RHPid, 
			   rtrim(a.RHPcodigo) as RHPcodigo, 
			   (select min(coalesce(ltrim(rtrim(r.RHPcodigoext)),rtrim(ltrim(r.RHPcodigo))))
					from RHPuestos r
					where r.Ecodigo = a.Ecodigo
					   and r.RHPcodigo = a.RHPcodigo
					) as RHPcodigoext,
			   a.RHJid,
			   a.DLfvigencia, 
			   a.DLfvigencia as rige,
			   a.DLffin,
			   a.DLffin as vence,
			   a.DLsalario, a.DLobs, a.Usucodigo, a.Ulocalizacion, a.RHAporc, a.RHAporcsal,
			   coalesce(c.RHTporc, 100) as RHTporc,
			   a.RHAvdisf, a.RHAvcomp, 
			   a.Indicador_de_Negociado as negociado,
			   a.RHCPlinea,
			   a.ts_rversion,				   
			   b.NTIcodigo, b.DEidentificacion,
			   a.RHAtipo,
			   a.RHAdescripcion,
			   a.EVfantig,
			   {fn concat({fn concat({fn concat({ fn concat(b.DEnombre, ' ') },b.DEapellido1)}, ' ')},b.DEapellido2) } as NombreEmp,
			   rtrim(c.RHTcodigo) as RHTcodigo, c.RHTdesc, c.RHTpfijo, 
			<cfif isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1>
			   0 as RHTctiponomina, 0 as RHTcregimenv, 0 as RHTcoficina, 0 as RHTcdepto, 0 as RHTcplaza, 0 as RHTcpuesto, 0 as RHTccomp, 
			   0 as RHTcsalariofijo, 0 as RHTcjornada, 0 as RHTcvacaciones, 0 as RHTccatpaso, 0 as RHTcempresa, 0 as RHTnoveriplaza,
			<cfelse>
			   c.RHTctiponomina, c.RHTcregimenv, c.RHTcoficina, c.RHTcdepto, c.RHTcplaza, c.RHTcpuesto, c.RHTccomp, 
			   c.RHTcsalariofijo, c.RHTcjornada, 1 as RHTcvacaciones, c.RHTccatpaso, c.RHTcempresa, c.RHTnoveriplaza,
			 </cfif>
			   c.RHTcomportam, c.RHTpmax, 
				(select min(d.NTIdescripcion)
					from NTipoIdentificacion d
					where d.NTIcodigo = b.NTIcodigo
				) as NTIdescripcion, 
			   e.RHPdescripcion, rtrim(e.RHPcodigo) as CodPlaza, 
			   (select min(coalesce(ltrim(rtrim(r.RHPcodigoext)),rtrim(ltrim(r.RHPcodigo))))
					from RHPuestos r
					where r.Ecodigo = a.Ecodigo
					   and r.RHPcodigo = a.RHPcodigo
					) as CodPuesto, 
			   e.Dcodigo as CodDepto, e.Ocodigo as CodOfic,
				(select min(f.RHPdescpuesto)
					from RHPuestos f
					where f.Ecodigo = a.Ecodigo
					   and f.RHPcodigo = a.RHPcodigo
				) as RHPdescpuesto,					
				(select min( {fn concat(coalesce(ltrim(rtrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo))),{fn concat(' - ',f.RHPdescpuesto)} )} )
					from RHPuestos f
					where f.Ecodigo = a.Ecodigo
					   and f.RHPcodigo = a.RHPcodigo
				) as Puesto,					
				(select min(g.Tdescripcion)
					from TiposNomina g
					where g.Ecodigo = a.Ecodigo
					   and g.Tcodigo = a.Tcodigo
				) as Tdescripcion,
				(select min(h.Descripcion)
					from RegimenVacaciones h
					where h.RVid = a.RVid
				) as RegVacaciones, 				   
				(select min(Odescripcion)
					from Oficinas i
					where i.Ecodigo = a.Ecodigo
					   and i.Ocodigo = a.Ocodigo
				) as Odescripcion,	 
			   (select min(j.Ddescripcion) 
					from Departamentos j 
					where j.Ecodigo = a.Ecodigo
					   and j.Dcodigo = a.Dcodigo
				) as Ddescripcion,				 
			   {fn concat(rtrim(e.RHPcodigo),{fn concat(' - ',e.RHPdescripcion)})} as Plaza,
			   (select {fn concat(rtrim(k.RHJcodigo),{fn concat(' - ',k.RHJdescripcion)})}
					from RHJornadas k
					where a.Ecodigo = k.Ecodigo
						and a.RHJid = k.RHJid
			   ) as Jornada,				   
			   s.RHTTid,s2.RHTTid as RHTTid2, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
			   t.RHCid,t2.RHCid as RHCid2, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
			   u.RHMPPid,u2.RHMPPid as RHMPPid2, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion,				   
			   pp.RHPPid,
			   pp.RHPPcodigo,
			   pp.RHPPdescripcion,
			   ( select min({fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' - ',ltrim(rtrim(cf.CFdescripcion)))})})

					from CFuncional cf
					where cf.CFid = e.CFid
				) as Ctrofuncional,
				ltp.RHMPnegociado,
			   coalesce(a.IDInterfaz,0) as IDInterfaz,
			   RHAdiasenfermedad,
			   RHTNoMuestraCS,
			   c.RHTsubcomportam,
			   a.RHItiporiesgo,
			   a.RHIconsecuencia,
			   a.RHIcontrolincapacidad,
			   a.RHfolio,
			   a.RHporcimss
		from RHAcciones a
			inner join DatosEmpleado b
				on a.DEid = b.DEid
			 inner join RHTipoAccion c
				on a.RHTid = c.RHTid
			 left outer join RHPlazas e
				on a.RHPid = e.RHPid
				<!---====================================================================================  
					Se une con la linea del tiempo de la plaza presup. para obtener los datos de la plaza de RH 
					en el momento de la accion, se verifica que el puesto de RH tenga asignado el mismo
					puesto presupuestario de plaza presup. 
					Se obtiene de ahi el puesto presup. tabla salarial y categoria.						
				===============================================================================---->
			left outer join RHLineaTiempoPlaza ltp
				on e.RHPid = ltp.RHPid
				  and  a.DLfvigencia between ltp.RHLTPfdesde  and ltp.RHLTPfhasta
			left outer join RHPlazaPresupuestaria pp
				on ltp.RHPPid = pp.RHPPid
				  and ltp.Ecodigo = pp.Ecodigo
			left outer join RHCategoriasPuesto r
				on r.RHCPlinea = a.RHCPlinea
			left outer join RHTTablaSalarial s
				on s.RHTTid = r.RHTTid
			left outer join RHCategoria t
				on t.RHCid = r.RHCid
			left outer join RHMaestroPuestoP u 	<!----Puesto presupuestario ----->
				on r.RHMPPid = u.RHMPPid	
			<!---En caso de que existas puesto-categorias propuestos--->
			left outer join RHCategoriasPuesto r2
				on r2.RHCPlinea = a.RHCPlineaP
			left outer join RHTTablaSalarial s2
				on s2.RHTTid = r2.RHTTid
			left outer join RHCategoria t2
				on t2.RHCid = r2.RHCid
			left outer join RHMaestroPuestoP u2 	<!----Puesto presupuestario ----->
				on r2.RHMPPid = u2.RHMPPid	
		where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfreturn rsAccion>
</cffunction>
<cffunction name="fnSituacionActual" access="private" returntype="query">
	<cfargument name="DEid" 			type="numeric" required="yes">
	<cfargument name="DLfvigencia" 		type="date" required="yes">
		
	<cfquery name="rsEstadoActual" datasource="#session.dsn#">
		select a.LTid, rtrim(a.Tcodigo) as Tcodigo,
			   a.RHCPlineaP, 
			   a.RVid,
			   a.Ocodigo, 
			   a.Dcodigo, 
			   a.RHPid, 
			   coalesce(rtrim(a.RHPcodigoAlt),rtrim(a.RHPcodigo)) as RHPcodigo, 
			   (select min(coalesce(ltrim(rtrim(ff.RHPcodigoext)),rtrim(ltrim(ff.RHPcodigo))))
						from RHPuestos ff
						where ff.Ecodigo = a.Ecodigo
						   and ff.RHPcodigo = coalesce(a.RHPcodigoAlt,a.RHPcodigo)
						) as RHPcodigoext,
			   a.RHJid,
			   a.LTporcplaza, 
			   a.LTporcsal, 
			   a.LTsalario,
			   a.RHCPlinea,

			  (select min(b.Tdescripcion)
			  	from TiposNomina b
				where a.Ecodigo = b.Ecodigo
						and a.Tcodigo = b.Tcodigo
			  ) as  Tdescripcion, 
			  (select  min(c.Descripcion)
			  	from RegimenVacaciones c
				where a.RVid = c.RVid
			  ) as RegVacaciones, 
 			  (select min(d.Odescripcion)
			  	from Oficinas d
				where a.Ocodigo = d.Ocodigo
					and a.Ecodigo = d.Ecodigo
			  ) as Odescripcion, 
  			  (select min(e.Ddescripcion)
			  	from Departamentos e
				where a.Dcodigo = e.Dcodigo
					and a.Ecodigo = e.Ecodigo
			  ) as Ddescripcion, 			  
			   f.RHPdescripcion, 
			   rtrim(f.RHPcodigo) as CodPlaza,
			   
			   (select min(coalesce(ltrim(rtrim(fx.RHPcodigoext)),rtrim(ltrim(fx.RHPcodigo))))
						from RHPuestos fx
						where fx.Ecodigo = a.Ecodigo
						   and fx.RHPcodigo = coalesce(a.RHPcodigoAlt,a.RHPcodigo)
				 ) as CodPuesto, 
			   f.Dcodigo as CodDepto, 
			   f.Ocodigo as CodOfic,
			   {fn concat(rtrim(f.RHPcodigo),{fn concat(' - ',f.RHPdescripcion)})}	as Plaza,  
			   (select min(g.RHPdescpuesto)
			   	from RHPuestos g
				where g.RHPcodigo = coalesce(a.RHPcodigoAlt,a.RHPcodigo)
					and g.Ecodigo = a.Ecodigo
				) as RHPdescpuesto, 
			   (select 	min({fn concat(rtrim(coalesce(ltrim(rtrim(g.RHPcodigoext)),ltrim(rtrim(g.RHPcodigo)))),{fn concat(' - ',g.RHPdescpuesto)})})
			   	from RHPuestos g
				where g.RHPcodigo = coalesce(a.RHPcodigoAlt,a.RHPcodigo)
				  and g.Ecodigo = a.Ecodigo
			   ) as Puesto,
 			  (select 	min({fn concat(rtrim(j.RHJcodigo),{fn concat(' - ',j.RHJdescripcion)})})
			  	from RHJornadas j
				where  a.Ecodigo = j.Ecodigo
					and a.RHJid = j.RHJid
			  )	as Jornada,
			   s.RHTTid, s2.RHTTid as RHTTid2,
			   rtrim(s.RHTTcodigo) as RHTTcodigo, 
			   s.RHTTdescripcion, 
			   t.RHCid,  t2.RHCid as RHCid2, 
			   rtrim(t.RHCcodigo) as RHCcodigo, 
			   t.RHCdescripcion, 
			   u.RHMPPid, u2.RHMPPid as RHMPPid2,
			   rtrim(u.RHMPPcodigo) as RHMPPcodigo, 
			   u.RHMPPdescripcion,
			  (select 	min({fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' ',ltrim(rtrim(cf.CFdescripcion)))})})
			   from CFuncional cf
				where f.CFid = cf.CFid
					and f.Ecodigo = cf.Ecodigo		
			  )	as Ctrofuncional,
			   pp.RHPPid,
			   pp.RHPPcodigo,
			   pp.RHPPdescripcion,
			   ltp.RHMPnegociado
		from LineaTiempo a
			inner join RHPlazas f
				on a.RHPid = f.RHPid
				and a.Ecodigo = f.Ecodigo
				<!---====================================================================================  
						Se une con la linea del tiempo de la plaza presup. para obtener los datos de la plaza de RH 
						en el momento de la accion, se verifica que el puesto de RH tenga asignado el mismo
						puesto presupuestario de plaza presup. 						
					===============================================================================---->
			left outer join RHLineaTiempoPlaza ltp
				on f.RHPid = ltp.RHPid						
				  and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.DLfvigencia#"> between ltp.RHLTPfdesde 
				  and ltp.RHLTPfhasta
			left outer join RHPlazaPresupuestaria pp
				on ltp.RHPPid = pp.RHPPid
				  and ltp.Ecodigo = pp.Ecodigo							 
			left outer join RHCategoriasPuesto r
				on r.RHCPlinea = a.RHCPlinea
			left outer join RHTTablaSalarial s
				on s.RHTTid = r.RHTTid
			left outer join RHCategoria t
				on t.RHCid = r.RHCid
			left outer join RHMaestroPuestoP u 	<!----Puesto presupuestario ----->
				on r.RHMPPid = u.RHMPPid	
			<!---En caso de que existas puesto-categorias propuestos--->
			left outer join RHCategoriasPuesto r2
				 on r2.RHCPlinea = a.RHCPlineaP
			left outer join RHTTablaSalarial s2
				 on s2.RHTTid = r2.RHTTid
			left outer join RHCategoria t2
				 on t2.RHCid = r2.RHCid
			left outer join RHMaestroPuestoP u2 	<!----Puesto presupuestario ----->
				on r2.RHMPPid = u2.RHMPPid	
		where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.DLfvigencia#"> between a.LTdesde and a.LThasta
		  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#" null="#Len(Arguments.DEid) is 0#">
	</cfquery>
	
	<cfreturn rsEstadoActual>
</cffunction>