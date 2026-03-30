<cfif not isdefined("form.modo")>
	<cfset modo="ALTA">
<cfelse>
	<cfset modo=FORM.modo>
</cfif>


<!--- Consultas --->
<cfquery name="rsCuentaEmpresarial" datasource="asp">
	select CEcodigo, CEnombre  from CuentaEmpresarial 
</cfquery>

<cfif not isdefined("form.CEcodigo")>
	<cfset form.CEcodigo = rsCuentaEmpresarial.CEcodigo>
</cfif>

<cfquery name="rsEmpresa" datasource="asp">
	select  CEcodigo,Ecodigo,Enombre from Empresa 
	<cfif modo eq 'ALTA'>
		where CEcodigo = #form.CEcodigo#
		and Ereferencia is not null
	<cfelse>
		where Ecodigo = #form.CEcodigo#
		and Ereferencia is not null
	</cfif>
	
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script> 
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	function validar(f){
		f.obj.Ecodigo.disabled = false;
		return true;
	}
	
	function deshabilitarValidacion() {
		objForm.Ecodigo.required = false;
	}
</script>

<form name="form1" method="post" action="SQLEmpresasXFormato.cfm">
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="1">	
		<tr>
			<td colspan="3" class="tituloAlterno"><div align="center"><strong>
			<cf_translate key="LB_EmpresasAsociadasAlFormato">Empresas asociadas al formato</cf_translate>
			</strong></div></td>
		</tr>
		<tr>
			<td colspan="3" class="tituloAlterno"><div align="center"><cfif modo eq 'ALTA'><strong><cf_translate key="LB_NuevaEmpresa">Nueva Empresa</cf_translate></cfif></div></strong></td>
		</tr>	  
		<tr><td>&nbsp;</td></tr>
		<cfif MODO eq 'ALTA'>
			<tr>
				<td width="45%" align="right"><cf_translate key="LB_CuentaEmpresarial">Cuenta Empresarial</cf_translate>:&nbsp;</td>
				<td colspan="2">
					<select name="CEcodigo" onChange="CambiaCuenta()" tabindex="1">
						<cfloop query="rsCuentaEmpresarial">
							<option  <cfif (isDefined("form.CEcodigo") AND form.CEcodigo EQ rsCuentaEmpresarial.CEcodigo)>selected</cfif> 
							value="#rsCuentaEmpresarial.CEcodigo#">#rsCuentaEmpresarial.CEnombre#</option>
						</cfloop>
					</select>
				</td>
			</tr>
		</cfif>
		<tr>
			<td width="45%" align="right"><cf_translate key="LB_Empresa">Empresa</cf_translate>:&nbsp;</td>
			<cfif modo eq 'ALTA'>
				<td colspan="2">
					<select name="Ecodigo" tabindex="2">
						<cfloop query="rsEmpresa">
							<option value="#rsEmpresa.Ecodigo#">#rsEmpresa.Enombre#</option>
						</cfloop>
					</select>
				</td>
			<cfelse>
				<td colspan="2">
					<b>#rsEmpresa.Enombre#<b>
					<input type="hidden" name="Ecodigo" value="<cfif isdefined("rsEmpresa.Ecodigo")>#rsEmpresa.Ecodigo#</cfif>">
					<input type="hidden" name="CEcodigo" value="<cfif isdefined("rsEmpresa.CEcodigo")>#rsEmpresa.CEcodigo#</cfif>">
					<input type="hidden" name="Enombre" value="<cfif isdefined("rsEmpresa.Enombre")>#rsEmpresa.Enombre#</cfif>">
				</td>
			</cfif>
		</tr>
		<tr><td>&nbsp;</td></tr>

		<tr>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Agregar"
			Default="Agregar"
			returnvariable="BTN_Agregar"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Borrar"
			Default="Borrar"
			returnvariable="BTN_Borrar"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_UsuariosPorEmpresa"
			Default="Usuarios Por Empresa"
			returnvariable="BTN_UsuariosPorEmpresa"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Regresar"
			Default="Regresar"
			returnvariable="BTN_Regresar"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Nuevo"
			Default="Nuevo"
			returnvariable="BTN_Nuevo"/>

			<td  align="center" colspan="3">
			<cfif modo eq 'ALTA'>
				<input type="submit" name="alta" value="<cfoutput>#BTN_Agregar#</cfoutput>">
			<cfelse>
				<input type="submit" name="baja"  value="<cfoutput>#BTN_Borrar#</cfoutput>">
				<input type="submit" name="nuevo" value="<cfoutput>#BTN_Nuevo#</cfoutput>">
				<input type="submit" name="AltaUsuarios"   value="<cfoutput>#BTN_UsuariosPorEmpresa#</cfoutput>" onClick="javascript: deshabilitarValidacion(); AsociarUsuarios();">
			</cfif>
			<input type="submit" name="btn_Regresar"   value="<cfoutput>#BTN_Regresar#</cfoutput>" onClick="javascript: deshabilitarValidacion(); Regresar();">

			</td>
		</tr>	  
	</table>
	<input name="EIid"  type="hidden" value="<cfif isdefined("form.EIid")>#Form.EIid#</cfif>">
	<input name="MODO"  type="hidden" value="#MODO#">
</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empresa"
	Default="Empresa"
	returnvariable="LB_Empresa"/>	
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	objForm.Ecodigo.required = true;
	objForm.Ecodigo.description="<cfoutput>#LB_Empresa#</cfoutput>";
	
	function Regresar(){
		document.form1.action="Importador.cfm";
		document.form1.submit();
	}	
	
	function CambiaCuenta(){
		document.form1.action="IMP_EmpresasXFormato.cfm";
		document.form1.submit();
	}	
	
	function AsociarUsuarios(){
		document.form1.action="IMP_UsuariosXEmpresas.cfm";
		document.form1.submit();
	}		
	
</script>