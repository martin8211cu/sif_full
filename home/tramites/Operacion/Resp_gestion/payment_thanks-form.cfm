<table width="100%" border="0">
        <!--DWLayoutTable-->
        <tr> 
          <td valign="top">
          <table align="center" border="0" cellspacing="2" style="border:solid 1px #000000; text-shadow: 6px;">
		  <tr><td colspan="3"><cfinclude template="payment_header.cfm"></td></tr>
              <!--DWLayoutTable-->
			  <cfoutput>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">Cobro No. <span class="orderno">11587</span></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">Pago No. <span class="orderno">48787</span></td>
              </tr>
              <tr>
                <td colspan="3" align="right" style="border-bottom:solid 2px ##c0c0c0;padding-bottom:4px;"><!--DWLayoutEmptyCell-->&nbsp;</td>
                </tr>
              <tr>
                <td colspan="3"> <strong>La transacci&oacute;n ha sido completada con &eacute;xito</strong></td>
                </tr>
              <tr>
                <td colspan="2"><!--DWLayoutEmptyCell-->&nbsp;</td>
                <td><!--DWLayoutEmptyCell-->&nbsp;</td>
              </tr>
              <tr>
                <td colspan="3" valign="top" align="center" class="tituloListas">Detalle del pago realizado </td>
              </tr>
              <tr>
                <td colspan="3">
Cobros seleccionados:
&gt;&gt; Lista de lo que se ha pagado &lt;&lt;

				</td>
              </tr>
<tr><td colspan="3" class="subTitulo tituloListas">Pago recibido: &nbsp; USD$ #NumberFormat(45,',0.00')#</td></tr>
			  </cfoutput>
              <tr>
                <td colspan="3" valign="top"><!--DWLayoutEmptyCell-->&nbsp;      </td>
              </tr>
              <tr>
                <td colspan="3" valign="top" >
				
				<cfset pago = StructNew()>
				<cfset pago.forma_pago='T'>
				<cfset pago.id_tarjeta=5>
				
			<cfif pago.forma_pago is 'T'>
				<cf_tarjeta action="display" key="#pago.id_tarjeta#">
				
				
				<cfelseif pago.forma_pago is 'C'>
					
			<cfquery datasource="#session.dsn#" name="bancos">
				select Bid, Bdescripcion
				from Bancos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pago.cheque_Bid#">
			</cfquery>
			<cfoutput>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr align="center">
				<td colspan="3" class="tituloListas">Pago con cheque</td>
			  </tr>
			  <tr>
				<td width="200" align="right"><strong>N&uacute;mero de cheque:</strong></td>
				<td width="5">&nbsp;</td>
				<td width="364">#HTMLEditFormat(pago.cheque_numero)#
				</td>
			  </tr>
			  <tr>
				<td align="right"><strong>N&uacute;mero de cuenta cliente: </strong></td>
				<td>&nbsp;</td>
				<td>#HTMLEditFormat(pago.cheque_cuenta)#</td>
			  </tr>
			  <tr>
				<td align="right"><strong>Banco:</strong></td>
				<td>&nbsp;</td>
				<td>#HTMLEditFormat(bancos.Bdescripcion)#</td>
			  </tr>
			</table></cfoutput>
		<cfelseif pago.forma_pago is 'E'>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr align="center">
				<td colspan="3" class="tituloListas subTitulo">Pago en efectivo</td>
			  </tr></table>
		<cfelse>
			<cfthrow message="Forma de pago inválida: #pago.forma_pago#">
		</cfif>
				
				</td>
              </tr>
              <tr>
                <td colspan="3" align="center" valign="top" >
				<form name="form1" method="get" action="gestion-form.cfm">
                  <input type="submit" name="Submit" value="Listo">
                </form></td>
              </tr>
          </table>          
          </td>
        </tr>
</table>