<cfheader name="Expires" value="#Now()#">
<cf_templateheader title="Configuración Inicial de Solicitudes">
		<!---Configuración Inicial--->
		<cfinclude template="compraConfig-Config.cfm">
		<!---Funciones estándar para avanzar y retroceder--->
		<script language="javascript" type="text/javascript">
			function funcSiguiente() {
				if (window.deshabilitarValidacion) deshabilitarValidacion();
				document.formOpt.opt.value = '<cfoutput>#Session.Compras.Configuracion.Pantalla + 1#</cfoutput>';
				document.formOpt.submit();
				return false;
			}
			
			function funcAnterior() {
				if (window.deshabilitarValidacion) deshabilitarValidacion();
				document.formOpt.opt.value = '<cfoutput>#Session.Compras.Configuracion.Pantalla - 1#</cfoutput>';
				document.formOpt.submit();
				return false;
			}

			function funcFinalizar() {
				if (window.deshabilitarValidacion) deshabilitarValidacion();
				document.formOpt.action = "compraConfig-inicio.cfm";
				document.formOpt.opt.value = 0;
				document.formOpt.submit();
				return false;
			}
		</script>
		<!---Tabla Principal---->
		<cf_web_portlet_start titulo="Configuración Inicial de Solicitudes">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<br>
		<table width="97%" align="center" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td valign="top">
					<!---Pinta un encabezado común en todas las pantallas--->
					<cfinclude template="compraConfig-Header.cfm">
					<!---Pinta la pantalla correspondiente--->
					<cfif Session.Compras.Configuracion.Pantalla EQ 0>
						<cfinclude template="compraConfig-Paso0.cfm">
					<cfelseif Session.Compras.Configuracion.Pantalla EQ 1>
						<cfinclude template="compraConfig-Paso1.cfm">
					<cfelseif Session.Compras.Configuracion.Pantalla EQ 2>
						<cfinclude template="compraConfig-Paso2.cfm">
					<cfelseif Session.Compras.Configuracion.Pantalla EQ 3>
						<cfinclude template="compraConfig-Paso3.cfm">
					</cfif>
			</td>
			<td width="1%" valign="top">
				<!---Secciones de progreso y ayuda--->
				<cfinclude template="compraConfig-Progreso.cfm"><br>
				<cfinclude template="compraConfig-Ayuda.cfm">
			</td>
		  </tr>
		</table>
		<br>
		<cf_web_portlet_end>
	<cf_templatefooter>