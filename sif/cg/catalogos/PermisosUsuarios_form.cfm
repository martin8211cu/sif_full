
<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr><td colspan="4">&nbsp;</td></tr>
<tr> 		
	<td colspan="4" valign="top">

		<cfoutput>
		<form method="post" name="form1" action="PermisosUsuarios_sql.cfm">
	
			<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="1%" valign="top">&nbsp;</td> 
				<td width="18%" valign="top" align="left"><strong>Usuario:&nbsp;&nbsp;&nbsp;</strong></td>
				<td width="20%" valign="top" align="left">		
					<cf_sifusuario Ecodigo="#Session.Ecodigo#" form="form1" tabindex="1">
				</td>
					<td width="5%" valign="top">&nbsp;</td>
				</tr>	
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>
				<td colspan="4" align="center">
					<input type="button" name="btnAgregar" value="Agregar" onClick="javascript:validar();" tabindex="2">
					<input type="button" name="btnRegresar" value="Regresar" onClick="javascript:document.location='TiposReglas.cfm';" tabindex="2">
				</td>
			</tr>
			</table>			
			<input type="hidden" name="modo" value="ALTA">
			<input type="hidden" name="btnAlta" value="ALTA">		
			<input type="hidden" name="PCRGid" value="#Form.PCRGid#">
		</form>
		</cfoutput>		
	
	</td>	
	</tr> 
	
</table>
<script language="javascript1.2" type="text/javascript">	
	function validar() 
	{
		var valido=true;
		if (document.form1.Usucodigo.value == '') 
		{
			alert('Debe de ingresar un usuario.');
			document.form1.Usulogin.focus();
			valido=false;
		}
		if (valido==true) 
		{			
			document.form1.submit();
		}
	}

	document.form1.Usulogin.focus();
</script>
