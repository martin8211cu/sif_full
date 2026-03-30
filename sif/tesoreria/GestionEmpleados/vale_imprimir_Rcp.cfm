<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ImpresionVale" default ="Impresion del Vale" returnvariable="LB_ImpresionVale" xmlfile = "vale_imprimir_Rcp.xml">

<cf_htmlReportsHeaders 
	title="#LB_ImpresionVale#" 
	filename="SolicitudPago.xls"
	irA="TransaccionCustodiaP.cfm?regresar=1"
	download="no"
	preview="no"
>

<cfif isDefined("Url.imprime") and not isDefined("form.imprime")>
  <cfset form.imprime = Url.imprime>
</cfif>
 
<cfif isdefined('form.id') and form.id NEQ ''>
	<cfquery datasource="#session.dsn#" name="rsReporteTotal">
		Select 
			com.CCHid, 
			com.CCHEMtipo, 
			com.CCHEMnumero, 
			com.Ecodigo, 
			com.CCHEMfecha as fecha	, 
			com.Mcodigo, 
			com.CCHEMmontoOri, 
			com.CCHEMtipoCambio,
			com.CCHEMdescripcion,
			com.CCHEMdepositadoPor,
			cee.CCHcodigo,
			mo.Mnombre as Moneda,
			e.Edescripcion,
			{fn concat({fn concat({fn concat({fn concat(dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )}, dp.Papellido2 )} as confeccionadoPor

		from CCHespecialMovs com
			inner join CCHica cee
				on cee.CCHid = com.CCHid
			inner join Monedas mo
				on mo.Mcodigo = com.Mcodigo
			inner join Empresas e
				on e.Ecodigo = com.Ecodigo
			inner join Usuario u
				inner join DatosPersonales dp
				on dp.datos_personales=u.datos_personales
			on u.Usucodigo=#session.Usucodigo#
		where cee.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 			and com.CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.CCHid#">	
			and com.CCHEMtipo = 'E'
 			and com.CCHEMnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">	
	</cfquery>	
</cfif>

<style type="text/css">
<!--
.style1 {
	font-size: 18px;
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
}
.style4 {font-size: 14px}
.style7 {font-size: 14px; font-weight: bold; }
.style8 {
	font-family: "Courier New", Courier, mono;
	font-size: 14px;
}
.style9 {font-family: Georgia, "Times New Roman", Times, serif}
-->
</style>


<cfif rsReporteTotal.recordcount gt 0>
	<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
	<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="25%">&nbsp;</td>
			<td width="40%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
		</tr>		
		<tr>
			<td colspan="7" align="center"><span class="style1"><cf_translate key = LB_ComprobanteRecepcionCajaEfectivo xmlfile = "vale_imprimir_Rcp.xml">COMPROBANTE DE RECEPCION DE CAJA DE EFECTIVO</cf_translate></span></td>
		</tr>
		<tr>
			<td colspan="7" align="center"><strong>(<cf_translate key = LB_EntradaEfectivo xmlfile = "vale_imprimir_Rcp.xml">ENTRADA DE EFECTIVO</cf_translate>)</strong></td>
		</tr>
	<cfparam name="Attributes.copia" default="false">
	<cfif Attributes.copia>
		<tr>
			<td colspan="7" align="center"><strong>*** <cf_translate key = LB_CopiaDelComprobanteOriginal xmlfile = "vale_imprimir_Rcp.xml">COPIA DEL COMPROBANTE ORIGINAL</cf_translate> ***</strong></td>
		</tr>
	</cfif>
		<tr>
			<td nowrap><strong><cf_translate key = LB_CajaEfectivo xmlfile = "vale_imprimir_Rcp.xml">CAJA DE EFECTIVO</cf_translate>:</strong>&nbsp;</td>
			<td><span class="style4">#rsReporteTotal.CCHcodigo#</span></td>
	
			<td nowrap align="right"><strong><cf_translate key = LB_Comprobante xmlfile = "vale_imprimir_Rcp.xml">COMPROBANTE</cf_translate>:&nbsp;</strong></td>
			<td nowrap align="right">#rsReporteTotal.CCHEMnumero#</td>
		</tr>
		<tr>
			<td nowrap><strong><cf_translate key = LB_NombreCompania xmlfile = "vale_imprimir_Rcp.xml">NOMBRE DE LA COMPA&Ntilde;IA</cf_translate>:&nbsp;</strong></td>
			<td>
				<span class="style4">#rsReporteTotal.Edescripcion#</span>
			</td>
			<td nowrap align="right"><strong><cf_translate key = LB_Fecha xmlfile = "vale_imprimir_Rcp.xml">FECHA</cf_translate>:&nbsp;&nbsp;</strong></td>
			<td nowrap align="right"><span class="style4">#dateFormat(rsReporteTotal.fecha,"DD/MM/YYYY")#</span></td>
		  </tr>
		  <tr>
			<td></td>
			<td><span class="style4"></td>
			<td nowrap align="right"><strong><cf_translate key = LB_Hora xmlfile = "vale_imprimir_Rcp.xml">HORA</cf_translate>:&nbsp;&nbsp;</strong></td>
			<td nowrap align="right"><span class="style4">#timeFormat(rsReporteTotal.fecha,"HH:MM:SS")#</span></td>
		  </tr>
		  
		  <tr>
			<td><strong><cf_translate key = LB_Monto xmlfile = "vale_imprimir_Rcp.xml">MONTO</cf_translate> :</strong></td>
			<td colspan="8">#numberFormat(rsReporteTotal.CCHEMmontoOri,",9.00")# <strong>#rsReporteTotal.Moneda#</strong></td>
		  </tr>
		  <tr>
			<td><strong><cf_translate key = LB_ValorEnLetras xmlfile = "vale_imprimir_Rcp.xml">VALOR EN LETRAS</cf_translate> :</strong></td>
			<td colspan="8">#LvarObj.fnMontoEnLetras(rsReporteTotal.CCHEMmontoOri)# <strong>#rsReporteTotal.Moneda#</strong></td>
		  </tr>
		  <tr>
		    <td><strong><cf_translate key = LB_PorConceptoDe xmlfile = "vale_imprimir_Rcp.xml">POR CONCEPTO DE</cf_translate> :</strong></td>
			<td colspan="4" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">#rsReporteTotal.CCHEMdescripcion#</td>
		  </tr>
		  
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="7">
				<table width="100%">
					<tr>
						<td width="5%">&nbsp;</td>
						<td width="40%" valign="top" style="border:solid 1px ##CCCCCC; height:50px">
							&nbsp;<strong><cf_translate key = LB_RecibidoPor xmlfile = "vale_imprimir_Rcp.xml">Recibido por</cf_translate>: #trim(rsReporteTotal.confeccionadoPor)#</strong>
						</td>
						<td width="5%">&nbsp;</td>
						<td width="40%" valign="top" style="border:solid 1px ##CCCCCC; height:50px">
							&nbsp;<strong><cf_translate key = LB_DepositadoPor xmlfile = "vale_imprimir_Rcp.xml">Depositado por</cf_translate>: #trim(rsReporteTotal.CCHEMdepositadoPor)#</strong>
						</td>
						<td width="5%">&nbsp;</td>
					</tr>
					<tr>
						<td width="5%">&nbsp;</td>
						<td width="40%" valign="top">
							&nbsp;<strong><cf_translate key = LB_NombreYFirmaRecibido xmlfile = "vale_imprimir_Rcp.xml">Nombre y firma de recibido</cf_translate>:<BR><BR><BR>________________________________</strong>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</cfoutput>		  	
<cfelse>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		Select count(1) as cantidad
		from CCHespecialMovs com
		where com.CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.CCHid#">	
			and com.CCHEMtipo = 'E'
 			and com.CCHEMnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">	
	</cfquery>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
		  <td align="center">&nbsp;</td>
		</tr>	  
		<tr>
			<cfif rsSQL.cantidad EQ 0>
				<td align="center"><strong><cf_translate key = MSG_NoSeEncontroElComprobanteSeleccionadoFavorIntenteloDeNuevo xmlfile = "vale_imprimir_Rcp.xml">No se encontr&oacute; el comprobante seleccionado, favor int&eacute;ntelo de nuevo</cf_translate> </strong></td>
			<cfelse>
				<td align="center"><strong><cf_translate key = MSG_ElComprobanteEstaVacioFavorIntenteloDeNuevo xmlfile = "vale_imprimir_Rcp.xml">El comprobante esta vacio, favor int&eacute;ntelo de nuevo</cf_translate> </strong></td>
			</cfif>
		</tr>	  
		<tr>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr>
		  <td align="center">&nbsp;</td> 
		</tr>				  
	</table>
</cfif>
