<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

		<cf_templatecss>
		<cf_web_portlet_start titulo="Errores">
		<!---<cfinclude template="/rh/portlets/pNavegacion.cfm">--->

		<cfquery name="datos_escenario" datasource="#session.DSN#">
			select RHEdescripcion, RHEfdesde as desde, RHEfhasta as hasta
			from RHEscenarios
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfquery name="data" datasource="#session.DSN#" >
			select formato
			from #ValidaCF#
			order by formato
		</cfquery>
		<table width="95%" align="center" cellpadding="2" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr><td align="left"><font size="2"><strong>Errores en proceso de Aprobaci&oacute;n de Escenario</strong></font></td></tr>
			<tr>
				<td>
					<cfoutput>
					<table width="100%" align="center" cellpadding="2" cellspacing="0">
						<tr>
							<td width="1%"><strong>Escenario:</strong>&nbsp;</td>
							<td>#datos_escenario.RHEdescripcion#</td>
						</tr>
						<tr>
							<td width="1%" nowrap="nowrap"><strong>Fecha Inicio:</strong>&nbsp;</td>
							<td>#LSDateFormat(datos_escenario.desde, 'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<td width="1%" nowrap="nowrap"><strong>Fecha Final:</strong>&nbsp;</td>
							<td>#LSDateFormat(datos_escenario.hasta, 'dd/mm/yyyy')#</td>
						</tr>

					</table>
					</cfoutput>
				</td>
			</tr>

			<tr><td><hr size="1" /></td></tr>			

			<cfif isdefined("data")>
				<tr>
					<td><font size="2"><strong>Los siguientes formatos de cuenta no corresponden a Cuentas Presupuestarias v&aacute;lidas:</strong></font></td>
				</tr>

				<tr>
					<td>
						<!---<div style="overflow:auto; height:<cfif valida_montos.recordcount gt 50>350px;<cfelse>75px;</cfif>  border-style:solid; border: #e5e5e5 SOLID 1PX;"    >--->
						<table width="100%" cellpadding="2" cellspacing="0" align="center" style=" border: #e5e5e5 SOLID 1PX;">
							<tr>
								<td class="tituloListas" >Formato de Cuenta</td>
							</tr>
								<cfoutput query="data" >
								<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
									<td>#trim(data.formato)#</td>
								</tr>
								</cfoutput>
						</table>
						<!---</div>--->
					</td>
				</tr>
			</cfif>
			
			<tr><td align="center">
			<cfoutput>
			<form name="form3" method="post" action="TrabajarEscenario.cfm" >
			<input type="hidden" name="RHEid" value="#form.RHEid#" />
			<input type="submit" name="Regresar" value="Regresar" />
			</form>
			</cfoutput>
			</td></tr>
		</table>
		
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
