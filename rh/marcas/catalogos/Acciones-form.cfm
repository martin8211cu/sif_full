<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	xmlfile="/rh/generales.xml"
	returnvariable="vCodigo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	xmlfile="/rh/generales.xml"
	returnvariable="vDescripcion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	xmlfile="/rh/generales.xml"
	returnvariable="vFiltrar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	xmlfile="/rh/generales.xml"
	returnvariable="vLimpiar"/>
<!--- VARIABLES DE TRADUCCION --->
<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
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

<cfparam name="Url.fRHAScodigo" default="">
<cfparam name="Url.fRHASdescripcion" default="">

<cfif isdefined("Url.fRHAScodigo") and not isdefined("Form.fRHAScodigo")>
	<cfset Form.fRHAScodigo = Url.fRHAScodigo>
</cfif>
<cfif isdefined("Url.fRHASdescripcion") and not isdefined("Form.fRHASdescripcion")>
	<cfset Form.fRHASdescripcion = Url.fRHASdescripcion>
</cfif>

<cfset filtro = "Ecodigo = #Session.Ecodigo#">
<cfset navegacion = "">
<cfif isdefined("form.fRHAScodigo") and len(trim(form.fRHAScodigo)) gt 0 >
	<cfset filtro = filtro & " and RHAScodigo like '%#form.fRHAScodigo#%' " >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHAScodigo=" & Form.fRHAScodigo>
</cfif>
<cfif isdefined("form.fRHASdescripcion") and len(trim(form.fRHASdescripcion)) gt 0 >
	<cfset filtro = filtro & " and upper(RHASdescripcion) like '%#Ucase(form.fRHASdescripcion)#%' " >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHASdescripcion=" & Form.fRHASdescripcion>
</cfif>
<cfset filtro = filtro & "order by RHAScodigo, RHASdescripcion">

<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select RHASid, Ecodigo, rtrim(RHAScodigo) as RHAScodigo, RHASdescripcion, BMUsucodigo, BMfecha, BMfmod, ts_rversion,RHASnegativo
		from RHAccionesSeguir
		where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHASid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<!--- Javascript --->
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function validar(f) {
		return true;
	}

	function limpiar() {
		document.filtro.fRHAScodigo.value = "";
		document.filtro.fRHASdescripcion.value   = "";
	}
	//-->
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top" width="50%">
			<form style="margin: 0" name="filtro" method="post" action="Acciones.cfm">
				<table border="0" width="100%" class="areaFiltro">
				  <tr> 
					<td nowrap><cfoutput>#vCodigo#</cfoutput></td>
					<td nowrap><cfoutput>#vDescripcion#</cfoutput></td>
				  </tr>
				  <tr> 
					<td nowrap><input type="text" name="fRHAScodigo" tabindex="1" value="<cfif isdefined("form.fRHAScodigo") and len(trim(form.fRHAScodigo)) gt 0 ><cfoutput>#form.fRHAScodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();" ></td>
					<td nowrap><input type="text" name="fRHASdescripcion" tabindex="1" value="<cfif isdefined("form.fRHASdescripcion") and len(trim(form.fRHASdescripcion)) gt 0 ><cfoutput>#form.fRHASdescripcion#</cfoutput></cfif>" size="50" maxlength="80" onFocus="javascript:this.select();" ></td>
					<td nowrap>
						<input type="submit" name="Filtrar" tabindex="1" value="<cfoutput>#vFiltrar#</cfoutput>">
						<input type="button" name="Limpiar" tabindex="1" value="<cfoutput>#vLimpiar#</cfoutput>" onClick="javascript:limpiar();">
					</td>
				  </tr>
				</table>
			  </form>						
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="RHAccionesSeguir"/>
				<cfinvokeargument name="columnas" value="RHASid, RHAScodigo, RHASdescripcion, 
														'#Form.fRHAScodigo#' as fRHAScodigo, 
														'#Form.fRHASdescripcion#' as fRHASdescripcion"/>
				<cfinvokeargument name="desplegar" value="RHAScodigo, RHASdescripcion"/>
				<cfinvokeargument name="etiquetas" value="#vCodigo#, #vDescripcion#"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="#filtro#"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="Acciones.cfm"/>
				<cfinvokeargument name="keys" value="RHASid"/>
				<cfinvokeargument name="maxRows" value="15"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
		<td width="50%" valign="top" align="left">
			<form name="form1" method="post" action="Acciones-SQL.cfm" onSubmit="return validar(this);">
			  <cfoutput>  
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td class="fileLabel" align="right">#vCodigo#:&nbsp;</td>
					<td>
					  <input name="RHAScodigo" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#trim(rsForm.RHAScodigo)#</cfif>" size="6" maxlength="5" onFocus="javascript:this.select();" alt="El C&oacute;digo de Plaza" >
					  <cfif modo neq 'ALTA'>
						<input type="hidden" name="RHASid" tabindex="-1" value="#rsForm.RHASid#" >
					  </cfif>
					</td>
				  </tr>
				  <tr>
					<td class="fileLabel" align="right">#vDescripcion#:&nbsp;</td>
					<td><input name="RHASdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.RHASdescripcion#</cfif>" size="60" maxlength="60" onFocus="javascript:this.select();" alt="La Descripci&oacute;n" ></td>
				  </tr>
				  <tr>
				  	<td>&nbsp;</td>
					<td valign="top"><table><tr>
						<td width="100" align="right" class="fileLabel">
							<input type="radio" name="RHASnegativo" tabindex="1" value="0" <cfif modo NEQ 'ALTA' and rsForm.RHASnegativo EQ 0>checked</cfif>>
							<cf_translate key="LB_Positivo">Positivo</cf_translate>
						</td>
						<td width="114" align="right" class="fileLabel">
							<input type="radio" name="RHASnegativo" tabindex="1" value="1" <cfif modo NEQ 'ALTA' and rsForm.RHASnegativo EQ 1>checked</cfif>>
							<cf_translate key="LB_Negativo">Negativo</cf_translate>
						</td>
					</tr></table></td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
					<td valign="top">&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="2" align="center">
						<cf_botones modo="#modo#"  tabindex="1">
						<!--- <cfinclude template="/rh/portlets/pBotones.cfm"> --->
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
						<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">&nbsp;
					</td>
				  </tr>
				</table>
			  </cfoutput>
			</form>
		</td>
	</tr>
</table>

<cf_qforms form="form1">
	<cf_qformsRequiredField args="RHAScodigo,#vCodigo#">
	<cf_qformsRequiredField args="RHASdescripcion,#vDescripcion#">
</cf_qforms>

