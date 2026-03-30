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
        	<form name="form1" action="repBeneficios-reporte.cfm" method="post">
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
                        funcion="fnLimpiar(1)"
                		funcionValorEnBlanco="fnLimpiar(1)"
                    >
                  </td>
                </tr>
                <tr>
                  <td width="1%" nowrap><strong>Actividad:&nbsp;</strong></td>
                  <td colspan="2">
                  	 <cf_conlis
                        campos="RHTBEFid,RHTBEFcodigo,RHTBEFdescripcion"
                        desplegables="N,S,S"
                        modificables="N,S,N"
                        size="0,10,50"
                        title="Lista de Actividades"
                        tabla="RHTipoBecaEFormatos"
                        columnas="RHTBEFid,RHTBEFcodigo,RHTBEFdescripcion"
                        filtro="RHTBid = $RHTBid,numeric$"
                        desplegar="RHTBEFcodigo, RHTBEFdescripcion"
                        filtrar_por="RHTBEFcodigo|RHTBEFdescripcion"
                        filtrar_por_delimiters="|"
                        etiquetas="Codigo,Descripción"
                        formatos="S,S"
                        align="left,left"
                        asignar="RHTBEFid,RHTBEFcodigo,RHTBEFdescripcion"
                        asignarformatos="I,S,S"
                        showEmptyListMsg="true"
                        form = "form1"
                        tabindex = "1"
                        funcion="fnLimpiar(2)"
                		funcionValorEnBlanco="fnLimpiar(2)"
                    >
                  </td>
                </tr>
                <tr>
                  <td width="1%" nowrap><strong>Fecha Inicial:&nbsp;</strong></td>
                  <td width="1%">
                  	 <cf_conlis
                        campos="RHTBDFid,RHTBDFetiqueta"
                        desplegables="N,S"
                        modificables="N,S"
                        size="0,64"
                        title="Lista de Fechas"
                        tabla="RHTipoBecaDFormatos"
                        columnas="RHTBDFid,RHTBDFetiqueta"
                        filtro="RHTBEFid = $RHTBEFid,numeric$ and RHTBDFcapturaA = 4 and RHTBDFcapturaB is null"
                        desplegar="RHTBDFetiqueta"
                        filtrar_por="RHTBDFetiqueta"
                        filtrar_por_delimiters="|"
                        etiquetas="Etiqueta"
                        formatos="S"
                        align="left"
                        asignar="RHTBDFid,RHTBDFetiqueta"
                        asignarformatos="I,S"
                        showEmptyListMsg="true"
                        form = "form1"
                        tabindex = "1"
                        funcion="fnLimpiar(3)"
                		funcionValorEnBlanco="fnLimpiar(3)"
                    >
                  </td>
                  <td width="5%"><cf_sifcalendario name="fecha" value="#Lsdateformat(now(),'dd/mm/yyyy')#" form="form1"></td>
                </tr>
                <tr>
                  <td  align="center" colspan="3">
                  	<cf_botones values="Procesar">
                  </td>
                </tr>
            </form>
			</table>
            <script src="/cfmx/sif/js/qForms/qforms.js"></script>
            <script language="javascript1.2" type="text/javascript">
				
				objForm = new qForm("form1");
				objForm.RHTBid.description="Tipo de Beca";
				objForm.RHTBEFid.description="Actividad";
					
				function trim(cad){  
					return cad.replace(/^\s+|\s+$/g,"");  
				}
					
				function funcProcesar(){
					Ltb = trim(document.form1.RHTBid.value).length;
					La = trim(document.form1.RHTBEFid.value).length;
					Lfi = trim(document.form1.RHTBDFid.value).length;
					Lfiv = trim(document.form1.fecha.value).length;
					errores = "";
					if(Ltb == 0)
						errores = errores + " -El tipo de beca es requerido.\n";
					if(La == 0)
						errores = errores + " -La actividad es requerido.\n";
				/*	if(Lfi == 0)
						errores = errores + " -La fecha inicial es requerido.\n";
					if(Lfiv == 0)
						errores = errores + " -El valor de la fecha inicial es requerido.\n";*/
					if(errores.length > 0){
						alert("Se presentaron los siguientes errores:\n" + errores);
						return false;
					}
					return true;
				}
				
				function fnLimpiar(n){
					if(n <= 3){
						document.form1.fecha.value = '';
					}
					if(n <= 2){
						document.form1.RHTBDFid.value = '';
						document.form1.RHTBDFetiqueta.value = '';
					}
					if(n <= 1){
						document.form1.RHTBEFid.value = '';
						document.form1.RHTBEFcodigo.value = '';
						document.form1.RHTBEFdescripcion.value = '';
					}

				}

			</script>
    <cf_web_portlet_end>
<cf_templatefooter>