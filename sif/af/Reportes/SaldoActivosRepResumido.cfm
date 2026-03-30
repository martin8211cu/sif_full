<!--- Inicio de validación de parámetros necesarios en el Reporte --->
<cfif isdefined("url.Periodo") and not isdefined("form.Periodo")>
	<cfset form.Periodo = url.Periodo>
</cfif>

<cfif isdefined("url.Mes") and not isdefined("form.Mes")>
	<cfset form.Mes = url.Mes>
</cfif>	

<cfif isdefined("url.AID") and not isdefined("form.AID")>
	<cfset form.AID = url.AID>
</cfif>

<cfif isdefined("url.CategoriaIni") and not isdefined("form.CategoriaIni")>
	<cfset form.CategoriaIni = url.CategoriaIni>
</cfif>

<cfif isdefined("url.CategoriaFin") and not isdefined("form.CategoriaFin")>
	<cfset form.CategoriaFin = url.CategoriaFin>
</cfif>

<cfif isdefined("url.CLASEIni") and not isdefined("form.CLASEIni")>
	<cfset form.CLASEIni = url.CLASEIni>
</cfif>

<cfif isdefined("url.CLASEFin") and not isdefined("form.CLASEFin")>
	<cfset form.CLASEFin = url.CLASEFin>
</cfif>

<cfif isdefined("url.OFICINAIni") and not isdefined("form.OFICINAIni")>
	<cfset form.OFICINAIni = url.OFICINAIni>
</cfif>

<cfif isdefined("url.OFICINAFin") and not isdefined("form.OFICINAFin")>
	<cfset form.OFICINAFin = url.OFICINAFin>
</cfif>

<cfquery name="rsMes" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as m
	from Idiomas a
		inner join VSidioma b
		on b.Iid = a.Iid
		and b.VSgrupo = 1
		and VSvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mes#" >
		
	where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
	order by <cf_dbfunction name="to_number" args="b.VSvalor">
</cfquery>

<!--- Inicio del Query de Consultas para pintar los datos del Reporte --->
<cfquery name="rsReporte" datasource="#session.dsn#" maxrows="5001">
	select 	
   	        dd.Deptocodigo,
    	    min(dd.Ddescripcion) as Ddescripcion,
    		Oficodigo, 
			min(Odescripcion) as Odescripcion,
			e.ACcodigodesc as CODCategoria,
			min(e.ACdescripcion) as Categoria,
			f.ACcodigodesc as CODClase,
			min(f.ACdescripcion) as Clase,
			sum(a.AFSvaladq) as MontoAdquisicion,
			sum(a.AFSvalmej) as MontoMejoras,
			sum(a.AFSvalrev) as MontoReevaluacion,
			sum(a.AFSdepacumadq) as MontoDepCompra,
			sum(a.AFSdepacummej) as MontoDepMejora,
			sum(a.AFSdepacumrev) as MontoDepRevaluacion,
			sum(b.Avalrescate) as ValorRescate
	from AFSaldos a
		inner join Activos b
		on b.Aid = a.Aid
		
		inner join CFuncional c
            inner join Oficinas d
            on d.Ecodigo=c.Ecodigo
            and d.Ocodigo=c.Ocodigo
            
            inner join Departamentos dd
            on dd.Ecodigo=c.Ecodigo
            and dd.Dcodigo=c.Dcodigo
		on a.CFid=c.CFid

		inner join ACategoria e
	  	on e.Ecodigo = a.Ecodigo
	 	and e.ACcodigo = a.ACcodigo

		inner join AClasificacion f
		on  f.Ecodigo = a.Ecodigo
		and f.ACid = a.ACid
		and f.ACcodigo = a.ACcodigo
	where  a.Ecodigo = #session.Ecodigo#
		and a.AFSperiodo = #form.Periodo# 
		and a.AFSmes = #form.Mes#
		<cfif isdefined("form.AID") and Len(Trim(form.AID)) gt 0>
			and a.Aid = #form.Aid#
		</cfif>
		<cfif isdefined("form.CategoriaIni") and Len(Trim(form.CategoriaIni)) gt 0>
			and  a.ACcodigo	>=  #form.CategoriaIni#
		</cfif>
		<cfif isdefined("form.CategoriaFin") and Len(Trim(form.CategoriaFin)) gt 0>
			and  a.ACcodigo	<=  #form.CategoriaFin#
		</cfif>	
		<cfif isdefined("form.CLASEIni") and Len(Trim(form.CLASEIni)) gt 0>
			and  a.ACid	>=  #form.CLASEIni#
		</cfif>
		<cfif isdefined("form.CLASEFin") and Len(Trim(form.CLASEFin)) gt 0>
			and  a.ACid	<=  #form.CLASEFin#
		</cfif>	
		<cfif isdefined("form.OFICINAIni") and Len(Trim(form.OFICINAIni)) gt 0>
			and  d.Oficodigo	>= '#rtrim(form.OFICINAIni)#'
		</cfif>
		<cfif isdefined("form.OFICINAFin") and Len(Trim(form.OFICINAFin)) gt 0>
			and  d.Oficodigo	<= '#rtrim(form.OFICINAFin)#'
		</cfif>
        
        <cfif isdefined("form.DepartamentoDes") and Len(Trim(form.DepartamentoDes)) gt 0>
			and  dd.Deptocodigo	>= '#rtrim(form.DepartamentoDes)#'
		</cfif>
		<cfif isdefined("form.DepartamentoHas") and Len(Trim(form.DepartamentoHas)) gt 0>
			and  dd.Deptocodigo	<= '#rtrim(form.DepartamentoHas)#'
		</cfif>
	group by dd.Deptocodigo, d.Oficodigo, e.ACcodigodesc, f.ACcodigodesc
	order by dd.Deptocodigo, d.Oficodigo, e.ACcodigodesc, f.ACcodigodesc
</cfquery>

<cfif rsReporte.recordcount gt 5000>
	<cfset request.Error.backs = 1 >
	<cf_errorCode	code = "50113"
					msg  = "La cantidad(@errorDat_1@) de categorías / clase a desplegar sobrepasa los 5000 registros. Reduzca los rangos en los filtros ó exporte a archivo."
					errorDat_1="#rsReporte.recordcount#"
	>
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
		title="Impresion de Saldos de Activos" 
		filename="SaldosActivos.xls"
		irA="SaldoActivos.cfm"
		download="no"
		preview="no">

<cfflush interval="64">
<!--- Se Pinta el Encabezado del Reporte cuando es invocado --->
<cfsavecontent variable="encabezado">
	<cfoutput>
		<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
		<tr><td align="center" colspan="8"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
		<tr><td align="center" colspan="8"><font size="2"><strong>Saldo de los Activos</strong></font></td></tr>
		<tr><td align="center" colspan="8"><font size="2"><strong>Resumido por Categor&iacute;a / Clase</strong></font></td></tr>
		<tr><td align="center" colspan="8"><font size="2"><strong>Mes/Per&iacute;odo:&nbsp;</strong>#trim(rsMes.m)#/#form.periodo#</font></td></tr>		
		<tr><td align="center" colspan="8"><hr></td></tr>
		<tr>
			<td align="left" bgcolor="##CCCCCC"><strong>Clase </strong></td>
			<td align="right"  bgcolor="##CCCCCC"><strong>Monto<br>Adquisici&oacute;n </strong></td>
			<td align="right" bgcolor="##CCCCCC"><strong>Monto<br>Mejoras </strong></td>
			<td align="right" bgcolor="##CCCCCC"><strong>Monto<br>Reevaluac. </strong></td>
			<td align="right" bgcolor="##CCCCCC"><strong>Monto<br>Deprec.<br>Compra </strong></td>
			<td align="right" bgcolor="##CCCCCC"><strong>Monto<br>Deprec.<br>Mejoras </strong></td>
			<td align="right" bgcolor="##CCCCCC"><strong>Monto<br>Deprec.<br>Revaluac. </strong></td>
			<td align="right" bgcolor="##CCCCCC"><strong>Monto<br>Valor<br>Rescate </strong></td>
		</tr>
		<tr><td align="center" colspan="8"><hr></td></tr>
	</cfoutput>
</cfsavecontent>

<cfset MaxLineasReporte = 51>
<cfset LBvar_pintarEnc = false>

<cfif rsReporte.recordcount gt 0>
	<cfset LSvar_depto = "">
	<cfset LSvar_oficina = "">
	<cfset LSvar_categoria = "">
	<cfset contador = 0>
	<cfoutput>#encabezado#</cfoutput>
	
	<cfloop query="rsReporte">
		<cfif (contador gt MaxLineasReporte)>
			<cfset contador = 0>
			<cfset LBvar_pintarEnc = true>
		</cfif>
		
		<cfif LBvar_pintarEnc>
			<cfif rsReporte.CurrentRow NEQ 1>
				</table>
				<br style="PAGE-BREAK-AFTER: always">
			</cfif>
			<cfoutput>#encabezado#</cfoutput>
			<cfset contador = contador + 7>
			<cfset LBvar_pintarEnc = false>
		</cfif>

		<cfif trim(rsReporte.DeptoCodigo) neq trim(LSvar_depto) and len(trim(LSvar_depto)) gt 0>
			<cfset printTotales(rsReporte, LSvar_depto, LSvar_oficina, LSvar_categoria)>
			<cfset printTotales(rsReporte, LSvar_depto, LSvar_oficina)>
			<cfset printTotales(rsReporte, LSvar_depto)>
		<cfelseif trim(rsReporte.Oficodigo) neq trim(LSvar_oficina) and len(trim(LSvar_oficina)) gt 0>
			<cfset printTotales(rsReporte, LSvar_depto, LSvar_oficina, LSvar_categoria)>
            <cfset printTotales(rsReporte, LSvar_depto, LSvar_oficina)>
        <cfelseif trim(rsReporte.CODCategoria) neq trim(LSvar_categoria) and len(trim(LSvar_categoria)) gt 0>
			<cfset printTotales(rsReporte,LSvar_depto, LSvar_oficina,LSvar_categoria)>
        </cfif>
		<cfif trim(rsReporte.DeptoCodigo) neq trim(LSvar_depto) or LBvar_pintarEnc>
			<cfif trim(LSvar_depto) GT 0>
	            <tr><td nowrap colspan="8" align="left">&nbsp;</td></tr>
				<cfset contador = contador + 1 >
            </cfif>
			<cfset LSvar_depto = trim(rsReporte.DeptoCodigo)>
            <cfset LSvar_oficina = "">
			<cfoutput>
			<tr><td nowrap colspan="8" align="left" bgcolor="##CCCCCC"><strong>Departamento:&nbsp;#trim(rsReporte.DeptoCodigo)# - #trim(rsReporte.Ddescripcion)#</strong></td></tr>	
			</cfoutput>
			<cfset contador = contador + 1 >
		</cfif>
		<cfif trim(rsReporte.Oficodigo) neq trim(LSvar_oficina) or LBvar_pintarEnc>
			<cfset LSvar_oficina = trim(rsReporte.Oficodigo)>
            <cfset LSvar_categoria = "">
			<cfoutput>
			<tr><td nowrap colspan="8" align="left" bgcolor="##CCCCCC"><strong>Oficina:&nbsp;#trim(rsReporte.Oficodigo)# - #trim(rsReporte.Odescripcion)#</strong></td></tr>	
			</cfoutput>
			<cfset contador = contador + 1 >
		</cfif>
		<cfif trim(rsReporte.CODCategoria) neq trim(LSvar_categoria) or LBvar_pintarEnc>
			<cfset LSvar_categoria = trim(rsReporte.CODCategoria)>
			<cfoutput>
			<tr><td nowrap colspan="8" align="left" bgcolor="##CCCCCC"><strong>Categor&iacute;a:&nbsp;#trim(rsReporte.CODCategoria)# - #trim(rsReporte.Categoria)#</strong></td> </tr>
			</cfoutput>
			<cfset contador = contador + 1 >
		</cfif>
		<cfoutput>
		<tr>
			<td align="left" nowrap ><font size="1">&nbsp;#trim(rsReporte.CODClase)#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(rsReporte.MontoAdquisicion,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(rsReporte.MontoMejoras,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(rsReporte.MontoReevaluacion,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(rsReporte.MontoDepCompra,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(rsReporte.MontoDepMejora,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(rsReporte.MontoDepRevaluacion,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(rsReporte.ValorRescate,',____.__')#</font></td>
		</tr>
		</cfoutput>
		<cfset contador = contador + 1 >
	</cfloop>
	<cfset printTotales(rsReporte,LSvar_depto, LSvar_oficina,LSvar_categoria)>
	<cfset printTotales(rsReporte,LSvar_depto, LSvar_oficina)>
	<cfset printTotales(rsReporte,LSvar_depto)>
	<cfset printTotales(rsReporte)>
	<cfset contador = contador + 3 >
<cfelse>
	<tr><td align="center" colspan="8">&nbsp;</td></tr>
	<tr><td align="center" colspan="8"><strong> --- La consulta no gener&oacute; ning&uacute;n resultado. --- </strong></td></tr>
</cfif>

<tr><td align="center" colspan="8">&nbsp;</td></tr>
<tr><td colspan="8" nowrap align="center"><strong> --- Fin de la Consulta --- </strong></td></tr>
</table>

<cffunction name="printTotales" access="private" returntype="string">
	<cfargument name="rsReporte" required="true">
	<cfargument name="departamento" default="" required="false">
	<cfargument name="oficina" default="" required="false">
	<cfargument name="categoria" default="" required="false">
	<!--- Se requiere que siempre venga definido la oficina y la categoria o solo la oficina o ninguno, pero NO la categoria sin oficina. --->
	<cfif (len(trim(arguments.categoria)) and len(trim(arguments.oficina)) eq 0)>
		<cfreturn "<tr><td colspan='8'><font color='##FF0000'>Total Inconsistente</font></td></tr>">
	</cfif>
	<cfquery name="rs"	 dbtype="query">
		select sum(MontoAdquisicion) as MontoAdquisicion,
			sum(MontoMejoras) as MontoMejoras,
			sum(MontoReevaluacion) as MontoReevaluacion,
			sum(MontoDepCompra) as MontoDepCompra,
			sum(MontoDepMejora)as MontoDepMejora,
			sum(MontoDepRevaluacion) as MontoDepRevaluacion,
			sum(ValorRescate) as ValorRescate
		from rsReporte
		<cfif len(trim(arguments.departamento))>
			where Deptocodigo = '#arguments.departamento#'
		</cfif>
		<cfif len(trim(arguments.oficina)) and len(trim(arguments.departamento))>
			and Oficodigo =  '#arguments.oficina#'
		</cfif>
		<cfif len(trim(arguments.oficina)) and len(trim(arguments.categoria)) and len(trim(arguments.departamento))>
			and CODCategoria = '#arguments.categoria#'
		</cfif>
	</cfquery>
	<cfoutput>
		<tr>
			<td align="left" nowrap bgcolor="##CCCCCC"><font size="1">&nbsp;&nbsp;&nbsp;
            	<strong>Total 
				<cfif len(trim(arguments.categoria))>Categoria: #arguments.categoria#
				<cfelseif len(trim(arguments.oficina))>Oficina: #arguments.oficina#
				<cfelseif len(trim(arguments.departamento))>Departamento: #arguments.Departamento#
                <cfelse> General
                </cfif>
                </strong></font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoAdquisicion,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoMejoras,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoReevaluacion,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoDepCompra,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoDepMejora,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoDepRevaluacion,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.ValorRescate,',____.__')#</font></td>
		</tr>
	</cfoutput>
    <cfset contador = contador + 1 >
	<cfreturn>
</cffunction>


