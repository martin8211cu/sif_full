<link href="/cfmx/aspAdmin/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/aspAdmin/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/web_portlet.css" rel="stylesheet" type="text/css">
<form name="form1" action="SQLEmpresas.cfm" method="post" enctype="multipart/form-data">
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td width=50%>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td width="1%"></td>
					<td width="1%"></td>
					<td width="97%"></td>
				</tr>
				<tr class="tituloListas">
					<td>&nbsp;</td>
					<td colspan="2"><strong>Modulo/Concepto de Tarifa</strong></td>
				</tr>
				<tr class="ListaNon">
					<td>&nbsp;</td>
					<td colspan="2"><strong>rh.pago</strong></td>
				</tr>
				<tr class="ListaPar">
					
          <td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>Monto total de Planilla</td>
				</tr>
				<tr class="ListaNon">
					<td>&nbsp;</td>
					<td colspan="2"><strong>rh.rrhh</strong></td>
				</tr>
				<tr class="ListaPar">
					
          <td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>Numero de Empleados Activos</td>
				</tr>
				<tr class="ListaNon">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.menu</strong></td>
				</tr>
				<tr class="ListaPar">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.ad</strong></td>
				</tr>
				<tr class="ListaNon">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.admin</strong></td>
				</tr>
				<tr class="ListaPar">
					<td><img border="0" src="/cfmx/sif/imagenes/addressGo.gif"></td>
					<td>&nbsp;</td>
					<td>Numero de Consultas Efectuadas</td>
				</tr>
				<tr class="ListaNon">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.an</strong></td>
				</tr>
				<tr class="ListaPar">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.cc</strong></td>
				</tr>
				<tr class="ListaNon">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.cg</strong></td>
				</tr>
				<tr class="ListaPar">
					
          <td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>Numero de Asientos No Auxiliares</td>
				</tr>
				<tr class="ListaNon">
					
          <td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>Numero de Asientos Auxiliares</td>
				</tr>
				<tr class="ListaPar">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.cm</strong></td>
				</tr>
				<tr class="ListaNon">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.cp</strong></td>
				</tr>
				<tr class="ListaPar">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.ct</strong></td>
				</tr>
				<tr class="ListaNon">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.fa</strong></td>
				</tr>
				<tr class="ListaPar">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.iv</strong></td>
				</tr>
				<tr class="ListaNon">
					<td>&nbsp;</td>
					<td colspan="2"><strong>sif.mb</strong></td>
				</tr>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td align="center" colspan="3">
						<input type="submit" name="AltaE" value="Agregar">
					</td>
				</tr>
			</table>
		</td>			
		<td width="5%">&nbsp;</td>
		<td width=50% valign="top">
			
			
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr class="itemtit"> 
          <td colspan="4"><b>Mantenimiento de Tarifas</b></td>
        </tr>
        <tr> 
          <td align="center" colspan="4">&nbsp; </td>
        </tr>
        <tr> 
          <td align="center" colspan="4"><strong>Módulo: sif.admin</strong></td>
        </tr>
        <tr> 
          <td align="center" colspan="4"> <strong>Numero de Consultas Efectuadas</strong> 
          </td>
        <tr> 
          <td align="center" colspan="4">&nbsp; </td>
        </tr>
        <tr> 
			<td colspan="4">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td align="right">Hasta:&nbsp;</td>
					<td><input type="text"></td>
				</tr>
				<tr>
					<td align="right">Tarifa Fija:&nbsp;</td>
					<td><input type="text"></td>
				</tr>
				<tr>
					<td align="right">Tarifa Variab:&nbsp;</td>
					<td><input type="text"></td>
				</tr>
			</table>					
			</td>
        </tr>
        <tr> 
          <td align="center" colspan="4"><input type="submit" name="AltaE2" value="Agregar">
            &nbsp; 
            <input type="submit" name="AltaE3" value="Limpiar"> </td>
        </tr>
        <tr> 
          <td colspan="4">&nbsp;</td>
        </tr>
        <tr class="tituloListas">
          <td align="right">&nbsp;</td>
          <td align="right">Hasta</td>
          <td align="right">Fija</td>
          <td align="right">Variable</td>
        </tr>
        <tr>
          <td align="right"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></td>
          <td align="right">0</td>
          <td align="right">0.00</td>
          <td align="right">0.00</td>
        </tr>
        <tr>
          <td align="right"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></td>
          <td align="right">1000</td>
          <td align="right">100.00</td>
          <td align="right">1.00</td>
        </tr>
        <tr>
          <td align="right">&nbsp;</td>
          <td align="right">Más de 1000</td>
          <td align="right">1,100.00</td>
          <td align="right">0.00</td>
        </tr>
      </table>
		</td>		
	</tr>
</table>
