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

<cfparam name="form.AGTPid">

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

<cfquery name="GetMonthNames" datasource="#session.dsn#">
	select VSdesc as MonthName
	from VSidioma v
		inner join Idiomas i
		on i.Iid = v.Iid
		and i.Icodigo = '#session.Idioma#'
	where v.VSgrupo = 1
	order by <cf_dbfunction name="to_number" args="VSvalor" datasource="#session.dsn#">
</cfquery>
<CFSET listMeses = ValueList(GetMonthNames.MonthName)>

<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select Pvalor as value
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 50
		and Mcodigo = 'GN'
</cfquery>
<cfquery name="rsMes" datasource="#session.dsn#">
	select Pvalor as value
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 60
		and Mcodigo = 'GN'
</cfquery>
<cfif rsPeriodo.RecordCount neq 1 or rsMes.RecordCount neq 1>
	<cf_errorCode	code = "50090" msg = "No están bien definidos el periodo y mes de auxiliares! Proceso Cancelado!">
</cfif>

<cfquery name="rsAGTPestado" datasource="#session.dsn#">
	select AGTPestadp, AGTPdescripcion, AGTPmes, AGTPperiodo from AGTProceso where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
</cfquery>

<cfquery name="rsConsultaCantReg" datasource="#session.DSN#" maxrows="15001">
	select count(1) as Cantidad
	from <cfif rsAGTPestado.AGTPestadp eq 4>TransaccionesActivos<cfelse>ADTProceso</cfif> ta 
		inner join Activos act
		on act.Ecodigo = ta.Ecodigo
		and act.Aid = ta.Aid
		<cfif isdefined('form.FAplaca') and len(trim(form.FAplaca))>
			and act.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAplaca#">
		</cfif>
		<cfif isdefined('form.FCategoria') and len(trim(form.FCategoria))>
			and act.ACcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FCategoria#">
		</cfif>		
		<cfif isdefined('form.FClase') and len(trim(form.FClase))>
			and act.ACid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FClase#">
		</cfif>
		<cfif isdefined('form.FCentroF') and len(trim(form.FCentroF))>
			inner join CFuncional fcf on fcf.CFid = ta.CFid and fcf.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCentroF#">
		</cfif>
	where ta.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
</cfquery>

<cfif rsConsultaCantReg.Cantidad gt 15000>
	<table width="50%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td align="left">
				<p>La cantidad de activos sobrepasa los 15000 registros. <br>
				Reduzca el rango mediante los filtros o utilice la opción de cargar la información en un archivo (Descargar).
				Proceso Cancelado.</p>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
<cfelse>	
	<cfquery name="listaDetalle" datasource="#session.DSN#">
		select 
			(select {fn concat({fn concat(cf.CFcodigo,' - ')},cf.CFdescripcion)} from CFuncional cf where cf.CFid = ta.CFid) as CFuncional,	
			(select {fn concat({fn concat(cat.ACcodigodesc,' - ')},cat.ACdescripcion)} from ACategoria cat where cat.Ecodigo = act.Ecodigo and cat.ACcodigo = act.ACcodigo) as Categoria,
			(select {fn concat({fn concat(clas.ACcodigodesc,' - ')},clas.ACdescripcion)} from AClasificacion clas where clas.Ecodigo = act.Ecodigo and clas.ACcodigo = act.ACcodigo and clas.ACid = act.ACid) as Clase,
			act.Aplaca as Placa, 
			act.Adescripcion as Activo, 
			coalesce(ta.TAvaladq, 0.00) as Adquisicion, 
			coalesce(ta.TAvalmej, 0.00) as Mejoras, 
			coalesce(ta.TAvalrev, 0.00) as Revaluacion, 
			coalesce(ta.TAdepacumadq, 0.00) as DepAcumAdquisicion, 
			coalesce(ta.TAdepacummej, 0.00) as DepAcumMejoras, 
			coalesce(ta.TAdepacumrev, 0.00) as DepAcumRevaluacion, 
			coalesce(ta.TAvaladq, 0.00) + coalesce(ta.TAvalmej, 0.00) + coalesce(ta.TAvalrev, 0.00) -
			coalesce(ta.TAdepacumadq, 0.00) - coalesce(ta.TAdepacummej, 0.00) - coalesce(ta.TAdepacumrev, 0.00) as ValorLibrosAnterior,
			ta.TAmontolocmej as Mejora, 
			ta.TAvutil as VidaUtil, 
			coalesce(ta.TAvaladq, 0.00) + coalesce(ta.TAvalmej, 0.00) + coalesce(ta.TAmontolocmej, 0.00) + coalesce(ta.TAvalrev, 0.00) -
			coalesce(ta.TAdepacumadq, 0.00) - coalesce(ta.TAdepacummej, 0.00) - coalesce(ta.TAdepacumrev, 0.00) as ValorLibrosDespues, '' as espacio
		from <cfif rsAGTPestado.AGTPestadp eq 4>TransaccionesActivos<cfelse>ADTProceso</cfif> ta 
			inner join Activos act
			on act.Ecodigo = ta.Ecodigo
			and act.Aid = ta.Aid
			<cfif isdefined('form.FAplaca') and len(trim(form.FAplaca))>
				and act.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAplaca#">
			</cfif>
			<cfif isdefined('form.FCategoria') and len(trim(form.FCategoria))>
				and act.ACcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FCategoria#">
			</cfif>		
			<cfif isdefined('form.FClase') and len(trim(form.FClase))>
				and act.ACid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FClase#">
			</cfif>
			<cfif isdefined('form.FCentroF') and len(trim(form.FCentroF))>
				inner join CFuncional fcf on fcf.CFid = ta.CFid and fcf.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCentroF#">
			</cfif>
		where ta.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		order by 1,2,3,4,5
	</cfquery>

	<cfset grupodesc = "">
	<cfif isdefined('rsAGTPestado') and rsAGTPestado.recordCount GT 0>
		<cfset grupodesc = rsAGTPestado.AGTPdescripcion>
	</cfif>
	<cfset HoraReporte = Now()> 
	
	<cf_htmlReportsHeaders 
			title="Impresion de Mejoras" 
			filename="RepMejoras.xls"
			irA="repMejoras.cfm?AGTPid="
			download="no"
			preview="no">

	<table width="100%" border="0" cellspacing="3" cellpadding="0">
		<tr>
			<td colspan="11" align="center" bgcolor="#E4E4E4"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>
		</tr>			
		<tr>
			<td colspan="11" align="center"><span class="style1">Lista de Transacciones de Depreciaci&oacute;n </span></td>
		</tr>
		<tr>
			<td colspan="11" align="center"><span class="style1"><cfoutput>del grupo #grupodesc#</cfoutput></span></td>
		</tr>		
		<tr>
			<td colspan="11" align="center"><span class="style1"><cfoutput>#ListGetAt(listMeses,rsAGTPestado.AGTPmes)# / #rsAGTPestado.AGTPperiodo# </cfoutput></span></td>
		</tr>		
		<tr>
			<td colspan="11" align="center"><cfoutput><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></cfoutput></td>
		</tr>						
		<tr class="style6"><td colspan="11">&nbsp;</td></tr>
		<tr class="style5">
			<td align="left">Placa</td>
			<td align="left">Activo</td>
			<td align="right">Adquisici&oacute;n</td>
			<td align="right">Mejoras</td>
			<td align="right">Revaluaci&oacute;n</td>
			<td align="right">Depreciacion Adquisici&oacute;n</td>
			<td align="right">Depreciacion Mejoras</td>
			<td align="right">Depreciaci&oacute;n Revaluaci&oacute;n</td>
			<td align="right">Vida &Uacute;til</td>
			<td align="right">Valor Libros Antes</td>
			<td align="right">Mejora</td>
			<td align="right">Valor Libros</td>
		</tr>
		
		<cfflush interval="64">
		
		<cfset LvarAdquisicionC4 		 = 0>
		<cfset LvarMejorasC4 			 = 0>
		<cfset LvarRevaluacionC4  		 = 0>
		<cfset LvarDepAcumAdquisicionC4  = 0>
		<cfset LvarDepAcumMejorasC4  	 = 0>
		<cfset LvarDepAcumRevaluacionC4  = 0>
		<cfset LvarValorLibrosAnteriorC4 = 0>
		<cfset LvarMejoraC4 			 = 0>
		<cfset LvarValorLibrosDespuesC4  = 0>
		<cfoutput query="listaDetalle" group="CFuncional">
			<tr>
				<td align="left" colspan="11" nowrap="nowrap" class="style5">Centro Funcional: #CFuncional#</td>
			</tr>
			<cfset LvarAdquisicionC3 		 = 0>
			<cfset LvarMejorasC3 			 = 0>
			<cfset LvarRevaluacionC3  		 = 0>
			<cfset LvarDepAcumAdquisicionC3  = 0>
			<cfset LvarDepAcumMejorasC3  	 = 0>
			<cfset LvarDepAcumRevaluacionC3  = 0>
			<cfset LvarValorLibrosAnteriorC3 = 0>
			<cfset LvarMejoraC3  			 = 0>
			<cfset LvarValorLibrosDespuesC3  = 0>
			<cfoutput group="Categoria">
				<tr>
					<td align="left" colspan="11" nowrap="nowrap" class="style5">Categor&iacute;a: #Categoria#</td>
				</tr>
				<cfset LvarAdquisicionC2 		 = 0>
				<cfset LvarMejorasC2 			 = 0>
				<cfset LvarRevaluacionC2  		 = 0>
				<cfset LvarDepAcumAdquisicionC2  = 0>
				<cfset LvarDepAcumMejorasC2  	 = 0>
				<cfset LvarDepAcumRevaluacionC2  = 0>
				<cfset LvarValorLibrosAnteriorC2 = 0>
				<cfset LvarMejoraC2  			 = 0>
				<cfset LvarValorLibrosDespuesC2  = 0>
				<cfoutput group="Clase">
					<tr>
						<td align="left" colspan="11" nowrap="nowrap" class="style5">Clase: #Clase#</td>
					</tr>
					<cfset LvarAdquisicionC1 		 = 0>
					<cfset LvarMejorasC1 			 = 0>
					<cfset LvarRevaluacionC1  		 = 0>
					<cfset LvarDepAcumAdquisicionC1  = 0>
					<cfset LvarDepAcumMejorasC1  	 = 0>
					<cfset LvarDepAcumRevaluacionC1  = 0>
					<cfset LvarValorLibrosAnteriorC1 = 0>
					<cfset LvarMejoraC1 			 = 0>
					<cfset LvarValorLibrosDespuesC1  = 0>
					<cfoutput>
						<tr nowrap="nowrap" class="style2">
							<td align="left">&nbsp;&nbsp;&nbsp;&nbsp;#Placa#</td>
							<td nowrap="nowrap" align="left">#Activo#</td>
							<td align="right">#NumberFormat(Adquisicion,',_.__')#</td>
							<td align="right">#NumberFormat(Mejoras,',_.__')#</td>
							<td align="right">#NumberFormat(Revaluacion,',_.__')#</td>
							<td align="right">#NumberFormat(DepAcumAdquisicion,',_.__')#</td>
							<td align="right">#NumberFormat(DepAcumMejoras,',_.__')#</td>
							<td align="right">#NumberFormat(DepAcumRevaluacion,',_.__')#</td>
							<td align="right">#NumberFormat(VidaUtil,',_')#</td>
							<td align="right">#NumberFormat(ValorLibrosAnterior,',_.__')#</td>
							<td align="right">#NumberFormat(Mejora,',_.__')#</td>
							<td align="right">#NumberFormat(ValorLibrosDespues,',_.__')#</td>
						</tr>

						<cfset LvarAdquisicionC1 			= LvarAdquisicionC1 		+ Adquisicion>
						<cfset LvarMejorasC1 				= LvarMejorasC1 			+ Mejoras>
						<cfset LvarRevaluacionC1  			= LvarRevaluacionC1 		+ Revaluacion>
						<cfset LvarDepAcumAdquisicionC1  	= LvarDepAcumAdquisicionC1	+ DepAcumAdquisicion>
						<cfset LvarDepAcumMejorasC1  		= LvarDepAcumMejorasC1 		+ DepAcumMejoras>
						<cfset LvarDepAcumRevaluacionC1	  	= LvarDepAcumRevaluacionC1 	+ DepAcumRevaluacion>
						<cfset LvarValorLibrosAnteriorC1 	= LvarValorLibrosAnteriorC1 + ValorLibrosAnterior>
						<cfset LvarMejoraC1  				= LvarMejoraC1 				+ Mejora>
						<cfset LvarValorLibrosDespuesC1  	= LvarValorLibrosDespuesC1 	+ ValorLibrosDespues>
					</cfoutput>
					<tr nowrap="nowrap">
						<td align="left" colspan="2" class="style5"><strong>Totales por Clase: #Clase#</strong></td>
						<td align="right" class="style4">#NumberFormat(LvarAdquisicionC1,',_.__')#</td>
						<td align="right" class="style4">#NumberFormat(LvarMejorasC1,',_.__')#</td>
						<td align="right" class="style4">#NumberFormat(LvarRevaluacionC1,',_.__')#</td>
						<td align="right" class="style4">#NumberFormat(LvarDepAcumAdquisicionC1,',_.__')#</td>
						<td align="right" class="style4">#NumberFormat(LvarDepAcumMejorasC1,',_.__')#</td>
						<td align="right" class="style4">#NumberFormat(LvarDepAcumRevaluacionC1,',_.__')#</td>
						<td align="right" class="style4">&nbsp;</td>
						<td align="right" class="style4">#NumberFormat(LvarValorLibrosAnteriorC1,',_.__')#</td>
						<td align="right" class="style4">#NumberFormat(LvarMejoraC1,',_.__')#</td>
						<td align="right" class="style4">#NumberFormat(LvarValorLibrosDespuesC1,',_.__')#</td>
					</tr>
					<tr class="style6"><td colspan="11">&nbsp;</td></tr>
					<cfset LvarAdquisicionC2 			= LvarAdquisicionC2 		+ LvarAdquisicionC1>
					<cfset LvarMejorasC2 				= LvarMejorasC2 			+ LvarMejorasC1>
					<cfset LvarRevaluacionC2  			= LvarRevaluacionC2 		+ LvarRevaluacionC1>
					<cfset LvarDepAcumAdquisicionC2  	= LvarDepAcumAdquisicionC2	+ LvarDepAcumAdquisicionC1>
					<cfset LvarDepAcumMejorasC2  		= LvarDepAcumMejorasC2 		+ LvarDepAcumMejorasC1>
					<cfset LvarDepAcumRevaluacionC2  	= LvarDepAcumRevaluacionC2 	+ LvarDepAcumRevaluacionC1>
					<cfset LvarValorLibrosAnteriorC2  	= LvarValorLibrosAnteriorC2 + LvarValorLibrosAnteriorC1>
					<cfset LvarMejoraC2  				= LvarMejoraC2 				+ LvarMejoraC1>
					<cfset LvarValorLibrosDespuesC2		= LvarValorLibrosDespuesC2 	+ LvarValorLibrosDespuesC1>
				</cfoutput>
				<tr nowrap="nowrap">
					<td align="left" colspan="2" class="style5">Totales por Categor&iacute;a: #Categoria#</td>
					<td align="right" class="style4">#NumberFormat(LvarAdquisicionC2,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarMejorasC2,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarRevaluacionC2,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarDepAcumAdquisicionC2,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarDepAcumMejorasC2,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarDepAcumRevaluacionC2,',_.__')#</td>
					<td align="right" class="style4">&nbsp;</td>
					<td align="right" class="style4">#NumberFormat(LvarValorLibrosAnteriorC2,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarMejoraC2,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarValorLibrosDespuesC2,',_.__')#</td>
				</tr>
				<cfset LvarAdquisicionC3 			= LvarAdquisicionC3 		+ LvarAdquisicionC2>
				<cfset LvarMejorasC3 				= LvarMejorasC3 			+ LvarMejorasC2>
				<cfset LvarRevaluacionC3  			= LvarRevaluacionC3 		+ LvarRevaluacionC2>
				<cfset LvarDepAcumAdquisicionC3  	= LvarDepAcumAdquisicionC3	+ LvarDepAcumAdquisicionC2>
				<cfset LvarDepAcumMejorasC3  		= LvarDepAcumMejorasC3	 	+ LvarDepAcumMejorasC2>
				<cfset LvarDepAcumRevaluacionC3  	= LvarDepAcumRevaluacionC3 	+ LvarDepAcumRevaluacionC2>
				<cfset LvarValorLibrosAnteriorC3	= LvarValorLibrosAnteriorC3 + LvarValorLibrosAnteriorC2>
				<cfset LvarMejoraC3  				= LvarMejoraC3 				+ LvarMejoraC2>
				<cfset LvarValorLibrosDespuesC3  	= LvarValorLibrosDespuesC3 	+ LvarValorLibrosDespuesC2>
			</cfoutput>
			<tr nowrap="nowrap">
				<td align="left" colspan="2" nowrap="nowrap" class="style5">Totales por C. Funcional: #CFuncional#</td>
				<td align="right" class="style4">#NumberFormat(LvarAdquisicionC3,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarMejorasC3,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarRevaluacionC3,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarDepAcumAdquisicionC3,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarDepAcumMejorasC3,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarDepAcumRevaluacionC3,',_.__')#</td>
				<td align="right" class="style4">&nbsp;</td>
				<td align="right" class="style4">#NumberFormat(LvarValorLibrosAnteriorC3,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarMejoraC3,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarValorLibrosDespuesC3,',_.__')#</td>
			</tr>
			    <cfset LvarAdquisicionC4 			= LvarAdquisicionC4 		+ LvarAdquisicionC3>
				<cfset LvarMejorasC4 				= LvarMejorasC4 			+ LvarMejorasC3>
				<cfset LvarRevaluacionC4  			= LvarRevaluacionC4 		+ LvarRevaluacionC3>
				<cfset LvarDepAcumAdquisicionC4  	= LvarDepAcumAdquisicionC4	+ LvarDepAcumAdquisicionC3>
				<cfset LvarDepAcumMejorasC4  		= LvarDepAcumMejorasC4	 	+ LvarDepAcumMejorasC3>
				<cfset LvarDepAcumRevaluacionC4  	= LvarDepAcumRevaluacionC4 	+ LvarDepAcumRevaluacionC3>
				<cfset LvarValorLibrosAnteriorC4	= LvarValorLibrosAnteriorC4 + LvarValorLibrosAnteriorC3>
				<cfset LvarMejoraC4  				= LvarMejoraC4 				+ LvarMejoraC3>
				<cfset LvarValorLibrosDespuesC4  	= LvarValorLibrosDespuesC4 	+ LvarValorLibrosDespuesC3>		
		</cfoutput>
		<cfoutput>
			<tr nowrap="nowrap">
				<td align="left" colspan="2" nowrap="nowrap" class="style5">Totales Generales</td>
				<td align="right" class="style4">#NumberFormat(LvarAdquisicionC4,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarMejorasC4,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarRevaluacionC4,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarDepAcumAdquisicionC4,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarDepAcumMejorasC4,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarDepAcumRevaluacionC4,',_.__')#</td>
				<td align="right" class="style4">&nbsp;</td>
				<td align="right" class="style4">#NumberFormat(LvarValorLibrosAnteriorC4,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarMejoraC4,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarValorLibrosDespuesC4,',_.__')#</td>
			</tr>
		</cfoutput>
	</table>
</cfif>

