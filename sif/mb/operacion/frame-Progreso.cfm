 <!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 17 de mayo del 2005
	Motivo:	Se agrego un nuevo paso en le proceso de conciliación bancaria. 
			Se agregó un nuevo acceso_uri para el proceso de Conciliación Automatica.
	Lineas:	47-69
----------->

<cfset LvarIrAConcAuto="/cfmx/sif/mb/operacion/ConciliacionAutomatica.cfm">
<cfset LvarIrAConciliacion="/cfmx/sif/mb/operacion/Conciliacion.cfm">
<cfset LvarIrAlistECP="/cfmx/sif/mb/operacion/listaEstadosCuentaEnProceso.cfm">
<cfset LvarIrAConcLibre="/cfmx/sif/mb/operacion/Conciliacion-Libre.cfm">
<cfset LvarIrAListaPreConci="/cfmx/sif/mb/operacion/listaPreConciliacion.cfm">
<cfset LvarIrAresumenConci="/cfmx/sif/mb/operacion/resumenConciliacion.cfm">
<!--- Nombres de los pasos según el modulo desde el cual se invoque--->
<!---1--->
<cfset LvarNamePasoUno="Estados de Cuenta">

 <cfif isdefined("LvarTCEFrameProgreso")>
 	<cfset LvarIrAConcAuto="/cfmx/sif/tce/operaciones/TCEConciliacionAutomatica.cfm">
	<cfset LvarIrAConciliacion="/cfmx/sif/tce/operaciones/TCEConciliacion.cfm">
	<cfset LvarIrAlistECP="/cfmx/sif/tce/operaciones/listaEstadosCuentaProcesoTCE.cfm">
	<cfset LvarIrAConcLibre="/cfmx/sif/tce/operaciones/TCEConciliacion-Libre.cfm">
	<cfset LvarIrAListaPreConci="/cfmx/sif/tce/operaciones/TCElistaPreConciliacion.cfm">
	<cfset LvarIrAresumenConci="/cfmx/sif/tce/operaciones/TCEresumenConciliacion.cfm">
	<cfset LvarNamePasoUno="Estados de Cuenta TCE">
 </cfif>
 
<script language="javascript" type="text/javascript">
	function goPage(page) {
		if (document.form1.opt) {
			document.frmGoPage.ECid.value = document.form1.opt.value;
		}
		if (document.frmGoPage.ECid.value != '') {
			document.frmGoPage.action = page;
			document.frmGoPage.submit();
		} else {
			alert('No hay ningún Estado de Cuenta Seleccionado');
		}
	}
</script>
<style type="text/css">
<!--
.style1 {font-size: 10px}
-->
</style>


<form name="frmGoPage" action="" method="post" style="margin: 0;">
	<input type="hidden" name="ECid" value="<cfif isdefined("Form.ECid")><cfoutput>#Form.ECid#</cfoutput></cfif>">
</form>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pasos'>
	<table border="0" cellpadding="2" cellspacing="0">
    
		<cfif acceso_uri('/sif/mb/operacion/listaEstadosCuentaEnProceso.cfm') or acceso_uri('/sif/tce/operaciones/listaEstadosCuentaProcesoTCE.cfm') >
		
		<!---======================== 1 ========================================--->
			<tr>
				<td width="1%" align="right">
					<cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"1") GT 0 >
						<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
					<cfelseif Session.Progreso.Pantalla EQ "1">
						<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
					</cfif>
				</td>
				<td width="1%" align="right"> <img src="/cfmx/sif/imagenes/menu/num1_small.gif" border="0"> </td>
				<td class="etiquetaProgreso" nowrap>
					
					<!---Direccionar a la pagina correspondiente listaEstadosCuentaEnProceso.cfm o listaEstadosCuentaEnProcesoTCE.cfm --->
					<a href="javascript: goPage('<cfoutput>#LvarIrAlistECP#</cfoutput>'); " class="style1" tabindex="-1">
					<cfoutput>#LvarNamePasoUno#</cfoutput></a></td>
			</tr>
		</cfif>
        
        <cfif acceso_uri('/sif/mb/operacion/ConciliacionAutomatica.cfm') or acceso_uri('/sif/tce/operaciones/TCEConciliacionAutomatica.cfm') >

		<!---======================== 2 ========================================--->
			<tr>
				<td width="1%" align="right">
					<cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"2") GT 0>
						<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
					<cfelseif Session.Progreso.Pantalla EQ "2">
						<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
					</cfif>
				</td>
				<td align="right"><img src="/cfmx/sif/imagenes/menu/num2_small.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap>
					<cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"1") GT 0 >
					
					<!---Direccionar a la pagina correspondiente ConciliacionAutomatica.cfm o TCEConciliacionAutomatica.cfm --->
 					<a href="javascript: goPage('<cfoutput>#LvarIrAConcAuto#</cfoutput>');" class="style1" 
						tabindex="-1">											
						Conciliaci&oacute;n Autom&aacute;tica					</a>
					<cfelse>
						<span class="style1">Conciliaci&oacute;n Autom&aacute;tica</span>
					</cfif>
				</td>
			</tr>
		</cfif>


		<cfif acceso_uri('/sif/mb/operacion/Conciliacion.cfm') or acceso_uri('/sif/tce/operaciones/TCEConciliacion.cfm')>
		
		<!---========================3 ========================================--->
			<tr>
				<td width="1%" align="right">
					<cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"3") GT 0>
						<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
					<cfelseif Session.Progreso.Pantalla EQ "3">
						<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
					</cfif>
				</td>
				<td align="right"><img src="/cfmx/sif/imagenes/menu/num3_small.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap>
					<cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"1") GT 0 >
					<a href="javascript: goPage('<cfoutput>#LvarIrAConciliacion#</cfoutput>');" class="style1" 
						tabindex="-1">
						Conciliaci&oacute;n Equivalencia					</a>
					<cfelse>
						<span class="style1">Conciliaci&oacute;n Equivalencia</span>
					</cfif>
				</td>
			</tr>
		</cfif>
		<cfif acceso_uri('/sif/mb/operacion/Conciliacion-Libre.cfm') or acceso_uri('/sif/tce/operaciones/TCEConciliacion-Libre.cfm')  >
		
		<!---======================== 4 ========================================--->
			<tr>
				<td width="1%" align="right">
					<cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"4") GT 0>
						<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
					<cfelseif Session.Progreso.Pantalla EQ "4">
						<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
					</cfif>
				</td>
				<td align="right"><img src="/cfmx/sif/imagenes/menu/num4_small.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap>
					<cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"1") GT 0 >
					<a href="javascript: goPage('<cfoutput>#LvarIrAConcLibre#</cfoutput>');" class="style1" 
						tabindex="-1">
						Conciliaci&oacute;n Libre					</a>
					<cfelse>
						<span class="style1">Conciliaci&oacute;n Libre</span>
					</cfif>
				</td>
			</tr>
		</cfif>
		<cfif acceso_uri('/sif/mb/operacion/listaPreConciliacion.cfm') or acceso_uri('/sif/tce/operaciones/TCElistaPreConciliacion.cfm')>
		
		<!---======================== 5 ========================================--->
			<tr>
				<td width="1%" align="right">
					<cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"5") GT 0>
						<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
					<cfelseif Session.Progreso.Pantalla EQ "5">
						<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
					</cfif>
				</td>
				<td align="right"><img src="/cfmx/sif/imagenes/menu/num5_small.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap>
					<cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"1") GT 0 >
					<a href="javascript: goPage('<cfoutput>#LvarIrAListaPreConci#</cfoutput>');" class="style1" tabindex="-1">
						Documentos Conciliados					</a>
					<cfelse>
						<span class="style1">Documentos Conciliados</span>
					</cfif>
				</td>
			</tr>
		</cfif>
		
		<cfif acceso_uri('/sif/mb/operacion/resumenConciliacion.cfm') or acceso_uri('/sif/tce/operaciones/TCEresumenConciliacion.cfm') >
		
		<!---======================== 6 ========================================--->
			<tr>
				<td width="1%" align="right">
					<cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"6") GT 0>
						<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
					<cfelseif Session.Progreso.Pantalla EQ "6">
						<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
					</cfif>
				</td>
				<td align="right"><img src="/cfmx/sif/imagenes/menu/num6_small.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap>
					<cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"1") GT 0 >
					<a href="javascript: goPage('<cfoutput>#LvarIrAresumenConci#</cfoutput>');" class="style1" tabindex="-1">
						Aplicar Conciliación					</a>
					<cfelse>
						<span class="style1">Aplicar Conciliaci&oacute;n</span>
					</cfif>
				</td>
			</tr>
		</cfif>
	</table>
<cf_web_portlet_end> 
