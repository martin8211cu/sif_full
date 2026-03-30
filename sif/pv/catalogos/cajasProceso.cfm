<cfif isdefined("url.Paso")>
	<cfset form.Paso = url.Paso>		
</cfif>
<cfif isdefined("url.FAM01COD")>
	<cfset form.FAM01COD = url.FAM01COD>
</cfif> 
<cfparam name="form.Paso" default="0">
<cfparam name="params" default="">
<cfif isdefined('url.FAM09MAQ') and len(trim(url.FAM09MAQ))>
	<cfset form.FAM09MAQ = url.FAM09MAQ>
</cfif>
<cfif isdefined('form.FAM09MAQ') and len(trim(form.FAM09MAQ))>
	<cfset params = params & "&FAM09MAQ=" & form.FAM09MAQ>
</cfif>
<cf_templateheader title="Punto de Venta - Definicion de Cajas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Definición de Cajas'>
		<!---Tabla Principal---->
		<br>
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td valign="top">
					<!---Pinta un encabezado común en todas las pantallas--->
					<cfinclude template="cajasProceso-header.cfm">
				  	<cfif form.Paso EQ 0>
						<cfinclude template="cajasProceso_Paso0.cfm">
					<cfelseif form.Paso EQ 1>
						<cfinclude template="cajasProceso_Paso1.cfm">
					<cfelseif form.Paso EQ 2>
						<cfinclude template="cajasProceso_Paso2.cfm">
					<cfelseif form.Paso EQ 3>
						<cfinclude template="cajasProceso_Paso3.cfm">
					</cfif>	
				</td>
				<td width="1%" valign="top">
					<!---Secciones de progreso y ayuda--->
					<cfinclude template="cajasProceso_Progreso.cfm"><br>
					<cfinclude template="cajasProceso_Ayuda.cfm">
				</td>
		  </tr>
	   </table>
	   </br>	
	   <!---Funciones estándar para avanzar y retroceder--->
		<script language="javascript" type="text/javascript">
			function funcSiguiente() {
				if ('#params#'.length==0){
					alert("#JSStringFormat('Debe seleccionar una máquina.')#");
					return false;
				}
				location.href="cajasProceso.cfm?Paso=#form.Paso+1##params#";
				return false;
			}
			function funcAnterior() {
				location.href="cajasProceso.cfm?Paso=#form.Paso-1##params#";
				return false;
			}
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>	
		