<!--- 
	Creado por Gustavo Fonseca H/DorianA.
		Motivo: Nueva consulta para exportación a Excel del módulo de Activos Fijos.
		Fecha:16-5-2006.
 --->

<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

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

<cfif isdefined("url.Formato") and url.Formato GT 1>
	<cftry>
		<cfsavecontent variable="myQuery">
			<cfoutput>
				<!--- Activos Adquiridos en un rango de meses --->
				select 
					{fn concat ( {fn concat (c.ACcodigodesc, ' - ')}, c.ACdescripcion)} as Categoria, 
					{fn concat ( {fn concat (cl.ACcodigodesc, ' - ')}, cl.ACdescripcion)} as Clase, 
					{fn concat ( {fn concat (rtrim(ltrim(ofi.Oficodigo)), ' - ')}, rtrim(ltrim(ofi.Odescripcion)) )} as Oficina,
					{fn concat ( {fn concat (d.CFcodigo, ' - ')}, min(d.CFdescripcion) )} as CentroF,
					sum(a.TAmontolocadq) as Suma_Resumida
				from TransaccionesActivos a
					inner join Activos b
						inner join ACategoria c
							on c.Ecodigo = b.Ecodigo
							and c.ACcodigo = b.ACcodigo					
							and c.ACcodigo between #url.codigodesde# and #url.codigohasta#
						inner join AClasificacion cl
							on cl.Ecodigo = b.Ecodigo
							and cl.ACcodigo = b.ACcodigo
							and cl.ACid = b.ACid
						on b.Ecodigo = a.Ecodigo
						and b.Aid = a.Aid
						and b.Astatus = 0	
						
					inner join CFuncional d
						on d.CFid = a.CFid
		
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
					
					inner join Oficinas ofi
						on ofi.Ocodigo = d.Ocodigo
					   and ofi.Ecodigo = d.Ecodigo
		
				where a.IDtrans = 1 <!--- Adquisiciones --->
				and a.Ecodigo = #session.Ecodigo#
				and a.TAperiodo = <cf_dbfunction name="to_number" args="#url.periodoInicial#"> 
				and a.TAmes	between <cf_dbfunction name="to_number" args="#url.mesInicial#"> and <cf_dbfunction name="to_number" args="#url.mesfinal#">
				group by c.ACcodigodesc,
						 c.ACdescripcion, 
						 cl.ACcodigodesc,
						 cl.ACdescripcion, 
						 ofi.Oficodigo, 
						 ofi.Odescripcion, 
						 d.CFcodigo,
						 d.CFdescripcion
				order by 1
			
			</cfoutput>
		</cfsavecontent>
	
		<cf_jdbcquery_open name="data" datasource="#session.DSN#">
		<cfoutput>#myquery#</cfoutput>
		</cf_jdbcquery_open>
	
		<cfif url.Formato eq 2>
			<cf_exportQueryToFile query="#data#" filename="Adquisicion_Res_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="true">
		<cfelseif url.Formato eq 3>
			<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Adquisicion_Res_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
		</cfif>
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cf_jdbcquery_close>
</cfif>
<!--- No se envió el formato a la salida de archivo plano.  Se imprime el reporte --->
<!--- Activos Adquiridos en un rango de meses. Se procesa el filtro requerido en el sistema --->
<cfquery name="datar" datasource="#session.dsn#">
	select 
		c.ACcodigodesc, c.ACcodigo,	{fn concat ( {fn concat (c.ACcodigodesc, ' - ')}, c.ACdescripcion)} as Categoria, count(1) as Cantidad
	from TransaccionesActivos a
		inner join Activos b
			inner join ACategoria c
				on c.Ecodigo = b.Ecodigo
				and c.ACcodigo = b.ACcodigo					
				and c.ACcodigo between #url.codigodesde# and #url.codigohasta#
		on b.Ecodigo = a.Ecodigo
		and b.Aid = a.Aid
		and b.Astatus = 0	
	
		<cfif centroini or centrofin or oficinaini or oficinafin>
			inner join CFuncional d
				on d.CFid = a.CFid

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

			inner join Oficinas ofi
				on ofi.Ocodigo = d.Ocodigo
			   and ofi.Ecodigo = d.Ecodigo
		</cfif>
	
	where a.IDtrans = 1 <!--- Adquisiciones --->
	and a.Ecodigo = #session.Ecodigo#
	and a.TAperiodo = <cf_dbfunction name="to_number" args="#url.periodoInicial#">
	and a.TAmes	between <cf_dbfunction name="to_number" args="#url.mesInicial#"> and <cf_dbfunction name="to_number" args="#url.mesfinal#">
	group by c.ACcodigodesc, c.ACcodigo,	{fn concat ( {fn concat (c.ACcodigodesc, ' - ')}, c.ACdescripcion)}
	order by c.ACcodigodesc
</cfquery>

<table width="70%" cellpadding="2" cellspacing="0" border="0" align="center">

	<cfflush interval="256">
	<cfoutput query="datar">
		<tr>
			<td bgcolor="CCCCCC" colspan="2"><strong>Categor&iacute;a:&nbsp;</strong>#datar.Categoria#</td>
		</tr>
		<tr>
			<td style="padding:3px;"  bgcolor="E1E1E1" nowrap="nowrap" width="37%"><strong>Centro&nbsp;Funcional:&nbsp;</strong></td>
			<td style="padding:3px;" bgcolor="E1E1E1" nowrap="nowrap" width="36%"><strong>Valor Original</strong></td>
	
		</tr>

		<cfquery name="data" datasource="#session.dsn#">
			select 
				{fn concat ( {fn concat (cl.ACcodigodesc, ' - ')}, cl.ACdescripcion)} as Clase, 
				{fn concat ( {fn concat (rtrim(ltrim(ofi.Oficodigo)), ' - ')}, rtrim(ltrim(ofi.Odescripcion)) )} as Oficina,
				{fn concat ( {fn concat (d.CFcodigo, ' - ')}, min(d.CFdescripcion) )} as CentroF,
				sum(a.TAmontolocadq) as Suma_Resumida
			from TransaccionesActivos a
				inner join Activos b
					inner join ACategoria c
						on c.Ecodigo = b.Ecodigo
						and c.ACcodigo = b.ACcodigo					
					inner join AClasificacion cl
						on cl.Ecodigo = b.Ecodigo
						and cl.ACcodigo = b.ACcodigo
						and cl.ACid = b.ACid
					on b.Ecodigo = a.Ecodigo
					and b.Aid = a.Aid
					and b.Astatus = 0	
					
				inner join CFuncional d
					on d.CFid = a.CFid
			
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
				
				inner join Oficinas ofi
					on ofi.Ocodigo = d.Ocodigo
				   and ofi.Ecodigo = d.Ecodigo
			
			where a.IDtrans = 1 <!--- Adquisiciones --->
			and a.Ecodigo = #session.Ecodigo#
			and a.TAperiodo = #url.periodoInicial#
			and a.TAmes	between #url.mesInicial# and #url.mesfinal#
			and c.ACcodigo = #datar.ACcodigo#

			group by cl.ACcodigodesc,
					 cl.ACdescripcion, 
					 ofi.Oficodigo, 
					 ofi.Odescripcion, 
					 d.CFcodigo,
					 d.CFdescripcion
			order by 1, 2, 3
		
		</cfquery>
		
		<cfset totalValorCF = 0>

		<cfloop query="data">
			<tr>
				<td colspan="1">#CentroF#</td>
				<td colspan="1">#NumberFormat(Suma_Resumida, ",_.__")#</td>
				<td colspan="1"></td>
			</tr>
			<cfset totalValorCF = totalValorCF + Suma_Resumida>
		</cfloop>
		<tr>
			<td align="right"><strong>Total Categor&iacute;a #Categoria#:&nbsp;</strong></td>
			<td>#NumberFormat(totalValorCF, ",_.__")#</td>
		</tr>
	</cfoutput>
</table>

