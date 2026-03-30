<cfif isdefined('form.CPid1') and LEN(TRIM(form.CPid1))>
	<cfset CPid = form.CPid1>
	<cfset CPcodigo = form.CPcodigo1>
	<cfset Tcodigo = form.Tcodigo1>
<cfelseif isdefined('form.CPid2') and LEN(TRIM(CPid2))>
	<cfset CPid = form.CPid2>
	<cfset CPcodigo = form.CPcodigo2>
	<cfset Tcodigo = form.Tcodigo2>
</cfif>
<cfset prefijo = ''>
<!--- SE VERIFICA CON CUAL TIPO DE NOMINA SE VA A TIRAR EL REPORTE, NOMINAS APLICADAS O SIN APLICAR --->
<cfif isdefined('form.TipoNomina')>
	<cfset prefijo = 'H'>
</cfif>

<!---CONSULTA DEL TIPO DE CAMBIO--->
<cfquery name="rsTipoCambio" datasource="#session.DSN#">
	select coalesce(RCtc,1.00) as RCtc
	from #prefijo#RCalculoNomina
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
</cfquery>
<cfif isdefined('rsTipoCambio') and rsTipoCambio.RecordCount GT 0>
	<cfset form.Tipo_Cambio = rsTipoCambio.RCtc>
<cfelse>
	<cfset form.Tipo_Cambio = 1.00>
</cfif>

<!--- CONSULTA PARA EL REPORTE --->

<cfquery name="rsReporte" datasource="#session.DSN#">
	select de.DEid, DEapellido1 + ' ' + DEapellido2 + ', ' + DEnombre as nombre,
		coalesce(de.DEdato3,'No ha sido registrado') as NSeguroSocial,
		se.SEsalariobruto + coalesce((select coalesce(sum(round(c.ICmontores,2)),0.00)
							from #prefijo#SalarioEmpleado b
							inner join #prefijo#IncidenciasCalculo c
							on c.RCNid = b.RCNid
							and c.DEid =b.DEid
							and c.CIid in (select CIncidente1
											from RHTipoAccion
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and RHTcomportam in (3,5)
											and CIncidente1 is not null)
	
							where b.DEid = de.DEid
							  and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
							group by b.DEid),0.00) as SubTotalSalBruto,
		(se.SEsalariobruto + coalesce((select coalesce(sum(round(c.ICmontores,2)),0.00)
							from #prefijo#SalarioEmpleado b
							inner join #prefijo#IncidenciasCalculo c
							on c.RCNid = b.RCNid
							and c.DEid =b.DEid
							and c.CIid in (select CIncidente1
											from RHTipoAccion
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and RHTcomportam in (3,5)
											and CIncidente1 is not null)
	
							where b.DEid = de.DEid
							  and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
							group by b.DEid),0.00)) / <cfqueryparam cfsqltype="cf_sql_money" value="#form.Tipo_Cambio#"> as SalarioBrutoDolares,
		coalesce((select sum(c.ICmontores)
						from #prefijo#SalarioEmpleado b
						inner join #prefijo#IncidenciasCalculo c
							on c.RCNid = b.RCNid
							and c.DEid =b.DEid
							and c.CIid in (select CIncidente2
										from RHTipoAccion
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and RHTcomportam = 3
										and CIncidente2 is not null)
						where b.DEid = de.DEid
						  and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
						group by b.DEid),0.00) as Vacaciones,
		sum(cc.CCvaloremp) as CargasEmpleado,
		sum(cc.CCvalorpat) as CargasPatronales,
		coalesce((select sum(c.ICmontores)
								from #prefijo#SalarioEmpleado b
								inner join #prefijo#IncidenciasCalculo c
									on c.RCNid = b.RCNid
									and c.DEid =b.DEid
									and c.CIid in (select CIncidente2
													from RHTipoAccion
													where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													and RHTcomportam = 5
													and CIncidente2 is not null)
								where b.DEid = de.DEid
								  and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
								group by b.DEid),0.00) as Incapacidad,
		se.SErenta as ImpRenta,
		 coalesce((select sum(DCvalor)
								from #prefijo#DeduccionesCalculo a
								inner join DeduccionesEmpleado b
									on a.Did = b.Did
									and b.DEid = de.DEid
								inner join TDeduccion c
									on b.TDid = c.TDid
								left outer join FDeduccion d
									on c.TDid = d.TDid
								where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
								  and d.TDid is null
								group by b.DEid),0.00) as OtrasDeducciones,
		coalesce((select sum(DCvalor)
								from #prefijo#DeduccionesCalculo a
								inner join DeduccionesEmpleado b
									on a.Did = b.Did
									and b.DEid = de.DEid
								inner join TDeduccion c
									on b.TDid = c.TDid
								inner join FDeduccion d
									on c.TDid = d.TDid
								where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
								group by b.DEid),0.00) as RetencionesxEmbargo,
		se.SEliquido as SalarioNeto,
		se.SEliquido / <cfqueryparam cfsqltype="cf_sql_money" value="#tipo_cambio#"> as SalarioNetoDolares,
		cf.CFid,
		cf.CFdescripcion,
		cf.CFcodigo
	from DatosEmpleado de
	inner join #prefijo#SalarioEmpleado se
		on se.DEid = de.DEid
		and se.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
	inner join 	#prefijo#CargasCalculo cc
		on cc.DEid = se.DEid
		and cc.RCNid = se.RCNid
		
	inner join #prefijo#RCalculoNomina rc
	   on rc.RCNid = se.RCNid
	  and rc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">

	inner join LineaTiempo lt
	   on lt.DEid = se.DEid
	  and lt.LThasta = ( select max(lt2.LThasta) 
						from LineaTiempo lt2 
						where lt.DEid = lt2.DEid 
						  and lt2.LTdesde < = rc.RChasta 
						  and lt2.LThasta > = rc.RCdesde 
						  and lt.LTid = lt2.LTid )

	inner join RHPlazas p
	   on p.Ecodigo = lt.Ecodigo
	  and p.RHPid = lt.RHPid	
	
	inner join CFuncional cf
	   on cf.CFid = p.CFid
	
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	group by cf.CFid,
		cf.CFdescripcion,
		cf.CFcodigo,
		de.DEid, 
		DEapellido1 + ' ' + DEapellido2 + ', ' + DEnombre,
		coalesce(de.DEdato3,'No ha sido registrado'),
		se.SEsalariobruto,
		se.SErenta,
		se.SEliquido
	order by cf.CFdescripcion,
		DEapellido1 + ' ' + DEapellido2 + ', ' + DEnombre

</cfquery>


<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- Datos de la nomina --->
<cfquery name="rsNomina" datasource="#session.DSN#">
	select CPhasta, CPdesde, CPfpago
	from CalendarioPagos
	where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
</cfquery>

<cfif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 1>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 2>
	<cfset formatos = "pdf">
<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 3>
	<cfset formatos = "excel">
</cfif>
<!---<cf_dump var="#rsReporte#">--->

<cfif formatos EQ 'excel'>
<!------>	<cfif  isdefined("form.formatos") and form.formatos eq "Excel">
		<cfcontent type="application/msexcel">
		<cfheader 	name="Content-Disposition" 
		value="attachment;filename=RepNominaBARODASA_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
	</cfif>
		<style>
			h1.corte {
				PAGE-BREAK-AFTER: always;}
			.tituloAlterno {
				font-size:16px;
				font-weight:bold;
				text-align:center;}
			.titulo_empresa2 {
				font-size:14px;
				font-weight:bold;
				text-align:center;}
			.titulo_reporte {
				font-size:12px;
				font-style:italic;
				text-align:center;}
			.titulo_filtro {
				font-size:10px;
				font-style:italic;
				text-align:center;}
			.titulolistas {
				font-size:10px;
				font-weight:bold;
				background-color:#CCCCCC;
				}
			.titulo_columnar {
				font-size:8px;
				font-weight:bold;
				background-color:#CCCCCC;
				text-align:right;}
			.listaCorte {
				font-size:9px;
				font-weight:bold;
				background-color:#CCCCCC;
				text-align:left;}
			.detalle {
				font-size:8px;
				text-align:left;}
			.detaller {
				font-size:8px;
				text-align:right;}
			.detallec {
				font-size:9px;
				text-align:center;}	
				
			.mensaje {
				font-size:10px;
				text-align:center;}
			.paginacion {
				font-size:10px;
				text-align:center;}
		</style>	

<cfoutput>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
		<cfset contadorlineas = 1>
		<cfset primercorte = true>
		<cfif rsReporte.recordCount>
			<cfset corte = ''>
			<tr>
				<td align="center" colspan="15" class="detallec">#rsEmpresa.Edescripcion#</td>
			</tr>
			<tr>
				<td align="center" colspan="15" class="detallec">Per&iacute;odo: #LSDateFormat(rsNomina.CPhasta,'mmm-dd-yyyy')# a #LSDateFormat(rsNomina.CPdesde,'mmm-dd-yyyy')#</td>
			</tr>
			<tr><td align="center" colspan="15" class="detallec">Fecha de Pago: #LSDateFormat(rsNomina.CPfpago,'mmm-dd-yyyy')#</td></tr>
			<tr><td align="center" colspan="15" class="detallec">Tipo de Cambio: #LSNumberFormat(form.Tipo_cambio, ',9.00')#</td></tr>
			<tr><td align="right" colspan="15"  class="detaller">Preparado por: #session.datos_personales.Nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#</td></tr>
			<tr><td align="right" colspan="15"class="detaller">Revisado por: _______________________</td></tr>
			<tr><td colspan="15">&nbsp;</td></tr>
			<tr class="titulo_columnar">
				<td align="left">Nombre</td>
				<td align="center">N&uacute;mero <br>Soc. Seg.</td>
				<td align="center">SUB TOTAL <br>SALARIO NETO <br>&cent;</td>
				<td align="center">SUB TOTAL <br>SALARIO NETO <br>$</td>
				<td align="center">Vacaciones <br>(+)</td>
				<td align="center">Salario <br>Bruto &cent;</td>
				<td align="center">Salario <br>Bruto $</td>				
				<td align="center">CCSS 9% <br>(-)</td>
				<td align="center">Cargas<br> Soc. 25%</td>
				<td align="center">Incapacidad <br>(+)</td>
				<td align="center">Imp. Renta <br>(-)</td>
				<td align="center">Otras <br>Deducc.</td>
				<td align="center">Ret. <br>p/embargo<br> (-)</td>
				<td align="center">Salario <br>Neto &cent;</td>
				<td align="center">Salario <br>Neto $</td>
			</tr>
			<cfset TotalCFSubSalNeto = 0.00>
			<cfset TotalCFSubSalNetoD = 0.00>
			<cfset TotalCFVacaciones = 0.00>
			<cfset TotalCFSalBruto = 0.00>
			<cfset TotalCFSalBrutoD = 0.00>
			<cfset TotalCFCCSS = 0.00>
			<cfset TotalCFCargasSoc = 0.00>
			<cfset TotalCFIncap = 0.00>
			<cfset TotalCFImpRenta = 0.00>
			<cfset TotalCFOtrasDed = 0.00>
			<cfset TotalCFRetpEmb = 0.00>
			<cfset TotalCFSalNeto = 0.00>
			<cfset TotalCFSalNetoD = 0.00>
			<cfloop query="rsReporte">
				<cfset Lvar_CFdescripcion = trim(rsReporte.CFdescripcion)>
				<cfif (contadorlineas gte 50 and rsReporte.CurrentRow NEQ 1) or  primercorte>
				  <tr>
					<td class="listaCorte" nowrap colspan="2">#Lvar_CFdescripcion#</td>
				  </tr>
				  <cfset corte = rsReporte.CFdescripcion>
				  <cfset primercorte = false>
				  <cfset contadorlineas = 1>  
				</cfif> 
				
				<cfif corte NEQ Lvar_CFdescripcion>
				  <cfset corte = Lvar_CFdescripcion>
					<tr bgcolor="CCCCCC">
						<td colspan="2" class="detalle">Total </td>
						<td class="detaller">#LSNumberFormat(TotalCFSubSalNeto, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFSubSalNetoD, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFVacaciones, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFSalBruto, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFSalBrutoD, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFCCSS, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFCargasSoc, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFIncap, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFImpRenta, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFOtrasDed, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFRetpEmb, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFSalNeto, ',9.00')#</td>
						<td class="detaller">#LSNumberFormat(TotalCFSalNetoD, ',9.00')#</td>
					</tr>
					<tr>
						<td class="listaCorte" nowrap colspan="2">#Lvar_CFdescripcion#</td>
					</tr>
					<cfset TotalCFSubSalNeto = 0.00>
					<cfset TotalCFSubSalNetoD = 0.00>
					<cfset TotalCFVacaciones = 0.00>
					<cfset TotalCFSalBruto = 0.00>
					<cfset TotalCFSalBrutoD = 0.00>
					<cfset TotalCFCCSS = 0.00>
					<cfset TotalCFCargasSoc = 0.00>
					<cfset TotalCFIncap = 0.00>
					<cfset TotalCFImpRenta = 0.00>
					<cfset TotalCFOtrasDed = 0.00>
					<cfset TotalCFRetpEmb = 0.00>
					<cfset TotalCFSalNeto = 0.00>
					<cfset TotalCFSalNetoD = 0.00>
				  
				</cfif>
				  <tr>
					<td class="detalle">#rsReporte.Nombre#</td>
					<td class="detalle">#rsReporte.NSeguroSocial#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.SubTotalSalBruto, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.SalarioBrutoDolares, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.Vacaciones, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.SubTotalSalBruto+rsReporte.Vacaciones, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat((rsReporte.SubTotalSalBruto+rsReporte.Vacaciones)/form.tipo_cambio, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.CargasEmpleado, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.CargasPatronales, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.Incapacidad, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.ImpRenta, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.OtrasDeducciones, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.RetencionesxEmbargo, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.SalarioNeto, ',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.SalarioNetoDolares, ',9.00')#</td>
				  </tr>
				<cfset TotalCFSubSalNeto = TotalCFSubSalNeto + rsReporte.SubTotalSalBruto>
				<cfset TotalCFSubSalNetoD = TotalCFSubSalNetoD + rsReporte.SalarioBrutoDolares>
				<cfset TotalCFVacaciones = TotalCFVacaciones + rsReporte.Vacaciones>
				<cfset TotalCFSalBruto = TotalCFSalBruto + rsReporte.SubTotalSalBruto+rsReporte.Vacaciones>
				<cfset TotalCFSalBrutoD = TotalCFSalBrutoD +(rsReporte.SubTotalSalBruto+rsReporte.Vacaciones)/form.tipo_cambio >
				<cfset TotalCFCCSS = TotalCFCCSS + rsReporte.CargasEmpleado>
				<cfset TotalCFCargasSoc = TotalCFCargasSoc + rsReporte.CargasPatronales>
				<cfset TotalCFIncap = TotalCFIncap + rsReporte.Incapacidad>
				<cfset TotalCFImpRenta = TotalCFImpRenta + rsReporte.ImpRenta>
				<cfset TotalCFOtrasDed = TotalCFOtrasDed + rsReporte.OtrasDeducciones>
				<cfset TotalCFRetpEmb = TotalCFRetpEmb + rsReporte.RetencionesxEmbargo>
				<cfset TotalCFSalNeto = TotalCFSalNeto+ rsReporte.SalarioNeto>
				<cfset TotalCFSalNetoD = TotalCFSalNetoD + rsReporte.SalarioNetoDolares>
				<cfset contadorlineas = contadorlineas + 1>  
			</cfloop>
			<tr bgcolor="CCCCCC">
				<td colspan="2" class="detalle">Total </td>
				<td class="detaller">#LSNumberFormat(TotalCFSubSalNeto, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFSubSalNetoD, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFVacaciones, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFSalBruto, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFSalBrutoD, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFCCSS, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFCargasSoc, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFIncap, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFImpRenta, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFOtrasDed, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFRetpEmb, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFSalNeto, ',9.00')#</td>
				<td class="detaller">#LSNumberFormat(TotalCFSalNetoD, ',9.00')#</td>
			</tr>
		  	<tr><td colspan="15">&nbsp;</td></tr>
			</table>
		</cfif>
</cfoutput>			

<cfelse>
	<cfreport format="#formatos#" template="RepNominaBARODASA.cfr" query="rsReporte" overwrite="yes">
		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
		</cfif>
		<cfif isdefined('rsNomina') and rsNomina.RecordCount GT 0>
			<cfreportparam name="FechaD" value="#rsNomina.CPdesde#">
			<cfreportparam name="FechaH" value="#rsNomina.CPhasta#">
			<cfreportparam name="FechaP" value="#rsNomina.CPfpago#">
		</cfif>
		<cfreportparam name="TipoCambio" value="#form.Tipo_cambio#">
		<cfreportparam name="usuario" value="#session.datos_personales.Nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#">
	</cfreport>
</cfif>

