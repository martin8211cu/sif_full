<cfif isdefined('url.TAmes') and not isdefined('form.TAmes')>
	<cfset form.TAmes = url.TAmes>
</cfif>
<cfif isdefined('url.TAperiodo') and not isdefined('form.TAperiodo')>
	<cfset form.TAperiodo = url.TAperiodo>
</cfif>
<cfif isdefined('url.TAfecha') and not isdefined('form.TAfecha')>
	<cfset form.TAfecha = url.TAfecha>
</cfif>					
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
<cfquery name="rsQuery" datasource="#session.dsn#">
	select 	rtrim(b.Aplaca) as Placa,
			rtrim(b.Adescripcion) as Descripcion, 
			coalesce(a.TAmontolocmej,0)  as Monto,
			a.TAfecha,
			a.TAmes, 
			a.TAperiodo,
			c.ACcodigodesc as Categoria,
			d.AFCcodigoclas as Clase,
			e.CFcodigo as CFuncional,
			f.Oficodigo as Oficina,
			coalesce(a.TAvutil,0) as TAvutil
			
	from TransaccionesActivos a

		inner join Activos b
			on a.Aid = b.Aid
			and a.Ecodigo = b.Ecodigo

		inner join ACategoria c
				on b.ACcodigo = c.ACcodigo
				and b.Ecodigo = c.Ecodigo

			inner join AFClasificaciones d
				on b.AFCcodigo = d.AFCcodigo
				and b.Ecodigo = d.Ecodigo
		
		inner join CFuncional e
			on a.CFid = e.CFid
			and a.Ecodigo = e.Ecodigo

			inner join Oficinas f
				on e.Ocodigo = f.Ocodigo
				and e.Ecodigo = f.Ecodigo
				
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		and a.IDtrans = 2
		<cfif isdefined("form.TAmes") and len(trim(form.TAmes))>
			and a.TAmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TAmes#">
		</cfif>
		<cfif isdefined("form.TAperiodo") and len(trim(form.TAperiodo))>
			and a.TAperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TAperiodo#">
		</cfif>		
		<cfif isdefined("form.TAfecha") and len(trim(form.TAfecha))>
			and a.TAfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TAfecha)#">
		</cfif>
	order by b.Aplaca, b.Adescripcion	
</cfquery>
<cfset HoraReporte = Now()> 
<table width="100%"  border="0" cellspacing="0" cellpadding="0"> 
  <tr>
	<td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr class="areaFiltro">
				<td colspan="3" align="center"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>
			  </tr>			
			  <tr>
				<td colspan="3" align="center">&nbsp;</td>
			  </tr>				  
			  <tr>
				<td colspan="3" align="center"><span class="style1">Lista de Transacciones de Mejoras Aplicadas</span></td>
			  </tr>
			  <cfif isdefined("form.TAmes") and len(trim(form.TAmes)) and isdefined("form.TAperiodo") and len(trim(form.TAperiodo))>
				 <cfoutput>
					  <tr>
						<td colspan="3" align="center"><font size="3"><strong>Per&iacute;odo:</strong>&nbsp;#form.TAperiodo#&nbsp;&nbsp;<strong>Mes:</strong>&nbsp;#form.TAmes#</font></td>
					  </tr>
				  </cfoutput>
			  </cfif>			 
			  <tr>
				<td colspan="3" align="center"><cfoutput><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></cfoutput></td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
			  <tr>
				<td>
					<cfif isdefined('url.imprimir')>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="10%" valign="top"><strong>Placa</strong></td>
								<td width="35%" valign="top"><strong>Descripci&oacute;n</strong></td>
								<td width="5%" align="center" valign="top"><strong>Categor&iacute;a</strong></td>
								<td width="5%" align="center" valign="top"><strong>Clase</strong></td>
								<td width="11%" align="center" valign="top"><strong>Ctro.Funcional</strong></td>
								<td width="5%" align="center" valign="top"><strong>Oficina</strong></td>
								<td width="6%" align="center" valign="top"><strong>Fecha</strong></td>
								<td width="14%" align="right" valign="top"><strong>Mto.Mejoras</strong></td>
								<td width="15%" align="right" valign="top"><strong>Vida &uacute;til</strong></td>
							</tr>
							<cfoutput query="rsQuery">
								<tr>
									<td valign="top" width="10%">#rsQuery.Placa#</td>
									<td valign="top" width="35%">#rsQuery.Descripcion#</td>
									<td align="center" valign="top" width="5%">#rsQuery.Categoria#</td>
									<td align="center" valign="top"  width="5%">#rsQuery.Clase#</td>
									<td align="center" valign="top" width="11%">#rsQuery.Cfuncional#</td>
									<td align="center" valign="top" width="5%">#rsQuery.Oficina#</td>
									<td align="center" valign="top" width="6%">#LSDateFormat(rsQuery.TAfecha,'dd/mm/yyyy')#</td>
									<td align="right" valign="top" width="14%">#LSNumberFormat(rsQuery.Monto,',9.00')#</td>
									<td align="right" valign="top" width="15%">#LSNumberFormat(rsQuery.TAvutil,',9.00')#</td>
								</tr>
							</cfoutput>														
						</table>
					<cfelse>
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRHRet">
							<cfinvokeargument name="query" value="#rsQuery#"/>
							<cfinvokeargument name="desplegar" value="Placa, Descripcion, Categoria, Clase, Cfuncional, Oficina, TAfecha, Monto, TAvutil"/>
							<cfinvokeargument name="etiquetas" value="Placa, Descripci&oacute;n, Categoría, Clase, Ctro.Funcional, Oficina, Fecha, Mto.Mejoras, Vida útil"/>
							<cfinvokeargument name="totales" value="Monto"/>
							<cfinvokeargument name="showLink" value="false"/>
							<cfinvokeargument name="formatos" value="S,S,S,S,S,S,D,M,M"/>
							<cfinvokeargument name="align" value="left, left, center, center, center, center, left, right, right"/>							
							<cfinvokeargument name="ajustar" value="S"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="botones" value="Regresar"/>
						</cfinvoke>
					</cfif>						
				</td>
			  </tr>	
			  <tr><td>&nbsp;</td></tr>				
		</table>		
	</td>
  </tr>
</table>
<script type="text/javascript" language="javascript1.2">
	function funcRegresar(){
		location.href = 'repMejorasAplicadas.cfm';
		return false;
	}
</script>