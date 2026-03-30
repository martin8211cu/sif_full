<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DiasPlaneados" default = "d&iacute;as planeados" returnvariable="LB_DiasPlaneados" xmlfile = "Tab6_Comision.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_UnDiaPlaneado" default = "Un d&iacute;a planeado" returnvariable="LB_UnDiaPlaneado" xmlfile = "Tab6_Comision.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Desde" default = "Desde" returnvariable="LB_Desde" xmlfile = "Tab6_Comision.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Hasta" default = "Hasta" returnvariable="LB_Hasta" xmlfile = "Tab6_Comision.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Modificar" default = "Modificar" returnvariable="BTN_Modificar" xmlfile = "Tab6_Comision.xml">


<cfoutput>
<form name="frmComision" action="LiquidacionAnticipos_sql.cfm?tipo=#LvarSAporEmpleadoSQL#" method="post" onsubmit="sbValidarComsion()">
<table cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td align="right">
			<strong><cf_translate key = LB_NumComision xmlfile="Tab6_Comision.xml">Num. Comision</cf_translate>:&nbsp;</strong>
		</td>
		<td>
			<input type="text" value="#rsGEcomision.GECnumero#" style="border:none" size="12" />
			<input type="hidden" name="GELid" value="#HTMLEditFormat(rsForm.GELid)#">
			<input type="hidden" name="GECid_comision" value="#LvarGECid_comision#">
		</td>
		<td align="right">
			<strong><cf_translate key = LB_Descripcion xmlfile="Tab6_Comision.xml">Descripción</cf_translate>:&nbsp;</strong>
		</td>
		<td>
			<input type="text" name="GECdescripcion" value="#rsGEcomision.GECdescripcion#" size="60" maxlength="50" tabindex="1"/>
		</td>
	</tr>
	<tr>				
		<!---Centro Funcional --->					
		<td align="right">
			<strong><cf_translate key = LB_CentroFuncional xmlfile="Tab6_Comision.xml">Centro&nbsp;Funcional</cf_translate>:&nbsp;</strong>					
		</td>
		<td colspan="1">
			<input type="text" name="CFuncional" value="#trim(rsGEcomision.CFcodigo)# - #trim(rsGEcomision.CFdescripcion)# (Oficina: #trim(rsGEcomision.Oficodigo)#)" disabled="disabled" size="55" style="border:solid 1px ##CCCCCC"/>
		 </td>
		<td align="right">
			<strong><cf_translate key = LB_Planeado xmlfile="Tab6_Comision.xml">Planeado</cf_translate>:&nbsp;</strong>
		</td>
		<td>
			<input type="text" value="#LB_Desde# #dateFormat(rsGEcomision.GECdesdePlan,"DD/MM/YYYY")# #LB_Hasta# #dateFormat(rsGEcomision.GEChastaPlan,"DD/MM/YYYY")#  #datediff("d",rsGEcomision.GECdesdePlan,rsGEcomision.GEChastaPlan)+1# #LB_DiasPlaneados#" style="border:none" size="60" readonly tabindex="-1"/>
		</td>
	</tr>
	<tr>
		<!---Empleado--->
		<td align="right">
			<strong><cf_translate key = LB_Empleado xmlfile="Tab6_Comision.xml">Empleado</cf_translate>:&nbsp;</strong>
		</td>
		<td colspan="1">
			<input type="text" name="CFuncional" value="#trim(rsGEcomision.DEidentificacion)# - #trim(rsGEcomision.DEnombre	)#" disabled="disabled" size="55" style="border:solid 1px ##CCCCCC"/>
		 </td>
		<td align="right">
			<strong><cf_translate key = LB_Tipo xmlfile="Tab6_Comision.xml">Tipo</cf_translate>:&nbsp;</strong>
		</td>
		<td>
			<select name="GECtipo" tabindex="1" disabled="disabled">
				<option value="1"<cfif rsGEcomision.GECtipo EQ 1> selected</cfif>><cf_translate key = LB_Nacional xmlfile="Tab6_Comision.xml">Nacional</cf_translate></option>
				<option value="2"<cfif rsGEcomision.GECtipo EQ 2> selected</cfif>><cf_translate key = LB_Exterior xmlfile="Tab6_Comision.xml">Exterior</cf_translate></option>
			</select>
			&nbsp;&nbsp;
			<input type="checkbox" name="GECautomovil" value="1" <cfif rsGEcomision.GECautomovil EQ 1>checked</cfif> tabindex="1"><cf_translate key = LB_Automovil xmlfile="Tab6_Comision.xml">Automóvil</cf_translate>
			&nbsp;&nbsp;
			<input type="checkbox" name="GEChotel" value="1" <cfif rsGEcomision.GEChotel EQ 1>checked</cfif> tabindex="1"><cf_translate key = LB_Hotel xmlfile="Tab6_Comision.xml">Hotel</cf_translate>
			&nbsp;&nbsp;
			<input type="checkbox" name="GECavion" value="1" <cfif rsGEcomision.GECavion EQ 1>checked</cfif> tabindex="1"><cf_translate key = LB_Avion xmlfile="Tab6_Comision.xml">Avión</cf_translate>
		</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td align="left" valign="top"><strong><cf_translate key = LB_Observaciones xmlfile="Tab6_Comision.xml">Observaciones</cf_translate>:&nbsp;</strong></td>
		<td>&nbsp;&nbsp;&nbsp;</td>
		<td align="left" valign="top"><strong><cf_translate key = LB_Resultados xmlfile="Tab6_Comision.xml">Resultados</cf_translate>:&nbsp;</strong></td>
		<td>&nbsp;&nbsp;&nbsp;</td>
		<td align="left" valign="top"><strong><cf_translate key = LB_JustificacionExcesos xmlfile="Tab6_Comision.xml">Justificación de Excesos</cf_translate>:&nbsp;</strong></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<textarea onkeypress="if (this.value.length >= 255) return false;" cols="40" rows="4" name="GECobservacionesLiq" tabindex="1">#rsGEcomision.GECobservacionesLiq#</textarea>
		</td>
		<td>&nbsp;&nbsp;&nbsp;</td>
		<td>
			<textarea onkeypress="if (this.value.length >= 255) return false;" cols="40" rows="4" name="GECobservacionesResultado" tabindex="1">#rsGEcomision.GECobservacionesResultado#</textarea>
		</td>
		<td>&nbsp;&nbsp;&nbsp;</td>
		<td>
			<textarea onkeypress="if (this.value.length >= 255) return false;" cols="40" rows="4" name="GECobservacionesExceso" tabindex="1">#rsGEcomision.GECobservacionesExceso#</textarea>
		</td>
	</tr>
	<tr>
		<td colspan="10" align="center">
			<input type="submit" name="btnDatosComision" value="#BTN_Modificar#">
		</td>
	</tr>
</table>
</form>
<script language="javascript">
	function sbValidarComsion()
	{
		if (document.frmComision.GECdescripcion.value == "")
			document.frmComision.GECdescripcion.value = "#rsGEcomision.GECdescripcion#";
	}
</script>
</cfoutput>
