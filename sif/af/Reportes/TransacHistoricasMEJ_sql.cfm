<!--- 
	Creado por Gustavo Fonseca H/DorianA.
		Motivo: Nueva consulta para exportacin a Excel del mdulo de Activos Fijos.
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

<cfsavecontent variable="myQuery">
	<cfoutput>
		<!--- Activos Adquiridos en un rango de meses --->
		select 
			a.TAmes as Mes, 
			<cf_dbfunction name="concat" args="c.ACcodigodesc,'-',c.ACdescripcion"> as Categoria, 
			<cf_dbfunction name="concat" args="d.CFcodigo,'-',d.CFdescripcion"> as CentroF, 
			b.Aplaca as Placa, 
			b.Adescripcion as Descripcion,
			a.TAmontolocmej as Valor,
			<cf_dbfunction name="concat" args="cl.ACcodigodesc,'-',cl.ACdescripcion"> as Clase,
			TAvutil as Vida_Util
			<cfif isdefined("url.chkveradq")>
			,a.TAvaladq as Monto_Adq
			</cfif>
			<cfif isdefined("url.chkvermej")>
			,a.TAvalmej as Monto_Mej
			</cfif>
			<cfif isdefined("url.chkverrev")>
			,a.TAvalrev as Monto_Rev
			</cfif>
			<cfif isdefined("url.chkverdepadq")>
			,a.TAmontodepadq as Dep_Adq
			</cfif>
			<cfif isdefined("url.chkverdepmej")>
			,a.TAmontodepmej as Dep_Mej
			</cfif>
			<cfif isdefined("url.chkverdeprev")>
			,a.TAmontodeprev as Dep_Rev
			</cfif>
			,hct.Edocumento as Documento
			,hct.Cconcepto as Concepto
			
		from TransaccionesActivos a
			inner join Activos b
				inner join ACategoria c
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
				inner join AClasificacion cl
					on cl.Ecodigo = b.Ecodigo
					and cl.ACcodigo = b.ACcodigo
					and cl.ACid = b.ACid
			 on  b.Aid = a.Aid
		<cfif isdefined('url.AFCcodigopadre') and LEN(TRIM(url.AFCcodigopadre)) gt 0 and url.AFCcodigopadre gte 0>
			 and b.AFCcodigo = #url.AFCcodigopadre#
		</cfif>
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
		
		left join HEContables hct
			on hct.IDcontable= a.IDcontable		
			
	where a.IDtrans = 2 
		and a.Ecodigo = #session.Ecodigo#
		and a.TAperiodo = #url.periodoInicial#
		and a.TAmes	between #url.mesInicial# and #url.mesfinal#
		and c.ACcodigo between #url.codigodesde# and #url.codigohasta#
		order by 1,2,3,4
	</cfoutput>
</cfsavecontent>

<cftry>
	<!--- <cfset registros = 0 > --->
	<cfflush interval="128">
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>

	<cfif isdefined("url.Formato") and url.Formato eq 2>
		<cf_exportQueryToFile query="#data#" filename="Mejoras_Det_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="true">
	<cfelseif isdefined("url.Formato") and url.Formato eq 3>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Mejoras_Det_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
	</cfif>
	
<table width="100%" cellpadding="2" cellspacing="0">
	<cfoutput query="data" group="Categoria">
	<cfset totalValorCat = 0>
		<tr>
			<td colspan="5"><strong>Categor&iacute;a:&nbsp;</strong>#Categoria#</td>
		</tr>
			<cfoutput group="CentroF">
			<cfset totalValorCF = 0>
			<tr>
				<td colspan="5"><strong>Centro&nbsp;Funcional:&nbsp;</strong>#CentroF#</td>
			</tr>
			<tr style="padding:10px;">
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Placa</strong></td>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Clase</strong></td>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Descripci&oacute;n</strong></td>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Valor&nbsp;Original</strong></td>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Vida útil</strong></td>
				<cfif isdefined("url.chkveradq")>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Adquisici&oacute;n</strong></td>
				</cfif>
				<cfif isdefined("url.chkvermej")>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Mejora</strong></td>
				</cfif>
				<cfif isdefined("url.chkverrev")>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Revaluaci&oacute;n</strong></td>
				</cfif>
				<cfif isdefined("url.chkverdepadq")>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Dep. Adquisici&oacute;n</strong></td>
				</cfif>
				<cfif isdefined("url.chkverdepmej")>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Dep. Mejora</strong></td>
				</cfif>
				<cfif isdefined("url.chkverdeprev")>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Dep. Revaluaci&oacute;n</strong></td>
				</cfif>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Mes</strong></td>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Documento</strong></td>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Concepto</strong></td>
			</tr>
			<cfoutput>
				<tr>
					<td>#Placa#</td>
					<td>#Clase#</td>
					<td>#Descripcion#</td>
					<td>#NumberFormat(Valor, ",_.__")#</td>
					<td>#Vida_Util#</td>
					<cfif isdefined("url.chkveradq")>
					<td>#NumberFormat(Monto_Adq, ",_.__")#</td>
					</cfif>
					<cfif isdefined("url.chkvermej")>
					<td>#NumberFormat(Monto_Mej, ",_.__")#</td>
					</cfif>
					<cfif isdefined("url.chkverrev")>
					<td>#NumberFormat(Monto_Rev, ",_.__")#</td>
					</cfif>
					<cfif isdefined("url.chkverdepadq")>
					<td>#NumberFormat(Dep_Adq, ",_.__")#</td>
					</cfif>
					<cfif isdefined("url.chkverdepmej")>
					<td>#NumberFormat(Dep_Mej, ",_.__")#</td>
					</cfif>
					<cfif isdefined("url.chkverdeprev")>
					<td>#NumberFormat(Dep_Rev, ",_.__")#</td>
					</cfif>
					<td>#Mes#</td>
					<td>#Documento#</td>
					<td>#Concepto#</td>
				</tr>
				<cfset totalValorCF = totalValorCF + Valor>
			</cfoutput>
			<tr>
				<td colspan="2">&nbsp;</td>
				<td align="right"><strong>Total Centro Funcional #CentroF#:&nbsp;</strong></td>
				<td>#NumberFormat(totalValorCF, ",_.__")#</td>
			</tr>
			<cfset totalValorCat = totalValorCat + totalValorCF>
		</cfoutput>
			<tr>
				<td colspan="2">&nbsp;</td>
				<td align="right"><strong>Total Categor&iacute;a #Categoria#:&nbsp;</strong></td>
				<td>#NumberFormat(totalValorCat, ",_.__")#</td>
			</tr>
	</cfoutput>
	
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
</table>	

