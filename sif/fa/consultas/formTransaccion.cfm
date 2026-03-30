	<cf_templatecss>
	<cfparam name="Form.ETnumero" default="">
	<cfparam name="Form.FCid" default="">
	
	<!--- parametros por url, cuando se quiere imprimir  --->	
	<cfif isdefined("Url.ETnumero") and Len(Trim(Url.ETnumero)) GT 0
	  and isdefined("Url.FCid") and Len(Trim(Url.FCid)) GT 0 >
		<cfset Form.ETnumero = Trim(Url.ETnumero) >
		<cfset Form.FCid = Trim(Url.FCid) >
	</cfif>							  
	
	<!--- Si no vienen los parámetros, ya sea por form o url, se devuelve al menú de Facturación --->
	<cfif not (Len(Trim(Form.ETnumero)) GT 0 and Len(Trim(Form.FCid)) GT 0 )>
		<cflocation addtoken="no" url="../MenuFA.cfm">
	</cfif>  
	
	<!--------------------->
	<!---  CONSULTAS	--->
	<!--------------------->
	
	<!--- Empresa --->
	<cfquery name="rsEmpresa" datasource="#Session.DSN#">
		select Edescripcion from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<!--- Encabezado de la transacción --->
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select 		
			convert(varchar,a.FCid) as FCid, convert(varchar,a.ETnumero) as ETnumero, a.Ocodigo, a.SNcodigo, 
			convert(varchar,a.Mcodigo) as Mcodigo, a.CCTcodigo, a.Icodigo, a.ETdocumento,
			convert(varchar,a.Ccuenta) as Ccuenta, convert(varchar,a.Tid) as Tid, convert(varchar,a.FACid) as FACid, a.ETfecha, 
			a.ETtotal, a.ETestado, convert(varchar,a.Usucodigo) as Usucodigo, a.Ulocalizacion, a.Usulogin, 
			a.ETporcdes, a.ETmontodes, a.ETimpuesto, a.ETnombredoc, a.ETobs, a.ETdocumento, a.ETserie		
		from ETransacciones a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
		  and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
	</cfquery>

	<!--- Detalle de la transacción --->
	<cfquery name="rsDetalle" datasource="#Session.DSN#">
		select 		
			convert(varchar,b.DTlinea) as DTlinea, b.DTtipo, b.DTdescripcion, b.DTcant, b.DTpreciou, b.DTdeslinea, b.DTtotal		
		from ETransacciones a, DTransacciones b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
		  and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
		  and a.Ecodigo = b.Ecodigo
		  and a.ETnumero = b.ETnumero
		  and a.FCid = b.FCid
		  and b.DTborrado = 0
	</cfquery>

	<!---<cfif rsEncabezado.CCTcodigo EQ "CO">--->
		<cfquery name="rsPagos" datasource="#Session.DSN#">			
			select 
				convert(varchar,FPlinea) as FPlinea, 
				convert(varchar,Mcodigo) as Mcodigo, 
				FPtc, 
				FPmontoori,
				FPmontolocal,
				FPfechapago,
				Tipo,
				FPdocnumero,
				FPdocfecha,
				convert(varchar,FPBanco) as FPbanco,
				convert(varchar,FPCuenta) as FPcuenta,
				FPtipotarjeta
			from FPagos 
			where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#"> 
			  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
		</cfquery>	
	<!---</cfif>--->

	<!--- Código de la Caja --->
	<cffunction name="get_caja" access="public" returntype="query">
		<cfargument name="fcid" type="numeric" required="true" default="">
		<cfquery name="rsget_caja" datasource="#session.DSN#" >
			select ltrim(rtrim(FCcodigo)) as FCcodigo from FCajas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and FCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fcid#">
		</cfquery>
		<cfreturn #rsget_caja#>
	</cffunction>

	<!--- Descripción del Cliente--->
	<cffunction name="get_cliente" access="public" returntype="query">
		<cfargument name="sncodigo" type="numeric" required="true" default="">
		<cfquery name="rsget_cliente" datasource="#session.DSN#" >
			select ltrim(rtrim(SNnombre)) as SNnombre from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and SNcodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#sncodigo#">
		</cfquery>
		<cfreturn #rsget_cliente#>
	</cffunction>

	<!--- Descripción de la Moneda--->
	<cffunction name="get_moneda" access="public" returntype="query">
		<cfargument name="mcodigo" type="numeric" required="true" default="">
		<cfquery name="rsget_moneda" datasource="#session.DSN#" >
			select rtrim(Mnombre) as Mnombre from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Mcodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#mcodigo#">
		</cfquery>
		<cfreturn #rsget_moneda#>
	</cffunction>

	<!--- Descripción de la Moneda--->
	<cffunction name="get_transaccion" access="public" returntype="query">
		<cfargument name="cctcodigo" type="string" required="true" default="">
		<cfquery name="rsget_transaccion" datasource="#session.DSN#" >
			select rtrim(CCTdescripcion) as CCTdescripcion from CCTransacciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CCTcodigo   = <cfqueryparam cfsqltype="cf_sql_char" value="#cctcodigo#">
		</cfquery>
		<cfreturn #rsget_transaccion#>
	</cffunction>

	<!--- Descripción del Impuesto --->
	<cffunction name="get_impuesto" access="public" returntype="query">
		<cfargument name="icodigo" type="string" required="true" default="">
		<cfquery name="rsget_impuesto" datasource="#session.DSN#" >
			select rtrim(Idescripcion) as Idescripcion from Impuestos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Icodigo   = <cfqueryparam cfsqltype="cf_sql_char" value="#icodigo#">
		</cfquery>
		<cfreturn #rsget_impuesto#>
	</cffunction>

	<!--- Descripción del tipo de compra--->
	<cffunction name="get_tipo" access="public" returntype="query">
		<cfargument name="cmtcodigo" type="string" required="true" default="">
		<cfquery name="rsget_tipo" datasource="#session.DSN#" >
			select rtrim(CMTdesc) as CMTdesc from CMTipoCompra
			where CMTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#cmtcodigo#">
		</cfquery>
		<cfreturn #rsget_tipo#>
	</cffunction>

<cf_sifHTML2Word Titulo="Consulta de Transacción">

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>

<script language="JavaScript1.2">
	function mostrarPagos() {
		var estado = document.getElementById("idPagos").style.display;
		if (estado == 'none') 
			document.getElementById("idPagos").style.display = "";
		else
			document.getElementById("idPagos").style.display = "none";
	}
	
</script>


<cfoutput>
  <table width="99%"  border="0" cellspacing="0" cellpadding="0" align="center">
    <tr> 
	  <td>&nbsp;</td>	
      <td >&nbsp;</td>
      <td align="right" width="16%" nowrap>Fecha: #DateFormat(Now(),'DD/MM/YYYY')#<br>Hora:#TimeFormat(Now(),'medium')#<br>Usuario:#Session.Usuario#</td>
    </tr>

    <tr> 
      <td colspan="4"><hr size="1" color="##000000"><div align="center"><strong><font size="4">#rsEmpresa.Edescripcion#</font></strong></div></td>
    </tr>
    <tr> 
      <td colspan="4"><div align="center"><strong><font size="3">Consulta de Transacci&oacute;n</font></strong></div></td>
    </tr>
    <tr> 
      <td colspan="4" ><div align="center"><font size="3"><strong>#rsEncabezado.ETobs#</strong></font></div></td>
    </tr>
    <tr>
      <td colspan="4" align="center" >
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <cfset prueba = get_caja(rsEncabezado.FCid).FCcodigo >
			<td width="13%"><div align="right"><font size="2">Caja:</font></div></td>
            <td width="20%"><font size="3"><strong>&nbsp;#get_caja(rsEncabezado.FCid).FCcodigo#</strong></font></td>
            <td width="5%"><div align="right"><font size="2">Factura:</font></div></td>
            <td width="22%"><font size="3"><strong>&nbsp;#rsEncabezado.ETnumero#</strong></font></td>
            <td width="2%"><div align="right"><font size="2">Transacci&oacute;n:</font></div></td>
            <td width="15%"><font size="3"><strong>&nbsp;#rsEncabezado.ETdocumento##rsEncabezado.ETserie#</strong></font></td>
          </tr>
		  
          <tr> 
            <td nowrap><div align="right"><font size="2">Cliente:</font></div></td>
            <td nowrap><font size="2"><strong>&nbsp;#trim(get_cliente(rsEncabezado.SNcodigo).SNnombre)#</strong></font></td>
            <td nowrap><div align="right"><font size="2">Tipo:</font></div></td>
            <td nowrap><font size="2"><strong>&nbsp;#get_transaccion(rsEncabezado.CCTcodigo).CCTdescripcion#</strong></font></td>
            <td nowrap><div align="right"><font size="2">Moneda:</font></div></td>
            <td nowrap><font size="2"><strong>&nbsp;#get_moneda(rsEncabezado.Mcodigo).Mnombre#</strong></font></td>
          </tr>
          <tr> 
            <td nowrap><div align="right"><font size="2">Nombre en doc.:</font></div><hr size="1" color="##000000"></td>
            <td nowrap><font size="2"><strong>&nbsp;#rsEncabezado.ETnombredoc#</strong></font><hr size="1" color="##000000"></td>
            <td nowrap><div align="right"><font size="2">Impuesto:</font></div><hr size="1" color="##000000"></td>
            <td nowrap><font size="2"><strong>&nbsp;#get_impuesto(rsEncabezado.Icodigo).Idescripcion#</strong></font><hr size="1" color="##000000"></td>
            <td nowrap><font size="2">&nbsp;</font><hr size="1" color="##000000"></td>
            <td><font size="2">&nbsp;</font><hr size="1" color="##000000"></td>
          </tr>
			
			<tr><td>&nbsp;</td></tr>

          <tr> 
            <td bgcolor="##CCCCCC"  colspan="6"> 
              <cfif rsEncabezado.CCTcodigo EQ "CO">
                <strong>&nbsp;&nbsp;<a href="javascript: mostrarPagos();" title="Mostrar los pagos hechos a esta factura"><font size="2"> 
                Detalle de Pagos </font></a></strong> 
              </cfif>
              </td>
          </tr>
          <tr > 
            <td colspan="6"> <div id="idpagos" style="display:;"> 
                <table width="100%" cellpadding="3" cellspacing="0">
                  <cfif rsPagos.RecordCount GT 0>
                    <tr class="tituloListas"> 
                      <td width="3%"><strong>L&iacute;nea</strong></td>
                      <td width="16%"><strong>Fecha</strong></td>
                      <td width="14%" nowrap><div align="right"><strong>Tipo 
                          Cambio</strong></div></td>
                      <td width="25%"><strong>Moneda</strong></td>
                      <td width="15%"><div align="right"><strong>Monto</strong></div></td>
                      <td width="15%" nowrap><div align="right"><strong>Monto 
                          en Moneda Local</strong></div></td>
                    </tr>
                    <cfloop query="rsPagos">
                      <tr> 
                        <td width="3%" align="center">#rsPagos.CurrentRow#</td>
                        <td width="16%" nowrap>#LSDateFormat(rsPagos.FPfechapago,'DD/MM/YYYY')#</td>
                        <td width="14%" nowrap><div align="right">#LSCurrencyFormat(rsPagos.FPtc,'none')#</div></td>
                        <td width="12%" nowrap>#get_moneda(rsPagos.Mcodigo).Mnombre#</td>
                        <td width="21%" nowrap><div align="right">#LSCurrencyFormat(rsPagos.FPmontoori,'none')#</div></td>
                        <td width="34%" nowrap><div align="right">#LSCurrencyFormat(rsPagos.FPmontolocal,'none')#</div></td>
                      </tr>
                    </cfloop>
                    <cfelse>
                    <tr> 
                      <td colspan="6">No tiene pagos registrados</td>
                    </tr>
                  </cfif>
                </table>
              </div></td>
          </tr>
        </table></td>
    </tr>
	
	<tr><td colspan="4">&nbsp;</td></tr>
    <tr> 
      <td colspan="4"> 
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
          <cfif rsDetalle.RecordCount GT 0>
            <cfset pie = "------------------------ FIN DEL REPORTE ------------------------">
            <cfelse>
            <cfset pie = "------------------------ NO HAY DATOS ------------------------">
          </cfif>

			<tr>
	            <td bgcolor="##CCCCCC" colspan="7"><font size="2"><strong>&nbsp;&nbsp;Detalle de la Transacci&oacute;n</strong></font></td> 
			</tr>

		  <cfif rsDetalle.RecordCount GT 0>
			  <tr class="tituloListas"> 
				<td width="6%"><strong>L&iacute;nea</strong></td>
				<td width="34%"><strong>Descripci&oacute;n</strong></td>
				<td width="9%"><strong>Tipo</strong></td>
				<td width="8%"><div align="right"><strong>Cantidad</strong></div></td>
				<td width="14%" nowrap><div align="right"><strong>Precio Unit.</strong></div></td>
				<td width="16%"><div align="right"><strong>Descuento</strong></div></td>
				<td width="13%"><div align="right"><strong>Total</strong></div></td>
			  </tr>
          
            <cfloop query="rsDetalle">
              <tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
                <td width="6%">#CurrentRow#</td>
                <td width="34%" nowrap>#DTdescripcion#</td>
                <td width="9%">#get_tipo(DTtipo).CMTdesc#</td>
                <td width="8%"><div align="right">#LSCurrencyFormat(DTcant,'none')#</div></td>
                <td width="14%"><div align="right">#LSCurrencyFormat(DTpreciou, 'none')#</div></td>
                <td width="16%"><div align="right">#LSCurrencyFormat(DTdeslinea, 'none')#</div></td>
                <td width="13%"><div align="right">#LSCurrencyFormat(DTtotal,'none')#</div></td>
              </tr>
            </cfloop>			
          </cfif>
		  <tr > 
			<td colspan="7" align="center">#pie#</td>
		  </tr>		  
        </table>
	  </td>
    </tr>
  </table>
</cfoutput>
</cf_sifHTML2Word>
