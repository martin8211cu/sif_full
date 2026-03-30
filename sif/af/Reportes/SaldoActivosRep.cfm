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

<cf_dbfunction name="to_float" args="a.AFSvaladq" returnvariable="AFSvaladq" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="a.AFSvalmej" returnvariable="AFSvalmej" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="a.AFSvalrev" returnvariable="AFSvalrev" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="a.AFSvaladq" returnvariable="AFSvaladq" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="AFSdepacumadq" returnvariable="AFSdepacumadq" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="AFSdepacummej" returnvariable="AFSdepacummej" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="AFSdepacumrev" returnvariable="AFSdepacumrev" delimiters=';' dec="2">
<cfquery name="rsReporteCuenta" datasource="#session.dsn#">
	select 	count(1) as total
	 from AFSaldos a
	 	inner join Activos b
			on a.Aid=b.Aid
		inner join CFuncional cf
            inner join Oficinas d
            on d.Ecodigo  = cf.Ecodigo
            and d.Ocodigo = cf.Ocodigo

			inner join Departamentos dd
            on  dd.Ecodigo = cf.Ecodigo
            and dd.Dcodigo = cf.Dcodigo
        on cf.CFid = a.CFid

		inner join AClasificacion f
			inner join ACategoria e
				on  e.ACcodigo = f.ACcodigo
				and e.Ecodigo  = f.Ecodigo
		   on f.ACid     = a.ACid
		  and f.ACcodigo = a.ACcodigo
	      and f.Ecodigo  = a.Ecodigo
	where a.Ecodigo 	= #session.Ecodigo#
	  and a.AFSperiodo  = #form.Periodo# 
	  and a.AFSmes 		= #form.Mes#
	  
	  <!--- Debe tener montos para poder aparecer en el reporte --->
	  and (  
			  #AFSvaladq# > 0
			  or #AFSvalmej# > 0
			  or #AFSvalrev# > 0
			  or #AFSdepacumadq# > 0
			  or #AFSdepacummej# > 0
			  or #AFSdepacumrev# > 0
			)   
	  
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
			and  dd.Deptocodigo	>= '#form.DepartamentoDes#'
		</cfif>
		<cfif isdefined("form.DepartamentoHas") and Len(Trim(form.DepartamentoHas)) gt 0>
			and  dd.Deptocodigo	<= '#form.DepartamentoHas#'
		</cfif>

</cfquery>
<cfif rsReporteCuenta.total gte 100001 >
	<cfset request.Error.backs = 1 >
	<cf_errorCode	code = "50112" msg = "La cantidad de activos a desplegar sobrepasa los 100.000 registros. Reduzca los rangos en los filtros ó exporte a archivo.">
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
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><td align="center" colspan="17"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
		<tr><td align="center" colspan="17"><font size="2"><strong>Saldo de los Activos</strong></font></td></tr>
		<tr><td align="center" colspan="17"><font size="2"><strong>Mes/Per&iacute;odo:&nbsp;</strong>#trim(rsMes.m)#/#form.periodo#</font></td></tr>		
	</cfoutput> 
		<tr><td align="center" colspan="17"><hr></td></tr>
		<tr class="style5">
			<td align="left" bgcolor="#CCCCCC"><strong>Clase</strong></td>
			<td align="left" bgcolor="#CCCCCC"><strong>Placa</strong></td>
			<td align="left" bgcolor="#CCCCCC"><strong>Descripci&oacute;n</strong></td>
			<td align="left" bgcolor="#CCCCCC"><strong>Centro<br>Funcional</strong></td>
			<td align="left" bgcolor="#CCCCCC"><strong>Metodo<br>Depreciaci&oacute;n</strong></td>
            <td align="right" bgcolor="#CCCCCC"><strong>Vida<br>&Uacute;til<br>Adquisici&oacute;n</strong></td>
			<td align="center" bgcolor="#CCCCCC"><strong>Fecha<br>Adquisici&oacute;n</strong></td>				
			<td align="right" bgcolor="#CCCCCC"><strong>Monto<br>Adq.</strong></td>
			<td align="right" bgcolor="#CCCCCC"><strong>Monto<br>Mejoras</strong></td>
			<td align="right" bgcolor="#CCCCCC"><strong>Monto<br>Reval.</strong></td>
			<td align="right" bgcolor="#CCCCCC"><strong>Monto<br>Deprec.<br>Compra</strong></td>
			<td align="right" bgcolor="#CCCCCC"><strong>Monto<br>Deprec.<br>Mejoras</strong></td>
			<td align="right" bgcolor="#CCCCCC"><strong>Monto<br>Deprec.<br>Reval</strong></td>
			<td align="right" bgcolor="#CCCCCC"><strong>Valor<br>Rescate<br></strong></td>
			<td align="right" bgcolor="#CCCCCC"><strong>Vida<br>&Uacute;til</strong></td>
			<td align="right" bgcolor="#CCCCCC"><strong>Meses<br>Depreciados</strong></td>
            <td align="right" bgcolor="#CCCCCC"><strong>Saldo<br>Vida<br>&Uacute;til</strong></td>
		</tr>
		<tr><td align="center" colspan="17"><hr></td></tr>
</cfsavecontent>
<cf_dbfunction name="dateadd" args="30,b.Afechaaltaadq,dd" returnvariable="LvarFecha">

<cf_dbfunction name="to_float" args="a.AFSvaladq" returnvariable="AFSvaladq" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="a.AFSvalmej" returnvariable="AFSvalmej" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="a.AFSvalrev" returnvariable="AFSvalrev" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="a.AFSvaladq" returnvariable="AFSvaladq" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="AFSdepacumadq" returnvariable="AFSdepacumadq" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="AFSdepacummej" returnvariable="AFSdepacummej" delimiters=';' dec="2">
<cf_dbfunction name="to_float" args="AFSdepacumrev" returnvariable="AFSdepacumrev" delimiters=';' dec="2">
<cfquery name="rsReporte" datasource="#session.dsn#">
	select 	
    	d.Oficodigo, 
		d.Odescripcion,
		e.ACcodigodesc as CODCategoria,
		e.ACdescripcion as Categoria,
		f.ACcodigodesc as CODClase,
		f.ACdescripcion as Clase,
		b.Aplaca,
		b.Adescripcion,
		a.CFid,
		c.CFcodigo,
		c.CFdescripcion,
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
        (a.AFSvutiladq - a.AFSsaldovutiladq) as MesesDepreciados,
		a.AFSvaladq as MontoAdquisicion,
		a.AFSvalmej as MontoMejoras,
		a.AFSvalrev as MontoReevaluacion,
		a.AFSdepacumadq as MontoDepCompra,
		a.AFSdepacummej as MontoDepMejora,
		a.AFSdepacumrev as MontoDepRevaluacion,
		b.Avalrescate as ValorRescate,
		a.AFSvutiladq as VidaUtil,
		a.AFSsaldovutiladq as SaldoVidaUtil,
		(( 
			select max(ta.TAvutil) 
			from TransaccionesActivos ta 
			where ta.Aid   = b.Aid 
            and ta.TAfecha <= #LvarFecha#
			and ta.IDtrans = 1
		)) as VidaUtilAdq,
		b.Afechaaltaadq,
        dd.Deptocodigo,
        dd.Ddescripcion
	from AFSaldos a
		inner join Activos b
			on a.Aid=b.Aid
		inner join CFuncional c
                inner join Oficinas d
                     on d.Ecodigo = c.Ecodigo
                    and d.Ocodigo = c.Ocodigo
            	inner join Departamentos dd
                	on dd.Ecodigo = c.Ecodigo
                   and dd.Dcodigo = c.Dcodigo
			on c.CFid = a.CFid
		inner join AClasificacion f
				inner join ACategoria e
					on  e.ACcodigo = f.ACcodigo
					and e.Ecodigo  = f.Ecodigo
			on  f.ACid     = a.ACid
			and f.ACcodigo = a.ACcodigo
			and f.Ecodigo  = a.Ecodigo
	where a.Ecodigo    = #session.Ecodigo#
	  and a.AFSperiodo = #form.Periodo# 
	  and a.AFSmes     = #form.Mes# 
	  <!--- Debe tener montos para poder aparecer en el reporte --->
	  and (    
			  #AFSvaladq# > 0
			  or #AFSvalmej# > 0
			  or #AFSvalrev# > 0
			  or #AFSdepacumadq# > 0
			  or #AFSdepacummej# > 0
			  or #AFSdepacumrev# > 0
	  		 )		
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
			and  dd.Deptocodigo	>= '#form.DepartamentoDes#'
		</cfif>
		<cfif isdefined("form.DepartamentoHas") and Len(Trim(form.DepartamentoHas)) gt 0>
			and  dd.Deptocodigo	<= '#form.DepartamentoHas#'
		</cfif>
	order by dd.Deptocodigo, d.Oficodigo, e.ACcodigodesc, f.ACcodigodesc, b.Aplaca
</cfquery>

<cfif rsReporteCuenta.total gt 0>
	<cfset MaxLineasReporte = 45>
    <cfset contador = 0>
	<cfset corte = "">
	<cfset LSvar_depto = "">
    <cfset LSvar_oficina = "">
    <cfset LSvar_categoria = "">
	<cfset LBvar_pintarEnc = true>

	<cfoutput query="rsReporte">
		<cfset fnPintaCortes()>
		<tr class="style4">
			<cfset largoAdescripcion = len(trim(Adescripcion))>
			<td align="left" nowrap ><font size="1">&nbsp;#trim(CODClase)#</font></td>
			<td align="left" nowrap ><font size="1">&nbsp;#trim(Aplaca)#</font></td>
			<td align="left" nowrap ><font size="1">&nbsp;<cfif largoAdescripcion GT 30>#mid(trim(Adescripcion),1,30)#...<cfelse>#mid(trim(Adescripcion),1,30)#</cfif></font></td>
			<td align="left" nowrap ><font size="1">&nbsp;#trim(CFcodigo)#</font></td>					
			<td align="left" nowrap ><font size="1">&nbsp;#trim(MetodoDep)#</font></td>					
            <td align="right" nowrap ><font size="1">&nbsp;#trim(VidaUtilAdq)#</font></td>
			<td align="right" nowrap ><font size="1">&nbsp;#dateformat(Afechaaltaadq,"dd/mm/yyyy")#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(MontoAdquisicion,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(MontoMejoras,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(MontoReevaluacion,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(MontoDepCompra,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(MontoDepMejora,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(MontoDepRevaluacion,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(ValorRescate,',____.__')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(VidaUtil,',')#</font></td>
			<td align="right" ><font size="1">#LSNumberFormat(MesesDepreciados,',')#</font></td>
            <td align="right" ><font size="1">#LSNumberFormat(SaldoVidaUtil,',')#</font></td>
		</tr>
		<cfset contador = contador + 1 >
	</cfoutput>
	<cfset printTotales(rsReporte, LSvar_depto, LSvar_oficina, LSvar_categoria)>
	<cfset printTotales(rsReporte, LSvar_depto, LSvar_oficina)>
	<cfset printTotales(rsReporte, LSvar_depto)>
	<cfset printTotales(rsReporte)>
    
<cfelse>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td align="center" colspan="17">&nbsp;</td></tr>
	<tr><td align="center" colspan="17"><strong> --- La consulta no gener&oacute; ning&uacute;n resultado. --- </strong></td></tr>
</cfif>
	<tr><td align="center" colspan="17">&nbsp;</td></tr>

	<tr><td colspan="17" nowrap align="center"><strong> --- Fin de la Consulta --- </strong></td></tr>
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
		<tr  class="style4">
			<td align="left" nowrap bgcolor="##CCCCCC" colspan="5"><font size="1">&nbsp;&nbsp;&nbsp;
            	<strong>Total 
				<cfif len(trim(arguments.categoria))>
                	Categoria: #arguments.categoria#
				<cfelseif len(trim(arguments.oficina))>
                	Oficina: #arguments.oficina#
				<cfelseif len(trim(arguments.departamento))>
                	Departamento: #arguments.Departamento#
                <cfelse> 
                	General
                </cfif>
                </strong></font>
            </td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">&nbsp;</font></td>
            <td align="right" bgcolor="##CCCCCC"><font size="1">&nbsp;</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoAdquisicion,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoMejoras,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoReevaluacion,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoDepCompra,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoDepMejora,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.MontoDepRevaluacion,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC"><font size="1">#LSNumberFormat(rs.ValorRescate,',____.__')#</font></td>
			<td align="right" bgcolor="##CCCCCC" colspan="3"><font size="1">&nbsp;</font></td>
		</tr>
	</cfoutput>
	<cfreturn>
</cffunction>
<cffunction name="fnPintaCortes" access="private" output="yes">
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
	            <tr><td nowrap colspan="15" align="left">&nbsp;</td></tr>
				<cfset contador = contador + 1 >
            </cfif>
			<cfset LSvar_depto = trim(rsReporte.DeptoCodigo)>
            <cfset LSvar_oficina = "">
			<cfoutput>
			<tr><td nowrap colspan="17" align="left" bgcolor="##CCCCCC"><strong>Departamento:&nbsp;#trim(rsReporte.DeptoCodigo)# - #trim(rsReporte.Ddescripcion)#</strong></td></tr>	
			</cfoutput>
			<cfset contador = contador + 1 >
		</cfif>
		<cfif trim(rsReporte.Oficodigo) neq trim(LSvar_oficina) or LBvar_pintarEnc>
			<cfset LSvar_oficina = trim(rsReporte.Oficodigo)>
            <cfset LSvar_categoria = "">
			<cfoutput>
			<tr><td nowrap colspan="17" align="left" bgcolor="##CCCCCC"><strong>Oficina:&nbsp;#trim(rsReporte.Oficodigo)# - #trim(rsReporte.Odescripcion)#</strong></td></tr>	
			</cfoutput>
			<cfset contador = contador + 1 >
		</cfif>
		<cfif trim(rsReporte.CODCategoria) neq trim(LSvar_categoria) or LBvar_pintarEnc>
			<cfset LSvar_categoria = trim(rsReporte.CODCategoria)>
			<cfoutput>
			<tr><td nowrap colspan="17" align="left" bgcolor="##CCCCCC"><strong>Categor&iacute;a:&nbsp;#trim(rsReporte.CODCategoria)# - #trim(rsReporte.Categoria)#</strong></td> </tr>
			</cfoutput>
			<cfset contador = contador + 1 >
		</cfif>
</cffunction>


