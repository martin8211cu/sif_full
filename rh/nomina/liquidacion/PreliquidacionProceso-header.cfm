

<cfquery name="rsRHLiqIngresosPrev" datasource="#session.DSN#">
	select	a.RHPLPid, a.DEid, a.RHPLPfecha, a.RHPLPfsalida,
	b.RHLPPid, b.RHLPdescripcion as nombre, b.fechaalta,
	c.CIcodigo, c.CIdescripcion,
	case when d.RHCAPLcant is null then b.importe else d.RHCAiPLmporte end as importe,
	coalesce(d.RHCAPLres,0) as Resultado, 
	coalesce(d.RHCAPLcant,0) as Cantidad
    
	from RHPreLiquidacionPersonal a

	  inner join RHLiqIngresosPrev b
		on  a.Ecodigo = b.Ecodigo
		and a.DEid = b.DEid
		and a.RHPLPid = b.RHPLPid

	  inner join CIncidentes c
		on  b.CIid = c.CIid
		and b.Ecodigo = c.Ecodigo
	
	  left outer join RHConceptosAccionPreLiq d
		on d.CIid = c.CIid
		and d.RHPLPid = a.RHPLPid
		
	where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
	  and b.RHLPautomatico = 1

	order by 2
</cfquery>

<!---
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
--->

<cfquery name="rsSumRHLiqIngresosAutom" datasource="#session.DSN#">
	select sum(importe) as totIngresos 
	from RHLiqIngresosPrev
	where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#"> 
	  and RHLPautomatico = 1
  </cfquery> 
  
<script language="javascript" type="text/javascript">
	<!--//
		function funcSiguiente(){
			if (document.form1.paso){
				var vpaso = parseInt(document.form1.paso.value) + 1;
				document.form1.paso.value = vpaso;
				if (window.deshabilitarValidacion) deshabilitarValidacion();
			}
		}
		function funcAnterior(){
			if (document.form1.paso)
				var vpaso = parseInt(document.form1.paso.value) - 1;
				document.form1.paso.value = vpaso;
				if (window.deshabilitarValidacion) deshabilitarValidacion();
		}
	//-->
</script>


<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td width="1%" align="right">
		<img src="/cfmx/rh/imagenes/number#Gpaso#_64.gif" border="0">
	</td>
	<td style="padding-left: 10px;" valign="top">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Gdescpasos[Gpaso+1]#</strong></td>
		  </tr>
		  <cfif isdefined("rsRHLiquidacionPersonal")>
		  <tr>
			<td class="ayuda" align="left" nowrap><strong><cf_translate key="LB_Liquidando">Liquidando</cf_translate>:</strong> <font color="##003399"><strong>#rsRHLiquidacionPersonal.DEidentificacion# &nbsp;- &nbsp;#rsRHLiquidacionPersonal.nombre#</strong></font></td>
		  </tr>
		  </cfif>
		</table>
	</td>
  </tr>
  <cfif Gpaso GT 0>
  <tr>
    <td colspan="2">
		<cfinclude template="/rh/portlets/pEmpleado.cfm">
	</td>
  </tr>
  <tr>
    <td colspan="2" align="center">
		<table align="center" width="100%"  style="border :1px solid gray" cellpadding="0" cellspacing="5">
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
						<cfloop query="rsRHLiqIngresos">
							<tr>
								<td>#rsRHLiqIngresos.nombre#</td>
								<td align="right"><cfif cantidad EQ 0><div align="center">-</div><cfelse>#rsRHLiqIngresos.cantidad#</cfif></td>
								<td align="right"><cfif cantidad EQ 0><div align="center">-</div><cfelse>#LsCurrencyFormat(rsRHLiqIngresos.importe,'none')#</cfif></td>
								<td align="right"><cfif cantidad EQ 0>#LsCurrencyFormat(rsRHLiqIngresos.importe,'none')#<cfelse>#LsCurrencyFormat(rsRHLiqIngresos.resultado,'none')#</cfif></td>
							</tr>
						</cfloop>
						
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
			<tr><td>&nbsp;</td></tr>
		</table>
	</td>
  </tr>
	<tr>
		<td align="center" colspan="2">
			<table style="background-color:##f5f5f5;" class="areaFiltro" align="center" width="100%" cellspacing="0" cellpadding="3">
				<tr><td bgcolor="##E8E8E8"><strong><cf_translate key="MSG_Recalculo_de_Liquidacion_de_Personal">Recalculo de Liquidaci&oacute;n de Personal</cf_translate></strong></td></tr>
				<tr><td><cf_translate key="MSG_MensajeRecalculo">El bot&oacute;n de Recalcular, le permite volver a realizar los c&aacute;lculos para un Concepto espec&iacute;fico, el cual debe ser definido  en Par&aacute;metros del Sistema. Este Concepto debe ser de tipo C&aacute;lculo  y debe estar incluido en esta liquidaci&oacute;n.</cf_translate></td></tr>

				<cfinvoke component="sif.Componentes.Translate"
						  method="Translate"
						  Key="BTN_Recalcular"
						  Default="Recalcular"
						  XmlFile="/rh/generales.xml"
						  returnvariable="vRecalcular"/>
				<cfif isdefined("url.DLlinea") and len(trim(url.DLlinea)) and not isdefined("form.DLlinea")>
					<cfset form.DLlinea = url.DLlinea >
				</cfif>
				<cfif not isdefined("form.DLlinea")>
					<cfset form.DLlinea = 0 >
				</cfif>
				<cfquery name="rs_empleado" datasource="#session.DSN#">
					select DEid
					from RHLiquidacionPersonal
					where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
				</cfquery>
				
				<tr>
					<td align="center">
						<form style="margin:0;" action="#CurrentPage#" method="post">
							<input type="submit" class="btnFiltrar" name="btnRecalcular" value="#vRecalcular#" />
							<input type="hidden" name="DLlinea" value="#form.DLlinea#" />
							<input type="hidden" name="DEid" value="#rs_empleado.DEid#" />
							<input type="hidden" name="paso" value="1">
						</form>
					</td>
				</tr>
			</table>
		</td>
	</tr>  


  </cfif>
</table>
</cfoutput>