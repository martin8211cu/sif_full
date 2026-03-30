<script language="javascript1.2" type="text/javascript">
	var popUpWinfg = 0;
	function popUpWindowfg(URLStr, left, top, width, height){
		if(popUpWinfg){
			if(!popUpWinfg.closed) popUpWinfg.close();
		}
		popUpWinfg = open(URLStr, 'popUpWin2fg', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		var params ="";
		params = "?id_inst=<cfoutput>#form.id_inst#</cfoutput>&id_grupo=<cfoutput>#form.id_grupo#</cfoutput>";
		popUpWindowfg("/cfmx/home/tramites/Catalogos/conlisFuncionarios.cfm"+params,250,200,650,400);
	}
</script>

<cfquery name="dataf" datasource="#session.tramites.dsn#">
	select fg.id_funcionario, nombre ||' '|| apellido1 ||' '|| apellido2 as nombre
	from TPFuncionarioGrupo fg
	
	inner join TPFuncionario f
	on f.id_funcionario = fg.id_funcionario
	and f.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between f.vigente_desde and vigente_hasta
	
	inner join TPPersona p
	on p.id_persona = f.id_persona
	
	where id_grupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_grupo#">
	order by nombre
</cfquery>

<table width="98%" align="center">
<tr><td class="tituloMantenimiento"><font size="1">Funcionarios asociados al grupo</font></td></tr>
</table> 
<form name="formfg" action="funcionarios-grupo-sql.cfm" method="post" style="margin:0;">
	<cfoutput>
	<input type="hidden" name="id_inst" value="#form.id_inst#">
	<input type="hidden" name="id_grupo" value="#data.id_grupo#">
	</cfoutput>
	<table width="85%" align="center" cellpadding="2" cellspacing="0">
		<tr><td colspan="2">
			<table width="100%" style="border:1px solid gray;"  bgcolor="#F5F5F5" cellpadding="4" cellspacing="0">
				<tr>
					<td align="right"><strong>Funcionario:</strong>&nbsp;</td>
					<td>
						<input type="hidden" name="id_funcionario" value="">
						<input type="text" size="50" disabled name="nombre" value="">
						<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Centros Funcionales" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlis();'></a>
					</td>
					<td><input type="submit" name="Agregar" value="Agregar" onClick="javascript: if( document.formfg.id_funcionario.value ==''){alert('Seleccione el funcionario.'); return false;}; return true; "></td>
				</tr>
			</table>
		</td></tr>

		<tr>
			<td class="tituloListas">Funcionario</td>
			<td class="tituloListas">&nbsp;</td>
		</tr>
		<cfif dataf.recordcount gt 0>
			<cfoutput query="dataf">
			<tr>
				<td nowrap>#dataf.nombre#</td>
				<td><input border="0" type="image" name="Eliminar" value="#dataf.id_funcionario#" src="/cfmx/home/tramites/images/Borrar01_S.gif" onClick="javascript:return confirm('Desea eliminar el registro?');"></td>
			</tr>
			</cfoutput>
		<cfelse>
			<tr><td colspan="2" align="center">- No se encontraron registros-</td></tr>
		</cfif>
	</table>
</form>