<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Filtrar"
xmlfile="/rh/generales.xml"	
Default="Filtrar"
returnvariable="vFiltrar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="BTN_Nuevo"
xmlfile="/rh/generales.xml"	
Default="Nuevo"
returnvariable="BTN_Nuevo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Administracion_de_Personas"
Default="Administraci&oacute;n de Personas"
returnvariable="LB_Administracion_de_Personas"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Seleccione_la_persona_con_la_cual_desea_trabajar"
Default="Seleccione la persona con la cual desea trabajar"
returnvariable="LB_Seleccione_la_persona_con_la_cual_desea_trabajar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Filtrar"
xmlfile="/rh/generales.xml"	
Default="Filtrar"
returnvariable="LB_Filtrar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Nombre"
xmlfile="/rh/generales.xml"	
Default="Nombre"
returnvariable="LB_Nombre"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Empleado"
xmlfile="/rh/generales.xml"	
Default="Empleado"
returnvariable="LB_Empleado"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_Identificacion"
xmlfile="/rh/generales.xml"	
Default="Identificaci&oacute;n"
returnvariable="LB_Identificacion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Persona"
Default="Persona"
returnvariable="Persona"/>
<cfif not isdefined("url.popup")> 
<cf_templateheader title="#LB_Administracion_de_Personas#">
<cf_web_portlet_start titulo="#LB_Administracion_de_Personas#">
</cfif>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  
	  
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>
	  <tr>
		
		<td style="padding-left: 5px; padding-right: 5px;" valign="top">

					<script language="JavaScript1.2" type="text/javascript">
								function limpiar(){
									document.filtro.DEidentificacion.value = "";
									document.filtro.DEnombre.value   = "";
									
								}
							</script>

												
					<cfset filtro = " ">
		<cfif isdefined("form.fDEidentificacion") and len(trim(form.fDEidentificacion)) gt 0 >
		<cfset filtro = filtro & " and upper(DEidentificacion) like '%#ucase(form.fDEidentificacion)#%' " >
		</cfif>
		<cfif isdefined("form.fDEnombre") and len(trim(form.fDEnombre)) gt 0 >
		<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, 		 DEnombre) }) like '%" & #UCase(Form.fDEnombre)# & "%'">
		</cfif> 
							
							
	

	<form name="formFiltroListaEmpl" method="post" action="persona-lista.cfm" onSubmit="return validar(this);">
	<input type="hidden" name="o" value="1">

	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
			<tr> 
			<td width="27%" height="17" class="fileLabel"><cfoutput>#LB_Identificacion#</cfoutput></td>
			<td width="68%" class="fileLabel"><cfoutput>#LB_Nombre#</cfoutput></td>
			<td width="5%" colspan="2" rowspan="2"><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#vFiltrar#</cfoutput>"></td>
		  </tr><tr> 
												<td><input name="fDEidentificacion" type="text" id="fDEidentificacion" size="30" maxlength="60" value="<cfif isdefined('form.fDEidentificacion')><cfoutput>#form.fDEidentificacion#</cfoutput></cfif>"></td>
												<td><input name="fDEnombre" type="text" id="fDEnombre" size="60" maxlength="260" value="<cfif isdefined('form.fDEnombre')><cfoutput>#form.fDEnombre#</cfoutput></cfif>"></td>
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
			
			<cfquery name="rsLista" datasource="#session.DSN#">
									select DEidentificacion, {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ', ')}, DEnombre) } as nombreEmpl, DEid
									from EDPersonas
									where 1=1
									#PreserveSingleQuotes(filtro)#
									order by {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }
	  </cfquery>
	 	
	  <cfif not isdefined("url.popup")>
 
												<cfinvoke 
										 			component="rh.Componentes.pListas"
										 			method=	"pListaQuery"
										 			returnvariable="pListaEmpl">
										 			<cfinvokeargument name="query" value="#rsLista#"/>
													<cfinvokeargument name="columnas" value="DEidentificacion, nombreEmpl"/>
													<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl"/>
													<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Nombre#"/>
													<cfinvokeargument name="formatos" value="V,V"/>
													<cfinvokeargument name="align" value="left,left"/>
													<cfinvokeargument name="ajustar" value="N"/>
													<cfinvokeargument name="irA" value="../usuarios/persona.cfm"/>								
													<cfinvokeargument name="keys" value="DEid"/>
												</cfinvoke>

 <cfelseif isdefined("url.popup")>
 	<cfif url.popup EQ 'a'>
		<cfset popup = "../usuarios/persona-sql.cfm?popup=a">
	<cfelseif url.popup EQ 'b'>
		<cfset popup = "../usuarios/persona-sql.cfm?popup=b">
	<cfelseif url.popup EQ 'c'>
		<cfset popup = "../usuarios/persona-sql.cfm?popup=c">
	<cfelseif url.popup EQ 'd'>
		<cfset popup = "../usuarios/persona-sql.cfm?popup=d">
	<cfelse>
		<cfset popup = "../usuarios/persona-sql.cfm?popup=s">
</cfif>
 
												<cfinvoke 
										 			component="rh.Componentes.pListas"
										 			method=	"pListaQuery"
										 			returnvariable="pListaEmpl">
										 			<cfinvokeargument name="query" value="#rsLista#"/>
													<cfinvokeargument name="columnas" value="DEidentificacion, nombreEmp"/>
													<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl"/>
													<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Nombre#"/>
													<cfinvokeargument name="formatos" value="V,V"/>
													<cfinvokeargument name="align" value="left,left"/>
													<cfinvokeargument name="ajustar" value="N"/>
													<cfinvokeargument name="irA" value="#popup#"/>								
													<cfinvokeargument name="keys" value="DEid"/>
												</cfinvoke>
												
	</cfif>
												</td>
												</tr>
												<tr>
												<td align="center">
	 <form name="formNuevoEmplLista" method="post" action="../usuarios/persona.cfm">
													<input type="hidden" name="o" value="1">
													<input type="hidden" name="sel" value="1">
													<input name="btnNuevoLista" class="btnNuevo" type="submit" value="<cfoutput>#BTN_Nuevo#</cfoutput>">
												</form>
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
								document.DEidentificacion.value = "";
								document.DEnombre.value = "";
							}
				</script>		

	</td>
  </tr>
</table>
</table>
<cfif not isdefined("url.popup")> 
	<cf_web_portlet_end>
<cf_templatefooter>
</cfif>