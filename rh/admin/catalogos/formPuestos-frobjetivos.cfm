<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio") or isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
	<cfset modo1="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo1")>
		<cfset modo1="ALTA">
	<cfelseif form.modo1 EQ "CAMBIO">
		<cfset modo1="CAMBIO">
	<cfelse>
		<cfset modo1="ALTA">
	</cfif>
</cfif>

<cfif modo1 eq 'ALTA'>
	<cf_translate key="MSG_DebeSeleccionarUnPuestoParaVerEstaOpcion">Debe seleccionar un Puesto para ver esta opción</cf_translate>.
	<cfabort>
</cfif>

<!--- Consultas --->

<!--- Form --->
<cfquery name="rsForm" datasource="#session.DSN#">
	select a.RHTPid, coalesce(a.RHPcodigoext, a.RHPcodigo) as RHPcodigoext,a.RHPcodigo, a.RHPdescpuesto, a.RHOcodigo, 
            b.RHOdescripcion, a.RHTPid, c.RHTPdescripcion,d.ts_rversion,d.RHDPobjetivos
	from RHPuestos a left outer join  RHOcupaciones b
		on  (a.RHOcodigo = b.RHOcodigo) left outer join RHTPuestos c
		on (a.RHTPid = c.RHTPid) left outer join RHDescriptivoPuesto d 
		on (a.Ecodigo = d.Ecodigo and 
			   a.RHPcodigo = d.RHPcodigo)
	where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 and a.RHPcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">		
		
</cfquery>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="formResp" method="post" action="SQLPuestos-frobjetivos.cfm">
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
		  <td align="right" width="20%"></td>
		  <td align="left" width="80%"></td>
		</tr>
    	<tr><td colspan="2">&nbsp;</td></tr>
    	<tr><td colspan="2">&nbsp;</td></tr>
    	<tr> 
			<td align="right"><strong><cf_translate key="LB_CodigoPuesto">C&oacute;digo de Puesto</cf_translate>:&nbsp;</strong></td>
			<td align="left">#Trim(rsForm.RHPcodigoext)#</td>
    	</tr>
    	<tr>
      		<td align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</strong></td>
      		<td align="left">#rsForm.RHPdescpuesto# </td>
    	</tr>
    	<tr><td colspan="2">&nbsp;</td></tr>
      <td align="left" colspan="2">
	  	
 		<cfif isdefined('rsForm.RHDPobjetivos') and len(trim(rsForm.RHDPobjetivos)) gt 0>
			<cf_rheditorhtml name="TextoResp" value="#Trim(rsForm.RHDPobjetivos)#" tabindex="1"> 
		<cfelse>
			<cf_rheditorhtml name="TextoResp" tabindex="1"> 
		</cfif>
      </td>
    </tr>	
	<tr><td colspan="2"></td></tr>
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
					<td><cf_translate key="MSG_ParaPoderAgregarOModificarResponsabilidadesDebeDeRealizarloDesdeElPerfilIdealDelPuesto">Para poder agregar o modificar responsabilidades debe de realizarlo desde el perfil ideal del puesto</cf_translate>.</td>
				</cfif>
				<td>&nbsp;&nbsp;</td>
			  </tr>
			  <tr><td colspan="5">&nbsp;&nbsp;</td></tr>
			</table>
		</td>
	</tr>
	<cfset ts = "">	
	<cfif modo1 neq "ALTA">
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
	</cfinvoke>
	</cfif>
	<tr>
	  <td>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHPcodigo" id="RHPcodigo" value="#Trim(rsForm.RHPcodigo)#">
	  </td>
	</tr>
  </table>
</cfoutput>
</form>

<cfset modo = 'ALTA'>

<cfif isdefined("url.RHDPCFid") and not isdefined("form.RHDPCFid")>
	<cfset form.RHDPCFid = url.RHDPCFid >
</cfif>

<cfif isdefined("form.RHDPCFid") and len(trim(form.RHDPCFid))>
	<cfset modo = 'CAMBIO'>

	<cfquery name="rs_respcf" datasource="#session.DSN#">
		select RHDPCFid, RHDPCFresp as resp, CFid as CFid
		from RHDescriptivoPuestoCF
		where RHDPCFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPCFid#">
	</cfquery>
</cfif>

<table width="100%" cellpadding="2" cellspacing="0" align="center">
	<tr><td colspan="2" style="padding:10px;" class="tituloListas">Definir responsabilidades del puesto por Centro Funcional</td></tr>
	<cfoutput>
	<form name="form1" method="post" action="SQLPuestos-frobjetivos.cfm" style="margin:0;">
		<tr>
			<td>
				<table width="100%" cellpadding="1" cellspacing="0">
					<tr>
						<td width="1%" nowrap="nowrap"><strong><cf_translate key="LB_CentroFuncional">CentroFuncional</cf_translate>:</strong></td>
						<td>
							<cfif modo neq 'ALTA'>
								<cfquery name="rs_cfuncional" datasource="#session.DSN#">
									select CFid, CFcodigo, CFdescripcion
									from CFuncional
									where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_respcf.CFid#">
								</cfquery>
								#trim(rs_cfuncional.CFcodigo)# - #trim(rs_cfuncional.CFdescripcion)#
								<input type="hidden" name="CFid" value="">
							<cfelse>
								<cf_rhcfuncional>
							</cfif>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<cfif modo neq 'ALTA'>
					<cf_rheditorhtml name="TextoRespCF" value="#Trim(rs_respcf.resp)#" tabindex="1">
				<cfelse>
					<cf_rheditorhtml name="TextoRespCF" tabindex="1">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="center">
				<cfif modo eq 'ALTA'>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Agregar"
						Default="Agregar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Agregar"/>
					<input type="submit" class="btnGuardar" name="btnALTACF" value="#BTN_Agregar#" tabindex="1">
				<cfelse>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Modificar"
						Default="Modificar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Modificar"/>
					<input type="submit" class="btnGuardar" name="btnCAMBIOCF" value="#BTN_Modificar#" tabindex="1">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Eliminar"
						Default="Eliminar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Eliminar"/>
					<input type="submit" class="btnEliminar" name="btnBAJACF" value="#BTN_Eliminar#" tabindex="1">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Nuevo"
						Default="Nuevo"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Nuevo"/>
					<input type="submit" class="btnNuevo" name="btnNuevoCF" value="#BTN_Nuevo#" tabindex="1">
				</cfif>
			</td>
		</tr>
		<input type="hidden" name="RHPcodigo" id="RHPcodigo" value="#Trim(rsForm.RHPcodigo)#">
		<cfif modo neq 'ALTA'>
			<input type="hidden" name="RHDPCFid" id="RHDPCFid" value="#rs_respcf.RHDPCFid#">
		</cfif>
	</form>
	</cfoutput>
	
	<cfif modo eq 'ALTA'>
		<cf_qforms>
		<script>
			objForm.CFid.required = true;
			objForm.CFid.description = 'Centro Funcional';
		</script>	
	</cfif>

	<tr><td class="tituloListas"><cf_translate key="LB_Listado_de_Responsabilidades_del_Puesto_por_Centro_Funcional">Listado de Responsabilidades del Puesto por Centro Funcional</cf_translate></td></tr>
	<tr>
		<td >

			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Codigo"
				Default="C&oacute;digo"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Codigo"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descripcion"
				Default="Descripci&oacute;n"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Descripcion"/>

			<cfquery name="rslista" datasource="#session.DSN#">
				select a.RHDPCFid, a.CFid, b.CFcodigo, b.CFdescripcion, 3 as o, 1 as sel, '#form.RHPcodigo#' as RHPcodigo
				from RHDescriptivoPuestoCF a, CFuncional b
				where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and a.RHPcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">		
				  and b.CFid=a.CFid	 
			</cfquery>
	
			<cfset navegacion = '&RHPcodigo=#form.RHPcodigo#&o=3&sel=1' >
	
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rslista#"/>
				<cfinvokeargument name="desplegar" value="CFcodigo,CFdescripcion"/>
				<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
				<cfinvokeargument name="formatos" value=""/>	
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="Puestos.cfm"/>
				<cfinvokeargument name="keys" value="CFid"/>
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="formName" value="lista"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<!---<cfinvokeargument name="navegacion" value="#navegacion#"/>--->
			</cfinvoke>
		</td>
	</tr>
</table>