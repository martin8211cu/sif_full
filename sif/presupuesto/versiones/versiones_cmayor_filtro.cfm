<form name="flt" method="post" style="margin:0" action="/cfmx/sif/presupuesto/versiones/versionesComun.cfm">
<table>
	<tr>
		<td width="1%" nowrap>
			<input type="checkbox" name="chkSoloPresupuesto" value="1" onClick="form.submit();" <cfif isdefined("form.chkSoloPresupuesto")> checked </cfif>>
			Listar solo con Presupuesto
		</td>
		<td width="90%" align="right" nowrap>
			<img src='/cfmx/sif/imagenes/Base.gif' border='0'> Formular Presupuesto&nbsp;&nbsp; 
			<img src='/cfmx/sif/imagenes/checked.gif' border='0'> Ya existen cuentas definidas
		</td>
	</tr>
</table>

<input type="hidden" name="CVid" value="<cfoutput>#form.CVid#</cfoutput>">
</form>