<cfoutput>
<form action="" method="post" name="form1" onSubmit="">
	<table width="100%" border="0">
		<tr>
			<td   colspan="2" align="left">
				<input type="button" name="Consul" value="Consultar"   onClick="javascript:Consultar();"  tabindex="1">
			</td>
		</tr>
		<tr>						
			<td align="center" colspan="4" nowrap bgcolor="##CCCCCC">
				<strong>Filtros</strong>
			</td>
		</tr> 	
		<tr>
		<td width="10%" align="left"><strong>Usuario :</strong></td>
		<td width="40%" >
			<INPUT 	TYPE="textbox"  
					NAME="USUARIO" 
					ID  ="USUARIO"
					VALUE="#trim(session.usuario)#" 
					SIZE="30" 
					MAXLENGTH="15" 
					ONBLUR="" 
					ONFOCUS="this.select(); " 
					ONKEYUP=""  
			>
		</td>
		<td align="left" width="10%" nowrap><strong>Estatus</strong></td>
		<td width="40%" nowrap>
		<select name="status"  onChange="javascript:Consultar();"tabindex="5">
				<option value="L">Listos</option>
				<option value="P">Pendientes</option>
				<option value="B">Bajados</option>
				<option value="E">En proceso</option>
			</select>
		</td>		
		</tr>
		<tr>						
			<td align="center" colspan="4" nowrap bgcolor="##CCCCCC">
				<strong>Tiene generado los siguientes Archivos</strong>
			</td>
		</tr> 		

	</table>
</form>
</cfoutput>

<iframe id="DOWNFILE" name="DOWNFILE" marginheight="0" marginwidth="0" frameborder="0" height="450" width="900" ></iframe>

<script language="javascript" type="text/javascript">
Consultar()
function Consultar() {
	var USUARIO		= document.form1.USUARIO.value;
	var status		= document.form1.status.value;
	var PARAMS = "?USUARIO="+ USUARIO+"&status="+ status;
	var frame  = document.getElementById("DOWNFILE");
	frame.src 	= "cg_formlistaArch2.cfm" + PARAMS;
}
</script>





