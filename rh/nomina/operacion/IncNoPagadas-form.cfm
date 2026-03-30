<cfsilent>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Concepto_Incidente"
		Default="Concepto Incidente"
		XmlFile="/rh/generales.xml"
		returnvariable="vConcepto"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Descripcion"
		Default="Descripci&oacute;n"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_Descripcion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ListaDeIncidencias"
		Default="Lista de Incidencias"
		returnvariable="LB_ListaDeIncidencias"/>
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Filtrar"
		Default="Filtrar"
		XmlFile="/rh/generales.xml"
		returnvariable="vFiltrar"/>	
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Modificar_la_Fecha"
		Default="Modificar la Fecha"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_Modificar_la_Fecha"/>	
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Cancelar"
		Default="Cancelar"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_Cancelar"/>	        
        
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Eliminar"
		Default="Eliminar"
		XmlFile="/rh/generales.xml"
		returnvariable="vEliminar"/>	
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Limpiar"
		Default="Limpiar"
		XmlFile="/rh/generales.xml"
		returnvariable="vLimpiar"/>	 
	<cfinvoke component="sif.Componentes.Translate"
         method="Translate"
         Key="LB_NoSeEncontraronRegistros"
         Default="No se encontraron Registros "
         returnvariable="LB_NoSeEncontraronRegistros"/>   
    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="LB_Fecha"
        Default="Fecha"
        XmlFile="/rh/generales.xml"
        returnvariable="vFecha"/> 
    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="Concepto_Incidente"
        Default="Concepto Incidente"
        XmlFile="/rh/generales.xml"
        returnvariable="vConcepto"/> 
    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="LB_Empleado"
        Default="Empleado"
        XmlFile="/rh/generales.xml"
        returnvariable="vEmpleado"/>  
    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="LB_Cantidad_Monto"
        Default="Cantidad/Monto"
        returnvariable="vCantidadMonto"/>                               
</cfsilent>
<cfset navegacion = "" >

<cfquery name="rsAcciones" datasource="#Session.DSN#">	
    select RHTid,RHTcodigo,RHTdesc
    from  RHTipoAccion
    where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and RHTnopagaincidencias = 1
</cfquery>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <cfoutput>
        <form  name="form1" method="post" action="IncNoPagadas.cfm">
        <td valign="top">
        	<fieldset><legend><cf_translate key="LB_Area_de_Filtros" >Area de Filtros</cf_translate></legend>
            	
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="top">
                            	<strong><cf_translate key="LB_Empleado">Empleado</cf_translate></strong>
                            </td>
                        	<td valign="top">
                                <strong><cf_translate key="LB_Concepto_Incidente">Concepto Incidente</cf_translate></strong>
                            </td>
                         </tr>
                        <tr>
                            <td valign="top">
                                 <cf_rhempleado tabindex="1" size = "30" >
                            </td>
                            <td valign="top">
                                <cf_conlis title="#LB_ListaDeIncidencias#"
                                    campos = "CIid,CIcodigo,CIdescripcion" 
                                    desplegables = "N,S,S" 
                                    modificables = "N,S,N" 
                                    size = "0,10,20"
                                    asignar="CIid,CIcodigo,CIdescripcion"
                                    asignarformatos="I,S,S"
                                    tabla="	CIncidentes a"																	
                                    columnas="CIid,CIcodigo,CIdescripcion,CInegativo"
                                    filtro="a.Ecodigo =#session.Ecodigo#
                                            and coalesce(a.CInomostrar,0) = 0"
                                    desplegar="CIcodigo,CIdescripcion"
                                    etiquetas="	#vConcepto#, 
                                                #LB_Descripcion#"
                                    formatos="S,S"
                                    align="left,left"
                                    showEmptyListMsg="true"
                                    debug="false"
                                    width="800"
                                    height="500"
                                    left="70"
                                    top="20"
                                    tabindex="1"
                                    filtrar_por="CIcodigo,CIdescripcion"
                                    >
                            </td>
                            
                        </tr>
						 <tr>
                            <td valign="top">
                                <strong><cf_translate key="LB_Fecha">Fecha</cf_translate> </strong>
                            </td>
                            <td valign="top">
                                <strong><cf_translate key="LB_TipoAccion">Tipo Acci&oacute;n</cf_translate> </strong>
                            </td>
                         </tr>
						  <tr>
						  <td valign="top">
                                    <cf_sifcalendario  name="Fecha" value="" tabindex="1">
                            </td> 
                            <td valign="top">
                                <select name="RHTid"  tabindex="1">
                                    <option value="">(<cf_translate key="CMB_Todas">Todas</cf_translate>)</option>
                                    <cfif rsAcciones.recordCount GT 0>
                                        <cfloop query="rsAcciones">
                                        <option value="#rsAcciones.RHTid#">#trim(rsAcciones.RHTcodigo)# #trim(rsAcciones.RHTdesc)#</option>
                                        </cfloop>
                                     </cfif>   
                                </select>
                            </td> 
						  
						  </tr>
						
						
						
                        <tr>
                            <td   colspan="2" align="center" valign="top">&nbsp;</td>
                        </tr> 
                        <tr>
                            <td   colspan="2" align="center" valign="top">
                            	<input  type="button"   class="btnFiltrar" name="btnFiltrar"  value="#vFiltrar#" onClick="filtrar();">
                                <input  type="submit"   class="btnLimpiar" name="btnLimpiar"  value="#vLimpiar#">
                            </td>
                        </tr>                        
                    </table>
            </fieldset>
        </td>
        </form>
        </cfoutput>

    </tr>
 	<tr>
        <td valign="top" align="center">
        	<strong><font  style="font-size:15px"><cf_translate key="LB_Incidencias_pendientes_de_pagar" >Incidencias pendientes de pago por acciones</cf_translate></font></strong>
            <iframe 
                id="Pendientes" 
                name="Pendientes" 
                marginheight="0" 
                marginwidth="0" 
                frameborder="2" 
                height="435px" 
                width="980px"  style="border:none"  scrolling="auto" 
                src="ListIncNoPagadas.cfm">                   
             </iframe>
        </td>
    </tr>        
</table>
<script type="text/javascript" language="javascript1.2">
	function filtrar() {
		var DEid		= document.form1.DEid.value;
		var Ifecha		= document.form1.Fecha.value;
		var CIid		= document.form1.CIid.value;
		var RHTid		= document.form1.RHTid.value;
		params = "?DEid="+DEid+"&Ifecha="+Ifecha+"&CIid="+CIid+"&RHTid="+RHTid;
		var frame = document.getElementById("Pendientes");
		frame.src = "ListIncNoPagadas.cfm"+params;
	}
</script>









			 	
