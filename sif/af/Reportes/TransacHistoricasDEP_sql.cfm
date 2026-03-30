<!--- 
	Creado por Gustavo Fonseca H / DorianA.
		Motivo: Nueva consulta para exportación a Excel del módulo de Activos Fijos.
		Fecha:16-5-2006.
 --->
<!--- Centros Funcionales --->
<cfif not isdefined("url.CFcodigoInicio")>
	<cfset centroini = false>
<cfelse>	
	<cfif url.CFcodigoInicio eq "">
		<cfset centroini = false>
	<cfelse>
		<cfset centroini = true>			
	</cfif>
</cfif>
<cfif not isdefined("url.CFcodigofinal")>
	<cfset centrofin = false>
<cfelse>	
	<cfif url.CFcodigoInicio eq "">
		<cfset centrofin = false>
	<cfelse>
		<cfset centrofin = true>			
	</cfif>
</cfif>

<!--- Oficinas --->
<cfif not isdefined("url.OficinaIni")>
	<cfset oficinaini = false>
<cfelse>	
	<cfif url.OficinaIni eq "">
		<cfset oficinaini = false>
	<cfelse>
		<cfset oficinaini = true>			
	</cfif>
</cfif>
<cfif not isdefined("url.OficinaFin")>
	<cfset oficinafin = false>
<cfelse>	
	<cfif url.OficinaFin eq "">
		<cfset oficinafin = false>
	<cfelse>
		<cfset oficinafin = true>			
	</cfif>
</cfif>	

<cfset LvarPeriodoCierre = url.periodoinicial>
<cfset LvarmesCierre = url.mesinicial - 1>
<cfif LvarmesCierre LT 1>
	<cfset LvarPeriodoCierre = LvarPeriodoCierre - 1>
	<cfset LvarmesCierre = 12>
</cfif>

<!--- 
	Depreciacion del Periodo:
	Valor de Depreciacion Acumulada a la fecha del reporte - Depreciacion Acumulada al Mes Final del AÑo Fiscal Anterior
--->
<cfsavecontent variable="myQuery">
	<cfoutput>
		select 
			af.AFSmes as Mes, 
			<cf_dbfunction name="concat" args="c.ACcodigodesc,'-',c.ACdescripcion"> as Categoria, 
		    <cf_dbfunction name="concat" args="cl.ACcodigodesc,'-',cl.ACdescripcion"> as Clase,
		     <cf_dbfunction name="concat" args="d.CFcodigo,'-',d.CFdescripcion"> as CentroF, 
			a.Aplaca as Placa,
			af.AFSsaldovutiladq as vu,
			a.Adescripcion as Activo,
			af.AFSvaladq + af.AFSvalmej + af.AFSvalrev as Valor,
			( af.AFSdepacumadq + af.AFSdepacummej + af.AFSdepacumrev )
			-  
				coalesce((
					select sum( y.AFSdepacumadq + y.AFSdepacummej + y.AFSdepacumrev ) 
					from AFSaldos y
					where y.Aid = af.Aid
					and y.AFSperiodo  =  #LvarPeriodoCierre#
					and y.AFSmes      =  #LvarMesCierre#
				) ,0.00)  
			as DepreciacionAcum
			<cfif isdefined("url.chkveradq")>
			,af.AFSvaladq as Monto_Adq
			</cfif>
			<cfif isdefined("url.chkvermej")>
			,af.AFSvalmej as Monto_Mej
			</cfif>
			<cfif isdefined("url.chkverrev")>
			,af.AFSvalrev as Monto_Rev
			</cfif>
			<cfif isdefined("url.chkverdepadq")>
			,af.AFSdepacumadq as Dep_Adq
			</cfif>
			<cfif isdefined("url.chkverdepmej")>
			,af.AFSdepacummej as Dep_Mej
			</cfif>
			<cfif isdefined("url.chkverdeprev")>
			,af.AFSdepacumrev as Dep_Rev
			</cfif>
			,hct.Edocumento as Documento
			,hct.Cconcepto as Concepto
		from ACategoria c
			inner join AClasificacion cl 
   				inner join Activos a 
  					inner join AFSaldos af 
						inner join CFuncional d
						on d.CFid = af.CFid 
						<cfif centroini and not centrofin > 
							and d.CFcodigo >= '#url.CFcodigoInicio#'
						<cfelseif not centroini and centrofin >
							and d.CFcodigo <= '#url.CFcodigofinal#'    
						<cfelseif centroini and centrofin >
							and d.CFcodigo between '#url.CFcodigoInicio#'  and '#url.CFcodigofinal#'
						</cfif>
						<cfif oficinaini and not oficinafin > 
							and d.Ocodigo >= #url.OficinaIni#
						<cfelseif not oficinaini and oficinafin >
							and d.Ocodigo <= #url.OficinaFin#
						<cfelseif oficinaini and oficinafin >
							and d.Ocodigo between #url.OficinaIni#  and #url.OficinaFin#
						</cfif>
					on af.Aid = a.Aid 
					and af.Ecodigo=a.Ecodigo
					and af.AFSperiodo = #url.PeriodoInicial#
					and af.AFSmes = #url.mesfinal#
					
					inner join TransaccionesActivos ta
						inner join HEContables hct
						on hct.IDcontable=ta.IDcontable						
					on ta.Aid=a.Aid
					and ta.Ecodigo=a.Ecodigo
				
				on a.Ecodigo = cl.Ecodigo 
				and a.ACid = cl.ACid 
				and a.ACcodigo = cl.ACcodigo 
			<cfif isdefined('url.AFCcodigopadre') and LEN(TRIM(url.AFCcodigopadre)) gt 0 and url.AFCcodigopadre gte 0>
				and a.AFCcodigo = #url.AFCcodigopadre#
			</cfif>
				
			on cl.Ecodigo = c.Ecodigo
			and cl.ACcodigo = c.ACcodigo
		where c.Ecodigo = #session.Ecodigo#
		and c.ACcodigo >= #url.codigodesde#
		and c.ACcodigo <= #url.codigohasta#
		and c.ACcodigo between #url.codigodesde# and #url.codigohasta#
		order by 1,2,3,4
	</cfoutput>
</cfsavecontent>
<table width="100%" cellpadding="2" cellspacing="0">
<cfflush interval="128">

<cftry>
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>
	
	<cfif isdefined("url.Formato") and url.Formato eq 2>
		<cf_exportQueryToFile query="#data#" filename="Depreciacion_Det_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="true">
	<cfelseif isdefined("url.Formato") and url.Formato eq 3>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Depreciacion_Det_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
	</cfif>
	
	<cfoutput query="data" group="Categoria">
	<cfset totalValorCat = 0>
	<cfset totalDepCat = 0>
	<cfset totalDepCF = 0>
		<tr>
			<td nowrap="nowrap" style="font-size:10px"><strong>Categor&iacute;a:&nbsp;</strong>#Categoria#</td>
		</tr>	
		<cfoutput group="CentroF">
		<cfset totalValorCF = 0>
		<cfset totalDepCF = 0>
			<tr>
				<td nowrap="nowrap" style="font-size:10px"><strong>Centro&nbsp;Funcional:&nbsp;</strong>#CentroF#</td>
			</tr>
			<tr style="font-size:10px">
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Placa</strong></td>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Clase</strong></td>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Descripci&oacute;n</strong></td>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Valor</strong></td>
				<cfif isdefined("url.chkveradq")>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Adquisici&oacute;n</strong></td>
				</cfif>
				<cfif isdefined("url.chkvermej")>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Mejora</strong></td>
				</cfif>
				<cfif isdefined("url.chkverrev")>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Revaluaci&oacute;n</strong></td>
				</cfif>
				<cfif isdefined("url.chkverdepadq")>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Dep. Adquisici&oacute;n</strong></td>
				</cfif>
				<cfif isdefined("url.chkverdepmej")>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Dep. Mejora</strong></td>
				</cfif>
				<cfif isdefined("url.chkverdeprev")>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Dep. Revaluaci&oacute;n</strong></td>
				</cfif>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Depreciación Acum. (rango)</strong></td>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Vida útil</strong></td>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Mes</strong></td>
				<td style="padding:8px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Documento</strong></td>
				<td style="padding:8px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Concepto</strong></td>
			</tr>
			<cfoutput>
				<tr>
					<td style="font-size:8px">#Placa#</td>
					<td style="font-size:8px" nowrap="nowrap">#Clase#</td>
					<td style="font-size:8px" nowrap="nowrap">#Activo#</td>
					<td style="font-size:8px">#NumberFormat(Valor, ",_.__")#</td>
					<cfif isdefined("url.chkveradq")>
					<td style="font-size:8px">#NumberFormat(Monto_Adq, ",_.__")#</td>
					</cfif>
					<cfif isdefined("url.chkvermej")>
					<td style="font-size:8px">#NumberFormat(Monto_Mej, ",_.__")#</td>
					</cfif>
					<cfif isdefined("url.chkverrev")>
					<td style="font-size:8px">#NumberFormat(Monto_Rev, ",_.__")#</td>
					</cfif>
					<cfif isdefined("url.chkverdepadq")>
					<td style="font-size:8px">#NumberFormat(Dep_Adq, ",_.__")#</td>
					</cfif>
					<cfif isdefined("url.chkverdepmej")>
					<td style="font-size:8px">#NumberFormat(Dep_Mej, ",_.__")#</td>
					</cfif>
					<cfif isdefined("url.chkverdeprev")>
					<td style="font-size:8px">#NumberFormat(Dep_Rev, ",_.__")#</td>
					</cfif>
					<td style="font-size:8px">#NumberFormat(DepreciacionAcum, ",_.__")#</td>
					<td style="font-size:8px">#vu#</td>
					<td style="font-size:8px">#Mes#</td>
					<td style="font-size:8px">#Documento#</td>
					<td style="font-size:8px">#Concepto#</td>
					<cfset totalValorCF = totalValorCF + Valor>
					<cfset totalDepCF = totalDepCF + DepreciacionAcum>
				</tr>
			</cfoutput>
				<tr>
					<td colspan="2">&nbsp;</td>
					<td align="right" nowrap="nowrap" colspan="3"><strong>Total Centro Funcional #CentroF#:&nbsp;</strong></td>
					<td>#NumberFormat(totalValorCF, ",_.__")#</td>
					<td>#NumberFormat(totalDepCF, ",_.__")#</td>
				</tr>
				<cfset totalValorCat = totalValorCat + totalValorCF>
				<cfset totalDepCat = totalDepCat + totalDepCF>
		</cfoutput>
				<tr>
					<td colspan="2">&nbsp;</td>
					<td align="right" nowrap="nowrap" colspan="3"><strong>Total Categor&iacute;a #Categoria#:&nbsp;</strong></td>
					<td>#NumberFormat(totalValorCat, ",_.__")#</td>
					<td>#NumberFormat(totalDepCat, ",_.__")#</td>
				</tr>
	</cfoutput>
	
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
<cf_jdbcquery_close>
</table>

