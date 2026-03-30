<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml"	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Competencia" Default="Competencia" returnvariable="LB_Competencia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Objetivo" Default="Objetivo" returnvariable="LB_Objetivo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Inicia" Default="Inicia" returnvariable="LB_Inicia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Finaliza" Default="Finaliza" returnvariable="LB_Finaliza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_EstaSeguroQueDeseaEliminarLasRelacionesMarcadas" 
	Default="Esta seguro que desea eliminar las relaciones marcadas" returnvariable="MSG_EstaSeguroQueDeseaEliminarLasRelacionesMarcadas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" 
	Default="¡Debe seleccionar al menos un registro para relizar esta acción!" returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"/>

<script type="text/javascript">
	function hayMarcados(){
		var form = document.form1;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}
		if (!result) alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>');
		return result;
	}
	
	function funcEliminar(){
		var form = document.form1;
		var msg = "<cfoutput>#MSG_EstaSeguroQueDeseaEliminarLasRelacionesMarcadas#</cfoutput>";
		result = (hayMarcados()&&confirm(msg));
		return result;
	}
	
	function funcRegresar(){
		document.form1.action ='registro_evaluacion.cfm';
		document.form1.submit();
	}
</script>

<!---=============== ELIMINADO DEFINITIVO ===============---->	
<cfif isdefined("form.eliminar2")>
	<cfinvoke component="rh.admintalento.Componentes.RH_EliminarRelacion" method="init" returnvariable="eliminar"/>	
	<cfloop list="#form.chk#" index="id">		
		<cfset eliminar.funcBorrarTodaRelacion(id)>
	</cfloop>
	<cflocation url="registro_evaluacion.cfm">
</cfif>
<!----===================================================---->

<cfif isdefined("va_pendientes") and len(trim(va_pendientes))></cfif>
<cf_dbfunction name="concat" args="c.DEidentificacion,' - ',c.DEapellido1 ,' ',c.DEapellido2,' ',c.DEnombre" returnvariable="empleado">
<cfquery name="rsDatosRelacion" datasource="#session.DSN#">
	select 	a.RHRSid
			,a.RHRSdescripcion
			,case a.RHRStipo when 'C' then 
							'#LB_Competencia#' 
						 else
						 	'#LB_Objetivo#'
			end as Tipo	
			,a.RHRSinicio
			,a.RHRSfin
			,<cf_dbfunction name="concat" args="c.DEidentificacion,' - ',c.DEapellido1 ,' ',c.DEapellido2,' ',c.DEnombre"> as empleado
	from RHRelacionSeguimiento a
		inner join RHEvaluados b
			on a.RHRSid = b.RHRSid
		inner join DatosEmpleado c
			on b.DEid = c.DEid
	where a.RHRSid in (#va_pendientes#)
</cfquery>
<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">	
	<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
	<script src="/cfmx/rh/js/utilesMonto.js"></script>
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
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_RelacionesDeSeguimientoDelTalento"
						Default="Relaciones de Seguimiento del Talento"
						returnvariable="LB_RelacionesDeSeguimientoDelTalento"/>		
                  	<cf_web_portlet_start border="true" titulo="#LB_RelacionesDeSeguimientoDelTalento#" skin="#Session.Preferences.Skin#">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						<form name="form1" action="verificacion_eliminado.cfm" method="post" onSubmit="javascript: return funcEliminar();">
							<table width="98%" cellpadding="0" cellspacing="0">
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td><b style="color:#FF0000;"><cf_translate key="LB_LasSiguientesRelacionesDeSeguimientoEstanPendientesDeFinalizar">
										Las siguientes relaciones de seguimiento est&aacute;n pendientes de finalizar
									</cf_translate>:</b></td>
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td>										
										<cfinvoke component="rh.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#rsDatosRelacion#"/>
											<cfinvokeargument name="desplegar" value="RHRSdescripcion, empleado, RHRSinicio,RHRSfin"/>
											<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_Empleado#, #LB_Inicia#, #LB_Finaliza#"/>
											<cfinvokeargument name="formatos" value="S,S,D,D"/>
											<cfinvokeargument name="align" value="left,left,left,left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="maxRows" value="20"/>						
											<cfinvokeargument name="Cortes" value="Tipo"/>
											<cfinvokeargument name="checkboxes" value="S">
											<cfinvokeargument name="keys" value="RHRSid">	
											<cfinvokeargument name="incluyeForm" value="false">	
											<cfinvokeargument name="formName" value="form1">	
										</cfinvoke>
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td align="center">
										<input type="submit" name="Eliminar2" value="Eliminar" class="btneliminar" >
										<input type="button" name="Regresar" value="Regresar" onClick="javascript: funcRegresar();" class="btnAnterior">
									</td>
								</tr>
							</table>
						</form>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>