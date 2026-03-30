<cfif isdefined('url.temp') and len(trim(url.temp)) GT 0>
	<cfif FileExists(#url.temp#)>
		<cfset _LvarFileName = '#session.Usulogin##dateformat(now(), "hhmmss")#.xls'>
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
<!--- Exportación a Archivo Excel --->
<cfsetting requesttimeout="14400">
<cfflush interval="32">
<cf_templatecss>
<cf_templateheader>

	<cfset buffer = CreateObject("java", "java.lang.StringBuffer").init( JavaCast("int", 262144 ))>
	<cfset temporaryFileName = GetTempFile( GetTempDirectory(), 'tmp_SaldoAct')>
	<cfset FinalFileName =  GetTempDirectory() & 'SaldoActivos_#session.Usulogin#_#dateformat(now(), "hhmmss")#.xls'>
	<cfset ShortFileName =  mid(FinalFileName, find('SaldoActivos',FinalfileName),35)>
	<cffile action="write" file="#temporaryFileName#" output="" addnewline="no">
	<p>Procesando la generación del archivo...
	<p>Se desplegarán las clases que se procesan y se graban en el archivo.</p>
	<p>Hacer click en el link al final de la página para descargar el archivo <strong> <cfoutput>#ShortFileName#</cfoutput> </strong></p>
	<br />
	<table cellspacing="0" cellpadding="1" border="0">
	<tr>
		<td><strong>Oficina</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td><strong>Categoria</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td><strong>Clase</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td align="right"><strong>Hora<br />Inicio</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td align="right"><strong>Hora<br />Control</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td align="right"><strong>Hora<br />Final</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td align="right"><strong>Cantidad<br />Activos</strong></td>
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
	<cfif Arguments.flush Or (buffer.length() GTE 180000)>
		<cffile action="append" file="#temporaryFileName#" output="#buffer.toString()#" addnewline="no">
		<cfset buffer.setLength(0)>
	</cfif>
</cffunction>

<cffunction name="fnGeneraSalida" access="private" output="yes" returntype="numeric">
	<cfset newline = Chr(13) & Chr(10)>
	<!--- Determinar la fecha de fin de mes ( ultimo dia del mes ) para buscar los responsables de Activo Fijo --->
	<cfset LvarFechaFinMes = createdate(form.Periodo,form.mes, 01)>
	<cfset LvarFechaFinMes = dateadd("m", 1, LvarFechaFinMes)>
	<cfset LvarFechaFinMes = dateadd("d", -1, LvarFechaFinMes)>
	<cfset fnObtieneCategorias()>
	<cfloop query="rsCategoria">
		<cfset LvarOcodigo = rsCategoria.Ocodigo>
		<cfset LvarACcodigo = rsCategoria.ACcodigo>
		<cfset LvarACid = rsCategoria.ACid>
		<cfset fnProcesaCategoria(LvarOcodigo, LvarACcodigo, LvarACid)>
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
		 	Oficodigo as Codigo_Oficina, 
				min(Odescripcion) as Oficina,
				e.ACcodigodesc as CODCategoria,
				min(e.ACdescripcion) as Categoria,
				f.ACcodigodesc as CODClase,
				min(f.ACdescripcion) as Clase,
                dd.Deptocodigo as Cod_Depto,
                min(dd.Ddescripcion) as Departamento,
				sum(a.AFSvaladq) as MontoAdquisicion,
				sum(a.AFSvalmej) as MontoMejoras,
				sum(a.AFSvalrev) as MontoRevaluacion,
				sum(a.AFSdepacumadq) as MontoDepCompra,
				sum(a.AFSdepacummej) as MontoDepMejora,
				sum(a.AFSdepacumrev) as MontoDepRev,
				sum(b.Avalrescate) as MontoValorRescate
		from AFSaldos a
			inner join Activos b
			on b.Aid = a.Aid
			
			inner join CFuncional c
                inner join Oficinas d
                on d.Ecodigo  = c.Ecodigo
                and d.Ocodigo = c.Ocodigo
                
                inner join Departamentos dd
                on dd.Ecodigo=c.Ecodigo
                and dd.Dcodigo=c.Dcodigo
			on c.CFid = a.CFid

			inner join AClasificacion f
						inner join ACategoria e
						on  e.Ecodigo  = f.Ecodigo
						and e.ACcodigo = f.ACcodigo
			on  f.Ecodigo  = a.Ecodigo
			and f.ACid     = a.ACid
			and f.ACcodigo = a.ACcodigo							

		where  a.Ecodigo = #Arguments.Empresa#
		  and a.AFSperiodo = #Arguments.Periodo# 
		  and a.AFSmes = #Arguments.Mes#
		  and c.Ocodigo  = #ArgOcodigo#
		  and a.ACcodigo = #ArgACcodigo#
		  and a.ACid     = #ArgACid#
		<cfif isdefined("Arguments.AID") and Len(Trim(Arguments.Aid)) gt 0 and Arguments.Aid GT -1>
			and a.Aid = #Arguments.Aid#
		</cfif>
        <cfif isdefined("form.DepartamentoDes") and Len(Trim(form.DepartamentoDes)) gt 0>
			and  dd.Deptocodigo	>= '#form.DepartamentoDes#'
		</cfif>
		<cfif isdefined("form.DepartamentoHas") and Len(Trim(form.DepartamentoHas)) gt 0>
			and  dd.Deptocodigo	<= '#form.DepartamentoHas#'
		</cfif>
		group by Oficodigo, e.ACcodigodesc, f.ACcodigodesc, dd.Deptocodigo
		order by Oficodigo, e.ACcodigodesc, f.ACcodigodesc, dd.Deptocodigo
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

	<cf_dbfunction name="dateadd" args="30, b.Afechaaltaadq, DD" returnvariable="LvarFecha">
	<cfquery name="data" datasource="#session.dsn#">
		select 
			d.Oficodigo as Codigo_Oficina, 
			d.Odescripcion as Oficina,
			e.ACcodigodesc as CODCategoria,
			e.ACdescripcion as Categoria,
			f.ACcodigodesc as CODClase,
			f.ACdescripcion as Clase,
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
            (case a.AFSmetododep 
        	when 1 then
            	'L&iacute;nea Recta'
            when 2 then
            	'Suma de D&iacute;gitos'
            when 3 then
            	'Por Actividad'
            else
            	'N/A'
         	end) as MetodoDep,
			b.Afechaaltaadq as Fecha_ADQ,
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
			a.AFSvaladq as MontoAdquisicion,
			a.AFSvalmej as MontoMejoras,
			a.AFSvalrev as MontoRevaluacion,
			a.AFSdepacumadq as MontoDepCompra,
			a.AFSdepacummej as MontoDepMejora,
			a.AFSdepacumrev as MontoDepRev,
			b.Avalrescate as ValorRescate,
			a.AFSvutiladq as VidaUtil,
            (a.AFSvutiladq - a.AFSsaldovutiladq) as MesesDepreciados,
			a.AFSsaldovutiladq as SaldoVidaUtil
		from AFSaldos a 
				inner join Activos b 
					inner join AFMarcas afm 
					on afm.AFMid = b.AFMid 

					inner join AFMModelos afmm 
					on afmm.AFMMid = b.AFMMid 

				on b.Aid = a.Aid 
			
				inner join CFuncional c 
					inner join Oficinas d 
					on  d.Ecodigo  = c.Ecodigo 
					and d.Ocodigo  = c.Ocodigo 

                    inner join Departamentos dd
                    on dd.Ecodigo=c.Ecodigo
                    and dd.Dcodigo=c.Dcodigo
				on c.CFid = a.CFid 

				inner join AClasificacion f 
					inner join ACategoria e 
					on e.Ecodigo = f.Ecodigo
					and e.ACcodigo = f.ACcodigo 
				on f.Ecodigo = a.Ecodigo 
				and f.ACid = a.ACid 
				and f.ACcodigo = a.ACcodigo 
			
				inner join AFResponsables resp 
					inner join CRCentroCustodia cc 
					on cc.CRCCid     = resp.CRCCid 

					inner join CRTipoDocumento td 
					on td.CRTDid = resp.CRTDid 
				on  resp.Aid     = a.Aid 
				and resp.Ecodigo = a.Ecodigo 

		where a.Ecodigo = #Arguments.Empresa#
		  and a.AFSperiodo = #Arguments.Periodo# 
		  and a.AFSmes = #Arguments.Mes#
		  and a.ACcodigo = #ArgACcodigo#
		  and a.ACid     = #ArgACid#
		  and c.Ocodigo  = #ArgOcodigo#
		<cfif isdefined("Arguments.AID") and Len(Trim(Arguments.Aid)) gt 0 and Arguments.Aid GT -1>
			and a.Aid = #Arguments.Aid#
		</cfif>
		  and   #ArgFechaFinMes# between resp.AFRfini and resp.AFRffin 
		  and 
			(	round(a.AFSvaladq,0.00) > 0 
			 or round(a.AFSvalmej,0.00) > 0 
			 or round(a.AFSvalrev,0.00) > 0 
			 or round(a.AFSdepacumadq,0.00) > 0 
			 or round(a.AFSdepacummej,0.00) > 0 
			 or round(a.AFSdepacumrev,0.00) > 0 
			) 
        <cfif isdefined("form.DepartamentoDes") and Len(Trim(form.DepartamentoDes)) gt 0>
			and  dd.Deptocodigo	>= '#rtrim(form.DepartamentoDes)#'
		</cfif>
		<cfif isdefined("form.DepartamentoHas") and Len(Trim(form.DepartamentoHas)) gt 0>
			and  dd.Deptocodigo	<= '#rtrim(form.DepartamentoHas)#'
		</cfif>
		order by Oficodigo, e.ACcodigodesc, f.ACcodigodesc, dd.Deptocodigo, b.Aplaca
	</cfquery>
</cffunction>

<cffunction name="fnGeneraColumnas" access="private" output="no" hint="Genera la información de las columnas">
	<cfset LvarCols = data.getColumnNames()>
	<cfset LvarFileType[1] = "S">
	
	<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
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
	</cfloop>
	<cfset write_to_buffer('<html xmlns:o="urn:schemas-microsoft-com:office:office" ' & 
			'xmlns:x="urn:schemas-microsoft-com:office:excel" ' &
			'xmlns="http://www.w3.org/TR/REC-html40">' & newline)>
	<cfset write_to_buffer('<table> #newline#')>
	<cfset write_to_buffer('<tr>')>
	<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
		<cfset write_to_buffer('<td>#LvarCols[i]#</td>')>
	</cfloop>
	<cfset write_to_buffer('</tr> #newline#')>
</cffunction>

<cffunction name="fnObtieneCategorias" access="private" output="no" hint="Genera las Categorias para Exportar">

	<cfset _LvarOficinas = "">
	<cfif (isdefined("form.OFICINAIni") and len(trim(form.OFICINAIni))) or (isdefined("form.OFICINAFin") and len(trim(form.OFICINAFin)))>
		<cfquery name="_rsRepSaldosAct" datasource="#session.dsn#">
			select Ocodigo from Oficinas o 
			where Ecodigo = #session.Ecodigo#
			<cfif isdefined("form.OFICINAIni") and Len(Trim(form.OFICINAIni)) gt 0>
				and  o.Oficodigo	>= '#rtrim(form.OFICINAIni)#'
			</cfif>
			<cfif isdefined("form.OFICINAFin") and Len(Trim(form.OFICINAFin)) gt 0>
				and  o.Oficodigo	<= '#rtrim(form.OFICINAFin)#'
			</cfif>
		</cfquery>
		<cfset _LvarOficinas = " and a.Ocodigo in (-1">
		<cfloop query="_rsRepSaldosAct">
			<cfset _LvarOficinas = _LvarOficinas & "," & _rsRepSaldosAct.Ocodigo>
		</cfloop>
		<cfset _LvarOficinas = _LvarOficinas & ")">
	</cfif>

	<cfset _LvarCategorias = "">
	<cfif (isdefined("form.CATEGORIA1") and len(trim(form.CATEGORIA1))) or (isdefined("form.CATEGORIA2") and len(trim(form.CATEGORIA2)))>
		<cfquery name="_rsRepSaldosAct" datasource="#session.dsn#">
			select ACcodigo 
			from ACategoria o 
			where Ecodigo = #session.Ecodigo#
			<cfif isdefined("form.CATEGORIA1") and Len(Trim(form.CATEGORIA1)) gt 0>
				and  o.ACcodigodesc	>= '#rtrim(form.CATEGORIA1)#'
			</cfif>
			<cfif isdefined("form.CATEGORIA2") and Len(Trim(form.CATEGORIA2)) gt 0>
				and  o.ACcodigodesc	<= '#rtrim(form.CATEGORIA2)#'
			</cfif>
		</cfquery>
		<cfif _rsRepSaldosAct.Recordcount GT 70>
			<cfif isdefined("form.CATEGORIA1") and Len(Trim(form.CATEGORIA1)) gt 0>
				<cfset _LvarCategorias = _LvarCategorias & "and e.ACcodigodesc	>= '#rtrim(form.CATEGORIA1)#'">
			</cfif>
			<cfif isdefined("form.CATEGORIA2") and Len(Trim(form.CATEGORIA2)) gt 0>
				<cfset _LvarCategorias = _LvarCategorias & "and e.ACcodigodesc	<= '#rtrim(form.CATEGORIA2)#'">
			</cfif>
		<cfelse>
			<cfset _LvarCategorias = " and a.ACcodigo in (-1">
			<cfloop query="_rsRepSaldosAct">
				<cfset _LvarCategorias = _LvarCategorias & "," & _rsRepSaldosAct.ACcodigo>
			</cfloop>
			<cfset _LvarCategorias = _LvarCategorias & ")">
		</cfif>
	</cfif>

	<cfquery name="rsCategoria" datasource="#session.dsn#">
		 select
        	o.Oficodigo, e.ACcodigodesc as Categoria, f.ACcodigodesc as Clase, 
        	count(1) as CantidadActivos, 
            min(cf.Ocodigo) as Ocodigo, min(a.ACcodigo) as ACcodigo, min(a.ACid) as ACid
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
		#_LvarOficinas#
		<cfif isdefined("_LvarCategorias") and len(trim(_LvarCategorias)) GT 0>
			#preservesinglequotes(_LvarCategorias)#
		</cfif>
		<cfif isdefined("form.AID") and Len(Trim(form.AID)) gt 0>
			and a.Aid = #form.Aid#
		</cfif>
		<cfif isdefined("form.CLASE1") and Len(Trim(form.CLASE1)) gt 0>
			and  f.ACcodigodesc	>=  '#form.CLASE1#'
		</cfif>
		<cfif isdefined("form.CLASE2") and Len(Trim(form.CLASE2)) gt 0>
			and  f.ACcodigodesc	<=  '#form.CLASE2#'
		</cfif>	
        <cfif isdefined("form.DepartamentoDes") and Len(Trim(form.DepartamentoDes)) gt 0>
			and  dd.Deptocodigo	>= '#form.DepartamentoDes#'
		</cfif>
		<cfif isdefined("form.DepartamentoHas") and Len(Trim(form.DepartamentoHas)) gt 0>
			and  dd.Deptocodigo	<= '#form.DepartamentoHas#'
		</cfif>
        group by o.Oficodigo, e.ACcodigodesc, f.ACcodigodesc
		order by o.Oficodigo, e.ACcodigodesc, f.ACcodigodesc
	</cfquery>
	
	<cfset LvarBanderaPrimerVez = true>
	<cfif isdefined('form.Aid') and len(trim(form.Aid)) GT 0>
		<cfset LvarAid = form.Aid>
	<cfelse>
		<cfset LvarAid = -1>
	</cfif> 
</cffunction>	

<cffunction name="fnGrabaResumido" output="no" access="private" hint="Genera la salida de los registros detallados">
	<cfargument name="Categoria" type="numeric" required="yes">
    <cfloop query="data">
        <cfset write_to_buffer('<tr>')>
		<cfset write_to_buffer('<td x:str>#data.Codigo_Oficina#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Oficina#</td>')>
		<cfset write_to_buffer('<td x:str>#data.CODCategoria#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Categoria#</td>')>
		<cfset write_to_buffer('<td x:str>#data.CODClase#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Clase#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Cod_Depto#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Departamento#</td>')>
		<cfset write_to_buffer('<td x:num>#MontoAdquisicion#</td>')>
		<cfset write_to_buffer('<td x:num>#MontoMejoras#</td>')>
		<cfset write_to_buffer('<td x:num>#MontoRevaluacion#</td>')>
		<cfset write_to_buffer('<td x:num>#MontoDepCompra#</td>')>
		<cfset write_to_buffer('<td x:num>#MontoDepMejora#</td>')>
		<cfset write_to_buffer('<td x:num>#MontoDepRev#</td>')>
		<cfset write_to_buffer('<td x:num>#MontoValorRescate#</td>')>
        <cfset write_to_buffer('</tr>')>
	</cfloop>
	<cfset Procesado = true>
	<cfreturn Procesado>
</cffunction>

<cffunction name="fnGrabaDetallado" output="no" access="private" hint="Genera la salida de los registros detallados">
	<cfargument name="Categoria" type="numeric" required="yes">
    <cfloop query="data">
        <cfset write_to_buffer('<tr>')>
		<cfset write_to_buffer('<td x:str>#data.Codigo_Oficina#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Oficina#</td>')>
		<cfset write_to_buffer('<td x:str>#data.CODCategoria#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Categoria#</td>')>
		<cfset write_to_buffer('<td x:str>#data.CODClase#</td>')>
		<cfset write_to_buffer('<td x:str>#data.Clase#</td>')>
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
        <cfset write_to_buffer('<td x:str>#data.MetodoDep#</td>')>
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
		<cfset write_to_buffer('<td x:num>#data.MesesDepreciados#</td>')>
		<cfset write_to_buffer('<td x:num>#data.SaldoVidaUtil#</td>')>
        <cfset write_to_buffer('</tr>')>
	</cfloop>
	<cfset Procesado = true>
	<cfreturn Procesado>
</cffunction>
<cffunction name="fnProcesaCategoria" access="private" output="no" hint="Procesa los Registros de la Categoria" returntype="boolean">
	<cfargument name="Ocodigo" type="numeric" required="yes">
	<cfargument name="ACcodigo" type="numeric" required="yes">
	<cfargument name="ACid" type="numeric" required="yes">
	<cfset LvarTiempoInicioSQL = now()>
	<cfif isdefined("form.resumido")>
        <cfset fnEjecutaResumido(session.Ecodigo, form.Periodo, form.Mes, Arguments.Ocodigo, Arguments.ACcodigo, Arguments.ACid, session.dsn, LvarAid)>
    <cfelse>
        <cfset fnEjecutaDetallado(session.Ecodigo, form.Periodo, form.Mes, Arguments.Ocodigo, Arguments.ACcodigo, Arguments.ACid, session.dsn, LvarAid, LvarFechaFinMes)>
    </cfif>
	<cfset LvarTiempoFinSQL = now()>
    <cfif LvarBanderaPrimerVez>
        <cfset LvarBanderaPrimerVez = false>
        <cfset fnGeneraColumnas()>
    </cfif>
	<cfif isdefined("form.resumido")>
		<cfset FueProcesado = fnGrabaResumido(LvarAid)>
    <cfelse>
		<cfset FueProcesado = fnGrabaDetallado(LvarAid)>
    </cfif>
    <cfreturn FueProcesado>
	<!---
    <cfloop query="data">
        <cfset write_to_buffer('<tr>')>
        <cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
            <cfset LvarDato = evaluate("data.#LvarCols[i]#")>
            <cfif Not IsDefined('LvarDato')>
                <cfset LvarDato = ''>
            </cfif>
            <cfif LvarFileType[i] EQ "N">
                <cfset write_to_buffer('<td x:num>#Trim(LvarDato)#</td>')>
            <cfelseif (LvarFileType[i] EQ "D" or LvarFileType[i] EQ "T") And Len(LvarDato)>
                <cfset write_to_buffer('<td x:date>#DateFormat(LvarDato,"YYYY-MM-DD")#</td>')>
            <cfelse>
                <cfset write_to_buffer('<td x:str>#Trim(LvarDato)#</td>')>
            </cfif>
        </cfloop>
        <cfset write_to_buffer('</tr> #newline#')>
    </cfloop>
	--->
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
		<td>#TimeFormat(LvarTiempoInicioSQL, "hh:mm:ss:L")#</td>
	    <td>&nbsp;&nbsp;</td>
		<td>#TimeFormat(LvarTiempoFinSQL, "hh:mm:ss:L")#</td>
	    <td>&nbsp;&nbsp;</td>
		<td>#TimeFormat(now(), "hh:mm:ss:L")#</td>
	    <td>&nbsp;&nbsp;</td>
		<td align="right">#numberformat(rsCategoria.CantidadActivos, ",9")#</td>
    </cfoutput>
	<cfflush>
	</tr>
</cffunction>
