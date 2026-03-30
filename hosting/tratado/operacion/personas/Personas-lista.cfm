<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tratado_De_Libre_Comercio"
	Default="Tratado de Libre Comercio"
	returnvariable="LB_title"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Personas"
	Default="Personas"
	returnvariable="LB_Personas"/>
	
	<cf_templatearea name="title">
		<cfoutput>#LB_title#</cfoutput>
	</cf_templatearea>
	
    
    
	<cf_templatearea name="body">
		<cfinclude template="../../../../sif/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!--- ========================================================== --->
					<!--- 						TRADUCCION							 --->
					<!--- ========================================================== --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Empresa"
						Default="Empresa"
						returnvariable="LB_Empresa"/>
					
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Cedula"
						Default="C&eacute;dula"
						returnvariable="LB_Cedula"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Nombre"
						Default="Nombre"
						returnvariable="vNombre"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Filtrar"
						Default="Filtrar"
						returnvariable="vFiltrar"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Nueva_Persona"
						Default="Nueva Persona"
						returnvariable="LB_Nueva_Persona"/>
                        
                      <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Importar_Personas"
						Default="Importar Personas"
						returnvariable="LB_Importar_Personas"/> 
                        
						
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Lista_de_Empresas"
						Default="Lista de Empresas"
						returnvariable="LB_Lista_de_Empresas"/>
					
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Cedula_Juridica"
						Default="C&eacute;dula Juridica"
						returnvariable="LB_Cedula_Juridica"/> 
						
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Nombre"
						Default="Nombre"
						returnvariable="vNombre"/>
                     <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_PrimerApellido"
						Default="Primer Apellido"
						returnvariable="Apellido1"/>
                        
                      <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_SegundoApellido"
						Default="Segundo Apellido"
						returnvariable="Apellido2"/>     
					
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="msg_DebeSeleccionarUna_empresa"
						Default="Debe seleccionar una empresa"
						returnvariable="msg_DebeSeleccionarUna_empresa"/>	
                     
                     <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="msg_Sincronizada"
						Default="Sincronizada (o)"
						returnvariable="vSincronizado"/>	
                        
                     <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="msg_Sincronizado"
						Default="Sincronizado"
						returnvariable="vSincronizadox"/>      
                        
                        
					<!--- ========================================================== --->
					<!--- ========================================================== --->

					<cf_web_portlet_start border="true" titulo="<cfoutput>#LB_Personas#</cfoutput>" skin="#Session.Preferences.Skin#">
						
						<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
							<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
						</cfif>
						<cfif isdefined("Url.CedulaFiltro") and not isdefined("Form.CedulaFiltro")>
							<cfparam name="Form.CedulaFiltro" default="#Url.CedulaFiltro#">
						</cfif>		
						<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
							<cfparam name="Form.filtrado" default="#Url.filtrado#">
						</cfif>	
						<cfif isdefined("Url.ETLCid") and not isdefined("Form.ETLCid")>
							<cfparam name="Form.ETLCid" default="#Url.ETLCid#">
						</cfif>
	
						<cfset filtro = "">
						<cfset navegacion = "">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">

						<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
						</cfif>
						<cfif isdefined("Form.CedulaFiltro") and Len(Trim(Form.CedulaFiltro)) NEQ 0>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CedulaFiltro=" & Form.CedulaFiltro>
						</cfif>
						
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<cfset regresar = "/cfmx/hosting/tratado/index.cfm">
							<tr><td><cfinclude template="../../../../sif/portlets/pNavegacion.cfm"></td></tr>
							
							<tr><td><b><cf_translate  key="LB_Seleccione_una_empresa_para_ver_las_personas_asociadas">Seleccione una empresa para ver las personas asociadas</cf_translate></b></td></tr>	  
							<tr style="display: ;" id="verFiltroListaEmpl"> 
								<td> 
							  		<form name="formFiltroListaPersona" method="post" action="Personas-lista.cfm">
										<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
										<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
										
										<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
											<tr>
												<td><strong><cfoutput>#LB_Empresa#</cfoutput>:</strong></td>
												<td colspan="6">
													<cfset ArrayEmpresa=ArrayNew(1)>
													<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid))>
														<cfquery name="rsEmpresas" datasource="#session.DSN#">
															select ETLCid,ETLCpatrono,ETLCnomPatrono,ETLCespecial
															from EmpresasTLC
															where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#"> 
														</cfquery>
														<cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCid)>
														<cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCpatrono)>
														<cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCnomPatrono)>
														<cfset ArrayAppend(ArrayEmpresa,rsEmpresas.ETLCespecial)>
													</cfif>
													<cf_conlis
														Campos="ETLCid,ETLCpatrono,ETLCnomPatrono,ETLCespecial"
														Desplegables="N,S,S,N"
														Modificables="N,S,N,N"
														Size="0,10,60,0"
														tabindex="1"
														ValuesArray="#ArrayEmpresa#" 
														Title="#LB_Lista_de_Empresas#"
														Tabla="EmpresasTLC"
														Columnas="ETLCid,ETLCpatrono,ETLCnomPatrono,ETLCespecial"
														Desplegar="ETLCpatrono,ETLCnomPatrono"
														Etiquetas="#LB_Cedula_Juridica#,#vNombre#"
														filtrar_por="ETLCpatrono,ETLCnomPatrono"
														Formatos="S,S"
														Align="left,left"
														funcion="cargaempresa"
														form="formFiltroListaPersona"
														Asignar="ETLCid,ETLCpatrono,ETLCnomPatrono,ETLCespecial"
														Asignarformatos="S,S,S,S"/>
												</td>
											</tr>
											<tr> 
												<td width="20%" height="17" class="fileLabel"><cfoutput>#LB_Cedula#</cfoutput></td>
                                                <td width="20%" class="fileLabel"><cfoutput>#Apellido1#</cfoutput></td>
                                                <td width="20%" class="fileLabel"><cfoutput>#Apellido2#</cfoutput></td>
                                                <td width="20%" class="fileLabel"><cfoutput>#vNombre#</cfoutput></td>
                                                <cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) and rsEmpresas.ETLCespecial eq 0>
													<td width="20%" class="fileLabel"><cfoutput>#vSincronizadox#</cfoutput></td>
												</cfif>
												<td width="5%" colspan="2" rowspan="2"><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#vFiltrar#</cfoutput>"></td>
											</tr>
											<tr> 
												<td><input name="CedulaFiltro" type="text" id="CedulaFiltro" size="30" maxlength="60" value="<cfif isdefined('form.CedulaFiltro')><cfoutput>#form.CedulaFiltro#</cfoutput></cfif>"></td>
												<td><input name="apellido1Filtro" type="text" id="apellido1Filtro" size="30" maxlength="80" value="<cfif isdefined('form.apellido1Filtro')><cfoutput>#form.apellido1Filtro#</cfoutput></cfif>"></td>
												<td><input name="apellido2Filtro" type="text" id="apellido2Filtro" size="30" maxlength="80" value="<cfif isdefined('form.apellido2Filtro')><cfoutput>#form.apellido2Filtro#</cfoutput></cfif>"></td>
												<td><input name="nombreFiltro" type="text" id="nombreFiltro2" size="30" maxlength="100" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>"></td>
                                                <cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) and rsEmpresas.ETLCespecial eq 0>
													<td>
                                                    <select name="TLCPSincronizadoFiltro" id="TLCPSincronizadoFiltro" stabindex="1" >
                                                        <option value="" ><cf_translate key="LB_Todos">Todos</cf_translate></option>
														<option value="1" <cfif isdefined("form.TLCPSincronizadoFiltro") and form.TLCPSincronizadoFiltro EQ 1> selected</cfif>><cf_translate key="LB_Si">Si</cf_translate></option>
                                                        <option value="0" <cfif isdefined("form.TLCPSincronizadoFiltro") and form.TLCPSincronizadoFiltro EQ 2> selected</cfif>><cf_translate key="LB_No">No</cf_translate></option>
                                                    </select>
                                                    </td>
												</cfif>
											</tr>
             				 			</table>
          						  	</form>
							  	</td>
						  	</tr>	
							<cfif isdefined("Form.CedulaFiltro")>
                                <cfset Form.nombreFiltro    = UCASE(Form.nombreFiltro)>
                            </cfif>
                            <cfif isdefined("Form.apellido1Filtro")>
                              <cfset Form.apellido1Filtro = UCASE(Form.apellido1Filtro)>
                            </cfif>
                            <cfif isdefined("Form.apellido2Filtro")>
                               <cfset Form.apellido2Filtro = UCASE(Form.apellido2Filtro)>
                            </cfif>                            	
        				  	<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) and rsEmpresas.ETLCespecial eq 1>
								<tr style="display: ;" id="verLista"> 
									<td> 
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td>
                                                    <cfquery name="rsLista" datasource="#session.DSN#">
														<cf_dbrowcount1 rows="10000" datasource="#session.DSN#">
                                                    	select 	TLCPcedula,
																TLCPapellido1,
                                                                TLCPapellido2,
                                                                TLCPnombre,
																#form.ETLCid# as ETLCid
														from TLCPadronE 
														where  1=1
														<cfif isdefined("Form.CedulaFiltro") and Len(Trim(Form.CedulaFiltro)) NEQ 0>
															and (TLCPcedula) like '#PreserveSingleQuotes(Form.CedulaFiltro)#%'
														</cfif>
														<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
                                                            and (TLCPnombre) like '#PreserveSingleQuotes(Form.nombreFiltro)#%'
														</cfif>
                                                        <cfif isdefined("Form.apellido1Filtro") and Len(Trim(Form.apellido1Filtro)) NEQ 0>
															and (TLCPapellido1) like '#PreserveSingleQuotes(Form.apellido1Filtro)#%'
														</cfif>
                                                        <cfif isdefined("Form.apellido2Filtro") and Len(Trim(Form.apellido2Filtro)) NEQ 0>
															and (TLCPapellido2) like '#PreserveSingleQuotes(Form.apellido2Filtro)#%'
														</cfif>
                                                       
                                                        <cf_dbrowcount2 rows="1000" datasource="#session.DSN#">
                                                         
													</cfquery>
													<cfinvoke 
														component="sif.rh.Componentes.pListas"
														method=	"pListaQuery"
														returnvariable="pListaEmpl">
														<cfinvokeargument name="query" value="#rsLista#"/>
	
														<cfinvokeargument name="desplegar" value="TLCPcedula,TLCPapellido1,TLCPapellido2,TLCPnombre"/>
														<cfinvokeargument name="etiquetas" value="#LB_Cedula#,#Apellido1#,#Apellido2#,#vNombre#"/>
														<cfinvokeargument name="formatos" value=""/>
														<cfinvokeargument name="formName" value="listaPersonas"/>	
														<cfinvokeargument name="align" value="left,left,left,left"/>
														<cfinvokeargument name="ajustar" value="N"/>
														<cfinvokeargument name="irA" value="Personas.cfm"/>
														<cfinvokeargument name="showEmptyListMsg" value="true"/>
														<cfinvokeargument name="EmptyListMsg" value="#msg_DebeSeleccionarUna_empresa#"/>
														<cfinvokeargument name="navegacion" value="#navegacion#"/>
														<cfinvokeargument name="keys" value="TLCPcedula,ETLCid"/>
                                                        <cfinvokeargument name="MaxRowsQuery" value="50"/>
                                                        <cfinvokeargument name="MaxRows" value="25"/>
                                                        
													</cfinvoke>
												</td>
											</tr>
                                            <tr>
												<td align="center">
													<form name="formNuevoEmplLista" method="post" action="Personas.cfm">
														<input type="hidden" name="o" value="1">
														<input type="hidden" name="sel" value="1">
                                                        <input name="btnPadron" class="btnNuevo" type="button" value="Importar Padron" onclick="javascript: ImportarPadron();">
													</form>
												</td>
											</tr>
										</table>
									</td>
								</tr>				
							<cfelse>
								<tr style="display: ;" id="verLista"> 
									<td> 
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td>
													<cfquery name="rsLista" datasource="#session.DSN#">
														select 	ETLCid,
                                                        		TLCPcedula,
																TLCPapellido1,
                                                                TLCPapellido2,
                                                                TLCPnombre,
                                                                case TLCPSincronizado when 1 then '<cf_translate key="LB_Si">Si</cf_translate>'
                                                                else '<cf_translate key="LB_No">No</cf_translate>' end  as TLCPSincronizado
														from TLCPersonas 
														<cfif not isdefined("form.ETLCid")>
															where  1=2
														<cfelse>
															where  ETLCid = #form.ETLCid#
														</cfif>
														
														<cfif isdefined("Form.CedulaFiltro") and Len(Trim(Form.CedulaFiltro)) NEQ 0>
															and (TLCPcedula) like '#PreserveSingleQuotes(Form.CedulaFiltro)#%'
														</cfif>
														<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
                                                            and (TLCPnombre) like '#PreserveSingleQuotes(Form.nombreFiltro)#%'
														</cfif>
                                                        <cfif isdefined("Form.apellido1Filtro") and Len(Trim(Form.apellido1Filtro)) NEQ 0>
															and (TLCPapellido1) like '#PreserveSingleQuotes(Form.apellido1Filtro)#%'
														</cfif>
                                                        <cfif isdefined("Form.apellido2Filtro") and Len(Trim(Form.apellido2Filtro)) NEQ 0>
															and (TLCPapellido2) like '#PreserveSingleQuotes(Form.apellido2Filtro)#%'
														</cfif>
                                                        <cfif isdefined("Form.TLCPSincronizadoFiltro") and Len(Trim(Form.TLCPSincronizadoFiltro)) NEQ 0>
															and TLCPSincronizado = #Form.TLCPSincronizadoFiltro#
														</cfif>
													</cfquery>
	
                                                    <cfinvoke 
														component="sif.rh.Componentes.pListas"
														method=	"pListaQuery"
														returnvariable="pListaEmpl">
														<cfinvokeargument name="query" value="#rsLista#"/>
	
														<cfinvokeargument name="desplegar" value="TLCPcedula,TLCPapellido1,TLCPapellido2,TLCPnombre,TLCPSincronizado"/>
														<cfinvokeargument name="etiquetas" value="#LB_Cedula#,#Apellido1#,#Apellido2#,#vNombre#,#vSincronizado#"/>
														<cfinvokeargument name="formatos" value=""/>
														<cfinvokeargument name="formName" value="listaPersonas"/>	
														<cfinvokeargument name="align" value="left,left,left,left,center"/>
														<cfinvokeargument name="ajustar" value="N"/>
														<cfinvokeargument name="irA" value="Personas.cfm"/>
														<cfinvokeargument name="showEmptyListMsg" value="true"/>
														<cfinvokeargument name="EmptyListMsg" value="#msg_DebeSeleccionarUna_empresa#"/>
														<cfinvokeargument name="navegacion" value="#navegacion#"/>
														<cfinvokeargument name="keys" value="TLCPcedula,ETLCid"/>
                                                        <cfinvokeargument name="MaxRowsQuery" value="50"/>
                                                        <cfinvokeargument name="MaxRows" value="25"/>
                                                        
													</cfinvoke>
                                                    
												</td>
											</tr>
											<tr>
												<td align="center">
													<form name="formNuevoEmplLista" method="post" action="Personas.cfm">
														<input type="hidden" name="o" value="1">
														<input type="hidden" name="sel" value="1">
														<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid))>
                                                            <cfquery name="rs2" datasource="#Session.DSN#">
                                                                select
                                                                    ETLCid	
                                                                from EmpFormatoTLC 
                                                                where 
                                                                    ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#" >	
                                                            </cfquery>
                                                        
                                                           <cfif rs2.recordCount GT 0>
                                                                <input name="btnNuevoLista" class="btnNuevo" type="submit" value="<cfoutput>#LB_Nueva_Persona#</cfoutput>">
                                                                <input name="btnImportar" class="btnNuevo" type="button" value="<cfoutput>#LB_Importar_Personas#</cfoutput>" onclick="javascript: ImportarPersonas();">

                                                           <cfelse>
                                                            	<font  style="font-size:13px" color="#0000FF"><cf_translate key="LB_Ayuda1">Para agregar o importar personas a esta empresa es necesario configurarlo en el mantenimiento de la empresa </cf_translate></font>
                                                                <br>
                                                                <font  style="font-size:13px" color="#0000FF"><cf_translate key="LB_Ayuda1">en el apartado llamado : Formato para carga e importaci&oacute;n de personas</cf_translate></font>

                                                           </cfif> 
                                                            <input type="hidden" name="ETLCid" value="<cfoutput>#form.ETLCid#</cfoutput>">
                                                        </cfif>
													</form>
												</td>
											</tr>
										</table>
									</td>
								</tr>				
							</cfif>


							
     			 		</table>
						<script language="JavaScript" type="text/javascript">
							var Bandera = "L";
							function buscar(){
							}				
							function limpiaFiltrado(){
								document.formFiltroListaPersona.filtrado.value = "";
								document.formFiltroListaPersona.sel.value = 0;
							}
							function cargaempresa(){
								document.formFiltroListaPersona.submit();
							}
							
							function ImportarPadron(){
								document.formFiltroListaPersona.action = '/cfmx/hosting/tratado/operacion/importador/Padron.cfm';
								document.formFiltroListaPersona.submit();
							}
							
							function ImportarPersonas(){
								document.formFiltroListaPersona.action = '/cfmx/hosting/tratado/operacion/importador/Personas.cfm';
								document.formFiltroListaPersona.submit();
							}
							
						</script>		
			<cf_web_portlet_end>
		</td>	
	</tr>
</table>	
</cf_templatearea>
</cf_template>