<!--- 
	Creado por Gustavo Fonseca H/DorianA.
		Motivo: Nueva consulta para exportacin a Excel del mdulo de Activos Fijos.
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


<cfsavecontent variable="myQuery">
	<cfoutput>
		<!--- Activos Adquiridos en un rango de meses --->
		select 
			{fn concat ( {fn concat(c.ACcodigodesc, ' - ')}, c.ACdescripcion)} as Categoria, 
			{fn concat ( {fn concat(d.CFcodigo, ' - ')}, min(d.CFdescripcion) )} as CentroF,
			sum(a.TAmontolocmej) as Suma_Resumida

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
			
		where a.IDtrans = 2 <!--- Mejoras --->
		and a.Ecodigo = #session.Ecodigo#
		and a.TAperiodo = <cf_dbfunction name="to_number" args="#url.periodoInicial#"> 
		and a.TAmes	between <cf_dbfunction name="to_number" args="#url.mesInicial#"> and <cf_dbfunction name="to_number" args="#url.mesfinal#">
		group by c.ACcodigodesc ,c.ACdescripcion, d.CFcodigo, d.CFdescripcion
		order by 1
		
	</cfoutput>
</cfsavecontent>

<cftry>
	<!--- <cfset registros = 0 > --->
	<cfflush interval="128">
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>

	<cfif isdefined("url.Formato") and url.Formato eq 2>
		<cf_exportQueryToFile query="#data#" filename="Mejoras_Res_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="true">
	<cfelseif isdefined("url.Formato") and url.Formato eq 3>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Mejoras_Res_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
	</cfif>

<table width="70%" cellpadding="2" cellspacing="0" border="0" align="center">
	<cfoutput query="data" group="Categoria">
	<cfset totalValorCF = 0>
		<tr>
			<td bgcolor="CCCCCC" colspan="2" width="1%"><strong>Categor&iacute;a:&nbsp;</strong>#Categoria#</td>
		</tr>
			<tr>
				<td style="padding:3px;"  bgcolor="E1E1E1" nowrap="nowrap" width="1%"><strong>Centro&nbsp;Funcional:&nbsp;</strong></td>
				<td style="padding:3px;" bgcolor="E1E1E1" nowrap="nowrap" width="1%"><strong>Valor Original</strong></td>
			</tr>
			<cfoutput>
				<tr>
					<td colspan="1">#CentroF#</td>
					<td colspan="1">#NumberFormat(Suma_Resumida, ",_.__")#</td>
				</tr>
				<cfset totalValorCF = totalValorCF + Suma_Resumida>
			</cfoutput>
			<tr>
				<td align="right"><strong>Total Categor&iacute;a #Categoria#:&nbsp;</strong></td>
				<td>#NumberFormat(totalValorCF, ",_.__")#</td>
			</tr>
		</cfoutput>
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
</table>

