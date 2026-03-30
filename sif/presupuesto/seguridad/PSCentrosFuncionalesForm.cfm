<table border="0" width="100%"  cellspacing="0" cellpadding="0">
<tr>
<td width="1%">&nbsp;</td>
<td>&nbsp;</td>
<td width="1%">&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>
<!--- Aquí Va el Centro Funcional --->
<fieldset>
<legend>Centro Funcional</legend>
<cfquery name="rsCFuncional" datasource="#session.dsn#">
	select a.CFid, a.Ecodigo, a.CFcodigo, 
		a.Dcodigo, a.Ocodigo, a.RHPid, 
		a.CFdescripcion, a.CFidresp, a.CFcuentac, 
		a.CFcuentaaf, a.CFuresponsable, a.CFcomprador, 
		a.CFpath, a.CFnivel, a.CFcuentainversion, 
		a.CFcuentainventario, b.Odescripcion, c.Ddescripcion
	from CFuncional a 
		inner join Oficinas b 
		on b.Ocodigo = a.Ocodigo 
		and b.Ecodigo = a.Ecodigo
		inner join Departamentos c 
		on c.Dcodigo = a.Dcodigo 
		and c.Ecodigo = a.Ecodigo
	where a.Ecodigo = #Session.Ecodigo#
		and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
</cfquery>
<br>
<cfoutput query="rsCFuncional">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td colspan="4" nowrap class="subtitulo"><strong>Informaci&oacute;n General</strong>&nbsp;</td>
  </tr>
  <tr>
	<td width="1%" nowrap>C&oacute;digo:</td>
	<td>#CFcodigo#&nbsp;</td>
	<td width="1%" nowrap>Oficina:</td>
	<td>#Odescripcion#&nbsp;#CFid#</td>
  </tr>
  <tr>
	<td width="1%" nowrap>Descripci&oacute;n:</td>
	<td>#CFdescripcion#&nbsp;</td>
	<td width="1%" nowrap>Departamento:</td>
	<td>#Ddescripcion#&nbsp;</td>
  </tr>
</table>
<br>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td colspan="5" nowrap class="subtitulo"><strong>Cuentas Financieras a Complementar</strong>&nbsp;</td>
  </tr>
  <tr>
  	<td width="1%" nowrap>Cuenta de Gasto:&nbsp;</td>
	<td colspan="3"><cfif len(trim(CFcuentac))>#CFcuentac#<cfelse>No se ha definido.</cfif>&nbsp;</td>
	<td rowspan="3" valign="middle">
		<script language="javascript" type="text/javascript">
			<!--//
				function funcAgregar(){
					return confirm('Esta seguro que desea agregar las cuentas complementarias a la lista de cuentas de presupuesto autorizadas?');
				}
			//-->
		</script>
		<form action="PSCentrosFuncionales-sql.cfm" method="post" name="formAgregarMascaras">
		<input name="CFpk" type="hidden" value="#form.CFpk#">
		<table width="1%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
				<cf_botones values="Agregar Complementarias" names="Agregar">
			</td>
		  </tr>
		</table>
		</form>
	</td>
  </tr>
  <tr>
  	<td width="1%" nowrap>Cuenta de Inversi&oacute;n:&nbsp;</td>
	<td colspan="3"><cfif len(trim(CFcuentainversion))>#CFcuentainversion#<cfelse>No se ha definido.</cfif>&nbsp;</td>
  </tr>
  <tr>
  	<td width="1%" nowrap>Cuenta de Inventario:&nbsp;</td>
	<td colspan="3"><cfif len(trim(CFcuentainventario))>#CFcuentainventario#<cfelse>No se ha definido.</cfif>&nbsp;</td>
  </tr>
<cfif isdefined("url.ERR")>
  <tr>
  	<td colspan="6" style="color:##FF0000">
		Se encontraron Máscaras Financieras mal formadas por lo que no se agregó la Máscara Presupuestal
	</td>
  </tr>
</cfif>
</table>
</cfoutput>
<br>
<div style="overflow:auto; height: 235; margin:0;" >
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top"><cfinclude template="PSCentrosFuncionalesMascaras.cfm"></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td valign="top"><cfinclude template="PSCentrosFuncionalesUsuarios.cfm"></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td valign="top"><cfinclude template="PSCentrosFuncionalesMascarasUsuarios.cfm"></td>
  </tr>
</table>
</div>
</fieldset>
<!--- Aquí termina el Centro Funcional --->
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
</table>
