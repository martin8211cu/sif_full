<cfquery name="data"  datasource="asp">
	select 	a.Rid, 
			a.Rtipo, 
			a.Rproducto, 
			a.Rareacomercial, 
			a.Rnombreemp, 
			a.Rnumemp, 
			a.Rescucho, 
			a.Observaciones, 
			a.Rrol,
			b.Pnombre, Papellido1, Papellido2,
			b.Pid,
			a.datos_personales
	from ReqInfo a
	
	inner join DatosPersonales b
	on a.datos_personales=b.datos_personales

	where not exists ( select 1 from Usuario u where u.datos_personales = a.datos_personales )
	order by a.Rproducto, b.Pnombre, Papellido1, Papellido2
</cfquery>

<table align="center" width="99%" cellpadding="2" cellspacing="0">
	<tr><td align="center"><strong><font size="2">Autorizaci&oacute;n de Demos</font></strong></td></tr>
</table>

<cfif data.recordcount gt 0 >
	<cfset sistemas = structnew() >
	<cfset structinsert(sistemas,'RH', 'Recursos Humanos') >
	<cfset structinsert(sistemas,'SIF', 'Sistema Financiero Integral') >
	<cfset structinsert(sistemas,'Educacion', 'Educación') >
	
	<form name="form1" action="autoriza-demo-sql.cfm" method="post" onSubmit="return validar(this);" style="margin:0; ">
	<table align="center" width="99%" cellpadding="2" cellspacing="0">
		<cfoutput query="data" group="Rproducto">
			<tr><td colspan="5" class="tituloCorte">#data.Rproducto# - #sistemas[data.Rproducto]#</td></tr>
			<tr class="tituloListas" style="padding:3px; ">
				<td width="1%"></td>
				<td style="padding:3px; "><strong>Identificaci&oacute;n</strong></td>
				<td style="padding:3px; "><strong>Solicitante</strong></td>
				<td style="padding:3px; "><strong>Empresa</strong></td>
				<td style="padding:3px; "><strong>Area Comercial</strong></td>
			</tr>
			<cfset i = 0 >
			<cfoutput>
				<tr class="<cfif i mod 2>listaPar<cfelse>listaNon</cfif>" onmouseover="this.className='listaParSel';" onmouseout="<cfif i mod 2>this.className='listaPar';<cfelse>this.className='listaNon';</cfif>"  >
					<td><input type="radio" name="chk" value="#data.Rid#"></td>
					<td>#data.Pid#</td>
					<td>#data.Pnombre# #data.Papellido1# #data.Papellido2#</td>
					<td>#data.Rnombreemp#</td>
					<td>#data.Rareacomercial#</td>
				</tr>
				<cfset i = i + 1 >
			</cfoutput>
		</cfoutput>
		<tr><td></td></tr>
		<tr><td colspan="5" align="center">
			<input type="submit" name="autorizar" value="Autorizar">
			<input type="submit" name="rechazar" value="Rechazar">
		</td></tr>
		<tr><td></td></tr>
	</table>
	</form>
	
	<script language="javascript1.2" type="text/javascript">
		function validar(f){
			var continuar = false;
	
			if (f.chk) {
				if (f.chk.value) {
					continuar = f.chk.checked;
					solID = f.chk.value;
				}
				else {
					for (var k = 0; k < f.chk.length; k++) {
						if (f.chk[k].checked) {
							continuar = true;
							break;
						}
					}
				}
				if (!continuar) { alert('Se presentaron los siguientes errores: \n  - Debe seleccionar al menos un registro.'); }
			}
			else {
				alert('No existen registros para procesar')
			}
	
			return continuar;
		}
	</script>
<cfelse>
	<br>
	<table width="100%" cellpadding="0" cellspacing="0" >
		<tr class="tituloListas" style="padding:3px; ">
			<td style="padding:3px; "><strong>Identificaci&oacute;n</strong></td>
			<td style="padding:3px; "><strong>Solicitante</strong></td>
			<td style="padding:3px; "><strong>Empresa</strong></td>
			<td style="padding:3px; "><strong>Area Comercial</strong></td>
		</tr>

		<tr><td align="center" colspan="4">- No se encontraron registros -</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="4" align="center"><input type="button" name="regresar" value="Regresar" onClick="javascript:location.href='';"></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</cfif>