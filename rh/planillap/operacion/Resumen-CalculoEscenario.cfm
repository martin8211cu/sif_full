<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Resumen Calculo del Escenario</title>
</head>
<body>	
<cf_templateheader template="#session.sitio.template#" >
			<cfsetting requesttimeout="8400">
			<cfif isdefined("url.RHEid") and len(trim(url.RHEid)) and not isdefined("form.RHEid")>
				<cfset form.RHEid = url.RHEid>
			</cfif>
			
			<!----Tabla temporal de meses(Guarda todos los meses/periodos del escenario para c/centro funcional y componente)--->
			<cf_dbtemp name="tempDatos" returnvariable="tempDatos" datasource="#session.DSN#">
				<cf_dbtempcol name="Monto"		 	type="money"		mandatory="yes"> 
				<cf_dbtempcol name="CPformato"	 	type="varchar(100)"	mandatory="yes"> 
				<cf_dbtempcol name="Periodo"	 	type="int"			mandatory="yes"> 
				<cf_dbtempcol name="Mes"	 	 	type="int"			mandatory="yes"> 
			</cf_dbtemp>
			
			<!---Tabla temporal de datos (Guarda los distintos centros funcionales)---->
			<cf_dbtemp name="tempMeses" returnvariable="tempMeses" datasource="#session.DSN#">
				<cf_dbtempcol name="Mes"		 type="int"				mandatory="yes"> 
				<cf_dbtempcol name="Periodo"	 type="int"				mandatory="yes"> 
				<cf_dbtempcol name="CPformato"	 type="varchar(100)"	mandatory="yes">
			</cf_dbtemp>
			
			<!----Datos del escenario---->
			<cfquery name="rsEscenario" datasource="#session.DSN#">
				select 	RHEdescripcion,
						RHEfdesde,
						RHEfhasta
				from RHEscenarios esc
				where esc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and esc.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	 
			</cfquery>		
			
			<!----Centros Funcionales---->
			<cfquery name="rsCuentasP" datasource="#session.DSN#">
				select b.CPformato
					from RHFormulacion a
						inner join RHCFormulacion b
							on a.RHFid = b.RHFid
						inner join RHCortesPeriodoF c
							on b.RHCFid = c.RHCFid			
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and b.CPformato is not null	
						and ltrim(rtrim(b.CPformato))!= ''	 
				 union 
			 
				select b.CPformato 
				from RHOPFormulacion a
				inner join RHOPDFormulacion d
					on d.RHOPFid = a.RHOPFid
				inner join RHOtrasPartidas c
					on c.RHOPid = a.RHOPid
				inner join RHPOtrasPartidas b
					on b.RHPOPid = c.RHPOPid
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
				group by b.CPformato
                union
                
                select CPformato
                from RHCPFormulacion
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
                  and ltrim(rtrim(CPformato))!= ''
                  
			</cfquery>
		
			<!----Fecha inicial del escenario---->
			<cfquery name="rsInicio" datasource="#session.DSN#">
				  select min(fdesdecorte) as desde
				  from RHFormulacion
				  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			 </cfquery>
			 
			 <!---Fecha final del escenario---->
			 <cfquery name="rsFinal" datasource="#session.DSN#">
				  select max(fhastacorte) as hasta
				  from RHFormulacion
				  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			 </cfquery>				
			 
			 <!--- Fecha incial del escenario Otras Partidas --->
			 <cfquery name="rsInicioOP" datasource="#session.DSN#">
			 	select min(fdesde) as desde
				from RHOPFormulacion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			 </cfquery>
			 <!--- Fecha final del escenario Otras Partidas --->
			 <cfquery name="rsFinalOP" datasource="#session.DSN#">
			 	select max(fhasta) as hasta
				from RHOPFormulacion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			 </cfquery>			 
			 <!---Para c/Cfuncional insertar las fechas----->
		
			 <cfloop query="rsCuentasP">
				 <cfif LEN(TRIM(rsInicioOP.desde)) GT 0 and rsInicio.desde LT rsInicioOP.desde>
				 	<cfset inicio = rsInicioOP.desde >
				<cfelse>
					<cfset inicio = rsInicio.desde >
				</cfif>
				 <cfif LEN(TRIM(rsFinalOP.hasta)) GT 0 and rsFinal.hasta GT rsFinalOP.hasta>
				 	<cfset fin = rsFinalOP.hasta >
				<cfelse>
					<cfset fin = rsFinal.hasta >
				</cfif>
				 
				 <cfloop condition=" inicio lte fin " >		
					<cfquery datasource="#session.DSN#">
						insert into #tempMeses#(Mes, Periodo, CPformato)
						values(<cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('m', inicio)#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('yyyy', inicio)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasP.CPformato#">)
					</cfquery>			
					<cfset inicio = dateadd('m', 1, inicio) >
				 </cfloop>
				
			 </cfloop>
			 <!---Meses/Periodos ----->
			 <cfquery name="rsMesesPeriodo" datasource="#session.DSN#">
				select 	distinct Periodo, 
						case Mes 	when 1 then 'Enero' 
									when 2 then 'Febrero'
									when 3 then 'Marzo'
									when 4 then 'Abril'
									when 5 then 'Mayo'
									when 6 then 'Junio'
									when 7 then 'Julio'
									when 8 then 'Agosto'
									when 9 then 'Setiembre'
									when 10 then 'Octubre'
									when 11 then 'Noviembre'
									when 12 then 'Diciembre'
						end as MesTexto,
						Mes
				from #tempMeses#
				Order by Periodo,Mes
			 </cfquery>	
				
			
			<!----Centros funcionales y sus componentes----->
			<cfquery datasource="#session.DSN#" name="y">
				insert into #tempDatos#(Monto, CPformato, Periodo, Mes)
				select 	sum(ctp.Monto),
						cfm.CPformato,
						ctp.Periodo,
						ctp.Mes			
				from  #tempMeses# tm
						inner join RHCortesPeriodoF ctp	
							on tm.Periodo = ctp.Periodo
							and tm.Mes = ctp.Mes
																			
						inner join RHCFormulacion cfm
							on cfm.RHCFid = ctp.RHCFid
							and tm.CPformato = cfm.CPformato
				
						inner join RHFormulacion fm
							on cfm.RHFid = fm.RHFid
							and fm.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	 
				group by cfm.CPformato, ctp.Periodo, ctp.Mes
			</cfquery>
			<cfquery name="OP" datasource="#session.DSN#">
				insert into #tempDatos#(Monto, CPformato, Periodo, Mes)
				select sum(b.Monto) as monto,
						d.CPformato,
						b.Periodo,
						b.Mes	
				from RHOPFormulacion a
				inner join RHOPDFormulacion b
					on b.RHOPFid = a.RHOPFid
				inner join RHOtrasPartidas c
					on c.RHOPid = a.RHOPid
				inner join RHPOtrasPartidas d
					on d.RHPOPid = c.RHPOPid
				where a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	 
		        group by d.CPformato, b.Periodo, b.Mes
			</cfquery>
            <!--- datos de las cargas --->
            <cfquery name="CP" datasource="#session.DSN#">
				  insert into #tempDatos#(Monto, CPformato, Periodo, Mes)  
				select sum(b.RHCPFmontoCarga) as monto,
						b.CPformato,
						a.Periodo,
						a.Mes	
				from #tempMeses# a
                inner join RHCPFormulacion b
                	on b.Periodo = a.Periodo
                    and b.Mes =a.Mes
                    and b.CPformato = a.CPformato
				where b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	 
		        group by b.CPformato, a.Periodo, a.Mes
			</cfquery>
			<cfquery name="rsDatos" datasource="#session.DSN#">
				select 	a.CPformato, 				
						a.Periodo, 
						a.Mes, 
						sum(coalesce(b.Monto, 0)) as Monto
						
				from #tempMeses# a
					left join #tempDatos# b
						on b.Periodo = a.Periodo
						and b.Mes = a.Mes
						and b.CPformato = a.CPformato
				group  by a.CPformato, a.Periodo, a.Mes
				order by a.CPformato, a.Periodo, a.Mes
			</cfquery>
			
			<form name="form1" method="post" action="escenario-aprobar-sql.cfm">
				<input type="hidden" name="RHEid" value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))><cfoutput>#form.RHEid#</cfoutput></cfif>">				
				<table border="0" width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<cfif rsDatos.RecordCount NEQ 0>
						<tr>
							<td align="right">
								<table ><tr><td><cf_botones include="Aplicar,Regresar" exclude="Alta,Limpiar"></td></tr></table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</cfif>
					<tr>
						<td align="center"><strong style="color:#003366; font-family:'Times New Roman', Times, serif; font-size:12pt; font-variant:small-caps; font-weight:bolder;"><cfoutput>#session.Enombre#</cfoutput></strong></td>
					</tr>					
					<tr>
						<td align="center">
							<a href="TrabajarEscenario.cfm?RHEid=<cfoutput>#form.RHEid#</cfoutput>">
							<strong style="color:#003366; font-family:'Times New Roman', Times, serif; font-size:12pt; font-variant:small-caps; font-weight:bolder;">
								<cfoutput>Escenario: &nbsp;&nbsp;#rsEscenario.RHEdescripcion#</cfoutput>
							</strong>
							</a>
						</td>
					</tr>
					<tr>
						<td align="center">
							<strong style="color:#003366; font-family:'Times New Roman', Times, serif; font-size:12pt; font-variant:small-caps; font-weight:bolder;">
								<cfoutput>Del #LSDateFormat(rsEscenario.RHEfdesde,'dd/mm/yyyy')# al #LSDateFormat(rsEscenario.RHEfhasta,'dd/mm/yyyy')#</cfoutput>
							</strong>
						</td>
					</tr>	
					<tr>
						<td align="center">
							<strong style="color:#003366; font-family:'Times New Roman', Times, serif; font-size:12pt; font-variant:small-caps; font-weight:bolder;">
								Resultado del C&aacute;lculo 
							</strong>
						</td>
					</tr>	
					<tr><td>&nbsp;</td></tr>				
					<tr><td>&nbsp;</td></tr>
					<cfif rsDatos.RecordCount NEQ 0>
						<tr>
							<td align="center">
								<div style="overflow:auto;height:360px; width:920px">
									<table width="100%" cellpadding="5" cellspacing="0" bgcolor="#CAE0ED">
										<tr bgcolor="#005A95" style="border-bottom:1px solid;">
											<td nowrap="nowrap" width="20%"><strong style="font-size:10px;color:#D4FFFF">Cuenta Presupuestaria</strong></td>											
											<cfoutput query="rsMesesPeriodo" >
												<td align="center"><strong style="color:##D4FFFF;font-size:10px">#rsMesesPeriodo.MesTexto#<br>#rsMesesPeriodo.Periodo#</strong></td>
											</cfoutput>	
										</tr>								
										<cfoutput query="rsDatos" group="CPformato"><!---Para las cuentas presupuestarias---->
											<tr>
												<td  width="20%" nowrap="nowrap" align="right" bgcolor="##CAE0ED" style="border-right:1px solid;"><!---##E6EAE9---->
													#rsDatos.CPformato#
												</td>												
												<cfoutput><!---Para los meses/monto---->
													<td nowrap="nowrap" bgcolor="##FFFFFF" style="border-bottom:1px solid; border-right:1px solid;">
														#LSNumberFormat(rsDatos.Monto,',9.00')#
													</td>
												</cfoutput>
											</tr>
										</cfoutput>											
									</table>
								</div>
							</td>
						</tr>					
					<cfelse>
						<tr><td align="center"s><strong>------- No se encontraron registros -------</strong></td></tr>
					</cfif>
				</table>
			</form>	
	<cf_templatefooter template="#session.sitio.template#" >
	<script language="javascript1.2" type="text/javascript">
		function funcRegresar(){
			location.href = 'TrabajarEscenario.cfm?RHEid=<cfoutput>#form.RHEid#</cfoutput>';
			return false;
		}
		function funcAplicar(){
			if(confirm("Este seguro de aplicar el escenario? Esta operación no se puede reversar."))
				return true;
			return false;
		}
	</script>
	

</body>
</html>					
