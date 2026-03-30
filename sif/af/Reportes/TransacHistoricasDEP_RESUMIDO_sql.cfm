<!--- 
	Creado por Gustavo Fonseca H / DorianA.
		Motivo: Nueva consulta para exportación a Excel del módulo de Activos Fijos.
		Fecha:16-5-2006.
 --->

<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfsetting requesttimeout="36000">

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

<!--- Activos Depreciados en un rango de meses --->
<cfsavecontent variable="myQuery">
	<cfoutput>
		select 
			Categoria,
			min(Clase) as Clase,
			min(CFdescripcion) as CFdescripcion,
			sum(Valor) as Valor,
			sum(DepreciacionAcum) as DepreciacionAcum
		from
		
		(
			select 
				{fn concat ( {fn concat ( c.ACcodigodesc, ' - ')}, c.ACdescripcion)} as Categoria,  
				{fn concat ( {fn concat (cl.ACcodigodesc, ' - ')}, cl.ACdescripcion)} as  Clase,
				{fn concat ( {fn concat (d.CFcodigo, ' - ')}, d.CFdescripcion)} as CFdescripcion,
				(AFSvaladq + AFSvalmej + AFSvalrev)
				as Valor,
				(AFSdepacumadq + AFSdepacummej + AFSdepacumrev) 
				- 
				coalesce(
				  (select sum(y.AFSdepacumadq + y.AFSdepacummej + y.AFSdepacumrev) 
					  from AFSaldos y
							where y.Aid = af.Aid
							and y.AFSperiodo = #LvarPeriodoCierre# 
							and y.AFSmes =  #LvarMesCierre#
				) ,0.00)
				as DepreciacionAcum
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
				  and af.AFSperiodo = #url.PeriodoInicial#
				  and af.AFSmes = #url.mesfinal#
			 
			
				  on a.ACcodigo = cl.ACcodigo
				and a.ACid = cl.ACid
				and a.Ecodigo = cl.Ecodigo
				
			   on cl.ACcodigo = c.ACcodigo
			   and cl.Ecodigo = c.Ecodigo
		
		where c.Ecodigo = #session.Ecodigo#
		  and c.ACcodigo >= #url.codigodesde#
		  and c.ACcodigo <= #url.codigohasta#
		
		)  tabladerivada
		
		group by Categoria
	</cfoutput>
</cfsavecontent>

<table width="100%" cellpadding="2" cellspacing="0">
	<cftry>
		<cfflush interval="128">
		<cf_jdbcquery_open name="data" datasource="#session.DSN#">
		<cfoutput>#myquery#</cfoutput>
		</cf_jdbcquery_open>

	<cfif isdefined("url.Formato") and url.Formato eq 2>
		<cf_exportQueryToFile query="#data#" filename="Depreciacion_Res_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="true">
	<cfelseif isdefined("url.Formato") and url.Formato eq 3>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Depreciacion_Res_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
	</cfif>
	
	<cfoutput query="data" group="Categoria">
		<cfset totalValorCat = 0>
		<cfset totalDepCat = 0>
		<tr>
			<td nowrap="nowrap" style="font-size:10px"><strong>Categor&iacute;a:&nbsp;</strong>#Categoria#</td>
		</tr>	
		<cfoutput group="CFdescripcion">
		<cfset totalValorCat = 0>

			<tr style="font-size:10px">
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Centro&nbsp;Funcional:&nbsp;</strong></td>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Valor</strong></td>
				<td style="font-size:8px" bgcolor="CCCCCC" nowrap="nowrap"><strong>Depreciación Acum. (rango)</strong></td>
			</tr>
			<cfoutput>
				<tr>
					<td style="font-size:8px">#CFdescripcion#</td>
					<td style="font-size:8px">#NumberFormat(Valor, ",_.__")#</td>
					<td style="font-size:8px">#NumberFormat(DepreciacionAcum, ",_.__")#</td>
					<cfset totalValorCat = totalValorCat + Valor>
					<cfset totalDepCat = totalDepCat + DepreciacionAcum>
				</tr>
			</cfoutput>
				<tr>
					<td align="right" nowrap="nowrap"><strong>Total Categor&iacute;a #Categoria#:&nbsp;</strong></td>
					<td style="font-size:9px">#NumberFormat(totalValorCat, ",_.__")#</td>
					<td style="font-size:9px">#NumberFormat(totalDepCat, ",_.__")#</td>
				</tr>
		</cfoutput>
				
	</cfoutput>
	
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
</table>	

