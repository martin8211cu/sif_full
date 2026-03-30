<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Evaluaciones_del_Desempeno_a_Otro_Grupal" default="Evaluaciones del Desempe&ntilde;o a Otro (Grupal)" returnvariable="LB_Evaluaciones_del_Desempeno_a_Otro_Grupal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DebeSeleccionarAlMenosUnaEvaluacion" default="Debe seleccionar al menos una evaluación" returnvariable="MSG_DebeSeleccionarAlMenosUnaEvaluación" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar" xmlfile="/rh/generales.xml" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" xmlfile="/rh/generales.xml"returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NoSeEncontraronRegistros" default="No se encontraron Registros" returnvariable="MSG_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>	
  
<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="../../../css/rh.css" rel="stylesheet" type="text/css">
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
	  <cfset Session.Params.ModoDespliegue = 0>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2"  cellspacing="0">
			<tr>
				<td valign="top">		    	            
					<cfinclude template="/rh/Utiles/consulta-Empleado.cfm">
					<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
						<cfset form.tipo = url.tipo >
					</cfif>
					<cfif isdefined("url.fRelacion") and not isdefined("form.fRelacion")>
						<cfset form.fRelacion = url.fRelacion >
					</cfif>
					<cfif isdefined("url.fPCodigo") and not isdefined("form.fPCodigo")>
						<cfset form.fPCodigo = url.fPCodigo >
					</cfif>
					<cfif isdefined("url.fPDescripcion") and not isdefined("form.fPDescripcion")>
						<cfset form.fPDescripcion = url.fPDescripcion >
					</cfif>

	              	<script language="JavaScript1.2" type="text/javascript">
						function algunoMarcado(){
								var f = document.form2;
								if (f.chk) {
									if (f.chk.checked) {
										return true;
									} else {
										for (var i=0; i<f.chk.length; i++) {
											if (f.chk[i].checked) { 
												return true;
											}
										}
									}
								}
								alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnaEvaluación#</cfoutput>');
								return false;
							}					
						function funcFinalizar(){
							if(algunoMarcado()){
								document.form2.action = 'evaluar_des_finalizar.cfm';
								document.form2.submit();
							}
							return false;
						}
		       		</script>
					
					<cf_web_portlet_start titulo="#LB_Evaluaciones_del_Desempeno_a_Otro_Grupal#">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
							<tr>
								<td>
									<cfoutput>
										<form style="margin:0; " name="filtro" method="post" action="evaluar_des-lista.cfm">
											<table width="100%" cellpadding="0" cellspacing="0" class="tituloListas">
												<tr>
													<td width="7%" nowrap="nowrap"><strong>
												  <cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:</strong></td>
													<td width="47%">
														<input type="text" name="fPDescripcion" size="100" maxlength="255" 
															value="<cfif isdefined("form.fPDescripcion") and  len(trim(form.fPDescripcion)) >#form.fPDescripcion#</cfif>" 
															onfocus="this.select();">
												  </td>
													<td width="46%" align="left" nowrap="nowrap">
														<input type="submit" name="Filtrar" value="#BTN_Filtrar#">
														<input type="button" name="Limpiar" value="#BTN_Limpiar#" onclick="javascript:limpiar();"> 
														
												  </td>
												</tr>
											</table>
										</form>
						
										<script language="javascript1.2" type="text/javascript">
											function limpiar(){
												document.filtro.fPDescripcion.value = '';
											}
										</script>
						
									</cfoutput>
								</td>
							</tr>

							<tr>
								<td>					
									<cfset navegacion = ''>
									<cf_dbfunction name="to_datechar" args="'#LSDateFormat(Now(),'dd-mm-yyyy')#'" returnvariable="Lvar_GetDate">
									<cf_dbfunction name="to_datechar" args="a.RHEEfdesde" returnvariable="Lvar_RHEEfdesde">
									<cf_dbfunction name="to_datechar" args="a.RHEEfhasta" returnvariable="Lvar_RHEEfhasta">
									<cf_dbfunction name="dateadd" args="1|#Lvar_RHEEfhasta#" delimiters="|" returnvariable="Lvar_RHEEfhasta1">
									
									
									<cfset filtro = 'a.Ecodigo=#session.Ecodigo#
												 and a.RHEEestado in (2,5)
												 and getdate() 
											     between #Lvar_RHEEfdesde#  and #Lvar_RHEEfhasta# and c.DEid!=#rsEmpleado.DEid#'>
									<cfset campos_extra = '' >
									<cfif isdefined("form.fPDescripcion") and len(trim(form.fPDescripcion))>
										<cfset filtro = filtro & " and upper(a.RHEEdescripcion) like  '%#Ucase(form.fPDescripcion)#%' ">
										<cfset campos_extra = campos_extra & ", '#form.fPDescripcion#' as fPDescripcion" >
										<cfset navegacion = navegacion & "&fPDescripcion=#form.fPDescripcion#" >
									</cfif>
									<!--- and getdate() between a.RHEEfdesde  and a.RHEEfhasta --->
									<cfset filtro = filtro &  '	and c.DEideval=#rsEmpleado.DEid# 
																and a.RHEEid=c.RHEEid
																and b.RHEEid=c.RHEEid
																and b.DEid=c.DEid
																and a.RHEEestado in (2,5)
																
																and a.RHEEid not in (
																select PCUreferencia 
																from PortalCuestionarioU pcu
																where pcu.PCUestado=10
																	and pcu.PCUreferencia = a.RHEEid
																	and pcu.DEid = b.DEid
																	and pcu.DEideval= #rsEmpleado.DEid# )' >
																
									<cfset filtro = filtro & ' order by a.RHEEdescripcion' >							
									<cfinvoke 
										component="rh.Componentes.pListas"
										method="pListaRH"
										returnvariable="pListaCar">
											<cfinvokeargument name="tabla" value="RHEEvaluacionDes a, RHListaEvalDes b,RHEvaluadoresDes c"/>
											<cfinvokeargument name="columnas" value="distinct a.RHEEid , PCid,RHEEdescripcion ,RHEEfdesde,RHEEfhasta  #campos_extra#"/>
											<cfinvokeargument name="desplegar" value="RHEEdescripcion"/>
											<cfinvokeargument name="etiquetas" value="#LB_Descripcion#"/>
											<cfinvokeargument name="formatos" value="V"/>
											<cfinvokeargument name="filtro" value="#filtro#"/>
											<cfinvokeargument name="align" value="left"/>
											<cfinvokeargument name="ajustar" value=""/>				
											<cfinvokeargument name="irA" value="evaluar_des-lista2.cfm"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
											<cfinvokeargument name="navegacion" value="#navegacion#"/>
											<cfinvokeargument name="debug" value="N"/>
											<cfinvokeargument name="maxRows" value="30"/>
											<cfinvokeargument name="keys" value="RHEEid,PCid"/>
											<cfinvokeargument name="formName" value="form2"/>
											<cfinvokeargument name="EmptyListMsg" value="#MSG_NoSeEncontraronRegistros#"/>
											<cfinvokeargument name="debug" value="N"/>
									</cfinvoke>		
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>	  
		            <cf_web_portlet_end>
     			</td>	
			</tr>
		</table>	
<cf_templatefooter>