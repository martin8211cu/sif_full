<!--- 
	Modificador por: Ana Villavicencio 
	Fecha: 04 de agosto del 2005
	Motivo: Error en la navegación de la lista de facturas.
			Se agrego el dato de TESSPid en la variable de navegacion.
	Linea: 121
 --->

<cfset titulo = "">
<cfset titulo = 'Preparación de Solicitudes de Pago de Documentos de CxP'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cf_SP_lista tipo="1" irA="solicitudesCP.cfm">
	<cfif NOT isdefined("form.chkCancelados")>
	<table>
		<tr>		  
			<td>		
				<form name="formRedirec" method="post" action="solicitudesCP.cfm" style="margin: '0' ">
				  <input name="PASO" type="hidden" value="1" tabindex="-1">
				  <!--- <input name="btnSel" type="button" value="Seleccionar Documentos de CxP"
				  		onClick="location.href='solicitudesCP.cfm?PASO=1';" tabindex="2"> --->
					<cf_botones tabindex="2" 
						include="btnSel" 
						includevalues="Seleccionar Documentos de CxP"
						exclude="Cambio,Baja,Nuevo,Alta,Limpiar">
				</form>  
			</td>
		</tr>		  
	</table>
	</cfif>
	<cf_web_portlet_end>

<script language="javascript" type="text/javascript">
	function funcbtnSel(){
		location.href='solicitudesCP.cfm?PASO=1';
	}
</script>
