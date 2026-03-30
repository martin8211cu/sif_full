<cfsetting requesttimeout="3600">
<cfif isdefined('url.imprimir')>
	<cfif isdefined('url.periodoInicial') and not isdefined('form.periodoInicial')>
		<cfset form.periodoInicial = url.periodoInicial>
	</cfif>
	<cfif isdefined('url.periodoFinal') and not isdefined('form.periodoFinal')>
		<cfset form.periodoFinal = url.periodoFinal>
	</cfif>
	<cfif isdefined('url.mesInicial') and not isdefined('form.mesInicial')>
		<cfset form.mesInicial = url.mesInicial>
	</cfif>
	<cfif isdefined('url.mesFinal') and not isdefined('form.mesFinal')>
		<cfset form.mesFinal = url.mesFinal>
	</cfif>
	<cfif isdefined('url.ACcodigo') and not isdefined('form.ACcodigo')>
		<cfset form.ACcodigo = url.ACcodigo>
	</cfif>
	<cfif isdefined('url.ACid') and not isdefined('form.ACid')>
		<cfset form.ACid = url.ACid>
	</cfif>
	<cfif isdefined('url.Fechadesde') and not isdefined('form.Fechadesde')>
		<cfset form.Fechadesde = url.Fechadesde>
	</cfif>
	<cfif isdefined('url.Fechahasta') and not isdefined('form.Fechahasta')>
		<cfset form.Fechahasta = url.Fechahasta>
	</cfif>
	<cfif isdefined('url.Aplaca') and not isdefined('form.Aplaca')>
		<cfset form.Aplaca = url.Aplaca>
	</cfif>
</cfif>
		<cfset LvarFecha = ''>
		
	<cfif isdefined('url.CFcodigoinicio') and not isdefined('form.CFcodigoinicio')>
		<cfset form.CFcodigoinicio = url.CFcodigoinicio>
	</cfif>	
	<cfif isdefined('url.CFcodigofinal') and not isdefined('form.CFcodigofinal')>
		<cfset form.CFcodigofinal = url.CFcodigofinal>
	</cfif>	
	
	<cfif isdefined('url.CFDcodigoinicio') and not isdefined('form.CFDcodigoinicio')>
		<cfset form.CFDcodigoinicio = url.CFDcodigoinicio>
	</cfif>	
	<cfif isdefined('url.CFDcodigofinal') and not isdefined('form.CFDcodigofinal')>
		<cfset form.CFDcodigofinal = url.CFDcodigofinal>
	</cfif>	
	
	<cfset categoriaini = true >
<cfif len(trim(form.codigodesde)) eq 0 >
	<cfquery name="categoria" datasource="#session.DSN#">
		select min(ACcodigo) as inicio
		from ACategoria 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset form.codigodesde = categoria.inicio >
	<cfset categoriaini = false >
</cfif>

<cfset categoriafin = true >
<cfif len(trim(form.codigohasta)) eq 0 >
	<cfquery name="categoria" datasource="#session.DSN#">
		select max(ACcodigo) as hasta
		from ACategoria 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset form.codigohasta = categoria.hasta >
	<cfset categoriafin = false >
</cfif>
		<!---Descripcion de Categorias --->
<cfif isdefined("form.codigodesde") and len(trim(form.codigodesde))>
	<cfquery name="rsCat1" datasource="#session.DSN#">
		select ACdescripcion
		from ACategoria
		where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.codigodesde#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfif isdefined("form.codigohasta") and len(trim(form.codigohasta))>
	<cfquery name="rsCat2" datasource="#session.DSN#">
		select ACdescripcion
		from ACategoria
		where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.codigohasta#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>


<cfquery name="consulta" datasource="#session.dsn#">
	select  
	count(1) as cantidad
		from TransaccionesActivos ta
				inner join Activos act
				on act.Ecodigo = ta.Ecodigo
				and act.Aid = ta.Aid
				<cfif (isdefined("form.Aplaca") and len(trim(form.Aplaca)) gt 0)>
				and act.Aplaca = '#form.Aplaca#'
				</cfif>
				inner join CFuncional cf1 
				on cf1.CFid = ta.CFid 
			
				inner join Oficinas ofi
				on ofi.Ocodigo = cf1.Ocodigo
			    and ofi.Ecodigo = cf1.Ecodigo
				
				inner join ACategoria cat
				on cat.ACcodigo=act.ACcodigo
				and cat.Ecodigo=act.Ecodigo
				and cat.ACcodigo between #form.codigodesde# and #form.codigohasta#	
		
				inner join AClasificacion clas
				on clas.ACcodigo=act.ACcodigo
				and clas.Ecodigo=act.Ecodigo
				and clas.ACid = act.ACid
				
	where ta.Ecodigo = #session.ecodigo#
			and ta.IDtrans = 9
			
			 and (TAperiodo > #form.periodoInicial#
				or  (TAperiodo = #form.periodoInicial#
				and TAmes >= #form.MesInicial#))
			and (TAperiodo < #form.periodoFinal# 
				or  (TAperiodo = #form.periodoFinal# 
				and TAmes <= #form.MesFinal#))
	</cfquery>
<cfif consulta.cantidad gt 50000>
	<cf_errorCode	code = "50110" msg = "Los registros superan los 50000, agregue mas filtros">
<cfelse>
<cfsavecontent variable="myQuery">
	<cfoutput>
 		select Aplaca as Placa, Adescripcion as Descripcion, 
			(cat.ACcodigodesc) as Categoria, 
			(clas.ACcodigodesc) as Clase, 
			((select CFdescripcion from CFuncional where CFid= ta.CFiddest )) as Destino,
			((select CFdescripcion from CFuncional where CFid= ta.CFid )) as CFuncionalOrigen,
			{fn concat(ofi.Oficodigo, {fn concat('-', ofi.Odescripcion)} )} as OficinaOrigen,			
	
				coalesce(
				(Select ec1.Cconcepto
				 from HEContables ec1 
				 where ec1.IDcontable = ta.IDcontable),
				(Select ec1.Cconcepto 
				 from EContables ec1 
				 where ec1.IDcontable = ta.IDcontable) )
				 as Asiento,
			 
				 coalesce(
				(Select ec2.Edocumento
				 from HEContables ec2 
				 where ec2.IDcontable = ta.IDcontable),
				(Select ec2.Cconcepto 
				 from EContables ec2 
				 where ec2.IDcontable = ta.IDcontable) )
				 as Poliza,
		
			(select {fn concat(ofd.Oficodigo, {fn concat('-', ofd.Odescripcion)})} 
				from CFuncional cf3
						inner join Oficinas ofd
						 	on ofd.Ocodigo = cf3.Ocodigo
						   and ofd.Ecodigo = cf3.Ecodigo
				where cf3.CFid = ta.CFiddest
			) as OficinaDestino, 
			
			((select min(c.CRCCdescripcion) from TransaccionesActivos a
				inner join AFResponsables b
				on a.Aid = b.Aid
				inner join CRCentroCustodia c
				on b.CRCCid = c.CRCCid
				where a.Aid = ta.Aid
			)) as Centro_Custodia,

			TAfecha, 
			TAvaladq + TAvalmej as Valor,<!--- TAvaltot--->
			TAvalrev as Valor_Rev,
			TAdepacumadq + TAdepacummej as Dep_Acumulada,
			TAdepacumrev as Dep_Acumulada_Rev,
			TAvaladq + TAvalmej + TAvalrev - 
			TAdepacumadq - TAdepacummej - TAdepacumrev as Valor_Libros
				from TransaccionesActivos ta
				inner join Activos act
				on act.Ecodigo = ta.Ecodigo
				and act.Aid = ta.Aid
				<cfif (isdefined("form.Aplaca") and len(trim(form.Aplaca)) gt 0)>
				and act.Aplaca = '#form.Aplaca#'
				</cfif>
				inner join CFuncional cf1 
				on cf1.CFid = ta.CFid 
			
				inner join Oficinas ofi
				on ofi.Ocodigo = cf1.Ocodigo
			    and ofi.Ecodigo = cf1.Ecodigo
				
				inner join ACategoria cat
				on cat.ACcodigo=act.ACcodigo
				and cat.Ecodigo=act.Ecodigo
				and cat.ACcodigo between #form.codigodesde# and #form.codigohasta#	
		
				inner join AClasificacion clas
				on clas.ACcodigo=act.ACcodigo
				and clas.Ecodigo=act.Ecodigo
				and clas.ACid = act.ACid
				
				<cfif isdefined('form.ACidI') and LEN(TRIM(form.ACidI)) gt 0 and form.ACidI gt 0>
					and clas.ACid >= #form.ACidI#
				</cfif>
				<cfif isdefined('form.ACidF') and LEN(TRIM(form.ACidF)) gt 0 and form.ACidF gt 0>
					and clas.ACid <= #form.ACidF#
				</cfif>
<!---Codigos iniciales --->		
				<cfif len(trim(form.CFcodigofinal)) eq 0 and len(trim(form.CFDcodigofinal)) eq 0 
					and (isdefined('form.CFcodigoinicio') and len(trim(form.CFcodigoinicio)) gt 0 
				 	or isdefined ('form.CFDcodigoinicio') and len(trim(form.CFDcodigoinicio)) gt 0)>
						inner join CFuncional cf 
						on cf.CFid = ta.CFid 
				<cfif isdefined ('form.CFcodigoinicio') and len(trim(form.CFcodigoinicio)) gt 0 
					and len(trim(form.CFDcodigoinicio)) eq 0>
						and ta.CFid >= #form.CFidinicio#
				<cfelseif isdefined ('form.CFDcodigoinicio') and len(trim(form.CFDcodigoinicio)) gt 0 
					and len(trim(form.CFcodigoinicio)) eq 0>
						and ta.CFiddest >=  #form.CFDidinicio#
				</cfif>
			</cfif>
<!---Codigos finales--->					
				<cfif len(trim(form.CFcodigoinicio)) eq 0 and len(trim(form.CFDcodigoinicio)) eq 0 
					and (isdefined('form.CFcodigofinal') and len(trim(form.CFcodigofinal)) gt 0 
					or isdefined ('form.CFDcodigofinal') and len(trim(form.CFDcodigofinal)) gt 0)>
						inner join CFuncional cf 
						on cf.CFid = ta.CFid 
				<cfif isdefined ('form.CFcodigofinal') and len(trim(form.CFcodigofinal)) gt 0 
					and len(trim(form.CFDcodigofinal)) eq 0>
						and ta.CFid >= #form.CFidfinal#
				<cfelseif isdefined ('form.CFDcodigofinal') and len(trim(form.CFDcodigofinal)) gt 0 
				   and len(trim(form.CFcodigofinal)) eq 0>
						and ta.CFiddest >=  #form.CFDidfinal#
				</cfif>
			</cfif>
<!---En caso de que sean ambos--->		
				<cfif isdefined("form.CFcodigofinal") and len(trim(form.CFcodigofinal)) gt 0
					and  isdefined ("form.CFcodigoinicio")and len(trim(form.CFcodigoinicio)) gt 0
					or isdefined("form.CFDcodigoinicio")and len(trim(form.CFDcodigoinicio)) gt 0
	    			and isdefined ("form.CFDcodigofinal")and len(trim(form.CFDcodigofinal)) gt 0>
					  inner join CFuncional cf 
					  on cf.CFid = ta.CFid 
			   <cfif isdefined ("form.CFcodigoinicio") and len(trim(form.CFcodigoinicio)) gt 0
			   		and isdefined ("form.CFcodigofinal") and len(trim(form.CFcodigofinal)) gt 0
			   		and  isdefined ("form.CFDcodigoinicio") and len(trim(form.CFDcodigoinicio)) eq 0
					and isdefined ("form.CFDcodigofinal")and len(trim(form.CFDcodigofinal)) eq 0>
					   and ta.CFid between #form.CFidinicio# and #form.CFidfinal#
				<cfelseif isdefined ("form.CFcodigoinicio") and len(trim(form.CFcodigoinicio)) eq 0
					and isdefined ("form.CFcodigofinal") and len(trim(form.CFcodigofinal)) eq 0
					and  isdefined ("form.CFDcodigoinicio") and len(trim(form.CFDcodigoinicio)) gt 0
					and isdefined ("form.CFDcodigofinal")and len(trim(form.CFDcodigofinal)) gt 0>
					   and ta.CFiddest between #form.CFDidinicio# and #form.CFDidfinal#
				<cfelseif isdefined ("form.CFcodigoinicio") and len(trim(form.CFcodigoinicio)) gt 0
					and isdefined ("form.CFcodigofinal") and len(trim(form.CFcodigofinal)) gt 0
					and isdefined ("form.CFDcodigoinicio")and len(trim(form.CFDcodigoinicio)) gt 0
					and isdefined ("form.CFDcodigofinal")and len(trim(form.CFDcodigofinal)) gt 0>
					   and ta.CFid between #form.CFidinicio# and #form.CFidfinal#
					   and ta.CFiddest between #form.CFDidinicio# and #form.CFDidfinal#
				</cfif>
			</cfif>

			where ta.Ecodigo = #session.ecodigo#
			and ta.IDtrans = 9
			
			 and (TAperiodo > #form.periodoInicial#
				or  (TAperiodo = #form.periodoInicial#
				and TAmes >= #form.MesInicial#))
			and (TAperiodo < #form.periodoFinal# 
				or  (TAperiodo = #form.periodoFinal# 
				and TAmes <= #form.MesFinal#))
			
			<cfif (isdefined("form.Fechadesde") and len(trim(form.Fechadesde)) gt 0)
				and not (isdefined("form.Fechahasta") and len(trim(form.Fechahasta)) gt 0)>
					and ta.TAfecha >= '#LSDateFormat(form.Fechadesde,'YYYYMMDD')#'
			<cfelseif not(isdefined("form.Fechadesde") and len(trim(form.Fechadesde)) gt 0)
				and (isdefined("form.Fechahasta") and len(trim(form.Fechahasta)) gt 0)>
					and ta.TAfecha <= '#LSDateFormat(form.Fechahasta,'YYYYMMDD')#'
			<cfelseif (isdefined("form.Fechadesde") and len(trim(form.Fechadesde)) gt 0)
				and (isdefined("form.Fechahasta") and len(trim(form.Fechahasta)) gt 0)>
					and ta.TAfecha between '#LSDateFormat(form.Fechadesde,'YYYYMMDD')#'
					and '#LSDateFormat(form.Fechahasta,'YYYYMMDD')#'
			</cfif>
		order by CFuncionalOrigen, Aplaca
	</cfoutput>
</cfsavecontent>
</cfif>

<cfset mes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<cfif isdefined("url.imprimir")>
	<tr>
		<td align="right">
			<table width="10%" align="right" border="0" height="25px">
				<tr><td>Usuario:</td><td>#session.Usulogin#</td></tr>
				<tr><td>Fecha:</td><td>#LSDateFormat(now(), 'dd/mm/yyyy')#</td></tr>
			</table>
		</td>
	</tr>
	</cfif>
	
	<tr><td align="center"><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
	<tr><td align="center"><strong>Reporte de Cambios de Centro Funcional por Periodo Mes</strong></td></tr>
	<tr><td align="center"><strong>Per&iacute;odo/Mes Inicial :</strong> #form.periodoInicial#/#ListGetAt(mes, form.mesInicial)#</td></tr>	
	<tr><td align="center"><strong>Per&iacute;odo/Mes Final:</strong> #form.periodoFinal#/#ListGetAt(mes, form.mesFinal)#</td></tr>	
	<tr><td align="right" style="width:1%"><cfoutput><strong>Usuario:#session.usulogin#</strong></cfoutput></td>
		</td>
	
	<cfif (isdefined("form.ACcodigo") and len(trim(form.ACcodigo)) gt 0)>
		<cfquery name="rsCat" datasource="#session.DSN#">
			select ACdescripcion
			from ACategoria
			where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<tr><td align="center"><strong>Categor&iacute;a : </strong>#rsCat.ACdescripcion#</td></tr>
	</cfif>
	<cfif (isdefined("form.ACcodigo") and len(trim(form.ACcodigo)) gt 0)
	and (isdefined("form.ACid") and len(trim(form.ACid)) gt 0)>
		<cfquery name="rsClas" datasource="#session.DSN#">
			select ACdescripcion
			from AClasificacion
			where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">
			  and ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<tr><td align="center"><strong>Clase : </strong>#rsClas.ACdescripcion#</td></tr>
	</cfif>
	
	<cfif (isdefined("form.Fechadesde") and len(trim(form.Fechadesde)) gt 0)
		and not (isdefined("form.Fechahasta") and len(trim(form.Fechahasta)) gt 0)>
			<tr><td align="center"><strong>Desde : </strong>#LSDateFormat(form.Fechadesde,'DD/MM/YYYY')#</td></tr>
	<cfelseif not(isdefined("form.Fechadesde") and len(trim(form.Fechadesde)) gt 0)
		and (isdefined("form.Fechahasta") and len(trim(form.Fechahasta)) gt 0)>
			<tr><td align="center"><strong>Hasta : </strong>#LSDateFormat(form.Fechahasta,'DD/MM/YYYY')#</td></tr>
	<cfelseif (isdefined("form.Fechadesde") and len(trim(form.Fechadesde)) gt 0)
		and (isdefined("form.Fechahasta") and len(trim(form.Fechahasta)) gt 0)>
			<tr><td align="center"><strong>Desde : </strong>#LSDateFormat(form.Fechadesde,'DD/MM/YYYY')#<strong> Hasta :</strong>#LSDateFormat(form.Fechahasta,'DD/MM/YYYY')#</td></tr>
	</cfif>
	
	<cfif (isdefined("form.Aplaca") and len(trim(form.Aplaca)) gt 0)>
		<tr><td align="center"><strong>Placa : </strong>#form.Aplaca#</td></tr>
	</cfif>
</table>
<br />
</cfoutput>
<table width="100%" border="0" cellpadding="2" cellspacing="0">
	 <tr style="padding:10px;">
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Placa</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Descripci&oacute;n</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Categor&iacute;a</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Clase</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Centro Funcional Origen</td>		
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Centro Funcional Destino</td>		
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Oficina Origen</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Oficina Destino</td>
		
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Fecha</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Valor</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Valor Rev.</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Dep. Acumulada</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Dep. Acumulada Rev.</td>	
	
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Asiento.</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Poliza</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Centro de Custodia</td>	
			
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Valor Libros</td>
	</tr>
<cftry>
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>
	
	<cfset registros = 0 >
	<!--- totales generales --->
	<cfset GTAvaltot = 0 >
	<cfset GTAvaltotrev = 0 >	
	<cfset GTAdepacumtot = 0 >
	<cfset GTAdepacumtotrev = 0 >
	<cfset GTAvallibros = 0 >

	<cfoutput query="data" group="CFuncionalOrigen">
		<cfset registros = registros + 1 >
		<cfif registros neq 1 >
			<tr>
				<td colspan="9"><strong>Total Centro Funcional #trim(vCFuncionalOrigen)#</strong></td>
				<td align="right"><strong>#LSNumberFormat(CFTAvaltot, ',9.00')#</td>
				<td align="right"><strong>#LSNumberFormat(CFTAvaltotrev, ',9.00')#</td>
				
				<td align="right"><strong>#LSNumberFormat(CFTAdepacumtot, ',9.00')#</td>
				<td align="right"><strong>#LSNumberFormat(CFTAdepacumtotrev, ',9.00')#</td>
				
				<td align="right"><strong>&nbsp;</td>			
				<td align="right"><strong>&nbsp;</td>
				<td align="right"><strong>&nbsp;</td>	
				
				<td align="right"><strong>#LSNumberFormat(CFTAvallibros, ',9.00')#</td>
			</tr>
			<tr><td>&nbsp;</td></tr>	
		</cfif>

		<cfset vCFuncionalOrigen = CFuncionalOrigen>
		<cfset CFTAvaltot = 0 >
		<cfset CFTAvaltotrev = 0 >		
		<cfset CFTAdepacumtot = 0 >
		<cfset CFTAdepacumtotrev = 0 >
		<cfset CFTAvallibros = 0 >
		
		<tr><td class="tituloListas" colspan="20">#trim(CFuncionalOrigen)#</td></tr>
		<cfoutput>
			<tr>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Placa#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Descripcion#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Categoria#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Clase#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#CFuncionalOrigen#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Destino#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#OficinaOrigen#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#OficinaDestino#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#LSDateFormat(TAfecha,'dd/mm/yyyy')#</td>
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(Valor, ',9.00')#</td>
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(Valor_Rev, ',9.00')#</td>				
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(Dep_Acumulada, ',9.00')#</td>
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(Dep_Acumulada_Rev, ',9.00')#</td>		
				<td  align="right" style="padding:3px;font-size:9px">#Asiento#</td>
				<td  align="right" style="padding:3px;font-size:9px">#Poliza#</td>
				<td  nowrap="nowrap" style="padding:3px;font-size:9px">#Centro_Custodia#</td>
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat( Valor_Libros, ',9.00')#</td>
			</tr>			
			<cfset CFTAvaltot = CFTAvaltot + LSNumberFormat(Valor, '9.00')>
			<cfset CFTAvaltotrev = CFTAvaltotrev + LSNumberFormat(Valor_Rev, '9.00')>			
			<cfset CFTAdepacumtot = CFTAdepacumtot + LSNumberFormat(Dep_Acumulada, '9.00')>
			<cfset CFTAdepacumtotrev = CFTAdepacumtotrev + LSNumberFormat(Dep_Acumulada_Rev, '9.00')>			
			<cfset CFTAvallibros = CFTAvallibros + LSNumberFormat( Valor_Libros, '9.00')>
			<cfset GTAvaltot = GTAvaltot + LSNumberFormat(Valor, '9.00')>
			<cfset GTAvaltotrev = GTAvaltotrev + LSNumberFormat(Valor_Rev, '9.00')>			
			<cfset GTAdepacumtot = GTAdepacumtot + LSNumberFormat(Dep_Acumulada, '9.00')>
			<cfset GTAdepacumtotrev = GTAdepacumtotrev + LSNumberFormat(Dep_Acumulada_Rev, '9.00')>
			<cfset GTAvallibros = GTAvallibros + LSNumberFormat( Valor_Libros, '9.00')>
		</cfoutput>
	</cfoutput>
	
	<cfif isdefined("form.exportar")>
	<cftry>
			<!--- <cfset registros = 0 > --->
			<cfflush interval="16000">
			<cf_jdbcquery_open name="data" datasource="#session.DSN#">
			<cfoutput>#myQuery#</cfoutput>
			</cf_jdbcquery_open>
			<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Traslados_#session.Usucodigo#_#dateformat(now(),'dd/mm/yyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
		<cf_jdbcquery_close>		
	</cfif>
	
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
</cftry>
	<cf_jdbcquery_close>
	
	<cfif registros gt 0 >
	<!--- TOTAL DE ULTIMO CENTRO FUNCIONAL --->
		<cfoutput>
		<tr>
			<td colspan="9"><strong>Total Centro Funcional #trim(vCFuncionalOrigen)#</strong></td>
			<td align="right"><strong>#LSNumberFormat(CFTAvaltot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(CFTAvaltotrev, ',9.00')#</td>			
			<td align="right"><strong>#LSNumberFormat(CFTAdepacumtot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(CFTAdepacumtotrev, ',9.00')#</td>	
			<td align="right"><strong>&nbsp;</td>			
			<td align="right"><strong>&nbsp;</td>
			<td align="right"><strong>&nbsp;</td>	
			<td align="right"><strong>#LSNumberFormat(CFTAvallibros, ',9.00')#</td>
		</tr>
		<tr><td>&nbsp;</td></tr>	
	
		<tr>
			<td colspan="9"><strong>Total General</strong></td>
			<td align="right"><strong>#LSNumberFormat(GTAvaltot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(GTAvaltotrev, ',9.00')#</td>			
			<td align="right"><strong>#LSNumberFormat(GTAdepacumtot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(GTAdepacumtotrev, ',9.00')#</td>	
			<td align="right"><strong>&nbsp;</td>			
			<td align="right"><strong>&nbsp;</td>
			<td align="right"><strong>&nbsp;</td>	
			<td align="right"><strong>#LSNumberFormat(GTAvallibros, ',9.00')#</td>
		</tr>
		</cfoutput>
	<cfelse>
		<tr><td colspan="30" align="center">--- No se encontraron registros ---</td></tr>
	</cfif>

	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="30" align="center">--- Fin del Reporte ---</td></tr>
	<tr><td>&nbsp;</td></tr>	
</table>

