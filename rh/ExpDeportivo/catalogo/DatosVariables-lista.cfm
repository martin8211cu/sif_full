
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Conceptos"
	Default="Conceptos"
	returnvariable="LB_Conceptos"/>
		<cf_templateheader title="#LB_Conceptos#">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">

					<!--- ========================================================== --->
					<!--- 						TRADUCCION							 --->
					<!--- ========================================================== --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Codigo"
						xmlfile="/rh/generales.xml"	
						Default="C&oacute;digo"
						returnvariable="LB_Codigo"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Descripcion"
						xmlfile="/rh/generales.xml"	
						Default="Descripci&oacute;n"
						returnvariable="LB_Descripcion"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="BTN_Filtrar"
						xmlfile="/rh/generales.xml"	
						Default="Filtrar"
						returnvariable="BTN_Filtrar"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="BTN_Nuevo"
						Default="Nuevo"
						xmlfile="/rh/expediente/catalogos/expediente-cons.xml"
						returnvariable="BTN_Nuevo"/>
					<!--- ========================================================== --->
					<!--- ========================================================== --->

					<cf_web_portlet_start border="true" titulo="<cfoutput>#LB_Conceptos#</cfoutput>" skin="#Session.Preferences.Skin#">
					<script language="JavaScript1.2" type="text/javascript">
								function limpiar(){
									document.filtro.fEDDcodigo.value = "";
									document.filtro.fEDDdescripcion.value   = "";
									
								}
							</script>
							<cfset filtro = " 1=1 ">
							<cfif isdefined("form.fEDDcodigo") and len(trim(form.fEDDcodigo)) gt 0 >
								<cfset filtro = filtro & " and upper(EDDcodigo) like '%#ucase(form.fEDDcodigo)#%' " >
							</cfif>
							<cfif isdefined("form.fEDDdescripcion") and len(trim(form.fEDDdescripcion)) gt 0 >
								<cfset filtro = filtro & " and upper(EDDdescripcion) like '%#ucase(form.fEDDdescripcion)#%' " >
							</cfif>
							
							<cfset filtro = filtro & "order by EDDcodigo">
					<!--- 	<cfif isdefined("Url.EDDcodigo") and not isdefined("Form.EDDcodigo")>
							<cfparam name="Form.EDDcodigo" default="#Url.EDDcodigo#">
						</cfif>
						<cfif isdefined("Url.EDDdescripcion") and not isdefined("Form.EDDdescripcion")>
							<cfparam name="Form.EDDdescripcion" default="#Url.EDDdescripcion#">
						</cfif>		
						<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
							<cfparam name="Form.filtrado" default="#Url.filtrado#">
						</cfif>	
						<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
							<cfparam name="Form.DEid" default="#Url.DEid#">
						</cfif>
						<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
							<cfparam name="Form.sel" default="#Url.sel#">
						</cfif>		
						<cfset filtro = "">
						<cfset navegacion = "">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
						<cfif isdefined("Form.DEid")>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & #form.DEid#>				
						</cfif>
						<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
							<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }) like '%" & #UCase(Form.nombreFiltro)# & "%'">

							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
						</cfif>
						<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
							<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & UCase(Form.DEidentificacionFiltro) & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEidentificacionFiltro=" & Form.DEidentificacionFiltro>
						</cfif>
						<cfif isdefined("Form.sel") and form.sel NEQ 1>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
						</cfif>		 --->
	   					<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<cfif isdefined("form.o") and form.o eq 4 and isdefined("form.DLLinea")>
								<cfset regresar = "javascript:history.back();">
							<cfelse>
								<cfset regresar = "/cfmx/rh/index.cfm">
							</cfif>		
							<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>	  
							<tr style="display: ;" id="verFiltroListaEmpl"> 
								<td> 
							  		<form name="formFiltroListaEmpl" method="post" action="DatosVariables-lista.cfm">
										<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
										<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
										<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
											<tr> 
												<td width="27%" height="17" class="fileLabel"><cfoutput>#LB_Codigo#</cfoutput></td>
												<td width="68%" class="fileLabel"><cfoutput>#LB_Descripcion#</cfoutput></td>
												<td width="5%" colspan="2" rowspan="2"><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>"></td>
											</tr>
											<tr> 
												<td><input name="EDDcodigo" type="text" id="EDDcodigo" size="30" maxlength="60" value="<cfif isdefined('form.EDDcodigo')><cfoutput>#form.EDDcodigo#</cfoutput></cfif>"></td>
												<td><input name="EDDdescripcion" type="text" id="EDDdescripcion" size="100" maxlength="260" value="<cfif isdefined('form.EDDdescripcion')><cfoutput>#form.EDDdescripcion#</cfoutput></cfif>"></td>
											</tr>
             				 			</table>
          						  	</form>
							  	</td>
						  	</tr>		
        				  	<tr style="display: ;" id="verLista"> 
          				  		<td> 
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
								  		<tr>
											<td>
												<cfinvoke 
										 		component="rh.Componentes.pListas"
												 method="pListaRH"
												 returnvariable="pListaRet">
													<cfinvokeargument name="tabla" value="EDDatosVariables"/>
													<cfinvokeargument name="columnas" value="EDDid,EDDcodigo, EDDdescripcion"/>
													<cfinvokeargument name="desplegar" value="EDDcodigo, EDDdescripcion"/>
													<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
													<cfinvokeargument name="formatos" value="V,V"/>
													<cfinvokeargument name="filtro" value="#filtro#"/>
													<cfinvokeargument name="align" value="left,left"/>
													<cfinvokeargument name="ajustar" value="N"/>
													<cfinvokeargument name="checkboxes" value="N"/>
													<cfinvokeargument name="irA" value="DatosVariables.cfm"/>
													<cfinvokeargument name="keys" value="EDDid"/>
												</cfinvoke>
											</td>
								  		</tr>
			  					  		<tr>
								  			<td align="center">
												<form name="formNuevoEmplLista" method="post" action="DatosVariables.cfm">
													<input type="hidden" name="o" value="1">
													<input type="hidden" name="sel" value="1">
													<input name="btnNuevoLista" class="btnNuevo" type="submit" value="<cfoutput>#BTN_Nuevo#</cfoutput>">
												</form>
											</td>
			 							</tr>
									</table>
		 				 		</td>
        					</tr>

							</table>
						<script language="JavaScript" type="text/javascript">
							var Bandera = "L";
							function buscar(){
								/*
								var connVerLista			= document.getElementById("verLista");
								var connVerPagina			= document.getElementById("verPagina");				
								var connVerFiltroListaEmpl	= document.getElementById("verFiltroListaEmpl");								
								var connVerEtiqueta1		= document.getElementById("letiqueta1");												
								var connVerEtiqueta2		= document.getElementById("letiqueta2");																
								if(document.formFiltroListaEmpl.filtrado.value != "")
									Bandera = "L";
								if(document.formFiltroListaEmpl.sel.value == "1")
									Bandera = "P";					
								if(Bandera == "L"){	// Ver Lista
									Bandera = "P";
									connVerLista.style.display = "";
									connVerFiltroListaEmpl.style.display = "";					
									connVerPagina.style.display = "none";
									document.formBuscar.imageBusca.src="/cfmx/rh/imagenes/iindex.gif";
									connVerEtiqueta1.style.display = "none";
									connVerEtiqueta2.style.display = "";					
									document.formBuscar.imageBusca.alt="Mantenimientos";
								}
								else{	//Pagina
									Bandera = "L";				
									connVerLista.style.display = "none";
									connVerFiltroListaEmpl.style.display = "none";					
									connVerPagina.style.display = "";
									document.formBuscar.imageBusca.src="/cfmx/rh/imagenes/iindex.gif";					
									connVerEtiqueta1.style.display = "";
									connVerEtiqueta2.style.display = "none";										
									document.formBuscar.imageBusca.alt="Lista de empleados";
								}
								*/
							}				
							function limpiaFiltrado(){
								document.formFiltroListaEmpl.filtrado.value = "";
								document.formFiltroListaEmpl.sel.value = 0;
							}
				</script>		
			<cf_web_portlet_end>
		</td>	
	</tr>
</table>	
	<cf_templatefooter>
