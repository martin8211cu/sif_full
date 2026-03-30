<cfsetting requesttimeout="8600">

<cfinvoke component="sif.Componentes.Translate"method="Translate"Key="MG_NOTC"Default="No existe registro de TC para la fecha de pago de la nomina"returnvariable="MG_NOTC"/> 
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Titulo"	Default="Reporte de Inconsistencias Generación de Asiento"	returnvariable="LB_Titulo"/>

<cfset LvarFileName = "Reporte_Inconsistencias.xls">

<cfquery name="rsEmpresas" datasource="#session.dsn#">
	select Ecodigo,Datasource,NIT,*
		from PurdyParam
		where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset purdy="#rsEmpresas.Datasource#">

<!---<cfset desde = CreateDate(2009, 01, 16)>
<cfset hasta = CreateDate(2009, 01, 31)>--->

<cfquery name="rsfecha" datasource="#session.dsn#">
	select RCNid, a.RCdesde, a.RChasta,CPfpago
		from HRCalculoNomina a,CalendarioPagos cp
		where cp.CPid = a.RCNid
			and a.RCNid = #form.RCNid#
			and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<cfset FechaP = #LSDateFormat(rsfecha.CPfpago, "yyyymmdd")#>


<cfquery name="rsTCid" datasource="#session.dsn#">
	select max(a.ID) as ID
	from PurdyTC a
	where a.Fecha = (select max(b.Fecha) from PurdyTC b 
		where b.Fecha between dateadd(d,-1,<cf_dbfunction name="date_format" args="#FechaP#,yyyymmdd">) and dateadd(d,1,<cf_dbfunction name="date_format" args="#FechaP#,yyyymmdd">))
</cfquery>

<cfif rsTCid.ID LT 0>
	<cfthrow message="#MG_NOTC# #FechaP#">
</cfif>


<cfquery name="rsTC" datasource="#session.dsn#">
	select ID,<cf_dbfunction name="date_format" args="Fecha,DD/MM/YYYY">,TC
	from PurdyTC
	where ID = #rsTCid.ID#
</cfquery>

<cfquery name="rsNomina" datasource="#session.dsn#">
	select RCNid, a.RCdesde, a.RChasta,CPfpago,a.RCDescripcion,cp.CPcodigo
		from HRCalculoNomina a,CalendarioPagos cp
		where cp.CPid = a.RCNid
			and a.RCNid = #form.RCNid#
			and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<!----------------------------------------------------------------->
<cfoutput>	
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
		<td align="center">
			<cf_htmlReportsHeaders 
			title="#LB_Titulo#" 
			filename="#LvarFileName#"
			param="&RCNid=#form.RCNid#&RCDescripcion=#rsNomina.RCDescripcion#" 
			irA="RepAsientosGenera.cfm">
			
			<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
				<tr>
					<td align="center" colspan="4"><strong><font size="2">
						<cfsavecontent variable="ENCABEZADO_IMP">
							<cf_EncReporte
								Titulo="#LB_Titulo#"
								Filtro1='Nómina del #LSDateFormat(rsNomina.RCdesde, "dd/mm/yyyy")#  al #LSDateFormat(rsNomina.RChasta, "dd/mm/yyyy")#'
								Filtro2='#rsNomina.CPcodigo# - #rsNomina.RCDescripcion#'>
						</cfsavecontent>
						#ENCABEZADO_IMP#
					</td>
				</tr>
				
				<cfif rsNomina.recordCount GT 0>
					<!---CarolRS, se modifica la tabla de lectura de RCuentasTipo a RCuentasTipoExactus--->
					<cfquery name="rsAsiento" datasource="#session.DSN#">
						select 	a.DEid, 
								cf.CFcodigo, 
								a.Cformato, 
								cp.CPcodigo, 
								cc.Cdescripcion,
								tipo,
								case tipo when  'C' then 
									a.montores <!--- * -1--->
								else a.montores  
								end  as monto, 
								case when ((<cf_dbfunction name="string_part" args="a.Cformato,4,1"> in ('5','6')) and (tiporeg <> 40))
									then rtrim(cf.CFcodigo) 
								when ((<cf_dbfunction name="string_part" args="a.Cformato,4,1"> not in ('5','6')) and (tiporeg = 40))
									then rtrim(cf.CFcodigo) 
							   	else  
							   		'00-0-0-0'
								end as subCFcodigo,
							<cf_dbfunction name="string_part" args="a.Cformato,4,10"> as subcformato,
						case tiporeg 	when 10 then 'Salario Base'
							when 20 then  'Incidencia - '+ isnull((select CIcodigo+' - '+CIdescripcion from HIncidenciasCalculo ha, CIncidentes hb where ICid = a.referencia and ha.CIid = hb.CIid),'')
							when 30 then (select distinct substring(DCcodigo+' - '+DCdescripcion,1,40) from HCargasCalculo ha, DCargas hb where ha.DClinea = a.referencia and ha.DClinea = hb.DClinea)
							when 40 then (select distinct substring(DCcodigo+' - '+DCdescripcion,1,40) from HCargasCalculo ha, DCargas hb where ha.DClinea = a.referencia and ha.DClinea = hb.DClinea)
							when 50 then (select distinct substring(DCcodigo+' - '+DCdescripcion,1,40) from HCargasCalculo ha, DCargas hb where ha.DClinea = a.referencia and ha.DClinea = hb.DClinea)
							when 55 then (select distinct substring(DCcodigo+' - '+DCdescripcion,1,40) from HCargasCalculo ha, DCargas hb where ha.DClinea = a.referencia and ha.DClinea = hb.DClinea)
							when 60 then (select distinct substring(TDcodigo+' - '+TDdescripcion,1,40) from HDeduccionesCalculo ha, TDeduccion  hb, DeduccionesEmpleado hc where ha.Did = a.referencia and hc.TDid = hb.TDid and ha.Did = hc.Did)
							when 70 then 'Imp. de Renta'
							when 80 then 'Salario a pagar'
							when 85 then 'Salario a pagar en Efectivo'
						end  as origen, 
						a.referencia
						from RCuentasTipoExactus a
							inner join HRCalculoNomina b
							on b.RCNid = a.RCNid
							inner join CFuncional cf 
							on cf.CFid = a.CFid
						
							inner join CContables cc 
							on (cc.Ccuenta=a.Ccuenta 
								<!---or rtrim(cc.Cformato) = rtrim(a.Cformato)--->
								)
								and cc.Ecodigo = a.Ecodigo
							inner join CalendarioPagos cp 
							on cp.CPid = a.RCNid 
							
							where a.RCNid = #form.RCNid#
								and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>	
					
						<cfquery name="rsCreditos" dbtype="query">
						select tipo, sum(monto) as monto, (sum(monto)/#rsTC.TC#)as mtoDolar
							from rsAsiento
							where tipo = 'C'
							group by tipo
					</cfquery>
					
					<cfquery name="rsDebitos" dbtype="query">
						select tipo, sum(monto) as monto, (sum(monto)/#rsTC.TC#)as mtoDolar
							from rsAsiento
							where tipo = 'D'
							group by tipo
					</cfquery>
					
					
					<cfquery name="rsAsientoExactus" dbtype="query"> 
						select subCFcodigo, subCformato, CPcodigo, origen, sum(monto) as monto, (sum(monto)/#rsTC.TC#)as mtoDolar,tipo
							from rsAsiento
							group by subCFcodigo, subCformato, CPcodigo, origen,tipo
					</cfquery>
				
					<cfquery name="rsParam" datasource="#session.DSN#">
						select *
						from PurdyParam
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>

					<cfquery name="rsConsecutivo"  datasource="#purdy#">
						select ultimo_asiento, substr(ultimo_asiento,5,10)+1 as nex
						from Paquete
						where paquete = '#rsParam.Paquete#'
					</cfquery>
					
					<cfset parte = ''>
					<cfloop from="#len(rsConsecutivo.nex)+1#" to='6' index="i">
						<cfset parte = parte & '0'>
					</cfloop>
					<cfset Asiento = 'PLAN' & '#parte#' & '#rsConsecutivo.nex#'>
				
					<cfset contadorlineas = 8>
					<cfset primercorte = true>
					<cfset Consecutivo = 0>
					<cfset buenos = 0>
					<cfset malos  = 0>
					
					<cfloop query="rsAsientoExactus">
						<cfquery datasource="#purdy#" name="rsCC">
							select centro_costo
							from centro_cuenta
							where centro_costo = '#rsAsientoExactus.subCFcodigo#'
								and cuenta_contable = '#rsAsientoExactus.subCformato#'
						</cfquery>
						
						<cfset Paso = 1>
						<cfif isdefined("rsCC") and rsCC.RecordCount EQ 0 >
							<cfset Paso = 2>
							<cfset malos = malos + 1>
							<cfif (contadorlineas gte 32 and rsAsientoExactus.CurrentRow NEQ 1)>
								<tr><td><H1 class=Corte_Pagina></H1></td></tr>
								<td align="center" colspan="4"><strong><font size="2">
								#ENCABEZADO_IMP#
								<cfset contadorlineas = 8>  
								</td>
							</cfif>
							<cfset contadorlineas = contadorlineas + 1>
							<tr><td colspan="3" align="left" class="letra">Registro con problemas verificar el Centro de Costo <strong>'#rsAsientoExactus.subCFcodigo#'</strong> y Cuenta Contable  <strong>'#rsAsientoExactus.subCformato#'</strong> que Existan en Exactus </td></tr>
						<cfelse>
							<cfset buenos = buenos + 1>
						</cfif>
					</cfloop>
				
					
					<cfif malos EQ 0 >
					
					
					<cfquery datasource="#purdy#">
						update Asiento_de_Diario set Fecha_Creacion = <cf_dbfunction name="today"		args=""  datasource="#purdy#" > ,
						Fecha_Ult_Modif = <cf_dbfunction name="today"		args=""  datasource="#purdy#" >
							where Asiento = 'PLAN000030'
					</cfquery>
					


					<cftransaction action="begin">	
						<cfquery datasource="#purdy#">
							insert into Asiento_de_Diario (
								Asiento,
								Paquete,
								Tipo_Asiento,
								Fecha,
								Contabilidad,
								Origen,
								Clase_Asiento,
								Total_Debito_Loc,
								Total_Debito_Dol,
								Total_Credito_Loc,
								Total_Credito_Dol,
								Ultimo_Usuario,
								Fecha_Ult_Modif,
								Marcado,
								Fecha_Creacion,
								Total_Control_Loc,
								Total_Control_Dol,
								Usuario_Creacion
							) Values (
								'#Asiento#',
								'PLAN',
								'PL01',
								'#LSDateFormat(rsNomina.CPfpago, "yyyymmdd")#',
								'A',
								'CG',
								'N',
								#rsDebitos.monto#,
								#rsDebitos.mtoDolar#,
								#rsCreditos.monto#,
								#rsCreditos.mtoDolar#,
								'SYSTEM',
								<!---'#LSDateFormat(Now(), "yyyymmdd")#',--->
								<cf_dbfunction name="today"		args=""  datasource="#purdy#" >,
								'N',
								<!---'#LSDateFormat(Now(), "yyyymmdd")#',--->
								<cf_dbfunction name="today"		args=""  datasource="#purdy#" >,
								0,
								0,
								'SYSTEM'
							)
						</cfquery>
					
						<cfset Consecutivo = 0>
						<cfloop query="rsAsientoExactus">
							<cfset Consecutivo = Consecutivo + 1>
							<cfquery datasource="#purdy#">
								insert into Diario (
									Asiento,
									Consecutivo,
									Centro_Costo,
									Cuenta_Contable,
									Fuente,
									Referencia,
									Debito_Local,
									Debito_Dolar,
									Credito_Local,
									Credito_Dolar,
									Tipo_Cambio,
									Nit
									) values (
									'#Asiento#',
									#Consecutivo#,
									'#rsAsientoExactus.subCFcodigo#',
									'#rsAsientoExactus.subCformato#',
									'#rsAsientoExactus.CPcodigo#',
									'#rsAsientoExactus.origen#',
									<cfif rsAsientoExactus.tipo EQ 'D'>
										#rsAsientoExactus.monto#,
										#rsAsientoExactus.mtoDolar#,
										0,
										0,
									<cfelse>	
										0,
										0,
										#rsAsientoExactus.monto#,
										#rsAsientoExactus.mtoDolar#,
									</cfif>
									#rsTC.TC#,
									'#rsEmpresas.NIT#'
									)
							</cfquery>
						</cfloop>
						
						<cfquery datasource="#purdy#">
							update Paquete set ultimo_asiento = '#Asiento#'
								where paquete = '#rsParam.Paquete#'
						</cfquery>
						
				
						
						<!---<cftransaction action="rollback">	--->
						</cftransaction>
												
						<tr><td colspan="3" align="center" class="letra">Número de Asiento Contable: #Asiento#</td></tr>
						<tr><td colspan="3" align="center" class="letra">* * * Proceso Concluido Sin Errores * * *</tr></tr>
					<cfelse>
						<tr><td colspan="3" align="left" class="letra">Total de Registros con Problemas: #malos# </td></tr>
						<tr><td colspan="3" align="left" class="letra">Total de Registros correctos: #buenos# </td></tr>
					</cfif>
				<cfelse>
					<tr><td colspan="3" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
					<!---<cfthrow message="#MG_NOTC#">--->

				</cfif>
				<tr><td colspan="3" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/sif/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
			</table>			
		</td>
	</tr>
	</table>
</cfoutput>
