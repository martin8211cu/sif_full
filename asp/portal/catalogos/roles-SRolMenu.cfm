<cfquery name="rsSRM" datasource="asp">
	select rtrim(rm.SScodigo) as SScodigo, m.nombre_menu as SMdescripcion, rtrim(rm.SRcodigo) as SRcodigo, rm.id_root, rm.default_menu
	  from SRolMenu rm
		inner join SMenu m
			on m.id_root = rm.id_root
	 where rm.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
	   and rm.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SRcodigo#">
	 order by m.orden_menu
</cfquery>
<input type="hidden" name="id_root_default" id="id_root_default" value="">
<input type="hidden" name="id_root_borrar" id="id_root_borrar" value="">
<script language="javascript" type="text/javascript">
	function doConlisMenus(proceso, rol) {
		var width = 650;
		var height = 400;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var nuevo = window.open('ConlisMenus.cfm?SScodigo='+proceso+'&SRcodigo='+rol,'Menus','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
</script>
<table cellpadding="2" cellspacing="0" border="0" width="99%" >
	<tr>
		<td colspan="3" class="subTitulo">
			Menúes para el Portal Relacionados
		</td>
		
	</tr>
	<tr>
		<td align="right">
			<strong>Def.</strong>
		</td>
		<td nowrap>
			&nbsp;
			<strong>Menú para el Portal</strong>
		</td>
		<td align="right">
			<input type="button" name="btnAgregarMenu" value="Agregar" onClick="javascript:doConlisMenus('<cfoutput>#Form.SScodigo#</cfoutput>','<cfoutput>#Form.SRcodigo#</cfoutput>');">
		</td>
	</tr>
	
<cfoutput query="rsSRM">
	<tr>
		<td align="right">
				<img src="/cfmx/sif/imagenes/Borrar01_S.gif" width="16" height="16"
					style="cursor:pointer;"
					onClick="sbBorrarMenu('#id_root#')"
				>
				<input type="checkbox" style="border:none;"
					<cfif default_menu EQ "1">
					checked
					onClick="return false;"
					<cfelse>
					onClick="return sbCambioMenuDefault('#id_root#',this.checked)"
					</cfif>
				>
		</td>
		<td colspan="2">
				&nbsp;#SMdescripcion#<BR>
		</td>
	</tr>
</cfoutput>
</table>
<script language="javascript">
	function sbCambioMenuDefault(id_root, Agregar)
	{
		if (Agregar)
		{
			if (!confirm("Sólo puede haber un Menú Default en el Grupo, si deja este como Default sustituirá al actual\n¿Desea sustituir este Menu como el Default del Grupo?"))
			{
				return false;
			}
			document.getElementById("id_root_default").value = id_root;
		}
		else
			document.getElementById("id_root_default").value = "-1";

		document.form1.submit();
		return true;
	}
	function sbBorrarMenu(id_root)
	{
		document.getElementById("id_root_borrar").value = id_root;
		document.form1.submit();
	}
</script>