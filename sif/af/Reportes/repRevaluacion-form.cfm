<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined('url.imprimir')>
	<cfif isdefined('url.AGTPid') and not isdefined('form.AGTPid')>
		<cfset form.AGTPid = url.AGTPid>
	</cfif>					
	<cfif isdefined('url.FAplaca') and not isdefined('form.FAplaca')>
		<cfset form.FAplaca = url.FAplaca>
	</cfif>
	<cfif isdefined('url.FCategoria') and not isdefined('form.FCategoria')>
		<cfset form.FCategoria = url.FCategoria>
	</cfif>
	<cfif isdefined('url.FClase') and not isdefined('form.FClase')>
		<cfset form.FClase = url.FClase>
	</cfif>															
	<cfif isdefined('url.FCentroF') and not isdefined('form.FCentroF')>
		<cfset form.FCentroF = url.FCentroF>
	</cfif>	
</cfif>

<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
}
.style2 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }

.style4 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
}
.style5 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
}
.style6 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 7px;
	font-weight: bold;
}
-->
</style>

<!--- Consultas de Periodo y Mes --->
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select Pvalor as value
	from Parametros
	where Ecodigo =  #session.Ecodigo# 
		and Pcodigo = 50
		and Mcodigo = 'GN'
</cfquery>

<cfquery name="rsMes" datasource="#session.dsn#">
	select Pvalor as value
	from Parametros
	where Ecodigo =  #session.Ecodigo# 
		and Pcodigo = 60
		and Mcodigo = 'GN'
</cfquery>

<!--- Valida si están definidos el Periodo y el Mes --->
<cfif rsPeriodo.RecordCount neq 1 or rsMes.RecordCount neq 1>
	<cf_errorCode	code = "50090" msg = "No están bien definidos el periodo y mes de auxiliares! Proceso Cancelado!">
</cfif>

<!--- Consulta a la tabla de Procesos --->
<cfquery name="rsAGTProceso" datasource="#session.dsn#">
	select AGTPdescripcion, AGTPestadp, AGTPperiodo, AGTPmes
	from AGTProceso
	where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AGTPid#">
</cfquery>

<!--- Valida si la consulta viene vacia --->
<cfif rsAGTProceso.recordcount eq 0>
	<cf_errorCode	code = "50105" msg = "No se encontró la transacción de Revaluación, Proceso Cancelado!">
</cfif>

<!--- Asignación de valores de la tabla de Procesos --->
<cfset HoraReporte = Now()> 
<cfset Estado = rsAGTProceso.AGTPestadp>
<cfset grupodesc = rsAGTProceso.AGTPdescripcion>

<!--- Consulta para pintar el reporte de Revaluaciones --->
<cfquery name="listaDetalle" datasource="#session.DSN#" maxrows="22001">
	
	select  (select cf.CFcodigo 	  #_Cat# ' - ' #_Cat# cf.CFdescripcion   from CFuncional cf where cf.CFid = ta.CFid) as CFuncional,	
			(select cat.ACcodigodesc  #_Cat# ' - ' #_Cat# cat.ACdescripcion  from ACategoria cat where cat.Ecodigo = act.Ecodigo and cat.ACcodigo = act.ACcodigo) as Categoria,
			(select clas.ACcodigodesc #_Cat# ' - ' #_Cat# clas.ACdescripcion from AClasificacion clas where clas.Ecodigo = act.Ecodigo and clas.ACcodigo = act.ACcodigo and clas.ACid = act.ACid) as Clase,
			(select ofi.Oficodigo 	  #_Cat# ' - ' #_Cat# ofi.Odescripcion   from CFuncional cf inner join Oficinas ofi on ofi.Ecodigo = cf.Ecodigo and ofi.Ocodigo = cf.Ocodigo where cf.CFid = ta.CFid) as Oficina,	
			(select dto.Deptocodigo   #_Cat# ' - ' #_Cat# dto.Ddescripcion   from CFuncional cf inner join Departamentos dto on dto.Ecodigo = cf.Ecodigo and dto.Dcodigo = cf.Dcodigo where cf.CFid = ta.CFid) as Departamento,
			ta.TAperiodo as Periodo, 
			ta.TAmes as Mes,
			act.Aplaca as PlacaSinRepetir, 
			act.Aplaca as Placa, 
			act.Adescripcion as ActivoSinRepetir, 
			act.Adescripcion as Activo, 
			act.Aserie as Serie,
			'Costo' as TipoMonto,
			coalesce(ta.TAvaladq,0.00) as Adquisicion, 
			coalesce(ta.TAvalmej,0.00) as Mejoras, 
			coalesce(ta.TAvalrev,0.00) as Revaluacion, 
			coalesce(ta.TAvaladq + ta.TAvalmej + ta.TAvalrev,0.00) as MontoTotal,
			<!---coalesce(ta.AFIindice,0.00) as Indice,--->
			(coalesce(ta.AFIindice,0.00)) as Indice,
			coalesce(ta.TAmontolocadq + ta.TAmontolocmej + ta.TAmontolocrev,0.00) as MontoRevaluacion,
			<!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
			i.Cformato as Cuenta_Costo_Reeval,
			j.Cformato as Cuenta_Depreciacion_Reeval,
			<!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
			'' as espacio
	
	from <cfif Estado lt 4>ADTProceso<cfelse>TransaccionesActivos</cfif> ta 
			inner join Activos act
				on act.Ecodigo = ta.Ecodigo
				and act.Aid = ta.Aid
					<!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
					inner join ACategoria d on d.ACcodigo = act.ACcodigo and d.Ecodigo = act.Ecodigo
					inner join AClasificacion e on e.ACid = act.ACid and e.ACcodigo = act.ACcodigo and e.Ecodigo = act.Ecodigo
						inner join CContables i on i.Ccuenta = e.ACcrevaluacion and e.Ecodigo = act.Ecodigo
						inner join CContables j on j.Ccuenta = e.ACcdepacumrev and e.Ecodigo = act.Ecodigo
					<!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
				<cfif isdefined('form.FAplaca') and len(trim(form.FAplaca))>
					and act.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAplaca#">
				</cfif>
				<cfif isdefined('form.FCategoria') and len(trim(form.FCategoria))>
					and act.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FCategoria#">
				</cfif>		
				<cfif isdefined('form.FClase') and len(trim(form.FClase))>
					and act.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FClase#">
				</cfif>	
		<cfif isdefined('form.FCentroF') and len(trim(form.FCentroF))>
			inner join CFuncional cfx 
				on cfx.CFid = ta.CFid 
				and cfx.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCentroF#">
		</cfif>									

	where ta.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ta.AGTPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		and ta.IDtrans=3
	order by 1, 2, 3, 9, 13
</cfquery>

<!--- Valida que la consulta del reporte no pase de las 22000 registros --->
<cfif listaDetalle.recordcount GT 22000>
	<table width="50%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td align="left">
				<p>
					La cantidad de activos sobrepasa los 22000 registros. Genero <cfoutput>#listaDetalle.recordcount#</cfoutput> Registros<br>
					Reduzca el rango mediante los filtros o utilice la opción de cargar la información en un archivo (Descargar).
					Proceso Cancelado.
				</p>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	
<cfelse>
	<cf_htmlReportsHeaders 
			title="Impresion de Revaluaci&oacute;n" 
			filename="RepRevaluacion.xls"
			irA="repRevaluacion.cfm?AGTPid="
			download="no"
			preview="no">
			
	<!--- Cambio el número de mes al nombre (Etiqueta) --->
	<cfquery name="GetMonthNames" datasource="#session.dsn#">
		select VSdesc as MonthName
		from VSidioma v
			inner join Idiomas i
				on i.Iid = v.Iid
				and i.Icodigo = '#session.Idioma#'
		where v.VSgrupo = 1
		order by <cf_dbfunction name="to_number" args="VSvalor" datasource="#session.dsn#">
	</cfquery>
	<cfset listMeses = ValueList(GetMonthNames.MonthName)>
		
	
	<table width="100%" border="0" cellspacing="2" cellpadding="0">
		<tr>
			<td colspan="11" align="center" bgcolor="#E4E4E4"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>
		</tr>			
		<tr>
			<td colspan="11" align="center"><span class="style1">Lista de Transacciones de Revaluaci&oacute;n</span></td>
		</tr>
		<tr>
			<td colspan="11" align="center"><span class="style1"><cfoutput>del grupo #grupodesc#</cfoutput></span></td>
		</tr>		
		<tr>
			<td colspan="11" align="center"><cfoutput><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></cfoutput></td>
		</tr>
		<tr>
			<td colspan="11" align="center"><cfoutput><strong>Periodo</strong> #rsAGTProceso.AGTPperiodo# / <strong>Mes</strong> #ListGetAt(listMeses,rsAGTProceso.AGTPmes)#</cfoutput></td>
		</tr>				
		
		<tr class="style6"><td colspan="11">&nbsp;</td></tr>
		<tr class="style5">
			<td align="left">Placa</td>
			<td align="left">Activo</td>
			<td align="left">Tipo Monto</td>
			<td align="right">Monto Adquisici&oacute;n</td>
			<td align="right">Monto Mejoras</td>
			<td align="right">Monto Revaluaci&oacute;n</td>
			<td align="right">Monto Total</td>
			<td align="right">&Iacute;ndice</td>
			<td align="right">Monto Revaluaci&oacute;n</td>
			<!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
			<td align="right">Cuenta Costo de Reevaluaci&oacute;n</td>
			<td align="right">Cuenta Depreciaci&oacute;n de Reevaluaci&oacute;n</td>
			<!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
		</tr>

		<cfflush interval="128">
		<cfoutput query="listaDetalle" group="CFuncional">
			<tr>
				<td align="left" colspan="9" nowrap="nowrap" class="style5">Centro Funcional: #CFuncional#</td>
			</tr>
			<cfset LvarAdquisicionC3  		= 0>
			<cfset LvarMejorasC3 	  		= 0>
			<cfset LvarRevaluacionC3  		= 0>
			<cfset LvarMontoTotalC3   		= 0>
			<cfset LvarIndiceC3  	  		= 0>
			<cfset LvarMontoRevaluacionC3   = 0>

				<cfoutput group="Categoria">
					<tr>
						<td align="left" colspan="9" nowrap="nowrap" class="style5">Categor&iacute;a: #Categoria#</td>
					</tr>
					<cfset LvarAdquisicionC2  		= 0>
					<cfset LvarMejorasC2 	  		= 0>
					<cfset LvarRevaluacionC2  		= 0>
					<cfset LvarMontoTotalC2   		= 0>
					<cfset LvarIndiceC2  	  		= 0>
					<cfset LvarMontoRevaluacionC2   = 0>
				

					<cfoutput group="Clase">
						<tr>
							<td align="left" colspan="9" nowrap="nowrap" class="style5">Clase: #Clase#</td>
						</tr>
						<cfset LvarAdquisicionC1  		= 0>
						<cfset LvarMejorasC1 	  		= 0>
						<cfset LvarRevaluacionC1  		= 0>
						<cfset LvarMontoTotalC1   		= 0>
						<cfset LvarIndiceC1  	  		= 0>
						<cfset LvarMontoRevaluacionC1   = 0>
						<cfoutput>
							<tr nowrap="nowrap" class="style2">
								<td align="left">&nbsp;&nbsp;&nbsp;&nbsp;#PlacaSinRepetir#</td>
								<td nowrap="nowrap" align="left">#ActivoSinRepetir#</td>
								<td nowrap="nowrap" align="left">#TipoMonto#</td>
								<td align="right">#NumberFormat(Adquisicion,',_.__')#</td>
								<td align="right">#NumberFormat(Mejoras,',_.__')#</td>
								<td align="right">#NumberFormat(Revaluacion,',_.__')#</td>
								<td align="right">#NumberFormat(MontoTotal,',_.__')#</td>
								<td align="right">#NumberFormat(Indice,',_.________')#</td>
								<td align="right">#NumberFormat(MontoRevaluacion,',_.__')#</td>
								<!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
								<td align="right">#Cuenta_Costo_Reeval#</td>
								<td align="right">#Cuenta_Depreciacion_Reeval#</td>
								<!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
							</tr>

							<cfset LvarAdquisicionC1 			= LvarAdquisicionC1 		+ Adquisicion>
							<cfset LvarMejorasC1 				= LvarMejorasC1 			+ Mejoras>
							<cfset LvarRevaluacionC1  			= LvarRevaluacionC1 		+ Revaluacion>
							<cfset LvarMontoTotalC1  			= LvarMontoTotalC1			+ MontoTotal>
							<cfset LvarIndiceC1  				= LvarIndiceC1 				+ Indice>
							<cfset LvarMontoRevaluacionC1	  	= LvarMontoRevaluacionC1 	+ MontoRevaluacion>
						</cfoutput>
						<tr nowrap="nowrap">
							<td align="left" colspan="3" class="style5"><strong>Totales por Clase: #Clase#</strong></td>
							<td align="right" class="style4">#NumberFormat(LvarAdquisicionC1,',_.__')#</td>
							<td align="right" class="style4">#NumberFormat(LvarMejorasC1,',_.__')#</td>
							<td align="right" class="style4">#NumberFormat(LvarRevaluacionC1,',_.__')#</td>
							<td align="right" class="style4">#NumberFormat(LvarMontoTotalC1,',_.__')#</td>
							<td align="right" class="style4">#NumberFormat(LvarIndiceC1,',_.________')#</td>
							<td align="right" class="style4">#NumberFormat(LvarMontoRevaluacionC1,',_.__')#</td>

						</tr>
						<tr class="style6"><td colspan="11">&nbsp;</td></tr>
						<cfset LvarAdquisicionC2 			= LvarAdquisicionC2 		+ LvarAdquisicionC1>
						<cfset LvarMejorasC2 				= LvarMejorasC2 			+ LvarMejorasC1>
						<cfset LvarRevaluacionC2  			= LvarRevaluacionC2 		+ LvarRevaluacionC1>
						<cfset LvarMontoTotalC2 		 	= LvarMontoTotalC2	 		+ LvarMontoTotalC1>
						<cfset LvarIndiceC2  				= LvarIndiceC2 				+ LvarIndiceC1>
						<cfset LvarMontoRevaluacionC2  		= LvarMontoRevaluacionC2 	+ LvarMontoRevaluacionC1>

					</cfoutput>
					<tr nowrap="nowrap">
						<td align="left" colspan="3" class="style5">Totales por Categor&iacute;a: #Categoria#</td>
						<td align="right" class="style4">#NumberFormat(LvarAdquisicionC2,',_.__')#</td>
						<td align="right" class="style4">#NumberFormat(LvarMejorasC2,',_.__')#</td>
						<td align="right" class="style4">#NumberFormat(LvarRevaluacionC2,',_.__')#</td>
						<td align="right" class="style4">#NumberFormat(LvarMontoTotalC2,',_.__')#</td>
						<td align="right" class="style4">#NumberFormat(LvarIndiceC2,',_.________')#</td>
						<td align="right" class="style4">#NumberFormat(LvarMontoRevaluacionC2,',_.__')#</td>
					</tr>
					<tr class="style6"><td colspan="11">&nbsp;</td></tr>
					<cfset LvarAdquisicionC3 			= LvarAdquisicionC3 		+ LvarAdquisicionC2>
					<cfset LvarMejorasC3 				= LvarMejorasC3 			+ LvarMejorasC2>
					<cfset LvarRevaluacionC3  			= LvarRevaluacionC3 		+ LvarRevaluacionC2>
					<cfset LvarMontoTotalC3  			= LvarMontoTotalC3			+ LvarMontoTotalC2>
					<cfset LvarIndiceC3  				= LvarIndiceC3	 			+ LvarIndiceC2>
					<cfset LvarMontoRevaluacionC3  		= LvarMontoRevaluacionC3 	+ LvarMontoRevaluacionC2>

				</cfoutput>
				<tr nowrap="nowrap">
					<td align="left" colspan="3" nowrap="nowrap" class="style5">Totales por C. Funcional: #CFuncional#</td>
					<td align="right" class="style4">#NumberFormat(LvarAdquisicionC3,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarMejorasC3,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarRevaluacionC3,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarMontoTotalC3,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarIndiceC3,',_.________')#</td>
					<td align="right" class="style4">#NumberFormat(LvarMontoRevaluacionC3,',_.__')#</td>
				</tr>
		</cfoutput>
	</table>
</cfif>

