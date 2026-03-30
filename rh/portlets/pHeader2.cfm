<cfquery name="rsUsuario" datasource="asp">
	select Pnombre ||''||Papellido1 ||''||Papellido2 as Nombre
	from DatosPersonales dp, Usuario u
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and dp.datos_personales = u.datos_personales
</cfquery>
<cf_templatecss>
<link href="/cfmx/sif/css/asp.css" rel="stylesheet" type="text/css">

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formatoCuenta">
		<tr>
			<td nowrap>  
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" >
					<tr>
						<td width="1%" class="tituloCuenta"  >
							<cf_leerimagen autosize="true" border="false" tabla="Empresa" campo="Elogo" condicion="Ecodigo = #Session.EcodigoSDC# and datalength(Elogo) > 1" conexion="asp" imgname="img">
						</td>
						<td align="left" nowrap><!---#Session.Enombre#---><b><font size="+1">Empresa Para prueba del Wizard</font></b></td>
					</tr>
				</table>
			</td>
			<td  nowrap style="height: 50; font-size: 18pt; font-family: Arial Black; color:##6C7ADD; ">#title#</td>
		</tr>
		
		<!---<tr><td class="tituloProceso" nowrap style="height: 50; font-size: 18pt; font-family: Arial Black; color:##6C7ADD; ">#title#</td></tr>	--->

		<tr><td colspan="2" class="tituloPersona" nowrap><a href="/cfmx/home/menu/micuenta/" title="Modificar datos de mi cuenta">#rsUsuario.Nombre#</a></td></tr>
	</table>
</cfoutput>