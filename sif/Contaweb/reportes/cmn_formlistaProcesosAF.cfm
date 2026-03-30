<cfoutput>
<form action="" method="post" name="form1" onSubmit="">
	<table width="100%" border="0">
		<tr>
			<td   colspan="2" align="left">
				<!--- <input type="button" name="Consul" value="Consultar" onClick="javascript:Consultar();"  tabindex="1"> --->
				<input type="button" name="ATRAS" value="Regresar" onClick="javascript:history.back()"  tabindex="1">
			</td>
		</tr>
		<tr>						
			<td align="center" colspan="4" nowrap bgcolor="##CCCCCC">
				<strong>Filtros</strong>
			</td>
		</tr> 	
		<tr>
		<td align="left" width="10%" nowrap><strong>Estatus</strong></td>
		<td width="40%" nowrap>		
			<select name="status"  onChange="javascript:Consultar();"tabindex="5">
				<option value="L">Listas</option>
				<option value="P">Pendientes</option>				
				<option value="E">En proceso</option>
				<option value="C">Errores</option>
				<option value="R">Ver Reportes</option>
			</select>
		</td>		
		<td width="10%" align="left">&nbsp;</td>
		<td width="40%" ><input type="hidden" name="usuario" value="#trim(session.usuario)#"></td>		
		</tr>
		<tr>
			<td align="center" colspan="4" nowrap bgcolor="##CCCCCC">
				<strong>Listado de las Tareas según su status</strong>
			</td>
		</tr>

	</table>
</form>
</cfoutput>

<iframe id="DOWNFILE" name="DOWNFILE" marginheight="0" marginwidth="0" frameborder="0" height="450" width="900" ></iframe>

<script language="javascript" type="text/javascript">
Consultar()
function Consultar() {		
	var USUARIO		= document.form1.usuario.value;	
	var status		= document.form1.status.value;
	var PARAMS = "?USUARIO="+ USUARIO+"&status="+ status;
	var frame  = document.getElementById("DOWNFILE");	
	if (status == 'R')
		frame.src 	= "/cfmx/sif/Contaweb/reportes/cmn_formlistaReportesAF.cfm" + PARAMS;		
	else
		frame.src 	= "/cfmx/sif/Contaweb/reportes/cmn_formlistaProcesosAF2.cfm" + PARAMS;
}
</script>