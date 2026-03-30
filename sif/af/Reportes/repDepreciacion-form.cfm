<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfparam name="form.AGTPid">

<cfset LvarCantidad = fnObtieneParametrosConsulta()>
<cfif LvarCantidad gt 15000>
	<table width="50%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td align="left">
				<p>La cantidad de activos sobrepasa los 15,000 registros. <br>
				Reduzca el rango mediante los filtros o utilice la opción de cargar la información en un archivo (Descargar).
				Proceso Cancelado.</p>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	<cfabort>
</cfif>
<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
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
<cf_htmlReportsHeaders 
	title="Impresion de DepreciaciÃ³nes"
	filename="RepDepreciacion.xls"
	irA="repDepreciacion.cfm?AGTPid="
	download="yes"
	preview="no">
<!---<cfoutput>#LvarCantidad#</cfoutput>--->
<table width="100%" border="0" cellspacing="2" cellpadding="0">
	<tr>
		<td colspan="9" align="center" bgcolor="#E4E4E4"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>
	</tr>			
	<tr>
		<td colspan="9" align="center">&nbsp;</td>
	</tr>				  
	<tr>
		<td colspan="9" align="center"><span class="style1">Lista de Transacciones de Depreciaci&oacute;n </span></td>
	</tr>
	<tr>
		<td colspan="9" align="center"><span class="style1"><cfoutput>del grupo #grupodesc#</cfoutput></span></td>
	</tr>		
	<tr>
		<td colspan="9" align="center"><span class="style1"><cfoutput>#ListGetAt(listMeses,rsAGTPestado.AGTPmes)# / #rsAGTPestado.AGTPperiodo# </cfoutput></span></td>
	</tr>		
	<tr>
		<td colspan="9" align="center"><cfoutput><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></cfoutput></td>
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
		<td align="right">Valor Libros Despues</td>
	</tr>						
	<cfflush interval="128">
	<cfoutput query="listaDetalle" group="CFuncional">
		<tr>
			<td align="left" colspan="11" nowrap="nowrap" class="style5">Centro Funcional: #CFuncional#</td>
		</tr>
		<cfset LvarAdquisicionC3 		 	  = 0>
		<cfset LvarMejorasC3 			 	  = 0>
		<cfset LvarRevaluacionC3  			  = 0>
		<cfset LvarDepreciacionAdquisicionC3  = 0>
		<cfset LvarDepreciacionMejorasC3  	  = 0>
		<cfset LvarDepreciacionRevaluacionC3  = 0>
		<cfset LvarValorLibrosDespuesC3 	  = 0>
		<cfoutput group="Categoria">
			<tr>
				<td align="left" colspan="11" nowrap="nowrap" class="style5">Categor&iacute;a: #Categoria#</td>
			</tr>
			<cfset LvarAdquisicionC2 		 	  = 0>
			<cfset LvarMejorasC2 			 	  = 0>
			<cfset LvarRevaluacionC2  			  = 0>
			<cfset LvarDepreciacionAdquisicionC2  = 0>
			<cfset LvarDepreciacionMejorasC2  	  = 0>
			<cfset LvarDepreciacionRevaluacionC2  = 0>
			<cfset LvarValorLibrosDespuesC2 	  = 0>
			<cfoutput group="Clase">
				<tr>
					<td align="left" colspan="11" nowrap="nowrap" class="style5">Clase: #Clase#</td>
				</tr>
				<cfset LvarAdquisicionC1 		 	  = 0>
				<cfset LvarMejorasC1 			 	  = 0>
				<cfset LvarRevaluacionC1  			  = 0>
				<cfset LvarDepreciacionAdquisicionC1  = 0>
				<cfset LvarDepreciacionMejorasC1  	  = 0>
				<cfset LvarDepreciacionRevaluacionC1  = 0>
				<cfset LvarValorLibrosDespuesC1 	  = 0>
				<cfoutput>
					<tr nowrap="nowrap" class="style2">
						<td align="left">&nbsp;&nbsp;&nbsp;&nbsp;#Placa#</td>
						<td nowrap="nowrap" align="left">#Activo#</td>
						<td align="right">#NumberFormat(Adquisicion,',_.__')#</td>
						<td align="right">#NumberFormat(Mejoras,',_.__')#</td>
						<td align="right">#NumberFormat(Revaluacion,',_.__')#</td>
						<td align="right">#NumberFormat(DepreciacionAdquisicion,',_.__')#</td>
						<td align="right">#NumberFormat(DepreciacionMejoras,',_.__')#</td>
						<td align="right">#NumberFormat(DepreciacionRevaluacion,',_.__')#</td>
						<td align="right">#NumberFormat(ValorLibrosDespues,',_.__')#</td>
					</tr>
					<cfset LvarAdquisicionC1 			 = LvarAdquisicionC1 			 + Adquisicion>
					<cfset LvarMejorasC1 				 = LvarMejorasC1 				 + Mejoras>
					<cfset LvarRevaluacionC1  			 = LvarRevaluacionC1 			 + Revaluacion>
					<cfset LvarDepreciacionAdquisicionC1 = LvarDepreciacionAdquisicionC1 + DepreciacionAdquisicion>
					<cfset LvarDepreciacionMejorasC1  	 = LvarDepreciacionMejorasC1 	 + DepreciacionMejoras>
					<cfset LvarDepreciacionRevaluacionC1 = LvarDepreciacionRevaluacionC1 + DepreciacionRevaluacion>
					<cfset LvarValorLibrosDespuesC1 	 = LvarValorLibrosDespuesC1 	 + ValorLibrosDespues>
				</cfoutput>
				<tr nowrap="nowrap">
					<td align="left" colspan="2" class="style5"><strong>Totales por Clase: #Clase#</strong></td>
					<td align="right" class="style4">#NumberFormat(LvarAdquisicionC1,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarMejorasC1,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarRevaluacionC1,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarDepreciacionAdquisicionC1,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarDepreciacionMejorasC1,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarDepreciacionRevaluacionC1,',_.__')#</td>
					<td align="right" class="style4">#NumberFormat(LvarValorLibrosDespuesC1,',_.__')#</td>
				</tr>
				<tr class="style6"><td colspan="11">&nbsp;</td></tr>
				<cfset LvarAdquisicionC2 				= LvarAdquisicionC2 			+ LvarAdquisicionC1>
				<cfset LvarMejorasC2 					= LvarMejorasC2 				+ LvarMejorasC1>
				<cfset LvarRevaluacionC2  				= LvarRevaluacionC2 			+ LvarRevaluacionC1>
				<cfset LvarDepreciacionAdquisicionC2  	= LvarDepreciacionAdquisicionC2	+ LvarDepreciacionAdquisicionC1>
				<cfset LvarDepreciacionMejorasC2  		= LvarDepreciacionMejorasC2 	+ LvarDepreciacionMejorasC1>
				<cfset LvarDepreciacionRevaluacionC2  	= LvarDepreciacionRevaluacionC2 + LvarDepreciacionRevaluacionC1>
				<cfset LvarValorLibrosDespuesC2  		= LvarValorLibrosDespuesC2 		+ LvarValorLibrosDespuesC1>
			</cfoutput>
			<tr nowrap="nowrap">
				<td align="left" colspan="2" class="style5">Totales por Categor&iacute;a: #Categoria#</td>
				<td align="right" class="style4">#NumberFormat(LvarAdquisicionC2,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarMejorasC2,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarRevaluacionC2,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarDepreciacionAdquisicionC2,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarDepreciacionMejorasC2,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarDepreciacionRevaluacionC2,',_.__')#</td>
				<td align="right" class="style4">#NumberFormat(LvarValorLibrosDespuesC2,',_.__')#</td>
			</tr>
			<cfset LvarAdquisicionC3 				= LvarAdquisicionC3 			+ LvarAdquisicionC2>
			<cfset LvarMejorasC3 					= LvarMejorasC3 				+ LvarMejorasC2>
			<cfset LvarRevaluacionC3  				= LvarRevaluacionC3 			+ LvarRevaluacionC2>
			<cfset LvarDepreciacionAdquisicionC3  	= LvarDepreciacionAdquisicionC3	+ LvarDepreciacionAdquisicionC2>
			<cfset LvarDepreciacionMejorasC3  		= LvarDepreciacionMejorasC3	 	+ LvarDepreciacionMejorasC2>
			<cfset LvarDepreciacionRevaluacionC3  	= LvarDepreciacionRevaluacionC3 + LvarDepreciacionRevaluacionC2>
			<cfset LvarValorLibrosDespuesC3			= LvarValorLibrosDespuesC3 		+ LvarValorLibrosDespuesC2>
		</cfoutput>
		<tr nowrap="nowrap">
			<td align="left" colspan="2" nowrap="nowrap" class="style5">Totales por C. Funcional: #CFuncional#</td>
			<td align="right" class="style4">#NumberFormat(LvarAdquisicionC3,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarMejorasC3,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarRevaluacionC3,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarDepreciacionAdquisicionC3,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarDepreciacionMejorasC3,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarDepreciacionRevaluacionC3,',_.__')#</td>
			<td align="right" class="style4">#NumberFormat(LvarValorLibrosDespuesC3,',_.__')#</td>
		</tr>
	</cfoutput>
</table>

<cffunction name="fnObtieneParametrosConsulta" access="private" returntype="numeric" output="no">
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
		where Ecodigo = #session.Ecodigo#
			and Pcodigo = 50
			and Mcodigo = 'GN'
	</cfquery>
	<cfquery name="rsMes" datasource="#session.dsn#">
		select Pvalor as value
		from Parametros
		where Ecodigo = #session.Ecodigo#
			and Pcodigo = 60
			and Mcodigo = 'GN'
	</cfquery>

	<cfif rsPeriodo.RecordCount neq 1 or rsMes.RecordCount neq 1>
		<cf_errorCode	code = "50090" msg = "No están bien definidos el periodo y mes de auxiliares! Proceso Cancelado!">
	</cfif>

	<cfquery name="rsAGTPestado" datasource="#session.dsn#">
		select AGTPestadp, AGTPdescripcion, AGTPmes, AGTPperiodo from AGTProceso where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	</cfquery>

	<cfquery name="rsConsultaCantReg" datasource="#session.DSN#">
		select count(1) as Cantidad
		from <cfif rsAGTPestado.AGTPestadp eq 4>TransaccionesActivos<cfelse>ADTProceso</cfif> ta 
			inner join Activos act
			on act.Ecodigo = ta.Ecodigo
			and act.Aid = ta.Aid
			<cfif isdefined('form.FAplaca') and len(trim(form.FAplaca))>
				and act.Aplaca = '#form.FAplaca#'
			</cfif>
			<cfif isdefined('form.FCategoria') and len(trim(form.FCategoria))>
				and act.ACcodigo=#form.FCategoria#
			</cfif>		
			<cfif isdefined('form.FClase') and len(trim(form.FClase))>
				and act.ACid=#form.FClase#
			</cfif>
			<cfif isdefined('form.FCentroF') and len(trim(form.FCentroF))>
				inner join CFuncional fcf on fcf.CFid = ta.CFid and fcf.CFid = #form.FCentroF#
			</cfif>
		where ta.AGTPid = #form.AGTPid#
	</cfquery>

	<cfquery name="listaDetalle" datasource="#session.DSN#">
			select 
			(
				select cf.CFcodigo #_Cat# ' - ' #_Cat# cf.CFdescripcion
				from CFuncional cf 
				where cf.CFid = ta.CFid
			) as CFuncional,	
			(
				select cat.ACcodigodesc #_Cat# ' - ' #_Cat# cat.ACdescripcion
				from ACategoria cat 
				where cat.Ecodigo  = s.Ecodigo 
				  and cat.ACcodigo = s.ACcodigo
			) as Categoria,
			(
				select clas.ACcodigodesc #_Cat# ' - ' #_Cat# clas.ACdescripcion
				from AClasificacion clas 
				where clas.Ecodigo = s.Ecodigo 
				and clas.ACcodigo  = s.ACcodigo 
				and clas.ACid = s.ACid
			) as Clase,
			act.Aplaca as Placa, 
			<cf_dbfunction name="sPart"     args="act.Adescripcion,1,30"> as Activo, 
			ta.TAvaladq as Adquisicion, 
			ta.TAvalmej as Mejoras, 
			ta.TAvalrev as Revaluacion, 
			ta.TAmontolocadq as DepreciacionAdquisicion, 
			ta.TAmontolocmej as DepreciacionMejoras, 
			ta.TAmontolocrev as DepreciacionRevaluacion, 
			ta.TAvaladq + ta.TAvalmej + ta.TAvalrev -
			ta.TAdepacumadq - ta.TAdepacummej - ta.TAdepacumrev -
			ta.TAmontolocadq - ta.TAmontolocmej - ta.TAmontolocrev as ValorLibrosDespues,
			'' as espacio
		<cfif rsAGTPestado.AGTPestadp eq 4>
		from TransaccionesActivos ta
			inner join AFSaldos s
			 on s.Aid = ta.Aid
			and s.AFSperiodo = ta.TAperiodo
			and s.AFSmes     = ta.TAmes
			and s.Ecodigo    = ta.Ecodigo
		<cfelse>
		from ADTProceso ta 
			inner join Activos s
			on s.Aid = ta.Aid
		</cfif>
	
			inner join Activos act
			on act.Aid = s.Aid
	
			<cfif isdefined('form.FCentroF') and len(trim(form.FCentroF))>
				inner join CFuncional fcf on fcf.CFid = ta.CFid
			</cfif>
		where ta.AGTPid = #form.AGTPid#
		<cfif isdefined('form.FAplaca') and len(trim(form.FAplaca))>
			and act.Aplaca = '#form.FAplaca#'
		</cfif>
		<cfif isdefined('form.FCategoria') and len(trim(form.FCategoria))>
			and s.ACcodigo = #form.FCategoria#
		</cfif>		
		<cfif isdefined('form.FClase') and len(trim(form.FClase))>
			and s.ACid = #form.FClase#
		</cfif>
		<cfif isdefined('form.FCentroF') and len(trim(form.FCentroF))>
			and fcf.CFid = #form.FCentroF#
		</cfif>
	
		order by 1,2,3,4,5
	</cfquery>

	<cfset grupodesc = "">
	<cfif isdefined('rsAGTPestado') and rsAGTPestado.recordCount GT 0>
		<cfset grupodesc = rsAGTPestado.AGTPdescripcion>
	</cfif>
	<cfset HoraReporte = Now()>
	<cfreturn rsConsultaCantReg.Cantidad>
</cffunction>