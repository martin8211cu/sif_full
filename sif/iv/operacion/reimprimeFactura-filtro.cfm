<cfif isdefined("url.fDreferencia") and len(url.fDreferencia) and not isdefined("form.fDreferencia")><cfset form.fDreferencia= url.fDreferencia></cfif>
<cfif isdefined("url.SNcodigo") and len(url.SNcodigo) and not isdefined("form.SNcodigo")><cfset form.SNcodigo = url.SNcodigo></cfif>
<cfif isdefined("url.fEDAfecha") and len(url.fEDAfecha) and not isdefined("form.fEDAfecha")><cfset form.fEDAfecha = url.fEDAfecha></cfif>

<form style="margin: 0" action="reimprimeFactura.cfm" name="form1" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
		<tr> 
			<td nowrap width="1%" align="right">
				<strong>Referencia:&nbsp;</strong>
			</td>	
			<td nowrap width="1%">
				<input type="text" name="fDreferencia" size="10" maxlength="20" value="<cfif isdefined('form.fDreferencia')><cfoutput>#form.fDreferencia#</cfoutput></cfif>"  >
			</td>
			<td nowrap width="1%" align="right">
				<strong>Socio de Negocios:&nbsp;</strong>
			</td>
			<td>
				<cfset idquery=''>
				<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))><cfset idquery = form.SNcodigo></cfif>
				<cf_sifsociosnegocios2 idquery="#idquery#" >
			</td>
			<td align="right"><strong>Fecha:&nbsp;</strong></td>
			<td>
				<cfif isdefined('form.fEDAfecha')>
					<cf_sifcalendario conexion="#session.DSN#"  name="fEDAfecha" value="#form.fEDAfecha#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#"  name="fEDAfecha" value="">
				</cfif>
			</td>

			<td align="center" colspan="2"><input type="submit" name="btnFiltro"  value="Ver Resultados"></td>
		</tr>

	</table>
</form>
