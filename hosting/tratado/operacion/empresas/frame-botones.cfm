
<script language="javascript" type="text/javascript">
	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}
	

	
</script>
<table border="0" cellpadding="2" cellspacing="0" style="height: 24px;">
	<cfif not isdefined("form.ETLCid")>

		<tr>
			<td class="botonUp" valign="bottom" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcAgregar();">
				<img width="17" height="17" src="../../images/media-floppy.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Agregar">Agregar</cf_translate></font>
			</td>
			<td>|</td>
			<td class="botonUp" valign="bottom" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcLimpiar();">
				<img width="17" height="17" src="../../images/edit-clear.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Limpiar">Limpiar</cf_translate></font>
			</td>
			<td>|</td>
			<td class="botonUp" valign="bottom" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcRegresar();">
				<img width="17" height="17" src="../../images/system-log-out.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Regresar">Regresar</cf_translate></font>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td class="botonUp" valign="bottom" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcModificar();">
				<img width="17" height="17" src="../../images/media-floppy.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Modificar">Modificar</cf_translate></font>
			</td>
			<td>|</td>
			<cfif isdefined("rs.ETLCespecial") and len(trim(rs.ETLCespecial)) and rs.ETLCespecial eq 0 > 
                <td class="botonUp" valign="bottom" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcEliminar();">
                    <img width="17" height="17" src="../../images/emblem-unreadable.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Eliminar">Eliminar</cf_translate></font>
                </td>
                <td>|</td>
			</cfif>
			<td class="botonUp" valign="bottom" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcNuevo();">
				<img width="17" height="17" src="../../images/text-x-generic.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Nuevo">Nuevo</cf_translate></font>
			</td>
			<td>|</td>
			<td class="botonUp" valign="bottom" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcPersonas();">
				<img width="17" height="17" src="../../images/personas.JPG" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Personas">Personas</cf_translate></font>
			</td>
           <!---  <cfif isdefined("rs.ETLCespecial") and len(trim(rs.ETLCespecial)) and rs.ETLCespecial eq 0 >
                <td>|</td>
                <td class="botonUp" valign="bottom" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcRegresar();">
				<img width="17" height="17"  src="../../images/Insert Record.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Formato">Formato de Importaci&oacute;n de personas</cf_translate></font>

                </td>
			</cfif> --->
            
			<td>|</td>
			<td class="botonUp" valign="bottom" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcRegresar();">
                    <img width="17" height="17"  src="../../images/system-log-out.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Regresar">Regresar</cf_translate></font>
			</td>
		</tr>
	</cfif>
</table>
