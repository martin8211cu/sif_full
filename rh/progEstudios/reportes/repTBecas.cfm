<cfparam name="modo" default="ALTA">
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>  
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" XmlFile="/rh/generales.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado" Default="Empleado" XmlFile="/rh/generales.xml" returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado" Default="Estado" XmlFile="/rh/generales.xml" returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Beca" Default="Beca" XmlFile="/rh/generales.xml" returnvariable="LB_Beca"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="dentificaci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Identificacion"/>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
    <cf_web_portlet_start border="true" titulo="Reporte por Tipo de Becas" skin="#Session.Preferences.Skin#">
    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
        	<form name="form1" action="repTBecas-reporte.cfm" method="post">
                <tr>
                  <td><strong>Funcionario:&nbsp;</strong></td>
                  <td>	<cf_rhempleado size="80" tabindex="1"></td>
                </tr>
                <tr>
					<td width="1%" nowrap><strong>Tipo de Beca:&nbsp;</strong></td>
                  <td colspan="2">
                  	 <cf_conlis
                        campos="RHTBid,RHTBcodigo,RHTBdescripcion"
                        desplegables="N,S,S"
                        modificables="N,S,N"
                        size="0,10,50"
                        title="Lista de Tipo de Beca"
                        tabla="RHTipoBeca"
                        columnas="RHTBid, RHTBcodigo, RHTBdescripcion"
                        filtro="RHTBesCorporativo = 1 or (RHTBesCorporativo = 0 and  Ecodigo = #session.Ecodigo#)"
                        desplegar="RHTBcodigo, RHTBdescripcion"
                        filtrar_por="RHTBcodigo|RHTBdescripcion"
                        filtrar_por_delimiters="|"
                        etiquetas="Codigo,Descripción"
                        formatos="S,S"
                        align="left,left"
                        asignar="RHTBid,RHTBcodigo,RHTBdescripcion"
                        asignarformatos="I,S,S"
                        showEmptyListMsg="true"
                        form = "form1"
                        tabindex = "1"
                    >
                  </td>
                 <!--- <td><strong>Fiador:&nbsp;</strong></td>
                  <td>
                  	 <cf_conlis
                        campos="RHFid,DEid,Indentificacion,Fiador"
                        desplegables="N,N,S,S"
                        modificables="N,N,S,N"
                        size="0,0,10,50"
                        title="Lista de Fiadores"
                        tabla="RHFiadoresBecasEmpleado fb left outer join DatosEmpleado de on de.DEid = fb.DEid left outer join RHFiadores f on f.RHFid = fb.RHFid"
                        columnas="f.RHFid, de.DEid, coalesce(de.DEidentificacion,f.RHFcedula) as Indentificacion, coalesce(de.DEnombre,f.RHFnombre) #_CAT# ' ' #_CAT# coalesce(de.DEapellido1,f.RHFapellido1) #_CAT# ' ' #_CAT# coalesce(de.DEapellido2,f.RHFapellido2) as Fiador"
                        filtro=""
                        desplegar="Indentificacion, Fiador"
                        filtrar_por="coalesce(de.DEidentificacion,f.RHFcedula) | coalesce(de.DEnombre,f.RHFnombre) #_CAT# ' ' #_CAT# coalesce(de.DEapellido1,f.RHFapellido1) #_CAT# ' ' #_CAT# coalesce(de.DEapellido2,f.RHFapellido2)"
                        filtrar_por_delimiters="|"
                        etiquetas="Indentificación,Fiador"
                        formatos="S,S"
                        align="left,left"
                        asignar="RHFid,DEid,Indentificacion,Fiador"
                        asignarformatos="I,I,S,S"
                        showEmptyListMsg="true"
                        form = "form1"
                    >
                  </td>--->
                </tr>
				<tr>
					<td colspan="3">
						<table>
							<tr>
								  <td><strong>Fecha Inicial:&nbsp;</strong></td>
								  <td><cf_sifcalendario name="fini" value=""></td>
								   <td><strong>Fecha Final:&nbsp;</strong></td>
								  <td><cf_sifcalendario name="ffin" value=""></td>
							</tr>
						</table>
					</td>
                </tr>
				<tr><td>&nbsp;</td></tr>
                <tr>
                  <td  align="center" colspan="2"><cf_botones values="Procesar"></td>
                </tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
				<td colspan="3">
					<table border="0" width="100%">
						<tr>
							<td width="15%">&nbsp;</td>
							<td width="60%" align="center">
								<cf_web_portlet_start border="true" titulo="Información" skin="#Session.Preferences.Skin#">
									La información que se despliega al realizar la consulta desde este reporte es configurable desde el sub-modulo de Tipos de Becas
								<cf_web_portlet_end>
							</td>
							<td width="15%">&nbsp;</td>
						</tr>
				</td>
				</tr>
            </form>
			</table>
            <script language="javascript1.2" type="text/javascript">
				
					
				function trim(cad){  
					return cad.replace(/^\s+|\s+$/g,"");  
				}
					
				function funcProcesar(){
					Lfecha = trim(document.form1.RHEBEfecha.value).length;
					errores = "";
					if(Lfecha == 0)
						errores = errores + " -La fecha es requerido.\n";
					if(errores.length > 0){
						alert("Se presentaron los siguientes errores:\n" + errores);
						return false;
					}
					return true;
				}

			</script>
    <cf_web_portlet_end>
<cf_templatefooter>