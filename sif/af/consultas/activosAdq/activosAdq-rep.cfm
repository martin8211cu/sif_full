<cfparam name="contieneDatosVariables" default="false">
<cfif isdefined('URL.Datosvariables') and len(trim(URL.Datosvariables)) GT 0>
	<cfquery name="Etiquetas" datasource="#session.dsn#">
		select DVencabezado from DVdatosVariables where DVid in (#URL.Datosvariables#) 
	</cfquery>
	<cfset contieneDatosVariables = true>
</cfif>

<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 4>
	<cfset LvarGeneraRsControl = fnGeneraRsControl()>
	<cfif LvarGeneraRsControl>
		<cfset temporaryFileName = "QueryToFileXLS_#session.usucodigo#.xls">
		<cfset temporaryFileName = GetTempFile( GetTempDirectory(), temporaryFileName)>
		<cfset lvarControl = fnGeneraSalidaFormato4()>
		<cfcontent type="application/msexcel">
		<cfheader name="Content-Disposition" value="attachment;filename=activosAdq.xls" charset="utf-8">
		<cfcontent type="application/msexcel" reset="yes" file="#temporaryFileName#" deletefile="yes">
	<cfelse>
		<p> no se encontraron registros que cumplan con la condicion o criterios indicados </p>
		<cfabort>
	</cfif>
<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
	<cfset LvarGeneraRsControl = fnGeneraRsControl()>
	<cfif LvarGeneraRsControl>
		<cfset temporaryFileName = "QueryToFileXLS_#session.usucodigo#.txt">
		<cfset temporaryFileName = GetTempFile( GetTempDirectory(), temporaryFileName)>
		<cfset lvarControl = fnGeneraSalidaFormato3()>
		<cfcontent type="text/plain">
		<cfheader name="Content-Disposition" value="attachment;filename=activosAdq.txt" charset="utf-8">
		<cfcontent type="text/plain" reset="yes" file="#temporaryFileName#" deletefile="yes">
	<cfelse>
		<p> no se encontraron registros que cumplan con la condicion o criterios indicados </p>
		<cfabort>
	</cfif>
<cfelse>
	<cfset maxrows = 7000>
	<cfset lvarExcesoRegistros = fnGeneraSalidaCFR(maxrows)>
	<cfif lvarExcesoRegistros>
		<cf_errorCode	code = "50049"
						msg  = "La cantidad de activos a desplegar sobrepasa los @errorDat_1@ registros. Reduzca los rangos en los filtros ó exporte a archivo. "
						errorDat_1="#maxrows#"
		>
		<cfabort>
	</cfif>
</cfif>

<cffunction name="fnGeneraRsControl" access="private" output="no" hint="Genera Query para el control del Ciclo de las salidas" returntype="boolean">
	<cfquery name="rsControl" datasource="#session.dsn#">
		select distinct 
			cf.CFcodigo, o.Oficodigo, 
			cat.ACcodigodesc, cla.ACcodigodesc, 
			cla.ACcodigo, cla.ACid, o.Ocodigo, cf.CFid
		from AFSaldos b 
			inner join Activos a 
				on a.Aid = b.Aid
								
			inner join ACategoria cat 
				on cat.Ecodigo = b.Ecodigo  
				and cat.ACcodigo = b.ACcodigo
			
			inner join AClasificacion cla 
				on cla.Ecodigo = b.Ecodigo  
				and cla.ACcodigo = b.ACcodigo 
				and cla.ACid = b.ACid

			inner join CFuncional cf
				on cf.CFid = b.CFid
			
			inner join Oficinas o
				on o.Ecodigo = b.Ecodigo
				and o.Ocodigo = b.Ocodigo
			
			inner join AFClasificaciones af
				on af.Ecodigo = b.Ecodigo
				and af.AFCcodigo = b.AFCcodigo
				
		where b.Ecodigo = #session.Ecodigo#
		  and b.AFSperiodo = #url.Periodo#
		  and b.AFSmes =  #url.Mes#
		<cfif isdefined('url.CFcodigoI') and LEN(TRIM(url.CFcodigoI)) gt 0  and isdefined('url.CFcodigoF') and LEN(TRIM(url.CFcodigoF)) gt 0>
			and cf.CFcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoI#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoF#">
		<cfelseif isdefined('url.CFcodigoI') and LEN(TRIM(url.CFcodigoI)) gt 0>
			and cf.CFcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoI#">
		<cfelseif isdefined('url.CFcodigoF') and LEN(TRIM(url.CFcodigoF)) gt 0>
			and cf.CFcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoF#">
		</cfif>
		
		<cfif isdefined('url.OcodigoI') and LEN(TRIM(url.OcodigoI)) gt 0  and isdefined('url.OcodigoF') and LEN(TRIM(url.OcodigoF)) gt 0>
			and b.Ocodigo between #url.OcodigoI# and #url.OcodigoF#
		<cfelseif isdefined('url.OcodigoI') and LEN(TRIM(url.OcodigoI)) gt 0>
			and b.Ocodigo >= #url.OcodigoI#
		<cfelseif isdefined('url.OcodigoF') and LEN(TRIM(url.OcodigoF)) gt 0>
			and b.Ocodigo <= #url.OcodigoF#
		</cfif>
		
		<cfif isdefined('url.ACcodigoI') and LEN(TRIM(url.ACcodigoI)) gt 0  and isdefined('url.ACcodigoF') and LEN(TRIM(url.ACcodigoF)) gt 0>
			and cat.ACcodigo between #url.ACcodigoI# and #url.ACcodigoF#
		<cfelseif isdefined('url.ACcodigoI') and LEN(TRIM(url.ACcodigoI)) gt 0>
			and cat.ACcodigo >= #url.ACcodigoI#
		<cfelseif isdefined('url.ACcodigoF') and LEN(TRIM(url.ACcodigoF)) gt 0>
			and cat.ACcodigo <= #url.OcodigoF#
		</cfif>
		
		<cfif isdefined('url.ACidI') and LEN(TRIM(url.ACidI)) gt 0  and isdefined('url.ACcodigoF') and LEN(TRIM(url.ACidF)) gt 0>
			and cla.ACid between #url.ACidI# and #url.ACidF#
		<cfelseif isdefined('url.ACidI') and LEN(TRIM(url.ACidI)) gt 0>
			and cla.ACid >= #url.ACcodigoI#
		<cfelseif isdefined('url.ACidF') and LEN(TRIM(url.ACidF)) gt 0>
			and cla.ACid <= #url.ACidF#
		</cfif>
		<cfif isdefined('url.AFCcodigopadre') and LEN(TRIM(url.AFCcodigopadre)) gt 0 and url.AFCcodigopadre gte 0>
			and af.AFCcodigo = #url.AFCcodigopadre#
		</cfif>
		order by cf.CFcodigo, o.Oficodigo, cat.ACcodigodesc, cla.ACcodigodesc
	</cfquery>
	<cfif rsControl.recordcount GT 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>	
</cffunction>

<cffunction name="fnGeneraSalidaFormato3" access="private" output="no" returntype="boolean" hint="Genera la salida en formato de texto ( txt )">
	<cfset newline = Chr(13)>
	<cfset newcolumn = Chr(9)>
	<cffile action="write" file="#temporaryFileName#" output="" addnewline="no">
	<cfset Lvar_String = 'CATEGORIA' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'DESCRIPCION_CATEGORIA' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'CLASIFICACION' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'DESCRIPCION_CLASIFICACION' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'PLACA' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'ACTIVO' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'MARCA' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'MODELO' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'SERIE' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'TIPO' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'CFUNCIONAL' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'DESCRIPCION_CFUNCIONAL' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'OFICINA' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'DESCRIPCION_OFICINA' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'NUMERO_SOCIO' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'NOMBRE_SOCIO' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'FECHA_ADQ' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'FECHA_INICIO_DEPR' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'VIDA_UTIL' & newcolumn>
	
	<cfset Lvar_String = Lvar_String & 'ADQUISICION' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'MEJORAS' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'REVALUACION' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'DEP_ACUM_ADQUISICION' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'DEP_ACUM_MEJORAS' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'DEP_ACUM_REVALUACION' & newcolumn>
	<cfset Lvar_String = Lvar_String & 'VALOR_LIBROS'> 
	<cfif contieneDatosVariables>
		<cfloop query="Etiquetas">
			<cfset Lvar_String = Lvar_String & '#Etiquetas.DVencabezado#' & newcolumn>
		</cfloop>
	</cfif>
	<cfset Lvar_String = Lvar_String & newline>

	<cffile action="append" file="#temporaryFileName#" output="#Lvar_String#" addnewline="yes">

	<cfloop query="rsControl">
		<cfset LvarOficinaProceso = fnObtieneDatos(rsControl.ACcodigo, rsControl.ACid, rsControl.Ocodigo, rsControl.CFid)>

		<cfloop query="data">	<!--- Grabar registro en el archivo --->
			<cfset Lvar_String = '#GvarCategoria#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#GvarDescripcionCategoria#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#GvarClasificacion#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#GvarDescripcionClasificacion#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.Placa#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.Activo#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.Marca#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.Modelo#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.Serie#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.Tipo#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#GvarCFuncional#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#GvarDescripcionCFuncional#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#GvarOficina#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#GvarDescripcionOficina#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.SNnumero#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.SNnombre#' & newcolumn>
			
			<cfset Lvar_String = Lvar_String & '#data.FechaAdq#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.FachaInicioDepr#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.VidaUtil#' & newcolumn>
			
			<cfset Lvar_String = Lvar_String & '#data.Adquisicion#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.Mejoras#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.Revaluacion#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.DepAcumAdquisicion#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.DepAcumMejoras#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.DepAcumRevaluacion#' & newcolumn>
			<cfset Lvar_String = Lvar_String & '#data.ValorLibros#'> 
			<cfif contieneDatosVariables>
				<cfloop index="DVid" list="#URL.Datosvariables#" delimiters=",">
					<cfset Lvar_String = Lvar_String & '#Evaluate('data.DV_'&DVid)#' & newcolumn>
				</cfloop>
			</cfif>
			
			<cfset Lvar_String = Lvar_String & newline>
			<cffile action="append" file="#temporaryFileName#" output="#Lvar_String#" addnewline="yes">
		</cfloop>
	</cfloop>
	<cfreturn true>
</cffunction>

<cffunction name="fnGeneraSalidaFormato4" access="private" output="no" hint="Genera la salida en archivo plano" returntype="boolean">
	<cfset newline = Chr(13) & Chr(10)>
	<cffile action="write" file="#temporaryFileName#" output="" addnewline="no">
	<cfset Lvar_String = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">' & newline>
	<cfset Lvar_String = Lvar_String &
			'<html xmlns:o="urn:schemas-microsoft-com:office:office" ' & 
			'xmlns:x="urn:schemas-microsoft-com:office:excel" ' &
			'xmlns="http://www.w3.org/TR/REC-html40">' & newline>
	<cfset Lvar_String = Lvar_String & '<head><title>Transacciones de Adquisicion de Activos</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>' & newline>

	<cfset Lvar_String = Lvar_String & '<body>' & newline & '<table align="left">' & newline>
	<cfset Lvar_String = Lvar_String & '<tr>' & newline>
	<cffile action="append" file="#temporaryFileName#" output="#Lvar_String#" addnewline="no">

	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Categoria</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>DescripcionCategoria</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Clasificacion</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>DescripcionClasificacion</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Placa</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Activo</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Marca</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Modelo</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Serie</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Tipo</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>CFuncional</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>DescripcionCFuncional</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Oficina</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>DescripcionOficina</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>NUMERO_SOCIO</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>NOMBRE_SOCIO</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>FechaAdq</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>FachaInicioDepr</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>VidaUtil</b></td>'>
	
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Adquisicion</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Mejoras</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>Revaluacion</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>DepAcumAdquisicion</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>DepAcumMejoras</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>DepAcumRevaluacion</b></td>'>
	<cfset Lvar_String = Lvar_String & '<td align="right"><b>ValorLibros</b></td>'>
	<cfif contieneDatosVariables>
		<cfloop query="Etiquetas">
			<cfset Lvar_String = Lvar_String & '<td align="right"><b>#Etiquetas.DVencabezado#</b></td>'>
		</cfloop>
	</cfif>
	<cfset Lvar_String = Lvar_String & '</tr>'>
	<cfset Lvar_String = Lvar_String & '</tr>' & newline>

	<cffile action="append" file="#temporaryFileName#" output="#Lvar_String#" addnewline="yes">

	<cfloop query="rsControl">
		<cfset LvarOficinaProceso = fnObtieneDatos(rsControl.ACcodigo, rsControl.ACid, rsControl.Ocodigo, rsControl.CFid)>
		
		<cfloop query="data">			<!--- Grabar registro en el archivo --->
			<cfset Lvar_String = '<tr>' & newline>
			<cfset Lvar_String = Lvar_String & '<td align="right">#GvarCategoria#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#GvarDescripcionCategoria#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#GvarClasificacion#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#GvarDescripcionClasificacion#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.Placa#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.Activo#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.Marca#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.Modelo#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.Serie#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.Tipo#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#GvarCFuncional#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#GvarDescripcionCFuncional#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#GvarOficina#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#GvarDescripcionOficina#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.SNnumero#</td>'> <!---Codigo del Socios de Negocios--->
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.SNnombre#</td>'> <!---Nombre del Socios de Negocios--->			
			<cfset Lvar_String = Lvar_String & '<td align="left" x:str>#dateformat(data.FechaAdq,"DD/MM/YYYY")#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="left" x:str>#dateformat(data.FachaInicioDepr,"DD/MM/YYYY")#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.VidaUtil#</td>'>			
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.Adquisicion#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.Mejoras#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.Revaluacion#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.DepAcumAdquisicion#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.DepAcumMejoras#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.DepAcumRevaluacion#</td>'>
			<cfset Lvar_String = Lvar_String & '<td align="right">#data.ValorLibros#</td>'>
			<cfif contieneDatosVariables>
				<cfloop index="DVid" list="#URL.Datosvariables#" delimiters=",">
					<cfset Lvar_String = Lvar_String & '<td align="right">#Evaluate('data.DV_'&DVid)#</td>'>
				</cfloop>
			</cfif>

			<cfset Lvar_String = Lvar_String & '</tr>' & newline>
			<cffile action="append" file="#temporaryFileName#" output="#Lvar_String#" addnewline="yes">
		</cfloop>
	</cfloop>

	<cfset Lvar_String = '</table>' & newline>
	<cffile action="append" file="#temporaryFileName#" output="#Lvar_String#" addnewline="yes">
	<cfreturn true>
</cffunction>

<cffunction name="fnObtieneDatos" access="private" output="no" returntype="string">
	<cfargument name="ACcodigo" required="yes" type="numeric" default="-1">
	<cfargument name="ACid" required="yes" type="numeric" default="-1">
	<cfargument name="Ocodigo" required="yes" type="numeric" default="-1">
	<cfargument name="CFid" required="yes" type="numeric" default="-1">

	<cfquery name="rsCategoria" datasource="#session.dsn#">
		select cat.ACcodigodesc as Categoria, cat.ACdescripcion as DescripcionCategoria
		from ACategoria cat 
		where cat.Ecodigo  = #session.Ecodigo#  
		  and cat.ACcodigo = #Arguments.ACcodigo#
	</cfquery>
	<cfset GvarCategoria = trim(rsCategoria.Categoria)>
	<cfset GvarDescripcionCategoria = trim(rsCategoria.DescripcionCategoria)>
	
	<cfquery name="rsClasificacion" datasource="#session.dsn#">
		select cla.ACcodigodesc as Clasificacion, cla.ACdescripcion as DescripcionClasificacion
		from AClasificacion cla 
		where cla.Ecodigo = #session.Ecodigo#  
		  and cla.ACcodigo = #Arguments.ACcodigo# 
		  and cla.ACid = #Arguments.ACid#	
	</cfquery>
	<cfset GvarClasificacion = trim(rsClasificacion.Clasificacion)>
	<cfset GvarDescripcionClasificacion = trim(rsClasificacion.DescripcionClasificacion)>
	
	<cfquery name="rsCentroFuncional" datasource="#session.dsn#">
		select	cf.CFcodigo as CFuncional,
				cf.CFdescripcion as DescripcionCFuncional
		from CFuncional cf
		where CFid = #Arguments.CFid#
	</cfquery>
	<cfset GvarCFuncional = trim(rsCentroFuncional.CFuncional)>
	<cfset GvarDescripcionCFuncional = trim(rsCentroFuncional.DescripcionCFuncional)>
	
	<cfquery name="rsOficina" datasource="#session.dsn#">
		select 	o.Oficodigo as Oficina,
				o.Odescripcion as DescripcionOficina
		from Oficinas o
		where o.Ecodigo = #session.Ecodigo#
		  and o.Ocodigo = #Arguments.Ocodigo#
	</cfquery>
	<cfset GvarOficina = trim(rsOficina.Oficina)>
	<cfset GvarDescripcionOficina = trim(rsOficina.DescripcionOficina)>
	<cf_dbfunction name="OP_concat" returnVariable="_Cat">
	<cfquery name="data" datasource="#session.dsn#">
		select  				
				a.Aplaca as Placa, 
				a.Adescripcion as Activo,
				RTRIM(LTRIM(afm.AFMcodigo))  #_Cat#' - ' #_Cat# RTRIM(LTRIM(afm.AFMdescripcion)) as Marca, 
				RTRIM(LTRIM(afmm.AFMMcodigo))#_Cat#' - ' #_Cat# RTRIM(LTRIM(afmm.AFMMdescripcion)) as Modelo, 
				a.Aserie as Serie,
			
				a.Afechaaltaadq as FechaAdq,
				a.Afechainidep as FachaInicioDepr, 
				a.Avutil as VidaUtil, 

				AFSvaladq as Adquisicion, 
				AFSvalmej as Mejoras,
				AFSvalrev as Revaluacion, 	
				AFSdepacumadq as DepAcumAdquisicion, 
				AFSdepacummej as DepAcumMejoras, 
				AFSdepacumrev as DepAcumRevaluacion, 
				(AFSvaladq + AFSvalmej +AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev) as ValorLibros, 
				sn.SNnumero,
				sn.SNnombre,
				af.AFCcodigoclas #_Cat#' - ' #_Cat# af.AFCdescripcion as Tipo
				<!---Datos Variables--->
				<cfif contieneDatosVariables>
					<cfloop index="DVid" list="#URL.Datosvariables#" delimiters=",">
						,(select
							case when dv.DVtipoDato = 'L' then vdv.DVVvalor #_Cat#'-'#_Cat#  ldv.DVLdescripcion
								 when dv.DVtipoDato = 'H' then vdv.DVVvalor
							  else vdv.DVVvalor end
							 from DVvalores vdv 
							 	inner join DVdatosVariables dv
									on dv.DVid = vdv.DVid
							 	left outer join DVlistaValores ldv
									on ldv.DVid = vdv.DVid
									and ldv.DVLcodigo = vdv.DVVvalor
						   where vdv.DVTcodigoValor = 'AF' 
							 and vdv.DVid = #DVid# 
							 and vdv.DVVidTablaVal = a.Aid
							 and vdv.DVVidTablaSec = 0) as DV_#DVid#
					</cfloop>
				</cfif>
		from AFSaldos b
			inner join Activos a
			on a.Aid = b.Aid

			inner join AFMarcas afm
			on afm.AFMid = a.AFMid

			inner join AFMModelos afmm
			on afmm.AFMMid = a.AFMMid
			
			inner join AFClasificaciones af
			on af.Ecodigo = b.Ecodigo
			and af.AFCcodigo = b.AFCcodigo
			
					
			left outer join SNegocios sn
			on sn.Ecodigo   = a.Ecodigo
			and sn.SNcodigo = a.SNcodigo 

		where b.Ecodigo    = #session.Ecodigo#
		  and b.AFSperiodo = #url.Periodo#
		  and b.AFSmes     = #url.Mes#
		  and b.ACcodigo   = #rsControl.ACcodigo#
		  and b.ACid       = #rsControl.ACid#
		  and b.Ocodigo    = #rsControl.Ocodigo#
		  and b.CFid       = #rsControl.CFid#
		order by a.Aplaca
	</cfquery>
	<cfreturn GvarOficina>
</cffunction>

<cffunction name="fnGeneraSalidaCFR" access="private" output="no" returntype="boolean">
	<cfargument name="maxrows" type="numeric" required="yes">
	
	<!--- Consulta de Cantidad de Registros --->
	<cfquery name="rsReporteCount" datasource="#session.dsn#">
		select count(1) as Total
		from AFSaldos b
			inner join Activos a  
				on  a.Aid = b.Aid
			
			inner join ACategoria cat 
				on cat.Ecodigo = b.Ecodigo  
				and cat.ACcodigo = b.ACcodigo

			inner join AClasificacion cla 
				on cla.Ecodigo = b.Ecodigo  
				and cla.ACcodigo = b.ACcodigo 
				and cla.ACid = b.ACid

			inner join CFuncional cf
				on cf.CFid = b.CFid
			
			inner join Oficinas o
				on o.Ecodigo = b.Ecodigo
				and o.Ocodigo = b.Ocodigo

			inner join AFClasificaciones af
				on af.Ecodigo = b.Ecodigo
				and af.AFCcodigo = b.AFCcodigo
			
		where b.Ecodigo = #session.Ecodigo#
		and b.AFSperiodo = #url.Periodo#
		and b.AFSmes =  #url.Mes#
		<cfif isdefined('url.CFcodigoI') and LEN(TRIM(url.CFcodigoI)) gt 0  and isdefined('url.CFcodigoF') and LEN(TRIM(url.CFcodigoF)) gt 0>
			and cf.CFcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoI#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoF#">
		<cfelseif isdefined('url.CFcodigoI') and LEN(TRIM(url.CFcodigoI)) gt 0>
			and cf.CFcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoI#">
		<cfelseif isdefined('url.CFcodigoF') and LEN(TRIM(url.CFcodigoF)) gt 0>
			and cf.CFcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoF#">
		</cfif>
		
		<cfif isdefined('url.OcodigoI') and LEN(TRIM(url.OcodigoI)) gt 0  and isdefined('url.OcodigoF') and LEN(TRIM(url.OcodigoF)) gt 0>
			and b.Ocodigo between #url.OcodigoI# and #url.OcodigoF#
		<cfelseif isdefined('url.OcodigoI') and LEN(TRIM(url.OcodigoI)) gt 0>
			and b.Ocodigo >= #url.OcodigoI#
		<cfelseif isdefined('url.OcodigoF') and LEN(TRIM(url.OcodigoF)) gt 0>
			and b.Ocodigo <= #url.OcodigoF#
		</cfif>
		
		<cfif isdefined('url.ACcodigoI') and LEN(TRIM(url.ACcodigoI)) gt 0  and isdefined('url.ACcodigoF') and LEN(TRIM(url.ACcodigoF)) gt 0>
			and cat.ACcodigo between #url.ACcodigoI# and #url.ACcodigoF#
		<cfelseif isdefined('url.ACcodigoI') and LEN(TRIM(url.ACcodigoI)) gt 0>
			and cat.ACcodigo >= #url.ACcodigoI#
		<cfelseif isdefined('url.ACcodigoF') and LEN(TRIM(url.ACcodigoF)) gt 0>
			and cat.ACcodigo <= #url.ACcodigoF#
		</cfif>
		
		<cfif isdefined('url.ACidI') and LEN(TRIM(url.ACidI)) gt 0  and isdefined('url.ACcodigoF') and LEN(TRIM(url.ACidF)) gt 0>
			and cla.ACid between #url.ACidI# and #url.ACidF#
		<cfelseif isdefined('url.ACidI') and LEN(TRIM(url.ACidI)) gt 0>
			and cla.ACid >= #url.ACcodigoI#
		<cfelseif isdefined('url.ACidF') and LEN(TRIM(url.ACidF)) gt 0>
			and cla.ACid <= #url.ACidF#
		</cfif>
		<cfif isdefined('url.AFCcodigopadre') and LEN(TRIM(url.AFCcodigopadre)) gt 0 and url.AFCcodigopadre gte 0>
			and af.AFCcodigo = #url.AFCcodigopadre#
		</cfif>
	</cfquery>
	<cfif rsReporteCount.Total GT Arguments.maxrows>
		<cfreturn true>
	</cfif>
	
	<!--- formato por defecto es html --->
	<cfif not isdefined("url.formato") >
		<cfset tipoformato = "html">
	<cfelse>
		<cfset tipoformato = url.formato >
	</cfif>
	
	<!--- Consulta el Centro funcional del filtro para enviarle al reporte en cfreport --->
	<cfif isdefined('url.CFidI')  and url.CFidI GT 0>
		<cfquery name="rsCfuncional" datasource="#session.DSN#">
			select CFcodigo,CFdescripcion
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and CFid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFidI#">
		</cfquery>
	</cfif>

	<!--- Consulta del Reporte --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select b.CFid, b.AFSid, rtrim(ltrim(cat.ACcodigodesc)) as Categoria, 
				rtrim(ltrim(cat.ACdescripcion)) as DescripcionCategoria, 
				rtrim(ltrim(cla.ACcodigodesc)) as Clasificacion, 
				rtrim(ltrim(cla.ACdescripcion)) as DescripcionClasificacion, 
				
				'#Session.Enombre#' as Edescripcion,
				a.Aplaca,
				a.Adescripcion,
				cf.CFcodigo,
				cf.CFdescripcion,
				o.Oficodigo,
				o.Odescripcion,
				a.Afechaaltaadq as fechaAdq,
				a.Afechainidep,
				a.Avutil,
		
				AFSvaladq,
				AFSvalmej,
				AFSvalrev,
				AFSdepacumadq,
				AFSdepacummej,
				AFSdepacumrev,
				(AFSvaladq + AFSvalmej +AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev) as ValorLibros, 
				af.AFCdescripcion, 
				af.AFCcodigoclas
				
		from AFSaldos b
			inner join Activos a  
				on  a.Aid = b.Aid
			
			inner join ACategoria cat 
				on cat.Ecodigo = b.Ecodigo  
				and cat.ACcodigo = b.ACcodigo
			
			inner join AClasificacion cla 
				on cla.Ecodigo = b.Ecodigo  
				and cla.ACcodigo = b.ACcodigo 
				and cla.ACid = b.ACid
			
			inner join CFuncional cf
				on b.CFid = cf.CFid
			
			inner join Oficinas o
				on o.Ecodigo = b.Ecodigo
				and o.Ocodigo = b.Ocodigo

			inner join AFClasificaciones af
				on af.Ecodigo = b.Ecodigo
				and af.AFCcodigo = b.AFCcodigo
		
		where b.Ecodigo = #session.Ecodigo#
		and b.AFSperiodo = #url.Periodo#
		and b.AFSmes =  #url.Mes#
		<cfif isdefined('url.CFcodigoI') and LEN(TRIM(url.CFcodigoI)) gt 0  and isdefined('url.CFcodigoF') and LEN(TRIM(url.CFcodigoF)) gt 0>
			and cf.CFcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoI#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoF#">
		<cfelseif isdefined('url.CFcodigoI') and LEN(TRIM(url.CFcodigoI)) gt 0>
			and cf.CFcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoI#">
		<cfelseif isdefined('url.CFcodigoF') and LEN(TRIM(url.CFcodigoF)) gt 0>
			and cf.CFcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.CFcodigoF#">
		</cfif>
		
		<cfif isdefined('url.OcodigoI') and LEN(TRIM(url.OcodigoI)) gt 0  and isdefined('url.OcodigoF') and LEN(TRIM(url.OcodigoF)) gt 0>
			and b.Ocodigo between #url.OcodigoI# and #url.OcodigoF#
		<cfelseif isdefined('url.OcodigoI') and LEN(TRIM(url.OcodigoI)) gt 0>
			and b.Ocodigo >= #url.OcodigoI#
		<cfelseif isdefined('url.OcodigoF') and LEN(TRIM(url.OcodigoF)) gt 0>
			and b.Ocodigo <= #url.OcodigoF#
		</cfif>
		
		<cfif isdefined('url.ACcodigoI') and LEN(TRIM(url.ACcodigoI)) gt 0  and isdefined('url.ACcodigoF') and LEN(TRIM(url.ACcodigoF)) gt 0>
			and cat.ACcodigo between #url.ACcodigoI# and #url.ACcodigoF#
		<cfelseif isdefined('url.ACcodigoI') and LEN(TRIM(url.ACcodigoI)) gt 0>
			and cat.ACcodigo >= #url.ACcodigoI#
		<cfelseif isdefined('url.ACcodigoF') and LEN(TRIM(url.ACcodigoF)) gt 0>
			and cat.ACcodigo <= #url.ACcodigoF#
		</cfif>
		
		<cfif isdefined('url.ACidI') and LEN(TRIM(url.ACidI)) gt 0  and isdefined('url.ACcodigoF') and LEN(TRIM(url.ACidF)) gt 0>
			and cla.ACid between #url.ACidI# and #url.ACidF#
		<cfelseif isdefined('url.ACidI') and LEN(TRIM(url.ACidI)) gt 0>
			and cla.ACid >= #url.ACcodigoI#
		<cfelseif isdefined('url.ACidF') and LEN(TRIM(url.ACidF)) gt 0>
			and cla.ACid <= #url.ACidF#
		</cfif>
		<cfif isdefined('url.AFCcodigopadre') and LEN(TRIM(url.AFCcodigopadre)) gt 0 and url.AFCcodigopadre gte 0>
			and af.AFCcodigo = #url.AFCcodigopadre#
		</cfif>
		order by cf.CFcodigo, o.Oficodigo, cat.ACcodigodesc, cla.ACcodigodesc, a.Aplaca
	</cfquery>	


	<!--- Invoca el Reporte en CFreport --->		
	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
		<cfset formatos = "excel">
	</cfif>
	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "af.consultas.activosAdq"
		headers = "empresa:#Session.Enombre#"/>
	<cfelse>
	<cfreport format="#formatos#" template= "activosAdq.cfr" query="rsReporte">
		<cfif isdefined("url.Categoria") and LEN(TRIM(url.Categoria))>
			<cfreportparam name="Categoria" value="#url.Categoria#">
		</cfif>
		<cfif isdefined("url.CategoriaDesc") and LEN(TRIM(url.CategoriaDesc))>
			<cfreportparam name="CategoriaDesc" value="#url.CategoriaDesc#">
		</cfif>
		
		<cfif isdefined("url.Clasificacion") and LEN(TRIM(url.Clasificacion))>
			<cfreportparam name="Clasificacion" value="#url.Clasificacion#">
		</cfif>
		<cfif isdefined("url.ClasificacionDesc") and LEN(TRIM(url.ClasificacionDesc))>
			<cfreportparam name="ClasificacionDesc" value="#url.ClasificacionDesc#">
		</cfif>
		
		<cfif isdefined("rsCfuncional") and rsCfuncional.recordcount gt 0>
			<cfreportparam name="CFcodigo" value="#rsCfuncional.CFcodigo#">
		</cfif>
		<cfif isdefined("rsCfuncional") and rsCfuncional.recordcount gt 0>
			<cfreportparam name="CFdescripcion" value="#rsCfuncional.CFdescripcion#">
		</cfif>
		
		<cfif isdefined("url.Periodo") and url.Periodo GT 0>
			<cfreportparam name="Periodo" value="#url.Periodo#">
		</cfif>
		<cfif isdefined("url.Mes") and url.Mes GT 0>
			<cfreportparam name="Mes" value="#url.Mes#">
		</cfif>
		<cfreportparam name="Empresa" value="#Session.Enombre#">
	</cfreport>
	</cfif>
</cffunction>

