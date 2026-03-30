
<cfset LvarIrARPresumenConciliacion = "/cfmx/sif/tce/operaciones/TCEOperaRPresumenConciliacion.cfm">
<cfset LvarIrAConciliacionResumida = "ConciliacionResumidaTCE.cfm">
<cfset LvarCBesTCE = 1>
<cfset etiquetaCuenta = "No. Tarjeta">

<cfif isdefined('url.EChasta')>
	<cfset form.EChasta = url.EChasta>
</cfif>
<cfif isdefined('url.ECid')>
	<cfset form.ECid  = #url.ECid#>
</cfif>
<cfif isdefined('url.Periodo')>
	<cfset form.Periodo = url.Periodo>
</cfif>
<cfif isdefined('url.mes')>
	<cfset form.mes = url.mes>
</cfif>

<cfif isdefined("form.Rango") and form.Rango EQ 'PeriodoMes'>
	<cfset FechaInicio = createdate(form.Periodo,form.mes,1)>
    <cfset FechaFin = createdate(form.Periodo,form.mes,1)>
    <cfset FechaFin = DateAdd("m",1,FechaFin)>
	<cfset FechaFin = DateAdd("d",-1,FechaFin)>
	<cfset FechaFin = DateAdd("h",23,FechaFin)>
	<cfset FechaFin = DateAdd("n",59,FechaFin)>
	<cfset FechaFin = DateAdd("s",59,FechaFin)>
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
	select 
    			ECid,Bdescripcion, 
                CBdescripcion, 
                CBcodigo,
                ECdescripcion,
                ECsaldoini , 
                ECdebitos, 
                ECcreditos, 
                ECsaldofin,
                ec.ECaplicado,
				ec.CBid,
                ECdesde,
                EChasta, 
                ec.Bid, 
				Miso4217 as Msimbolo, 
                cb.Ocodigo, 
                o.Odescripcion, 
                ECaplicado,
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
	where 
    	<cfif isdefined('form.Rango') and form.Rango EQ 'PeriodoMes'>
            ec.EChasta 
            between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaInicio#">
            and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaFin#">
        <cfelse>
        	ec.EChasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EChasta)#">
        </cfif>
    	and cb.CBesTCE = <cfqueryparam value="#LvarCBesTCE#" cfsqltype="cf_sql_bit">
	    and ec.ECStatus = 1
	order by ec.ECaplicado, cb.Ocodigo,ec.Bid, cb.Mcodigo, cb.CBcodigo, ec.EChasta
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
			<cfif isdefined("form.Rango") and form.Rango EQ 'PeriodoMes'>
            	<tr>
                    <td align="center"><font size="3"><strong>Saldo de Cuentas Bancarias del Periodo: #form.Periodo# Mes: #form.Mes#</strong></font></td>
                </tr>
            <cfelse>
                <tr>
                    <td align="center"><font size="3"><strong>Saldo de Cuentas Bancarias al #LSDateFormat(form.EChasta,'dd/mm/yyyy')#</strong></font></td>
                </tr>
            </cfif>
			<tr><td align="center">
				<font size="3"><strong> Conciliaciones: 
					<cfif #form.Conciliaciones# eq -1>Todas	<cfelseif #form.Conciliaciones# eq 1>Aplicadas<cfelseif #form.Conciliaciones# eq 2>	NO Aplicadas</cfif>	
				</strong></font>
			</td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
	</cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center">	

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
								<td width="70%" valign="top">
									<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center" >
										
										<cfoutput query="rsDatosEncab" group="Ocodigo">	
											<tr>
												<td align="left"><span style="font-size:14px;"><strong>Oficina</strong></span></td>
												<td align="left"><span style="font-size:14px;"><strong>#rsDatosEncab.Odescripcion#</strong></span></td>
											</tr>
											<cfoutput group="Bid">	
                                                <tr>
                                                    <td align="left"><span style="font-size:14px;"><strong>Banco</strong></span></td>
                                                    <td colspan="3" align="left"><span style="font-size:14px;"><strong>#rsDatosEncab.Bdescripcion#</strong></span></td>
                                                </tr>
                                            	<cfoutput>
                                                <tr  bgcolor="E2E2E2">
                                                    <td align="left"><span style="font-size:11px;"><strong>Estatus</strong></span></td>
                                                    <td align="left" width="18%"><span style="font-size:11px;"><strong>#etiquetaCuenta#</strong></span></td>
                                                    <td align="left" width="25%"><span style="font-size:11px;"><strong>Descripcion</strong></span></td>
                                                    <td align="left" width="9%"><span style="font-size:11px;"><strong>Fecha Corte</strong></span></td>
                                                    <td align="left"><span style="font-size:11px;"><strong>Moneda</strong></span></td>
                                                     <td align="center" width="9%"><span style="font-size:11px;"><strong>Tipo Movimiento</strong></span></td>
                                                     <td align="right" width="9%"><span style="font-size:11px;"><strong>Saldo seg&uacute;n Libros</strong></span></td>
                                                     <td align="right" width="9%"><span style="font-size:11px;"><strong>Saldo seg&uacute;n Bancos</strong></span></td>
                                                     <td align="right" width="9%"><span style="font-size:11px;"><strong>Saldo Conciliado</strong></span></td>
                                                    <cfif not isdefined("url.imprimir")><td align="right"></td></cfif>
                                                </tr>
                                                    <!--- Saldos en Libros para Debitos --->
                                                    <cfquery name="rsSaldoLibrosD" datasource="#Session.DSN#">
                                                         select round(coalesce((
                                                                    select sum(sb.Sinicial)
                                                                     from SaldosBancarios sb
                                                                    where sb.CBid = #rsDatosEncab.CBid#       <!---Cuenta Bancaria del Estado de Cuenta--->
                                                                    and Periodo   = #rsDatosEncab.periodo#    <!---Año del Estado de Cuenta--->
                                                                    and Mes       = #rsDatosEncab.mes#        <!---Mes del Estado de Cuenta--->
                                                                    ),0.00)
                                                            + 
                                                            coalesce((select sum(MLmonto) 
                                                                        from MLibros
                                                                        where CBid    = #rsDatosEncab.CBid#      <!--- Cuenta Bancaria del Estado de Cuenta--->
                                                                        and MLtipomov = 'D'
                                                                        and MLfecha   >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosEncab.ECdesde#">  <!--- Fecha del Estado de Cuenta (Fecha Hasta)--->
                                                                        and MLfecha   < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosEncab.EChasta#">  <!--- Fecha del Estado de Cuenta (Fecha Hasta)--->
                                                                        ) , 0.00),2) as Saldo                                    
                                                        from dual
                                                    </cfquery>
                                                     <!--- Saldos en Libros para Creditos --->
                                                    <cfquery name="rsSaldoLibrosC" datasource="#Session.DSN#">
                                                          select round(coalesce((
                                                                    select sum(sb.Sinicial)
                                                                     from SaldosBancarios sb
                                                                    where sb.CBid = #rsDatosEncab.CBid#       <!---Cuenta Bancaria del Estado de Cuenta--->
                                                                    and Periodo   = #rsDatosEncab.periodo#    <!---Año del Estado de Cuenta--->
                                                                    and Mes       = #rsDatosEncab.mes#        <!---Mes del Estado de Cuenta--->
                                                                    ),0.00)
                                                            + 
                                                            coalesce((select sum(MLmonto) 
                                                                        from MLibros
                                                                        where CBid    = #rsDatosEncab.CBid#      <!--- Cuenta Bancaria del Estado de Cuenta--->
                                                                        and MLtipomov = 'C'
                                                                       and MLfecha   >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosEncab.ECdesde#">  <!--- Fecha del Estado de Cuenta (Fecha Hasta)--->
                                                                        and MLfecha   < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosEncab.EChasta#">  <!--- Fecha del Estado de Cuenta (Fecha Hasta)--->
                                                                        ) , 0.00),2) as Saldo 
                                                        from dual
                                                    </cfquery>
                                                    <!--- Validador del Saldo en cero Debitos--->
                                                    <cfif rsSaldoLibrosD.recordCount GT 0>
                                                        <cfset SaldoLibrosD = rsSaldoLibrosD.Saldo>
                                                    <cfelse>
                                                        <cfset SaldoLibrosD = 0.00>
                                                    </cfif>
                                                    <!--- Validador del Saldo en cero Creditos--->
                                                    <cfif rsSaldoLibrosC.recordCount GT 0>
                                                        <cfset SaldoLibrosC = rsSaldoLibrosC.Saldo>
                                                    <cfelse>
                                                        <cfset SaldoLibrosC = 0.00>
                                                    </cfif>
                                                    
                                                    <!--- Resumen Conciliacion Bancos Movimientos Creditos --->
                                                    <cfquery name="rsResumenConcBancos" datasource="#Session.DSN#">
                                                        select c.Bid, c.BTEcodigo, 
                                                            case c.BTEtipo when 'D' then '+' when 'C' then '-' else '' end as SumaResta,
                                                            c.BTEdescripcion, 
                                                            count(b.BTEcodigo) as Cantidad, 
                                                            round(coalesce(sum(cd.CDBmonto), 0.00),2) as Despliegue, 
                                                            round(coalesce(sum(cd.CDBmonto), 0.00),2) as Suma 
                                                        from CDBancos cd, DCuentaBancaria b, TransaccionesBanco c
                                                        where cd.ECid 			= #rsDatosEncab.ECid#
                                                            and cd.CDBgrupo is null
                                                            and cd.CDBlinea 	   	= b.Linea
                                                            and b.Bid 		  		= c.Bid
                                                            and b.BTEcodigo 	   	= c.BTEcodigo
                                                        group by c.Bid, c.BTEcodigo, c.BTEdescripcion, c.BTEtipo, case c.BTEtipo when 'D' then '+' when 'C' then '-' else '' end
                                                    </cfquery>
                                                   
                                                    <!--- Debitos en Bancos --->
                                                    <cfquery name="rsDebitosBancos" dbtype="query">
                                                        select sum(Suma) as Suma from rsResumenConcBancos where SumaResta = '+'
                                                    </cfquery>
                                                    <cfif rsDebitosBancos.recordCount GT 0>
                                                        <cfset DebitosBancos = rsDebitosBancos.Suma>
                                                    <cfelse>
                                                        <cfset DebitosBancos = 0.00>
                                                    </cfif>
                                                    
                                                    <!--- Creditos en Bancos --->
                                                    <cfquery name="rsCreditosBancos" dbtype="query">
                                                        select sum(Suma) as Suma from rsResumenConcBancos where SumaResta = '-'
                                                    </cfquery>
                                                    <cfif rsCreditosBancos.recordCount GT 0>
                                                        <cfset CreditosBancos = rsCreditosBancos.Suma>
                                                    <cfelse>
                                                        <cfset CreditosBancos = 0.00>
                                                    </cfif>
                                                    
                                                    <!--- Saldo conciliado Creditos --->
                                                    <cfset sumaFinalC = SaldoLibrosC+DebitosBancos-CreditosBancos>
                                                    <!--- Saldos conciliados Debitos --->
													<cfset sumaFinalD = SaldoLibrosD+DebitosBancos-CreditosBancos>
                                                   
                                                    <!--- Movimientos Credito --->
                                                    <tr>
                                                        <td><cfif rsDatosEncab.ECaplicado EQ 'S'>Aplicado<cfelse>No Aplicado</cfif><br /><cfdump var="#rsDatosEncab.ECid#"></td>
                                                        <td>#rsDatosEncab.CBcodigo#</td>
                                                        <td>#rsDatosEncab.CBdescripcion#</td>
                                                        <td align="left">#LSDateFormat(rsDatosEncab.EChasta,'dd/mm/yyyy')#</td>
                                                        <td align="center">#rsDatosEncab.Msimbolo#</td>
                                                        <td align="right"><span style="font-size:11px;">Credito</span></td>	
                                                        <!--- Saldos Libros  Movimientos Creditos--->
                                                        <td align="right">
															<cfif rsDatosEncab.ECaplicado eq 'N'>
																<cfif rsSaldoLibrosC.Saldo neq 0.00>-</cfif>#LSCurrencyFormat(rsSaldoLibrosC.Saldo,'none')#
                                                            <cfelse>
                                                            <!--- 
																	Se utiliza el cero unicamente para el caso en que se haya aplicada la conciliación
																	y por solicitud de explicita de Mexico para efectos de este reporte
															 --->
                                                            	0.00    
															</cfif>
														</td>
                                                        <!--- Saldos Bancos  Movimientos Creditos--->
                                                        <td align="right"><cfif CreditosBancos neq 0.00>-</cfif>#LSCurrencyFormat(CreditosBancos,'none')#</td>
                                                       <td align="right">
                                                        <!--- Saldos Creditos --->
															 <cfif rsDatosEncab.ECaplicado eq 'N'>
                                                       		     0.00
                                                            <cfelse>
                                                              	  <cfif sumaFinalC neq 0.00>-</cfif>#LSCurrencyFormat(sumaFinalC,'none')#
                                                            </cfif>     
                                                        </td>
                                                    </tr>
                                                    
                                                    <!--- Movimientos Debitos --->
                                                    <tr>
                                                    	<td>&nbsp;</td> <td>&nbsp;</td> <td>&nbsp;</td > <td>&nbsp;</td> <td>&nbsp;</td>
                                                        <td align="right"><span style="font-size:11px;">Debitos</span></td>	
                                                        <!--- Saldos Libros  Movimientos Debitos--->
                                                        <td align="right">
															 <cfif rsDatosEncab.ECaplicado eq 'N'>
                                                             	#LSCurrencyFormat(rsSaldoLibrosD.Saldo,'none')#
															<cfelse>
                                                            <!--- 
																	Se utiliza el cero unicamente para el caso en que se haya aplicada la conciliación
																	y por solicitud de explicita de Mexico para efectos de este reporte
															 --->
                                                            	0.00
															</cfif>
														</td>
                                                        <!--- Saldos Bancos  Movimientos Debitos--->
                                                        <td align="right">#LSCurrencyFormat(DebitosBancos,'none')#</td>
                                                        <!--- Saldo Conciliado Debitos --->
                                                        <td align="right">
                                                         	<cfif rsDatosEncab.ECaplicado eq 'N'>
                                                            	0.00
															<cfelse>
                                                                    #LSCurrencyFormat(sumaFinalD,'none')#
                                                             </cfif> 
                                                        </td>
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
                                                    <tr><td>&nbsp;</td></tr>
                                                </cfoutput>
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
	
		
	<!--- =============================================================================--->
	<!---                                               Pie del Reporte                                                                                 --->
	<!--- =============================================================================--->		
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