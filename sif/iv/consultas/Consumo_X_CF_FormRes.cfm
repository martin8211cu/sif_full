<cfif isdefined("url.TipoReporte") and not isdefined("form.TipoReporte")>
	<cfset form.TipoReporte = url.TipoReporte>
</cfif>
<cfif isdefined("url.CFcodigoDes") and not isdefined("form.CFcodigoDes")>
    <cfset form.CFcodigoDes = url.CFcodigoDes>
</cfif>
<cfif isdefined("url.CFcodigoHas") and not isdefined("form.CFcodigoHas")>
    <cfset form.CFcodigoHas = url.CFcodigoHas>
</cfif>
<cfif isdefined("url.AlmcodigoIni") and not isdefined("form.AlmcodigoIni")>
    <cfset form.AlmcodigoIni = url.AlmcodigoIni>
</cfif>
<cfif isdefined("url.AlmcodigoFin") and not isdefined("form.AlmcodigoFin")>
    <cfset form.AlmcodigoFin = url.AlmcodigoFin>
</cfif>
<cfif isdefined("url.FechaDes") and not isdefined("form.FechaDes")>
    <cfset form.FechaDes = url.FechaDes>
</cfif>
<cfif isdefined("url.FechaHas") and not isdefined("form.FechaHas")>
    <cfset form.FechaHas = url.FechaHas>
</cfif>
<cfif isdefined("url.chk_CorteAlmacen") and not isdefined("form.chk_CorteAlmacen")>
    <cfset form.chk_CorteAlmacen = url.chk_CorteAlmacen>
</cfif>
<cfif isdefined("url.chk_CorteOgasto") and not isdefined("form.chk_CorteOgasto")>
    <cfset form.chk_CorteOgasto = url.chk_CorteOgasto>
</cfif>

<cf_dbfunction name="to_float" args="k.Kcosto" returnvariable = "Kcosto">
<cf_dbfunction name="op_concat" returnvariable = "Cat">
<cfquery name="data" datasource="#session.DSN#">
	select 	
		cf.CFcodigo,
        cf.CFdescripcion,
        art.Acodigo as Codigo,
        art.Adescripcion as Descripcion,
        sum(abs(k.Kunidades)) as Cantidad,
        sum(#PreserveSingleQuotes(Kcosto)#) as Total
        <cfif isdefined("form.chk_CorteAlmacen")>
            , alm.Almcodigo
            , min(alm.Almcodigo #Cat# ' - ' #Cat# alm.Bdescripcion) as Almacen
       	</cfif>
        ,case when <cf_dbfunction name="length"	args="rtrim(cl.cuentac)"> = 0 then 'Sin Objeto de Gasto' else
        Coalesce(cl.cuentac, 'Sin Objeto de Gasto') end as objetoGasto
	from HERequisicion a
		inner join Kardex k
			inner join Articulos art
				on art.Aid = k.Aid
            LEFT OUTER JOIN Clasificaciones cl
            	 ON cl.Ecodigo = art.Ecodigo
                AND cl.Ccodigo = art.Ccodigo
            inner join Almacen alm
            	on alm.Aid = k.Alm_Aid
			inner join CFuncional cf
				on cf.CFid= k.CFid
				and cf.Ecodigo = k.Ecodigo
		on k.ERid = a.ERid	
	where a.Ecodigo = #session.Ecodigo#
		<!--- Centro Funcional --->
		<cfif isdefined("form.CFcodigoDes") and len(trim(form.CFcodigoDes)) and isdefined("form.CFcodigoHas") and len(trim(form.CFcodigoHas))>
	        <cfset LvarCFcodigoDes = form.CFcodigoDes>
            <cfset LvarCFcodigoHas = form.CFcodigoHas>
            
			<cfif form.CFcodigoHas LT form.CFcodigoDes>
                <cfset LvarCFcodigoDes = form.CFcodigoHas>
                <cfset LvarCFcodigoHas = form.CFcodigoDes>
            </cfif>
			and cf.CFcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCFcodigoDes#"> 
			and cf.CFcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCFcodigoHas#">
		<cfelseif isdefined("form.CFcodigoDes") and len(trim(form.CFcodigoDes)) >
			and cf.CFcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.CFcodigoDes#">
		<cfelseif isdefined("form.CFcodigoHas") and len(trim(form.CFcodigoHas)) >
			and cf.CFcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.CFcodigoHas#">
		</cfif> 
        
		<!--- Almacen --->
        <cfif isdefined("form.AlmcodigoIni") and len(trim(form.AlmcodigoIni)) and isdefined("form.AlmcodigoFin") and len(trim(form.AlmcodigoFin))>
	        <cfset LvarAlmcodigoIni = form.AlmcodigoIni>
            <cfset LvarAlmcodigoFin = form.AlmcodigoFin>
            
			<cfif form.AlmcodigoFin LT form.AlmcodigoIni>
                <cfset AlmcodigoIni = form.AlmcodigoFin>
                <cfset AlmcodigoFin = form.AlmcodigoIni>
            </cfif>
			and alm.Almcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#AlmcodigoIni#"> 
			and alm.Almcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#LvarAlmcodigoFin#">
		<cfelseif isdefined("form.AlmcodigoIni") and len(trim(form.AlmcodigoIni)) >
			and alm.Almcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.AlmcodigoIni#">
		<cfelseif isdefined("form.AlmcodigoFin") and len(trim(form.AlmcodigoFin)) >
			and alm.Almcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.AlmcodigoFin#">
		</cfif> 
        
		<!--- Fechas Desde / Hasta --->
		<cfif isdefined("form.fechaDes") and len(trim(form.fechaDes)) and isdefined("form.fechaHas") and len(trim(form.fechaHas))>
			<cfif datecompare(lsparsedatetime(form.fechaDes), lsparsedatetime(form.fechaHas)) eq -1>
				<cfset LvarFecha1 =  lsparsedatetime(form.fechaDes)>
				<cfset LvarFecha2 =  lsparsedatetime(form.fechaHas)>
			<cfelseif datecompare(lsparsedatetime(form.fechaDes), lsparsedatetime(form.fechaHas)) eq 1>
				<cfset LvarFecha1 =  lsparsedatetime(form.fechaHas)>
				<cfset LvarFecha2 =  lsparsedatetime(form.fechaDes)>
			<cfelseif datecompare(lsparsedatetime(form.fechaDes), lsparsedatetime(form.fechaHas)) eq 0>
				<cfset LvarFecha1 =  lsparsedatetime(form.fechaDes)>
				<cfset LvarFecha2 =  LvarFecha1>
			</cfif>
			<cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
			and a.ERFecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha1#">
							  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha2#">
		<cfelseif isdefined("form.fechaDes") and len(trim(form.fechaDes))>
			<cfset LvarFecha1 =  lsparsedatetime(form.fechaDes)>
			and a.ERFecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha1#">
		<cfelseif isdefined("form.fechaHas") and len(trim(form.fechaHas))>
			<cfset LvarFecha2 =  lsparsedatetime(form.fechaHas)>
			<cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
			and a.ERFecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha2#">
		</cfif>	
    group by cf.CFcodigo,
		cf.CFdescripcion,
		art.Acodigo,
		art.Adescripcion,cl.cuentac
        <cfif isdefined("form.chk_CorteAlmacen")>
	        , alm.Almcodigo
        </cfif>
        <cfif isdefined("form.chk_CorteOgasto")>
   		 	,case when <cf_dbfunction name="length"	args="rtrim(cl.cuentac)"> = 0 then 'Sin Objeto de Gasto' else
        Coalesce(cl.cuentac, 'Sin Objeto de Gasto') end
  		</cfif>
	order by 
		cf.CFcodigo,
        <cfif isdefined("form.chk_CorteAlmacen")>
			alm.Almcodigo, 
        </cfif> 
        <cfif isdefined("form.chk_CorteOgasto")>
   		 	objetoGasto,
  		</cfif>
		CFdescripcion, art.Adescripcion 
</cfquery>

<style type="text/css">
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td colspan="5">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
				<tr><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> 
					<td colspan="5"  valign="middle" align="center"><font size="4"><strong><cfoutput>#session.Enombre#</cfoutput></strong></font></td>
					</strong>
				</tr>
		
				<tr> 
					<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
					<td colspan="5" align="center">
						<font size="3">
							<strong>
								Consulta de Consumo por Centro Funcional (Resumido)
							</strong>
						</font>
					</td>
					</strong>
				</tr>
				<cfoutput>
				<tr > 
					<td colspan="5" align="center">
					
							<cfif isdefined("form.CFcodigoDes") and isdefined("form.CFcodigoHas")>
								<cfif form.CFcodigoDes neq form.CFcodigoHas >
									<font size="2"><strong>Centro Funcional Desde:  #form.CFcodigoDes# - Centro Funcional Hasta:  #form.CFcodigoHas#</strong></font>
								<cfelse>
									<font size="2"><strong>Centro Funcional: #form.CFcodigoDes#</strong></font>
								</cfif>
							<cfelseif isdefined("desde")>
								<font size="2"><strong>Centro Funcional Desde: #form.CFcodigoDes#</strong></font>
							<cfelseif isdefined("hasta")>
								<font size="2"><strong>Centro Funcional Hasta: #form.CFcodigoHas#</strong></font>
							<cfelse>
								<font size="1"><strong>(Todos los Centros Funcionales)</strong></font>
							</cfif>
					</td>
				</tr>
				</cfoutput>
			</table>
		</td>	
	</tr>
    	
	<cfif data.RecordCount gt 0>
		<cfset LvarCorteCF  = '' >
        <cfset LvarCorteAlm = ''>
        <cfset corteOG	    = '' >
        <cfset totalCF      = 0>
        <cfset totalOG      = 0>
        
		 <cfoutput query="data" group="CFdescripcion">
			<cfset totalCF = 0>
            <cfset totalOG = 0>
            <cfset corteOG = '' >
				<tr> 
					<td colspan="5" class="bottomline">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="5" class="tituloListas" align="left" style="padding-left:3;"><div align="left"><font size="3">Centro Funcional: #CFcodigo# - #CFdescripcion# </font></div></td>
				</tr>
				<cfoutput>
					<cfif isdefined("form.chk_CorteAlmacen") and LvarCorteAlm NEQ data.Almcodigo or isdefined("form.chk_CorteAlmacen") and LvarCorteAlm EQ data.Almcodigo and LvarCorteCF NEQ data.CFdescripcion>
                      	<cfif isdefined("form.chk_CorteOgasto") and corteOG NEQ data.objetoGasto and LEN(TRIM(corteOG))>
                            <tr>
                                <td nowrap="nowrap" colspan="3" align="right"><strong>Total del Objeto de Gasto #corteOG#</strong></td>
                                <td nowrap="nowrap" colspan="1" align="right"><strong>#LSNumberFormat(totalOG,",9.00")#</strong></td>
                            </tr>
                            <cfset totalOG = 0>  
                            <cfset corteOG = "">
                 		</cfif>
                        <tr>
                            <td colspan="5" class="tituloListas" align="left" style="padding-left:3;"><div align="left"><font size="3">&nbsp;Almacén: #Almacen# </font></div></td>
                        </tr>
                        <tr  bgcolor="##B6D0F1" style="padding-left:10; padding:3; "> 
                          <td><strong>C&oacute;digo</strong></td>
                          <td><strong>Descripci&oacute;n</strong></td>
                          <td align="right"><strong>Cantidad</strong></td>
                          <td align="right"><strong>Total</strong></td>
                        </tr>
                    <cfelseif LvarCorteCF NEQ data.CFdescripcion and not isdefined("form.chk_CorteAlmacen")>
                    	<tr  bgcolor="##B6D0F1" style="padding-left:10; padding:3; "> 
                          <td><strong>C&oacute;digo</strong></td>
                          <td><strong>Descripci&oacute;n</strong></td>
                          <td align="right"><strong>Cantidad</strong></td>
                          <td align="right"><strong>Total</strong></td>
                        </tr>
                    </cfif>
                    <!---►►Corte por Objeto de Gasto◄◄--->
                    <cfif isdefined("form.chk_CorteOgasto") and corteOG NEQ data.objetoGasto>
						<cfif LEN(TRIM(corteOG))>
                            <tr>
                                <td nowrap="nowrap" colspan="3" align="right"><strong>Total del Objeto de Gasto #corteOG#</strong></td>
                                <td nowrap="nowrap" colspan="1" align="right"><strong>#LSNumberFormat(totalOG,",9.00")#</strong></td>
                            </tr>
                            <cfset totalOG = 0>  
                        </cfif>   	
                        <cfset corteOG = data.objetoGasto>
                        <tr><td colspan="5"><strong>Objeto de Gasto: #corteOG#</strong></td></tr>
                 	</cfif>
                 	<cfset totalOG = totalOG + data.Total>
                    <tr style="padding-left:10; cursor:hand;">
                        <td nowrap>#data.Codigo#</td>
                        <td nowrap>#data.Descripcion#</td>
                        <td nowrap align="right">#LSNumberFormat(data.Cantidad,",9.00")#</td> 
                        <td nowrap align="right">#LSNumberFormat(data.Total,",9.00")#</td> 
                    </tr>
                    <cfset totalCF = totalCF + data.Total>
                    <cfif isdefined("form.chk_CorteAlmacen")>
                		<cfset LvarCorteAlm = data.Almcodigo>
                    </cfif>
                    <cfset LvarCorteCF = data.CFdescripcion>
                </cfoutput>
            <!---►►Total por Objeto de Gasto◄◄--->    
           <cfif isdefined("form.chk_CorteOgasto")  and LEN(TRIM(corteOG))>
                <tr>
                    <td nowrap="nowrap" colspan="3" align="right"><strong>Total del Objeto de Gasto #corteOG#</strong></td>
                    <td nowrap="nowrap" colspan="1" align="right"><strong>#LSNumberFormat(totalOG,",9.00")#</strong></td>
                </tr>  
            </cfif>   	
			<tr>
				<td nowrap="nowrap" colspan="3" align="right"><strong>Total Centro Funcional #CFcodigo# - #CFdescripcion#:</strong></td>
				<td nowrap="nowrap" colspan="1" align="right"><strong>#LSNumberFormat(totalCF,",9.00")#</strong></td>
			</tr>

            
		</cfoutput>	
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr><td colspan="5" align="center"><strong>------ Fin del Reporte ------</strong></td></tr>
	<cfelse>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="5" align="center"><strong>--- No se encontraron Registros ---</strong></td></tr>
	</cfif>
</table>
<br>
