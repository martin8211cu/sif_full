<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descripcion"
	Default="Descripci&oacute;n"
	xmlfile="/rh/generales.xml"	
	returnvariable="vDescripcion"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Periodo"
	Default="Periodo"	
	returnvariable="vPeriodo"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_FechaD"
	Default="Fecha Desde"
	xmlfile="/rh/generales.xml"	
	returnvariable="vFecha"/>
    		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_FechaH"
	Default="Fecha Hasta"
	xmlfile="/rh/generales.xml"	
	returnvariable="vFechaH"/>	
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Monto"
	Default="Monto"
	xmlfile="/rh/generales.xml"	
	returnvariable="vMonto"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Dias_enfermedad"
	Default="D&iacute;as de enfermedad"
	returnvariable="vDiasEnfermedad"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="vReposicion"
	Default="Reposici&oacute;n D&iacute;as"
	returnvariable="vReposicion"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Dias_compensados"
	Default="D&iacute;as compensados"
	returnvariable="vDiasCompensados"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Eliminar"
	Default="Eliminar"
	returnvariable="vBorrar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Mostrar"
	Default="Mostrar"
	xmlfile="/rh/generales.xml"		
	returnvariable="vMostrar"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Agregar"
	Default="Agregar"
	xmlfile="/rh/generales.xml"	
	returnvariable="vAgregar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Limpiar"
	Default="Limpiar"
	xmlfile="/rh/generales.xml"	
	returnvariable="vLimpiar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Filtrar"
	Default="Filtrar"
	xmlfile="/rh/generales.xml"	
	returnvariable="vFiltrar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Dias"
	Default="D&iacute;as"
	xmlfile="/rh/generales.xml"	
	returnvariable="vDias"/>
    
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Default="Devoluci&oacute;n de dias de Faltas para Aguinaldo" VSgrupo="103" returnvariable="nombre_proceso" component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"/>

<!---<cf_dump var = "#form.RHDFid#">--->

<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.txtDescripcion") and not isdefined("Form.txtDescripcion")>
	<cfparam name="Form.txtDescripcion" default="#Url.txtDescripcion#">
</cfif>

<cfif isdefined("Url.vaca_ver") and not isdefined("Form.vaca_ver")>
	<cfparam name="Form.vaca_ver" default="#Url.vaca_ver#">
</cfif>

<!---<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>--->
<cfif not isdefined("Form.modo")>
	<cfset modo="ALTA">
<cfelseif Form.modo EQ "CAMBIO">
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>
<!---</cfif>--->

<cfif modo EQ "CAMBIO" and isdefined('form.DEid') and form.DEid NEQ '' and isdefined('form.RHDFid') and form.RHDFid NEQ ''>
	<cfquery datasource="#Session.DSN#" name="rsForm">
		select DEid, RHDFdescripcion,RHDFfechadesde,RHDFfechahasta,RHDFcantdias
		from RHDevolucionFaltas 
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
        and RHDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDFid#">
    </cfquery>
</cfif>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_web_portlet_start border="true" titulo="<cfoutput>#nombre_proceso#</cfoutput>" skin="#Session.Preferences.Skin#">
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
	  <tr>
		<td>
			<cfinclude template="/rh/portlets/pEmpleado.cfm">
		</td>
	  </tr>
	  <tr>
		<td>
		  <table width="95%" border="0" cellspacing="0" cellpadding="0" style="margin-left: 10px; margin-right: 10px;">
			<tr>
			  <td width="46%" align="center" valign="top">
			  
			  	<table width="99%" border="0" cellspacing="3" cellpadding="3">
				  <tr>
					<td>
						<form name="formFiltroListaVaca" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
							<input type="hidden" name="DEid" value="<cfoutput>#form.DEid#</cfoutput>">
							<input name="sel" type="hidden" value="1">
							<input type="hidden" name="o" value="9">				
							
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
								<tr> 
									<td class="fileLabel" width="50%"><cfoutput>#vDescripcion#:</cfoutput></td>
									<td rowspan="2" valign="middle"  width="50%"><input class="btnFiltrar" name="btnFiltrarVaca" type="submit" id="btnFiltrarVaca" value="<cfoutput>#vFiltrar#</cfoutput>"></td>
								</tr>

								<tr> 
									<td width="50%" nowrap><input name="txtDescripcion" type="text" id="txtDescripcion" size="35" maxlength="60" value="<cfif isdefined('form.txtDescripcion')><cfoutput>#form.txtDescripcion#</cfoutput></cfif>"></td>																	
								</tr>
							</table>
						</form>							
							</td>
						  </tr>
						  <tr>
							<td nowrap>
                            <cfquery datasource="#session.DSN#" name="rsLista">
                            select RHDFid,DEid, RHDFdescripcion,RHDFfechadesde,RHDFfechahasta,RHDFcantdias
							from RHDevolucionFaltas 
							where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                            </cfquery>
							
							<cfinvoke 
								 component="rh.Componentes.pListas"
								 method="pListaQuery"
								 returnvariable="pListaFam">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="RHDFdescripcion,RHDFfechadesde,RHDFfechahasta,RHDFcantdias"/>
									<cfinvokeargument name="etiquetas" value="#vDescripcion#,#vFecha#,#vFechaH#,#vReposicion#"/>
									<cfinvokeargument name="formatos" value="V,D,D,I"/>
									<cfinvokeargument name="formName" value="listaDevolucionFechas"/>	
									<cfinvokeargument name="align" value="left,left,left,right"/>
									<cfinvokeargument name="ajustar" value="S"/>			
									<cfinvokeargument name="debug" value="N"/>
									<cfinvokeargument name="usaAjax" value="true"/>
									<cfinvokeargument name="conexion" value="#session.dsn#"/>
									<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>	
                                    <!---<cfinvokeargument name="keys" value="#RHDFid#"/>--->	
									<!---<cfinvokeargument name="navegacion" value="#navegacionVaca#"/>--->
							</cfinvoke>							

							
						</td>
						  </tr>
						</table>
				  </td>
				  <td width="4%" align="center" valign="top">&nbsp;</td>
				  <td width="50%" valign="top" nowrap> 
				  <cfoutput>

					<form name="formDevolFaltasEmpl" action="RelacionDevolucionFaltas-sql.cfm" enctype="multipart/form-data" method="post" onmousedown="cantDias();">
					<input name="DEid" type="hidden" value="<cfif isdefined('form.DEid') and form.DEid NEQ ''><cfoutput>#form.DEid#</cfoutput></cfif>">
                    <input name="RHDFid" type="hidden" value="<cfif isdefined('form.RHDFid') and form.RHDFid NEQ ''><cfoutput>#form.RHDFid#</cfoutput></cfif>">
						
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr> 
							  <td colspan="2" class="#Session.preferences.Skin#_thcenter" style="padding-left: 5px;"><cf_translate key="LB_Reposicion_Faltas">Reposici&oacute;n de Faltas</cf_translate></td>
						  </tr>						
						  <tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						  </tr>						  
						  <tr>
							<td colspan="2"><hr></td>
						  </tr>
						  <tr>
							<td><strong>#vFecha#</strong></td>
							<td id="label" nowrap="nowrap"><strong>#vFechaH#</td>
						  </tr>
						  <tr>
							<td>
								<cfif MODO EQ "ALTA">
									<cf_sifcalendario form="formDevolFaltasEmpl" name="fechaDesde" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
								<cfelse>
									<cfoutput>
									<cf_sifcalendario form="formDevolFaltasEmpl" name="fechaDesde" value="#LSDateFormat(rsForm.RHDFfechadesde,'DD/MM/YYYY')#">
									</cfoutput>
								</cfif>							
							</td>
                            <td nowrap>
								<cfif MODO EQ "ALTA">
									<cf_sifcalendario form="formDevolFaltasEmpl" name="fechaHasta" value="#LSDateFormat(Now(),'DD/MM/YYYY')#" onChange="cantDias()">
								<cfelse>
									<cfoutput>
									<cf_sifcalendario form="formDevolFaltasEmpl" name="fechaHasta" value="#LSDateFormat(rsForm.RHDFfechahasta,'DD/MM/YYYY')#" onChange="cantDias()">
									</cfoutput>
								</cfif>	
							</td>							
						  </tr>
                          <tr>
							<td><strong>#vReposicion#</strong></td>
							<td id="label" nowrap="nowrap"></td>
						  </tr>
                          <tr>
                            <td nowrap>
                            <cfif MODO EQ "ALTA">
									<input name="DFdias" type="text" value="0" size="10" maxlength="8" style="text-align: right;">
							<cfelse>
                                <cfoutput>
									<input name="DFdias" type="text" value="#rsForm.RHDFcantdias#" size="10" maxlength="8" style="text-align: right;">
								</cfoutput>
							</cfif>	
						
							</td>
                            <td>
                            </td>							
						  </tr>
						  <tr>
							<td><strong>#vDescripcion#</strong></td>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
							<td colspan="2">
                            <cfif MODO EQ "ALTA">
                            	<input name="DFdescripcion" value="" type="text" id="DFdescripcion" size="60" maxlength="60">
                            <cfelse>
                            	<input name="DFdescripcion" value="#rsForm.RHDFdescripcion#" type="text" id="DFdescripcion" size="60" maxlength="60">
                            </cfif>
                            </td>
						  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td colspan="2" align="center">
							<cfif modo NEQ 'ALTA'>
								<input type="submit" name="btnEliminar"   value="#vBorrar#">																
							<cfelse>
								<input type="submit" name="btnAgregar" value="#vAgregar#" >								
								<input type="reset"  name="btnLimpiar"  value="#vLimpiar#" >																				
							</cfif>
						</td>
					  </tr>							  						  
						</table>
					</form>					
				</cfoutput>
			  </td>
			</tr>	
		  </table>
	    </td>
	  </tr>
	</table>
<cf_web_portlet_end>
<cf_templatefooter>
  
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>

<cfoutput>
<!------->
<script language="JavaScript" type="text/javascript">

	function cantDias(){	
		var d1 = document.formDevolFaltasEmpl.fechaDesde.value.split('/');
		var dat1 = new Date(d1[2], parseFloat(d1[1])-1, parseFloat(d1[0]));
		var d2 = document.formDevolFaltasEmpl.fechaHasta.value.split('/');
		var dat2 = new Date(d2[2], parseFloat(d2[1])-1, parseFloat(d2[0]));
 
		var fin = dat2.getTime() - dat1.getTime();
		var dias = Math.floor(fin / (1000 * 60 * 60 * 24))  
		
		document.formDevolFaltasEmpl.DFdias.value = dias + 1 ;
				
	}
</script>
</cfoutput>
