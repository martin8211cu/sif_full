<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
	  
	  <!---- Query para saber si se pintan o no los TABS de perfil y perfil comparativo ---->
		<cfquery name="rsUsatest" datasource="#session.DSN#">
			select Pvalor
			from RHParametros 
			where Pcodigo = 450 
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
		</cfquery>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">  		     
			 <cfinclude template="consultas-frame-header.cfm">
			 <cfinclude template="iconOptions.cfm">	
			<script language="JavaScript" type="text/javascript">
	  		function switchPages() {
				var DataPage = document.getElementById("TRDatosEmp");
				var ListPage = document.getElementById("TRBuscarEmp");
				if (DataPage.style.display == "") {
					DataPage.style.display = "none";
					ListPage.style.display = "";
				} else {
					DataPage.style.display = "";
					ListPage.style.display = "none";
				}
			}
	                </script>
                  <cfset Session.modulo = 'index' >		
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	    
	  <tr><td><cfinclude template="consultas-frame-header.cfm"><cfinclude template="iconOptions.cfm"></td></tr>
  
	  <!--- Cuando ya se ha seleccionado un empleado --->
	    <cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
  	      <tr>
	  	    <td>
		      <form name="reqEmpl" action="expediente-globalcons.cfm" method="post">
		  	     <input type="hidden" name="o" value="">
		  	     <input type="hidden" name="DEid" value="">
		      </form>
		      <table width="100%" border="0" cellspacing="0" cellpadding="0">
			      <tr>
				    <td align="right" valign="middle">
					    <cfif not isdefined("Form.toconcursantes")>
							<a href="javascript: switchPages();">
								Seleccionar Empleado: <img src="/cfmx/rh/imagenes/find.small.png" name="imageBusca" id="imageBusca" border="0">
							</a>
						</cfif>
				    </td>
			      </tr>
		      </table>
		    </td>
	      </tr>
	      <tr id="TRDatosEmp">
	  	    <td>
		    <cfinclude template="frame-header.cfm">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				  <td ><!--- class="tabContent" --->
				  <cfif isDefined("Form.DEid") and isDefined("Form.Regresar")>
					  <cfoutput>
					  <form name="frmRegresar" method="post" action="#Form.Regresar#" style="margin: 0;">
						  <input type="hidden" name="DEid" value="#Form.DEid#">
						  <cfif isdefined("Form.o")>
						  <input type="hidden" name="o" value="#Form.o#">
						  <cfelse>
						  <input type="hidden" name="o" value="1">
						  </cfif>
					  </form>
					  </cfoutput>
					  <cfset regresar = "javascript: if (window.regresar) { regresar(); } else { document.Regresar.submit(); }">
				  </cfif>
				  <cfinclude template="/rh/portlets/pNavegacion.cfm">
				  </td>
			  </tr>
			  <tr>
			    <td><!--- class="tabContent" --->
				    <cfif tabChoice eq 1>
					    <cfif isdefined("Form.dvacemp")>
						    <cfinclude template="expediente-detalleVacaciones.cfm">
						  <cfelse>
						    <cfinclude template="expediente-all.cfm">
					    </cfif>
					  <cfelseif tabChoice eq 2 and tabAccess[tabChoice]>
					    <cfinclude template="expediente-general.cfm">
					  <cfelseif tabChoice eq 3 and tabAccess[tabChoice]>
					    <cfinclude template="expediente-familiar.cfm">
					  <cfelseif tabChoice eq 4 and tabAccess[tabChoice]>
					    <cfinclude template="expediente-laboral.cfm">
					  <cfelseif tabChoice eq 5 and tabAccess[tabChoice]>
					    <cfinclude template="expediente-cargas.cfm">
					  <cfelseif tabChoice eq 6 and tabAccess[tabChoice]>
					    <cfinclude template="expediente-deducciones.cfm">
					  <cfelseif tabChoice eq 7 and tabAccess[tabChoice]>
					    <cfinclude template="expediente-anotaciones.cfm">
					  <cfelseif tabChoice eq 8 and tabAccess[6]>
					    <cfinclude template="expediente-deducciones.cfm">					  
					  <cfelseif tabChoice eq 10 and tabAccess[10]>					  					    
					  	<cfinclude template="expediente-frbenzinger.cfm">
				      <cfelseif tabChoice eq 11 and tabAccess[11]>		
						<cfinclude template="comparativo-benziger.cfm">
				      <cfelseif tabChoice eq 12 and tabAccess[12]>		
						<cfinclude template="expediente-beneficios.cfm">
					  <!---
					<cfelseif tabChoice eq 9 and tabAccess[tabChoice]>
						<cfinclude template="expediente-adicional.cfm">
					--->
				    </cfif>
			    </td>
			  </tr>
		    </table>
		    </td>
	      </tr>
		    <tr id="TRBuscarEmp" style="display: none">
		      <td>
		  		    <cf_web_portlet_start titulo="Consulta de Expediente Laboral">
					    <table width="100%" border="0" cellspacing="0" cellpadding="0">
						    <tr valign="top">
							    <td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
						    </tr>
					      <tr valign="top"> 
						    <td>&nbsp;</td>
					      </tr>
					      <tr valign="top"> 
						    <td align="center">
						      <cfinclude template="frame-Empleados.cfm">
						    </td>
					      </tr>
					      <tr valign="top"> 
						    <td>&nbsp;</td>
					      </tr>
					    </table>
				    <cf_web_portlet_end>
		      </td>
		    </tr>
	      <!--- Cuando todavía no se ha seleccionado un empleado --->
	      <cfelse>
	      <tr>
	  	    <td>
			    <cf_web_portlet_start titulo="Consulta de Expediente Laboral">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0">
					    <tr valign="top">
						    <td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
					    </tr>
				      <tr valign="top"> 
					    <td>&nbsp;</td>
				      </tr>
				      <tr valign="top"> 
					    <td align="center">
					      <p class="tituloAlterno">Debe seleccionar un empleado</p>
					      <cfinclude template="frame-Empleados.cfm">
					    </td>
				      </tr>
				      <tr valign="top"> 
					    <td>&nbsp;</td>
				      </tr>
				    </table>
			    <cf_web_portlet_end>
		    </td>
	      </tr>
	      </cfif>
	                  </table>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>