<cfif Not IsDefined("session.comprar_Ecodigo")><cflocation url="../../public/index.cfm" addtoken="no"></cfif>

<cfquery datasource="#session.dsn#" name="carritos">
select c.id_carrito, c.fcompra,
	c.direccion_facturacion,
	c.direccion_envio, s.nombre_estado
from Carrito c, Estado s
where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
  and s.estado = c.estado
  and c.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
  and c.Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">
  and c.estado != 0
order by c.id_carrito desc
</cfquery>

<cf_template>
<cf_templatearea name=title>Compras anteriores</cf_templatearea>
<cf_templatearea name=header>
<cfinclude template="/tienda/tienda/public/carrito_p.cfm">
</cf_templatearea>
<cf_templatearea name=body>

<cfinclude template="../../public/estilo.cfm">

<table width="100%">
        <!--DWLayoutTable-->
        <tr> 
          <td valign="top">
		  
		    <br>			<cfif carritos.RecordCount GT 0>
		  &Uacute;ltimas compras realizadas:<br>
		    <table width="100%" class="small" border="0" cellspacing="0" cellpadding="0">
  <cfoutput query="carritos">
		      <tr>
		        <td>
              <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="##F5F5F5" class="small">
                <tr>
                  <td width="0%">&nbsp;</td>
                  <td width="12%" align="left">Orden No.</td>
                  <td width="38%" align="left"><a href="receipt.cfm?id=#id_carrito#">#id_carrito#</a></td>
                  <td width="2%" align="right">&nbsp;</td>
                  <td align="left" valign="top"><a href="receipt.cfm?id=#id_carrito#"><img src="../../images/btn_detalle.gif" alt="Agregar a mi compra" width="140" height="16" border="0"></a></td>
                  </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td align="left">Fecha</td>
                  <td align="left">#LSDateFormat( fcompra )#</td>
                  <td align="right">&nbsp;</td>
                  <td align="left"><a href="favoritas_add.cfm?id=#id_carrito#"><img src="../../images/btn_agregar.gif" alt="Agregar a mi compra" width="140" height="16" border="0"></a></td>
                  </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="2" bgcolor="##CCCCCC">Facturar a:</td>
                  <td bgcolor="##CCCCCC">&nbsp; </td>
                  <td bgcolor="##CCCCCC">Enviar a:</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="2">
				  <cf_direccion action="label" key="#direccion_facturacion#">
				  </td>
                  <td>&nbsp;</td>
                  <td>
				  <cf_direccion action="label" key="#direccion_envio#"></td>
                  </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="2" bgcolor="##CCCCCC">Estado: #nombre_estado#</td>
                  <td bgcolor="##CCCCCC">&nbsp;</td>
                  <td bgcolor="##CCCCCC">&nbsp;</td>
                  </tr>
                <tr>
                  <td colspan="5" style="border-bottom:solid 1px">&nbsp;</td>
                  </tr></table>
			    </td>
		        </tr>
		      <tr>
		        <td>&nbsp;</td>
		        </tr></cfoutput>
		      </table>
              <cfelse>
			    <form class="cuadro"><p>&nbsp;</p><p>&nbsp;</p>
				  No hay compras almacenadas<br>
			    <input type="button" onClick="history.back()" value="Regresar"></form>
			  </cfif></td>
        </tr>
      </table>
	  	  </cf_templatearea>
</cf_template>
