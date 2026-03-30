<cfset LvarIrARPresumenConciliacion = "/cfmx/sif/mb/operacion/RPresumenConciliacion.cfm">
<cfset LvarIrAConciliacionResumida = "ConciliacionResumida.cfm">
<cfset LvarIrAformConciliacionResumida = "/sif/mb/consultas/formConciliacionResumida.cfm">
<cfset LvarCBesTCE = 0>
<cfif isdefined("LvarformConciliacionResumida")>
	<cfset LvarIrARPresumenConciliacion = "/cfmx/sif/tce/operaciones/TCEOperaRPresumenConciliacion.cfm">
	<cfset LvarIrAConciliacionResumida = "ConciliacionResumidaTCE.cfm">
	<cfset LvarIrAformConciliacionResumida = "/sif/tce/consultas/formConciliacionResumidaTCE.cfm">
	<cfset LvarCBesTCE = 1>
</cfif>

<cfif isdefined('url.EChasta')>
	<cfset form.EChasta = url.EChasta>
</cfif>
<cfif isdefined('url.ECid')>
	<cfset form.ECid  = #url.ECid#>
</cfif>

<cfset Title           = "Reporte de Saldos de Cuentas Bancarias al #LSDateFormat(form.EChasta,'dd/mm/yyyy')#">
<cfset FileName        = "SaldosCuentasBancarias">
<cfset FileName 	   = FileName &".xls">
<cf_htmlreportsheaders title="#Title#" filename="#FileName#" download="yes" ira="#LvarIrAConciliacionResumida#">

<cfset vparams ="">
<cfset vparams = vparams & "&EChasta=" & form.EChasta>

<!--- CONSULTAS --->
<!--- 1. Datos de la empresa --->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!--- 2. Estado de Cuenta a Consultar>--->
<cfquery name="rsDatosEncab" datasource="#session.DSN#">
	select ECid,Bdescripcion, CBdescripcion, CBcodigo,ECdescripcion,ECsaldoini , ECdebitos, ECcreditos, ECsaldofin,
			ec.CBid,EChasta, ec.Bid, Msimbolo, cb.Ocodigo, o.Odescripcion,
			<cf_dbfunction name="date_part" args="mm,EChasta"> as mes, 
			<cf_dbfunction name="date_part" args="yyyy,EChasta"> as periodo
	from ECuentaBancaria ec
	inner join CuentasBancos cb
	   on cb.Bid = ec.Bid
	  and cb.CBid = ec.CBid
	  <cfif #form.Conciliaciones# eq 1>
	  	and ec.ECaplicado = 'S'
	  <cfelseif #form.Conciliaciones# eq 2>
	  	and ec.ECaplicado = 'N'
	  </cfif>	
	inner join Bancos b
	   on cb.Ecodigo = b.Ecodigo
	  and cb.Bid = b.Bid
	 inner join Monedas m 
		on m.Mcodigo=cb.Mcodigo
		and m.Ecodigo=cb.Ecodigo
	inner join Oficinas o
		on o.Ocodigo=cb.Ocodigo
		and o.Ecodigo=cb.Ecodigo 	
	  and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	where ec.EChasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EChasta)#">
    	and cb.CBesTCE = <cfqueryparam value="#LvarCBesTCE#" cfsqltype="cf_sql_bit">  
	order by cb.Ocodigo,ec.Bid, cb.Mcodigo
</cfquery>

<cfif isdefined('rsDatosEncab') and rsDatosEncab.RecordCount GT 0>
	<cfset form.ECid  = rsDatosEncab.ECid>
</cfif>



<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<form name="form1" method="post">

<cfset var="#form#">            
<cfif isdefined('form.ECid') and LEN(TRIM(form.ECid))>
	<!--- ============================================================================================================ --->
	<!---                                            Encabezado del Reporte                                            --->
	<!--- ============================================================================================================ --->		
	
	<cfoutput>
		<table  width="90%"  align="center" border="0">
			<tr>
            	<td align="right"><font size="1"><strong>#LSDateFormat(Now(),'dd/mm/yyyy')#</strong></font></td>
            </tr>
            <tr>
				<td align="center"><font size="4"><strong>#rsEmpresa.Edescripcion#</strong></font></td>
			</tr>
			<tr>
				<td align="center"><font size="3"><strong>Saldo de Cuentas Bancarias al #LSDateFormat(form.EChasta,'dd/mm/yyyy')#</strong></font></td>
			</tr>
			<tr><td align="center">
				<font size="3"><strong> Conciliaciones: 
					<cfif #form.Conciliaciones# eq -1>Todas	<cfelseif #form.Conciliaciones# eq 1>Aplicadas<cfelseif #form.Conciliaciones# eq 2>	NO Aplicadas</cfif>	
				</strong></font>
			</td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
	</cfoutput>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center">	

		<!--- ============================================================================================================ --->
		<!---                                                Datos del Reporte                                             --->
		<!--- ============================================================================================================ --->		

		<tr><td colspan="2">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center" >
							<tr>
								<td width="50%" valign="top">
									<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center" >
										
										<cfoutput query="rsDatosEncab" group="Ocodigo">	
											<tr>
												<td align="left"><span style="font-size:16px;"><strong>Oficina</strong></span></td>
												<td align="left"><span style="font-size:16px;"><strong>#rsDatosEncab.Odescripcion#</strong></span></td>
											</tr>
										
											<tr bgcolor="E2E2E2">
												<td align="left"><span style="font-size:12px;"><strong>Banco</strong></span></td>
												<td align="left"><span style="font-size:12px;"><strong>No. Cuenta</strong></span></td>
												<td align="left"><span style="font-size:12px;"><strong>Descripcion</strong></span></td>
												<td align="left"><span style="font-size:12px;"><strong>Moneda</strong></span></td>
												<td align="right"><span style="font-size:12px;"><strong>Saldo según Libros</strong></span></td>
												<td align="right"><span style="font-size:12px;"><strong>Saldo según Bancos</strong></span></td>
												<td align="right"><span style="font-size:12px;"><strong>Saldo Conciliado</strong></span></td>
												<cfif not isdefined("url.imprimir")><td align="right"></td></cfif>
											</tr>
										
											<cfoutput>	
												<cfquery name="rsSaldoLibros" datasource="#Session.DSN#">
													select round(coalesce((
																select sum(sb.Sinicial)
																 from SaldosBancarios sb
																where sb.CBid = #rsDatosEncab.CBid#       <!---Cuenta Bancaria del Estado de Cuenta--->
																and Periodo   = #rsDatosEncab.periodo#    <!---Año del Estado de Cuenta--->
																and Mes       = #rsDatosEncab.mes#        <!---Mes del Estado de Cuenta--->
																),0.00)
														+ 
														coalesce((select sum(MLmonto * case when MLtipomov = 'D' then 1 else -1 end) 
																	from MLibros
																	where CBid    = #rsDatosEncab.CBid#      <!--- Cuenta Bancaria del Estado de Cuenta--->
																	and MLperiodo = #rsDatosEncab.periodo#   <!--- Año del Estado de Cuenta--->
																	and MLmes     = #rsDatosEncab.mes#       <!--- Mes del Estado de Cuenta--->
																	and MLfecha   <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosEncab.EChasta#">  <!--- Fecha del Estado de Cuenta (Fecha Hasta)--->
																	) , 0.00),2) as Saldo 
													from dual
												</cfquery>
												
												<cfif rsSaldoLibros.recordCount GT 0>
													<cfset SaldoLibros = rsSaldoLibros.Saldo>
												<cfelse>
													<cfset SaldoLibros = 0.00>
												</cfif>
												
												<cfquery name="rsResumenConcBancos" datasource="#Session.DSN#">
													select c.Bid, c.BTEcodigo, 
														case c.BTEtipo when 'D' then '+' when 'C' then '-' else '' end as SumaResta,
														c.BTEdescripcion, 
														count(b.BTEcodigo) as Cantidad, 
														round(coalesce(sum(cd.CDBmonto), 0.00),2) as Despliegue, 
														round(coalesce(sum(cd.CDBmonto), 0.00),2) as Suma 
													from CDBancos cd, DCuentaBancaria b, TransaccionesBanco c
													where cd.ECid 			= #rsDatosEncab.ECid#
													and cd.CDBconciliado 	= 'N'
													and cd.CDBgrupo is null
													and cd.CDBlinea 	   	= b.Linea
													and b.Bid 		  		= c.Bid
													and b.BTEcodigo 	   	= c.BTEcodigo
													group by c.Bid, c.BTEcodigo, c.BTEdescripcion, c.BTEtipo, case c.BTEtipo when 'D' then '+' when 'C' then '-' else '' end
												</cfquery>
												<cfquery name="rsDebitosBancos" dbtype="query">
													select sum(Suma) as Suma from rsResumenConcBancos where SumaResta = '+'
												</cfquery>
												<cfif rsDebitosBancos.recordCount GT 0>
													<cfset DebitosBancos = rsDebitosBancos.Suma>
												<cfelse>
													<cfset DebitosBancos = 0.00>
												</cfif>
												<cfquery name="rsCreditosBancos" dbtype="query">
													select sum(Suma) as Suma from rsResumenConcBancos where SumaResta = '-'
												</cfquery>
												<cfif rsCreditosBancos.recordCount GT 0>
													<cfset CreditosBancos = rsCreditosBancos.Suma>
												<cfelse>
													<cfset CreditosBancos = 0.00>
												</cfif>
												
												<cfset sumaFinal = SaldoLibros+DebitosBancos-CreditosBancos>
																				
												<tr>
													<td>#rsDatosEncab.Bdescripcion#</td>
													<td>#rsDatosEncab.CBcodigo#</td>
													<td>#rsDatosEncab.CBdescripcion#</td>
													<td>#rsDatosEncab.Msimbolo#</td>
													<td align="right">#LSCurrencyFormat(rsSaldoLibros.Saldo,'none')#</td>
													<td align="right">#LSCurrencyFormat(rsDatosEncab.ECsaldofin,'none')#</td>
													<td align="right">#LSCurrencyFormat(sumaFinal,'none')#</td>
													<cfif not isdefined("url.imprimir")>
														<td align="right">
															<a href="javascript: IrImprimir(#rsDatosEncab.ECid#);" tabindex="-1"> 
																<img src="/cfmx/sif/imagenes/impresora2.gif" 
																	name="Img_Cambio" 
																	border="0" title="Imprimir Resumen de conciliacion" 
																	>
															</a>
														</td>	
													</cfif>	
												</tr>
											</cfoutput>
										</cfoutput>
									</table>	
								</td>
								<td width="1%"></td>
							</tr>
							<tr><td class="bottomline" colspan="3">&nbsp;</td></tr>
						</table>	
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>									
				<tr><td>&nbsp;</td></tr>
			</table>
		</td></tr>
	
		
	<!--- ============================================================================================================ --->
	<!---                                               Pie del Reporte                                                --->
	<!--- ============================================================================================================ --->		
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr> 
		<td colspan="2"><div align="center">------------------ Fin del Reporte ------------------</div></td>
	</tr>	
<cfelse>
	<tr> 
		<td colspan="2"><div align="center">------------------ No hay datos relacionados ------------------</div></td>
	</tr>
	<tr> 
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr> 
		<!---Utilizar en Bancos con ConciliacionResumida.cfm o en TCE con ConciliacionResumidaTCE.cfm--->
		<td colspan="2"><div align="center"><input type="button" value="Nueva Consulta" onclick="location='<cfoutput>#LvarIrAConciliacionResumida#</cfoutput>'"/></div></td>
	</tr>
</cfif>
</table>
</form>
<script language="JavaScript" type="text/javascript">
function IrImprimir(llave){
		<!---Utilizar en Bancos con RPresumenConciliacion.cfm o en TCE con RPresumenConciliacionTCE.cfm--->
		var PARAM  = "<cfoutput>#LvarIrARPresumenConciliacion#</cfoutput>?ECid="+ llave+"&imprimir="+true+"&detalles="+true
		var x = open(PARAM,'Resumen_Conciliado','left=200,top=250,scrollbars=yes,resizable=yes,width=1000,height=450');
		x.focus();
	}
</script>
