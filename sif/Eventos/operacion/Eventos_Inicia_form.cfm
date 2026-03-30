<cf_templateheader title="Proceso Inicial Control Eventos">  
<cf_web_portlet_start titulo="Proceso Inicial Control Eventos">


<cfoutput>
<form name="form1" action="Eventos_Inicia_SQL.cfm" method="post">
	<h1 align="center"> Procesos Iniciales para el Control de Eventos </h1>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr> <td >&nbsp;  </td> </tr>
        <tr>
        	<td width="30%" >&nbsp;  </td>
        	<td align="justify" width="40%">El proceso inicial, debe ejecutarse antes de comenzar a utilizar la funcionalidad del Control de Eventos, este proceso le permitir&aacute; generar los N&uacute;meros de Evento para los documentos de CxC y CxP con saldo, as&iacute; como de las Cajas Chicas existentes al momento de su ejecuci&oacute;n. Este proceso no afecta la informaci&oacute;n contable Hist&oacute;rica de la empresa</td>
            <td width="30%" >&nbsp;  </td>
		</tr>
        <tr> <td >&nbsp;  </td> </tr>
		<tr>
        	<td width="30%" >&nbsp;  </td>
        	<td align="left" width="40%"><input type="checkbox" id="CXC" name="CXC" /><strong> Iniciar Cuentas por Cobrar </strong></td>
            <td width="30%" >&nbsp;  </td>
		</tr>
        <tr>
        	<td width="30%" >&nbsp;  </td>
        	<td align="left" width="40%"><input type="checkbox" id="CXP" name="CXP" /><strong> Iniciar Cuentas por Pagar </strong></td>
            <td width="30%" >&nbsp;  </td>
		</tr>
        <tr>
        	<td width="30%" >&nbsp;  </td>
        	<td align="left" width="40%"><input type="checkbox" id="CCH" name="CCH" /><strong> Iniciar Cajas Chicas </strong></td>
            <td width="30%" >&nbsp;  </td>
		</tr>
		<tr> <td>&nbsp;  </td> </tr>
		<tr>
			<td colspan="3" align="center">
				<input type="submit" value="Iniciar" name="btnI"/>
			</td>
		</tr>
		<tr> <td>&nbsp;  </td> </tr>
	</table>
</form>
</cfoutput>

<cf_web_portlet_end>
<cf_templatefooter> 