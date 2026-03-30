<cfexit>
<cfif NOT (isdefined("session.sitio.Ecodigo") and Len(session.sitio.Ecodigo) is 0)>
	<cfexit>
</cfif>
<table border="0" cellpadding="0" cellspacing="0" align="center" width="100%">
	<tr>
		<td colspan="3"> 
		<cfoutput>
			<table border="0" width="100%" <cfif isdefined("session.menues.PonerCuadro") and NOT session.menues.PonerCuadro>style="border-bottom: 1px solid ##333"<cfelse>style="background-color:##ccc;border:1px solid ##999; padding:4px; border-bottom: 2px solid ##333; border-right: 2px solid ##333"</cfif>>
			  <tr >
				<td valign="middle">&nbsp;
				<cfif isdefined("session.sitio.Ecodigo") and Len(session.sitio.Ecodigo) is 0>
					<!--- solamente pinto el logo si estamos SEGUROS de que la plantilla es multiempresa --->
					<cfquery datasource="asp" name="empresats">
						select ts_rversion, Elogo from Empresa
						where Ecodigo = #session.EcodigoSDC#
					</cfquery>
					<cfif Len(empresats.Elogo) gt 1>
						<cfinvoke 
						 component="sif.Componentes.DButils"
						 method="toTimeStamp"
						 returnvariable="tsurl">
							<cfinvokeargument name="arTimeStamp" value="#empresats.ts_rversion#"/>
						</cfinvoke>
						<img src="../public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" border="0">
					</cfif>
				</cfif>
				</td>
				<td style="font-size: 16px;">&nbsp;&nbsp;</td>
				<td style="font-size: 22px;" nowrap valign="middle">
				<strong>#session.Enombre#</strong>
				</td>
				<td style="font-size: 16px;" width="100%">&nbsp;</td>
				<td style="font-size: 12px;" nowrap align="right" valign="bottom">
				<cfif NOT isdefined("session.menues.PonerUsuario") OR session.menues.PonerUsuario NEQ false>
					<a href="/cfmx/home/menu/micuenta/">
					#session.datos_personales.nombre# 
					#session.datos_personales.apellido1# 
					#session.datos_personales.apellido2#</a>
				<cfelse>
				&nbsp;
				</cfif>
				</td>
			  </tr>
			</table>
		</cfoutput>
		</td>
	</tr>
</table>
