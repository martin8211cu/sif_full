<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Administraci&oacute;n de Beneficios de Empleados">
	<!--- Por si el empleado viene por Url --->
	<cfif isdefined("Url.DEid") and Len(Trim(Url.DEid))>
		<cfparam name="Form.DEid" default="#Url.DEid#">
	</cfif>
	<!--- Cuando ya se ha seleccionado un empleado --->
	<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>	
		<script language="javascript" type="text/javascript">
			function switchPages() {
				var ListPage = document.getElementById("trSelEmpleado");

				var DataPage1 = document.getElementById("trSel2");
				var DataPage2 = document.getElementById("trBenEmpleado");
				
				if (DataPage1.style.display == "") {
					DataPage1.style.display = "none";
					DataPage2.style.display = "none";
					ListPage.style.display = "";
				} else {
					DataPage1.style.display = "";
					DataPage2.style.display = "";
					ListPage.style.display = "none";
				}
			}
		</script>
	</cfif>	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr valign="top">
		<td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
	  </tr>
	  <tr id="trSelEmpleado" valign="top" <cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>style="display:none;"</cfif>> 
		<td align="center">
		  <p class="tituloAlterno">SELECCIONE UN EMPLEADO</p>
		  <cfinclude template="frame-Empleados.cfm">
		</td>
	  </tr>
	<!--- Cuando ya se ha seleccionado un empleado --->
	<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
	  <tr id="trSel2">
		<td align="right" style="padding-top: 5px; padding-bottom: 5px; padding-right: 5px;">
			<a href="javascript: switchPages();"><strong>SELECCIONAR EMPLEADO</strong><img src="/cfmx/rh/imagenes/find.small.png" name="imageBusca" id="imageBusca" border="0"></a>
		</td>
	  </tr>
	  <tr id="trBenEmpleado" valign="top"> 
		<td align="center">
		  <cfinclude template="beneficiosEmpleado-form.cfm">
		</td>
	  </tr>
	</cfif>
	  <tr valign="top"> 
		<td>&nbsp;</td>
	  </tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>	
