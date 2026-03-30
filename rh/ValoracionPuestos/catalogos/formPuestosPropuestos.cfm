<!--- Sección de Etiquetas de Traducción --->
<cfsilent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarElDetalle"
	Default="Desea Eliminar el Detalle"
	returnvariable="MSG_DeseaEliminarElDetalle"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Modificar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
</cfsilent>

<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio") or isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
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

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select upper(rtrim(RHPcodigo))as RHPcodigo,RHPdescpuesto
		from RHPuestos 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	</cfquery>
</cfif>


<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<form name="form1" method="post" action="SQLPuestosPropuestos.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
      <td nowrap>
	  	<cfif modo eq 'ALTA'>
    	    <input name="RHPcodigo" type="text" tabindex="1" value="" size="10" maxlength="10" onFocus="javascript:this.select();" style="text-transform:uppercase;">
        <cfelse>
	        <input name="RHPcodigo" type="hidden" value="<cfif modo neq 'ALTA'>#Trim(rsForm.RHPcodigo)#</cfif>" size="10" maxlength="10">
            #Trim(rsForm.RHPcodigo)#
        </cfif>
	  </td>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap><input name="RHPdescpuesto" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.RHPdescpuesto#</cfif>" size="55" maxlength="100" onFocus="javascript:this.select();"></td>
    </tr>

	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td nowrap colspan="2" align="center">
			<cfset tabindex=1>
			<cfif modo eq 'ALTA'>
				<cf_botones modo="#modo#">
			<cfelse>
				<cf_botones modo="#modo#" include="Homologar">
			</cfif>
		</td>
	</tr>
	<tr align="center"> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
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

	objForm.RHPcodigo.required 			= true;
	objForm.RHPdescpuesto.required 	= true;
	objForm.RHPcodigo.description		="<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.RHPdescpuesto.description	="<cfoutput>#MSG_Descripcion#</cfoutput>";
	
	function deshabilitarValidacion(){
		objForm.RHPcodigo.required 			= false;
		objForm.RHPdescpuesto.required 	= false;
	}	
	function habilitarValidacion(){
		objForm.RHPcodigo.required 			= true;
		objForm.RHPdescpuesto.required 	= true;
	} 
	function funcHomologar(){
		document.form1.action = 'HomologarPuestos.cfm';
	}

</script>