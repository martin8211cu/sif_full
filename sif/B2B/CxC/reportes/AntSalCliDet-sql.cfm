<cfinclude template="Estado_Cuenta_funciones.cfm">
<!--- 
		Creado por:	Rodolfo Jiménez Jara.
		Fecha: 19-9-2005.
		Motivo: Creado a Solicitud de Mauricio Esquivel. Para Ricardo Perez.
 --->
<cfif not isdefined("url.FechaF") and isdefined("form.FechaF")>
	<cfset url.FechaF = form.FechaF>
</cfif>
<cfif not isdefined("url.SNnumero") and isdefined("form.SNnumero")>
	<cfset url.SNnumero = form.SNnumero>
</cfif>
<cfif not isdefined("url.formato") and isdefined("form.formato")>>
	<cfset url.formato = form.formato>
</cfif>

<cfif isdefined('url.FechaF')>
	<cfset form.FechaF = url.FechaF>
</cfif>
<cfif isdefined('url.SNnumero')>
	<cfset form.SNnumero = url.SNnumero>	
</cfif>
<cfif isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>

<cfif not isdefined("url.FechaF")>
	<cfset LvarFechaFinal = createdate(mid(now(), 6,4), mid(now(), 11,2), mid(now(), 14, 2))>  	
<cfelse>
	<cfset LvarFechaFinal = createdate(mid(url.FechaF, 7,4), mid(url.FechaF, 4,2), mid(url.FechaF, 1, 2))>  	
</cfif>

<cfset LvarPeriodo = datepart('yyyy', LvarFechaFinal)>
<cfset LvarMes = datepart('m', LvarFechaFinal)>
<cfset LvarFechaInicioMes = createdate(LvarPeriodo, LvarMes, 1)>

<cfset fnObtenerPeriodosAntiguedad(LvarFechaFinal)>

<cfif isdefined("url.Formato") and len(trim(url.Formato))>
	<cfset formatos = url.Formato>
<cfelse>
	<cfset formatos = "pdf">
</cfif>
<cfset MaximoRegistros = 1000>

<cfset fnGeneraQueryReporte()>

<cfif isdefined('rsReporte') and rsReporte.RecordCount LT MaximoRegistros and formatos NEQ "excel">
	<!--- Busca nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo =  #session.Ecodigo#
	</cfquery>
	<!--- Invoca el Reporte --->		
	<cfreport format="#formatos#" template= "AntSalCliDet.cfr" query="rsReporte">
		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
		</cfif>
		<cfif isdefined("LvarAntiguedad1")>
			<cfreportparam name="P1" value="1 a #LvarAntiguedad1#">
		</cfif>		
		<cfif isdefined("LvarAntiguedad2")>
			<cfreportparam name="P2" value="#LvarAntiguedad1+1# a #LvarAntiguedad2#">
		</cfif>		
		<cfif isdefined("LvarAntiguedad3")>
			<cfreportparam name="P3" value="#LvarAntiguedad2+1# a #LvarAntiguedad3#">
		</cfif>
		<cfif isdefined("LvarAntiguedad4")>
			<cfreportparam name="P4" value="#LvarAntiguedad3+1# a #LvarAntiguedad4#">
		</cfif>

		<cfif isdefined("LvarAntiguedad5")>
			<cfreportparam name="P5" value="#LvarAntiguedad4+1# o Mas">
        </cfif>

		<cfreportparam name="Hoy" value="#LvarFechaFinal#">
	</cfreport>
<cfelse>
	<!--- Salida en formato HTML --->
	<!---
		Corte por:
				Sucursal
				Cliente
				Moneda
	--->
	<cfset MnombreAnt = "">
	<cfset SNnumeroAnt = "">
	<cfset OcodigoAnt = -1>
	<cf_htmlReportsheaders irA="./AntSalCliDet.cfm" FileName="AntiguedadSaldos#session.usucodigo#.xls">
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr>
			<td colspan="10"><cfoutput>#Session.Enombre#</cfoutput></td>
			<td colspan="2" align="right">Fecha:</td>
			<td colspan="2" align="left"><cfoutput>#dateformat(now(), "DD/MM/YYYY")#</cfoutput></td>
		</tr>
		<tr>
			<td colspan="10" style="font-size:large"><strong>Antiguedad de Saldos por Cliente Detallado</strong></td>
			<td colspan="2" align="right">Hora:</td>
			<td colspan="2" align="left"><cfoutput>#dateformat(now(), "HH:MM:SS")#</cfoutput></td>
		</tr>
		<tr>
			<td colspan="12" align="right">Corte:</td>
			<td colspan="2" align="left"><cfoutput>#dateformat(LvarFechaFinal, "DD/MM/YYYY")#</cfoutput></td>
		</tr>
		<tr><td colspan="14">&nbsp;</td></td>
		<cfflush interval="24">
		<cfoutput query="rsReporte">
			<cfset lflagPonerEncabezado = false>
			<cfif OcodigoAnt NEQ Ocodigo>
				<cfset MnombreAnt = Mnombre>
				<cfset SNnumeroAnt = SNnumero>
				<cfset OcodigoAnt = Ocodigo>
				<cfset lflagPonerEncabezado = true>
				<tr>
					<td colspan="14">Sucursal: #Odescripcion#</td>
				</tr>				
				<tr>
					<td colspan="14">Cliente:  #SNnumero# #SNnombre#</td>
				</tr>				
				<tr>
					<td colspan="14">Moneda:   #Mnombre#</td>
				</tr>				
			<cfelseif SNnumeroAnt NEQ SNnumero>
				<cfset SNnumeroAnt = SNnumero>
				<cfset MnombreAnt = Mnombre>
				<cfset lflagPonerEncabezado = true>
				<tr>
					<td colspan="14">Cliente:  #SNnumero# #SNnombre#</td>
				</tr>				
				<tr>
					<td colspan="14">Moneda:   #Mnombre#</td>
				</tr>				
			<cfelseif MnombreAnt NEQ Mnombre>
				<cfset MnombreAnt = Mnombre>
				<cfset lflagPonerEncabezado = true>
				<tr>
					<td colspan="14">Moneda:   #Mnombre#</td>
				</tr>				
			</cfif>
			<cfif lflagPonerEncabezado>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>Documento</td>
					<td>Fecha</td>
					<td>Venc.</td>
					<td align="right" nowrap="nowrap">Total</td>
					<td align="right" nowrap="nowrap">Saldo</td>
					<td align="right" nowrap="nowrap">Aplicado</td>
					<td align="right" nowrap="nowrap">Corriente</td>
					<td align="right" nowrap="nowrap">Sin Vencer</td>
					<td align="right" nowrap="nowrap">1 a #LvarAntiguedad1#</td>
					<td align="right" nowrap="nowrap">#LvarAntiguedad1+1# a #LvarAntiguedad2#</td>
					<td align="right" nowrap="nowrap">#LvarAntiguedad2+1# a #LvarAntiguedad3#</td>
					<td align="right" nowrap="nowrap">#LvarAntiguedad3+1# a #LvarAntiguedad4#</td>
					<td align="right" nowrap="nowrap">#LvarAntiguedad4+1# o Mas</td>
					<td align="right" nowrap="nowrap">Morosidad</td>
				</tr>
			</cfif>
			<tr>
				<td nowrap="nowrap">#CCTcodigo#-#Ddocumento#</td>
				<td nowrap="nowrap">#DateFormat(Dfecha, "DD/MM/YYYY")#</td>
				<td nowrap="nowrap"> #DateFormat(Dvencimiento, "DD/MM/YYYY")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(Total, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(Saldo, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(Total - Saldo, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(Corriente, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(SinVencer, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(P1, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(P2, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(P3, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(P4, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(P5, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(Morosidad, ",0.00")#</td>
			</tr>
			<cfflush>
		</cfoutput>
	</table>
</cfif>
<cfset rsReporte = javacast("null","")>
<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
<cfset javaRT.gc()>

<cffunction name="fnGeneraQueryReporte" access="private" output="no">
	<cfinclude template="/sif/Utiles/sifConcat.cfm">
	<cfif dateformat(LvarFechaFinal, "DD/MM/YYYY") EQ dateformat(now(), "DD/MM/YYYY")>
		<cfquery name="rsReporte" datasource="#session.DSN#">
			select 
				 s.SNnumero, 
				 m.Mnombre ,
				 o.Oficodigo as CodigoOficina,   <!--- Campo nuevo en el query para el ordenamiento --->
				 coalesce(c.CDCidentificacion, s.SNidentificacion) as IdentificacionCliente, <!--- Campo nuevo en el query para el ordenamiento --->
				 d.Dfecha,
				 d.CCTcodigo, 
				 d.Ddocumento,
				 d.Dvencimiento, 
				 s.SNidentificacion, 
				 s.SNnombre,
				 d.Ocodigo,
					ltrim(rtrim(coalesce(c.CDCidentificacion, s.SNidentificacion))) 
					#_Cat# 
					' - ' 
					#_Cat# 
					ltrim(rtrim(coalesce(c.CDCnombre, s.SNnombre))) as Cliente,
				 ltrim(rtrim(o.Oficodigo)) #_Cat# ' - ' #_Cat# ltrim(rtrim(o.Odescripcion)) as Odescripcion,
				 d.Dtotal * (case when t.CCTtipo = 'D' then 1.00 else -1.00 end) as Total,  
				 d.Dsaldo * (case when t.CCTtipo = 'D' then 1.00 else -1.00 end) as Saldo,
				 case when d.Dvencimiento >= #LvarFechaFinal# and d.Dfecha >= #LvarFechaInicioMes# and d.Dfecha < #dateadd('m', 1, LvarFechaInicioMes)#
						then d.Dsaldo 
						else 0.00 
				 end 
				 * (case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
				 as Corriente,
				 case when d.Dvencimiento >= #LvarFechaFinal# and d.Dfecha < #LvarFechaInicioMes#
						then d.Dsaldo 
						else 0.00 
				end 
				 * (case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
				as SinVencer,
				case when d.Dvencimiento 
                	< #LvarFechaFinal# and d.Dvencimiento >= #LvarFechaAntiguedad1#
						then d.Dsaldo 
						else 0.00 
				end 
				 * (case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
				as P1,
				
                case when d.Dvencimiento 
	                < #LvarFechaAntiguedad1# and d.Dvencimiento >= #LvarFechaAntiguedad2#
						then d.Dsaldo 
						else 0.00 
				end 
				 * (case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
				as P2,
				
                case when d.Dvencimiento 
	                < #LvarFechaAntiguedad2# and d.Dvencimiento >= #LvarFechaAntiguedad3#
						then d.Dsaldo 
						else 0.00 
				end 
				 * (case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
				as P3,
				
                case when d.Dvencimiento 
                	< #LvarFechaAntiguedad3# and d.Dvencimiento >= #LvarFechaAntiguedad4#
						then d.Dsaldo 
						else 0.00 
				end 
				 * (case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
				as P4,
                
				case when d.Dvencimiento 
                	< #LvarFechaAntiguedad4#
						then d.Dsaldo 
						else 0.00 
				end 
				 * (case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
				as P5,
				
                case when d.Dvencimiento < #LvarFechaAntiguedad5#
						then d.Dsaldo 
						else 0.00 
				end 
				 * (case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
				as Morosidad 
			from SNegocios s 
				inner join Documentos d
					inner join CCTransacciones t
					 on t.CCTcodigo = d.CCTcodigo
					and t.Ecodigo   = d.Ecodigo
	
					inner join HDocumentos dh
							left outer join ClientesDetallistasCorp c
							on c.CDCcodigo = dh.CDCcodigo
					 on dh.SNcodigo   = d.SNcodigo
					and dh.Ecodigo    = d.Ecodigo
					and dh.CCTcodigo  = d.CCTcodigo
					and dh.Ddocumento = d.Ddocumento
	
					inner join Oficinas o
					 on o.Ecodigo = d.Ecodigo
					and o.Ocodigo = d.Ocodigo
			
					inner join Monedas m
					on  m.Mcodigo = d.Mcodigo
					and m.Ecodigo = d.Ecodigo
			
				 on d.SNcodigo = s.SNcodigo
				and d.Ecodigo  = s.Ecodigo
			where s.Ecodigo =  #session.Ecodigo#
			<cfif isdefined("session.B2B.SNcodigo") and len(trim(session.B2B.SNcodigo))>
			  and s.SNcodigo = #session.B2B.SNcodigo#
			<cfelse>
			  and s.SNcodigo = -1
			</cfif>
			  and d.Dsaldo <> 0.00
			order by 1, 2, 3, 4, 5, 6, 7
		</cfquery>
	<cfelse>
		<cfset LvarSNcodigo = session.B2B.SNcodigo>
		<cfquery name="rsSocio" datasource="#session.dsn#">
			select SNid, SNnumero
			from SNegocios
			where Ecodigo = #session.Ecodigo#
			  and SNcodigo = #session.B2B.SNcodigo#
		</cfquery>
		<cfset LvarSNnumero = rsSocio.SNnumero>
		<cfset LvarSNid = rsSocio.SNid>
		<cfset CreaTemp2()>
		<cfset CreaTemp3()>
		<cfset CreaTemp4()>
		<cfset LvarFechaParam = DateFormat(LvarFechaFinal, "DD/MM/YYYY")>
		<cfset LvarFechaParam2 = DateFormat(LvarFechaInicioMes, "DD/MM/YYYY")>
		<cfset fnSaldosInicialesFechas(Session.Ecodigo, LvarSNcodigo, lvarSNid, LvarFechaParam, LvarFechaParam ,LvarSNnumero, LvarPeriodo, LvarMes, -1, ' ', -1, -1, LvarFechaParam2)>
		<cfquery name="rsReporte" datasource="#session.DSN#">
			select 
				 s.SNnumero, 
				 m.Mnombre ,
				 o.Oficodigo as CodigoOficina,   <!--- Campo nuevo en el query para el ordenamiento --->
				 coalesce(c.CDCidentificacion, s.SNidentificacion) as IdentificacionCliente, <!--- Campo nuevo en el query para el ordenamiento --->
				 d.Fecha as Dfecha,
				 d.TTransaccion as CCTcodigo, 
				 d.Documento as Ddocumento,
				 d.FechaVencimiento as Dvencimiento, 
				 s.SNidentificacion, 
				 s.SNnombre,
				 dh.Ocodigo,
					ltrim(rtrim(coalesce(c.CDCidentificacion, s.SNidentificacion))) 
					#_Cat# 
					' - ' 
					#_Cat# 
					ltrim(rtrim(coalesce(c.CDCnombre, s.SNnombre))) as Cliente,
				 ltrim(rtrim(o.Oficodigo)) #_Cat# ' - ' #_Cat# ltrim(rtrim(o.Odescripcion)) as Odescripcion,
				 d.Total as Total,  
				 d.SaldoFinal as Saldo,
				 case when d.FechaVencimiento >= #LvarFechaFinal# and d.Fecha >= #LvarFechaInicioMes# and d.Fecha < #dateadd('m', 1, LvarFechaInicioMes)#
						then d.SaldoFinal 
						else 0.00 
				 end 
				 as Corriente,
				 case when d.FechaVencimiento >= #LvarFechaFinal# and d.Fecha < #LvarFechaInicioMes#
						then d.SaldoFinal 
						else 0.00 
				end 
				as SinVencer,
				case when d.FechaVencimiento < #LvarFechaFinal# and d.FechaVencimiento >= #LvarFechaAntiguedad1#
						then d.SaldoFinal 
						else 0.00 
				end 
				as P1,
				case when d.FechaVencimiento < #LvarFechaAntiguedad1# and d.FechaVencimiento >= #LvarFechaAntiguedad2#
						then d.SaldoFinal 
						else 0.00 
				end 
				as P2,
				case when d.FechaVencimiento < #LvarFechaAntiguedad2# and d.FechaVencimiento >= #LvarFechaAntiguedad3#
						then d.SaldoFinal 
						else 0.00 
				end 
				as P3,
				case when d.FechaVencimiento < #LvarFechaAntiguedad3# and d.FechaVencimiento >= #LvarFechaAntiguedad4#
						then d.SaldoFinal 
						else 0.00 
				end 
				as P4,
				case when d.FechaVencimiento < #LvarFechaAntiguedad4#
						then d.SaldoFinal 
						else 0.00 
				end 
				as P5,
				case when 
					d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaFinal#">
						then d.SaldoFinal 
						else 0.00 
				end 
				as Morosidad 
			from SNegocios s 
				inner join #documentos# d
					inner join CCTransacciones t
					 on t.CCTcodigo = d.TTransaccion
					and t.Ecodigo   = d.Ecodigo
					inner join HDocumentos dh
							left outer join ClientesDetallistasCorp c
							on c.CDCcodigo = dh.CDCcodigo
					 on dh.SNcodigo   = d.Socio
					and dh.Ecodigo    = d.Ecodigo
					and dh.CCTcodigo  = d.TTransaccion
					and dh.Ddocumento = d.Documento
	
					inner join Oficinas o
					 on o.Ecodigo = dh.Ecodigo
					and o.Ocodigo = dh.Ocodigo
			
					inner join Monedas m
					on  m.Mcodigo = dh.Mcodigo
			
				 on d.Socio = s.SNcodigo
				and d.Ecodigo  = s.Ecodigo
			where s.Ecodigo =  #session.Ecodigo#
			  and s.SNcodigo = #session.B2B.SNcodigo#
			  and d.SaldoFinal <> 0.00
			order by 1, 2, 3, 4, 5, 6, 7 
		</cfquery>
	</cfif>
</cffunction>
