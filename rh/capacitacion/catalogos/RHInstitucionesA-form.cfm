<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MantenimientoDeInstitucionesAcademicas"
	Default="Mantenimiento de Instituciones Acad&eacute;micas"
	returnvariable="LB_MantenimientoDeInstitucionesAcademicas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"	
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Telefono"
	Default="Tel&eacute;fono"
	returnvariable="LB_Telefono"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PaginaWeb"
	Default="P&aacute;gina Web"
	returnvariable="LB_PaginaWeb"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Contacto"
	Default="Contacto"
	returnvariable="LB_Contacto"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TelefonoContacto"
	Default="Tel&eacute;fono [Contacto]"
	returnvariable="LB_TelefonoContacto"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fax"
	Default="Fax"
	returnvariable="LB_Fax"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EmailContacto"
	Default="E-mail [Contacto]"
	returnvariable="LB_EmailContacto"/>	
	
	
<!--- FIN VARIABLES DE TRADUCCION --->
﻿﻿<cfparam name="url.RHIAid" default="">
	<cfquery datasource="#session.dsn#" name="data">
		select 
			RHIAid,
			Ecodigo,
			CEcodigo,
			RHIAcodigo,
			RHIAnombre,
			RHIAtelefono,
			RHIAfax,
			RHIAurl,
			BMfecha,
			BMUsucodigo,
			RHIAcontacto,
			RHIAtelefonoc,
			RHIAemailc,
			ts_rversion
		from  RHInstitucionesA
		where RHIAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHIAid#" null="#Len(url.RHIAid) Is 0#">
	</cfquery>
<cfoutput>
<form action="RHInstitucionesA-apply.cfm"  method="post" name="form1" id="form1">
	<table width="100%" summary="Tabla de entrada">
		<tr>
			<td width="32%" valign="top" align="right"><strong>#LB_Codigo#:</strong></td>
			<td width="68%" valign="top">
				<input name="RHIAcodigo" id="RHIAcodigo" type="text" value="#HTMLEditFormat(data.RHIAcodigo)#" maxlength="10" size="10"onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong>#LB_Nombre#:</strong></td>
			<td valign="top">
              <input name="RHIAnombre" id="RHIAnombre" type="text" value="#HTMLEditFormat(data.RHIAnombre)#" maxlength="100" size=" 50"onFocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong>#LB_Telefono#:</strong></td>
			<td valign="top">
				<input name="RHIAtelefono" id="RHIAtelefono" type="text" value="#HTMLEditFormat(data.RHIAtelefono)#" maxlength="25"  size="25"onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong>#LB_Fax#:</strong></td>
			<td valign="top">
				<input name="RHIAfax" id="RHIAfax" type="text" value="#HTMLEditFormat(data.RHIAfax)#" maxlength="25"  size="25"onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong>#LB_PaginaWeb#: </strong></td>
			<td valign="top">
				<input name="RHIAurl" id="RHIAurl" type="text" value="#HTMLEditFormat(data.RHIAurl)#" maxlength="255"   size="50"onfocus="this.select()">
			</td>
		</tr>
		<tr>
		<tr>
			<td valign="top" align="right"><strong>#LB_Contacto#: </strong></td>
			<td valign="top" nowrap>
				<input name="RHIAcontacto" id="RHIAcontacto" type="text" value="#HTMLEditFormat(data.RHIAcontacto)#" maxlength="120" size="60"onfocus="this.select()">
			</td>
		</tr>
		<tr>
			<td valign="top" align="right" nowrap><strong>#LB_TelefonoContacto#: </strong></td>
			<td valign="top" nowrap>
				<input name="RHIAtelefonoc" id="RHIAtelefonoc" type="text" value="#HTMLEditFormat(data.RHIAtelefonoc)#" maxlength="60" size="40"onfocus="this.select()">
			</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong>#LB_EmailContacto#: </strong></td>
			<td valign="top" nowrap>
				<input name="RHIAemailc" id="RHIAemailc" type="text" value="#HTMLEditFormat(data.RHIAemailc)#" maxlength="100" size="40"onfocus="this.select()">
			</td>
		</tr>
		<tr>
			<td colspan="2" class="formButtons">
				<cfif data.RecordCount>
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="RHIAid" value="#HTMLEditFormat(data.RHIAid)#">
	<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
</form>
<cf_qforms>
<script type="text/javascript">
	objForm.RHIAcodigo.required = true;
	objForm.RHIAcodigo.description="#LB_Codigo#";			
		
	objForm.RHIAnombre.required= true;
	objForm.RHIAnombre.description="#LB_Nombre#";	

	
	function habilitarValidacion(){
		objForm.RHIAcodigo.required = true;
		objForm.RHIAnombre.required= true;
	}
	
	function deshabilitarValidacion(){
		objForm.RHIAcodigo.required = false;
		objForm.RHIAnombre.required= false;

	}		
	
</script>

</cfoutput>


