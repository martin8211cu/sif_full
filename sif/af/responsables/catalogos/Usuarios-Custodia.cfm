<!--- <cf_dump var="#form#"> --->

<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr> 		
		<td colspan="4" valign="top" class="tituloAlterno"><div align="center">Usuario</div></td>
		<td class="tituloAlterno" width="54%" valign="top"><div align="center">Usuarios Asignados</div></td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr> 		
		<td width="1%" valign="top">&nbsp;</td> 
		<td width="5%" valign="top" align="left"><strong>Usuario:&nbsp;&nbsp;&nbsp;</strong></td>
		<td width="33%" valign="top" align="left">
		<cfoutput>
		<form method="post" name="form1" action="Usuarios-Custodia-sql.cfm">
			<cf_sifusuario
				Ecodigo="#Session.Ecodigo#" form="form1" tabindex="1">
			<input type="button" name="btnAgregar" value="Agregar" onClick="javascript:validar();" tabindex="2">
         	<input type="hidden" name="modo" value="ALTA">
			<input type="hidden" name="CRCCid" value="#form.CRCCid#">
			<input type="hidden" name="tab" value="#form.tab#">			
			<input type="hidden" name="btnAlta" value="ALTA">			
		</form>
		</cfoutput>		
		</td>
		<td width="5%" valign="top">&nbsp;</td>
		<td width="54%" valign="top">
			<cfinclude template="Usuarios-Custodia-form.cfm">
		</td>
	</tr> 
</table>

<script language="javascript1.2" type="text/javascript">	
	function validar() {		
		var valido=true;
		if (trim(document.form1.Usucodigo.value) == '') {
			alert('Debe de ingresar un usuario.');
			valido=false;
		}
		if (valido==true) {			
			valido=true;
			document.form1.submit();
		}
	}
</script>

<script language="javascript">
	document.form1.Usulogin.focus();
</script>