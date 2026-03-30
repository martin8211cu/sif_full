<cfoutput>
<form name="combos" id="combos" method="get" action="simple.cfm" style="margin:0">
<table border="0" cellspacing="0" cellpadding="2" width="795">
  <tr>
    <td colspan="3" class="subTitulo">Administrar seguridad de Empresa </td>
    </tr>
  <tr>
    <td width="68">&nbsp;Cuenta&nbsp;</td>
    <td width="345">
	#HTMLEditFormat(CuentaEmpresarial_Q.CEnombre)#
	<input type="hidden" name="ce" value="#HTMLEditFormat(CuentaEmpresarial_Q.CEcodigo)#"/>
	</td>
    <td width="370">
	<cfif Not IsDefined('Request.soyaspweb')>
	  <input name="regresar" type="button" id="regresar" value="Regresar" class="btnAnterior" onclick="this.disabled=true;window.open('../empresas.cfm','_self')"/>
 </cfif>
	<input type="button" name="nuevoUsuario" value="Nuevo Usuario" onclick="showUser()" class="btnSiguiente">
	</td>
  </tr>
  <tr>
    <td>&nbsp;Empresa&nbsp;</td>
    <td>
	#HTMLEditFormat(Empresa_Q.Enombre)#
	<input type="hidden" name="ce" value="#HTMLEditFormat(Empresa_Q.Ecodigo)#"/>
	</td>
    <td>&nbsp;</td>
  </tr>
</table>
<br />
</form>
</cfoutput>
