<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
		Registro de Encuestas Salariales
	</cf_templatearea>	
	<cf_templatearea name="body">
	  <cf_web_portlet_start border="true" titulo="Habilidades" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfif isdefined("url.Eid") and not isdefined('Form.Eid')>
				<cfset Form.Eid = Url.Eid>
			</cfif>			
			<cfif isdefined("url.Paso") and not isdefined('form.Paso')>
				<cfset form.paso = url.Paso>
			</cfif>
			<cfparam name="form.Paso" default="0">
			<cfparam name="params" default="">
 			<cfif isdefined('form.Eid') and len(trim(form.Eid))>
				<cfset params = params & "&Eid=" & form.Eid>
			</cfif>
			<cfif form.Paso eq "">
				<cfset form.Paso = "0">
			</cfif>		

			<!---Tabla Principal---->
			<br>
			<table width="97%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td valign="top">
						<!---Pinta un encabezado común en todas las pantallas--->
						<cfinclude template="datosEncuestas-header.cfm">
						<!---Pinta la pantalla correspondiente--->
						<cfif form.Paso EQ 0>
							<cfinclude template="listaDatosEncuestas.cfm">
						<cfelseif form.Paso EQ 1>
							<cfinclude template="Encuesta-form.cfm">
						<cfelseif form.Paso EQ 2>
							<cfinclude template="infoEncuesta-form.cfm">
						</cfif>	
					</td>
					<td width="1%" valign="top">
						<!---Secciones de progreso y ayuda--->
						<cfinclude template="datosEncuestas_Progreso.cfm"><br>
						<!--- <cfinclude template="datosEncuestas_Ayuda.cfm"> --->
					</td>
			  </tr>
		   </table>
		   </br>	
		   <!---Funciones estándar para avanzar y retroceder--->
			<script language="javascript" type="text/javascript">
			<!--//
				function funcSiguiente() {
					if ('#params#'.length==0){
						alert("#JSStringFormat('Debe seleccionar una encuesta.')#");
						return false;
					}
					location.href="datosEncuestas-proceso.cfm?Paso=<cfoutput>#form.Paso+1##params#</cfoutput>";
					return false;
				}
				function funcAnterior() {
//					location.href="cajasProceso.cfm?Paso=#form.Paso-1##params#";
					return false;
				}
			//-->
			</script>			
			 
	  <cf_web_portlet_end>
	</cf_templatearea>
</cf_template>	  
