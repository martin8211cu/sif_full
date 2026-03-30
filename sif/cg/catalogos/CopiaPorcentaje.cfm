
<cf_web_portlet_start border="true" titulo="Copia de Porcentajes de Oficina" skin="#Session.Preferences.Skin#">
<cfoutput>
	<form name="form1" action="SQLPorcentajesOficinas.cfm" method="post">
		<cfif isdefined ('url.PCCDclaid') and isdefined ('url.smes') and isdefined ('url.speriodo') and isdefined('url.PCCEclaid') and not isdefined('url.bandera2')>
			<input type="hidden" name="PCCDclaid" value="#url.PCCDclaid#">
			<input type="hidden" name="PCCEclaid" value="#url.PCCEclaid#">
			<input type="hidden" name="smes" value="#url.smes#">
			<input type="hidden" name="speriodo" value="#url.speriodo#">
			
			<table width="100%" align="center" border="0">
				<tr>
					<td align="right">
					<strong>Periodo:</strong></td>
					<td><cf_periodos></td>		  
				</tr>
				<tr>
					<td align="right">
					<strong>Mes:</strong></td>
					<td><cf_meses></td>		  
				</tr>
				<tr>
					<td align="center" colspan="2"><input name="copiar" id="copiar" value="Listo" type="submit" /></td>
				</tr>
			</table>
		
			<cfif isdefined ('url.bandera') and #url.bandera# eq 1>
				Para el periodo:#url.periodo# y el mes:#url.mes# no existen porcentajes de Oficina Procesados			
			</cfif>
		</cfif>
			<cfif isdefined ('url.bandera2')>
			<input type="hidden" name="PCCDclaid" value="#url.PCCDclaid#">
			<input type="hidden" name="PCCEclaid" value="#url.PCCEclaid#">
			<input type="hidden" name="smes" value="#url.smes#">
			<input type="hidden" name="speriodo" value="#url.speriodo#">
			<input type="hidden" name="mes" value="#url.mes#">
			<input type="hidden" name="periodo" value="#url.periodo#">
			<table width="100%">
			<tr><td align="center">
			<strong>Ya existen en el periodo y mes en el cual quiere insertar los datos,</br> desea sobreescribirlos</strong>			
			</td></tr>
			<tr><td align="center"><input name="sobre" id="sobre" value="Sobrescribir" type="submit" /></td></tr>
			</cfif>
		
	</form>
</cfoutput>
<cf_web_portlet_end>