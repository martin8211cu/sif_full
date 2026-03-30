<!--- Sección de Etiquetas de Traducción --->
<cfsilent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Puesto"
	Default="Puesto"
	returnvariable="MSG_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Lista_de_Puesto"
	Default="Lista de Puesto"
	returnvariable="MSG_Lista_de_Puesto"/>    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>
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
    
</cfsilent>

<!-- Establecimiento del modo -->
<cfset modo="ALTA">

<!--- Javascript --->
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<form name="form1" method="post" action="SqlHomologarPuestos.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Puesto" XmlFile="/rh/generales.xml">Puesto</cf_translate>:&nbsp;</td>
      <td nowrap>
        <cf_conlis
            Campos="RHPcodigoH,RHPdescpuestoH"
            Desplegables="S,S"
            Modificables="S,S"
            Size="10,30"
            tabindex="1"
            Title="#MSG_Lista_de_Puesto#"
            Tabla="RHPuestos"
            Columnas="RHPcodigo as RHPcodigoH,RHPdescpuesto as RHPdescpuestoH"
            Filtro=" Ecodigo = #Session.Ecodigo# and RHPactivo = 1 and RHPcodigo not in (select b.RHPcodigoH from RHPuestosH b where b.Ecodigo = #Session.Ecodigo# )"
            Desplegar="RHPcodigoH,RHPdescpuestoH"
            Etiquetas="#LB_Codigo#,#LB_Descripcion#"
            filtrar_por="RHPcodigo,RHPdescpuesto"
            Formatos="S,S"
            Align="left,left"
            form="form1"
            Asignar="RHPcodigoH,RHPdescpuestoH"
            Asignarformatos="S,S"/>

	  </td>
    </tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td nowrap colspan="2" align="center">
			<cfset tabindex=1>
			<cf_botones modo="#modo#" include="Regresar">

		</td>
	</tr>
	<tr align="center"> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
	<input type="hidden" name="RHPcodigo" value="#form.RHPcodigo#">
    <input type="hidden" name="RHPcodigoD" value="">
    <input type="hidden" name="AccionAEjecutar"   	id="AccionAEjecutar"    value="">
  </table>  
  </cfoutput>
</form>
	
<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_El_campo"
	Default="El campo"
	returnvariable="MSG_El_campo"/>	

	objForm.RHPcodigoH.required 			= true;
	objForm.RHPcodigoH.description		="<cfoutput>#MSG_Puesto#</cfoutput>";
	
	function deshabilitarValidacion(){
		objForm.RHPcodigoH.required 			= false;
	}	
	
	function habilitarValidacion(){
		objForm.RHPcodigoH.required 			= true;
	} 
	
	function funcRegresar(){
		deshabilitarValidacion();
		document.form1.action = 'PuestosPropuestos.cfm';
	}
	
	function Eliminar(valor){
		document.form1.RHPcodigoD.value = valor;
		document.form1.AccionAEjecutar.value="BORRAR";
		document.form1.action='SqlHomologarPuestos.cfm';
		document.form1.submit();
	}
	
</script>