<cfif not isdefined("url.desde") or not isdefined("url.hasta")>
	<cflocation url="vouchers.cfm">
</cfif>

<cfset f_desde = LSParseDateTime(url.desde)>
<cfset f_hasta = DateAdd("d", 1, LSParseDateTime(url.hasta))>

<cfquery datasource="#session.dsn#" name="data">
select  e.id_carrito, e.id_envio, e.tracking_no, e.num_voucher, e.num_autorizacion, e.total, c.moneda
from Carrito c, CarritoEnvio e
where c.fcompra >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f_desde#">
  and c.fcompra <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f_hasta#">
  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  and e.id_carrito = c.id_carrito
  and e.Ecodigo = c.Ecodigo
  and c.id_tarjeta is not null
order by 1,2
</cfquery>

<cfquery datasource="#session.dsn#" name="total">
select sum(e.total) as total, c.moneda
from Carrito c, CarritoEnvio e
where c.fcompra >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f_desde#">
  and c.fcompra <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f_hasta#">
  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  and e.id_carrito = c.id_carrito
  and e.Ecodigo = c.Ecodigo
  and c.id_tarjeta is not null
group by c.moneda
</cfquery>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">Reporte de vouchers </cf_templatearea>
<cf_templatearea name="header">
<cfinclude template="header.cfm"></cf_templatearea>
<cf_templatearea name="body">

<cfinclude template="/home/menu/pNavegacion.cfm">
		
		<cf_web_portlet titulo="Reporte de vouchers"><cfoutput>
		  <table border="0" align="center">
            <tr>
              <td>Desde</td>
              <td>#HTMLEditFormat(url.desde)#</td>
            </tr>
            <tr> 
              <td>Hasta</td>
              <td>#HTMLEditFormat(url.hasta)#</td>
            </tr>
          </table>
		  
	    </cfoutput>
		  <table width="100%" border="0" align="center" cellpadding="4" cellspacing="0">
            <tr>
              <td bgcolor="#CCCCCC"><strong>Pedido</strong></td>
              <td bgcolor="#CCCCCC"><strong>Env&iacute;o</strong></td>
              <td bgcolor="#CCCCCC"><strong>Tracking no </strong></td>
              <td bgcolor="#CCCCCC"><strong>Autorizaci&oacute;n</strong></td>
              <td align="right" bgcolor="#CCCCCC"><strong>Importe</strong></td>
              <td align="right" bgcolor="#CCCCCC">&nbsp;</td>
            </tr>
			<cfoutput query="data">
            <tr>
              <td>#id_carrito#</td>
              <td>#id_envio#</td>
              <td>#tracking_no#</td>
              <td>#num_autorizacion#</td>
              <td align="right">#LSCurrencyFormat(total,'none')#</td>
              <td>#moneda#</td>
            </tr></cfoutput>
			<cfoutput query="total">
            <tr>
              <td bgcolor="##CCCCCC">&nbsp;</td>
              <td bgcolor="##CCCCCC">&nbsp;</td>
              <td colspan="2" bgcolor="##CCCCCC">Total General </td>
              <td align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(total,'none')#</td>
              <td align="left" bgcolor="##CCCCCC">#moneda#</td>
            </tr></cfoutput>
        </table>
		</cf_web_portlet> </cf_templatearea> </cf_template> 