<cfparam name="url.LFlote" type="numeric">
<cfparam name="url.trafico" type="numeric" default="1">
<cfquery datasource="#session.dsn#" name="data">
	select
		fm.LFlote, fm.EMid, fm.LFnumero, fm.LFestado,
		fm.LFcreacion, fm.LFenvio, fm.LFrespuesta,
		fm.cantEnviadas, fm.cantAplicadas, fm.cantInconsistentes, fm.cantMorosas, fm.cantLiquidadas,
		fm.cantEnviadas + fm.cantAplicadas + fm.cantInconsistentes + fm.cantMorosas + fm.cantLiquidadas as cantTotal,
		fm.montoEnviadas, fm.montoAplicadas, fm.montoInconsistentes, fm.montoMorosas, fm.montoLiquidadas,
		fm.montoEnviadas + fm.montoAplicadas + fm.montoInconsistentes + fm.montoMorosas + fm.montoLiquidadas as montoTotal,
		mc.EMnombre, mc.EMcorreoEnvioFacturas
	from  ISBfacturaMedios fm
		left join ISBmedioCia mc
			on fm.EMid = mc.EMid
	where fm.LFlote =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LFlote#" null="#Len(url.LFlote) Is 0#">
	</cfquery>

<cfoutput>
  <form action="ISBfacturaMedios-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
    <table width="843" summary="Tabla de entrada">
      
      
      
      <tr>
        <td colspan="8" class="subTitulo"> Facturación de medios </td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td width="96" valign="top">Enviar a</td>
        <td width="4" valign="top">&nbsp;</td>
        <td width="205" valign="top"><strong>#HTMLEditFormat(data.EMnombre)#</strong> </td>
        <td colspan="2" valign="top" class="subTitulo">Resumen de llamadas </td>
        <td width="62" align="right" valign="top" class="subTitulo">Cantidad</td>
        <td width="10" align="right" valign="top" class="subTitulo">&nbsp;</td>
        <td width="73" align="right" valign="top" class="subTitulo">Importe</td>
        <td width="202" align="right" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top">&nbsp;</td>
        <td valign="top">#HTMLEditFormat(data.EMcorreoEnvioFacturas)#</td>
        <td width="12">&nbsp;</td>
        <td width="139" valign="top">Enviadas </td>
        <td align="right" valign="top">#NumberFormat(data.cantEnviadas, ',0')# </td>
        <td align="right" valign="top">&nbsp;</td>
        <td align="right" valign="top">#NumberFormat(data.montoEnviadas, ',0.00')# </td>
        <td align="right" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">Número de lote</td>
        <td valign="top">&nbsp;</td>
        <td valign="top"><strong>#HTMLEditFormat(data.LFnumero)#</strong> </td>
        <td>&nbsp;</td>
        <td valign="top">Aplicadas </td>
        <td align="right" valign="top">#NumberFormat(data.cantAplicadas, ',0')# </td>
        <td align="right" valign="top">&nbsp;</td>
        <td align="right" valign="top">#NumberFormat(data.montoAplicadas, ',0.00')# </td>
        <td align="right" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top" class="subTitulo">Estado</td>
        <td valign="top">&nbsp;</td>
        <td valign="top"><cfif data.LFestado is 'C'>
          Creado
          <cfelseif data.LFestado is 'E'>
          Enviado
          <cfelseif data.LFestado is 'R'>
          Respuesta recibida
          <cfelse>
          #data.LFestado#
        </cfif>        </td>
        <td valign="top">&nbsp;</td>
        <td valign="top">Inconsistentes </td>
        <td align="right" valign="top">#NumberFormat(data.cantInconsistentes, ',0')# </td>
        <td align="right" valign="top">&nbsp;</td>
        <td align="right" valign="top">#NumberFormat(data.montoInconsistentes, ',0.00')# </td>
        <td align="right" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">Creado</td>
        <td valign="top">&nbsp;</td>
        <td valign="top"><cfif Len(data.LFcreacion)>
          #DateFormat(data.LFcreacion,'dd/mm/yyyy')#
          #TimeFormat(data.LFcreacion,'HH:mm:ss')#
          <cfelse>
          N.D.
        </cfif></td>
        <td>&nbsp;</td>
        <td valign="top">Morosas </td>
        <td align="right" valign="top">#NumberFormat(data.cantMorosas, ',0')# </td>
        <td align="right" valign="top">&nbsp;</td>
        <td align="right" valign="top">#NumberFormat(data.montoMorosas, ',0.00')# </td>
        <td align="right" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">Enviado</td>
        <td valign="top">&nbsp;</td>
        <td valign="top"><cfif Len(data.LFenvio)>
          #DateFormat(data.LFenvio,'dd/mm/yyyy')##TimeFormat(data.LFenvio,'HH:mm:ss')#
          <cfelse>
          -
        </cfif></td>
        <td>&nbsp;</td>
        <td valign="top">Liquidadas </td>
        <td align="right" valign="top">#NumberFormat(data.cantLiquidadas, ',0')# </td>
        <td align="right" valign="top">&nbsp;</td>
        <td align="right" valign="top">#NumberFormat(data.montoLiquidadas, ',0.00')# </td>
        <td align="right" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">Respuesta</td>
        <td valign="top">&nbsp;</td>
        <td valign="top"><cfif Len(data.LFrespuesta)>
          #DateFormat(data.LFrespuesta,'dd/mm/yyyy')#
          #TimeFormat(data.LFrespuesta,'HH:mm:ss')#
          <cfelse>
          N.D.
        </cfif></td>
        <td>&nbsp;</td>
        <td valign="top"><strong>Total</strong></td>
        <td align="right" valign="top"><strong>#NumberFormat(data.cantTotal, ',0')#</strong></td>
        <td align="right" valign="top">&nbsp;</td>
        <td align="right" valign="top"><strong>#NumberFormat(data.montoTotal, ',0.00')#</strong></td>
        <td align="right" valign="top">&nbsp;</td>
      </tr>
      
      <tr>
        <td colspan="9" class="formButtons">
			<input type="button" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript:location.href='index.cfm?tab=#url.tab#';">     
			<input type="button" name="Download" class="btnGuardar" value="Descargar archivo completo" onclick="DescargarArchivo()">
			<input type="button" name="Reenviar" class="btnEmail" value="Reenviar facturación" onclick="funcReenviar()"></td>
      </tr>
    </table>
    <input type="hidden" name="LFlote" value="#HTMLEditFormat(data.LFlote)#">
  </form>

<form name="reenviarform" action="ISBfacturaMedios-apply.cfm" style="margin:0" method="post">
<input type="hidden" name="chk" id="chk" value="#url.LFlote#" />
<input type="hidden" name="btnReenviar" id="Reenviar"/>
</form>
<cfif url.trafico>
	<cfinclude template="ISBfacturaMedios-det.cfm">
</cfif>

<script type="text/javascript">
function DescargarArchivo() {
	window.open('descargar-factura.cfm?LFlote=#url.LFlote#', '_self');
}
function MostrarTrafico() {
	window.open('index.cfm?tab=#url.tab#&LFlote=#url.LFlote#&trafico=1','_self')
}
function OcultarTrafico() {
	window.open('index.cfm?tab=#url.tab#&LFlote=#url.LFlote#&trafico=0','_self')
}
function funcReenviar() {
	document.reenviarform.submit();
}
</script>




</cfoutput> 













