<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
	<cfquery name="rsestatus" datasource="#session.DSN#">
		select coalesce(a.RHAprobado,0)  as RHAprobado 
        	, coalesce(a.RHOlistanegra,0)  as RHOlistanegra 
        from  DatosOferentes a 
		where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
	</cfquery>
</cfif>



<script language="javascript" type="text/javascript">
	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}
	
							

	
</script>
<table border="0" cellpadding="2" cellspacing="0" style="height: 24px;">
	<tr>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardar();">
			<img src="/cfmx/rh/imagenes/JSPInclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_GuardarInformacion">Guardar Informaci&oacute;n</cf_translate></font>
		</td>
		<td>|</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcContrasena();">
			<img src="/cfmx/rh/imagenes/E-Mail Link.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Enviar_Contrasena">Enviar Contrase&ntilde;a</cf_translate></font>
		</td>
		<td>|</td>
		<cfif isdefined("rsestatus") and rsestatus.RHAprobado eq 0>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcHabilitar();">
				<img src="/cfmx/rh/imagenes/w-check.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Habilitar_para_Consultas">Habilitar para Consultas</cf_translate></font>
			</td>
		<cfelse>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcDeshabilitar();">
				<img src="/cfmx/rh/imagenes/delete.small.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Deshabilitar_para_Consultas">Deshabilitar para Consultas</cf_translate></font>
			</td>
		</cfif>
		<td>|</td>
        <!---20140728 - ljimenez Lista Negra IICA--->
        <cfif isdefined("rsestatus") and rsestatus.RHOlistanegra eq 0>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcAddListaNegra();">
				<a class="btn btn-default sinBorde"><i class="fa fa-ban"></i> <cf_translate key="LB_AgregarListaNegra" xmlFile="curriculum.xml">Agregar a lista de bloqueados</cf_translate></a>
			</td>
		<cfelse>
			<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcDelListaNegra();">
				<a class="btn btn-default sinBorde"><i class="fa fa-check"></i> <cf_translate key="LB_EliminarListaNegra" xmlFile="curriculum.xml">Eliminar de lista de bloqueados</cf_translate></a>
			</td>
		</cfif>

	</tr>	
</table>
