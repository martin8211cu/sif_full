<style>
	td{ font-family:Arial, Helvetica, sans-serif; font-size:12px;}
</style>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeSalariosPorBanco" Default="Reporte de Salarios por Banco" returnvariable="LB_ReporteDeSalariosPorBanco"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NominaDel" Default="N&oacute;mina del" returnvariable="LB_NominaDel"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_al" Default="al" returnvariable="LB_al"/>	
<cfset vs_pefijo = 'H'>
<cfif isdefined("form.TipoNomina")><!---Son  nominas aplicadas (Historicas)--->
	<cfset vnCPid = form.CPid1>
<cfelse>
	<cfset vnCPid = form.CPid2>
	<cfset vs_pefijo = ''>
</cfif>

<cfif isdefined("vnCPid") and len(trim(vnCPid))>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select 	case when c.Bid = 3 then
					d.DEcuenta 
				else
					coalesce(d.CBcc,d.DEcuenta) 
				end as Cuenta, 			
				<cf_dbfunction name="concat" args="d.DEapellido1,' ',d.DEapellido2,' ',d.DEnombre"> as empleado,
				coalesce(c.#vs_pefijo#DRNliquido,0) as monto,
				c.Bid,
				e.Bdescripcion,
				a.CPdesde,
				a.CPhasta				
		from CalendarioPagos a
			inner join #vs_pefijo#ERNomina b
				on a.CPid = b.RCNid
			inner join #vs_pefijo#DRNomina c
				on b.ERNid = c.ERNid
				and c.#vs_pefijo#DRNliquido > 0 
				<cfif isdefined("form.Bid") and len(trim(form.Bid))>
					and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
				</cfif>				
			inner join DatosEmpleado d
				on c.DEid = d.DEid
			inner join Bancos e
				on c.Bid = e.Bid
				and b.Ecodigo = e.Ecodigo	
		where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnCPid#">
		order by c.Bid, <cf_dbfunction name="concat" args="d.DEapellido1,' ',d.DEapellido2,' ',d.DEnombre">
	</cfquery>
	
	<cfset LvarFileName = "SalariosPorLugarDePago#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<cfset vn_total = 0>
	<cfset vn_cont = 0>
	
	<cf_htmlReportsHeaders 
		title="#LB_ReporteDeSalariosPorBanco#" 
		filename="#LvarFileName#"
		irA="repSalarioLugarPago-filtro.cfm">
		
	<table width="98%" cellpadding="0" cellspacing="0" align="center" border="0">		
		<cfif rsDatos.RecordCount NEQ 0>
			<tr>
				<td valign="top">
					<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" style="vertical-align:top;">						
						<cfoutput query="rsDatos" group="Bid">														
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan="3" valign="top">
									<table width="100%" cellpadding="0" cellspacing="0" align="center">
										<tr><td>
											<cfset filtro1 = '#LB_NominaDel#: #LSDateFormat(rsDatos.CPdesde,'dd/mm/yyyy')# #LB_al#: #LSDateFormat(rsDatos.CPhasta,'dd/mm/yyyy')#'>
											<cf_EncReporte
												Titulo="#LB_ReporteDeSalariosPorBanco#"												
												Color="##E3EDEF"
												filtro1="#filtro1#"
											>											
										</td></tr>
									</table>								
								</td>
							</tr>
							<tr>							
								<td colspan="3" bgcolor="##F1F1F1" valign="top">
									<strong><cf_translate key="LB_LugarDePago">Lugar de Pago</cf_translate>:&nbsp;#rsDatos.Bdescripcion#</strong>
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td valign="top"><strong><cf_translate key="LB_NumeroDeCuenta">N&uacute;mero de Cuenta</cf_translate></strong></td>
								<td valign="top"><strong><cf_translate key="LB_NombreFuncionario">Nombre del Funcionario</cf_translate></strong></td>
								<td valign="top" align="right"><strong><cf_translate key="LB_Monto">Monto</cf_translate></strong></td>
							</tr>
							<cfset vn_total = 0>
							<cfoutput>								
								<tr>
									<td valign="top">#rsDatos.Cuenta#</td>
									<td valign="top">#rsDatos.empleado#</td>
									<td valign="top" align="right">#LSNumberFormat(rsDatos.monto,'999,999,999,999.99')#</td>
								</tr>
								<cfset vn_total = vn_total + rsDatos.monto>
								<cfset vn_cont = vn_cont+1>
							</cfoutput>
							<tr>
								<td colspan="2" align="right">
									<strong><cf_translate key="LB_Total">Total</cf_translate>:&nbsp;</strong>
								</td>
								<td valign="top" align="right" style="border-top:1px solid black;"><strong>#LSNumberFormat(vn_total,'999,999,999,999.99')#</strong></td>
							</tr>
							<cfif vn_cont LTE rsDatos.RecordCount>
								<tr><td style="page-break-after:always;"></td></tr>							
							</cfif>
						</cfoutput>
					</table>
				</td>
			</tr>
		<cfelse>
			<tr><td align="center"><strong>---- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ----</strong></td></tr>	
		</cfif>
	</table>	
</cfif>