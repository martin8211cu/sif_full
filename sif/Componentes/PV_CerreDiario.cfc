<!---*****************************************************************
			Última Modificación:	Agosto - 2006
			Programador:					Berman Romero Leiva.
			
			DETALLE DE CAMBIOS:
			1. Correcciones en Descripciones del Asiento Generado
			2. Contabilización De Otros Recibos
			3. Contabilización De Devolución De Recibos
*******************************************************************--->
<cfcomponent>
	<!--- AplicarMascara --->
	<cffunction name="AplicarMascara" access="public" output="true" returntype="string">
		<cfargument name="cuenta"   type="string" required="true">
		<cfargument name="objgasto" type="string" required="true">

		<cfset vCuenta = arguments.cuenta >
		<cfset vObjgasto = arguments.objgasto >

		<cfif len(trim(vCuenta))>
			<cfloop condition="Find('?',vCuenta,0) neq 0">
				<cfif len(trim(vObjgasto))>
					<cfset caracter = mid(vObjgasto, 1, 1) >
					<cfset vObjgasto = mid(vObjgasto, 2, len(vObjgasto)) >
					<cfset vCuenta = replace(vCuenta,'?',caracter) >
				<cfelse>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn vCuenta >
	</cffunction>
	
	<!--- 	*******************
			FALTANTE / SOBRANTE
			******************* --->
	<cffunction name="PV_CierreDiario_InsSobrante" access="package" output="true" returntype="boolean">
		<cfargument name="caja"				type="string" 	required="yes">
		<cfargument name="sfechahoy"			type="string"	required="yes">
		<cfargument name="sPeriodo"			type="string"	required="yes">
		<cfargument name="sMes"				type="string"	required="yes">
		<cfargument name="tableName"			type="string"	required="yes">
		<cfargument name="Ocodigo"			type="string"	required="yes">
		<cfargument name="nMoneda"			type="string"	required="yes">
		<cfargument name="CFcuentaSobrantes"		type="string"	required="yes">
		<cfargument name="CFcuentaFaltantes"		type="string"	required="yes">
		<cfargument name="CFcuenta"			type="string"	required="yes">
		<cfargument name="showPseudo"			type="boolean"	required="no"	default="false">
		<cfargument name="showStruts"			type="boolean"	required="no"	default="false">
		<cfargument name="debug"			type="boolean"	required="no"	default="false">
		<cfargument name="conexion"			type="string"	required="no"	default="#Session.DSN#">

		<!--- <cfif Arguments.debug>
			<cfif Arguments.showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>FALTANTE / SOBRANTE</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
					<tr><th scope="col" width="50%">&nbsp;</th><th scope="col" width="50%">FAM001.CFcuentaSobrantes</th></tr>
					<tr><th scope="col" width="50%">FAM001.CFcuentaFaltantes</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif> --->
		
		<cfquery name="rs_FALTANTE_SOBRANTE" datasource="#Arguments.conexion#">
			select coalesce(sum(FAX15MON),0.00) as FAX15MONsum
			from FAX015 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
			and FAM30CTO = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
			and FAM30LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="99">
			and coalesce(FAX15SCO, 'S') <> <cfqueryparam cfsqltype="cf_sql_char" value="C">
		</cfquery> 

		<cfif rs_FALTANTE_SOBRANTE.recordcount and rs_FALTANTE_SOBRANTE.FAX15MONsum neq 0.00>
			<cfquery datasource="#Arguments.conexion#">
				insert into #Arguments.tableName# (	INTORI, INTREL, INTDOC, INTREF, 
													INTMON, INTTIP, INTDES, INTFEC, 
													INTCAM, Periodo, Mes, CFcuenta, Ccuenta,
													Mcodigo, Ocodigo, INTMOE)
				values (
					'PV', 0, 'Efectivo', 'Caja: #Arguments.caja#', 
					<cfqueryparam cfsqltype="cf_sql_money" value="#abs(rs_FALTANTE_SOBRANTE.FAX15MONsum)#">, 
					<cfif rs_FALTANTE_SOBRANTE.FAX15MONsum LT 0.00>'C'<cfelse>'D'</cfif>,
					<cfif rs_FALTANTE_SOBRANTE.FAX15MONsum LT 0.00>
						'Cierre Pos - Sobrante de Caja: #Arguments.caja#', 
					<cfelse>
						'Cierre Pos - Faltante de Caja: #Arguments.caja#', 
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					1.00, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					<cfif rs_FALTANTE_SOBRANTE.FAX15MONsum LT 0.00>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuentaSobrantes#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuentaFaltantes#">
					</cfif>, 
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.nMoneda#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ocodigo#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#abs(rs_FALTANTE_SOBRANTE.FAX15MONsum)#">
				)
			</cfquery>

			<cfquery datasource="#Arguments.conexion#">
				insert into #Arguments.tableName# (	INTORI, INTREL, INTDOC, INTREF, 
													INTMON, INTTIP, INTDES, INTFEC, 
													INTCAM, Periodo, Mes, CFcuenta, Ccuenta,
													Mcodigo, Ocodigo, INTMOE)
				values (
					'PV', 0, 'Efectivo', 'Caja: #Arguments.caja#', 
					<cfqueryparam cfsqltype="cf_sql_money" value="#abs(rs_FALTANTE_SOBRANTE.FAX15MONsum)#">, 
					<cfif rs_FALTANTE_SOBRANTE.FAX15MONsum LT 0.00>'D'<cfelse>'C'</cfif>,
					'Cierre Pos - Efectivo Faltante/Sobrante en la Caja: #Arguments.caja#', 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					1.00, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.nMoneda#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ocodigo#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#abs(rs_FALTANTE_SOBRANTE.FAX15MONsum)#">
				)
			</cfquery>


		</cfif>
		
		<!--- <cfif Arguments.debug>
			<cfif Arguments.showStruts>
				<cfquery name="rsdebug" datasource="#Arguments.conexion#">
					select * from #Arguments.tableName#
				</cfquery>
				<cfdump var="#rsdebug#" label="#Arguments.tableName#">
			</cfif>
		</cfif> --->				
		
		<cfreturn true>
	</cffunction>

	<!--- EFECTIVO --->
	<cffunction name="PV_CierreDiario_InsEfectivo" access="package" output="true" returntype="boolean">
		<cfargument name="caja"					type="string" 	required="yes">
		<cfargument name="sfechahoy"			type="string"	required="yes">
		<cfargument name="sPeriodo"				type="string"	required="yes">
		<cfargument name="sMes"					type="string"	required="yes">
		<cfargument name="tableName"			type="string"	required="yes">
		<cfargument name="CFcuenta"				type="string"	required="yes">
		<cfargument name="showPseudo"			type="boolean"	required="no"	default="false">
		<cfargument name="showStruts"			type="boolean"	required="no"	default="false">
		<cfargument name="debug"				type="boolean"	required="no"	default="false">
		<cfargument name="conexion"				type="string"	required="no"	default="#Session.DSN#">

		<!--- <cfif Arguments.debug>
			<cfif Arguments.showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>EFECTIVO</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
					<tr><th scope="col" width="50%">FAM001.CFcuenta</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif> --->
		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# (	INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE )
			select	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
							select max(d.FAX11LIN) 
							from FAX011 d
							where c.FAM01COD = d.FAM01COD
							  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					(round(b.FAX12TOTMF * a.FAX01FCAM,2)), 
					'D', 
					'Cierre Pos - Efectivo', 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					a.FAX01FCAM, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">, 
					0,
					null, 
					null, 
					a.Mcodigo, 
					a.Ocodigo, 
					round(b.FAX12TOTMF, 2)
			from FAX001 a 
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'EF'
			where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
			  and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<!--- <cfif Arguments.debug>
			<cfif Arguments.showStruts>
				<cfquery name="rsdebug" datasource="#Arguments.conexion#">
					select * from #Arguments.tableName#
				</cfquery>
				<cfdump var="#rsdebug#" label="#Arguments.tableName#">
			</cfif>
		</cfif> --->

		<cfreturn true>
	</cffunction>

	<!--- CAMBIO --->
	<cffunction name="PV_CierreDiario_InsCambio" access="package" output="true" returntype="boolean">
		<cfargument name="caja"					type="string" 	required="yes">
		<cfargument name="sfechahoy"			type="string"	required="yes">
		<cfargument name="sPeriodo"				type="string"	required="yes">
		<cfargument name="sMes"					type="string"	required="yes">
		<cfargument name="tableName"			type="string"	required="yes">
		<cfargument name="CFcuenta"				type="string"	required="yes">
		<cfargument name="showPseudo"			type="boolean"	required="no"	default="false">
		<cfargument name="showStruts"			type="boolean"	required="no"	default="false">
		<cfargument name="debug"				type="boolean"	required="no"	default="false">
		<cfargument name="conexion"				type="string"	required="no"	default="#Session.DSN#">
		
		<!--- <cfif Arguments.debug>
			<cfif Arguments.showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>CAMBIO</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
					<tr><th scope="col" width="50%">FAM001.CFcuenta</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif> --->

		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# (	INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
			select 	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					(round(b.FAX10CAM * a.FAX01FCAM ,2)), 
					'C', 
					'Cierre Pos - Vuelto', 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					a.FAX01FCAM, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">, 
					0, 
					null, 
					null, 
					a.Mcodigo, 
					a.Ocodigo, 
					round(b.FAX10CAM , 2)
			from FAX001 a 
				inner join FAX010 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX10CAM <> 0.00
			where a.FAM01COD = '#Arguments.caja#'
			and a.FAX01STA = 'T'
			and a.Ecodigo = #Session.Ecodigo#
		</cfquery>
		
		<!--- <cfif Arguments.debug>
			<cfif Arguments.showStruts>
				<cfquery name="rsdebug" datasource="#Arguments.conexion#">
					select * from #Arguments.tableName#
				</cfquery>
				<cfdump var="#rsdebug#" label="#Arguments.tableName#">
			</cfif>
		</cfif>	 --->			
		
		<cfreturn true>
	</cffunction>

	<!---CHEQUES--->
	<cffunction name="PV_CierreDiario_InsCheques" access="package" output="true" returntype="boolean">
		<cfargument name="caja"					type="string" 	required="yes">
		<cfargument name="sfechahoy"			type="string"	required="yes">
		<cfargument name="sPeriodo"				type="string"	required="yes">
		<cfargument name="sMes"					type="string"	required="yes">
		<cfargument name="tableName"			type="string"	required="yes">
		<cfargument name="CFcuenta"				type="string"	required="yes">
		<cfargument name="showPseudo"			type="boolean"	required="no"	default="false">
		<cfargument name="showStruts"			type="boolean"	required="no"	default="false">
		<cfargument name="debug"				type="boolean"	required="no"	default="false">
		<cfargument name="conexion"				type="string"	required="no"	default="#Session.DSN#">

		<cfinclude template="../Utiles/sifConcat.cfm">
		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# (	INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta,
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
			select 	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					(round(b.FAX12TOTMF * a.FAX01FCAM ,2)), 
					'D', 
					'Cierre Pos - Cheque No. ' #_Cat# ltrim(rtrim(b.FAX12NUM)) #_Cat# ' Bco: ' #_Cat# ltrim(rtrim(c.Bdescripcion)), 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					a.FAX01FCAM, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">, 
					0, 
					null, 
					null, 
					a.Mcodigo, 
					a.Ocodigo, 
					round(b.FAX12TOTMF ,2)
			from FAX001 a
				inner join FAX012 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX12TIP = 'CK'
				inner join Bancos c
				 on b.Bid = c.Bid
			where a.FAM01COD = '#Arguments.caja#'
			and a.FAX01STA = 'T'
			and a.Ecodigo = #Session.Ecodigo#
		</cfquery>

		<!--- <cfif Arguments.debug>
			<cfif Arguments.showStruts>
				<cfquery name="rsdebug" datasource="#Arguments.conexion#">
					select * from #Arguments.tableName#
				</cfquery>
				<cfdump var="#rsdebug#" label="#Arguments.tableName#">
			</cfif>
		</cfif> --->
		<cfreturn true>
	</cffunction>

	<!--- 	TARJETAS DE CRÉDITO - COMISION TARJETAS DE CRÉDITO --->
	<cffunction name="PV_CierreDiario_InsCredito" access="package" output="true" returntype="boolean">
		<cfargument name="caja"					type="string" 	required="yes">
		<cfargument name="sfechahoy"			type="string"	required="yes">
		<cfargument name="sPeriodo"				type="string"	required="yes">
		<cfargument name="sMes"					type="string"	required="yes">
		<cfargument name="tableName"			type="string"	required="yes">
		<cfargument name="CFcuenta"				type="string"	required="yes">
		<cfargument name="showPseudo"			type="boolean"	required="no"	default="false">
		<cfargument name="showStruts"			type="boolean"	required="no"	default="false">
		<cfargument name="debug"				type="boolean"	required="no"	default="false">
		<cfargument name="conexion"				type="string"	required="no"	default="#Session.DSN#">

		<!--- <cfif Arguments.debug>
			<cfif Arguments.showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>TARJETAS DE CRÉDITO - COMISION TARJETAS DE CRÉDITO</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
					<tr><th scope="col" width="50%">FATarjetas.CFcuentaCobro</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>
		</cfif> --->
        <cfinclude template="../Utiles/sifConcat.cfm">
		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# ( INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
			select 	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					round(
						(round(b.FAX12TOTMF * a.FAX01FCAM ,2))  
						-  
						round((round(b.FAX12TOTMF * a.FAX01FCAM ,2)) * (coalesce(e.FATporccom,0.00)  / 100),2)
					, 2),
					'D', 
					'Cierre Pos - ' #_Cat# e.FATdescripcion, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					a.FAX01FCAM, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					coalesce(e.CFcuentaCobro, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">), 
					0, 
					null, 
					null, 
					a.Mcodigo, 
					a.Ocodigo, 
					(round(b.FAX12TOTMF - round((b.FAX12TOTMF * (coalesce(e.FATporccom,0.00)) / 100),2), 2) )
			from FAX001 a
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'TC'
				inner join FATarjetas e
					on e.FATid = b.FATid
					and e.FATtiptarjeta <> 'O'
			where a.FAM01COD = '#Arguments.caja#'
			and a.FAX01STA = 'T'
			and a.Ecodigo = #Session.Ecodigo#
		</cfquery>
		
		<!--- Contabilización de Documentos de Oferta --->
		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# ( INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
			select 	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					round(b.FAX12TOTMF * a.FAX01FCAM , 2),
					'D', 
					'Cierre Pos - Bono: ' #_Cat# ltrim(rtrim(c.BNDescripcion)), 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					a.FAX01FCAM, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					coalesce(b.CFcuenta, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">), 
					0, 
					null, 
					null, 
					a.Mcodigo, 
					cf.Ocodigo, 
					round(b.FAX12TOTMF, 2)
			from FAX001 a
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'BN'
				inner join FATiposBono c
				  on b.IdTipoBn = c.IdTipoBn
				inner join CFuncional cf
					on cf.CFid = b.CFid
			where a.FAM01COD = '#Arguments.caja#'
			and a.FAX01STA = 'T'
			and a.Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfreturn true>
	</cffunction>

	<!--- 	COMISION TARJETAS DE CRÉDITO --->
	<cffunction name="PV_CierreDiario_InsComisionCredito" access="package" output="true" returntype="boolean">
		<cfargument name="caja"					type="string" 	required="yes">
		<cfargument name="sfechahoy"			type="string"	required="yes">
		<cfargument name="sPeriodo"				type="string"	required="yes">
		<cfargument name="sMes"					type="string"	required="yes">
		<cfargument name="tableName"			type="string"	required="yes">
		<cfargument name="CFcuenta"				type="string"	required="yes">
		<cfargument name="showPseudo"			type="boolean"	required="no"	default="false">
		<cfargument name="showStruts"			type="boolean"	required="no"	default="false">
		<cfargument name="debug"				type="boolean"	required="no"	default="false">
		<cfargument name="conexion"				type="string"	required="no"	default="#Session.DSN#">
	
		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# ( INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
			select 	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					round((
						(round(b.FAX12TOTMF * a.FAX01FCAM,2)) * ( coalesce(e.FATporccom,0.00) ) / 100 
					), 2),
					'D', 
					'Cierre Pos - Comisión Tarjeta Crédito', 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					a.FAX01FCAM, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					coalesce(e.CFcuentaComision, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">), 
					0, 
					null, 
					null, 
					a.Mcodigo, 
					a.Ocodigo, 
					round((
						b.FAX12TOTMF * ( coalesce(e.FATporccom,0.00) ) / 100 
					),2)
			from FAX001 a
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'TC'
				left outer join FATarjetas e
					on e.FATid = b.FATid
					and e.FATtiptarjeta <> 'O'
			where a.FAM01COD = '#Arguments.caja#'
			  and a.FAX01STA = 'T'
			  and a.Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfreturn true>
	</cffunction>

	<!--- DEPÓSITOS--->
	<cffunction name="PV_CierreDiario_InsDepositos" access="package" output="true" returntype="boolean">
		<cfargument name="caja"					type="string" 	required="yes">
		<cfargument name="sfechahoy"			type="string"	required="yes">
		<cfargument name="sPeriodo"				type="string"	required="yes">
		<cfargument name="sMes"					type="string"	required="yes">
		<cfargument name="tableName"			type="string"	required="yes">
		<cfargument name="CFcuenta"				type="string"	required="yes">
		<cfargument name="showPseudo"			type="boolean"	required="no"	default="false">
		<cfargument name="showStruts"			type="boolean"	required="no"	default="false">
		<cfargument name="debug"				type="boolean"	required="no"	default="false">
		<cfargument name="conexion"				type="string"	required="no"	default="#Session.DSN#">

		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# ( INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
			select 	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					(round(b.FAX12TOTMF * a.FAX01FCAM ,2)), 
					'D', 
					'Cierre Pos - Deposito', 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					round(a.FAX01FCAM, 2), 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					coalesce(
						(select min(CFcuenta) from CFinanciera where Ccuenta =
						(
						select min(e.Ccuenta)
						from CuentasBancos e
						where e.CBcodigo = b.FAX12CTA
                        and e.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
                        and e.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
						and e.Ecodigo = b.Ecodigo
						and e.Bid = b.Bid
						))
						,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">
					), 
					0, 
					null, 
					null, 
					a.Mcodigo, 
					a.Ocodigo, 
					round(b.FAX12TOTMF , 2)
			from FAX001 a 
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'DB'
			where a.FAM01COD = '#Arguments.caja#'
			and a.FAX01STA = 'T'
			and a.Ecodigo = #Session.Ecodigo#
			
		</cfquery>
		<cfreturn true>
	</cffunction>


	<!--- 	CARTAS BANCARIAS - COMISIÓN CARTAS BANCARIAS --->
	<cffunction name="PV_CierreDiario_InsCartasBancarias" access="package" output="true" returntype="boolean">
		<cfargument name="caja"					type="string" 	required="yes">
		<cfargument name="sfechahoy"			type="string"	required="yes">
		<cfargument name="sPeriodo"				type="string"	required="yes">
		<cfargument name="sMes"					type="string"	required="yes">
		<cfargument name="tableName"			type="string"	required="yes">
		<cfargument name="CFcuenta"				type="string"	required="yes">
		<cfargument name="showPseudo"			type="boolean"	required="no"	default="false">
		<cfargument name="showStruts"			type="boolean"	required="no"	default="false">
		<cfargument name="debug"				type="boolean"	required="no"	default="false">
		<cfargument name="conexion"				type="string"	required="no"	default="#Session.DSN#">

		<cfinclude template="../Utiles/sifConcat.cfm">
		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# ( INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
			select 	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					round(b.FAX12TOTMF * a.FAX01FCAM ,2), 
					'D', 
					'CxC Carta Bancaria - ' #_Cat# ltrim(rtrim(d.CDCidentificacion)) #_Cat# ' / ' #_Cat#  d.CDCnombre, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					a.FAX01FCAM, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					null,
					coalesce(f.SNcuentacxc, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">), 
					null, 
					null, 
					a.Mcodigo, 
					a.Ocodigo, 
					round(b.FAX12TOTMF , 2)
			from FAX001 a 
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAM018 e
					on e.Bid = b.Bid
				inner join SNegocios f
					on e.SNcodigo = f.SNcodigo
					and e.Ecodigo = f.Ecodigo
				inner join ClientesDetallistasCorp d
				    on d.CDCcodigo = a.CDCcodigo
			where a.FAM01COD = '#Arguments.caja#'
			and a.FAX01STA = 'T'
			and a.Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfreturn true>
	</cffunction>

	<!---COMISIÓN CARTAS BANCARIAS--->
	<cffunction name="PV_CierreDiario_InsComisionCartasBancarias" access="package" output="true" returntype="boolean">
		<cfargument name="caja"					type="string" 	required="yes">
		<cfargument name="sfechahoy"			type="string"	required="yes">
		<cfargument name="sPeriodo"				type="string"	required="yes">
		<cfargument name="sMes"					type="string"	required="yes">
		<cfargument name="tableName"			type="string"	required="yes">
		<cfargument name="nMoneda"				type="string"	required="yes">
		<cfargument name="showPseudo"			type="boolean"	required="no"	default="false">
		<cfargument name="showStruts"			type="boolean"	required="no"	default="false">
		<cfargument name="debug"				type="boolean"	required="no"	default="false">
		<cfargument name="conexion"				type="string"	required="no"	default="#Session.DSN#">

		<!---DEBITA  CXC AL SOCIO DE NEGOCIOS POR LA COMISION BANCARIA--->
        <cfinclude template="../Utiles/sifConcat.cfm">
		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# (	INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
			select 	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					round((f.FAM19MON + round(((abs(round(a.FAX01TOT * a.FAX01FCAM,2)) - f.FAM19INF) * f.FAM19PRI / 100.0), 2)) +
					((f.FAM19MON + round(((abs(round(a.FAX01TOT * a.FAX01FCAM,2)) - f.FAM19INF) * f.FAM19PRI / 100.0), 2)) * h.Iporcentaje / 100.0),2) , 
					'D', 
					'CxC Comisión Carta Bancaria - ' #_Cat# ltrim(rtrim(d.CDCidentificacion)) #_Cat# ' / ' #_Cat#  d.CDCnombre, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					a.FAX01FCAM, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					null,
					coalesce(g.SNcuentacxc, -1),
					null, 
					null, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.nMoneda#">, 
					a.Ocodigo, 
					round((f.FAM19MON + round(((abs(round(a.FAX01TOT * a.FAX01FCAM,2)) - f.FAM19INF) * f.FAM19PRI / 100.0), 2)) +
					((f.FAM19MON + round(((abs(round(a.FAX01TOT * a.FAX01FCAM,2)) - f.FAM19INF) * f.FAM19PRI / 100.0), 2)) * h.Iporcentaje / 100.0),2)
			from FAX001 a
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAM018 e
					on e.Bid = b.Bid
				inner join FAM019 f
					on f.Bid = e.Bid
					and f.FAM19INF <= round(a.FAX01TOT * a.FAX01FCAM, 2)
					and f.FAM19SUP >= round(a.FAX01TOT * a.FAX01FCAM, 2)
				inner join SNegocios g
					on e.SNcodigo = g.SNcodigo
					and e.Ecodigo = g.Ecodigo
				inner join Impuestos h
					on h.Icodigo = e.Icodigo
					and h.Ecodigo = e.Ecodigo
				inner join ClientesDetallistasCorp d
				    on d.CDCcodigo = a.CDCcodigo
			where a.FAM01COD = '#Arguments.caja#'
			  and a.FAX01STA = 'T'
			  and a.Ecodigo = #Session.Ecodigo#
		</cfquery>

		<!---ACREDITA CUENTA DE COMISION DE CARTA BANCARIA.--->
		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# ( INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
			select 	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					round((f.FAM19MON + round(((abs(round(a.FAX01TOT * a.FAX01FCAM,2)) - f.FAM19INF) * f.FAM19PRI / 100.0), 2)),2) , 
					'C', 
					'Cierre Pos - Comisión Carta Bancaria - ' #_Cat# ltrim(rtrim(d.CDCidentificacion)) #_Cat# ' / ' #_Cat#  d.CDCnombre, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					a.FAX01FCAM, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					coalesce(e.CFcuentaComision, -1),
					0, 
					null, 
					null, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.nMoneda#">, 
					a.Ocodigo, 
					(f.FAM19MON + round(((abs(round(a.FAX01TOT * a.FAX01FCAM,2)) - f.FAM19INF) * f.FAM19PRI / 100.0), 2))
			from FAX001 a
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAM018 e
					on e.Bid = b.Bid
				inner join FAM019 f
					on f.Bid = e.Bid
					and f.FAM19INF <= round(a.FAX01TOT * a.FAX01FCAM, 2)
					and f.FAM19SUP >= round(a.FAX01TOT * a.FAX01FCAM, 2)
				inner join ClientesDetallistasCorp d
				    on d.CDCcodigo = a.CDCcodigo
			where a.FAM01COD = '#Arguments.caja#'
			and a.FAX01STA = 'T'
			and a.Ecodigo = #Session.Ecodigo#
		</cfquery>

		<!---ACREDITA CUENTA DE COMISION DE CARTA BANCARIA.--->
		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# (	INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
			select 	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					round((f.FAM19MON + round(((abs(round(a.FAX01TOT * a.FAX01FCAM,2)) - f.FAM19INF) * f.FAM19PRI / 100.0), 2)) * h.Iporcentaje / 100.0, 2), 
					'C', 
					'Cierre Pos - Impuesto x Comisión Carta Bancaria - ' #_Cat# ltrim(rtrim(d.CDCidentificacion)) #_Cat# ' / ' #_Cat# d.CDCnombre, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					a.FAX01FCAM, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					null,
					coalesce(h.Ccuenta, -1), 
					null, 
					null, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.nMoneda#">, 
					a.Ocodigo, 
					round((f.FAM19MON + round(((abs(round(a.FAX01TOT * a.FAX01FCAM,2)) - f.FAM19INF) * f.FAM19PRI / 100.0), 2)) * h.Iporcentaje / 100.0, 2)
			from FAX001 a
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAM018 e
					on e.Bid = b.Bid
				inner join FAM019 f
					on f.Bid = e.Bid
					and f.FAM19INF <= round(a.FAX01TOT * a.FAX01FCAM, 2)
					and f.FAM19SUP >= round(a.FAX01TOT * a.FAX01FCAM, 2)
				inner join Impuestos h
					on h.Icodigo = e.Icodigo
					and h.Ecodigo = e.Ecodigo
				inner join ClientesDetallistasCorp d
				    on d.CDCcodigo = a.CDCcodigo
			where a.FAM01COD = '#Arguments.caja#'
			  and a.FAX01STA = 'T'
			  and a.Ecodigo = #Session.Ecodigo#
		</cfquery>
		
		<!---DEBITA  Adelantos aplicados como forma de pago--->
		<cfquery datasource="#Arguments.conexion#">
			insert into #Arguments.tableName# (	INTORI, INTREL, INTDOC, INTREF, 
												INTMON, INTTIP, INTDES, INTFEC, 
												INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
												Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
			select 	'PV', 
					0, 
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					convert(varchar,a.FAX01NTR), 
					(round(c.FAX16MON * a.FAX01FCAM,2)), 
					'D', 
					'Cierre Pos - Aplicación de Adelanto ' #_Cat# convert(varchar, c.FAX14CON) #_Cat# ' - ' #_Cat# coalesce(ltrim(rtrim(cl.CDCidentificacion)), ' ') #_Cat# ' / ' #_Cat# coalesce(cl.CDCnombre, ' '), 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.sfechahoy#">, 
					a.FAX01FCAM, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
					coalesce(d.CFcuenta, -1),
					0,
					null, 
					null, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.nMoneda#">, 
					coalesce(co.Ocodigo, a.Ocodigo), 
					round(c.FAX16MON,2)
			from FAX001 a
				inner join FAX016 c
					 on c.Ecodigo   = a.Ecodigo
				 	and c.FAM01COD  = a.FAM01COD
					and c.FAX01NTR  = a.FAX01NTR
				inner join FAX014 d
					  on d.CDCcodigo = c.CDCcodigo
					 and d.FAX14CON  = c.FAX14CON
				 	 and d.Ecodigo   = c.Ecodigo
				left outer join FAM001 co
					  on co.FAM01COD = d.FAM01COD
					 and co.Ecodigo = d.Ecodigo
				left outer join ClientesDetallistasCorp cl
					  on cl.CDCcodigo = d.CDCcodigo
			where a.FAM01COD = '#Arguments.caja#'
			and a.FAX01STA = 'T'
			and a.Ecodigo = #Session.Ecodigo#
		</cfquery>
	
		<cfreturn true>
	</cffunction>

	<!--- Graba  Factura/NC en CxC--->
	<cffunction name="PV_CierreDiario_InsFacturaNCenCxC" access="package" output="true" returntype="boolean">
		<cfargument name="caja"					type="string" 	required="yes">
		<cfargument name="sfechahoy"			type="string"	required="yes">
		<cfargument name="sPeriodo"				type="string"	required="yes">
		<cfargument name="sMes"					type="string"	required="yes">
		<cfargument name="tableName"			type="string"	required="yes">
		<cfargument name="nMoneda"				type="string"	required="yes">
		<cfargument name="showPseudo"			type="boolean"	required="no"	default="false">
		<cfargument name="showStruts"			type="boolean"	required="no"	default="false">
		<cfargument name="debug"				type="boolean"	required="no"	default="false">
		<cfargument name="conexion"				type="string"	required="no"	default="#Session.DSN#">

		<cfquery datasource="#Arguments.conexion#">
				 insert into Documentos (
						Ecodigo,   		CCTcodigo,   	
						Ddocumento,   		
						Ocodigo,   			
						SNcodigo,     	Mcodigo, 
						Dtipocambio,  	
						Dtotal,    		Dsaldo,    			Dfecha,    			Dvencimiento,
						Ccuenta,
						Dtcultrev,   	
						Dusuario,   	Rcodigo,   			Dmontoretori,  		Dtref,      		Ddocref, 
						Icodigo,   		Dreferencia,  	DEidVendedor,  		DEidCobrador,  		DEdiasVencimiento,   DEordenCompra,
						DEnumReclamo,  	DEobservacion,  DEdiasMoratorio, 	DfechaAplicacion, id_direccionFact, id_direccionEnvio,
						CDCcodigo
				)
				select 	a.Ecodigo, 		
					coalesce((
						select CCTcodigo
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR)),'FA'),	
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					a.Ocodigo, 
					e.SNcodigo, 		b.Mcodigo, 
					round((b.FAX12TOTMF / b.FAX12TOT) * a.FAX01FCAM, 2),
					b.FAX12TOT,		b.FAX12TOT,			
					convert(date,a.FAX01FEC),
					dateadd(dd, coalesce(f.SNvenventas,0), convert(date,a.FAX01FEC)),
					f.SNcuentacxc,
					round((b.FAX12TOTMF / b.FAX12TOT) * a.FAX01FCAM,2), 
					<cfqueryparam cfsqltype="cf_sql_char" value="#session.usulogin#">,
					null, 
					0, 	
					null,      		
					null, 
					null, 
					null,   	
					null,    		
					null,  
					coalesce(f.SNvenventas,0), 
					null, 
					null, 
					null,  
					0, 
					<cf_dbfunction name="now">,
					coalesce(e.id_direccionFact, f.id_direccion), coalesce(e.id_direccionEnvio, f.id_direccion),
					a.CDCcodigo
			from FAX001 a 
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAM018 e
					on e.Bid = b.Bid
				inner join SNegocios f
					on e.SNcodigo = f.SNcodigo
					and e.Ecodigo = f.Ecodigo
				inner join ClientesDetallistasCorp d
				    on d.CDCcodigo = a.CDCcodigo
			where a.FAM01COD = '#Arguments.caja#'
			and a.FAX01STA = 'T'
			and a.Ecodigo = #Session.Ecodigo#
		</cfquery>
		
		<!----Insertar el plan de Pagos de estos documentos que se generaron ---->
		<cfquery datasource="#Arguments.conexion#">
				insert into PlanPagos (
					Ecodigo, CCTcodigo, Ddocumento, 
					PPnumero, PPfecha_vence, PPsaldoant, 
					PPprincipal, PPinteres, 
					PPpagoprincipal, PPpagointeres, PPpagomora, PPfecha_pago, 
					Mcodigo, PPtasa, PPtasamora, BMUsucodigo)
				select 
					a.Ecodigo,
					coalesce((
						select CCTcodigo
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR)),'FA'),	
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					1,  dateadd(dd, coalesce(f.SNvenventas,0), convert(date,a.FAX01FEC)), 
					b.FAX12TOT,
					b.FAX12TOT, 
					0,
					0, 0, 0, null,
					b.Mcodigo, 0, 0, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from FAX001 a 
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAM018 e
					on e.Bid = b.Bid
				inner join SNegocios f
					on e.SNcodigo = f.SNcodigo
					and e.Ecodigo = f.Ecodigo
				inner join ClientesDetallistasCorp d
				    on d.CDCcodigo = a.CDCcodigo
			where a.FAM01COD = '#Arguments.caja#'
			  and a.FAX01STA = 'T'
			  and a.Ecodigo = #Session.Ecodigo#
		</cfquery>

		<!----   Fin de inserción de Plan de Pagos de documentos generados      ---->
		<cfquery datasource="#Arguments.conexion#">
	        insert into BMovimientos (
				Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento, BMfecha, Ccuenta, 
				Ocodigo, SNcodigo, Mcodigo, Dtipocambio, Dtotal, Dfecha, Dvencimiento, 
				IDcontable, BMperiodo, BMmes, Dtcultrev, BMusuario, Rcodigo, 
				BMmontoretori, BMtref, BMdocref, Dtotalloc, Dtotalref, Icodigo, Dreferencia, CFid)
	        select 
				do.Ecodigo, do.CCTcodigo, do.Ddocumento, do.CCTcodigo, do.Ddocumento, do.Dfecha, do.Ccuenta, 
				do.Ocodigo, do.SNcodigo, do.Mcodigo, do.Dtipocambio, do.Dtotal, do.Dfecha, do.Dvencimiento, 
				null, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
				do.Dtipocambio, do.Dusuario, do.Rcodigo, do.Dmontoretori, do.Dtref, do.Ddocref, round(do.Dtotal * do.Dtipocambio,2), do.Dtotal, do.Icodigo, do.Dreferencia, do.CFid
			from FAX001 a 
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAX011 c
					on c.Ecodigo = a.Ecodigo
					and c.FAM01COD = a.FAM01COD
					and c.FAX01NTR = a.FAX01NTR
					and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR)
				inner join Documentos do
					on do.Ecodigo = a.Ecodigo
					and do.CCTcodigo = c.CCTcodigo
					and do.Ddocumento = c.FAX11DOC
			where a.FAM01COD = '#Arguments.caja#'
			and a.FAX01STA = 'T'
			and a.Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfquery datasource="#Arguments.conexion#">
				 insert into HDocumentos (
						Ecodigo,   		CCTcodigo,   	
						Ddocumento,   		
						Ocodigo,   			
						SNcodigo,     		Mcodigo, 
						Dtipocambio,  	
						Dtotal,    		Dsaldo,    			Dfecha,    			Dvencimiento,
						Ccuenta,
						Dtcultrev,   	
						Dusuario,   	Rcodigo,   			Dmontoretori,  		Dtref,      		Ddocref, 
						Icodigo,   		Dreferencia,  	DEidVendedor,  		DEidCobrador,  		DEdiasVencimiento,   DEordenCompra,
						DEnumReclamo,  	DEobservacion,  DEdiasMoratorio, 	DfechaAplicacion, id_direccionFact, id_direccionEnvio,
						FAX01NTR, FAM01COD, CDCcodigo
				)
				select 	a.Ecodigo, 		
						coalesce((
						select CCTcodigo
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR)),'CP'),	
						coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					a.Ocodigo, 
					e.SNcodigo, 		b.Mcodigo, 
					round((b.FAX12TOTMF / b.FAX12TOT) * a.FAX01FCAM, 2),
					b.FAX12TOT,		b.FAX12TOT,			
					convert(date,a.FAX01FEC),
					dateadd(dd, coalesce(f.SNvenventas,0), convert(date,a.FAX01FEC)),
					f.SNcuentacxc,
					round((b.FAX12TOTMF / b.FAX12TOT) * a.FAX01FCAM,2), 
					<cfqueryparam cfsqltype="cf_sql_char" value="#session.usulogin#">,
					null, 
					0, 	
					null,      		
					null, 
					null, 
					null,   	
					null,    		
					null,  
					coalesce(f.SNvenventas,0), 
					null, 
					null, 
					null,  
					0, 
					<cf_dbfunction name="now">,
					coalesce(e.id_direccionFact, f.id_direccion), coalesce(e.id_direccionEnvio, f.id_direccion),
					a.FAX01NTR, a.FAM01COD, a.CDCcodigo
			from FAX001 a 
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAM018 e
					on e.Bid = b.Bid
				inner join SNegocios f
					on e.SNcodigo = f.SNcodigo
					and e.Ecodigo = f.Ecodigo
				inner join ClientesDetallistasCorp d
				    on d.CDCcodigo = a.CDCcodigo
			where a.FAM01COD = '#Arguments.caja#'
			  and a.FAX01STA = 'T'
			  and a.Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfreturn true>
	</cffunction>

		<!--- Graba Comision de Factura/NC en CxC--->
	<cffunction name="PV_CierreDiario_InsFacturaComision" access="package" output="true" returntype="boolean">
		<cfargument name="caja"					type="string" 	required="yes">
		<cfargument name="sfechahoy"			type="string"	required="yes">
		<cfargument name="sPeriodo"				type="string"	required="yes">
		<cfargument name="sMes"					type="string"	required="yes">
		<cfargument name="tableName"			type="string"	required="yes">
		<cfargument name="nMoneda"				type="string"	required="yes">
		<cfargument name="showPseudo"			type="boolean"	required="no"	default="false">
		<cfargument name="showStruts"			type="boolean"	required="no"	default="false">
		<cfargument name="debug"				type="boolean"	required="no"	default="false">
		<cfargument name="conexion"				type="string"	required="no"	default="#Session.DSN#">

		<cfquery datasource="#Arguments.conexion#">
				 insert into Documentos (
						Ecodigo,   		CCTcodigo,   	
						Ddocumento,   		
						Ocodigo,   			
						SNcodigo,     		Mcodigo, 
						Dtipocambio,  	
						Dtotal,    		Dsaldo,    			Dfecha,    			Dvencimiento,
						Ccuenta,
						Dtcultrev,   	
						Dusuario,   	Rcodigo,   			Dmontoretori,  		Dtref,      		Ddocref, 
						Icodigo,   		Dreferencia,  	DEidVendedor,  		DEidCobrador,  		DEdiasVencimiento,   DEordenCompra,
						DEnumReclamo,  	DEobservacion,  DEdiasMoratorio, 	DfechaAplicacion, id_direccionFact, id_direccionEnvio
				)
				select 	a.Ecodigo, 		
					e.CCTcodigo,	
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					a.Ocodigo, 
					e.SNcodigo, 		b.Mcodigo, 
					round(a.FAX01FCAM, 2),
					round(
						((
							f.FAM19MON 
							+ round(
								(
									(
										abs( round(a.FAX01TOT * a.FAX01FCAM,2) ) 
										- f.FAM19INF
									) 
									* f.FAM19PRI / 100.0
								), 2)
						) * (1 + coalesce(h.Iporcentaje, 0) / 100.0)) ,2) , 
					round(
						((
							f.FAM19MON 
							+ round(
								(
									(
										abs( round(a.FAX01TOT * a.FAX01FCAM,2) ) 
										- f.FAM19INF
									) 
									* f.FAM19PRI / 100.0
								), 2)
						) * (1 + coalesce(h.Iporcentaje, 0) / 100.0)) ,2) , 
					convert(date,a.FAX01FEC),
					dateadd(dd, coalesce(g.SNvenventas,0), convert(date,a.FAX01FEC)), 
					g.SNcuentacxc,
					round(a.FAX01FCAM, 2),
					<cfqueryparam cfsqltype="cf_sql_char" value="#session.usulogin#">,
					null, 
					0, 	
					null,      		
					null, 
					e.Icodigo, 
					null,   	
					null,    		
					null,  
					coalesce(g.SNvenventas,0), 
					null, 
					null, 
					null,  
					0, 
					<cf_dbfunction name="now">,
					coalesce(e.id_direccionFact, g.id_direccion), coalesce(e.id_direccionEnvio, g.id_direccion)
			from FAX001 a
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAM018 e
					on e.Bid = b.Bid
				inner join FAM019 f
					on f.Bid = e.Bid
					and f.FAM19INF <= round(a.FAX01TOT * a.FAX01FCAM, 2)
					and f.FAM19SUP >= round(a.FAX01TOT * a.FAX01FCAM, 2)
				inner join SNegocios g
					on e.SNcodigo = g.SNcodigo
					and e.Ecodigo = g.Ecodigo
				inner join ClientesDetallistasCorp d
				    on d.CDCcodigo = a.CDCcodigo
				inner join Impuestos h
					on h.Icodigo = e.Icodigo
					and h.Ecodigo = e.Ecodigo
			where a.FAM01COD = '#Arguments.caja#'
			  and a.FAX01STA = 'T'
			  and a.Ecodigo = #Session.Ecodigo#
		</cfquery>

		<!----    Insertar el plan de Pagos de estos documentos que se generaron ---->
		<cfquery datasource="#Arguments.conexion#">
				insert into PlanPagos (
					Ecodigo, CCTcodigo, Ddocumento, 
					PPnumero, PPfecha_vence, PPsaldoant, 
					PPprincipal, PPinteres, 
					PPpagoprincipal, PPpagointeres, PPpagomora, PPfecha_pago, 
					Mcodigo, PPtasa, PPtasamora, BMUsucodigo)
				select 
					a.Ecodigo,
					e.CCTcodigo,	
					coalesce((
						select FAX11DOC
						from FAX011 c
						where c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
						and c.FAX01NTR = a.FAX01NTR
						and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR
					)),'N/A'),
					1,  dateadd(dd, coalesce(g.SNvenventas,0), convert(date,a.FAX01FEC)),  
					round(
						((
							f.FAM19MON 
							+ round(
								(
									(
										abs( round(a.FAX01TOT * a.FAX01FCAM,2) ) 
										- f.FAM19INF
									) 
									* f.FAM19PRI / 100.0
								), 2)
						) * (1 + coalesce(h.Iporcentaje, 0) / 100.0)) ,2) , 
					round(
						((
							f.FAM19MON 
							+ round(
								(
									(
										abs( round(a.FAX01TOT * a.FAX01FCAM,2) ) 
										- f.FAM19INF
									) 
									* f.FAM19PRI / 100.0
								), 2)
						) * (1 + coalesce(h.Iporcentaje, 0) / 100.0)) ,2) , 
					0,
					0, 0, 0, null,
					b.Mcodigo, 0, 0, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from FAX001 a
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAM018 e
					on e.Bid = b.Bid
				inner join FAM019 f
					on f.Bid = e.Bid
					and f.FAM19INF <= round(a.FAX01TOT * a.FAX01FCAM, 2)
					and f.FAM19SUP >= round(a.FAX01TOT * a.FAX01FCAM, 2)
				inner join SNegocios g
					on e.SNcodigo = g.SNcodigo
					and e.Ecodigo = g.Ecodigo
				inner join ClientesDetallistasCorp d
				    on d.CDCcodigo = a.CDCcodigo
				inner join Impuestos h
					on h.Icodigo = e.Icodigo
					and h.Ecodigo = e.Ecodigo
			where a.FAM01COD = '#Arguments.caja#'
			  and a.FAX01STA = 'T'
			  and a.Ecodigo = #Session.Ecodigo#
		</cfquery>
		<!----    Fin de inserción de Plan de Pagos de documentos generados      ---->
		<cfquery datasource="#Arguments.conexion#">
	        insert into BMovimientos (
				Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento, BMfecha, Ccuenta, 
				Ocodigo, SNcodigo, Mcodigo, Dtipocambio, Dtotal, Dfecha, Dvencimiento, 
				IDcontable, BMperiodo, BMmes, Dtcultrev, BMusuario, Rcodigo, 
				BMmontoretori, BMtref, BMdocref, Dtotalloc, Dtotalref, Icodigo, Dreferencia, CFid)
	        select 
				do.Ecodigo, do.CCTcodigo, do.Ddocumento, do.CCTcodigo, do.Ddocumento, do.Dfecha, do.Ccuenta, 
				do.Ocodigo, do.SNcodigo, do.Mcodigo, do.Dtipocambio, do.Dtotal, do.Dfecha, do.Dvencimiento, 
				null, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sPeriodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.sMes#">,
				do.Dtipocambio, do.Dusuario, do.Rcodigo, do.Dmontoretori, do.Dtref, do.Ddocref, round(do.Dtotal * do.Dtipocambio,2), do.Dtotal, do.Icodigo, do.Dreferencia, do.CFid
			from FAX001 a 
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAM018 e
					on e.Bid = b.Bid
				inner join FAX011 c
					on c.Ecodigo = a.Ecodigo
					and c.FAM01COD = a.FAM01COD
					and c.FAX01NTR = a.FAX01NTR
					and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR)
				inner join Documentos do
					on do.Ecodigo = a.Ecodigo
					and do.CCTcodigo = e.CCTcodigo
					and do.Ddocumento = c.FAX11DOC
			where a.FAM01COD = '#Arguments.caja#'
			  and a.FAX01STA = 'T'
			  and a.Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfquery datasource="#Arguments.conexion#">
				 insert into HDocumentos (
						Ecodigo,   		CCTcodigo,   	Ddocumento,   		Ocodigo,   			SNcodigo,     		Mcodigo, 
						Dtipocambio,  	Dtotal,    		Dsaldo,    			Dfecha,    			Dvencimiento,
						Ccuenta,		Dtcultrev,   	Dusuario,   	Rcodigo,   		Dmontoretori,  		Dtref,      		Ddocref, 
						Icodigo,   		Dreferencia,  	DEidVendedor,  		DEidCobrador,  		DEdiasVencimiento,   DEordenCompra,
						DEnumReclamo,  	DEobservacion,  DEdiasMoratorio, 	DfechaAplicacion, id_direccionFact, id_direccionEnvio, 
						FAX01NTR, FAM01COD, CDCcodigo
				)
				select 	
						do.Ecodigo,   	do.CCTcodigo,   do.Ddocumento,   	do.Ocodigo,   		do.SNcodigo,     	do.Mcodigo, 
						do.Dtipocambio, do.Dtotal,    	do.Dsaldo,    		do.Dfecha,    		do.Dvencimiento,
						do.Ccuenta,		do.Dtcultrev,   do.Dusuario,   		do.Rcodigo,   		do.Dmontoretori,  	do.Dtref,      		do.Ddocref, 
						do.Icodigo,   	do.Dreferencia,  do.DEidVendedor,  	do.DEidCobrador,  	do.DEdiasVencimiento,   do.DEordenCompra,
						do.DEnumReclamo,  	do.DEobservacion,  do.DEdiasMoratorio, 	do.DfechaAplicacion, do.id_direccionFact, do.id_direccionEnvio,
						a.FAX01NTR, a.FAM01COD, a.CDCcodigo
			from FAX001 a 
				inner join FAX012 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX12TIP = 'CP'
				inner join FAM018 e
					on e.Bid = b.Bid
				inner join FAX011 c
					on c.Ecodigo = a.Ecodigo
					and c.FAM01COD = a.FAM01COD
					and c.FAX01NTR = a.FAX01NTR
					and c.FAX11LIN = (
								select max(d.FAX11LIN)
								from FAX011 d
								where c.FAM01COD = d.FAM01COD
								  and c.FAX01NTR = d.FAX01NTR)
				inner join Documentos do
					on do.Ecodigo = a.Ecodigo
					and do.CCTcodigo = e.CCTcodigo
					and do.Ddocumento = c.FAX11DOC
			where a.FAM01COD = '#Arguments.caja#'
			and a.FAX01STA = 'T'
			and a.Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="PV_CerreDiario" access="public" returntype="boolean">		
		<cfargument name="caja" 	  type="string" 	required="true">
		<cfargument name="conexion"	  type="string"	required="no"	default="#Session.DSN#">
		<cfargument name="debug" 	  type="boolean" 	required="false" 	default="false">
		<cfargument name="stfechahoy" type="string"    required="false" default="#lsDateformat(Now(), "DD/MM/YYYY")#">
		
		<!--- DEFINICIÓN DE INICIAL DE VARIABLES --->
		
		<cfset var showStruts=Arguments.debug>
		<cfset var showPseudo=Arguments.debug>
		<cfset var RESULT=false>

		<cfset var nMoneda = -1>
		<cfset var dfechahoy = createdate(mid(stfechahoy, 7,4), mid(stfechahoy, 4,2), mid(stfechahoy, 1, 2))>
		<cfset var sfechahoy = "#RepeatString('0',2-Len(Day(dfechahoy)))##Day(dfechahoy)##RepeatString('0',2-Len(Month(dfechahoy)))##Month(dfechahoy)##Year(dfechahoy)#"> <!--- Ejemplo: 30012001 --->

		<cfif datecompare(dfechahoy, now()) EQ 1>
			<cf_errorCode	code = "51385" msg = "La fecha no puede ser mayor que la actual. Proceso Cancelado"> 
		</cfif>

		<cfif datediff("d",dfechahoy, now()) GT 4>
			<cf_errorCode	code = "51386" msg = "La fecha DE CIERRE no puede ser mayor a 4 dias de la fecha de hoy. Proceso Cancelado"> 
		</cfif>

		<cfset sPeriodo = "#Year(dfechahoy)#">
		<cfset sMes = "#Month(dfechahoy)#">

		<!--- CONSULTAS INICIALES A LA BASE DE DATOS Y VALIDACIONES CORRESPONDIENTES--->
		<cfquery name="rnMoneda" datasource="#Arguments.conexion#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif rnMoneda.recordcount and len(rnMoneda.value) and IsNumeric(rnMoneda.value) and rnMoneda.value gt 0>
			<cfset nMoneda = rnMoneda.value>
		<cfelse>
			<cf_errorCode	code = "51371" msg = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. No está definido la Moneda Local correctamente. Proceso Cancelado!">
		</cfif>
		<cfquery name="rsSelectFAM001" datasource="#Arguments.conexion#">
			select 
				Ocodigo, 
				FAM01TIP, 
				FAM01STS, 
				FAM01STP, 
				CFcuenta, 
				CFcuentaSobrantes, 
				CFcuentaFaltantes, 
				FAM01CODD as CodigoCaja
			from FAM001
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
		</cfquery>
		<cfif rsSelectFAM001.recordcount>
			<cfif rsSelectFAM001.FAM01STS neq 0 or rsSelectFAM001.FAM01STP neq 30>
				<cf_errorCode	code = "51372"
								msg  = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. La caja @errorDat_1@ se encuentra pendiente de cierre. Proceso Cancelado!"
								errorDat_1="#Arguments.caja#"
				>>
			<cfelseif rsSelectFAM001.FAM01TIP EQ 6 OR rsSelectFAM001.FAM01TIP EQ 8>
				<cf_errorCode	code = "51373"
								msg  = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. La caja @errorDat_1@ es cotizadora, no se puede efectuar cierre a cajas cotizadoras. Proceso Cancelado!"
								errorDat_1="#Arguments.caja#"
				>>
			<cfelseif len(rsSelectFAM001.Ocodigo) eq 0>
				<cf_errorCode	code = "51374"
								msg  = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. La caja @errorDat_1@ no tiene Oficina, no se puede efectuar cierre a cajas sin oficina. Proceso Cancelado!"
								errorDat_1="#Arguments.caja#"
				>>
			<cfelseif len(rsSelectFAM001.CFcuentaSobrantes) eq 0>
				<cf_errorCode	code = "51375"
								msg  = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. La caja @errorDat_1@ no tiene cuenta de Sobrantes, no se puede efectuar cierre a cajas sin cuenta de Sobrantes. Proceso Cancelado!"
								errorDat_1="#Arguments.caja#"
				>>
			<cfelseif len(rsSelectFAM001.CFcuentaFaltantes) eq 0>
				<cf_errorCode	code = "51376"
								msg  = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. La caja @errorDat_1@ no tiene cuenta de Faltantes, no se puede efectuar cierre a cajas sin cuenta de Faltantes. Proceso Cancelado!"
								errorDat_1="#Arguments.caja#"
				>>
			<cfelseif len(rsSelectFAM001.CFcuenta) eq 0>
				<cf_errorCode	code = "51377"
								msg  = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. La caja @errorDat_1@ no tiene cuenta, no se puede efectuar cierre a cajas sin cuenta. Proceso Cancelado!"
								errorDat_1="#Arguments.caja#"
				>>
			</cfif>
		<cfelse>
			<cf_errorCode	code = "51378"
							msg  = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. La caja @errorDat_1@ no existe en la empresa. Proceso Cancelado!"
							errorDat_1="#Arguments.caja#"
			>>
		</cfif>

		<cfset LvarCodigoCaja = rsSelectFAM001.CodigoCaja>

		<!--- Verificar que no existan transacciones Guardadas que tengan numero de documento asignado --->
		<cfquery name="rsSelectFAX001P" datasource="#Arguments.conexion#">
			select count(1) as Cantidad
			from FAX001
			where FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
			and FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="G">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and (FAX01DOC is not null or len(FAX01DOC) > 0)
		</cfquery>
		<cfif rsSelectFAX001P.Cantidad GT 0>
			<cf_errorCode	code = "51387"
							msg  = "Existen transacciones GUARDADAS para la caja '@errorDat_1@' que tienen Documento Asignado, no se puede efectuar el cierre de la caja"
							errorDat_1="#LvarCodigoCaja#"
			>
		</cfif>
		
		<cfquery name="rsSelectFAX001P" datasource="#Arguments.conexion#">
			select 1
			from FAX001
			where FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
			  and FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="P">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif rsSelectFAX001P.recordcount>
			<cf_errorCode	code = "51379" msg = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. La caja tiene transacciones en proceso. Proceso Cancelado!">>
		</cfif>
		<!--- ASIGNACIÓN DE CUENTAS CONTABLES--->
		<cfquery name="rsP2" datasource="#Arguments.conexion#">
			select Pvalor as P2
			from Parametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="2">
		</cfquery>
		<cfif rsP2.recordcount and rsP2.P2 EQ 'N'>
			<cfquery name="rsSelectFAX004a" datasource="#Arguments.conexion#">
				select distinct Ocodigo, SNcodigo, CCTcodigo, Aid, Alm_Aid, Cid, CFid
				from FAX004 a
				inner join FAX001 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
					and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<cfloop query="rsSelectFAX004a">
				<cfinvoke returnvariable="Cuentas" component="sif.Componentes.CG_Complementos" method="TraeCuenta" 
					Oorigen		= "PV"
					Ecodigo		= "#Session.Ecodigo#"
					Conexion	= "#Arguments.conexion#"
					Oficinas 	= "#rsSelectFAX004a.Ocodigo#"
					SNegocios  	= "#rsSelectFAX004a.SNcodigo#"
					CCTransacciones = "#rsSelectFAX004a.CCTcodigo#"
					Articulos 	= "#rsSelectFAX004a.Aid#"
					Almacen 	= "#rsSelectFAX004a.Alm_Aid#"
					Conceptos 	= "#rsSelectFAX004a.Cid#"
					CFuncional = "#rsSelectFAX004a.CFid#"/>
				<cfquery datasource="#Arguments.conexion#">
					Update FAX004
					set CFcuentaV = #Cuentas.CFcuenta#
					where FAX004.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and FAX004.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
					  and exists(select 1 from FAX001 b
						where b.Ecodigo = FAX004.Ecodigo
						  and b.FAX01NTR = FAX004.FAX01NTR
						  and b.FAM01COD = FAX004.FAM01COD
						  and b.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
						  and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">)
					  and FAX004.CFcuentaV is null
				</cfquery>
				<cfquery datasource="#Arguments.conexion#">
					Update FAX004
					set CFcuentaD = #Cuentas.CFcuenta#
					where FAX004.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and FAX004.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
					  and exists(select 1 from FAX001 b
						where b.Ecodigo = FAX004.Ecodigo
						  and b.FAX01NTR = FAX004.FAX01NTR
						  and b.FAM01COD = FAX004.FAM01COD
						  and b.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
						  and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">)
					  and FAX004.CFcuentaD is null
				</cfquery>
			</cfloop>			
		<cfelse>
			<cfquery datasource="#Arguments.conexion#">
				Update FAX004
				set CFcuentaV = (
					select min(CFcuenta) from CFinanciera where Ccuenta = 
					(select d.IACingventa from Existencias c, IAContables d where c.Aid = FAX004.Aid and c.Alm_Aid = FAX004.Alm_Aid and c.IACcodigo = d.IACcodigo and c.Ecodigo = d.Ecodigo)					
				)
				where FAX004.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and FAX004.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				  and exists(select 1 from FAX001 b
					where b.Ecodigo = FAX004.Ecodigo
					  and b.FAX01NTR = FAX004.FAX01NTR
					  and b.FAM01COD = FAX004.FAM01COD
					  and b.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
					  and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">)
				  and FAX004.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="A">
				  and FAX004.CFcuentaV is null
			</cfquery>
			<cfquery datasource="#Arguments.conexion#">
				Update FAX004
				set CFcuentaD = (
					select min(CFcuenta) from CFinanciera where Ccuenta = 
					(select d.IACdescventa from Existencias c, IAContables d where c.Aid = FAX004.Aid and c.Alm_Aid = FAX004.Alm_Aid and c.IACcodigo = d.IACcodigo and c.Ecodigo = d.Ecodigo)					
				)
				where FAX004.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and FAX004.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				  and exists(select 1 from FAX001 b
					where b.Ecodigo = FAX004.Ecodigo
					  and b.FAX01NTR = FAX004.FAX01NTR
					  and b.FAM01COD = FAX004.FAM01COD
					  and b.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
					  and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">)
				  and FAX004.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="A">
				  and FAX004.CFcuentaD is null
			</cfquery>
		</cfif>
		<cfquery name="rsSelectFAX004" datasource="#Arguments.conexion#">
			select distinct CtaVenF as Formato
			from FAX001 a, FAX004 b
			where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and b.Ecodigo = a.Ecodigo
				and b.FAX01NTR = a.FAX01NTR
				and b.FAM01COD = a.FAM01COD
				and b.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
				and b.CFcuentaV is null
				and b.CtaVenF is not null
			union
			select distinct CtaDesF as Formato
			from FAX001 a, FAX004 b
			where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and b.Ecodigo = a.Ecodigo
				and b.FAX01NTR = a.FAX01NTR
				and b.FAM01COD = a.FAM01COD
				and b.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
				and b.CFcuentaD is null
				and b.CtaDesF is not null
		</cfquery>
		<cfloop query="rsSelectFAX004">
			<cftransaction>
			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
				<cfinvokeargument name="Lprm_Cmayor" value="#Left(Formato,4)#"/>							
				<cfinvokeargument name="Lprm_Cdetalle" value="#mid(Formato,6,100)#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				<cfinvokeargument name="Lprm_DSN" value="#Arguments.conexion#"/>
				<cfinvokeargument name="Lprm_Ecodigo" value="#Session.Ecodigo#"/>
			</cfinvoke>
			</cftransaction>
			<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
				<cf_errorCode	code = "51380"
								msg  = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. @errorDat_1@. Proceso Cancelado!"
								errorDat_1="#LvarError#"
				>
			<cfelse>
				<cfquery datasource="#Arguments.conexion#">
					Update FAX004
						set CFcuentaV = 
							(select min(CFcuenta)
							from CFinanciera 
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and CFformato = <cfqueryparam value="#Formato#" cfsqltype="cf_sql_varchar">)
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
					and FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
					and CtaVenF = <cfqueryparam value="#Formato#" cfsqltype="cf_sql_varchar">
					and CFcuentaV is null
					and exists(select 1 from FAX001 b
							where b.Ecodigo = FAX004.Ecodigo
							and b.FAX01NTR = FAX004.FAX01NTR
							and b.FAM01COD = FAX004.FAM01COD
							and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">)
				</cfquery>
				<cfquery datasource="#Arguments.conexion#">
					Update FAX004
						set CFcuentaD = 
							(select min(CFcuenta)
							from CFinanciera 
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and CFformato = <cfqueryparam value="#Formato#" cfsqltype="cf_sql_varchar">)
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
					and FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
					and CtaDesF = <cfqueryparam value="#Formato#" cfsqltype="cf_sql_varchar">
					and CFcuentaD is null
					and exists(select 1 from FAX001 b
							where b.Ecodigo = FAX004.Ecodigo
							and b.FAX01NTR = FAX004.FAX01NTR
							and b.FAM01COD = FAX004.FAM01COD
							and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">)
				</cfquery>
			</cfif>
		</cfloop>

		<cfquery name="rsSelectFAX004Count" datasource="#Arguments.conexion#">
			select 1
			from FAX004 a
			inner join FAX001 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
			where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and a.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
			and a.CFcuentaV is null
			union
			select 1
			from FAX004 a
			inner join FAX001 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
			where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and a.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
			and a.CFcuentaD is null
		</cfquery>
		<cfif rsSelectFAX004Count.recordcount>
			<cf_errorCode	code = "51381" msg = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. No se logró definir las cuentas de ventas y/o descuentos por ventas. Proceso Cancelado!">
		</cfif>
		
		<!--- Actualiza Cuentas de Bonos --->
		<cfquery name="rsBonos" datasource="#Arguments.conexion#">
			SELECT 
				b.FAM01COD, 
				b.FAX01NTR, 
				b.FAX12LIN, 
				d.CFcuentac, 
				e.BNComplementoCF
			FROM FAX001 a

				inner join FAX012 b
					 on b.FAX01NTR = a.FAX01NTR
					and b.FAM01COD = a.FAM01COD
					and b.FAX12TIP = 'BN'

				inner join CFuncional d
					 on d.CFid    = b.CFid
					and d.Ecodigo = b.Ecodigo


				inner join FATiposBono e
					 on e.IdTipoBn = b.IdTipoBn
					and e.Ecodigo = b.Ecodigo

			where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
			  and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">	
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfloop query="rsBonos">

			<cfset Formato_CuentaBono = AplicarMascara(rsBonos.CFcuentac, rsBonos.BNComplementoCF)>

			<cftransaction>

			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
				<cfinvokeargument name="Lprm_Cmayor" value="#Left(Formato_CuentaBono,4)#"/>							
				<cfinvokeargument name="Lprm_Cdetalle" value="#mid(Formato_CuentaBono,6,100)#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				<cfinvokeargument name="Lprm_DSN" value="#Arguments.conexion#"/>
				<cfinvokeargument name="Lprm_Ecodigo" value="#Session.Ecodigo#"/>
			</cfinvoke>

			</cftransaction>

			<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
				<cf_errorCode	code = "51382"
								msg  = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS (Cuenta De Bono). @errorDat_1@. Proceso Cancelado!"
								errorDat_1="#LvarError#"
				>
			<cfelse>
				<cfquery datasource="#Arguments.conexion#">
					Update FAX012
						set CFcuenta = 
							(select min(CFcuenta)
							from CFinanciera 
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and CFformato = <cfqueryparam value="#Formato_CuentaBono#" cfsqltype="cf_sql_varchar">)
					where FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#rsBonos.FAM01COD#">
					and FAX01NTR = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsBonos.FAX01NTR#">
					and FAX12LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsBonos.FAX12LIN#">
				</cfquery>
			</cfif>

		</cfloop>
		
		<cfquery name="rsSelectFAX012Count" datasource="#Arguments.conexion#">
			SELECT count(1) as Cantidad
			FROM FAX001 a, FAX012 b, FATarjetas c, CFuncional d, FATiposBono e
			where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
			  and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">			
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a.FAM01COD = b.FAM01COD
			  and a.FAX01NTR = b.FAX01NTR
			  and b.FAX12TIP = 'TC' 
			  and c.FATid = b.FATid
			  and c.FATtiptarjeta = 'O'
			  and d.CFid = b.CFid
			  and d.Ecodigo = b.Ecodigo
			  and e.IdTipoBn = b.IdTipoBn
			  and e.Ecodigo = b.Ecodigo
			  and b.CFcuenta is null
		</cfquery>
		<cfif rsSelectFAX012Count.recordcount GT 0 and rsSelectFAX012Count.Cantidad GT 0>
			<cf_errorCode	code = "51383" msg = "PV_CerreDiario.PV_CerreDiario.VALIDACIONES_PREVIAS. No se logró definir las cuentas de Bonos. Proceso Cancelado!">
		</cfif>
		
		<!--- 	
			***********
			CREA INTARC
			*********** 
		--->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC" conexion="#Arguments.conexion#"/>

		<!--- Obtiene el numero de documento del ultimo cierre no aplicado --->
		<cfset vFecha = dfechahoy>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select FACDdocumento
			  from FAcierreDiario
			where Ecodigo  = #Session.Ecodigo#
			  and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
			  and FACDfechaAplicacion IS NULL
		</cfquery>
		<cfif rsSQL.FACDdocumento NEQ "">
			<cfset LvarNumeroCierreCaja = rsSQL.FACDdocumento>
		<cfelse>
			<cfset LvarNumeroCierreCaja = "#LSDateFormat(vFecha, "YYYYMMDD")##LSTimeFormat(Now(), 'HHmmss')#-#LvarCodigoCaja#">
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				insert into FAcierreDiario
					(
						Ecodigo,
						FAM01COD,
						FACDdocumento,
						FACDfechaInclusion,
						FACDfechaCierre,
						BMUsucodigo
					)
					values
					(
						#session.Ecodigo#,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">,
						'#LvarNumeroCierreCaja#',
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFecha#">,
						#session.Usucodigo#
					)						
			</cfquery>
		</cfif>
		<cftransaction>
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				update FAcierreDiario
				   set FACDfechaAplicacion	=
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					 , BMUsucodigo = #session.Usucodigo#
				where Ecodigo  		= #Session.Ecodigo#
				  and FAM01COD 		= <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				  and FACDdocumento	= <cfqueryparam cfsqltype="cf_sql_char" value="#LvarNumeroCierreCaja#">
			</cfquery>

			<!--- <cfif Arguments.debug>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr>
					<td class="style1">&nbsp;<strong>TRANSACCIÓN SECCION 0. CREA INTARC</strong></td>
				  </tr>
				</table>
			</cfif> --->
			<!--- 	***************************************************************
					TRANSACCIÓN SECCION 1. ANULAR TODAS LAS TRANSACCIONES GUARDADAS
					*************************************************************** --->
			<!--- <cfif Arguments.debug>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr>
					<td class="style1">&nbsp;<strong>TRANSACCIÓN SECCION 1. ANULAR TODAS LAS TRANSACCIONES GUARDADAS</strong></td>
				  </tr>
				</table>
			</cfif> --->
			<cfquery name="rsSelectFAX001P" datasource="#Arguments.conexion#">
				select count(1) as Cantidad
				from FAX001
				where FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="G">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			    and (FAX01DOC is null or len(FAX01DOC) = 0)
			</cfquery>
			<cfif rsSelectFAX001P.Cantidad GT 0>
				<cfquery datasource="#Arguments.conexion#">
					update FAX004
					set FAX04DEL = 1
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
					and exists ( select 1 from FAX001 
									where Ecodigo = FAX004.Ecodigo
									and FAX01NTR = FAX004.FAX01NTR 
									and FAM01COD = FAX004.FAM01COD 
									and FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="G">
									and (FAX01DOC is null or len(FAX01DOC) = 0)
								)
				</cfquery>
				<cfquery datasource="#Arguments.conexion#">
					delete FAX014
					from FAX001 c
					where c.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
					  and c.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="G">
					  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and (FAX01DOC is null or len(FAX01DOC) = 0)
					  and FAX014.FAX01NTR = c.FAX01NTR
					  and FAX014.FAM01COD = c.FAM01COD
					  and FAX014.Ecodigo  = c.Ecodigo
				</cfquery>
				<cfquery datasource="#Arguments.conexion#">
					update FAX001
					set FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="A">
					where FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
					  and FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="G">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and (FAX01DOC is null or len(FAX01DOC) = 0)
				</cfquery>
			</cfif>
			<!--- 	************************************************
					TRANSACCIÓN SECCION 2. CAMBIA ESTADO A CAJA A 50
					************************************************ ---->
			<!--- <cfif Arguments.debug>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr>
					<td class="style1">&nbsp;<strong>TRANSACCIÓN SECCION 2. CAMBIA ESTADO A CAJA A 50</strong></td>
				  </tr>
				</table>
			</cfif> --->
			<cfquery datasource="#Arguments.conexion#">
				update FAM001
				set FAM01STP = 50
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
			</cfquery>
			<!--- 	****************************************
					TRANSACCIÓN SECCION 3. INSERTA EN INTARC
					**************************************** ---->
			<!--- <cfif Arguments.debug>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr>
					<td class="style1">&nbsp;<strong>TRANSACCIÓN SECCION 3. INSERTA EN INTARC</strong></td>
				  </tr>
				</table>
			</cfif>
			<cfif Arguments.debug and showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
					<tr><th scope="col" width="50%"><strong>D</strong></th><th scope="col" width="50%"><strong>C</strong></th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif> --->

			<cfset procesoOK = PV_CierreDiario_InsSobrante(Arguments.caja, sfechahoy, sPeriodo, sMes, INTARC, rsSelectFAM001.Ocodigo, nMoneda, rsSelectFAM001.CFcuentaSobrantes, rsSelectFAM001.CFcuentaFaltantes, rsSelectFAM001.CFcuenta, showPseudo, showStruts, Arguments.debug)>

			<cfset procesoOK = PV_CierreDiario_InsEfectivo(Arguments.caja, sfechahoy, sPeriodo, sMes, INTARC, rsSelectFAM001.CFcuenta, showPseudo, showStruts, Arguments.debug)>

			<cfset procesoOK = PV_CierreDiario_InsCambio(Arguments.caja, sfechahoy, sPeriodo, sMes, INTARC, rsSelectFAM001.CFcuenta, showPseudo, showStruts, Arguments.debug)>

			<cfset procesoOK = PV_CierreDiario_InsCheques(Arguments.caja, sfechahoy, sPeriodo, sMes, INTARC, rsSelectFAM001.CFcuenta, showPseudo, showStruts, Arguments.debug)>

			<cfset procesoOK = PV_CierreDiario_InsCredito(Arguments.caja, sfechahoy, sPeriodo, sMes, INTARC, rsSelectFAM001.CFcuenta, showPseudo, showStruts, Arguments.debug)>

			<cfset procesoOK = PV_CierreDiario_InsComisionCredito(Arguments.caja, sfechahoy, sPeriodo, sMes, INTARC, rsSelectFAM001.CFcuenta, showPseudo, showStruts, Arguments.debug)>

			<cfset procesoOK = PV_CierreDiario_InsDepositos(Arguments.caja, sfechahoy, sPeriodo, sMes, INTARC, rsSelectFAM001.CFcuenta, showPseudo, showStruts, Arguments.debug)>

			<cfset procesoOK = PV_CierreDiario_InsCartasBancarias(Arguments.caja, sfechahoy, sPeriodo, sMes, INTARC, rsSelectFAM001.CFcuenta, showPseudo, showStruts, Arguments.debug)>

			<cfset procesoOK = PV_CierreDiario_InsComisionCartasBancarias(Arguments.caja, sfechahoy, sPeriodo, sMes, INTARC, nMoneda, showPseudo, showStruts, Arguments.debug)>

			<cfset procesoOK = PV_CierreDiario_InsFacturaNCenCxC(Arguments.caja, sfechahoy, sPeriodo, sMes, INTARC, nMoneda, showPseudo, showStruts, Arguments.debug)>

			<cfset procesoOK = PV_CierreDiario_InsFacturaComision(Arguments.caja, sfechahoy, sPeriodo, sMes, INTARC, nMoneda, showPseudo, showStruts, Arguments.debug)>


	
			<!--- 	****************
					VENTAS SERVICIOS
					**************** --->
			<!--- <cfif Arguments.debug>
				<cfif showPseudo>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
					  <tr><td class="style1">&nbsp;<strong>VENTAS SERVICIOS</strong></td></tr>
					  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
						<tr><th scope="col" width="50%">&nbsp;</th><th scope="col" width="50%">FAX004.CFcuentaV</th></tr>
					  </table></td></tr>
					</table>
					<hr>
				</cfif>			
			</cfif> --->
            <cfinclude template="../Utiles/sifConcat.cfm">
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									round((b.FAX04TOT + b.FAX04DESC) * a.FAX01FCAM,2), 
									'C', 
									'Cierre Pos - Venta ' #_Cat# b.FAX04DES, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									a.FAX01FCAM, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									b.CFcuentaV, 0, 
									null, 
									null, 
									a.Mcodigo, 
									a.Ocodigo, 
									round(b.FAX04TOT + b.FAX04DESC,2),a.CFid
				
				from FAX001 a 
					inner join  FAX004 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX04TIP = 'S'
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<!--- <cfif Arguments.debug>
				<cfif showStruts>
					<cfquery name="rsdebug" datasource="#Arguments.conexion#">
						select * from #INTARC#
					</cfquery>
					<cfdump var="#rsdebug#" label="#INTARC#">
				</cfif>
			</cfif> --->
			<!--- 	****************
					VENTAS ARTÍCULOS
					**************** --->
			<!--- <cfif Arguments.debug>
				<cfif showPseudo>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
					  <tr><td class="style1">&nbsp;<strong>VENTAS ARTÍCULOS</strong></td></tr>
					  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
						<tr><th scope="col" width="50%">&nbsp;</th><th scope="col" width="50%">IAContables.IACingventa</th></tr>
					  </table></td></tr>
					</table>
					<hr>
				</cfif>			
			</cfif> --->
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE.CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									(round(b.FAX04TOT * a.FAX01FCAM,2)), 
									'C', 
									'Cierre Pos - Venta', 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									a.FAX01FCAM, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									b.CFcuentaV, 0, 
									null, 
									null, 
									a.Mcodigo, 
									a.Ocodigo, 
									b.FAX04TOT,a.CFid
				
				from FAX001 a 
					inner join  FAX004 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX04TIP = 'A'
					left outer join Existencias e
					on e.Aid = b.Aid
					and e.Alm_Aid = b.Alm_Aid
					left outer join IAContables f
					on f.IACcodigo = e.IACcodigo
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<!--- <cfif Arguments.debug>
				<cfif showStruts>
					<cfquery name="rsdebug" datasource="#Arguments.conexion#">
						select * from #INTARC#
					</cfquery>
					<cfdump var="#rsdebug#" label="#INTARC#">
				</cfif>
			</cfif> --->
			<!--- 	**************************
					DESCUENTO VENTAS SERVICIOS
					************************** --->
			<!--- <cfif Arguments.debug>
				<cfif showPseudo>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
					  <tr><td class="style1">&nbsp;<strong>DESCUENTO VENTAS SERVICIOS</strong></td></tr>
					  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
						<tr><th scope="col" width="50%">FAX004.CFcuentaD</th><th scope="col" width="50%">&nbsp;</th></tr>
					  </table></td></tr>
					</table>
					<hr>
				</cfif>			
			</cfif> --->
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									(round(b.FAX04DESC * a.FAX01FCAM,2)), 
									'D', 
									'Cierre Pos - Descuento Venta', 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									a.FAX01FCAM, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									b.CFcuentaD, 0, 
									null, 
									null, 
									a.Mcodigo, 
									a.Ocodigo, 
									b.FAX04DESC, a.CFid
				
				from FAX001 a 
					inner join  FAX004 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX04TIP = 'S'
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<!--- <cfif Arguments.debug>
				<cfif showStruts>
					<cfquery name="rsdebug" datasource="#Arguments.conexion#">
						select * from #INTARC#
					</cfquery>
					<cfdump var="#rsdebug#" label="#INTARC#">
				</cfif>
			</cfif> --->
			<!--- 	**************************
					DESCUENTO VENTAS ARTÍCULOS
					************************** --->
			<!--- <cfif Arguments.debug>
				<cfif showPseudo>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
					  <tr><td class="style1">&nbsp;<strong>DESCUENTO VENTAS ARTÍCULOS</strong></td></tr>
					  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
						<tr><th scope="col" width="50%">IAContables.IACdescventa</th><th scope="col" width="50%">&nbsp;</th></tr>
					  </table></td></tr>
					</table>
					<hr>
				</cfif>			
			</cfif> --->
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									(round(b.FAX04DESC * a.FAX01FCAM,2)), 
									'D', 
									'Cierre Pos - Descuento Venta', 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									a.FAX01FCAM, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									b.CFcuentaD, 0, 
									null, 
									null, 
									a.Mcodigo, 
									a.Ocodigo, 
									b.FAX04DESC,a.CFid
				
				from FAX001 a 
					inner join  FAX004 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					and b.FAX04TIP = 'A'
					left outer join Existencias e
					on e.Aid = b.Aid
					and e.Alm_Aid = b.Alm_Aid
					left outer join IAContables f
					on f.IACcodigo = e.IACcodigo
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<!--- <cfif Arguments.debug>
				<cfif showStruts>
					<cfquery name="rsdebug" datasource="#Arguments.conexion#">
						select * from #INTARC#
					</cfquery>
					<cfdump var="#rsdebug#" label="#INTARC#">
				</cfif>
			</cfif> --->
			<!--- 	***************
					COSTO DE VENTAS
					*************** --->
			<!--- <cfif Arguments.debug>
				<cfif showPseudo>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
					  <tr><td class="style1">&nbsp;<strong>COSTO DE VENTAS</strong></td></tr>
					  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
						<tr><th scope="col" width="50%">IAContables.IACcostoventa</th><th scope="col" width="50%">&nbsp;</th></tr>
					  </table></td></tr>
					</table>
					<hr>
				</cfif>			
			</cfif> --->
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									round(abs(k.Kcosto),2), 
									case when FAX01TIP = '1' then 'D' else 'C' end, 
									'Cierre Pos - Costo de Ventas', 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									1.00, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									b.CFcuentaV, 0, 
									null, 
									null, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#nMoneda#">,
									a.Ocodigo, 
									round(abs(k.Kcosto),2),a.CFid
				
				from FAX001 a 
					inner join  FAX004 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					inner join Kardex k
					on k.Kid = b.Kid
					left outer join Existencias e
					on e.Aid = b.Aid
					and e.Alm_Aid = b.Alm_Aid
					left outer join IAContables f
					on f.IACcodigo = e.IACcodigo
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<!--- <cfif Arguments.debug>
				<cfif showStruts>
					<cfquery name="rsdebug" datasource="#Arguments.conexion#">
						select * from #INTARC#
					</cfquery>
					<cfdump var="#rsdebug#" label="#INTARC#">
				</cfif>
			</cfif> --->
			<!--- 	***********
					INVENTARIOS
					*********** --->
			<!--- <cfif Arguments.debug>
				<cfif showPseudo>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
					  <tr><td class="style1">&nbsp;<strong>INVENTARIOS</strong></td></tr>
					  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
						<tr><th scope="col" width="50%">&nbsp;</th><th scope="col" width="50%">IAContables.IACinventario</th></tr>
					  </table></td></tr>
					</table>
					<hr>
				</cfif>			
			</cfif> --->
					<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									round(abs(k.Kcosto),2), 
									case when FAX01TIP = '1' then 'C' else 'D' end,
									'Cierre Pos - Costo de Ventas Inventarios', 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									1.00, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									b.CFcuentaV, 0, 
									null, 
									null, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#nMoneda#">,
									a.Ocodigo, 
									round(abs(k.Kcosto),2),a.CFid
				
				from FAX001 a 
					inner join  FAX004 b
					on b.Ecodigo = a.Ecodigo
					and b.FAM01COD = a.FAM01COD
					and b.FAX01NTR = a.FAX01NTR
					inner join Kardex k
					on k.Kid = b.Kid
					left outer join Existencias e
					on e.Aid = b.Aid
					and e.Alm_Aid = b.Alm_Aid
					left outer join IAContables f
					on f.IACcodigo = e.IACcodigo
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<!--- <cfif Arguments.debug>
				<cfif showStruts>
					<cfquery name="rsdebug" datasource="#Arguments.conexion#">
						select * from #INTARC#
					</cfquery>
					<cfdump var="#rsdebug#" label="#INTARC#">
				</cfif>
			</cfif> --->
			<!--- 	*********
					IMPUESTOS
					********* --->
			<!--- <cfif Arguments.debug>
				<cfif showPseudo>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
					  <tr><td class="style1">&nbsp;<strong>IMPUESTOS</strong></td></tr>
					  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
						<tr><th scope="col" width="50%">&nbsp;</th><th scope="col" width="50%">Impuestos.Ccuenta</th></tr>
					  </table></td></tr>
					</table>
					<hr>
				</cfif>			
			</cfif> --->
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE, CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									(round(coalesce(a.FAX01MIT,0.00)* a.FAX01FCAM,2)), 
									'C', 
									'Cierre Pos - Impuestos', 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									a.FAX01FCAM, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									b.CFcuenta1, 0,
									null, 
									null, 
									a.Mcodigo, 
									a.Ocodigo, 
									coalesce(a.FAX01MIT,0.00),a.CFid
									
				from FAX001 a, FAP000 b
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.Ecodigo = b.Ecodigo
			</cfquery>
			<!--- <cfif Arguments.debug>
				<cfif showStruts>
					<cfquery name="rsdebug" datasource="#Arguments.conexion#">
						select * from #INTARC#
					</cfquery>
					<cfdump var="#rsdebug#" label="#INTARC#">
				</cfif>
			</cfif> --->
			<!--- 	**********
					DESCUENTOS
					********** --->
			<!--- <cfif Arguments.debug>
				<cfif showPseudo>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
					  <tr><td class="style1">&nbsp;<strong>DESCUENTOS</strong></td></tr>
					  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
						<tr><th scope="col" width="50%">FAX004.CFcuentaD</th><th scope="col" width="50%">&nbsp;</th></tr>
					  </table></td></tr>
					</table>
					<hr>
				</cfif>			
			</cfif> --->
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE.CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									(round(coalesce(a.FAX01MDT-a.FAX01MDL, 0)* a.FAX01FCAM,2)), 
									'D', 
									'Cierre Pos - Descuentos', 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									a.FAX01FCAM, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									c.CFcuenta, 0, 
									null, 
									null, 
									a.Mcodigo, 
									a.Ocodigo, 
									round(coalesce(a.FAX01MDT-a.FAX01MDL, 0),2),a.CFid
				
				from FAX001 a
					inner join FAM001 c
						on c.Ecodigo = a.Ecodigo
						and c.FAM01COD = a.FAM01COD
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<!--- <cfif Arguments.debug>
				<cfif showStruts>
					<cfquery name="rsdebug" datasource="#Arguments.conexion#">
						select * from #INTARC#
					</cfquery>
					<cfdump var="#rsdebug#" label="#INTARC#">
				</cfif>
			</cfif> --->
			<!--- 	**********
					DOCUMENTOS
					********** --->
			<!--- <cfif Arguments.debug>
				<cfif showPseudo>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
					  <tr><td class="style1">&nbsp;<strong>DOCUMENTOS</strong></td></tr>
					  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
						<tr><th scope="col" width="50%">Si CCTtipo es C entonces Documentos.Cuenta</th><th scope="col" width="50%">Si CCTtipo es C entonces Documentos.Cuenta</th></tr>
					  </table></td></tr>
					</table>
					<hr>
				</cfif>			
			</cfif> --->
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									(round(b.Dtotal * b.Dtipocambio,2)), 
									e.CCTtipo, 
									'Cierre Pos - Documento CxC Socio: ' #_Cat# s.SNnumero #_Cat# ' / ' #_Cat# s.SNnombre, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									b.Dtipocambio, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									b.Ccuenta, 
									null, 
									null, 
									b.Mcodigo, 
									a.Ocodigo, 
									round(b.Dtotal, 2),a.CFid
				
				from FAX001 a 
					inner join Documentos b
							inner join SNegocios s
							on  s.Ecodigo = b.Ecodigo
							and s.SNcodigo = b.SNcodigo

							inner join CCTransacciones e
							on e.Ecodigo = b.Ecodigo
							and e.CCTcodigo = b.CCTcodigo				

					on b.Ecodigo = a.Ecodigo
					and b.CCTcodigo = a.CCTcodigo
					and b.Ddocumento = a.FAX01DOC
				where a.FAM01COD = '#Arguments.caja#'
				  and a.FAX01STA = 'T'
				  and a.FAX01TIP = '1'
  				  and a.FAX01TPG = 1
				  and a.Ecodigo = #Session.Ecodigo#
			</cfquery>
			
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									(round(b.Dtotal * b.Dtipocambio,2)), 
									e.CCTtipo, 
									'Cierre Pos - Documento CxC Socio: ' #_Cat# s.SNnumero #_Cat# ' / ' #_Cat# s.SNnombre, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									b.Dtipocambio, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									b.Ccuenta, 
									null, 
									null, 
									b.Mcodigo, 
									a.Ocodigo, 
									round(b.Dtotal, 2),a.CFid
				
				from FAX001 a 
					inner join Documentos b
							inner join SNegocios s
							on  s.Ecodigo = b.Ecodigo
							and s.SNcodigo = b.SNcodigo

							inner join CCTransacciones e
							on e.Ecodigo = b.Ecodigo
							and e.CCTcodigo = b.CCTcodigo				

					on b.Ecodigo = a.Ecodigo
					and b.CCTcodigo = a.CCTcodigo
					and b.Ddocumento = a.FAX01DOC
				where a.FAM01COD = '#Arguments.caja#'
				  and a.FAX01STA = 'T'
				  and a.FAX01TIP = '4'
  				  and a.FAX01TPG = 1
				  and a.Ecodigo = #Session.Ecodigo#
			</cfquery>

			<!--- CONTABILIZACION DE Recibos de CxC Abiertos--->
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									(round(b.Dtotal * b.Dtipocambio,2)), 
									'C', 
									'Cierre Pos - Recibo CxC Socio: ' #_Cat# s.SNnumero #_Cat# ' / ' #_Cat# s.SNnombre, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									b.Dtipocambio, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									b.Ccuenta, 
									null, 
									null, 
									b.Mcodigo, 
									a.Ocodigo, 
									round(b.Dtotal, 2),a.CFid
				
				from FAX001 a 
					inner join Documentos b
						inner join SNegocios s
						on  s.Ecodigo = b.Ecodigo
						and s.SNcodigo = b.SNcodigo
						inner join CCTransacciones e
						on e.Ecodigo = b.Ecodigo
						and e.CCTcodigo = b.CCTcodigo				
					on b.Ecodigo = a.Ecodigo
					and b.CCTcodigo = a.CCTcodigo
					and b.Ddocumento = a.FAX01DOC
				where a.FAM01COD = '#Arguments.caja#'
				  and a.FAX01STA = 'T'
				  and a.FAX01TIP = '2'
  				  and a.FAX01TPG = 1
				  and a.Ecodigo = #Session.Ecodigo#
			</cfquery>
			
			<!--- 	**********
				CONTABILIZACION DE Recibos de CxC Directos a Facturas
				********** 
			--->

			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
	
				select 				'PV', 
									0, 
									coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
									convert(varchar,a.FAX01NTR), 
									(round(dr.FAX07MON * b.Dtipocambio,2)), 
									'C', 
									'Cierre Pos - Recibo CxC ' #_Cat# b.CCTcodigo #_Cat# ' ' #_Cat# b.Ddocumento, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
									b.Dtipocambio, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
									b.Ccuenta, 
									null, 
									null, 
									b.Mcodigo, 
									a.Ocodigo, 
									round(dr.FAX07MON, 2),a.CFid
				
				from FAX001 a 
					inner join FAX007 dr
						 on dr.FAM01COD = a.FAM01COD
						and dr.FAX01NTR = a.FAX01NTR
						inner join Documentos b
							 on b.Ecodigo    = dr.Ecodigo
							and b.CCTcodigo  = dr.CCTcodigo
							and b.Ddocumento = dr.Ddocumento
							and b.SNcodigo   = dr.SNcodigo
							inner join CCTransacciones e
								 on e.Ecodigo = b.Ecodigo
								and e.CCTcodigo = b.CCTcodigo				
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				  and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				  and a.FAX01TIP = <cfqueryparam cfsqltype="cf_sql_char" value="2">
  				  and a.FAX01TPG = 1
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			

			
			<!--- 	**********
					CONTABILIZACION DE ADELANTOS
					********** 
			--->
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
				select	'PV', 
						0,
						coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
						convert(varchar,a.FAX01NTR), 
						round(b.FAX14MON * a.FAX01FCAM, 2),
						'C', 
						'Cierre Pos - Recibo: '#_Cat# ltrim(rtrim(c.Descripcion)) #_Cat# ' de ' #_Cat# ltrim(rtrim(cl.CDCidentificacion)) #_Cat# ' / ' #_Cat# cl.CDCnombre , 
						<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
						a.FAX01FCAM, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
						coalesce(c.CFcuenta, b.CFcuenta), 
						0,
						null, 
						null, 
						a.Mcodigo, 
						a.Ocodigo, 
						b.FAX14MON,a.CFid
				FROM FAX001 a
					inner join FAX014 b
						on b.FAM01COD = a.FAM01COD 
						and b.FAX01NTR = a.FAX01NTR
						and b.CDCcodigo = a.CDCcodigo
					left join FATiposAdelanto c
						 on c.Ecodigo = b.Ecodigo
						and c.IdTipoAd = b.IdTipoAd
					inner join ClientesDetallistasCorp cl
						on cl.CDCcodigo = a.CDCcodigo
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			
			<!--- 	**********
					CONTABILIZACION DE OTROS RECIBOS
					Programador: Berman, Agosto 2006
					********** 
			--->
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
				select	'PV', 
						0,
						coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
						convert(varchar,a.FAX01NTR), 
						round(b.FAX04TOT * a.FAX01FCAM, 2),
						'C', 
						'Cierre Pos - Recibo: '#_Cat# ltrim(rtrim(c.Descripcion)) #_Cat# ' de ' #_Cat# ltrim(rtrim(cl.CDCidentificacion)) #_Cat# ' / ' #_Cat# cl.CDCnombre , 
						<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
						a.FAX01FCAM, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
						coalesce(c.CFcuenta, -1), 
						0,
						null, 
						null, 
						a.Mcodigo, 
						a.Ocodigo, 
						b.FAX04TOT,a.CFid
				FROM FAX001 a
					inner join FAX004 b
						on b.FAM01COD = a.FAM01COD 
						and b.FAX01NTR = a.FAX01NTR
					left join FATiposAdelanto c
						 on c.Ecodigo = b.Ecodigo
						and c.IdTipoAd = b.IdTipoAd
					inner join ClientesDetallistasCorp cl
						on cl.CDCcodigo = a.CDCcodigo
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				  and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				  and a.FAX01TIP = '3'
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			
			<!--- 	**********
					CONTABILIZACION DE DEVOLUCION DE RECIBOS
					Programador: Berman, Agosto 2006
					********** 
			--->
			<cfquery datasource="#Arguments.conexion#">
				insert into #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, CFcuenta, Ccuenta, 
									Cgasto, Cformato, Mcodigo, Ocodigo, 
									INTMOE,CFid)
				select	'PV', 
						0,
						coalesce((
									select FAX11DOC
									from FAX011 c
									where c.Ecodigo = a.Ecodigo
									and c.FAM01COD = a.FAM01COD
									and c.FAX01NTR = a.FAX01NTR
									and c.FAX11LIN = (
											select max(d.FAX11LIN)
											from FAX011 d
											where c.FAM01COD = d.FAM01COD
											  and c.FAX01NTR = d.FAX01NTR
									)),'N/A'),
						convert(varchar,a.FAX01NTR), 
						round(b.FAX04TOT * a.FAX01FCAM, 2),
						'C', 
						'Cierre Pos - Dev Recibo: '#_Cat# ltrim(rtrim(c.Descripcion)) #_Cat# ' de ' #_Cat# ltrim(rtrim(cl.CDCidentificacion)) #_Cat# ' / ' #_Cat# cl.CDCnombre , 
						<cfqueryparam cfsqltype="cf_sql_char" value="#sfechahoy#">, 
						a.FAX01FCAM, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
						coalesce(c.CFcuenta, -1), 
						0,
						null, 
						null, 
						a.Mcodigo, 
						a.Ocodigo, 
						b.FAX04TOT,a.CFid
				FROM FAX001 a
					inner join FAX004 b
						on b.FAM01COD = a.FAM01COD 
						and b.FAX01NTR = a.FAX01NTR
					left join FATiposAdelanto c
						 on c.Ecodigo = b.Ecodigo
						and c.IdTipoAd = b.IdTipoAd
					inner join ClientesDetallistasCorp cl
						on cl.CDCcodigo = a.CDCcodigo
				where a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				  and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				  and a.FAX01TIP = '0'
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			
			<!--- <cfif Arguments.debug>
				<cfif showStruts>

					<cfquery name="rsdebug" datasource="#Arguments.conexion#">
						select * from #INTARC#
					</cfquery>

					<cfdump var="#dfechahoy#">
					<cfdump var="#LsDateFormat(dfechahoy, "DD/MM/YYYY")#">
					<cfdump var="#sfechahoy#">
					<cfdump var="#sPeriodo#">
					<cfdump var="#sMes#">
					<cf_abort errorInterfaz="">

					<cfdump var="#rsdebug#" label="#INTARC#">
					<cftransaction action="rollback"/>
					<cf_abort errorInterfaz="">

				</cfif>

			</cfif> --->

			<cfquery datasource="#Arguments.conexion#">
					DELETE from #INTARC# WHERE INTMON = 0 AND INTMOE = 0
			</cfquery>

			<cfquery name="rsVerificaBalance" datasource="#Arguments.conexion#">
				select 
					sum(case when INTTIP = 'D' then INTMON else 0.00 end) as Debitos,
					sum(case when INTTIP = 'C' then INTMON else 0.00 end) as Creditos,
					sum(case when INTTIP = 'D' then INTMOE else 0.00 end) as DebitosE,
					sum(case when INTTIP = 'C' then INTMOE else 0.00 end) as CreditosE
					from #INTARC#
			</cfquery>

			<cfif rsVerificaBalance.recordcount GT 0> 
				<cfif rsVerificaBalance.Debitos Not Equal rsVerificaBalance.Creditos or rsVerificaBalance.DebitosE Not Equal rsVerificaBalance.CreditosE>

					<!---   Revisión de los Datos de la tabla antes de enviar a Posteo de Asientos  --->
					<br>
					No se logró balancear el Asiento Generado
					<br>
					Documentos:
					<br>
					<cfquery name="rsVerificaBalanceDoc" datasource="#Arguments.conexion#">
						select 
							d.INTREF as A_Transaccion,
							d.INTDOC as A_Documento,
							sum(case when INTTIP = 'D' then INTMON else 0.00 end) as Debitos,
							sum(case when INTTIP = 'C' then INTMON else 0.00 end) as Creditos
						from #INTARC# d
						group by d.INTREF, d.INTDOC
						having sum(case when INTTIP = 'D' then INTMON else 0.00 end) <> sum(case when INTTIP = 'C' then INTMON else 0.00 end)
					</cfquery>

					<cfdump var="#rsVerificaBalanceDoc#" label="DocsDesbalance">

					<cfquery name="rsVerifica" datasource="#Arguments.conexion#">
						select 
							d.INTDOC as A_Documento,
							'A_Financiera' as B_TipoCuenta, 
							c.CFformato as C_Cuenta, 
							d.INTTIP Mov_Tipo, 
							d.INTMON as Mov_Monto, 
							case when d.INTTIP = 'D' then INTMON else 0.00 end as Mov_Debitos,
							case when d.INTTIP = 'C' then INTMON else 0.00 end as Mov_Creditos,
							d.INTDES as Mov_Descripcion, 
							coalesce(c.CFdescripcion, ' **** NO EXISTE **** ') as C_DescripcionCuenta
						from #INTARC# d
						  left join CFinanciera c
							on c.CFcuenta = d.CFcuenta
						where d.CFcuenta is not null 
		
						union all
		
						select 
							d.INTDOC as A_Documento,
							'A_Contable' as B_TipoCuenta, 
							c.Cformato as C_Cuenta, 
							d.INTTIP Mov_Tipo, 
							d.INTMON as Mov_Monto, 
							case when d.INTTIP = 'D' then INTMOE else 0.00 end as Mov_Debitos,
							case when d.INTTIP = 'C' then INTMOE else 0.00 end as Mov_Creditos,
							d.INTDES as Mov_Descripcion, 
							coalesce(c.Cdescripcion, ' **** NO EXISTE **** ') as C_DescripcionCuenta
						from #INTARC# d
						  left join CContables c
							on c.Ccuenta = d.Ccuenta
						where d.CFcuenta is null 
						  and d.Ccuenta is not null 
	
						order by d.INTDOC
					</cfquery>
		
					<cfdump var="#rsVerifica#" label="AsientoGenerado">
	
					<cfquery name="rsdebug" datasource="#Arguments.conexion#">
						select * from #INTARC#
					</cfquery>
		
					<cfdump var="#rsdebug#">
	
					<cftransaction action="rollback"/>
					<cf_abort errorInterfaz="No se logró balancear el Asiento Generado">
	
					<!---  Fin de Revisión de los Datos de la tabla antes de enviar a Posteo de Asientos  --->
	

				</cfif>
			</cfif>

			<!---  Se cambia la fecha del asiento por la que viene en parametros. M. Esquivel 27 / Octubre / 2005 
			<cfset vFecha = createdate( year(now()), month(now()), day(now()) ) >
			--->
			
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
				<cfinvokeargument name="Conexion" value="#Session.Dsn#"/>
				<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
				<cfinvokeargument name="Usuario" value="#Session.Usulogin#"/>
				<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
				<cfinvokeargument name="Oorigen" value="PV"/>				
				<cfinvokeargument name="Eperiodo" value="#sPeriodo#"/>
				<cfinvokeargument name="Emes" value="#sMes#"/>
				<cfinvokeargument name="Efecha" value="#vFecha#"/>
				<cfinvokeargument name="Edescripcion" value="Cierre de Cajas - Caja: #LvarCodigoCaja# Fecha: #LSDateFormat(vFecha, "DD/MM/YYYY")#."/> 
				<cfinvokeargument name="Edocbase" value="#LvarNumeroCierreCaja#"/>
				<cfinvokeargument name="Ereferencia" value="CIERRE CAJA"/>
				<cfinvokeargument name="Ocodigo" value="#rsSelectFAM001.Ocodigo#"/>
 				<cfinvokeargument name="Debug" value="#Arguments.debug#"/> 
			</cfinvoke>

			<cfif res_GeneraAsiento LT 1 or res_GeneraAsiento EQ ''>
				<cftransaction action="rollback"/>
				<cf_errorCode	code = "51012" msg = "Error en la Generación del Asiento">
			</cfif> 
 
			<!--- <cfif Arguments.debug>
				<cfdump var="#res_GeneraAsiento#">
				<cfquery name="rsVerifica" datasource="#Arguments.conexion#">
					select 
						d.CFcuenta as A_CuentaFinanciera,
						d.Ccuenta as A_CuentaContable,
						c.Cformato as A_CuentaFormato, 
						case when d.Dmovimiento = 'D' then Dlocal else 0.00 end as Mov_Debitos,
						case when d.Dmovimiento = 'C' then Dlocal else 0.00 end as Mov_Creditos,
						d.Dlocal as Mov_Monto, 
						d.Dmovimiento as Mov_Tipo, 
						d.Ddescripcion as Mov_Descripcion
					from DContables d
					  inner join CContables c
						on c.Ccuenta = d.Ccuenta
					where IDcontable = #res_GeneraAsiento#
				</cfquery>
				<cfdump var="#rsVerifica#" label="AsientoGenerado">
	
				<cfquery name="rsdebug" datasource="#Arguments.conexion#">
					select * from #INTARC#
				</cfquery>
	
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif> --->
			<cfquery name="rsBTid" datasource="#Arguments.conexion#">
				select min(BTid) as BTid
				from FAP000
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>

			<cfif rsBTid.recordcount eq 0>
				<cf_errorCode	code = "51384" msg = "No se ha definido el parámetro Tipo de Transacción de Depósito en los parámetros de Punto de Venta! Proceso Cancelado!">
			</cfif>

			<cfif rsBTid.recordcount EQ 0 or rsBTid.BTid eq ''>
				<br>
				<br>
				<br>
				<stong> No se ha definido la Transaccion de Bancos para registrar los Depósitos Bancarios. </strong>
				<br>
				<br>
				<strong>Se ha reversado el cierre de la Caja</strong>
			 
				<cftransaction action="rollback"/>
				<cf_abort errorInterfaz="No se ha definido la Transaccion de Bancos para registrar los Depósitos Bancarios.">
			</cfif>

			<cfquery datasource="#Arguments.conexion#">
				insert into MLibros (Ecodigo, Bid, BTid,
						CBid, Mcodigo, MLfecha, MLdescripcion, 
						MLdocumento, MLreferencia, MLconciliado, MLtipocambio, 
						MLmonto, MLmontoloc, MLperiodo, MLmes, 
						MLtipomov, MLusuario, IDcontable, MLfechamov, BMUsucodigo)
				SELECT  a.Ecodigo, 
						a.Bid, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBTid.BTid#">, 
						b.CBid, 
						a.Mcodigo, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dfechahoy#">, 
						'Pago de Transacción Caja: ' #_Cat# convert(varchar,a.FAM01COD) #_Cat# ', Transaccion: ' #_Cat# convert(varchar,a.FAX01NTR),
						convert(varchar,a.FAX12NUM), 
						convert(varchar,a.FAM01COD) #_Cat# '-' #_Cat# convert(varchar,a.FAX01NTR), 
						'N', 
						round( a.FAX12TOT / a.FAX12TOTMF * c.FAX01FCAM ,2),
						a.FAX12TOT, 
						round( a.FAX12TOT * round( a.FAX12TOT / a.FAX12TOTMF * c.FAX01FCAM ,2) ,2), 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#sPeriodo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#sMes#">,
						'D', 
						<cfqueryparam cfsqltype="cf_sql_char" value="#session.usulogin#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#res_GeneraAsiento#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				FROM FAX001 c
					inner join FAX012 a
						 on a.FAM01COD = c.FAM01COD
						and a.FAX01NTR = c.FAX01NTR
						and a.FAX12TIP = 'DP'
						inner join CuentasBancos b
							 on b.Bid = a.Bid
							and b.CBcodigo = a.FAX12CTA
				WHERE c.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
                	and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">ss
					and c.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>

			<!---poner transacciones como posteadas--->
			<cfquery datasource="#Arguments.conexion#">
				update FAX007
				set FAX07POS = 1
				from FAX001 t
				where t.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				  and t.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				  and t.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and FAX007.FAX01NTR = t.FAX01NTR
				  and FAX007.FAM01COD = t.FAM01COD
			</cfquery>

			<!----INSERTAR EN TABLA DE BITÁCORA DE CIERRES Y ACTUALIZAR TABLAS: FAX001, FAX015 Y FADepositosp----->			
			<cfquery name="rsEdocumento" datasource="#session.DSN#">
				select coalesce(Edocumento,0) as Edocumento, coalesce(Eperiodo,0) as Eperiodo, coalesce(Emes,0) as Emes
				from EContables
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#res_GeneraAsiento#">
			</cfquery>	

			
			<cfquery name="insertaBitacora" datasource="#session.DSN#">
				insert into FABitacoraCierreCaja (FAM01COD, 
												Ecodigo, 
												IDcontable, 
												Edocumento, 
												Eperiodo, 
												Emes, 
												Efecha, 
												FACierreCajaIP_Maquina, 
												BMUsucodigo, 
												BMfechaalta)
				values (<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#res_GeneraAsiento#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEdocumento.Edocumento#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEdocumento.Eperiodo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEdocumento.Emes#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFecha#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sitio.ip#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
				<cf_dbidentity1 datasource="#session.DSN#"> 				
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertaBitacora">
			
			<cfquery datasource="#session.DSN#">
				update FAX001
					set FACierreCajaId = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#insertaBitacora.identity#">,
						FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="C">	
				where FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				  and FAX01STA = 'T'
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<cfquery datasource="#session.DSN#">
				update FAX015
					set FAX15SCO = <cfqueryparam cfsqltype="cf_sql_char" value="C"> ,
						FACierreCajaId = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#insertaBitacora.identity#">
				where FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
					and FAX15SCO is null
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<cfquery datasource="#session.DSN#">
				update FADepositosp
					set FACierreCajaId =<cfqueryparam  cfsqltype="cf_sql_numeric" value="#insertaBitacora.identity#">
				where FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.caja#">
				  and FACierreCajaId is null
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>

			<!--- <!--- Arguments.debug FINAL--->
			<cfif Arguments.debug>
				<cfif showStruts>
				<cfquery name="rsdebug" datasource="#Arguments.conexion#">
					select * from dual
				</cfquery>
				<cfdump var="#rsdebug#" label="rsdebug">
				</cfif>
				<cftransaction action="rollback"/>
				<cf_abort errorInterfaz="">
			</cfif> --->
		</cftransaction>
		<cfset RESULT=true>
		<cfreturn RESULT>
	</cffunction>
</cfcomponent>


