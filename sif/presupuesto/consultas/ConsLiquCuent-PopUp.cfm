<cf_templatecssreport>
<script language="javascript">
	function fnclose()
	{
		window.close();
	}
	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print()	
        tablabotones.style.display = ''
	}
</script>


<cfif isdefined("form.lpf")>
	<cfset form.lpf=form.lpf>
<cfelseif isdefined("url.lpf")>
	<cfset form.lpf=url.lpf>
<cfelse>
	<cfset form.lpf=0>
</cfif>


<cfif isdefined("form.CPPid")>
	<cfset form.CPPid=form.CPPid>
<cfelseif isdefined("url.CPPid")>
	<cfset form.CPPid=url.CPPid>
<cfelse>
	<cfset form.CPPid=0>
</cfif>


<!---<cfif isdefined("form.lpf") AND isdefined("form.extencion") AND form.CPPid NEQ "-1">--->
	<script>
		window.resizeTo(900,450);
		//window.moveTo(0,0);
		//window.resizeTo(screen.width,(screen.height-20));
	</script>
	
	<style type="text/css">
	<!--
	.table
	{
	border-collapse:collapse;
	}
	th,td{
	border-bottom:1px solid #f2f2f2;
	text-align:left;
	padding:5px 5px;
	}
	td
	{
	text-align:right;
	}

	.style1 {
	color: #FF0000;
	font-weight:bold;
	}
	.ln2 td
	{
		background:#E0ECF8;
	}
	.linearoja td{
		color:red;
	}
	-->
	</style>

	<cfquery name="rsLiquidacion" datasource="#Session.DSN#">
		select CPLnumeroLiquidacion
		  from CPLiquidacion
		 where Ecodigo 				= #session.Ecodigo#
		   and CPPid				= #form.CPPid#
		   and CPNAPnumLiquidacion	is null
	</cfquery>
	<cfif rsLiquidacion.CPLnumeroLiquidacion EQ "">
			<cfquery name="rsLiquidacion" datasource="#Session.DSN#">
				select coalesce(max(CPLnumeroLiquidacion)+1,1) as CPLnumeroLiquidacion
				  from CPLiquidacion
				 where Ecodigo 				= #session.Ecodigo#
			</cfquery>
			<cfif rsLiquidacion.CPLnumeroLiquidacion EQ "">
				<cfset rsLiquidacion.CPLnumeroLiquidacion = 1>
			</cfif>
	</cfif>
	<cfquery name="rsLiquidacionCuentas" datasource="#Session.DSN#">
			select 	case m.Ctipo
						when 'A' then 'Activo' 
						when 'G' then 'Gasto' 
						else 'OTRO ???'
					end	as TipoCta, c.CPdescripcion,
					l.CPcuenta, c.CPformato,
					l.Ocodigo, o.Oficodigo,
					CPLCdisponibleAntes,
					CPLCpendientesAntes,
					CPLCmontoReservas,
					CPLCmontoCompromisos,
					CPLCmontoModificacion,
					CPLCdisponibleAntes-CPLCpendientesAntes-CPLCmontoReservas-CPLCmontoCompromisos+CPLCmontoModificacion as DisponibleNeto,
					CPLCresultado,
					case CPLCresultado
						when 0 then 'OK&nbsp;'
						when 1 then 'No hay disponible&nbsp;'
						when 2 then 'No existe Cuenta&nbsp;'
						else 'Cuenta+Oficina no Formulada&nbsp;'
					end as Resultado
			  from CPLiquidacionCuentas l
				inner join CPresupuesto c
					inner join CtasMayor m
						 on m.Ecodigo = c.Ecodigo
						and m.Cmayor  = c.Cmayor
					on c.CPcuenta = l.CPcuenta
				inner join Oficinas o
					 on o.Ecodigo = l.Ecodigo
					and o.Ocodigo = l.Ocodigo
			 where l.Ecodigo 	= #session.Ecodigo#
			   and l.CPPid 		= #form.CPPid#
			   and l.CPLnumeroLiquidacion = #rsLiquidacion.CPLnumeroLiquidacion#
			 order by m.Ctipo, c.CPformato
		</cfquery>
		<cfquery name="rsTotal" datasource="#Session.DSN#">
			select 	sum(CPLCmontoReservas) as Total_RC
					,sum(CPLCmontoCompromisos) as Total_CC
					,sum(CPLCmontoModificacion) as Total_M
					,sum(CPLCmontoReservas+CPLCmontoCompromisos-CPLCmontoModificacion) as Total_SF
					,count(1) as buenos
			  from CPLiquidacionCuentas
			 where Ecodigo 	= #session.Ecodigo#
			   and CPPid 	= #form.CPPid#
			   and CPLnumeroLiquidacion = #rsLiquidacion.CPLnumeroLiquidacion#
			   and CPLCresultado = 0 
		</cfquery>
		<cfquery name="rsTotal_ErrSD" datasource="#Session.DSN#">
			select coalesce(sum(CPLCmontoReservas+CPLCmontoCompromisos),0) as Total
			  from CPLiquidacionCuentas
			 where Ecodigo 	= #session.Ecodigo#
			   and CPPid 	= #form.CPPid#
			   and CPLnumeroLiquidacion = #rsLiquidacion.CPLnumeroLiquidacion#
			   and CPLCresultado = 1 
		</cfquery>
		<cfquery name="rsTotal_ErrSC" datasource="#Session.DSN#">
			select coalesce(sum(CPLCmontoReservas+CPLCmontoCompromisos),0) as Total
			  from CPLiquidacionCuentas
			 where Ecodigo 	= #session.Ecodigo#
			   and CPPid 	= #form.CPPid#
			   and CPLnumeroLiquidacion = #rsLiquidacion.CPLnumeroLiquidacion#
			   and CPLCresultado in (2, 3)
		</cfquery>
	
		<cfset LvarFileName = "Liquidacion#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
			<cf_htmlReportsHeaders 
			title="Liquidacion a aprobar" 
			filename="#LvarFileName#"
			irA="javascript:fnclose();">
			<cf_templatecss>
					
		<cfoutput>
		<table width="75%" align="center" class="table" >
			<tr>
				<td colspan="11" align="center"><h1 style="text-align:center;" >Reporte de Liquidación por Aprobar</h1></td>
			</tr>
			<tr>
				<th>
					<strong>Total Reservas a Liquidar:</strong>
				</th>
				<td>&nbsp;</td>
				<td align="right">
					#numberFormat(rsTotal.Total_RC,",0.00")#
				</td>
			</tr>
			<tr>
				<th>
					<strong>Total Compromisos a Liquidar:</strong>
				</th>
				<td>&nbsp;</td>
				<td align="right">
					#numberFormat(rsTotal.Total_CC,",0.00")#
				</td>
			</tr>
			<tr>
				<th>
					<strong>Total con Modificacion:</strong>
				</th>
				<td>&nbsp;
					
				</td>
				<td align="right">
					#numberFormat(rsTotal.Total_M,",0.00")#
				</td>
			</tr>
			<tr>
				<th>
					<strong>Total sin Modificacion:</strong>
				</th>
				<td>&nbsp;
					
				</td>
				<td align="right">
					#numberFormat(rsTotal.Total_SF,",0.00")#
				</td>
			</tr>
			<tr>
				<th class="style1">
					<strong>Total Reservas y Compromisos con Error que no se van a liquidar:</strong>
				</th>
				<td>&nbsp;
					
				</td>
				<td class="style1" align="right">
					#numberFormat(rsTotal_ErrSD.Total + rsTotal_ErrSC.Total,",0.00")#
				</td>
			</tr>
			<tr>
				<th class="style1" style="font-weight:100" align="right">
					Sin Fondos en nuevo Período:
				</th>
				<td>&nbsp;</td>
				<td class="style1" style="font-weight:100" align="right">
					#numberFormat(rsTotal_ErrSD.Total,",0.00")#
				</td>
			</tr>
			<tr>
				<th class="style1" style="font-weight:100" align="right">
					Sin Cuenta en nuevo Período:
				</th>
				<td>&nbsp;</td>
				<td class="style1" style="font-weight:100" align="right">
					#numberFormat(rsTotal_ErrSC.Total,",0.00")#
				</td>
			</tr>
		</table>
		</cfoutput>	
		<br/><br/>
		<table width="85%" align="center" class="table" >
		<tr>
			<th>Tipo Cuenta</th>
			<th>Cuenta</th>
			<th>Nombre Cuenta</th>
			<th>Oficina</th>
			<th>Disponible Anterior</th>
			<th>Pendientes Anterior</th>
			<th>Monto Reservas</th>
			<th>Monto Compromisos</th>
			<th>Monto Modificacion</th>
			<th>Disponible&nbsp;Neto a Generar</th>
			<th>Resultado</th>
		</tr>
		<cfset tmp=0>
		<cfloop query="rsLiquidacionCuentas">
		<cfoutput>
		<tr class="<cfif tmp eq 0>ln1<cfset tmp=1><cfelse>ln2<cfset tmp=0></cfif><cfif rsLiquidacionCuentas.CPLCresultado NEQ 0> linearoja</cfif>">
			<td>#rsLiquidacionCuentas.TipoCta#</td>
			<td>#rsLiquidacionCuentas.CPformato#</td>
			<td>#rsLiquidacionCuentas.CPdescripcion#</td>
			<td>#rsLiquidacionCuentas.Oficodigo#</td>
			<td>#rsLiquidacionCuentas.CPLCdisponibleAntes#</td>
			<td>#rsLiquidacionCuentas.CPLCpendientesAntes#</td>
			<td>#rsLiquidacionCuentas.CPLCmontoReservas#</td>
			<td>#rsLiquidacionCuentas.CPLCmontoCompromisos#</td>
			<td>#rsLiquidacionCuentas.CPLCmontoModificacion#</td>
			<td>#rsLiquidacionCuentas.DisponibleNeto#</td>
			<td>#rsLiquidacionCuentas.Resultado# </td>
		</tr>
		</cfoutput>		
		</cfloop>
		
		</table>
	
<!---<cfelse>
	
<cf_web_portlet_start titulo="Autorizacion Presupuestaria">
	<form name="form1" action="ConsLiquCuent-PopUp.cfm" method="post">
		<input type="hidden" name="lpf" id="lpf" value="<cfif isdefined("url.lpf")><cfoutput>#url.lpf#</cfoutput></cfif>" />
		<input type="hidden" name="CPPid" id="CPPid" value="<cfif isdefined("url.CPPid")> <cfoutput>#url.CPPid#</cfoutput></cfif>" />
        <table border="0" align="center">
            <tr>
                <td>
                    Impresion de Liquidación por Aprobar
                </td>
            </tr>
            <tr>
                <td>Formato:
					<select name="extencion" id="extencion">
						<option value="excel">Excel</option>
						<option value="html">HTML</option>
					</select>
				</td>
            </tr>
            <tr>
                <td align="center">
                    <input type="submit" name="btnimprimir" class="btnimprimir" value="Imprimir">
                    <input type="button" name="btnNormal" 	class="btnNormal" 	value="Cerrar" onclick="fnclose();">
					
                </td>
            </tr>
        </table>
     </form>
<cf_web_portlet_end>

</cfif>--->
