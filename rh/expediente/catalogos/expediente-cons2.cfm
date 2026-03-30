<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Mantenimiento de Empleados
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>


		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
				
		<!--- navegacion --->
<!---
		<cfif isdefined("form.PageNum_lista")>
			<cfset form.pagina = form.PageNum_lista >
		<cfelseif isdefined("url.PageNum_lista")>
			<cfset form.pagina = url.PageNum_lista >
		<cfelseif isdefined("form.PageNum")>
			<cfset form.pagina = form.PageNum >
		<cfelseif isdefined("url.PageNum")>
			<cfset form.pagina = url.PageNum >
		<cfelseif isdefined("url.pagina")>
			<cfset form.pagina = url.pagina >
		<cfelseif not isdefined("form.pagina")>
			<cfset form.pagina = 1 >
		</cfif>
<cfdump var="La paginacion es: #form.pagina#">
--->
		<!--- fin nav --->

	  <cf_web_portlet_start border="true" titulo="Mantenimiento de Empleados" skin="#Session.Preferences.Skin#">
		<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
			<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
		</cfif>
		<cfif isdefined("Url.DEidentificacionFiltro") and not isdefined("Form.DEidentificacionFiltro")>
			<cfparam name="Form.DEidentificacionFiltro" default="#Url.DEidentificacionFiltro#">
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
			<cfset filtro = filtro & " and upper(DEapellido1 || ' ' || DEapellido2 || ', ' || DEnombre) like '%" & #UCase(Form.nombreFiltro)# & "%'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
		</cfif>
		<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
			<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & UCase(Form.DEidentificacionFiltro) & "%'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEidentificacionFiltro=" & Form.DEidentificacionFiltro>
		</cfif>
		<cfif isdefined("Form.sel") and form.sel NEQ 1>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
		</cfif>		
	
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif isdefined("form.o") and form.o eq 4 and isdefined("form.DLLinea")>
			<cfset regresar = "javascript:history.back();">
		<cfelse>
			<cfset regresar = "/cfmx/rh/index.cfm">
		</cfif>		
		<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>	  
		<form name="formBuscar" method="post" action="">			  	  
			<tr> 
            <td valign="middle" align="right">  
              <label id="letiqueta1"><a href="javascript: limpiaFiltrado(); buscar();">Seleccione un empleado:  </a></label>
			  <label id="letiqueta2"><a href="javascript: limpiaFiltrado(); buscar();">Datos del empleado: </a> </label>			  
			  <a href="javascript: limpiaFiltrado(); buscar();">
	              <img src="/cfmx/rh/imagenes/iindex.gif" name="imageBusca" border="0" id="imageBusca"> 
              </a> </td>
			</tr>
		</form>	  							
		<tr style="display: ;" id="verFiltroListaEmpl"> 
		  <td> 
		  	<form name="formFiltroListaEmpl" method="post" action="expediente-cons.cfm">
		  		<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
		  		<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
				
              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
                <tr> 
                  <td width="27%" height="17" class="fileLabel"><cf_translate key="CedulaEmp">Identificaci&oacute;n</cf_translate></td>
                  <td width="68%" class="fileLabel"><cf_translate key="NomEmpEmp">Nombre del empleado</cf_translate></td>
                  <td width="5%" colspan="2" rowspan="2"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
                </tr>
                <tr> 
                  <td><input name="DEidentificacionFiltro" type="text" id="DEidentificacionFiltro" size="30" maxlength="60" value="<cfif isdefined('form.DEidentificacionFiltro')><cfoutput>#form.DEidentificacionFiltro#</cfoutput></cfif>">
                  </td>
                  <td><input name="nombreFiltro" type="text" id="nombreFiltro2" size="100" maxlength="260" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>"></td>
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
					select DEid, DEidentificacion, (DEapellido1 || ' ' || DEapellido2 || ', ' || DEnombre) as nombreEmpl, 1 as o, 1 as sel ,'ALTA' as modo
					from DatosEmpleado
					where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					<cfif isdefined("filtro") and len(trim(filtro))>
						#PreserveSingleQuotes(filtro)#
					</cfif>
					order by DEidentificacion, DEapellido1, DEapellido2, DEnombre
				</cfquery>
						
					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaEmpl">
					 <cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl"/>
						<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n,Empleado"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="formName" value="listaEmpleados"/>	
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="expediente-cons.cfm"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="keys" value="DEid"/>
					</cfinvoke>
				</td>
			  </tr>
			  <tr>
				<td align="center">
					<form name="formNuevoEmplLista" method="post" action="expediente-cons.cfm">
						<input type="hidden" name="o" value="1">
						<input type="hidden" name="sel" value="1">
						
						<input name="btnNuevoLista" type="submit" value="Nuevo Empleado">				
					</form>
				</td>
			  </tr>
			</table>
		  </td>
        </tr>
        <tr style="display: ;" id="verPagina"> 
          <td> 
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td><cfinclude template="header.cfm"></td>
					</tr>
					
					<tr>
						<td class="tabContent">

							<cfif tabChoice eq 1 and tabAccess[tabChoice]>	<!--- Datos del empleado --->
								<cfinclude template="datosEmpleado.cfm">
							<cfelseif tabChoice eq 2 and tabAccess[tabChoice] and  isdefined('form.DEid') and Len(form.DEid) neq 0>	<!--- Familiares --->
								<cfinclude template="familiares.cfm">
							<cfelseif tabChoice eq 3 and tabAccess[tabChoice] and  isdefined('form.DEid') and Len(form.DEid) neq 0>	<!--- Anotaciones --->
								<cfinclude template="anotaciones.cfm">
							<cfelseif tabChoice eq 4 and tabAccess[tabChoice] and  isdefined('form.DEid') and Len(form.DEid) neq 0>	<!--- Datos Laborales --->
								<cfinclude template="datosLaborales.cfm">
							<cfelseif tabChoice eq 5 and tabAccess[tabChoice] and  isdefined('form.DEid') and Len(form.DEid) neq 0>	<!--- Acciones de Personal --->
								<cfinclude template="acciones.cfm">
							<cfelseif tabChoice eq 6 and tabAccess[tabChoice] and  isdefined('form.DEid') and Len(form.DEid) neq 0>	<!--- Cargas --->
								<cfinclude template="cargas.cfm">
							<cfelseif tabChoice eq 7 and tabAccess[tabChoice] and  isdefined('form.DEid') and Len(form.DEid) neq 0>	<!--- Deducciones --->
								<cfinclude template="deducciones.cfm">
							<cfelseif tabChoice eq 8 and tabAccess[tabChoice] and  isdefined('form.DEid') and Len(form.DEid) neq 0>	<!--- Vacaciones --->
								<cfquery datasource="#Session.DSN#" name="rsEncabRevisa">
									select eve.DEid
									from EVacacionesEmpleado eve,
										DatosEmpleado de
									where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
										and eve.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
										and eve.DEid=de.DEid
								</cfquery>
								<cfif rsEncabRevisa.recordCount GT 0>
									<cfinclude template="vacaciones.cfm">
								<cfelse>
									  <div align="center"> <br><br><b>Este empleado no posee ENCABEZADO de vacaciones</b><br><br></div>
								</cfif>
							<cfelse>														
								  <div align="center"> <b>Este m&oacute;dulo no est&aacute; disponible</b></div>
							</cfif>

						</td>
					</tr>
				</table>
		  </td>
        </tr>
      </table>
      <script language="JavaScript" type="text/javascript">
			var Bandera = "L";
			
			function buscar(){
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
				}else{	//Pagina
					Bandera = "L";				
					connVerLista.style.display = "none";
					connVerFiltroListaEmpl.style.display = "none";					
					connVerPagina.style.display = "";
					document.formBuscar.imageBusca.src="/cfmx/rh/imagenes/iindex.gif";					
					connVerEtiqueta1.style.display = "";
					connVerEtiqueta2.style.display = "none";										
					document.formBuscar.imageBusca.alt="Lista de empleados";
				}
			}				
			
			function limpiaFiltrado(){
				document.formFiltroListaEmpl.filtrado.value = "";
				document.formFiltroListaEmpl.sel.value = 0;
			}
			
			buscar();
		</script>
		<cf_web_portlet_end>
				
				
				
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>