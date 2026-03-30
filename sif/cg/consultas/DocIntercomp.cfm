<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select a.Ecodigo,a.Edescripcion
	from Empresas a 
	where a.cliente_empresarial = #session.CEcodigo#
</cfquery>


<cfquery name="rsPeriodo" datasource="#session.DSN#">
	select Speriodo 
	from CGPeriodosProcesados 
	where Ecodigo = #session.Ecodigo#
	group by Speriodo
	order by Speriodo desc
</cfquery>

<cfquery name="rsMes" datasource="#session.DSN#">
	select 
		case 
			when Smes =1 then 'Enero'
			when Smes =2 then 'Febrero' 
			when Smes =3 then 'Marzo' 
			when Smes =4 then 'Abril' 
			when Smes =5 then 'Mayo' 
			when Smes =6 then 'Junio' 
			when Smes =7 then 'Julio' 
			when Smes =8 then 'Agosto' 
			when Smes =9 then 'Septiembre' 
			when Smes =10 then 'Octubre' 
			when Smes =11 then 'Noviembre' 
			when Smes =12 then 'Diciembre' 
		end as SmesL,
		Smes
	from CGPeriodosProcesados 
	where Ecodigo = #session.Ecodigo#
	group by Smes
	order by 2
</cfquery>

<cf_templateheader title="Documentos Intercompañ&iacute;a">
	<cf_web_portlet_start titulo="Consulta de Documentos Intercompañ&iacute;a">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<form name="form1" action="DocIntercomp_lista.cfm" method="post">
			<cfoutput>
			<table width="100%"  border="0" align="center">
				<tr>
					<td style="width:50%">
						<fieldset><legend>Empresas</legend>
							<table> 
								<tr>
									<td align="right" nowrap><strong>Origen:&nbsp;</strong> </td>	
									<td colspan="3">					
										<select name="EcodigoOri" id="EcodigoOri" tabindex="1">
											<cfloop query="rsEmpresas">
												<option value="#rsEmpresas.Ecodigo#">#HTMLEditFormat(rsEmpresas.Edescripcion)#</option>
											</cfloop>
										</select>
									</td>	
								</tr>		
								<tr>
									<td align="right" nowrap><strong>Destino:&nbsp;</strong> </td>	
									<td colspan="3">					
										<select name="EcodigoDest" id="EcodigoDest" tabindex="1">
											<option value="-1">Todos</option>
											<cfloop query="rsEmpresas">
												<option value="#rsEmpresas.Ecodigo#">#HTMLEditFormat(rsEmpresas.Edescripcion)#</option>
											</cfloop>
										</select>
									</td>	
								</tr>
							</table>
						</fieldset>
					</td>
					<td style="width:50%">
						<fieldset><legend>Fechas</legend>	
							<table> 
								<tr>
									<td><strong>Periodo:</strong>&nbsp;</td>
								  	<td>

										<select name="Periodo">
											<cfloop query="rsPeriodo">
												<option value="#rsPeriodo.Speriodo#">#rsPeriodo.Speriodo#</option>
											</cfloop>
										</select>
									</td>
								</tr>
								<tr>
									<td><strong>Mes:&nbsp;</strong></td>
									<td>
										<select name="Mes">
											<cfloop query="rsMes">
												<option value="#Smes#">#SmesL#</option>
											</cfloop>
										</select>
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center" colspan="4"><cf_botones values="Consultar" tabindex="1"></td></tr>
			</table>
			</cfoutput>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>