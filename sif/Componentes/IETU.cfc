<cfcomponent>
	<cffunction name="IETU_CreaTablas" access="public" output="no">
		<cfargument name="conexion"		type="string"	required="yes">
		<!--- Unicamente se deben incluir documentos de cobro o pago que involucre flujo de efectivo:
				Recibos de Cobro/Pago
				Recibos de Compras/Ventas de contado
				Anticipos de efectivo (fueron creados anteriormente por un documento de flujo de efectivo)
				Cheques
				Transferencias
		--->
		<cf_dbtemp name="IETUP_V1" returnvariable="IETUpago" datasource="#Arguments.conexion#">
			<cf_dbtempcol name="ID"					type="numeric"		mandatory="yes" identity="yes">
			<cf_dbtempcol name="EcodigoPago"		type="int"			mandatory="yes">
			<cf_dbtempcol name="ReferenciaPago"		type="varchar(35)"	mandatory="no">
			<cf_dbtempcol name="DocumentoPago"		type="varchar(20)"	mandatory="yes">
			<cf_dbtempcol name="TipoPago"    		type="int"			mandatory="yes"> <!---valores="1=Cobro, 2=Pago"--->
			<cf_dbtempcol name="FechaPago"			type="datetime"		mandatory="yes">


			<cf_dbtempcol name="SNid"				type="numeric"		mandatory="no">
			<cf_dbtempcol name="TESBid"				type="numeric"		mandatory="no">
			<cf_dbtempcol name="CDCcodigo"			type="numeric"		mandatory="no">

			<cf_dbtempcol name="McodigoPago"		type="numeric"		mandatory="yes">
			<cf_dbtempcol name="MontoPago"			type="money"		mandatory="yes">
			<cf_dbtempcol name="MontoPagoLocal"		type="money"		mandatory="yes">

			<cf_dbtempcol name="ReversarCreacion"	type="bit default 0" mandatory="yes"> <!--- valores="1=Aplicacion de un anticipo que afectó IETU en su creación por lo que debe reversarse la afectacion original" --->

			<!--- CAMPOS DE TRABAJO, NO LLENAR: --->
			<cf_dbtempcol name="IETUPid"			type="numeric"		mandatory="no">

			<cf_dbtempkey cols="ID">
		</cf_dbtemp>
		<cfset request.IETUpago = IETUpago>

		<cf_dbtemp name="IETUD_V1" returnvariable="IETUdocs" datasource="#Arguments.conexion#">
		<!--- Unicamente se deben incluir documentos que puedan afectar el IETU a los que se les aplicó el documento de cobro o pago:
				Facturas o ND en CxC y CxP
				La creacion de un Anticipo con un documento de cobro o pago
				Facturas de Compras/Ventas de contado
		--->
			<cf_dbtempcol name="ID"						type="numeric"		mandatory="yes">
			<cf_dbtempcol name="EcodigoDoc"				type="int"			mandatory="yes">
			<cf_dbtempcol name="ReferenciaDoc"			type="varchar(20)"	mandatory="yes">
			<cf_dbtempcol name="DocumentoDoc"			type="varchar(20)"	mandatory="yes">
			<cf_dbtempcol name="TipoDoc"    			type="int"			mandatory="yes"> <!---valores="1=CxC, 2=CxP, 3=Ventas Contado, 4=Compras Contado, 5=Otros"--->
			<cf_dbtempcol name="FechaDoc"				type="datetime"		mandatory="yes">
			<cf_dbtempcol name="OcodigoDoc"				type="int"			mandatory="yes">

			<cf_dbtempcol name="TipoAfectacion"			type="int"			mandatory="yes"> <!--- valores="1=Acreditar o Aumentar IETUxPagar (para Cobros/ventas contado), -1=Debitar o Disminuir IETUxPagar (para Pagos/compras contado)"--->

			<cf_dbtempcol name="McodigoDoc"				type="numeric"		mandatory="yes">
			<cf_dbtempcol name="MontoAplicadoDoc"		type="money"		mandatory="yes">
			<cf_dbtempcol name="MontoBaseDoc"			type="money"		mandatory="yes">
			<cf_dbtempcol name="MontoBasePago"			type="money"		mandatory="yes">
			<cf_dbtempcol name="MontoBaseLocal"			type="money"		mandatory="yes">
			<cf_dbtempcol name="TESRPTCid"				type="numeric"		mandatory="no">

			<cf_dbtempcol name="ReversarEnAplicacion"	type="bit default 0" mandatory="yes"> <!---valores="1=Creacion de un anticipo cuya afectación debe reversarse después en el momento de su aplicación"--->
			<cf_dbtempcol name="EsReversion"			type="bit default 0" mandatory="yes"> <!--- valores="1=Movimientos de Reversion durante la Aplicacion de un anticipo, reversando la afectación generada anteriormente durante su creacion"--->

			<!--- CAMPOS DE TRABAJO, NO LLENAR: --->
			<cf_dbtempcol name="generado"				type="numeric"		mandatory="no">
			<cf_dbtempcol name="TESRPTCfecha"			type="date"			mandatory="no">
			<cf_dbtempcol name="TESRPTCietuP"			type="numeric"		mandatory="no">
			<cf_dbtempcol name="CFcuentaDB"				type="numeric"		mandatory="no">
			<cf_dbtempcol name="CFcuentaCR"				type="numeric"		mandatory="no">

			<cf_dbtempindex cols="ID">
		</cf_dbtemp>
		<cfset request.IETUdocs = IETUdocs>
	</cffunction>
	
	<cffunction name="IETU_Afectacion" access="public" output="yes">
		<cfargument name="Ecodigo"		type="numeric"	required="yes" >
		<cfargument name="Oorigen"		type="string"	required="yes" >
		<cfargument name="Efecha"		type="date"		required="yes" >
		<cfargument name="Eperiodo"		type="numeric"	required="yes" >
		<cfargument name="Emes"			type="numeric"	required="yes" >
		<cfargument name="conexion"		type="string"	required="yes">
		<cfargument name="Contabilizar"	type="boolean"	default="yes" >

		<!--- Verifica si está activo IETU --->
		<cfquery name="rsIETU" datasource="#Arguments.conexion#">
			select count(1) as cantidad
			  from TESRPTCietu
			 where Ecodigo = #session.Ecodigo#
			   and TESRPTCietu	= 1
		</cfquery>
		<cfif rsIETU.cantidad EQ 0>
			<cfreturn>
		</cfif>

		<!--- Obtiene los documentos que se intentan procesar, pero hay que determinar cuales se deben y cuales no --->
		<cfquery name="rsIETUpago" datasource="#Arguments.conexion#">
			select * from #request.IETUpago#
		</cfquery>
		<cfif rsIETUpago.recordCount EQ 0>
			<return>
		</cfif>
		
		<!--- Obtiene el Parámetro vigente del Concepto de Pago --->
		<cfquery name="rsIETUpago" datasource="#Arguments.conexion#">
			update #request.IETUdocs#
			   set TESRPTCfecha = (select max(TESRPTCfecha) from TESRPTCietu where TESRPTCid = #request.IETUdocs#.TESRPTCid and Ecodigo = #request.IETUdocs#.EcodigoDoc and TESRPTCfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Efecha#">)
		</cfquery>
		<!--- Borra los documentos de afectación a procesar que no tienen IETU o que no afectan IETU --->
		<cfquery name="rsIETUpago" datasource="#Arguments.conexion#">
			delete from #request.IETUdocs#
			 where (
			 	select count(1)
				  from TESRPTCietu
				 where TESRPTCid	= #request.IETUdocs#.TESRPTCid
				   and TESRPTCfecha = #request.IETUdocs#.TESRPTCfecha
				   and TESRPTCietu	= 1
				 ) = 0
		</cfquery>

		<!--- Genera la reversion de los Anticipos que afectaron el IETU durante su creación:
				OJO: 
					p.MontoPago es en moneda de Pago 
					d.MontoAplicado es en moneda del Documento original
					NO SE DEBERÍAN MEZCLAR PERO EN ESTE CASO:
					El documento de pago es el Anticipo que se está aplicando y el documento original es la creacion del mismo Anticipo,
					por tanto, la moneda pago y moneda documento es la misma, porque es el mismo documento.
					La proporcion es el MontoPago (parte a aplicar) / IETUDmontoAplicado (total del Anticipo)
		--->
		<cfset LvarProporcionAplicada = "p.MontoPago/d.IETUDmontoAplicado">
		<cfquery name="rsIETUpago" datasource="#Arguments.conexion#">
			insert into #request.IETUdocs# (
				  ID
				, EcodigoDoc
				, TipoDoc
				, ReferenciaDoc
				, DocumentoDoc
				, OcodigoDoc
				, FechaDoc

				, TipoAfectacion

				, McodigoDoc
				, MontoAplicadoDoc
				, MontoBaseDoc
				, MontoBasePago
				, MontoBaseLocal

				, TESRPTCid
				, TESRPTCietuP
				, CFcuentaDB
				, CFcuentaCR

				, ReversarEnAplicacion, EsReversion
				)
				select 
					 p.ID
					,d.EcodigoDoc
					,d.IETUDorigen
					,d.IETUDreferencia
					,d.IETUDdocumento
					,d.OcodigoDoc
					,d.IETUDfecha

					,-d.IETUDsigno
					
					,d.McodigoDoc
					,round(d.IETUDmontoAplicado, 2)
					,round(d.IETUDmontoBase		* #LvarProporcionAplicada#, 2)
					,round(d.IETUDmontoBasePago	* #LvarProporcionAplicada#, 2)
					,round(d.IETUDmontoBaseLocal* #LvarProporcionAplicada#, 2)

					,d.TESRPTCid
					,d.TESRPTCietuP
					,d.CFcuentaDB
					,d.CFcuentaCR

					,0 , 1
			  from #request.IETUpago# p
			  	inner join IETUdoc d
				 on d.EcodigoDoc 		= p.EcodigoPago
				and d.IETUDreferencia	= p.ReferenciaPago
				and d.IETUDdocumento	= p.DocumentoPago
				and d.IETUDparaReversar	= 1
			 where ReversarCreacion = 1
		</cfquery>

		<!--- Borra los documentos de Pago a procesar que no le quedaron documentos de afectación ni reversión --->
		<cfquery name="rsIETUpago" datasource="#Arguments.conexion#">
			delete from #request.IETUpago#
			 where (
			 	select count(1)
				  from #request.IETUdocs#
				 where ID	= #request.IETUpago#.ID
				 ) = 0
			   and ReversarCreacion = 0
		</cfquery>

		<!--- Obtiene los documentos a procesar --->
		<cfquery name="rsIETUpago" datasource="#Arguments.conexion#">
			select * from #request.IETUpago#
		</cfquery>
		<cfif rsIETUpago.recordCount EQ 0>
			<return>
		</cfif>

		<!--- Obtiene los Parametros de Afectacion --->
		<cfquery datasource="#Arguments.conexion#">
			update #request.IETUdocs#
			   set TESRPTCietuP = (select TESRPTCietuP 	from TESRPTCietu where TESRPTCid = #request.IETUdocs#.TESRPTCid and TESRPTCfecha = #request.IETUdocs#.TESRPTCfecha)
			     , CFcuentaDB	= (select CFcuentaDB 	from TESRPTCietu where TESRPTCid = #request.IETUdocs#.TESRPTCid and TESRPTCfecha = #request.IETUdocs#.TESRPTCfecha)
			     , CFcuentaCR	= (select CFcuentaCR 	from TESRPTCietu where TESRPTCid = #request.IETUdocs#.TESRPTCid and TESRPTCfecha = #request.IETUdocs#.TESRPTCfecha)
			 where TESRPTCfecha is NOT null
			   and EsReversion = 0
		</cfquery>

		<cfloop query="rsIETUpago">
			<cfquery name="rsInsert" datasource="#Arguments.conexion#">
				insert into IETUpago (
					 Ecodigo			<!--- Empresa que realiza la transaccion --->
					,Oorigen			<!--- Referencia a tabla Origen de la transaccion --->
					,EcodigoPago		<!--- Empresa de Pago --->
					,IETUPreferencia	<!--- Indica el tipo de Documento de Pago --->
					,IETUPdocumento		<!--- Numero del documento de pago --->

					,IETUPtipo			<!--- Origen CxP CxC VentasContado --->
					,IETUPreversar		<!--- Aplicacion de Anticipo: Aplicacion de Documento que afecto IETU en su creacion que debe reversar dicha afectacion --->

					,SNid				<!--- ID Socio o Beneficiario Pago --->
					,TESBid				<!--- TESBid Beneficiario Manual --->
					,CDCcodigo			<!--- Codigo de Cliente Detallista Corporativo --->

					,Eperiodo			<!--- Periodo de Auxiliares --->
					,Emes				<!--- Mes de Auxiliares --->
					,IETUPfecha			<!--- Fecha de Pago --->
					,McodigoPago		<!--- Moneda del documento de pago --->
					,IETUPmontoPago		<!--- Monto del documento de pago en mondeda del documento de pago --->
					,IETUPmontoLocal	<!--- Monto del documento de pago en moneda local --->
					,IDcontable			<!--- Referencia a la poliza contable: debe llenarse despues de generar el asiento --->
					,BMUsucodigo
				)
				values (
					  #Arguments.Ecodigo#
					,'#Arguments.Oorigen#'
					,#rsIETUpago.EcodigoPago#
					,'#rsIETUpago.ReferenciaPago#'
					,'#rsIETUpago.DocumentoPago#'

					,#rsIETUpago.TipoPago#
					,#rsIETUpago.ReversarCreacion#

					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIETUpago.SNid#" 		null="#rsIETUpago.SNid EQ ''#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIETUpago.TESBid#"		null="#rsIETUpago.TESBid EQ ''#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIETUpago.CDCcodigo#"	null="#rsIETUpago.CDCcodigo EQ ''#">

					,<cfqueryparam cfsqltype="cf_sql_integer"  value="#Arguments.Eperiodo#">
					,<cfqueryparam cfsqltype="cf_sql_integer"  value="#Arguments.Emes#">
					,<cfqueryparam cfsqltype="cf_sql_date" value="#rsIETUpago.FechaPago#">
					,#rsIETUpago.McodigoPago#
					,#rsIETUpago.MontoPago#
					,#rsIETUpago.MontoPagoLocal#
					,NULL
					,#session.Usucodigo#
				)
				<cf_dbidentity1 name="rsInsert" datasource="#Arguments.conexion#" returnvariable="LvarIETUPid">
			</cfquery>
			<cf_dbidentity2 name="rsInsert" datasource="#Arguments.conexion#" returnvariable="LvarIETUPid">
			<cfquery datasource="#Arguments.conexion#">
				update #request.IETUpago#
				   set IETUPid = #LvarIETUPid#
				 where ID = #rsIETUpago.ID#
			</cfquery>
		</cfloop>
		<cfquery datasource="#Arguments.conexion#">
			insert into IETUdoc (
				 IETUPid				<!--- ID documento Pago --->
				,EcodigoDoc				<!--- Ecodigo Documento Afectacion --->
				,IETUDreferencia		<!--- Identifica el tipo de documento que afecto el IETU --->
				,IETUDdocumento			<!--- Numero de documento que afecto el IETU --->
				,OcodigoDoc				<!--- Oficina Documento Afectacion --->
				,IETUDfecha				<!--- Fecha del documento que afecto el IETU --->

				,IETUDorigen			<!--- Origen CxP CxC VentasContado --->

				,McodigoDoc				<!--- Moneda del documento que afecto el IETU --->
				,IETUDmontoAplicado		<!--- Monto del pago que se le aplico al documento en moneda del documento --->
				,IETUDmontoBase			<!--- Monto base al que se le aplico el IETU en moneda del documento --->
				,IETUDmontoBasePago		<!--- Monto base en moneda de Pago --->
				,IETUDmontoBaseLocal	<!--- Monto base en moneda local --->

				,TESRPTCid				<!--- Concepto de pagos a terceros --->
				,TESRPTCietuP			<!--- Porcentaje de IETU aplicado al monto base --->
				,CFcuentaDB				<!--- Cuenta provision Gasto x IETU --->
				,CFcuentaCR				<!--- Cuenta provision IETU  x Pagar --->
				,IETUDsigno				<!--- IETUsigno 1=Acreditacion/aumento IETUxPagar, -1=Debito/Disminución IETUxPagar --->
				,IETUDmonto				<!--- Monto de afectacion al IETU en moneda local --->

				,IETUDparaReversar		<!--- Creación de Anticipo: el documento debe reversarse cuando se va a aplicar --->
				,IETUDreversion			<!--- Movimientos de Reversion en Aplicación de Anticipo: es la reversion de la afectacion realizada cuando se creo el documento --->
			)
			select
				 p.IETUPid
				,d.EcodigoDoc
				,d.ReferenciaDoc
				,d.DocumentoDoc
				,d.OcodigoDoc
				,d.FechaDoc

				,d.TipoDoc

				,d.McodigoDoc
				,d.MontoAplicadoDoc
				,d.MontoBaseDoc
				,d.MontoBasePago
				,d.MontoBaseLocal

				,d.TESRPTCid
				,d.TESRPTCietuP
				,d.CFcuentaDB
				,d.CFcuentaCR
				,d.TipoAfectacion
				,round(d.MontoBaseLocal * TESRPTCietuP / 100,2)

				,ReversarEnAplicacion, EsReversion
			  from #request.IETUdocs# d
			  	inner join #request.IETUpago# p
					on p.ID = d.ID
		</cfquery>
		<cfif Arguments.Contabilizar>
			<cfset IETU_Contabilizar (Arguments.Ecodigo, Arguments.Oorigen, Arguments.Efecha, Arguments.Eperiodo, Arguments.Emes, Arguments.Conexion)>
		</cfif>
	</cffunction>

	<cffunction name="IETU_Contabilizar" access="public" output="yes">
		<cfargument name="Ecodigo"		type="numeric"	required="yes" >
		<cfargument name="Oorigen"		type="string"	required="yes" >
		<cfargument name="Efecha"		type="date"		required="yes" >
		<cfargument name="Eperiodo"		type="numeric"	required="yes" >
		<cfargument name="Emes"			type="numeric"	required="yes" >
		<cfargument name="conexion"		type="string"	required="yes">

		<!--- GENERACION DE POLIZA CONTABLE --->
		<cfquery datasource="#Arguments.conexion#">
			insert into #request.INTARC# ( 
				INTORI,		INTREL,		INTDOC,		INTREF,
				INTTIP,		INTDES,		
				Periodo, 	Mes,		INTFEC,
				Ccuenta, 	CFcuenta, 	Ocodigo,  		
				Mcodigo, 	INTMOE, 	INTCAM, 	INTMON 
			)
			select 
				'#Arguments.Oorigen#', 1, d.IETUDdocumento, d.IETUDreferencia,
				case when d.IETUDsigno = 1 then 'D' else 'C' end,
				<cf_dbfunction name="concat" args="'Provisión Gasto x IETU: ',IETUPreferencia,'-',IETUPdocumento,case when IETUDparaReversar=1 then ' (Creacion Anticipo)' when IETUDreversion=1 then ' (Reversion Anticipo)' else ' ' end">,
				#Arguments.Eperiodo#, 	#Arguments.Emes#, 		IETUPfecha,
				0, d.CFcuentaDB, d.OcodigoDoc,
				(
					select Mcodigo from Empresas where Ecodigo = d.EcodigoDoc
				),
				d.IETUDmonto, 1, d.IETUDmonto
			  from #request.IETUpago# t
			  	inner join IETUpago p
					inner join IETUdoc d
					on d.IETUPid = p.IETUPid
			  	on p.IETUPid = t.IETUPid
				inner join #request.IETUdocs# g
				 on g.ID 			= t.ID
				and g.EcodigoDoc 	= d.EcodigoDoc
				and g.ReferenciaDoc	= d.IETUDreferencia
				and g.DocumentoDoc	= d.IETUDdocumento
				and g.generado is null
			  where d.EcodigoDoc = #Arguments.Ecodigo#
		</cfquery>
		<cfquery datasource="#Arguments.conexion#">
			insert into #request.INTARC# ( 
				INTORI,		INTREL,		INTDOC,		INTREF,
				INTTIP,		INTDES,		
				Periodo, 	Mes,	INTFEC,
				Ccuenta, 	CFcuenta, 	Ocodigo,  		
				Mcodigo, 	INTMOE, 	INTCAM, 	INTMON 
			)
			select 
				'#Arguments.Oorigen#', 1, IETUDdocumento, IETUDreferencia,
				case when IETUDsigno = 1 then 'C' else 'D' end,
				<cf_dbfunction name="concat" args="'Provisión IETU x Pagar: ',IETUPreferencia,'-',IETUPdocumento,case when IETUDparaReversar=1 then ' (Creacion Anticipo)' when IETUDreversion=1 then ' (Reversion Anticipo)' else ' ' end">,
				#Arguments.Eperiodo#, 	#Arguments.Emes#, 		IETUPfecha,
				0, d.CFcuentaCR, d.OcodigoDoc,
				(
					select Mcodigo from Empresas where Ecodigo = d.EcodigoDoc
				),
				IETUDmonto, 1, IETUDmonto
			  from #request.IETUpago# t
			  	inner join IETUpago p
					inner join IETUdoc d
					on d.IETUPid = p.IETUPid
			  	on p.IETUPid = t.IETUPid
				inner join #request.IETUdocs# g
				 on g.ID 			= t.ID
				and g.EcodigoDoc 	= d.EcodigoDoc
				and g.ReferenciaDoc	= d.IETUDreferencia
				and g.DocumentoDoc	= d.IETUDdocumento
				and g.generado is null
			  where d.EcodigoDoc = #Arguments.Ecodigo#
		</cfquery>
		<cfquery datasource="#Arguments.conexion#">
			update #request.IETUdocs#
			   set generado = 1
			  where EcodigoDoc = #Arguments.Ecodigo#
			    and generado is null
		</cfquery>

<!---
<cfquery name="rsSQL" datasource="#Arguments.conexion#">
	select *
	  from #request.IETUpago#
</cfquery>
<cfdump var="#rsSQL#">
<cfquery name="rsSQL" datasource="#Arguments.conexion#">
	select *
	  from #request.IETUdocs#
</cfquery>
<cfdump var="#rsSQL#">
<cfquery name="rsSQL" datasource="#Arguments.conexion#">
	select *
	  from #request.INTARC#
</cfquery>
<cf_dump var="#rsSQL#">
--->
	</cffunction>

	<cffunction name="IETU_ActualizaIDcontable" access="public" output="no">
		<cfargument name="IDcontable"	type="numeric"	required="yes">
		<cfargument name="conexion"		type="string"	required="yes">
		
		<cfquery datasource="#Arguments.conexion#">
			update IETUpago
			   set IDcontable = #Arguments.IDcontable#
			 where (
			 	select count(1)
				  from #request.IETUpago# t
				  	inner join #request.IETUdocs# d
					 on d.ID = t.ID
				 where t.IETUPid = IETUpago.IETUPid
				   and d.generado = 1
			 )	> 0
			 and IDcontable is null
		</cfquery>
	</cffunction>
</cfcomponent>