<cfsavecontent variable="myQuery">
	<cfoutput>
		select a.Aplaca, 
		  	   a.Adescripcion, 
		  	   acat.ACcodigodesc as Categoria_Actual,
		  	   acla.ACcodigodesc as Clase_Actual,
			   
	  		   (select rtrim(cat1.ACcodigodesc)
			   	from TransaccionesActivos s1
				inner join ACategoria cat1
				   on cat1.Ecodigo 	= s1.Ecodigo
				  and cat1.ACcodigo = s1.ACcodigoori
		  		where s1.Aid       	= ta.Aid
			  	  and s1.TAperiodo 	= ta.TAperiodo 
			  	  and s1.TAmes     	= ta.TAmes 
			  	  and s1.TAid      	= ta.TAid
		  		) as Categoria_origen,
		  
				(select cla1.ACcodigodesc
		  			from TransaccionesActivos s1
					  inner join AClasificacion cla1
			  			on cla1.Ecodigo 	= s1.Ecodigo
				  		and cla1.ACcodigo 	= s1.ACcodigoori
				  		and cla1.ACid 		= s1.ACidori
		  		where s1.Aid 		= ta.Aid
			  	and  s1.TAperiodo 	= ta.TAperiodo 
			  	and  s1.TAmes 		= ta.TAmes 
			  	and s1.TAid 		= ta.TAid
		  		) as Clase_origen,

			   (select rtrim(cat1.ACcodigodesc)
		  			from TransaccionesActivos s1
						inner join ACategoria cat1
							on cat1.Ecodigo 	= s1.Ecodigo
							and cat1.ACcodigo 	= s1.ACcodigodest
		  		where s1.Aid 		= ta.Aid
			  	and  s1.TAperiodo 	= ta.TAperiodo
			  	and  s1.TAmes 		= ta.TAmes
			  	and s1.TAid 		= ta.TAid
		  		) as Categoria_destino,
	
				(select cla1.ACcodigodesc
					from TransaccionesActivos s1
						inner join AClasificacion cla1
							on cla1.Ecodigo 	= s1.Ecodigo
							and cla1.ACcodigo 	= s1.ACcodigodest
							and cla1.ACid 		= s1.ACiddest
				where s1.Aid 		= ta.Aid
				and  s1.TAperiodo 	= ta.TAperiodo
				and  s1.TAmes 		= ta.TAmes
				and s1.TAid 		= ta.TAid
			    ) as Clase_destino,

				s.AFSvaladq as montoAdquisicion,
				s.AFSvalmej as montoMejoras,
				s.AFSvalrev as montoRevaluacion,
				s.AFSdepacumadq as montoDepAdquisicion,
				s.AFSdepacummej as montoDepMejoras,
				s.AFSdepacumrev as montoDepRevaluacion,
				s.AFSvutiladq as vidaUtil, 	
				<cf_dbfunction name="concat" args="rtrim(ltrim(ofi.Oficodigo)),'-',rtrim(ltrim(ofi.Odescripcion))"> as Oficina
		
	from TransaccionesActivos ta
	
			inner join AFSaldos s
				on s.Aid		 = ta.Aid
				and s.Ecodigo	 = ta.Ecodigo
				and s.AFSperiodo = #url.periodo#
				and s.AFSmes 	 = #url.mes#
			
			inner join ACategoria acat
				on acat.ACcodigo = s.ACcodigo
			   and acat.Ecodigo  = s.Ecodigo
			
			inner join AClasificacion acla
				on acla.ACcodigo = s.ACcodigo
				and acla.ACid 	 = s.ACid
				and acla.Ecodigo = s.Ecodigo
				
			inner join Oficinas ofi
				on ofi.Ocodigo  = s.Ocodigo
				and ofi.Ecodigo = s.Ecodigo
			
			inner join Activos a
				on a.Aid=ta.Aid
				<cfif isdefined("url.ACcodigo") and len(trim(url.ACcodigo))>
					and a.ACcodigo = #url.ACcodigo#
				</cfif>
				<cfif isdefined("url.ACid") and len(trim(url.ACid))>
					and a.ACid = #url.ACid#
				</cfif>
	
	where ta.Ecodigo = #session.Ecodigo#
	and ta.IDtrans 	 = 6
	and ta.TAperiodo = #url.periodo#
	and ta.TAmes     = #url.mes#
	order by a.Aplaca, ta.TAfalta
	</cfoutput>
</cfsavecontent>

<cfif isdefined("url.exportar")>
		<cftry>
			<cfflush interval="16000">
			<cf_jdbcquery_open name="data" datasource="#session.DSN#">
			<cfoutput>#myquery#</cfoutput>
			</cf_jdbcquery_open>
		
			<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="ReporteCambios#session.Usucodigo#_#dateformat(now(),'dd/mm/yyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
		
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
		</cftry>
			<cf_jdbcquery_close>		
<cfelse>

	<cfquery name="rscantidad" datasource="#session.DSN#">
		select count(1) as total
		from TransaccionesActivos ta
		
		inner join AFSaldos s
		on s.Aid=ta.Aid
		and s.Ecodigo=ta.Ecodigo
		and s.AFSperiodo = #url.periodo#
		and s.AFSmes = #url.mes#
		
		inner join Activos a
		on a.Aid=ta.Aid
		and a.Ecodigo=ta.Ecodigo
		<cfif isdefined("url.ACcodigo") and len(trim(url.ACcodigo))>
			and a.ACcodigo = #url.ACcodigo#
		</cfif>
		<cfif isdefined("url.ACid") and len(trim(url.ACid))>
			and a.ACid = #url.ACid#
		</cfif>
		
		where ta.Ecodigo = #session.Ecodigo#
		and ta.IDtrans = 6
		and ta.TAperiodo = #url.periodo#
		and ta.TAmes = #url.mes#
	</cfquery>
	<cfif rscantidad.total GT 3001 >
		<cf_errorCode	code = "50115" msg = "La cantidad de activos a desplegar sobrepasa los 3000 registros. Reduzca los rangos en los filtros ó exporte a archivo. ">
		<cfabort>
	</cfif>

		<cfif not isdefined("url.imprimir") >
				<cf_templateheader template="#session.sitio.template#" title="Consulta de Transacciones de Cambio de Categor&iacute;a-Clase">
			</cfif>
			
			<cfset params = "&periodo=#url.periodo#&mes=#url.mes#" >
			<cfif isdefined("url.ACcodigo") and len(trim(url.ACcodigo))>
				<cfset params = params & "&ACcodigo=#url.ACcodigo#">
				
				<cfquery name="rsCat" datasource="#session.DSN#">
					select ACcodigodesc, ACdescripcion
					from ACategoria
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACcodigo#">
				</cfquery>
			</cfif>
			<cfif isdefined("url.ACcodigo") and len(trim(url.ACcodigo)) and isdefined("url.ACid") and len(trim(url.ACid))>
				<cfset params = params & "&ACid=#url.ACid#">
				<cfquery name="rsClas" datasource="#session.DSN#">
					select ACcodigodesc, ACdescripcion
					from AClasificacion
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACcodigo#">		
					and ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACid#">		
				</cfquery>
			</cfif>
			<cf_rhimprime datos="/sif/af/Reportes/transaccionCambio.cfm" paramsuri="#params#" >
			
			
			<!--- Encabezado del reporte --->
			<style type="text/css">
				.titulox {
					padding: 2px; 
					font-size:12px;
				}
				
				.letra1{
					font-size:11px;
				}	
			
				.letra2{
					font-size:11px;
					font-weight:bold;
				}	
				
			</style> 
			<cfoutput>
			
			<cfset mes = 'Enero,Febrero,marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>
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
				
				<tr><td align="center" ><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
				<tr><td align="center"><strong>Consulta de Transacciones de Cambio de Categor&iacute;a-Clase</strong></td></tr>
				<tr><td align="center"><strong>Per&iacute;odo:&nbsp;</strong> #url.periodo#</td></tr>
				<tr><td align="center"><strong>Mes:&nbsp;</strong>#ListGetAt(mes, url.mes)#</td></tr>	
				
				<cfif isdefined("rsCat")>
					<tr><td align="center"><strong>Categor&iacute;a:&nbsp;</strong>#trim(rsCat.ACcodigodesc)# - #rsCat.ACdescripcion#</td></tr>	
				</cfif>
				<cfif isdefined("rsClas")>
					<tr><td align="center"><strong>Categor&iacute;a:&nbsp;</strong>#trim(rsClas.ACcodigodesc)# - #rsClas.ACdescripcion#</td></tr>	
				</cfif>
				
			</table>
			</cfoutput>
			
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<!--- inicio reporte --->
						<br>
						<table width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr style="padding:10px;">
								<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong></td>
								<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong></td>
								<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong></td>
			
								<td class="letra2" style="padding:3px; border-bottom-style:solid; border-bottom-width:thin;" bgcolor="#CCCCCC" nowrap="nowrap" align="center" colspan="2">Origen</td>
								<td class="letra2" style="padding:3px; " bgcolor="#CCCCCC" nowrap="nowrap" align="center" >&nbsp;</td>
			
								<td class="letra2" style="padding:3px; border-bottom-style:solid; border-bottom-width:thin;" bgcolor="#CCCCCC" nowrap="nowrap" align="center" colspan="2">Destino</td>
								<td class="letra2" style="padding:3px; " bgcolor="#CCCCCC" nowrap="nowrap" align="center" >&nbsp;</td>
			
								<td class="letra2" style="padding:3px; border-bottom-style:solid; border-bottom-width:thin;" bgcolor="#CCCCCC" nowrap="nowrap" align="center" colspan="3">Montos</td>
								<td class="letra2" style="padding:3px; " bgcolor="#CCCCCC" nowrap="nowrap" align="center" >&nbsp;</td>
								<td class="letra2" style="padding:3px; border-bottom-style:solid; border-bottom-width:thin;" bgcolor="#CCCCCC" nowrap="nowrap" align="center" colspan="3">Montos Depreciaci&oacute;n</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" align="right" nowrap="nowrap"></td>
							</tr>
							<tr style="padding:10px;">
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap">Placa</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap">Descripci&oacute;n</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap">Oficina</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap">Categor&iacute;a</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap">Clase</td>
								<td class="letra2" style="padding:3px; " bgcolor="#CCCCCC" nowrap="nowrap" align="center" >&nbsp;</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap">Categor&iacute;a</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap">Clase</td>
								<td class="letra2" style="padding:3px; " bgcolor="#CCCCCC" nowrap="nowrap" align="center" >&nbsp;</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap">Adquisici&oacute;n</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap">Mejoras</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap">Revaluaci&oacute;n</td>
								<td class="letra2" style="padding:3px; " bgcolor="#CCCCCC" nowrap="nowrap" align="center" >&nbsp;</td>					
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" align="right" nowrap="nowrap">Adquisici&oacute;n</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" align="right" nowrap="nowrap">Mejoras</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" align="right" nowrap="nowrap">Revaluaci&oacute;n</td>
								<td class="letra2" style="padding:3px;" bgcolor="#CCCCCC" align="right" nowrap="nowrap">Vida Util</td>
							</tr>
							
						<cftry>
							<cf_jdbcquery_open name="data" datasource="#session.DSN#">
							<cfoutput>#myquery#</cfoutput>
							</cf_jdbcquery_open>
						
								<cfset total_general = 0 >
								<cfset total_1 = 0 >		<!--- total adquisicion --->
								<cfset total_2 = 0 >		<!--- total mejoras --->
								<cfset total_3 = 0 >		<!--- total revaluacion --->
								<cfset total_4 = 0 >		<!--- total dep adquisicion --->
								<cfset total_5 = 0 >		<!--- total dep mejoras --->
								<cfset total_6 = 0 >		<!--- total dep revaluacion --->			
								<cfset registros = 0 >
								
								<cfoutput query="data">
									<cfset registros = registros + 1 >
									<cfif registros neq 1 >
									</cfif>
									<tr>
										<td nowrap="nowrap" class="letra1">#Aplaca#</td>
										<td nowrap="nowrap" class="letra1">#Adescripcion#</td>
										<td nowrap="nowrap" class="letra1">#Oficina#</td>
										<td nowrap="nowrap" class="letra1" nowrap="nowrap">#Categoria_origen#</td>
										<td nowrap="nowrap" class="letra1">#Clase_origen#</td>
										<td nowrap="nowrap" align="right" class="letra1"></td>
										<td nowrap="nowrap" class="letra1">#Categoria_destino#</td>
										<td nowrap="nowrap" class="letra1">#Clase_destino#</td>
										<td nowrap="nowrap" align="right" class="letra1"></td>
										<td nowrap="nowrap" align="right" class="letra1">#LSNumberFormat(montoAdquisicion, ',9.00')#</td>
										<td nowrap="nowrap" align="right" class="letra1">#LSNumberFormat(montoMejoras, ',9.00')#</td>
										<td nowrap="nowrap" align="right" class="letra1">#LSNumberFormat(montoRevaluacion, ',9.00')#</td>
										<td nowrap="nowrap" align="right" class="letra1"></td>
										<td nowrap="nowrap" align="right" class="letra1">#LSNumberFormat(montoDepAdquisicion, ',9.00')#</td>
										<td nowrap="nowrap" align="right" class="letra1">#LSNumberFormat(montoDepMejoras, ',9.00')#</td>
										<td nowrap="nowrap" align="right" class="letra1">#LSNumberFormat(montoDepRevaluacion, ',9.00')#</td>
										<td nowrap="nowrap" align="right" class="letra1">#LSNumberFormat(vidaUtil, ',9.00')#</td>								
									</tr>
			
									<cfset total_1 = total_1 + montoAdquisicion>		<!--- total adquisicion --->
									<cfset total_2 = total_2 + montoMejoras>			<!--- total mejoras --->
									<cfset total_3 = total_3 + montoRevaluacion>		<!--- total revaluacion --->
									<cfset total_4 = total_4 + montoDepAdquisicion>		<!--- total dep adquisicion --->
									<cfset total_5 = total_5 + montoDepMejoras>			<!--- total dep mejoras --->
									<cfset total_6 = total_6 + montoDepRevaluacion>		<!--- total dep revaluacion --->
								</cfoutput>
								
								<!--- PINTA EL TOTAL DEL ULTIMO CENTRO FUNCIONAL --->
								<cfoutput>
								<cfif registros eq 0>
									<tr><td colspan="16" align="center">--- No se encontraron registros ---</td></tr>
								</cfif>
								</cfoutput>		
						<cfcatch type="any">
							<cf_jdbcquery_close>
							<cfrethrow>
						</cfcatch>
						</cftry>
							<cf_jdbcquery_close>
			
							<cfif registros gt 0>
								<cfoutput>
								<tr>
									<td colspan="9" class="letra2">Total</td>
									<td align="right" class="letra2">#LSNumberFormat(total_1, ',9.00')#</td>
									<td align="right" class="letra2">#LSNumberFormat(total_2, ',9.00')#</td>
									<td align="right" class="letra2">#LSNumberFormat(total_3, ',9.00')#</td>
									<td></td>
									<td align="right" class="letra2">#LSNumberFormat(total_4, ',9.00')#</td>
									<td align="right" class="letra2">#LSNumberFormat(total_5, ',9.00')#</td>
									<td align="right" class="letra2">#LSNumberFormat(total_6, ',9.00')#</td>
								</tr>
								</cfoutput>
			
								<tr><td>&nbsp;</td></tr>
								<tr><td colspan="16" align="center">--- Fin del Reporte ---</td></tr>
							</cfif>
						</table>
						<!--- fin reporte --->
			
					</td>
				</tr>	
				<cfif not isdefined("url.imprimir") >
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center"><input type="button" class="btnAnterior" name="Regresar" value="Regresar" onClick="javascript:location.href='transaccionCambio-filtro.cfm'"></td></tr>
				</cfif>
				
			</table>
			
			<cfif not isdefined("url.imprimir") >
				<cf_templatefooter template="#session.sitio.template#">
			</cfif>
</cfif>

