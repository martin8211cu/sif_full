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
		f.obj.Usucodigo.disabled = false;
		return true;
	}
	
	function deshabilitarValidacion() {
		objForm.Usucodigo.required = false;
	}
</script>


<form name="form1" method="post" action="SQLUsuariosXEmpresas.cfm">
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="1">	
		<tr>
			<td colspan="3" class="tituloAlterno"><div align="center"><strong>
			<cf_translate key="LB_UsuariosDeLaEmpresa">Usuarios de la empresa</cf_translate>(#Form.Enombre#) <cf_translate key="LB_AsociadaAlFormato">asociada al formato</cf_translate>
			</strong></div></td>
		</tr>
		<tr>
			<td colspan="3" class="tituloAlterno"><div align="center"><cfif modo eq 'ALTA'><strong><cf_translate key="LB_NuevoUsuario">Nuevo Usuario</cf_translate></cfif></div></strong></td>
		</tr>	  
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="45%" align="right"><cf_translate key="LB_Usuario">Usuario</cf_translate>:&nbsp;</td>
			<td colspan="2">
					<cf_conlis 
						campos="Usucodigo,Usulogin,Pnombre,Papellido1,Papellido2"
						size="0,15,20,20,20"
						desplegables="N,S,S,S,S"
						modificables="N,S,N,N,N"
						title="Usuarios"
						tabla="Usuario a 
							inner join DatosPersonales b
							  on b.datos_personales = a.datos_personales"
						columnas="a.Usucodigo,a.Usulogin,b.Pnombre,b.Papellido1,b.Papellido2"
						filtro="CEcodigo = #form.CEcodigo# and a.Usucodigo != #session.usucodigo#"
						filtrar_por="a.Usulogin,b.Pnombre,b.Papellido1,b.Papellido2"
						desplegar="Usulogin,Pnombre,Papellido1,Papellido2"
						etiquetas="Login,Nombre,Primer Apellido,Segundo Apellido"
						formatos="S,S,S,S"
						align="left,left,left,left"
						asignar="Usucodigo,Usulogin,Pnombre,Papellido1,Papellido2"
						asignarFormatos="I,S,S,S,S"
						showEmptyListMsg="true"
						conexion="asp"
						EmptyListMsg=" --- No se encontraron registros --- "
						tabindex="1"/>
			</td>
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
			Key="BTN_Regresar"
			Default="Regresar"
			returnvariable="BTN_Regresar"/>
			
			<td  align="center" colspan="3">
				<input type="submit" name="alta" value="<cfoutput>#BTN_Agregar#</cfoutput>">
				<input type="submit" name="btn_Regresar"   value="<cfoutput>#BTN_Regresar#</cfoutput>" onClick="javascript: deshabilitarValidacion(); Regresar();">
			</td>
		</tr>	  
	</table>
	<input name="EIid"  type="hidden" value="<cfif isdefined("form.EIid")>#Form.EIid#</cfif>">
	<input name="CEcodigo"  type="hidden" value="<cfif isdefined("form.CEcodigo")>#Form.CEcodigo#</cfif>">
	<input name="Ecodigo"  type="hidden" value="<cfif isdefined("form.Ecodigo")>#Form.Ecodigo#</cfif>">
	<input name="Enombre"  type="hidden" value="<cfif isdefined("form.Enombre")>#Form.Enombre#</cfif>">
	<input name="MODO"  type="hidden" value="ALTA">
	<input name="MODODET"  type="hidden" value="ALTA">
</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Usuario"
	Default="Usuario"
	returnvariable="LB_Usuario"/>	
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	objForm.Usucodigo.required = true;
	objForm.Usucodigo.description="<cfoutput>#LB_Usuario#</cfoutput>";

	function Regresar(){
		document.form1.action="IMP_EmpresasXFormato.cfm";
		document.form1.submit();
	}	
	
	function AsociarUsuarios(){
		document.form1.action="IMP_UsuariosXEmpresas.cfm";
		document.form1.submit();
	}		
	
</script>