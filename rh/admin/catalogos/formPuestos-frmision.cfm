<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio") or isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>


<cfif modo eq 'ALTA'>
	<cf_translate key="MSG_DebeSeleccionarUnPuestoParaVerEstaOpcion">Debe seleccionar un Puesto para ver esta opción</cf_translate>.
	<cfabort>
</cfif>

<!--- Consultas --->

<!--- Form --->
<cfquery name="rsForm" datasource="#session.DSN#">
	select a.RHTPid, coalesce(a.RHPcodigoext, a.RHPcodigo) as RHPcodigoext, a.RHPcodigo, a.RHPdescpuesto, a.RHOcodigo, 
				b.RHOdescripcion, a.RHTPid, c.RHTPdescripcion,d.ts_rversion,   d.RHDPmision
	from RHPuestos a left outer join  RHOcupaciones b
		on  (a.RHOcodigo = b.RHOcodigo) left outer join RHTPuestos c
		on (a.RHTPid = c.RHTPid) left outer join RHDescriptivoPuesto d 
		on (a.Ecodigo = d.Ecodigo and 
			   a.RHPcodigo = d.RHPcodigo)
	where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">		
</cfquery>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="form1" method="post" action="SQLPuestos-frmision.cfm">
<cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td align="right" width="20%"></td>
      <td align="left" width="80%"></td>
    </tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr> 
      <td align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</strong></td>
	  <td align="left">
		#Trim(rsForm.RHPcodigoext)#
	  </td>
    </tr>
    <tr>
      <td align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</strong></td>
      <td align="left">#rsForm.RHPdescpuesto#</td>
    </tr>
    <tr>
      <td colspan="2" align="right">&nbsp;</td>
    </tr>
	<tr> 
      <td align="left" colspan="2">
 		<cfif isdefined('rsForm.RHDPmision') and len(trim(rsForm.RHDPmision)) gt 0>
			<cf_rheditorhtml name="Texto" value="#Trim(rsForm.RHDPmision)#" tabindex="1"> 
		<cfelse>
			<cf_rheditorhtml name="Texto" tabindex="1"> 
		</cfif>
      </td>
    </tr>	
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center">
			<table width="0%" align="center"  border="0" cellspacing="0" cellpadding="0" class="ayuda">
			  <tr><td colspan="5">&nbsp;&nbsp;</td></tr>
			  <tr>
				<td>&nbsp;&nbsp;</td>
				<td>
					<cfif isdefined("Aprobacion") and len(trim(Aprobacion)) and Aprobacion eq 'A'>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Actualizar"
							Default="Actualizar"
							XmlFile="/rh/generales.xml"
							returnvariable="BTN_Actualizar"/>
						<input type="submit" name="Cambio" value="#BTN_Actualizar#" tabindex="1">
					</cfif>
				</td>
				<td>&nbsp;&nbsp;</td>
				<cfif isdefined("Aprobacion") and len(trim(Aprobacion)) and Aprobacion eq 'A'>
					<td><cf_translate key="MSG_PresioneEsteBotonParaActualizarLaInformacionModificada">Presione este bot&oacute;n para actualizar <br>la informaci&oacute;n modificada</cf_translate>.</td>
				<cfelse>
					<td><cf_translate key="MSG_ParaPoderAgregarOModificarLaMisionDebeDeRealizarloDesdeElPerfilIdealDelPuesto">Para poder agregar o modificar la misi&oacute;n debe de realizarlo desde el perfil ideal del puesto</cf_translate>.</td>
				</cfif>
				
				<td>&nbsp;&nbsp;</td>
			  </tr>
			  <tr><td colspan="5">&nbsp;&nbsp;</td></tr>
			</table>
		</td>
	</tr>
	<cfset ts = "">	
	<cfif modo neq "ALTA">
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
	</cfinvoke>
	</cfif>
	<tr>
	  <td colspan="2">
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHPcodigo" id="RHPcodigo" value="#Trim(rsForm.RHPcodigo)#">
	  </td>
	</tr>
  </table>
</cfoutput>
</form>
