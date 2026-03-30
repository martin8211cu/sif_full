<cfquery datasource="#session.dsn#" name="documento">
	select d.CCTcodigo, SNidentificacion, SNnombre, CCTdescripcion, Ddocumento, Mnombre, Dfecha, Dtotal, Dsaldo, Dvencimiento
	from Documentos d
		join CCTransacciones cct
			on cct.Ecodigo = d.Ecodigo
			and cct.CCTcodigo = d.CCTcodigo
		join SNegocios sn
			on sn.Ecodigo = d.Ecodigo
			and sn.SNcodigo = d.SNcodigo
		join Monedas m
			on m.Ecodigo = d.Ecodigo
			and m.Mcodigo = d.Mcodigo
	where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and d.Dsaldo != 0
	  and d.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
	  and d.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ddocumento#">
	  and cct.CCTtipo = 'D'
</cfquery>
<cfif documento.RecordCount is 0>
	<cf_errorCode	code = "50195" msg = "Documento no existe">
</cfif>

<cfquery datasource="#session.dsn#" name="detalles">
	select dd.DDescripcion, dd.DDcantidad, dd.DDtotal
	from DDocumentos dd
	where dd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and dd.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
	  and dd.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ddocumento#">
	order by dd.DDlinea
</cfquery>



<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Detalle de la factura">
<cfoutput>

<table width="980"  border="0" cellspacing="0" cellpadding="0">
  <tr valign="top">
    <td width="14">&nbsp;</td>
    <td colspan="2">&nbsp;</td>
    <td width="14">&nbsp;</td>
    <td width="597">&nbsp;</td>
    <td width="14">&nbsp;</td>
  </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td width="101"><strong>Cliente</strong></td>
    <td width="240">#documento.SNidentificacion# </td>
    <td>&nbsp;</td>
    <td rowspan="8"><div style="height:100px;overflow:auto;border:1px solid gray">
	    
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
	query="#detalles#"
	desplegar="DDcantidad,DDescripcion,DDtotal"
	etiquetas="Cant,Concepto,Importe(*)"
	formatos="S,S,M"
	funcion="void(0)"
	align="left, left, right"
	showLink="false"
	PageIndex="3">
    </cfinvoke>
          </div> </td>
    <td rowspan="8">&nbsp;</td>
  </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>#documento.SNnombre#</td>
    <td>&nbsp;</td>
    </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td><strong>Transacci&oacute;n</strong></td>
    <td>#documento.CCTdescripcion#</td>
    <td>&nbsp;</td>
    </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td><strong>Documento</strong></td>
    <td>#documento.Ddocumento#</td>
    <td>&nbsp;</td>
    </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td><strong>Moneda</strong></td>
    <td>#documento.Mnombre#</td>
    <td>&nbsp;</td>
    </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td><strong>Fecha</strong></td>
    <td>#LSDateFormat(documento.Dfecha,'dd/mm/yyyy')#</td>
    <td>&nbsp;</td>
    </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td><strong>Vencimiento</strong></td>
    <td>#LSDateFormat(documento.Dvencimiento,'dd/mm/yyyy')#</td>
    <td>&nbsp;</td>
  </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td><strong>Total</strong></td>
    <td>#NumberFormat(documento.Dtotal,',0.00')#</td>
    <td>&nbsp;</td>
    </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td><strong>Saldo</strong></td>
    <td>#NumberFormat(documento.Dsaldo,',0.00')#</td>
    <td>&nbsp;</td>
    <td>(*) importes no incluyen impuestos</td>
    <td>&nbsp;</td>
  </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</cfoutput>

<cf_web_portlet_end> 

