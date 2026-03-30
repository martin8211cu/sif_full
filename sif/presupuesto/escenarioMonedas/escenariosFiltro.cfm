<cfoutput><form action="#GCurrentPage#" method="post" name="formfiltroEscenarios">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
  <tr>
    <td><label for="Fdescripcion"><strong>Descripci&oacute;n&nbsp;:&nbsp;</strong></label><input name="Fdescripcion" id="Fdescripcion" type="text" value="#form.Fdescripcion#"></td>
    <td><label for="Ftipo"><strong>Tipo&nbsp;:&nbsp;</strong></label><select name="Ftipo" id="Ftipo" onChange="javascript: this.form.submit();">
		<option value="">Todos</option>
		<option value="N" <cfif isdefined("form.Ftipo") and form.Ftipo equal "N">selected</cfif>>Normal</option>
		<option value="O" <cfif isdefined("form.Ftipo") and form.Ftipo equal "O">selected</cfif>>Optimista</option>
		<option value="P" <cfif isdefined("form.Ftipo") and form.Ftipo equal "P">selected</cfif>>Pesimista</option>
		</select></td>
    <td><cf_botones values="Filtrar,Limpiar"></td>
  </tr>
</table>
</form></cfoutput>
<script language="javascript" type="text/javascript">
<!--// 
	function funcFiltrar(){
		//no retornar nada, se va por post
		return;
	}
	function funcLimpiar(){
		document.formfiltroEscenarios.Fdescripcion.value="";
		document.formfiltroEscenarios.Ftipo.value=0;
		//no retornar nada, se va por post
		return;
	}
//-->
</script>