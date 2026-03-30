<cfinvoke key="BTN_Agregar" default="Agregar"	returnvariable="BTN_Agregar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="/sif/generales.xml"/>

<form name="form1" action="seguridadOP_sql.cfm" method="post" style="margin:0;">
<table width="100%">
	<tr>
		<td colspan="2" width="1%" nowrap="nowrap" align="left" style="border-bottom: 1px solid black; padding-bottom: 5px;">
			<strong><cf_translate key=LB_AgregarUsuarios>Agregar Usuarios a la Tesorería</cf_translate></strong>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="1%" nowrap><strong><cf_translate key=LB_Usuario>Usuario</cf_translate>:</strong></td>
	</tr>
	<tr>
		<td>
			<cf_sifusuario conlis="true" size="40">
		</td>
	</tr>
	<tr>
		<td align="center">
			<cfoutput><input type="submit" name="Alta" id="Alta" value="#BTN_Agregar#"></cfoutput>
		</td>
	</tr>
</table>
</form>


<cf_qforms>
<script language="javascript1.1" type="text/javascript">
	objForm.Usucodigo.required = true;
	objForm.Usucodigo.description="Usuario";
</script>
