<cfsetting requesttimeout="14400">
<cfif isdefined('url.temp') and len(trim(url.temp)) GT 0>
	<cfif FileExists(#url.temp#)>
		<cfset _LvarFileName = '#session.Usulogin#_#dateformat(now(), "hhmmss")#.xls'>
        <cfheader name="Content-Disposition"	value="attachment;filename=#_LvarFileName#">
        <cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
        <cfcontent type="application/msexcel" reset="yes" file="#url.temp#" deletefile="yes">
    <cfelse>
        <cf_templatecss>
        <cf_templateheader>
        <form name="form1" action="SaldoActivos.cfm" method="post">
            <p>El Archivo temporal no existe.  Presione Regresar para volver al reporte</p>
                <p><input type="submit" name="Regresar" value="Regresar" /></p>
        </form>
        <cf_templatefooter>
    </cfif>
	<cfabort>
</cfif>
<!---Prepara variables de trabajo --->
<cfset GVarReporteResumido = false>
<cfset LvarAid = -1>
<cfset LvarBanderaPrimerVez = true>
<cfset GvarDeptoCodigoDes = "">
<cfset GvarDeptoCodigoHas = "">
<cfset LvarPeriodo = form.Periodo>
<cfset LvarMes = form.Mes>
<cfset newline = Chr(13) & Chr(10)>
<cfif isdefined("form.resumido")>
	<cfset GVarReporteResumido = true>
</cfif>
<cfif isdefined('form.Aid') and len(trim(form.Aid)) GT 0>
	<cfset LvarAid = form.Aid>
</cfif> 
<cfif isdefined("form.DepartamentoDes") and Len(Trim(form.DepartamentoDes)) gt 0>
	<cfset GvarDeptoCodigoDes = rtrim(form.DepartamentoDes)>
</cfif>
<cfif isdefined("form.DepartamentoHas") and Len(Trim(form.DepartamentoHas)) gt 0>
	<cfset GvarDeptoCodigoHas = rtrim(form.DepartamentoHas)>
</cfif>
<!--- Determinar la fecha de fin de mes ( ultimo dia del mes ) para buscar los responsables de Activo Fijo --->
<cfset LvarFechaFinMes = createdate(LvarPeriodo,Lvarmes, 01)>
<cfset LvarFechaFinMes = dateadd("m", 1, LvarFechaFinMes)>
<cfset LvarFechaFinMes = dateadd("d", -1, LvarFechaFinMes)>

<!--- Exportación a Archivo Excel --->
<cfset buffer = CreateObject("java", "java.lang.StringBuffer").init( JavaCast("int", 180000 ))>
<cfset temporaryFileName = GetTempFile( GetTempDirectory(), 'tmp_SaldoAct')>
<cfset FinalFileName =  GetTempDirectory() & 'SaldoActivos_#session.usulogin#_#dateformat(now(), "DDMMYY")#_#TimeFormat(now(), "hhmmssL")#.xls'>
<cfset ShortFileName =  mid(FinalFileName, find('SaldoActivos',FinalfileName),60)>
<cffile action="write" file="#temporaryFileName#" output="" addnewline="no">
<cf_dbfunction name="dateadd" args="30, b.Afechaaltaadq, DD" returnvariable="LvarFecha">
<cf_templatecss>
<cf_templateheader>
	<p>Generación el archivo... Inicio: <cfoutput>#TimeFormat(now(), "hh:mm:ss.L")#</cfoutput></p>
	<cfif isdefined("form.OFICINAIni") and Len(Trim(form.OFICINAIni)) gt 0>
		<br />Oficina Inicial:<cfoutput>#form.OFICINAIni#</cfoutput>
	</cfif>
	<cfif isdefined("form.OFICINAFin") and Len(Trim(form.OFICINAFin)) gt 0>
		<br />Oficina Final:<cfoutput>#form.OFICINAFin#</cfoutput>
	</cfif>
	<cfif isdefined("form.CATEGORIA1") and Len(Trim(form.CATEGORIA1)) gt 0>
		<br />Categoria Inicial: <cfoutput>#form.CATEGORIA1#</cfoutput>
	</cfif>
	<cfif isdefined("form.CATEGORIA2") and Len(Trim(form.CATEGORIA2)) gt 0>
		<br />Categoria Final: <cfoutput>#form.CATEGORIA2#</cfoutput>
	</cfif>
	<cfif isdefined("form.CLASE1") and Len(Trim(form.CLASE1)) gt 0>
		<br />Clase Inicial: <cfoutput>#form.CLASE1#</cfoutput>
	</cfif>
	<cfif isdefined("form.CLASE2") and Len(Trim(form.CLASE2)) gt 0>
		<br />Clase Final: <cfoutput>#form.CLASE2#</cfoutput>
	</cfif>
	<p>Se desplegarán las clases que se procesan y se graban en el archivo.
	<br />Hacer click en el link al final de la página para descargar el archivo <strong> <cfoutput>#ShortFileName#</cfoutput> </strong></p>
	<br />
	<cfflush interval="32">
	<table cellspacing="0" cellpadding="1" border="0">
	<tr>
		<td><strong>Oficina</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td><strong>Categoria</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td><strong>Clase</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td align="right"><strong>Cantidad<br />Activos</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td align="right"><strong>Hora<br />Inicio</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td align="right"><strong>Hora<br />Control</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td align="right"><strong>Hora<br />Final</strong></td>
	</tr>
	<cfset LvarResultado = fnGeneraSalida()>
	</table>
	<cfif LvarResultado eq 1>
		<cffile action="rename" source="#temporaryFileName#" destination="#FinalFileName#">
		<cfoutput>
			<form name="form1" action="SaldoActivos.cfm" method="post">
				<p>El Archivo <a href="SaldoActivosArc.cfm?Temp=#FinalFileName#"><strong>#ShortFileName#</strong> fue generado correctamente. <strong> Presione AQUI para descargarlo</strong></a> </p>
				<p><input type="submit" name="Regresar" value="Regresar" /></p>
			</form>
		</cfoutput>
	</cfif>
<cf_templatefooter>

<cffunction name="write_to_buffer" output="no" access="private">
	<cfargument name="contents" type="string" required="yes">
	<cfargument name="flush" type="boolean"   default="no">
	<cfset buffer.append(JavaCast("string", Arguments.contents))>
	<cfif Arguments.flush Or (buffer.length() GTE 150000)>
		<cffile action="append" file="#temporaryFileName#" output="#buffer.toString()#" addnewline="no">
		<cfset buffer.setLength(0)>
	</cfif>
</cffunction>

<cffunction name="fnGeneraSalida" access="private" output="yes" returntype="numeric">
	<cfset fnObtieneCategorias()>
	<cfloop query="rsCategoria">
		<cfset fnProcesaCategoria(rsCategoria.Ocodigo, rsCategoria.ACcodigo, rsCategoria.ACid, rsCategoria.Oficodigo, rsCategoria.Categoria, rsCategoria.DesCategoria, rsCategoria.Clase, rsCategoria.DesClase)>
        <cfset fnPintaSalida()>
	</cfloop>
	<cfset write_to_buffer('</table> #newline#', true)>
    <cfreturn 1>
</cffunction>

<cffunction name="fnEjecutaResumido" access="private" output="no" hint="Ejecuta el Query para reporte Resumido">
	<cfargument name="Empresa"		type="numeric" required="yes">
	<cfargument name="Periodo"		type="numeric" required="yes">
	<cfargument name="Mes"			type="numeric" required="yes">
	<cfargument name="ArgOcodigo" 	type="numeric" required="yes">
	<cfargument name="ArgACcodigo" 	type="numeric" required="yes">
	<cfargument name="ArgACid"		type="numeric" required="yes">
	<cfargument name="Conexion"	 	type="string"  required="yes">
	<cfargument name="Aid"			type="numeric" required="yes" default="0">	
	<cfquery name="data" datasource="#Arguments.Conexion#">
		select
			dd.Deptocodigo as Cod_Depto,
			min(dd.Ddescripcion) as Departamento,
			sum(a.AFSvaladq) as MontoAdquisicion,
			sum(a.AFSvalmej) as MontoMejoras,
			sum(a.AFSvalrev) as MontoRevaluacion,
			sum(a.AFSdepacumadq) as MontoDepCompra,
			sum(a.AFSdepacummej) as MontoDepMejora,
			sum(a.AFSdepacumrev) as MontoDepRev,
			sum(b.Avalrescate) as MontoValorRescate,
			count(1) as CantidadActivos
		from AFSaldos a
			inner join Activos b
				on b.Aid = a.Aid
			inner join CFuncional c
				on c.CFid = a.CFid
			inner join Departamentos dd
				on dd.Ecodigo=c.Ecodigo
				and dd.Dcodigo=c.Dcodigo
		where a.Ecodigo = #Arguments.Empresa#
		  and a.AFSperiodo = #Arguments.Periodo# 
		  and a.AFSmes = #Arguments.Mes#
		  and c.Ocodigo  = #ArgOcodigo#
		  and a.ACcodigo = #ArgACcodigo#
		  and a.ACid     = #ArgACid#
		<cfif Arguments.Aid GT -1>
			and a.Aid = #Arguments.Aid#
		</cfif>
        <cfif Len(GvarDeptoCodigoDes) gt 0>
			and  dd.Deptocodigo	>= '#GvarDeptoCodigoDes#'
		</cfif>
		<cfif Len(GvarDeptoCodigoHas) gt 0>
			and  dd.Deptocodigo	<= '#GvarDeptoCodigoHas#'
		</cfif>
		group by dd.Deptocodigo
		order by dd.Deptocodigo
	</cfquery>
</cffunction>

<cffunction name="fnEjecutaDetallado" access="private" output="no" hint="Ejecuta el Query para reporte Detallado">
	<cfargument name="Empresa"		type="numeric" required="yes">
	<cfargument name="Periodo"		type="numeric" required="yes">
	<cfargument name="Mes"			type="numeric" required="yes">
	<cfargument name="ArgOcodigo" 	type="numeric" required="yes">
	<cfargument name="ArgACcodigo" 	type="numeric" required="yes">
	<cfargument name="ArgACid"		type="numeric" required="yes">
	<cfargument name="Conexion"	 	type="string"  required="yes">
	<cfargument name="Aid"			type="numeric" required="yes" default="0">
	<cfargument name="ArgFechaFinMes" type="date" required="yes" default="now()">
	<cfquery name="data" datasource="#session.dsn#">
		select 
            dd.Deptocodigo as Cod_Depto,
            dd.Ddescripcion as Departamento,
			b.Aplaca as Placa,
			b.Adescripcion as Activo,
			{fn concat(RTRIM(LTRIM(afm.AFMcodigo)), {fn concat(' - ',RTRIM(LTRIM(afm.AFMdescripcion)))})} as Marca, 
			{fn concat(RTRIM(LTRIM(afmm.AFMMcodigo)), {fn concat(' - ',RTRIM(LTRIM(afmm.AFMMdescripcion)))})} as Modelo, 
			b.Aserie as Serie,
			c.CFcodigo as Codigo_CentroF,
			c.CFdescripcion CentroF,
			td.CRTDcodigo as Cod_Docum,
			td.CRTDdescripcion as Documento,
			cc.CRCCcodigo as CodCCustodia,
			cc.CRCCdescripcion as CCustodia,
			b.Afechaaltaadq as Fecha_ADQ,
<!---Cambiar la siguiente línea --->
			a.AFSvutiladq as VidaUtilAdq,
<!---
			coalesce(
				( 
					select max(ta1.TAvutil) 
					from TransaccionesActivos ta1
					where ta1.TAid = ((
							select min(ta.TAid)
							from TransaccionesActivos ta
							where ta.Aid   = b.Aid 
							and ta.IDtrans = 1
						))
				), a.AFSvutiladq) as VidaUtilAdq,
--->
			a.AFSvaladq as MontoAdquisicion,
			a.AFSvalmej as MontoMejoras,
			a.AFSvalrev as MontoRevaluacion,
			a.AFSdepacumadq as MontoDepCompra,
			a.AFSdepacummej as MontoDepMejora,
			a.AFSdepacumrev as MontoDepRev,
			b.Avalrescate as ValorRescate,
			a.AFSvutiladq as VidaUtil,
			a.AFSsaldovutiladq as SaldoVidaUtil
		from AFSaldos a 
			inner join Activos b 
				on b.Aid = a.Aid 
			inner join AFMarcas afm 
				on afm.AFMid = b.AFMid 
			inner join AFMModelos afmm 
				on afmm.AFMMid = b.AFMMid 
			inner join CFuncional c 
				on c.CFid = a.CFid 
			inner join Departamentos dd
				on dd.Ecodigo  = c.Ecodigo
				and dd.Dcodigo = c.Dcodigo
			inner join AFResponsables resp 
					inner join CRCentroCustodia cc 
					on cc.CRCCid     = resp.CRCCid 
					inner join CRTipoDocumento td 
					on td.CRTDid = resp.CRTDid 
				on  resp.Aid     = a.Aid 
				and resp.Ecodigo = a.Ecodigo 
				and #ArgFechaFinMes# between resp.AFRfini and resp.AFRffin
		where a.Ecodigo = #Arguments.Empresa#
		  and a.AFSperiodo = #Arguments.Periodo# 
		  and a.AFSmes = #Arguments.Mes#
		  and a.ACcodigo = #ArgACcodigo#
		  and a.ACid     = #ArgACid#
		  and c.Ocodigo  = #ArgOcodigo#
		<cfif Arguments.Aid GT -1>
			and a.Aid = #Arguments.Aid#
		</cfif>
		  and (	round(a.AFSvaladq,0.00) > 0 or round(a.AFSvalmej,0.00) > 0 or round(a.AFSvalrev,0.00) > 0 )
        <cfif Len(GvarDeptoCodigoDes) gt 0>
			and  dd.Deptocodigo	>= '#GvarDeptoCodigoDes#'
		</cfif>
		<cfif Len(GvarDeptoCodigoHas) gt 0>
			and  dd.Deptocodigo	<= '#GvarDeptoCodigoHas#'
		</cfif>
		order by dd.Deptocodigo, b.Aplaca
	</cfquery>
</cffunction>

<cffunction name="fnGeneraColumnas" access="private" output="no" hint="Genera la información de las columnas">
	<cfset LvarCols = data.getColumnNames()>
	<cfset LvarFileType[1] = "S">
	<cfloop index="i" from="1" to="#arrayLen(LvarCols)#"><cfsilent>
		<cfset LvarJavaType = evaluate("data.#LvarCols[i]#").getClass().getName()>
		<cfif findNoCase("Integer",LvarJavaType) GT 0>
			<cfset LvarFileType[i] = "N">
		<cfelseif findNoCase("BigDecimal",LvarJavaType) GT 0>
			<cfset LvarFileType[i] = "N">
		<cfelseif findNoCase("Double",LvarJavaType) GT 0>
			<cfset LvarFileType[i] = "N">
		<cfelseif findNoCase("Float",LvarJavaType) GT 0>
			<cfset LvarFileType[i] = "N">
		<cfelseif findNoCase("Time",LvarJavaType) GT 0>
			<cfset LvarFileType[i] = "T">
		<cfelseif findNoCase("Date",LvarJavaType) GT 0>
			<cfset LvarFileType[i] = "D">
		<cfelseif findNoCase("[B",LvarJavaType) GT 0>
			<cfset LvarFileType[i] = "B">
		<cfelse>
			<cfset LvarFileType[i] = "S">
		</cfif>
	</cfsilent></cfloop>
	<cfset write_to_buffer('<html xmlns:o="urn:schemas-microsoft-com:office:office" ' & 
			'xmlns:x="urn:schemas-microsoft-com:office:excel" ' &
			'xmlns="http://www.w3.org/TR/REC-html40">' & newline)>
	<cfset write_to_buffer('<table> #newline#')>
	<cfset write_to_buffer('<tr>')>
	<cfset write_to_buffer('<td>Oficina</td>')>
	<cfset write_to_buffer('<td>Cat</td>')>
	<cfset write_to_buffer('<td>Categoria</td>')>
	<cfset write_to_buffer('<td>Cla</td>')>
	<cfset write_to_buffer('<td>Clase</td>')>
	<cfloop index="i" from="1" to="#arrayLen(LvarCols)#"><cfsilent>
		<cfset write_to_buffer('<td>#LvarCols[i]#</td>')>
	</cfsilent></cfloop>
	<cfset write_to_buffer('</tr> #newline#')>
</cffunction>

<cffunction name="fnObtieneCategorias" access="private" output="no" hint="Genera las Categorias para Exportar">
	<cfif LvarAid gt 0>
		<!--- Está solicitandose un único activo. El query de la selección se hace únicamente para dicho activo y los filtros correspondientes --->
		<cfquery name="rsCategoria" datasource="#session.dsn#">
			select
				o.Oficodigo, e.ACcodigodesc as Categoria, f.ACcodigodesc as Clase,
				o.Ocodigo as Ocodigo, e.ACcodigo as ACcodigo, f.ACid ACid,
				o.Odescripcion as Oficina, e.ACdescripcion as DesCategoria, f.ACdescripcion as DesClase
			from AFSaldos a
					inner join AClasificacion f
						inner join ACategoria e
							 on e.ACcodigo = f.ACcodigo
							and e.Ecodigo  = f.Ecodigo
					on  f.ACid     = a.ACid
					and f.ACcodigo = a.ACcodigo
					and f.Ecodigo  = a.Ecodigo
					inner join CFuncional cf
						inner join Oficinas o
						on  o.Ecodigo = cf.Ecodigo
						and o.Ocodigo = cf.Ocodigo

						inner join Departamentos dd
						 on dd.Ecodigo = cf.Ecodigo
						and dd.Dcodigo = cf.Dcodigo

					on cf.CFid = a.CFid
			where a.Ecodigo    = #session.Ecodigo#
			and   a.AFSperiodo = #form.Periodo# 
			and   a.AFSmes 	   = #form.Mes#
			and   a.Aid        = #LvarAid#
			<cfif isdefined("form.OFICINAIni") and Len(Trim(form.OFICINAIni)) gt 0>
				and  o.Oficodigo	>= '#rtrim(form.OFICINAIni)#'
			</cfif>
			<cfif isdefined("form.OFICINAFin") and Len(Trim(form.OFICINAFin)) gt 0>
				and  o.Oficodigo	<= '#rtrim(form.OFICINAFin)#'
			</cfif>
			<cfif isdefined("form.CATEGORIA1") and Len(Trim(form.CATEGORIA1)) gt 0>
				and  e.ACcodigodesc	>= '#rtrim(form.CATEGORIA1)#'
			</cfif>
			<cfif isdefined("form.CATEGORIA2") and Len(Trim(form.CATEGORIA2)) gt 0>
				and  e.ACcodigodesc	<= '#rtrim(form.CATEGORIA2)#'
			</cfif>
			<cfif isdefined("form.CLASE1") and Len(Trim(form.CLASE1)) gt 0>
				and  f.ACcodigodesc	>=  '#form.CLASE1#'
			</cfif>
			<cfif isdefined("form.CLASE2") and Len(Trim(form.CLASE2)) gt 0>
				and  f.ACcodigodesc	<=  '#form.CLASE2#'
			</cfif>	
			<cfif Len(GvarDeptoCodigoDes) gt 0>
				and  dd.Deptocodigo	>= '#GvarDeptoCodigoDes#'
			</cfif>
			<cfif Len(GvarDeptoCodigoHas) gt 0>
				and  dd.Deptocodigo	<= '#GvarDeptoCodigoHas#'
			</cfif>
		</cfquery>
	<cfelse>
		<!--- No hay parametro de Activo para el informe. Se determinan los parámetros de generación --->
		<cfquery name="rsCategoria" datasource="#session.dsn#">
			select
				o.Oficodigo, e.ACcodigodesc as Categoria, f.ACcodigodesc as Clase,
				o.Ocodigo as Ocodigo, e.ACcodigo as ACcodigo, f.ACid ACid,
				o.Odescripcion as Oficina, e.ACdescripcion as DesCategoria, f.ACdescripcion as DesClase
			from Oficinas o, ACategoria e, AClasificacion f
			where o.Ecodigo = #session.Ecodigo#
			<cfif isdefined("form.OFICINAIni") and Len(Trim(form.OFICINAIni)) gt 0>
				and  o.Oficodigo	>= '#rtrim(form.OFICINAIni)#'
			</cfif>
			<cfif isdefined("form.OFICINAFin") and Len(Trim(form.OFICINAFin)) gt 0>
				and  o.Oficodigo	<= '#rtrim(form.OFICINAFin)#'
			</cfif>
			  and e.Ecodigo = #session.Ecodigo#
			<cfif isdefined("form.CATEGORIA1") and Len(Trim(form.CATEGORIA1)) gt 0>
				and  e.ACcodigodesc	>= '#rtrim(form.CATEGORIA1)#'
			</cfif>
			<cfif isdefined("form.CATEGORIA2") and Len(Trim(form.CATEGORIA2)) gt 0>
				and  e.ACcodigodesc	<= '#rtrim(form.CATEGORIA2)#'
			</cfif>
				and f.ACcodigo = e.ACcodigo 
				and f.Ecodigo  = e.Ecodigo
			<cfif isdefined("form.CLASE1") and Len(Trim(form.CLASE1)) gt 0>
				and  f.ACcodigodesc	>=  '#form.CLASE1#'
			</cfif>
			<cfif isdefined("form.CLASE2") and Len(Trim(form.CLASE2)) gt 0>
				and  f.ACcodigodesc	<=  '#form.CLASE2#'
			</cfif>
			and (
				select count(1) 
				from AFSaldos a 
				where a.Ecodigo  = #session.Ecodigo#
				  and a.AFSperiodo = #LvarPeriodo#
				  and a.AFSmes = #LvarMes#
				  and a.ACid     = f.ACid
				  and a.ACcodigo = f.ACcodigo
				  and a.Ecodigo  = f.Ecodigo
				  and a.Ocodigo  = o.Ocodigo
				 ) > 0
			order by o.Oficodigo, e.ACcodigodesc, f.ACcodigodesc
		</cfquery>
	</cfif>
</cffunction>	

<cffunction name="fnGrabaResumido" output="no" access="private"  returntype="boolean"  hint="Genera la salida de los registros detallados">
	<cfargument name="LParOficodigo" type="string" required="yes">
	<cfargument name="LParCategoria" type="string" required="yes">
	<cfargument name="LParDesCategoria" type="string" required="yes">
	<cfargument name="LParClase" type="string" required="yes">
	<cfargument name="LParDesClase" type="string" required="yes">
	<cfif LvarCantidadActivos LT 1>
		<cfreturn false>
	</cfif>
    <cfloop query="data"><cfsilent>
        <cfset write_to_buffer('<tr>')>
		<cfset write_to_buffer('<td x:str>#Arguments.LParOficodigo#</td>')>
		<cfset write_to_buffer('<td x:str>#Arguments.LParCategoria#</td>')>
		<cfset write_to_buffer('<td x:str>#Arguments.LParDesCategoria#</td>')>
		<cfset write_to_buffer('<td x:str>#Arguments.LParClase#</td>')>
		<cfset write_to_buffer('<td x:str>#Arguments.LParDesClase#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Cod_Depto#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Departamento#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoAdquisicion#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoMejoras#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoRevaluacion#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoDepCompra#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoDepMejora#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoDepRev#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoValorRescate#</td>')>
        <cfset write_to_buffer('</tr>')>
	</cfsilent></cfloop>
	<cfset Procesado = true>
	<cfreturn Procesado>
</cffunction>

<cffunction name="fnGrabaDetallado" output="no" access="private" returntype="boolean" hint="Genera la salida de los registros detallados">
	<cfargument name="LParOficodigo" type="string" required="yes">
	<cfargument name="LParCategoria" type="string" required="yes">
	<cfargument name="LParDesCategoria" type="string" required="yes">
	<cfargument name="LParClase" type="string" required="yes">
	<cfargument name="LParDesClase" type="string" required="yes">
	<cfif LvarCantidadActivos lt 1>
		<cfreturn false>
	</cfif>
    <cfloop query="data"><cfsilent>
        <cfset write_to_buffer('<tr>')>
		<cfset write_to_buffer('<td x:str>#Arguments.LParOficodigo#</td>')>
		<cfset write_to_buffer('<td x:str>#Arguments.LParCategoria#</td>')>
		<cfset write_to_buffer('<td x:str>#Arguments.LParDesCategoria#</td>')>
		<cfset write_to_buffer('<td x:str>#Arguments.LParClase#</td>')>
		<cfset write_to_buffer('<td x:str>#Arguments.LParDesClase#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Cod_Depto#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Departamento#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Placa#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Activo#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Marca#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Modelo#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Serie#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Codigo_CentroF#</td>')>
		<cfset write_to_buffer('<td x:str>#data.CentroF#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Cod_Docum#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Documento#</td>')>
		<cfset write_to_buffer('<td x:str>#data.CodCCustodia#</td>')>
		<cfset write_to_buffer('<td x:str>#data.CCustodia#</td>')>
		<cfset write_to_buffer('<td x:date>#data.Fecha_ADQ#</td>')>
		<cfset write_to_buffer('<td x:num>#data.VidaUtilAdq#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoAdquisicion#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoMejoras#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoRevaluacion#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoDepCompra#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoDepMejora#</td>')>
		<cfset write_to_buffer('<td x:num>#data.MontoDepRev#</td>')>
		<cfset write_to_buffer('<td x:num>#data.ValorRescate#</td>')>
		<cfset write_to_buffer('<td x:num>#data.VidaUtil#</td>')>
		<cfset write_to_buffer('<td x:num>#data.SaldoVidaUtil#</td>')>
        <cfset write_to_buffer('</tr>')>
	</cfsilent></cfloop>
	<cfset Procesado = true>
	<cfreturn Procesado>
</cffunction>

<cffunction name="fnProcesaCategoria" access="private" output="no" hint="Procesa los Registros de la Categoria" returntype="boolean">
	<cfargument name="Ocodigo" type="numeric" required="yes">
	<cfargument name="ACcodigo" type="numeric" required="yes">
	<cfargument name="ACid" type="numeric" required="yes">
	<cfargument name="LParOficodigo" type="string" required="yes">
	<cfargument name="LParCategoria" type="string" required="yes">
	<cfargument name="LParDesCategoria" type="string" required="yes">
	<cfargument name="LParClase" type="string" required="yes">
	<cfargument name="LParDesClase" type="string" required="yes">
	<cfset LvarTiempoInicioSQL = now()>
	<cfif GVarReporteResumido>
		<cfset fnEjecutaResumido(session.Ecodigo, form.Periodo, form.Mes, Arguments.Ocodigo, Arguments.ACcodigo, Arguments.ACid, session.dsn, LvarAid)>
		<cfset LvarCantidadActivos = data.CantidadActivos>
	<cfelse>
		<cfset fnEjecutaDetallado(session.Ecodigo, form.Periodo, form.Mes, Arguments.Ocodigo, Arguments.ACcodigo, Arguments.ACid, session.dsn, LvarAid, LvarFechaFinMes)>
		<cfset LvarCantidadActivos = data.recordcount>
	</cfif>
	<cfset LvarTiempoFinSQL = now()>
	<cfif LvarBanderaPrimerVez>
		<cfset LvarBanderaPrimerVez = false>
		<cfset fnGeneraColumnas()>
	</cfif>
	<cfif GVarReporteResumido>
		<cfset FueProcesado = fnGrabaResumido(Arguments.LParOficodigo, Arguments.LParCategoria, Arguments.LParDesCategoria, Arguments.LParClase, Arguments.LParDesClase)>
	<cfelse>
		<cfset FueProcesado = fnGrabaDetallado(Arguments.LParOficodigo, Arguments.LParCategoria, Arguments.LParDesCategoria, Arguments.LParClase, Arguments.LParDesClase)>
	</cfif>
	<cfreturn FueProcesado>
</cffunction>

<cffunction name="fnPintaSalida" access="private" output="yes" hint="Muestra los datos a procesar">
	<tr>
	<cfoutput>
		<td>#rsCategoria.Oficodigo#</td>
	    <td>&nbsp;&nbsp;</td>
		<td>#rsCategoria.Categoria#</td>
	    <td>&nbsp;&nbsp;</td>
		<td>#rsCategoria.Clase#</td>
	    <td>&nbsp;&nbsp;</td>
		<td align="right">#numberformat(LvarCantidadActivos, ",9")#</td>
	    <td>&nbsp;&nbsp;</td>
		<td>#TimeFormat(LvarTiempoInicioSQL, "hh:mm:ss.L")#</td>
	    <td>&nbsp;&nbsp;</td>
		<td>#TimeFormat(LvarTiempoFinSQL, "hh:mm:ss.L")#</td>
	    <td>&nbsp;&nbsp;</td>
		<td>#TimeFormat(now(), "hh:mm:ss.L")#</td>
    </cfoutput>
	<cfflush>
	</tr>
</cffunction>
