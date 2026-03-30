<cfif isdefined ('url.DLlinea') and len(trim(url.DLlinea)) gt 0 and not isdefined('form.DLlinea')>
	<cfset form.DLlinea=url.DLlinea>
</cfif>
<!---Consultas para la liquidación--->
<cfquery name="rsRHLiqIngresos" datasource="#session.DSN#">
	select	a.DLlinea, a.DEid, a.RHLPfecha, a.fechaalta,
	b.RHLPid, b.RHLPdescripcion as nombre, b.fechaalta,
	c.CIcodigo, c.CIdescripcion,
	case when d.DDCcant is null then b.importe else d.DDCimporte end as importe,
	coalesce(d.DDCres,0) as Resultado, 
	coalesce(d.DDCcant,0) as Cantidad
	from RHLiquidacionPersonal a

	  inner join RHLiqIngresos b
		on  a.Ecodigo = b.Ecodigo
		and a.DEid = b.DEid
		and a.DLlinea = b.DLlinea

	  inner join CIncidentes c
		on  b.CIid = c.CIid
		and b.Ecodigo = c.Ecodigo
	
	  left outer join DDConceptosEmpleado d
		on d.CIid = c.CIid
		and d.DLlinea = a.DLlinea
		
	where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
	  and b.RHLPautomatico = 1

	order by 2
</cfquery>

<cfquery name="rsDetalleRHLiquidacionPersonal" datasource="#session.DSN#">
	select    rhta.RHTdesc,	 dle.DLfvigencia as DLfechaaplic, eve.EVfantig, dle.DEid
	 from DLaboralesEmpleado  dle
	  inner join RHTipoAccion rhta
		on  dle.Ecodigo = rhta.Ecodigo
		and dle.RHTid = rhta.RHTid
	  inner join EVacacionesEmpleado eve
	    on  dle.DEid = eve.DEid 
	where dle.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and dle.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
</cfquery>
<cfquery name="rsSumRHLiqIngresosAutom" datasource="#session.DSN#">
	select sum(importe) as totIngresos 
	from RHLiqIngresos
	where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#"> 
	  and RHLPautomatico = 1
 </cfquery> 
 
<!---Querys para verificar los recalculos existentes que ya fueron aplicados--->
<cfquery name="rsEncR" datasource="#session.dsn#">
	select RHLRLid, DLlinea,Ecodigo,
		   DEid,RHLRPestado,RHLRPfecha,
		   BMUsucodigo,fechaalta ,RHRLdif
	from RHRLiqPersonal
	where DLlinea=#form.DLlinea#
	and Ecodigo=#session.Ecodigo#
	and RHLRPestado=1
</cfquery>
<!---Querys para verificar los recalculos existentes que no han sido aplicados--->
<cfquery name="rsEncR1" datasource="#session.dsn#">
	select RHLRLid, DLlinea,Ecodigo,
		   DEid,RHLRPestado,RHLRPfecha,
		   BMUsucodigo,fechaalta ,RHRLdif
	from RHRLiqPersonal
	where DLlinea=#form.DLlinea#
	and Ecodigo=#session.Ecodigo#
	and RHLRPestado=0
</cfquery>

<table width="100%">
<cfoutput>
<form name="form1" action="recalculo-sql.cfm" method="post">
<cfif isdefined ('form.DEid') and len(trim(form.DEid)) gt 0>
	<input type="hidden" name="DEid" value="#form.DEid#" />
</cfif>
<cfif isdefined ('form.DLlinea') and len(trim(form.DLlinea)) gt 0>
	<input type="hidden" name="DLlinea" value="#form.DLlinea#" />
</cfif>
<cfif isdefined ('rsDetalleRHLiquidacionPersonal.DLfechaaplic') and len(trim(rsDetalleRHLiquidacionPersonal.DLfechaaplic)) gt 0>
	<input type="hidden" name="FVigencia" value="#rsDetalleRHLiquidacionPersonal.DLfechaaplic#" />
</cfif>

<!---Datos empleados--->
	<tr>
		<td>
			<cfinclude template="/rh/portlets/pEmpleado.cfm">
		</td>
	</tr>
	<tr>
		<td class="#Session.preferences.Skin#_thcenter" align="center">
			<strong>Datos de Liquidación</strong>
		</td>
	</tr>
<!---Datos de la liquidacion original--->
	<tr>
		<td>
			<cfloop query="rsDetalleRHLiquidacionPersonal">
			<table align="center" width="100%" border="0">
				<tr>
					<td align="right" ><strong><cf_translate key="LB_Tipo_de_Accion" xmlfile="/rh/generales.xml">Tipo de Acci&oacute;n</cf_translate>:</strong></td>
					<td colspan="3" >&nbsp;#rsDetalleRHLiquidacionPersonal.RHTdesc#</td>
				</tr>
				<tr>
					<td width="35%" align="right"><strong><cf_translate key="LB_Fecha_de_Accion" >Fecha de Acción</cf_translate>:</strong></td>
					<td width="15%">&nbsp;#LSDateFormat(rsDetalleRHLiquidacionPersonal.DLfechaaplic,'dd/mm/yyyy')#</td>
					<td width="15%" align="right" nowrap="nowrap"><strong><cf_translate key="LB_Fecha_de_Ingreso" xmlfile="/rh/generales.xml" >Fecha de Ingreso</cf_translate>:</strong></td>	
					<td width="35%">&nbsp;#LSDateFormat(rsDetalleRHLiquidacionPersonal.EVfantig,'dd/mm/yyyy')#</td>
				</tr>
				<tr>
					<td colspan="4" align="center">
						<table align="center" width="75%" border="0">
							<tr>
								<cfset ylaborados = DateDiff('yyyy',rsDetalleRHLiquidacionPersonal.EVfantig,rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
								<cfset mlaborados = DateDiff('m',DateAdd('yyyy',ylaborados,rsDetalleRHLiquidacionPersonal.EVfantig),rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
								<cfset dlaborados = DateDiff('d',DateAdd('m',mlaborados,DateAdd('yyyy',ylaborados,rsDetalleRHLiquidacionPersonal.EVfantig)),rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
								<td width="20%" align="right" nowrap="nowrap"><strong><cf_translate key="LB_Anos" xmlfile="/rh/generales.xml">Años</cf_translate>:</strong></td>
								<td width="10%">#ylaborados#</td>
								<td width="20%" align="right" nowrap="nowrap"><strong><cf_translate key="LB_Meses" xmlfile="/rh/generales.xml">Meses</cf_translate>:</strong></td>
								<td width="10%">#mlaborados#</td>
								<td width="15%" align="right" nowrap="nowrap"><strong><cf_translate key="LB_Dias" xmlfile="/rh/generales.xml">D&iacute;as</cf_translate>:</strong></td>
								<td width="25%">#dlaborados#</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</cfloop>
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width="75%" border="0" cellpadding="0" cellspacing="0">
				<!--- ENCABEZADO --->
				<tr class="TituloListas">
					<td><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
					<td align="right"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
					<td align="right"><cf_translate key="LB_Monto">Monto</cf_translate></td>
					<td align="right"><cf_translate key="LB_Total">Total</cf_translate></td>
				</tr>
				<cfset LvarT=0>
				<cfloop query="rsRHLiqIngresos">
				<cfset LvarT=LvarT+rsRHLiqIngresos.resultado>
					<tr>
						<td>#rsRHLiqIngresos.nombre#</td>
						<td align="right"><cfif cantidad EQ 0><div align="center">-</div><cfelse>#rsRHLiqIngresos.cantidad#</cfif></td>
						<td align="right"><cfif cantidad EQ 0><div align="center">-</div><cfelse>#LsCurrencyFormat(rsRHLiqIngresos.importe,'none')#</cfif></td>
						<td align="right"><cfif cantidad EQ 0>#LsCurrencyFormat(rsRHLiqIngresos.importe,'none')#<cfelse>#LsCurrencyFormat(rsRHLiqIngresos.resultado,'none')#</cfif></td>
					</tr>
				</cfloop>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="4" align="right">
						<strong>Total</strong>:#LsCurrencyFormat(LvarT,'none')#
					</td>
				</tr>	
				<cfset v_hayrenta = false >
				<cfif isdefined("rsRHLiquidacionPersonal") and len(trim(rsRHLiquidacionPersonal.renta)) and rsRHLiquidacionPersonal.renta gt 0 >
					<tr>
						<td><cf_translate key="LB_Renta">Renta</cf_translate></td>
						<td align="right">0.00</td>
						<td align="right">#LsCurrencyFormat(rsRHLiquidacionPersonal.renta,'none')#</td>
						<td align="right">#LsCurrencyFormat(rsRHLiquidacionPersonal.renta,'none')#</td>
					</tr>
					<cfset v_hayrenta = true >
				</cfif>
				
				<cfif rsRHLiqIngresos.RecordCount EQ 0 and not v_hayrenta >
					<tr><td colspan="4" align="center"><cf_translate key="LB_NoHayConceptosRelacionados">No hay conceptos relacionados.</cf_translate></td></tr>
				</cfif>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<cf_botones names="Recalcular" values="Recalcular">
		</td>
	</tr>
	<cfif isdefined ('url.error') and len(trim(url.error)) gt 0>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
			<font color="CC0033">No aplica recalculo de Liquidación</font>
		</td>
	</tr>
	</cfif>
<!---Recalculo de liquidacion--->
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<cfif rsEncR.recordcount gt 0>
				<cfloop query="rsEncR">
					<cfquery name="rsDetR" datasource="#session.dsn#">
						select  a.DLlinea,
								a.DEid,
								a.CIid,
								a.Ecodigo,
								a.RHRLPdescripcion,
								a.importe,
								a.BMUsucodigo,
								a.fechaalta,
								a.cantidad,
								a.resultado,
								c.CIdescripcion
						from RHRLiqIngresos a
							inner join CIncidentes c
							on a.CIid=c.CIid
						where DLlinea=#form.DLlinea#
						and a.Ecodigo=#session.Ecodigo#
						and RHLRLid=#rsEncR.RHLRLid#
					</cfquery>	
					  <cfset id = rsEncR.RHLRLid>		
					<table width="100%" border="0" cellspacing="0" cellpadding="0">					
						<tr bgcolor="##E4E4E4">
							<td height="20" class="fileLabel" nowrap>
							<img  id="menos#id#" 
							style="display:none;"  
							src="../../imagenes/menos.gif" 
							onclick="javascript: document.getElementById('TR#id#').style.display='none'; document.getElementById('mas#id#').style.display=''; document.getElementById('menos#id#').style.display='none'; "/>
							
							<img id="mas#id#"							
							src="../../imagenes/mas.gif" 
							onclick="javascript: document.getElementById('TR#id#').style.display=''; document.getElementById('menos#id#').style.display=''; document.getElementById('mas#id#').style.display='none'; "/>
							<strong>Recalculo Fecha:#LSDateFormat(rsEncR.fechaalta,'DD/MM/YYYY')#</strong>
							</td>
						</tr>	
						
						 <tr id="TR#id#" style="display:none">
						 	<td>
								<table align="center" width="75%" border="0" cellpadding="0" cellspacing="0">
								<!--- ENCABEZADO --->
								<tr class="TituloListas">
									<td><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
									<td align="right"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
									<td align="right"><cf_translate key="LB_Monto">Monto</cf_translate></td>
									<td align="right"><cf_translate key="LB_Total">Total</cf_translate></td>
								</tr>
								<cfloop query="rsDetR">
									<tr>
										<td>#rsDetR.CIdescripcion#</td>
										<td align="right">#rsDetR.cantidad#</td>
										<td align="right">#LsCurrencyFormat(rsDetR.importe,'none')#</td>
										<td align="right">#LsCurrencyFormat(rsDetR.resultado,'none')#</td>
									</tr>
								</cfloop>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="4" align="right">
										<strong>Total</strong>:#LsCurrencyFormat(rsEncR.RHRLdif,'none')#
									</td>
								</tr>	
								<tr><td>&nbsp;</td></tr>
								</table>
							</td>
						 </tr>
				</cfloop>
			</cfif>
		</td>
	</tr>	
	
<!---Recalculo de liquidacion sin aplicar--->
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td class="#Session.preferences.Skin#_thcenter" align="center">
			<strong>Recalculo de Liquidación</strong>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<cfif rsEncR1.recordcount gt 0>
					<cfquery name="rsDetR" datasource="#session.dsn#">
						select  a.DLlinea,
								a.DEid,
								a.CIid,
								a.Ecodigo,
								a.RHRLPdescripcion,
								a.importe,
								a.BMUsucodigo,
								a.fechaalta,
								a.cantidad,
								a.resultado,
								c.CIdescripcion
						from RHRLiqIngresos a
							inner join CIncidentes c
							on a.CIid=c.CIid
						where DLlinea=#form.DLlinea#
						and a.Ecodigo=#session.Ecodigo#
						and RHLRLid=#rsEncR1.RHLRLid#
					</cfquery>	
					<input type="hidden" name="RHLRLid" value="#rsEncR1.RHLRLid#" />
					<table align="center" width="75%" border="0" cellpadding="0" cellspacing="0">
						<!--- ENCABEZADO --->
						<tr class="TituloListas">
							<td><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
							<td align="right"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
							<td align="right"><cf_translate key="LB_Monto">Monto</cf_translate></td>
							<td align="right"><cf_translate key="LB_Total">Total</cf_translate></td>
						</tr>
						<cfloop query="rsDetR">
							<tr>
								<td>#rsDetR.CIdescripcion#</td>
								<td align="right">#rsDetR.cantidad#</td>
								<td align="right">#LsCurrencyFormat(rsDetR.importe,'none')#</td>
								<td align="right">#LsCurrencyFormat(rsDetR.resultado,'none')#</td>
							</tr>
						</cfloop>	
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center" colspan="4">
								<cf_botones names="btnAplicar" values="Aplicar">
							</td>
						</tr>
					</table>
			</cfif>
		</td>
	</tr>	
</cfoutput>
</form>
</table>
				
	