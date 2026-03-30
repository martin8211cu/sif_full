<cfset pagina = "/sif/cm/operacion/" & GetFileFromPath(GetTemplatePath())>
<cfif acceso_uri(pagina)>
	<script language="javascript" type="text/javascript">
		function goPage(opt,subopcion) {
			document.form1.action = 'compraProceso.cfm';
			<cfif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Session.Compras.ProcesoCompra.Pantalla EQ "0" and not (isdefined("Session.Compras.ProcesoCompra.DSlinea") and Len(Trim(Session.Compras.ProcesoCompra.DSlinea)))>
				if (opt != "0" && opt != "1" && opt != "9") {
					alert("Debe seleccionar uno de los procesos de compra o crear uno nuevo antes de continuar");
				} else {
					document.form1.opt.value = opt;
					document.form1.submit();
				}
			<cfelseif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Session.Compras.ProcesoCompra.Pantalla EQ "1" and not (isdefined("Session.Compras.ProcesoCompra.DSlinea") and Len(Trim(Session.Compras.ProcesoCompra.DSlinea)))>
				if (opt != "0" && opt != "1" && opt != "9") {
					alert('Deber oprimir el botón de \'Guardar y Continuar >>\'  antes de continuar');
				} else {
					document.form1.opt.value = opt;
					document.form1.submit();
				}
			<cfelseif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Session.Compras.ProcesoCompra.Pantalla EQ "2" and not (isdefined("Session.Compras.ProcesoCompra.CMPid") and Len(Trim(Session.Compras.ProcesoCompra.CMPid)))>
				if (opt != "0" && opt != "1" && opt != "2" && opt != "9") {
					alert('Deber oprimir el botón de \'Guardar y Continuar >>\'  antes de continuar');
				} else {
					document.form1.opt.value = opt;
					document.form1.submit();
				}
			<cfelseif not (isdefined("Session.Compras.ProcesoCompra.CMPid") and Len(Trim(Session.Compras.ProcesoCompra.CMPid)))>
				if (opt != "0" && opt != "9") {
					alert('Debe seleccionar uno de los procesos de compra o crear uno nuevo antes de continuar');
				} else {
					document.form1.opt.value = opt;
					document.form1.submit();
				}
			<cfelse>
				document.form1.opt.value = opt;
				document.form1.submit();
			</cfif>
		}
	</script>
	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pasos'>
	<cfoutput>
		<table border="0" cellpadding="2" cellspacing="0">

		  <!--- 0 --->
		  <tr>
			<td style="border-bottom: 1px solid black; ">
			  <cfif Session.Compras.ProcesoCompra.Pantalla EQ "0">
				<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
			  <cfelse>
			  	&nbsp;
			  </cfif>
			</td>
			<td align="center" style="border-bottom: 1px solid black; "> <img src="/cfmx/sif/imagenes/home.gif" border="0"> </td>
			<td class="etiquetaProgreso" style="border-bottom: 1px solid black; " nowrap><a href="javascript: goPage('0','0');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;"><strong>Lista de Procesos</strong></a></td>
		  </tr>

		  <!--- 1 --->
		  <tr>
			<td width="1%" align="right">
			  <cfif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Compare(Session.Compras.ProcesoCompra.Pantalla,"1") GT 0>
				<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
			  <cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "1">
				<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
			  </cfif>
			</td>
			<td width="1%" align="right"> <img src="/cfmx/sif/imagenes/number1_16.gif" border="0"> </td>
			<td class="etiquetaProgreso" nowrap><a href="javascript: goPage('1');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Solicitudes de Compra</a></td>
		  </tr>

		  <!--- 2 --->
		  <tr>
			<td width="1%" align="right">
			  <cfif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Compare(Session.Compras.ProcesoCompra.Pantalla,"2") GT 0>
				<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
				<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "2">
				<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
			  </cfif>
			</td>
			<td align="right"><img src="/cfmx/sif/imagenes/number2_16.gif" border="0"></td>
			<td class="etiquetaProgreso" nowrap><a href="javascript: goPage('2','0');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Proceso de Compra</a></td>
		  </tr>

		  <!--- 3 --->
		  <tr>
			<td width="1%" align="right">
			  <cfif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Compare(Session.Compras.ProcesoCompra.Pantalla,"3") GT 0>
				<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
				<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "3">
				<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
			  </cfif>
			</td>
			<td align="right"><img src="/cfmx/sif/imagenes/number3_16.gif" border="0"></td>
			<td class="etiquetaProgreso" nowrap><a href="javascript: goPage('3','0');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Invitaci&oacute;n a Proveedores</a></td>
		  </tr>

		  <!--- 4 --->
		  <cfquery name="rsPublica" datasource="#session.DSN#">
		  	select Pvalor 
		  	from Parametros 
		  	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  	and Pcodigo=570
		  </cfquery>
		  <cfif rsPublica.RecordCount gt 0 and rsPublica.Pvalor eq '1'>
		  	<cfset tituloPaso4 = "Publicaci&oacute;n de Compra">
		  <cfelse>
		  	<cfset tituloPaso4 = "Resumen de Compra">
		  </cfif>

		  <tr>
			<td width="1%" align="right">
			  <cfif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Compare(Session.Compras.ProcesoCompra.Pantalla,"4") GT 0>
				<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
				<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "4">
				<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
			  </cfif>
			</td>
			<td align="right"><img src="/cfmx/sif/imagenes/number4_16.gif" border="0"></td>
			<td class="etiquetaProgreso" nowrap><a href="javascript: goPage('4','0');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">#tituloPaso4#</a></td>
		  </tr>
			
			<cfif isdefined("Session.Compras.ProcesoCompra.CMPid") and (isdefined('Session.Compras.ProcesoCompra.CMPestado') and Session.Compras.ProcesoCompra.CMPestado eq 10)>
			<!--- 5 --->
			<tr>
			<td width="1%" align="right">
			  <cfif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Compare(Session.Compras.ProcesoCompra.Pantalla,"5") GT 0>
				<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
				<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "5">
				<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
			  </cfif>
			</td>
			<td align="right"><img src="/cfmx/sif/imagenes/number5_16.gif" border="0"></td>			
			<td class="etiquetaProgreso" nowrap><a href="javascript: goPage('5','0');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Cotizaci&oacute;n Manual</a></td>														
		  </tr>
		  
		  <cfif rsPublica.RecordCount gt 0 and rsPublica.Pvalor eq '1'>
		  <!--- 6 --->
		  <tr>
			<td width="1%" align="right">
			  <cfif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Compare(Session.Compras.ProcesoCompra.Pantalla,"6") GT 0>
				<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
				<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ "6">
				<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
			  </cfif>
			</td>
			<td align="right"><img src="/cfmx/sif/imagenes/number6_16.gif" border="0"></td>
			<td class="etiquetaProgreso" nowrap><a href="javascript: goPage('6','0');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Importaci&oacute;n de Cotizaciones</a></td>
		  </tr>
		  </cfif>
		  </cfif>
			
		  <!--- 9 --->
		  <tr>
			<td style="border-top: 1px solid black; ">&nbsp;</td>
			<td align="center" style="border-top: 1px solid black; "> <img src="/cfmx/sif/imagenes/file.png" border="0"> </td>
			<td class="etiquetaProgreso" style="border-top: 1px solid black; " nowrap><a href="javascript: goPage('9','0');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Nuevo Proceso</a></td>
		  </tr>
		</table>
	</cfoutput>
	<cf_web_portlet_end> 
</cfif>
