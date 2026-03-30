<cfquery name="rsObra" datasource="#Session.DSN#">
Select PRJPOcodigo, PRJPOdescripcion, PRJPOcliente, PRJPOlugar, PRJPOnumero
from PRJPobra
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
  and PRJPOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPOid#">
</cfquery>

<!--- --Todas las areas de una Obra --->
<cfquery name="rsAreasObras" datasource="#Session.DSN#">
Select B.PRJPAcodigo, B.PRJPAdescripcion
from PRJPobra A, PRJPobraArea B
where A.PRJPOid  = B.PRJPOid
   and A.Ecodigo    = B.Ecodigo
   and A.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
   and A.PRJPOid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPOid#">
</cfquery>

<cfset TOBRA = rsObra.PRJPOdescripcion>

<style type="text/css">
	.color{
		color:#FF0000;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<table width="98%" cellpadding="0" cellspacing="0" align="center">
<!--- encabezado --->
<tr><td>&nbsp;</td></tr>
<tr>
	<td>
		<cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0" border="0" style="border:1px solid black">			
			<tr><td width="6%" align="left"><strong>Cliente:</strong></td><td width="72%" align="left"><strong>#rsObra.PRJPOcliente#</strong></td><td width="22%" align="right">#dateformat(now(),"dd/mm/yyyy")#</td>
			<tr><td align="left"><strong>Obra:</strong></td><td align="left" colspan="2"><strong>#rsObra.PRJPOdescripcion#</strong></td>
			<tr><td width="6%" align="left"><strong>Lugar:</strong></td><td align="left" width="72%"><strong>#rsObra.PRJPOlugar#</strong></td><td width="22%" align="right">Presupuesto No. #rsObra.PRJPOnumero#</td>
			</tr>
		</table> 
		</cfoutput>
	</td>
</tr>
<!--- consulta --->
<tr><td>&nbsp;</td></tr>
<tr><td colspan="3" align="center"><strong><font size="3">Presupuesto</font></strong></td></tr>
<tr><td>&nbsp;</td></tr>
<tr>
	<td>
	
		<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<cfset cortepry = ''>	
			<tr class="tituloListas">
				<td align="left" nowrap><strong>CÃ³digo</strong></td>
				<td align="left"><strong>Concepto</strong></td>
				<td align="right"><strong>Unidad</strong></td>
				<td align="right"><strong>Cantidad</strong></td>
				<td align="right"><strong>P. Unitario</strong></td>
				<td align="right"><strong>Importe</strong></td>				
			</tr>
		
			<cfif rsAreasObras.RecordCount gt 0>
	
				<cfset total_obra = 0 >
				<cfloop query="rsAreasObras">
			
					<cfset total_area = 0 >
					<cfset tituloarea = #PRJPAdescripcion#>
					<cfset codigoarea = #PRJPAcodigo#>
					<tr><td><strong>#codigoarea#</strong></td><td colspan="5"><strong>#tituloarea#</strong></td></tr>
					
					<!--- --Todas las Actividades de un Area --->
					<cfquery name="rsActividadesAreas" datasource="#Session.DSN#">
					Select B.PRJPACcodigo, B.PRJPACdescripcion
					from PRJPobraArea A,  PRJPobraActividad B
					where A.PRJPAid   = B.PRJPAid
					   and A.Ecodigo    = B.Ecodigo
					   and B.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					   and A.PRJPAid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoarea#">  
					</cfquery>
					
					<cfloop query="rsActividadesAreas">
					
						<cfset total_actividad = 0 >
						<cfset tituloactividad = #PRJPACdescripcion#>
						<cfset codigoactividad = #PRJPACcodigo#>	
						<tr><td><strong>#codigoactividad#</strong></td><td colspan="5"><strong>#tituloactividad#</strong></td></tr>
						
						<!--- --Todos los Productos de una Actividad --->
						<cfquery name="rsProductosActividades" datasource="#Session.DSN#">
						Select C.PRJPPcodigo,       C.PRJPPdescripcion, C.Ucodigo, B.PRJPPcantidad,
							   C.PRJPPcostoDirecto, C.PRJPPporcentajeIndirecto
						from PRJPobraActividad A, PRJPobraProducto B, PRJPproducto C
						where A.PRJPACid = B.PRJPACid
						   and  A.Ecodigo   = B.Ecodigo
						   and  B.PRJPPid   = C.PRJPPid
						   and  B.Ecodigo   = C.Ecodigo
						   and B.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						   and A.PRJPACid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoactividad#">
						 </cfquery>					
						 
						 <cfloop query="rsProductosActividades">
						 	
							<!--- 
							Calculo del PUnitario 
							Calculo del Importe
							--->
							<cfset Cindirecto = rsProductosActividades.PRJPPcostoDirecto * (rsProductosActividades.PRJPPporcentajeindirecto/100)>
						 	<cfset Punit = Cindirecto + rsProductosActividades.PRJPPcostoDirecto>
							<cfset Importe = Punit * rsProductosActividades.PRJPPcantidad>
							
							<tr style="cursor:hand;" class="<cfif rsProductosActividades.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td nowrap>#rsProductosActividades.PRJPPcodigo#</td>
								<td nowrap>#rsProductosActividades.PRJPPdescripcion#</td>
								<td align="right">#rsProductosActividades.Ucodigo#</td>
								<td align="right">#rsProductosActividades.PRJPPcantidad# %</td>
								<td align="right">#LSCurrencyFormat(Punit,'none')#</td>
								<td align="right">#LSCurrencyFormat(Importe,'none')#</td>
							</tr>						 
						 
						 	<cfset total_actividad = total_actividad + Importe>
						 </cfloop>	
						 
						 <!--- Totalisa Actividad --->
						 <tr class="topline"><td class="topline" colspan="5" align="right"><strong>Total #tituloactividad#:</strong></td><td class="topline" align="right"><strong>#LSCurrencyFormat(total_actividad,'none')#</strong></td></tr>
						 <cfset total_area = total_area + total_actividad>
					</cfloop>	
					<!--- Totalisa Area --->
					<tr class="topline"><td class="topline" colspan="5" align="right"><strong>Total #tituloarea#:</strong></td><td class="topline" align="right"><strong>#LSCurrencyFormat(total_area,'none')#</strong></td></tr>
					<cfset total_obra = total_obra + total_area>
				</cfloop>	
				<!--- Totalisa Obra --->
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr class="topline"><td class="topline" colspan="5" align="right"><strong>Total #TOBRA#:</strong></td><td class="topline" align="right"><strong>#LSCurrencyFormat(total_obra,'none')#</strong></td></tr>
							
			<cfelse>
				<tr class="tituloListas">
					<td colspan="6" align="center" width="1%" nowrap><strong>No se encontraron registros</strong></td>
				</tr>
			</cfif>
		</table>
		</cfoutput>
		
	</td>
</tr>
<tr><td>&nbsp;</td></tr>
</table>
