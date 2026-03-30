<!---------

	Modificado por: Ana Villavicencio
	Fecha: 18 de noviembre del 2005
	Motivo: Cambiar el filtro por Estado de cuenta y agregar el banco y la cuenta.  
			Cambiar las consultas para hacerlas sobre las tablas MLibros y ECuentaBancaria
	
	Modificado por: Gustavo Fonseca H.
		Fecha: 14-11-2005.
		Motivo:	Se agrega el Tipo de Movimiento (Crédito / Débito) en bancos y libros.
		Se le agrega la navegación a esta pantalla.
	
	Modificado por: Ana Villavicencio
	Fecha de modificación: 25 de mayo del 2005
	Motivo:	Se agrego el  ícono de impresión de la consulta
	
	Modificado por: Alejandro Bolaños APH
	Fecha de modificación: 12 de septiembre 2011
	Motivo:	se modifica la leyenda "Saldo final" por "Monto Conciliado" cuando se consulta desde tarjetas de credito
		Se agrega la sumatoria de la columna Montos
		
	Modificado por: Alejandro Bolaños APH
	Fecha de modificación: 19 de septiembre 2011
	Motivo:	Se genera la consulta por filtro fecha o Periodo-Mes
		
----------->
<cfset LvarIrAformConciliacion = "formConciliacion.cfm">
<cfset LvarIrAConciliacion = "Conciliacion.cfm">
<cfset LvarCuenta = "Cuenta:">
<cfset LvarLeyendaSaldoFinal = "Saldo Final:">
<cfset LvarLeyendaSaldoInicial = "Saldo Inicial:">
<cfset LvarLeyendaDebitos = "D&eacute;bitos:">
<cfset LvarLeyendaCreditos = "Cr&eacute;ditos:">
<cfset LvarCBesTCE = 0>
<cfif isdefined("LvarformConciliacion")>
	<cfset LvarIrAformConciliacion = "formConciliacionTCE.cfm">
	<cfset LvarCBesTCE = 1>
	<cfset LvarCuenta = "Tarjeta de Cr&eacute;dito:">
    <cfset LvarLeyendaSaldoFinal = "Monto Conciliado:">
    <cfset LvarLeyendaSaldoInicial = "Saldo Anterior:">
    <cfset LvarLeyendaDebitos = "D&eacute;bitos:">
	<cfset LvarLeyendaCreditos = "Cr&eacute;ditos:">
	<cfset LvarIrAConciliacion = "ConciliacionTCE.cfm">
</cfif>

<cfset Title           = "Reporte de Concialiacion Bancaria">
<cfset FileName        = "ConcialiacionBancaria">
<cfset FileName 	   = FileName &".xls">
<cf_htmlreportsheaders title="#Title#" filename="#FileName#" download="no" ira="#LvarIrAConciliacion#">

<cfif isdefined('url.Bid')>
	<cfset form.Bid = url.Bid>
</cfif>
<cfif isdefined('url.CBid')>
	<cfset form.CBid = url.CBid>
</cfif>
<cfif isdefined('url.EChasta')>
	<cfset form.EChasta = url.EChasta>
</cfif>
<cfif isdefined('url.montos_cero')>
	<cfset form.montos_cero = url.montos_cero>
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

<cfset vparams ="">
<cfif form.CBid EQ -1>
	<cfset vparams = vparams & "&Bid=" & form.Bid & "&EChasta=" & form.EChasta>		
<cfelse>
    <cfset vparams = vparams & "&Bid=" & form.Bid & "&CBid=" & form.CBid & "&EChasta=" & form.EChasta>
</cfif>
<cfif isdefined("form.montos_cero")>
	<cfset vparams = vparams & "&montos_cero=" & form.montos_cero>
</cfif>

<!--- CONSULTAS --->
<!--- 1. Datos de la empresa --->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!--- 2. Estado de Cuenta a Consultar>--->
<cfquery name="rsDatosEncab" datasource="#session.DSN#">
		select ECid,Bdescripcion, CBdescripcion, CBcodigo,ECdescripcion,ECsaldoini , ECdebitos, ECcreditos, ECsaldofin
		from ECuentaBancaria ec
		inner join CuentasBancos cb
		   on cb.Bid = ec.Bid
		  and cb.CBid = ec.CBid
		  and ec.ECaplicado = 'S'
		inner join Bancos b
		   on cb.Ecodigo = b.Ecodigo
		  and cb.Bid = b.Bid
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
		  and cb.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
          <cfif form.CBid NEQ -1>
		  	and cb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
          </cfif>
	   	  <!--- and ec.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#"> --->
	</cfquery>
	<cfif isdefined('rsDatosEncab') and rsDatosEncab.RecordCount GT 0>
		<cfset form.ECid  = rsDatosEncab.ECid>
	</cfif>
<!--- Funciones --->
<!--- 1. Recupera el tipo de transaccion --->
<cffunction name="get_transaccion" access="public" returntype="string">
	<cfargument name="id"    type="numeric" required="true" default="<!--- Código de la línea de Título --->">
	<cfquery name="rsget_transaccion" datasource="#session.DSN#" >
		select BTdescripcion
		from BTransacciones
		where BTid = #id#
	</cfquery>
	<cfreturn #rsget_transaccion.BTdescripcion#>
</cffunction>


<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<form name="form1" method="post">
            
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
				  <td colspan="2" align="center"><font size="3"><strong>Reporte de Conciliaci&oacute;n Bancaria </strong></font></td>
				</tr>
				<tr><td colspan="2" align="center"><font size="2"><strong>Banco:&nbsp;#rsDAtosEncab.Bdescripcion#</strong></font></td></tr>
                <tr>
                	<td align="center" colspan="2">
                    	<font size="2"><strong>
                    	<cfif isdefined('form.Rango') and form.Rango EQ 'PeriodoMes'>
                        	Estados de cuenta del Periodo: #form.Periodo# Mes: #form.Mes#
                        <cfelse>
                        	Estados de Cuenta con fecha de corte al: #LSDateFormat(form.EChasta,'dd/mm/yyyy')#
                        </cfif>
                        </strong></font>
                    </td>
                </tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
		</cfoutput>
	    <table width="90%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center">	
	
		<!--- ============================================================================================================ --->
		<!---                                                Datos del Reporte                                             --->
		<!--- ============================================================================================================ --->		
			<cfoutput>
			<cfloop query="rsDatosEncab">
			<tr><td colspan="2">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center">
						<cfquery name="rsLibros" datasource="#session.DSN#">
                            select 
                                MLdocumento, 
                                MLmonto, 
                                MLfecha, 
                                BTid,
                                case when MLtipomov = 'C' then 'Crédito' else 'Débito' end as tipo
                            from MLibros
                            where MLconciliado = 'S' 
                                and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEncab.ECid#">
                                
                                <cfif not isdefined("form.montos_cero")>
                                    and MLmonto > 0
                                </cfif>
                                
                                
                            order by MLdocumento
                        </cfquery>
                        <cfif rsLibros.recordcount gt 0>
                        <tr><td colspan="2"><font size="2"><strong><cfoutput>#LvarCuenta#</cfoutput>&nbsp;#rsDAtosEncab.CBdescripcion#&nbsp;&nbsp;#rsDatosEncab.CBcodigo#</strong></font></td></tr>
						<tr><td colspan="2"><font size="2"><strong>Estado de Cuenta &nbsp;#rsDAtosEncab.ECdescripcion#</strong></font></td></tr>
						<cfset titulos = false >	
							<tr><td>&nbsp;</td></tr>

							<tr>
								<td colspan="2" align="center">
									<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center" >
										<tr bgcolor="E2E2E2">
											<td class="bottomline"align="right" nowrap><b>#LvarLeyendaSaldoInicial#&nbsp;</b></td>
											<td class="bottomline" nowrap>#LSCurrencyFormat(rsDatosEncab.ECsaldoini,'none')#</td>
											<td class="bottomline" align="right" nowrap><b>#LvarLeyendaDebitos#&nbsp;</b></td>
											<td class="bottomline" nowrap>#LSCurrencyFormat(rsDatosEncab.ECdebitos,'none')#</td>
											<td class="bottomline" align="right" nowrap><b>#LvarLeyendaCreditos#&nbsp;</b></td>
											<cfif isdefined("LvarformConciliacion")>
                                            	<td class="bottomline" nowrap>#LSCurrencyFormat(abs(rsDatosEncab.ECcreditos),'none')#</td>
                                            <cfelse>
                                            	<td class="bottomline" nowrap>#LSCurrencyFormat(rsDatosEncab.ECcreditos,'none')#</td>
                                            </cfif>
											<td class="bottomline"align="right" nowrap><b>#LvarLeyendaSaldoFinal#&nbsp;</b></td>
                                            <cfif isdefined("LvarformConciliacion")>
												<td class="bottomline" nowrap>#LSCurrencyFormat(abs(rsDatosEncab.ECsaldofin),'none')#</td>
                                            <cfelse>
                                            	<td class="bottomline" nowrap>#LSCurrencyFormat(rsDatosEncab.ECsaldofin,'none')#</td>
                                            </cfif>
										</tr>
										<tr><td colspan="8">&nbsp;</td></tr>
									</table>
								</td>
							</tr>
								
								
								<cfquery name="rsBancos" datasource="#session.DSN#">
									select 
										Documento, 
										DCmontoori, 
										DCfecha, 
										BTEdescripcion,
										case when DCtipo = 'C' then 'Crédito' else 'Débito' end as tipo
									from ECuentaBancaria a 
									inner join DCuentaBancaria dc
									   on a.ECid = dc.ECid
										<cfif not isdefined("form.montos_cero")>
										   and dc.DCmontoori > 0
										 </cfif>  
									 and dc.DCconciliado = 'S'
						
									inner join TransaccionesBanco c
									  on dc.Bid = c.Bid
									 and dc.BTEcodigo = c.BTEcodigo

									where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEncab.ECid#">
										
									order by Documento  
								</cfquery>
								<tr>
									<td colspan="2">
										<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center" >
											<tr>
												<td width="50%" valign="top">
													<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center" >
														
														<cfif not titulos >
															<tr bgcolor="E2E2E2"><td align="center" colspan="5"><span style="font-size:12px;"><strong>Libros</strong></span></td></tr>
															<tr bgcolor="EFEFEF" height="15">
																<td align="left"><strong>Documento</strong></td>
																<td align="left"><strong>Tipo</strong></td>															
																<td align="left"><strong>Fecha</strong></td>
																<td align="left"><strong>T. Movi.</strong></td>
																<td align="right"><strong>Monto</strong></td>
															</tr>
														</cfif>	
														
														<cfloop query="rsLibros">			
															<tr>
																<td>#MLdocumento#</td>
																<td>#get_transaccion(BTid)#</td>
																<td>#LSDateFormat(MLfecha,'dd/mm/yyyy')#</td>
																<td>#tipo#</td>
																<td align="right">#LSCurrencyFormat(MLmonto,'none')#</td>
															</tr>
														</cfloop> <!--- rsLibros --->
                                                        
                                                        <cfif isdefined("LvarformConciliacion")>
                                                            <cfquery dbtype="query" name="rsTotalMonto">
                                                                select sum(MLmonto) as TMLmonto
                                                                from rsLibros
                                                            </cfquery>
                                                            <tr bgcolor="EFEFEF" height="15">
                                                                <td align="right" colspan="3">&nbsp;</td>
                                                                <td align="left"><strong>Total:</strong></td>
                                                                <td align="right"><strong>#LSCurrencyFormat(rsTotalMonto.TMLmonto,'none')#</strong></td>
                                                            </tr>
                                                        </cfif>
													</table>	
												</td>
												<td width="1%"></td>
												<td width="50%" valign="top">
													<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center">
														<cfif not titulos >
														    <tr bgcolor="E2E2E2"><td align="center" colspan="5"><span style="font-size:12px;"><strong>Bancos</strong></span></td></tr>
															<tr bgcolor="EFEFEF" height="15">
																<td align="left"><strong>Documento</strong></td>
																<td align="left"><strong>Tipo</strong></td>
																<td align="left"><strong>Fecha</strong></td>
																<td align="left"><strong>T. Movi.</strong></td>
																<td align="right"><strong>Monto</strong></td>
															</tr>
														</cfif>	

														<cfloop query="rsBancos">			
															<tr>
																<td>#Documento#</td>
																<td>#BTEdescripcion#</td>
																<td>#LSDateFormat(DCfecha,'dd/mm/yyyy')#</td>
																<td align="right">#tipo#</td>
																<td align="right">#LSCurrencyFormat(DCmontoori,'none')#</td>
															</tr>
														</cfloop> <!--- rsLibros --->
														
                                                        <cfif isdefined("LvarformConciliacion")>
                                                            <cfquery dbtype="query" name="rsTotalMontoB">
                                                                select sum(DCmontoori) as TMLmonto
                                                                from rsBancos
                                                            </cfquery>
                                                            <tr bgcolor="EFEFEF" height="15">
                                                                <td align="right" colspan="3">&nbsp;</td>
                                                                <td align="left"><strong>Total:</strong></td>
                                                                <td align="right"><strong>#LSCurrencyFormat(rsTotalMontoB.TMLmonto,'none')#</strong></td>
                                                            </tr>
                                                        </cfif>
                                                        		
														<cfset titulos = true >		
													</table>	
												</td>
											</tr>
											<tr><td class="bottomline" colspan="3">&nbsp;</td></tr>
										
										</table>	
									</td>
								</tr>
								
								<tr><td colspan="2">&nbsp;</td></tr>									
						<tr><td>&nbsp;</td></tr>
                        </cfif>
				</table>
			</td></tr>
            </cfloop>
			</cfoutput>			
		<!--- ============================================================================================================ --->
		<!--- ============================================================================================================ --->		
			
		<!--- ============================================================================================================ --->
		<!---                                               Pie del Reporte                                                --->
		<!--- ============================================================================================================ --->		
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr> 
				<td colspan="2"><div align="center">------------------ Fin del Reporte ------------------</div></td>
			</tr>
		<!--- ============================================================================================================ --->
		<!--- ============================================================================================================ --->		
<cfelse>
	<tr> 
		<td colspan="2"><div align="center">------------------ No hay datos relacionados ------------------</div></td>
	</tr>
	<tr> 
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr> 
						<!---Utilizar en Bancos con Conciliacion.cfm o en TCE ConciliacionTCE.cfm--->
		<td colspan="2"><div align="center"><input type="button" value="Nueva Consulta" onclick="location='<cfoutput>#LvarIrAConciliacion#</cfoutput>'"/></div></td>
	</tr>
</cfif>
    </table>
</form>

