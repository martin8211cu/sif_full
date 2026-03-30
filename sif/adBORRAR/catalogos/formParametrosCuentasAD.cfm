<!--- Variables para saber si hay que hacer un insert (0) o un update (1) en el .sql de cada uno de estos registros ---->
<cfset hayCuentaDescuentosCxC = 0 >
<cfset hayCuentaMovOficinas = 0 >
<cfset hayCuentaAjusteRedondeo = 0 >
<cfset hayCuentaIngresoDifCambCxC = 0 >
<cfset hayCuentaEgresoDifCambCxC = 0 >
<cfset hayCuentaIngresoDifCambCxP = 0 >
<cfset hayCuentaEgresoDifCambCxP = 0 >
<cfset hayCuentaRetenciones = 0 >
<cfset hayCuentaAnticiposCxC = 0 >
<cfset hayCuentaAnticiposCxP = 0 >
<cfset hayCuentaActivosTransito = 0 >
<cfset hayCuentaBalance = 0 >
<cfset hayCuentaIngresoDifCambCG = 0 >
<cfset hayCuentaEgresoDifCambCG = 0 >
<cfset hayCuentaUtilPeriodo = 0 >
<cfset hayCuentaUtilAcumulada = 0 >
<cfset hayCuentaCajaCxC = 0 >
<!--- PARAMETROS NUEVOS RELACIONADOS CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxC  --->
<cfset hayCuentaDepositosT = 0>
<!--- PARAMETROS NUEVOS RELACIONADOS CON TESORERIA  --->
<cfset hayCuentaTEF = 0>
<cfset hayCuentaMultas = 0>

<cfset hayMovOrigenBancos = 0 >
<cfset hayMovDestinoBancos = 0 >
<cfset hayTransPagosCC = 0 >
<cfset hayTransPagosCP = 0 >

<!---  PEAJE --->
<cfset hayCuentaIngresosDifP = 0 >
<cfset hayCuentaRemision = 0>

<!--- Obtiene los datos de la cuenta contable según el pcodigo (Ccuenta) --->
<cffunction name="ObtenerCuenta" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	

	<cfquery name="rsValor" datasource="#Session.DSN#">
		select Pvalor from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	
	<cfif isdefined("rsValor") and len(trim(rsValor.Pvalor))>
		<cfset LvarCcuenta = rsValor.Pvalor>
	<cfelse>
		<cfset LvarCcuenta = 0>
	</cfif>
	
	<cfquery name="rsCuenta" datasource="#Session.DSN#">
		select 
			c.Ccuenta as Ccuenta, 
			c.Cdescripcion as Cdescripcion, 
			c.Cformato as Cfformato
		from CContables c
		where c.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuenta#">
		  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
	</cfquery>
	<cfreturn #rsCuenta#>
</cffunction>

<!--- Obtiene los datos de la cuenta contable según el pcodigo (Ccuenta) --->
<cffunction name="ObtenerValor" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rsValor" datasource="#Session.DSN#">
		select Pvalor from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rsValor#>
</cffunction>

<cfquery name="rsTransaccionesOrigenBancos" datasource="#Session.DSN#">
	select BTid, BTdescripcion from BTransacciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and BTtipo = 'C'
</cfquery>

<cfquery name="rsTransaccionesDestinoBancos" datasource="#Session.DSN#">
	select BTid, BTdescripcion from BTransacciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and BTtipo = 'D'
</cfquery>

<cfquery name="rsTransaccionesCC" datasource="#Session.DSN#">
	select CCTcodigo, CCTdescripcion from CCTransacciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	  and CCTpago = 1
</cfquery>

<cfquery name="rsTransaccionesCP" datasource="#Session.DSN#">
	select CPTcodigo, CPTdescripcion from CPTransacciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
	  and CPTpago = 1
</cfquery>

<cfquery name="rsExistenCContables" datasource="#Session.DSN#">
	select min(Ccuenta) as Existe
	from CContables
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>	

<cfquery name="rsExistenTiposTransaccionCP" datasource="#Session.DSN#">
	select 1 as existe
	  from CPTransacciones 
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	   and CPTpago = 1
</cfquery>	

<cfquery name="rsExistenTiposTransaccionCC" datasource="#Session.DSN#">
	select 1 as existe
	  from CCTransacciones 
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	   and CCTpago = 1
</cfquery>	

<cfquery name="rsExistenTiposTransaccionBancos" datasource="#Session.DSN#">
	select 1 as existe
	  from BTransacciones 
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	having count (distinct BTtipo) = 2
</cfquery>

<!--- Verifica si existen Cuentas Contables definidas para esa empresa --->
<cfset existenCContables = false >
<cfif isdefined('rsExistenCContables') and len(trim(rsExistenCContables.Existe)) GT 0 and rsExistenCContables.Existe GT 0 >
	<cfset existenCContables = true >
</cfif>

<!--- Verifica si existen Tipos de Transacción en CxP definidas para esa empresa --->
<cfset existenTiposTransCP = false >
<cfif rsExistenTiposTransaccionCP.existe EQ "1" >
	<cfset existenTiposTransCP = true >
</cfif>

<!--- Verifica si existen Tipos de Transacción en CxC definidas para esa empresa --->
<cfset existenTiposTransCC = false >
<cfif rsExistenTiposTransaccionCC.existe EQ "1" >
	<cfset existenTiposTransCC = true >
</cfif>

<!--- Verifica si existen Tipos de Transacción (Crédito y Débito) en Bancos definidas para esa empresa --->
<cfset existenTiposTransMB = false >
<cfif rsExistenTiposTransaccionBancos.existe EQ "1" >
	<cfset existenTiposTransMB = true >
</cfif>

<cfset definidos = ObtenerValor(5)>
<cfset existenParametrosDefinidos = false >
<cfif definidos.RecordCount GT 0 >
	<cfif definidos.Pvalor NEQ "N" >
		<cfset existenParametrosDefinidos = true >
	</cfif>
</cfif>

<form action="SQLParametrosCuentasAD.cfm" method="post" name="form1">
	
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <cfset cuenta = ObtenerCuenta(70)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaDescuentosCxC = 1 >
      </cfif>
      <td><div align="right">Cuenta de Descuentos Documento CxC:</div></td>
      <td>
	  	  <cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="N" frame="frame6" ccuenta="CcuentaDescuentosCxC" cdescripcion="CdescripcionDescuentosCxC" cformato="CformatoDescuentosCxC">
	  </td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(80)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaDescuentosCxP = 1 >
      </cfif>
      <td><div align="right">Cuenta de Descuentos Documento CxP:</div></td>
      <td> N/A <input type="hidden" name="CdescripcionDescuentosCxP"/></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(90)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaMovOficinas = 1 >
      </cfif>
      <td><div align="right">Cuenta Contable de Movimiento entre Oficinas:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame8" ccuenta="CcuentaMovOficinas" cdescripcion="CdescripcionMovOficinas" cformato="CformatoMovOficinas"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(100)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaAjusteRedondeo = 1 >
      </cfif>
      <td><div align="right">Cuenta de Ajuste por Redondeo de Monedas:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame9" ccuenta="CcuentaAjusteRedondeo" cdescripcion="CdescripcionAjusteRedondeo" cformato="CformatoAjusteRedondeo"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(110)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaIngresoDifCambCxC = 1 >
      </cfif>
      <td><div align="right">Cuenta de Ingreso por Dif. Camb. CxC:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame10" ccuenta="CcuentaIngresoDifCambCxC" cdescripcion="CdescripcionIngresoDifCambCxC" cformato="CformatoIngresoDifCambCxC"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(120)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaEgresoDifCambCxC = 1 >
      </cfif>
      <td><div align="right">Cuenta de Egreso por Dif. Camb. CxC:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame11" ccuenta="CcuentaEgresoDifCambCxC" cdescripcion="CdescripcionEgresoDifCambCxC" cformato="CformatoEgresoDifCambCxC"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(130)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaIngresoDifCambCxP = 1 >
      </cfif>
      <td><div align="right">Cuenta de Ingreso por Dif. Camb. CxP:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame12" ccuenta="CcuentaIngresoDifCambCxP" cdescripcion="CdescripcionIngresoDifCambCxP" cformato="CformatoIngresoDifCambCxP"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(140)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaEgresoDifCambCxP = 1 >
      </cfif>
      <td><div align="right">Cuenta de Egreso por Dif. Camb. CxP:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame13" ccuenta="CcuentaEgresoDifCambCxP" cdescripcion="CdescripcionEgresoDifCambCxP" cformato="CformatoEgresoDifCambCxP"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(150)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaRetenciones = 1 >
      </cfif>
      <td><div align="right">Cuenta Contable de Retenciones:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame14" ccuenta="CcuentaRetenciones" cdescripcion="CdescripcionRetenciones" cformato="CformatoRetenciones"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(151)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaMultas = 1 >
      </cfif>
      <td><div align="right">Cuenta Contable para Multas:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame14" ccuenta="CcuentaMultas" cdescripcion="CdescripcionMultas" cformato="CformatoMultas"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(180)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaAnticiposCxC = 1 >
      </cfif>
      <td><div align="right">Cuenta de Anticipos CxC:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame15" ccuenta="CcuentaAnticiposCxC" cdescripcion="CdescripcionAnticiposCxC" cformato="CformatoAnticiposCxC"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(190)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaAnticiposCxP = 1 >
      </cfif>
      <td><div align="right">Cuenta de Anticipos CxP:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame16" ccuenta="CcuentaAnticiposCxP" cdescripcion="CdescripcionAnticiposCxP" cformato="CformatoAnticiposCxP"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(240)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaActivosTransito = 1 >
      </cfif>
      <td><div align="right">Cuenta de Activos en Tránsito:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame17" ccuenta="CcuentaActivosTransito" cdescripcion="CdescripcionActivosTransito" cformato="CformatoActivosTransito"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(200)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaBalance = 1 >
      </cfif>
      <td><div align="right">Cuenta de Balance Multimoneda:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame1" ccuenta="CcuentaBalance" cdescripcion="CdescripcionBalance" cformato="CformatoBalance"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(260)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaIngresoDifCambCG = 1 >
      </cfif>
      <td><div align="right">Cuenta de Ingreso por Diferencial Cambiario:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame2" ccuenta="CcuentaIngresoDifCambCG" cdescripcion="CdescripcionIngresoDifCambCG" cformato="CformatoIngresoDifCambCG"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(270)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaEgresoDifCambCG = 1 >
      </cfif>
      <td><div align="right">Cuenta de Egreso por Diferencial Cambiario:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame3" ccuenta="CcuentaEgresoDifCambCG" cdescripcion="CdescripcionEgresoDifCambCG" cformato="CformatoEgresoDifCambCG"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(290)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaUtilPeriodo = 1 >
      </cfif>
      <td><div align="right">Cuenta de Utilidad del Periodo:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame4" ccuenta="CcuentaUtilPeriodo" cdescripcion="CdescripcionUtilPeriodo" cformato="CformatoUtilPeriodo"></td>
    </tr>
    <tr> 
      <cfset cuenta = ObtenerCuenta(300)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaUtilAcumulada = 1 >
      </cfif>
      <td><div align="right">Cuenta de Utilidad Acumulada:</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame5" ccuenta="CcuentaUtilAcumulada" cdescripcion="CdescripcionUtilAcumulada" cformato="CformatoUtilAcumulada"></td>
    </tr>
	<tr>
		<cfset cuenta = ObtenerCuenta(350)>
		<cfif cuenta.RecordCount GT 0 >
			<cfset hayCuentaCajaCxC = 1 >
		</cfif>	
		<td><div align="right">Cuenta de Caja CxC:</div></td>
		<td>
			<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame18" 
				ccuenta="CcuentaCajaCxC" cdescripcion="CdescripcionCajaCxC" cformato="CformatoCajaCxC">
		</td>
	</tr>
	<!--- PARAMETROS NUEVOS RELACIONADOS CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxC  --->
	<!--- CUENTA CONTABLE DE DEPOSITOS EN TRANSITO 
		VERIFICAR LOS PARAMETROS PARA EL TAG CUENTAS AUXILIARES, MOVIMIENTOS
	--->
	<tr>
		<cfset cuenta = ObtenerCuenta(650)>
		<cfif cuenta.RecordCount GT 0 >
			<cfset hayCuentaDepositosT = 1 >
		</cfif>	
		<td><div align="right">Cuenta de Dep&oacute;sitos en tr&aacute;nsito:</div></td>
		<td>
			<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame19" 
				ccuenta="CDepositosT" cdescripcion="CdescripcionDepositosT" cformato="CformatoDepositosT">
		</td>
	</tr>
	
		<!--- PARAMETROS PEAJE  --->
	<tr>
		<cfset cuenta = ObtenerCuenta(1850)>
		<cfif cuenta.RecordCount GT 0 >
			<cfset hayCuentaIngresosDifP = 1 >
		</cfif>	
		<td><div align="right">Cuenta de Ingresos Diferidos  por Peaje:</div></td>
		<td>
			<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame20" 
				ccuenta="CIngresosDifP" cdescripcion="CdescripcionIngresosDifP" cformato="CformatoIngresosDifP">
		</td>

	<tr>
		<cfset cuenta = ObtenerCuenta(1700)>
		<cfif cuenta.RecordCount GT 0 >
			<cfset hayCuentaTEF = 1 >
		</cfif>	
		<td><div align="right">Cuenta Transitoria para TEF con única confirmación:</div></td>
		<td>
			<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame19" 
				ccuenta="CuentaTEF" cdescripcion="CdescripcionCuentaTEF" cformato="CformatoCuentaTEF">
		</td>
	</tr>

    <tr> 
      <cfset valor = ObtenerValor(160)>
      <cfif valor.RecordCount GT 0 >
        <cfset hayMovOrigenBancos = 1 >
      </cfif>	
      <td><div align="right">Tipo de Movimiento Orígen de Bancos:</div></td>
      <td><select name="MovOrigenBancos">
          <cfoutput query="rsTransaccionesOrigenBancos"> 
            <option value="#rsTransaccionesOrigenBancos.BTid#" <cfif rsTransaccionesOrigenBancos.BTid EQ "22">selected</cfif>>#rsTransaccionesOrigenBancos.BTdescripcion#</option>
          </cfoutput>	  	  
	  </select></td>
    </tr>
	
		
	
	
    <tr>
      <cfset valor = ObtenerValor(170)>
      <cfif valor.RecordCount GT 0 >
        <cfset hayMovDestinoBancos = 1 >
      </cfif>		 
      <td><div align="right">Tipo de Movimiento Destino de Bancos:</div></td>
      <td><select name="MovDestinoBancos">
          <cfoutput query="rsTransaccionesDestinoBancos"> 
            <option value="#rsTransaccionesDestinoBancos.BTid#" <cfif rsTransaccionesDestinoBancos.BTid EQ "23">selected</cfif>>#rsTransaccionesDestinoBancos.BTdescripcion#</option>
          </cfoutput>	  	  
	  </select></td>
    </tr>
    <tr> 
      <cfset valor = ObtenerValor(210)>
      <cfif valor.RecordCount GT 0 >
        <cfset hayTransPagosCC = 1 >
      </cfif>		 	
      <td><div align="right">Transacci&oacute;n de Pagos de CxC:</div></td>
      <td><select name="TransPagosCC">
          <cfoutput query="rsTransaccionesCC"> 
            <option value="#rsTransaccionesCC.CCTcodigo#" <cfif rsTransaccionesCC.CCTcodigo EQ "RE">selected</cfif>>#rsTransaccionesCC.CCTdescripcion#</option>
          </cfoutput>	  
	  </select></td>
    </tr>
    <tr> 
      <cfset valor = ObtenerValor(220)>
      <cfif valor.RecordCount GT 0 >
        <cfset hayTransPagosCP = 1 >
      </cfif>		 		
      <td><div align="right">Transacci&oacute;n de Pagos de CxP:</div></td>
      <td><select name="TransPagosCP">
          <cfoutput query="rsTransaccionesCP"> 
            <option value="#rsTransaccionesCP.CPTcodigo#" <cfif rsTransaccionesCP.CPTcodigo EQ "RE">selected</cfif>>#rsTransaccionesCP.CPTdescripcion#</option>
          </cfoutput>	  
	  </select></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    
    <tr> 
      <cfset cuenta = ObtenerCuenta(1710)>
      <cfif cuenta.RecordCount GT 0 >
        <cfset hayCuentaRemision = 1 >
      </cfif>
      <td><div align="right">Cuenta Pendientes de Factura (Remisión):</div></td>
      <td><cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#cuenta#" auxiliares="N" movimiento="S" frame="frame20" ccuenta="CcuentaRemision" cdescripcion="CdescripcionCuentaRemision" cformato="CformatoCuentaRemision"></td>
    </tr>
    
    <tr> 
      <td colspan="2"><div align="center"> 
          <input type="submit" name="Aceptar" value="Aceptar" onClick="javascript: return valida();">
        </div></td>
    </tr>
	
	<tr><td>&nbsp;</td></tr>
	
  </table>

	<cfoutput>
	<input type="hidden" name="hayCuentaDescuentosCxC" value="#hayCuentaDescuentosCxC#">
	<input type="hidden" name="hayCuentaMovOficinas" value="#hayCuentaMovOficinas#">
	<input type="hidden" name="hayCuentaAjusteRedondeo" value="#hayCuentaAjusteRedondeo#">
	<input type="hidden" name="hayCuentaIngresoDifCambCxC" value="#hayCuentaIngresoDifCambCxC#">
	<input type="hidden" name="hayCuentaEgresoDifCambCxC" value="#hayCuentaEgresoDifCambCxC#">
	<input type="hidden" name="hayCuentaIngresoDifCambCxP" value="#hayCuentaIngresoDifCambCxP#">
	<input type="hidden" name="hayCuentaEgresoDifCambCxP" value="#hayCuentaEgresoDifCambCxP#">
	<input type="hidden" name="hayCuentaRetenciones" value="#hayCuentaRetenciones#">
	<input type="hidden" name="hayCuentaAnticiposCxC" value="#hayCuentaAnticiposCxC#">
	<input type="hidden" name="hayCuentaAnticiposCxP" value="#hayCuentaAnticiposCxP#">
	<input type="hidden" name="hayCuentaActivosTransito" value="#hayCuentaActivosTransito#">
	<input type="hidden" name="hayCuentaBalance" value="#hayCuentaBalance#">
	<input type="hidden" name="hayCuentaIngresoDifCambCG" value="#hayCuentaIngresoDifCambCG#">
	<input type="hidden" name="hayCuentaEgresoDifCambCG" value="#hayCuentaEgresoDifCambCG#">
	<input type="hidden" name="hayCuentaUtilPeriodo" value="#hayCuentaUtilPeriodo#">
	<input type="hidden" name="hayCuentaUtilAcumulada" value="#hayCuentaUtilAcumulada#">
	<input type="hidden" name="hayCuentaCajaCxC" value="#hayCuentaCajaCxC#">
	<!--- PARAMETROS NUEVOS RELACIONADOS CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxC  --->
	<input type="hidden" name="hayCuentaDepositosT" value="#hayCuentaDepositosT#">	
	<input type="hidden" name="hayCuentaTEF" value="#hayCuentaTEF#">	
	<input type="hidden" name="hayCuentaMultas" value="#hayCuentaMultas#">
	
	<input type="hidden" name="hayMovOrigenBancos" value="#hayMovOrigenBancos#">
	<input type="hidden" name="hayMovDestinoBancos" value="#hayMovDestinoBancos#">
	<input type="hidden" name="hayTransPagosCC" value="#hayTransPagosCC#">
	<input type="hidden" name="hayTransPagosCP" value="#hayTransPagosCP#">
	
	<!--- PEAJE  --->
	<input type="hidden" name="hayCuentaIngresosDifP" value="#hayCuentaIngresosDifP#">

    <input type="hidden" name="hayCuentaRemision" value="#hayCuentaRemision#">
	</cfoutput>
</form>
<script language="JavaScript1.2">
	function valida() {
		<cfif existenParametrosDefinidos and existenCContables and existenTiposTransCP and existenTiposTransCC and existenTiposTransMB>
		document.form1.CdescripcionDescuentosCxC.disabled = false;
		if (document.form1.CdescripcionDescuentosCxC.value == '') {
			document.form1.CdescripcionDescuentosCxC.disabled = true;
			alert("Debe digitar una cuenta de descuentos de CxC");
			document.form1.CformatoDescuentosCxC.select();
			return false;
		}
		
		/*document.form1.CdescripcionDescuentosCxP.disabled = false;
		if (document.form1.CdescripcionDescuentosCxP.value == '') {
			document.form1.CdescripcionDescuentosCxP.disabled = true;
			alert("Debe digitar una cuenta de descuentos de CxP");
			document.form1.CformatoDescuentosCxP.select();
			return false;
		}*/
		
		document.form1.CdescripcionMovOficinas.disabled = false;
		if (document.form1.CdescripcionMovOficinas.value == '') {
			document.form1.CdescripcionMovOficinas.disabled = true;
			alert("Debe digitar una cuenta de movimientos entre oficinas");
			document.form1.CformatoMovOficinas.select();
			return false;
		}
				
		document.form1.CdescripcionAjusteRedondeo.disabled = false;
		if (document.form1.CdescripcionAjusteRedondeo.value == '') {
			document.form1.CdescripcionAjusteRedondeo.disabled = true;
			alert("Debe digitar una cuenta de ajuste por redondeo de monedas");
			document.form1.CformatoAjusteRedondeo.select();
			return false;
		}
		
		document.form1.CdescripcionIngresoDifCambCxC.disabled = false;
		if (document.form1.CdescripcionIngresoDifCambCxC.value == '') {
			document.form1.CdescripcionIngresoDifCambCxC.disabled = true;
			alert("Debe digitar una cuenta de ingreso por diferencial cambiario de CxC");
			document.form1.CformatoIngresoDifCambCxC.select();
			return false;
		}

		document.form1.CdescripcionEgresoDifCambCxC.disabled = false;
		if (document.form1.CdescripcionEgresoDifCambCxC.value == '') {
			document.form1.CdescripcionEgresoDifCambCxC.disabled = true;
			alert("Debe digitar una cuenta de egreso por diferencial cambiario de CxC");
			document.form1.CformatoEgresoDifCambCxC.select();
			return false;
		}
		
		document.form1.CdescripcionIngresoDifCambCxP.disabled = false;
		if (document.form1.CdescripcionIngresoDifCambCxP.value == '') {
			document.form1.CdescripcionIngresoDifCambCxP.disabled = true;
			alert("Debe digitar una cuenta de ingreso por diferencial cambiario de CxP");
			document.form1.CformatoIngresoDifCambCxP.select();
			return false;
		}

		document.form1.CdescripcionEgresoDifCambCxP.disabled = false;
		if (document.form1.CdescripcionEgresoDifCambCxP.value == '') {
			document.form1.CdescripcionEgresoDifCambCxP.disabled = true;
			alert("Debe digitar una cuenta de egreso por diferencial cambiario de CxP");
			document.form1.CformatoEgresoDifCambCxP.select();
			return false;
		}
			
		document.form1.CdescripcionRetenciones.disabled = false;
		if (document.form1.CdescripcionRetenciones.value == '') {
			document.form1.CdescripcionRetenciones.disabled = true;
			alert("Debe digitar una cuenta de retenciones");
			document.form1.CformatoRetenciones.select();
			return false;
		}
			
		document.form1.CdescripcionAnticiposCxC.disabled = false;
		if (document.form1.CdescripcionAnticiposCxC.value == '') {
			document.form1.CdescripcionAnticiposCxC.disabled = true;
			alert("Debe digitar una cuenta de anticipos de CxC");
			document.form1.CformatoAnticiposCxC.select();
			return false;
		}
			
		document.form1.CdescripcionAnticiposCxP.disabled = false;
		if (document.form1.CdescripcionAnticiposCxP.value == '') {
			document.form1.CdescripcionAnticiposCxP.disabled = true;
			alert("Debe digitar una cuenta de anticipos de CxP");
			document.form1.CformatoAnticiposCxP.select();
			return false;
		}
		
		document.form1.CdescripcionActivosTransito.disabled = false;
		if (document.form1.CdescripcionActivosTransito.value == '') {
			document.form1.CdescripcionActivosTransito.disabled = true;
			alert("Debe digitar una cuenta de activos en tránsito");
			document.form1.CformatoActivosTransito.select();
			return false;
		}
			
		document.form1.CdescripcionBalance.disabled = false;
		if (document.form1.CdescripcionBalance.value == '') {
			document.form1.CdescripcionBalance.disabled = true;
			alert("Debe digitar una cuenta de balance multimoneda");
			document.form1.CformatoBalance.select();
			return false;
		}

		document.form1.CdescripcionIngresoDifCambCG.disabled = false;
		if (document.form1.CdescripcionIngresoDifCambCG.value == '') {
			document.form1.CdescripcionIngresoDifCambCG.disabled = true;
			alert("Debe digitar una cuenta de ingreso por diferencial cambiario");
			document.form1.CformatoIngresoDifCambCG.select();
			return false;
		}
		
		document.form1.CdescripcionEgresoDifCambCG.disabled = false;
		if (document.form1.CdescripcionEgresoDifCambCG.value == '') {
			document.form1.CdescripcionEgresoDifCambCG.disabled = true;
			alert("Debe digitar una cuenta de egreso por diferencial cambiario");
			document.form1.CformatoEgresoDifCambCG.select();
			return false;
		}
		
		document.form1.CdescripcionUtilPeriodo.disabled = false;
		if (document.form1.CdescripcionUtilPeriodo.value == '') {
			document.form1.CdescripcionUtilPeriodo.disabled = true;
			alert("Debe digitar una cuenta de utilidad del periodo");
			document.form1.CformatoUtilPeriodo.disabled = true;
			return false;
		}
		
		document.form1.CdescripcionUtilAcumulada.disabled = false;
		if (document.form1.CdescripcionUtilAcumulada.value == '') {
			document.form1.CdescripcionUtilAcumulada.disabled = true;
			alert("Debe digitar una cuenta de utilidad acumulada");
			document.form1.CformatoUtilAcumulada.disabled = true;
			return false;
		}

		document.form1.CdescripcionCajaCxC.disabled = false;
		if (document.form1.CdescripcionCajaCxC.value == '') {
			document.form1.CdescripcionCajaCxC.disabled = true;
			alert("Debe digitar una cuenta de caja de CxC");
			document.form1.CformatoCajaCxC.disabled = true;
			return false;
		}
		<!--- PARAMETROS NUEVOS RELACIONADOS CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxC  --->
		document.form1.CdescripcionDepositosT.disabled = false;
		if (document.form1.CdescripcionDepositosT.value == '') {
			document.form1.CdescripcionDepositosT.disabled = true;
			alert("Debe digitar una cuenta de Depósitos de Tránsito");
			document.form1.CformatoDepositosT.disabled = true;
			return false;
		}
		
		if (document.form1.MovOrigenBancos.value == '') {
			alert('Debe seleccionar un tipo de movimiento orígen para Bancos');
			document.form1.MovOrigenBancos.focus();
			return false;
		}

		if (document.form1.MovDestinoBancos.value == '') {
			alert('Debe seleccionar un tipo de movimiento destino para Bancos');
			document.form1.MovDestinoBancos.focus();
			return false;
		}

		if (document.form1.TransPagosCC.value == '') {
			alert('Debe seleccionar un tipo de transacción para CxC');
			document.form1.TransPagosCC.focus();
			return false;
		}

		if (document.form1.TransPagosCP.value == '') {
			alert('Debe seleccionar un tipo de transacción para CxP');
			document.form1.TransPagosCP.focus();
			return false;
		}
		
		

		document.form1.CdescripcionCuentaRemision.disabled = false;
		if (document.form1.CdescripcionCuentaRemision.value == '') {
			document.form1.CdescripcionCuentaRemision.disabled = true;
			alert("Debe digitar una Cuenta de Pendientes de Factura");
			document.form1.CformatoCuentaRemision.disabled = true;
			return false;
		}
		<cfelse>
			<cfif not existenParametrosDefinidos >
				alert('¡No están definidos los parámetros generales!');				
			<cfelseif not existenCContables>
				alert('¡No están definidas las cuentas contables!');							
			<cfelseif not existenTiposTransCP>
				alert('¡No están definidas los tipos de transacción de CxP!');							
			<cfelseif not existenTiposTransCC>
				alert('¡No están definidas los tipos de transacción de CxC!');							
			<cfelseif not existenTiposTransMB>
				alert('¡No están definidas los tipos de transacción de Bancos!');							
			</cfif>
			return false;
		</cfif>		
		return confirm('Desea modificar los parámetros?');		
	}
</script>


