<!--- determina la pantalla a la que Ingresa --->
<cfset pagina = #GetFileFromPath(GetTemplatePath())#>
<cfif pagina EQ "wizGeneral01.cfm">
	<cfset titulo = ": Par&aacute;metros Generales" >
	<cfset pasoImg = "/cfmx/asp/imagenes/menu/num1_large.gif">
<cfelseif pagina eq 'wizGeneral02.cfm'>
	<cfset titulo = ": Cat&aacute;logo Contable" >
	<cfset pasoImg = "/cfmx/asp/imagenes/menu/num2_large.gif">
<cfelseif pagina eq 'wizConfirma.cfm'>
	<cfset titulo = ": Confirmaci&oacute;n" >
	<cfset pasoImg = "">
<cfelseif pagina eq 'wizBienvenida.cfm'>
	<cfset titulo = " Financiero Integral" >
	<cfset pasoImg = "">
</cfif>

<cfquery name="rsUsuario" datasource="asp">
	select {fn concat({fn concat({fn concat({fn concat(Pnombre , '-')}, Papellido1)}, ' ')}, Papellido2)} as Nombre
	from DatosPersonales dp 
	inner join Usuario u
	on dp.datos_personales = u.datos_personales
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>

<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="1%" rowspan="3" align="center" valign="middle"><cfif isdefined("pasoImg") and len(trim(pasoImg)) gt 0><img border="0" src="#pasoImg#"><cfelse>&nbsp;</cfif></td>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="formatoCuenta">
					<tr>
						<td class="tituloCuenta"  >
							<cfif isdefined("session.sitio.Ecodigo") and Len(session.sitio.Ecodigo) is 0>
								<cfquery datasource="asp" name="empresats">
									select Elogo, ts_rversion from Empresa
									where Ecodigo = #session.EcodigoSDC#
								</cfquery>
								<cfif Len(empresats.Elogo) GT 1>
									<cfinvoke component="sif.Componentes.DButils"
											  method="toTimeStamp"
											  returnvariable="tsurl">
										<cfinvokeargument name="arTimeStamp" value="#empresats.ts_rversion#"/>
									</cfinvoke>
									<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&ts=#tsurl#"  border="0">
								</cfif>
							</cfif>
						</td>
						<td class="tituloCuenta"  align="left" nowrap>#Session.Enombre#</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr><td nowrap style="height: 50; font-size: 18pt; font-family: Arial Black; color:##6C7ADD; ">Configuración del Sistema#titulo#</td></tr>	
		<tr><td class="tituloPersona" nowrap>#rsUsuario.Nombre#</td></tr>	
		
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr bgcolor="##A0BAD3"><td width="24px;" colspan="2"><font color="##A0BAD3" size="+1">M</font></td></tr>
	</table>
</cfoutput>