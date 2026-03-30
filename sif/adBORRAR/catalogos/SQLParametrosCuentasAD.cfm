<cfif isDefined("Form.Aceptar")>
	<!--- Inserta un registro en la tabla de Parámetros --->
	<cffunction name="insertCuenta" >		
		<cfargument name="pcodigo" type="numeric" required="true">
		<cfargument name="mcodigo" type="string" required="true">
		<cfargument name="pdescripcion" type="string" required="true">
		<cfargument name="pvalor" type="string" required="true">			
		<cfquery name="insCuenta" datasource="#Session.DSN#">
			select count(1) as cantidad
			from Parametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		</cfquery>
		<cfif insCuenta.cantidad EQ 0>
			<cfquery name="insCuenta" datasource="#Session.DSN#">
				insert into Parametros 
					(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
					)
			</cfquery>
		<cfelse>
			<cfquery name="insCuenta" datasource="#Session.DSN#">
				update Parametros 
				   set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#">
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
			</cfquery>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<!--- Actualiza la cuenta contable según el pcodigo --->
	<cffunction name="updateCuenta" >					
		<cfargument name="pcodigo" type="numeric" required="true">
		<cfargument name="pvalor" type="string" required="true">			
		<cfquery name="updCuenta" datasource="#Session.DSN#">
			update Parametros 
			   set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			   and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cftransaction>
	<cftry>		
		<cfif isDefined("Form.hayCuentaDescuentosCxC") and Len(Trim(hayCuentaDescuentosCxC)) GT 0>
			<cfif Form.hayCuentaDescuentosCxC EQ "1">
				<cfset a = updateCuenta(70,Form.CcuentaDescuentosCxC)>
			<cfelseif Form.hayCuentaDescuentosCxC EQ "0">
				<cfset b = insertCuenta(70,'CC','Cuenta Descuentos CxC',Form.CcuentaDescuentosCxC)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaMovOficinas") and Len(Trim(hayCuentaMovOficinas)) GT 0>
			<cfif Form.hayCuentaMovOficinas EQ "1">
				<cfset a = updateCuenta(90,Form.CcuentaMovOficinas)>
			<cfelseif Form.hayCuentaMovOficinas EQ "0">
				<cfset b = insertCuenta(90,'GN','Cuenta Contable Mov. entre Oficinas',Form.CcuentaMovOficinas)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaAjusteRedondeo") and Len(Trim(hayCuentaAjusteRedondeo)) GT 0>
			<cfif Form.hayCuentaAjusteRedondeo EQ "1">
				<cfset a = updateCuenta(100,Form.CcuentaAjusteRedondeo)>
			<cfelseif Form.hayCuentaAjusteRedondeo EQ "0">
				<cfset b = insertCuenta(100,'GN','Cuenta de Ajuste por Redondeo de Monedas',Form.CcuentaAjusteRedondeo)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaIngresoDifCambCxC") and Len(Trim(hayCuentaIngresoDifCambCxC)) GT 0>
			<cfif Form.hayCuentaIngresoDifCambCxC EQ "1">
				<cfset a = updateCuenta(110,Form.CcuentaIngresoDifCambCxC)>
			<cfelseif Form.hayCuentaIngresoDifCambCxC EQ "0">
				<cfset b = insertCuenta(110,'CC','Cuenta de Ingreso por Dif. Camb. CxC',Form.CcuentaIngresoDifCambCxC)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaEgresoDifCambCxC") and Len(Trim(hayCuentaEgresoDifCambCxC)) GT 0>
			<cfif Form.hayCuentaEgresoDifCambCxC EQ "1">
				<cfset a = updateCuenta(120,Form.CcuentaEgresoDifCambCxC)>
			<cfelseif Form.hayCuentaEgresoDifCambCxC EQ "0">
				<cfset b = insertCuenta(120,'CC','Cuenta de Egreso por Dif. Camb. CxC',Form.CcuentaEgresoDifCambCxC)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaIngresoDifCambCxP") and Len(Trim(hayCuentaIngresoDifCambCxP)) GT 0>
			<cfif Form.hayCuentaIngresoDifCambCxP EQ "1">
				<cfset a = updateCuenta(130,Form.CcuentaIngresoDifCambCxP)>
			<cfelseif Form.hayCuentaIngresoDifCambCxP EQ "0">
				<cfset b = insertCuenta(130,'CP','Cuenta de Ingreso por Dif. Camb. CxP',Form.CcuentaIngresoDifCambCxP)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaEgresoDifCambCxP") and Len(Trim(hayCuentaEgresoDifCambCxP)) GT 0>
			<cfif Form.hayCuentaEgresoDifCambCxP EQ "1">
				<cfset a = updateCuenta(140,Form.CcuentaEgresoDifCambCxP)>
			<cfelseif Form.hayCuentaEgresoDifCambCxP EQ "0">
				<cfset b = insertCuenta(140,'CP','Cuenta de Egreso por Dif. Camb. CxP',Form.CcuentaEgresoDifCambCxP)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaRetenciones") and Len(Trim(hayCuentaRetenciones)) GT 0>
			<cfif Form.hayCuentaRetenciones EQ "1">
				<cfset a = updateCuenta(150,Form.CcuentaRetenciones)>
			<cfelseif Form.hayCuentaRetenciones EQ "0">
				<cfset b = insertCuenta(150,'GN','Cuenta Contable de Retenciones',Form.CcuentaRetenciones)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaAnticiposCxC") and Len(Trim(hayCuentaAnticiposCxC)) GT 0>
			<cfif Form.hayCuentaAnticiposCxC EQ "1">
				<cfset a = updateCuenta(180,Form.CcuentaAnticiposCxC)>
			<cfelseif Form.hayCuentaAnticiposCxC EQ "0">
				<cfset b = insertCuenta(180,'CC','Cuenta de Anticipos CxC',Form.CcuentaAnticiposCxC)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaAnticiposCxP") and Len(Trim(hayCuentaAnticiposCxP)) GT 0>
			<cfif Form.hayCuentaAnticiposCxP EQ "1">
				<cfset a = updateCuenta(190,Form.CcuentaAnticiposCxP)>
			<cfelseif Form.hayCuentaAnticiposCxP EQ "0">
				<cfset b = insertCuenta(190,'CP','Cuenta de Anticipos CxP',Form.CcuentaAnticiposCxP)>
			</cfif>
		</cfif>
		
		<cfif isDefined("Form.hayCuentaMultas") and Len(Trim(hayCuentaMultas)) GT 0>
			<cfif Form.hayCuentaMultas EQ "1">
				<cfset a = updateCuenta(151,Form.hayCuentaMultas)>
			<cfelseif Form.hayCuentaMultas EQ "0">
				<cfset b = insertCuenta(151,'GN','Cuenta financiera de multas',Form.CcuentaMultas)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaActivosTransito") and Len(Trim(hayCuentaActivosTransito)) GT 0>
			<cfif Form.hayCuentaActivosTransito EQ "1">
				<cfset a = updateCuenta(240,Form.CcuentaActivosTransito)>
			<cfelseif Form.hayCuentaActivosTransito EQ "0">
				<cfset b = insertCuenta(240,'AF','Cuenta de Activos en Tránsito',Form.CcuentaActivosTransito)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaBalance") and Len(Trim(hayCuentaBalance)) GT 0>
			<cfif Form.hayCuentaBalance EQ "1">
				<cfset a = updateCuenta(200,Form.CcuentaBalance)>
			<cfelseif Form.hayCuentaBalance EQ "0">
				<cfset b = insertCuenta(200,'CG','Cuenta Balance Multimoneda',Form.CcuentaBalance)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaIngresoDifCambCG") and Len(Trim(hayCuentaIngresoDifCambCG)) GT 0>
			<cfif Form.hayCuentaIngresoDifCambCG EQ "1">
				<cfset a = updateCuenta(260,Form.CcuentaIngresoDifCambCG)>
			<cfelseif Form.hayCuentaIngresoDifCambCG EQ "0">
				<cfset b = insertCuenta(260,'CG','Cuenta de Ingreso por Dif. Camb. CG',Form.CcuentaIngresoDifCambCG)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaEgresoDifCambCG") and Len(Trim(hayCuentaEgresoDifCambCG)) GT 0>
			<cfif Form.hayCuentaEgresoDifCambCG EQ "1">
				<cfset a = updateCuenta(270,Form.CcuentaEgresoDifCambCG)>
			<cfelseif Form.hayCuentaEgresoDifCambCG EQ "0">
				<cfset b = insertCuenta(270,'CG','Cuenta de Egreso por Dif. Camb. CG',Form.CcuentaEgresoDifCambCG)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaUtilPeriodo") and Len(Trim(hayCuentaUtilPeriodo)) GT 0>
			<cfif Form.hayCuentaUtilPeriodo EQ "1">
				<cfset a = updateCuenta(290,Form.CcuentaUtilPeriodo)>
			<cfelseif Form.hayCuentaUtilPeriodo EQ "0">
				<cfset b = insertCuenta(290,'CG','Cuenta de Utilidad del Periodo',Form.CcuentaUtilPeriodo)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaUtilAcumulada") and Len(Trim(hayCuentaUtilAcumulada)) GT 0>
			<cfif Form.hayCuentaUtilAcumulada EQ "1">
				<cfset a = updateCuenta(300,Form.CcuentaUtilAcumulada)>
			<cfelseif Form.hayCuentaUtilAcumulada EQ "0">
				<cfset b = insertCuenta(300,'CG','Cuenta de Utilidad Acumulada',Form.CcuentaUtilAcumulada)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayCuentaCajaCxC") and Len(Trim(hayCuentaCajaCxC)) GT 0>
			<cfif Form.hayCuentaCajaCxC EQ "1">
				<cfset a = updateCuenta(350,Form.CcuentaCajaCxC)>
			<cfelseif Form.hayCuentaCajaCxC EQ "0">
				<cfset b = insertCuenta(350,'CG','Cuenta de Caja CxC',Form.CcuentaCajaCxC)>
			</cfif>
		</cfif>
		<!--- PARAMETROS NUEVOS RELACIONADOS CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxC  --->
		<cfif isDefined("Form.hayCuentaDepositosT") and Len(Trim(hayCuentaDepositosT)) GT 0>
			<cfif Form.hayCuentaDepositosT EQ "1">
				<cfset a = updateCuenta(650,Form.CDepositosT)>
			<cfelseif Form.hayCuentaDepositosT EQ "0">
				<cfset b = insertCuenta(650,'CC','Cuenta de Depósitos en Tránsito',Form.CDepositosT)>
			</cfif>
		</cfif>			

		<cfif isDefined("Form.hayCuentaTEF") and Len(Trim(hayCuentaTEF)) GT 0>
			<cfif Form.hayCuentaTEF EQ "1">
				<cfset a = updateCuenta(1700,Form.CuentaTEF)>
			<cfelseif Form.hayCuentaTEF EQ "0">
				<cfset b = insertCuenta(1700,'TE','Cuenta Transitoria para TEF con una confirmación',Form.CuentaTEF)>
			</cfif>
		</cfif>			

		<cfif isDefined("Form.hayCuentaMultas") and Len(Trim(hayCuentaMultas)) GT 0>
			<cfif Form.hayCuentaMultas EQ "1">
				<cfset a = updateCuenta(151,Form.CcuentaMultas)>
			<cfelseif Form.hayCuentaMultas EQ "0">
				<cfset b = insertCuenta(151,'GN','Cuenta Contable para Multas',Form.CcuentaMultas)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayMovOrigenBancos") and Len(Trim(hayMovOrigenBancos)) GT 0>
			<cfif Form.hayMovOrigenBancos EQ "1">
				<cfset a = updateCuenta(22,Form.MovOrigenBancos)>
			<cfelseif Form.hayMovOrigenBancos EQ "0">
				<cfset b = insertCuenta(22,'MB','Tipo de Mov. Origen Transferencias Bancarias',Form.MovOrigenBancos)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayMovDestinoBancos") and Len(Trim(hayMovDestinoBancos)) GT 0>
			<cfif Form.hayMovDestinoBancos EQ "1">
				<cfset a = updateCuenta(23,Form.MovDestinoBancos)>
			<cfelseif Form.hayMovDestinoBancos EQ "0">
				<cfset b = insertCuenta(23,'MB','Tipo de Mov. Destino Transferencias Bancarias',Form.MovDestinoBancos)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayTransPagosCC") and Len(Trim(hayTransPagosCC)) GT 0>
			<cfif Form.hayTransPagosCC EQ "1">
				<cfset a = updateCuenta(210,Form.TransPagosCC)>
			<cfelseif Form.hayTransPagosCC EQ "0">
				<cfset b = insertCuenta(210,'CC','Transacción de Pagos CxC',Form.TransPagosCC)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayTransPagosCP") and Len(Trim(hayTransPagosCP)) GT 0>
			<cfif Form.hayTransPagosCP EQ "1">
				<cfset a = updateCuenta(220,Form.TransPagosCP)>
			<cfelseif Form.hayTransPagosCP EQ "0">
				<cfset b = insertCuenta(220,'CP','Transacción de Pagos CxP',Form.TransPagosCP)>
			</cfif>
		</cfif>
		
		<cfif isDefined("Form.hayCuentaIngresosDifP") and Len(Trim(hayCuentaIngresosDifP)) GT 0>
			<cfif Form.hayCuentaIngresosDifP EQ "1">
				<cfset a = updateCuenta(1850,Form.CIngresosDifP)>
			<cfelseif Form.hayCuentaIngresosDifP EQ "0">
				<cfset b = insertCuenta(1850,'CG','Cuenta de Ingresos Diferidos  por Peaje',Form.CIngresosDifP)>
			</cfif>
		</cfif>
        
        <cfif isDefined("Form.hayCuentaRemision") and Len(Trim(hayCuentaRemision)) GT 0>
			<cfif Form.hayCuentaRemision EQ "1">
				<cfset a = updateCuenta(1710,Form.CcuentaRemision)>
			<cfelseif Form.hayCuentaRemision EQ "0">
				<cfset b = insertCuenta(1710,'CP','Cuenta Pendientes de Factura (Remisión)',Form.CcuentaRemision)>
			</cfif>
		</cfif>
        
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>
<form action="ParametrosCuentasAD.cfm" method="post" name="sql">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>



