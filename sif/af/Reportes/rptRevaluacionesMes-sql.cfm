<cfquery name="GetMonthNames" datasource="#session.dsn#">
	select VSdesc as MonthName
	from VSidioma v
		inner join Idiomas i
		on i.Iid = v.Iid
		and i.Icodigo = '#session.Idioma#'
	where v.VSgrupo = 1
	order by <cf_dbfunction name="to_number" args="VSvalor">
</cfquery>
<CFSET listMeses = ValueList(GetMonthNames.MonthName)>

<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
}
.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }
-->
</style>

<cfinclude template="rptRevaluacionesMes-query.cfm">
<cfquery name="rsQuery" datasource="#session.dsn#">
	#preservesinglequotes(consulta_reporte)#
</cfquery>

<table width="100%"  border="0" cellspacing="0" cellpadding="0"> 
  <tr>
    <td colspan="4">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr class="areaFiltro">
				<td colspan="4" align="center"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>
			  </tr>			
			  <tr>
				<td colspan="4" align="center">&nbsp;</td>
			  </tr>				  
			  <tr>
				<td colspan="4" align="center"><span class="style1">Lista de Transacciones de Revaluaci&oacute;n</span></td>
			  </tr>
			<cfif isdefined('url.Periodo') and  len(trim(url.Periodo)) gt 0 and url.Periodo gt 0
				and isdefined('url.Mes') and  len(trim(url.Mes)) gt 0 and url.Mes gt 0>
				  <tr>
					<td colspan="4" align="center"><span class="style1"><cfoutput>Periodo #url.Periodo# / Mes #ListGetAt(listMeses,url.Mes)#</cfoutput></span></td>
				  </tr>
			</cfif>
			<cfif isdefined('url.ACcodigodesde') and len(trim(url.ACcodigodesde)) gt 0 and url.ACcodigodesde gt 0>
				<cfquery name="rsCategoriadesde" datasource="#session.dsn#">
					select ACcodigodesc, ACdescripcion from ACategoria 
					where Ecodigo =  #session.ecodigo# 
					and ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ACcodigodesde#">
				</cfquery>
				<tr>
					<td colspan="4" align="center"><span class="style1"><cfoutput>Desde la Categor&iacute;a #rsCategoriadesde.ACcodigodesc# - #rsCategoriadesde.ACdescripcion#</cfoutput></span></td>
				</tr>
			</cfif>
			<cfif isdefined('url.ACcodigohasta') and len(trim(url.ACcodigohasta)) gt 0 and url.ACcodigohasta gt 0>
				<cfquery name="rsCategoriahasta" datasource="#session.dsn#">
					select ACcodigodesc, ACdescripcion from ACategoria 
					where Ecodigo =  #session.ecodigo# 
					and ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ACcodigohasta#">
				</cfquery>
				<tr>
					<td colspan="4" align="center"><span class="style1"><cfoutput>Hasta la Categor&iacute;a #rsCategoriahasta.ACcodigodesc# - #rsCategoriahasta.ACdescripcion#</cfoutput></span></td>
				</tr>
			</cfif>
			<cfif isdefined('url.Ocodigodesde') and len(trim(url.Ocodigodesde)) gt 0 and url.Ocodigodesde gt 0>
				<cfquery name="rsOficinadesde" datasource="#session.dsn#">
					select Oficodigo, Odescripcion from Oficinas
					where Ecodigo =  #session.ecodigo# 
					and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigodesde#">
				</cfquery>
				<tr>
					<td colspan="4" align="center"><span class="style1"><cfoutput>Desde la Oficina #rsOficinadesde.Oficodigo# - #rsOficinadesde.Odescripcion#</cfoutput></span></td>
				</tr>
			</cfif>
			<cfif isdefined('url.Ocodigohasta') and len(trim(url.Ocodigohasta)) gt 0 and url.Ocodigohasta gt 0>
				<cfquery name="rsOficinahasta" datasource="#session.dsn#">
					select Oficodigo, Odescripcion from Oficinas
					where Ecodigo =  #session.ecodigo# 
					and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigohasta#">
				</cfquery>
				<tr>
					<td colspan="4" align="center"><span class="style1"><cfoutput>Hasta la Oficina #rsOficinahasta.Oficodigo# - #rsOficinahasta.Odescripcion#</cfoutput></span></td>
				</tr>
			</cfif>
			  <tr>
				<td colspan="4" align="center"><cfoutput><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</font></cfoutput></td>
			  </tr>		
			  <tr><td colspan="4">&nbsp;</td></tr>					
			  <tr>
			  	<td colspan="4">
					<cfif isdefined('url.imprimir')>	
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRHRet">
							<cfinvokeargument name="query" value="#rsQuery#"/>
							<cfinvokeargument name="cortes" value="CFuncional, Categoria, Clase"/>
							<cfinvokeargument name="desplegar" value="PlacaSinRepetir, ActivoSinRepetir, TipoMonto, Adquisicion, Mejoras, Revaluacion, MontoTotal, Indice, MontoRevaluacion"/>
							<cfinvokeargument name="etiquetas" value="Placa, Descripci&oacute;n, , Monto Adquisici&oacute;n, Monto Mejoras, Monto Revaluaci&oacute;n, Monto Total, &Iacute;ndice, Monto Revaluaci&oacute;n"/>
							<cfinvokeargument name="formatos" value="S, S, S, M, M, M, M, S, M"/>
							<cfinvokeargument name="align" value="left, left, left, right, right, right, right, right, right"/>
							<cfinvokeargument name="showLink" value="false"/>
							<cfinvokeargument name="MaxRows" value="0"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
						</cfinvoke>	
						<br />
						<table width="100%">
						  <tr>
							<td align="center"> -- Fin del Reporte -- </td>
						  </tr>
						</table>
					<cfelse>
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRHRet">
							<cfinvokeargument name="query" value="#rsQuery#"/>
							<cfinvokeargument name="cortes" value="CFuncional, Categoria, Clase"/>
							<cfinvokeargument name="desplegar" value="PlacaSinRepetir, ActivoSinRepetir, TipoMonto, Adquisicion, Mejoras, Revaluacion, MontoTotal, Indice, MontoRevaluacion"/>
							<cfinvokeargument name="etiquetas" value="Placa, Descripci&oacute;n, , Monto Adquisici&oacute;n, Monto Mejoras, Monto Revaluaci&oacute;n, Monto Total, &Iacute;ndice, Monto Revaluaci&oacute;n"/>
							<cfinvokeargument name="formatos" value="S, S, S, M, M, M, M, S, M"/>
							<cfinvokeargument name="align" value="left, left, left, right, right, right, right, right, right"/>
							<cfinvokeargument name="showLink" value="false"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>			
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
						</cfinvoke>	
					</cfif> 				
				</td>
			</tr>
		</table>		
	</td>
  </tr>
</table>