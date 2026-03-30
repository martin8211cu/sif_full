<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RecursosHumanos"
	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_TiposDeAccion"
	Key="LB_TiposDeAccion" Default="Tipos de Acci&oacute;n"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_CODIGO"
	Key="LB_CODIGO" Default="C&oacute;digo" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_DESCRIPCION"
	Key="LB_DESCRIPCION" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="BTN_Filtrar"
	Key="BTN_Filtrar" Default="Filtrar" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="BTN_Limpiar"
	Key="BTN_Limpiar" Default="Limpiar" XmlFile="/rh/generales.xml"/>
<cfinvoke key="MSG_TipoIncSAT" default="Tipo Incapacidad SAT" returnvariable="MSG_TipoIncSAT" component="sif.Componentes.Translate" method="Translate"/>
    
<cfif isdefined("url.fRHTcodigo") and not isdefined("form.fRHTcodigo")>
	<cfset form.fRHTcodigo = url.fRHTcodigo >
</cfif>
<cfif isdefined("url.fRHTdesc") and not isdefined("form.fRHTdesc")>
    <cfset form.fRHTdesc = url.fRHTdesc >
</cfif>
<cfif isdefined('url.RHTid') and not isdefined('form.RHTid')>
    <cfset form.RHTid = url.RHTid>
</cfif>
<cfset filtro = "Ecodigo = #Session.Ecodigo# and RHTespecial = 0 ">
<cfset navegacion = "">
<cfif isdefined("form.fRHTcodigo") and len(trim(form.fRHTcodigo)) gt 0 >
	<cfset filtro = filtro & " and upper(RHTcodigo) like '%#ucase(form.fRHTcodigo)#%' " >
	<cfset navegacion = navegacion & "&fRHTcodigo=#form.fRHTcodigo#" >
</cfif>
<cfif isdefined("form.fRHTdesc") and len(trim(form.fRHTdesc)) gt 0 >
	<cfset filtro = filtro & " and upper(RHTdesc) like '%#ucase(form.fRHTdesc)#%' " >
	<cfset navegacion = navegacion & "&fRHTdesc=#form.fRHTdesc#" >
</cfif>
<cfset filtro = filtro & "order by RHTcodigo">
<cfset regresar = "/cfmx/rh/indexAdm.cfm">
<cfset navBarItems = ArrayNew(1)>
<cfset navBarLinks = ArrayNew(1)>
<cfset navBarStatusText = ArrayNew(1)>			 
<cfset navBarItems[1] = "Administraci&oacute;n de N&oacute;mina">
<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
            
<script language="JavaScript1.2" type="text/javascript">
    function limpiar(){
        document.filtro.fRHTcodigo.value = "";
        document.filtro.fRHTdesc.value   = "";
    }
</script>  
      
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start titulo="#LB_TiposDeAccion#">		
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
        	<tr> 
                <td width="41%" valign="top">
					<form name="filtro" method="post" style="Margin:0"> 
						<table border="0" width="100%" class="areaFiltro">
					  		<tr> 
                                <td class="subTitulo"><cfoutput>#LB_CODIGO#:</cfoutput></td>
                                <td class="subTitulo"><cfoutput>#LB_DESCRIPCION#:</cfoutput></td>
						  </tr>
						  <tr>
                            <td><input type="text" name="fRHTcodigo" value="<cfif isdefined("form.fRHTcodigo") and len(trim(form.fRHTcodigo)) gt 0 ><cfoutput>#form.fRHTcodigo#</cfoutput></cfif>" size="5" maxlength="3" onFocus="javascript:this.select();" ></td>
                            <td><input type="text" name="fRHTdesc" value="<cfif isdefined("form.fRHTdesc") and len(trim(form.fRHTdesc)) gt 0 ><cfoutput>#form.fRHTdesc#</cfoutput></cfif>" size="60" maxlength="60" onFocus="javascript:this.select();" ></td>
					  	</tr>
					  	<tr>
					    	<td colspan="2" align="center">
                            	<input type="submit" name="Filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
				          		<input type="button" name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onClick="javascript:limpiar();">
					    	</td>
				      	</tr>
					</table>
				</form>
					<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
                        <cfinvokeargument name="tabla" 		value="RHTipoAccion"/>
                        <cfinvokeargument name="columnas" 	value="RHTid, RHTcodigo, RHTdesc"/>
                        <cfinvokeargument name="desplegar" 	value="RHTcodigo, RHTdesc"/>
                        <cfinvokeargument name="etiquetas" 	value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
                        <cfinvokeargument name="formatos" 	value="V, V"/>
                        <cfinvokeargument name="filtro" 	value="#filtro#"/>
                        <cfinvokeargument name="align" 		value="left, left"/>
                        <cfinvokeargument name="ajustar" 	value="N"/>
                        <cfinvokeargument name="checkboxes" value="N"/>
                        <cfinvokeargument name="irA" 		value="TipoAccion.cfm"/>
                        <cfinvokeargument name="keys" 		value="RHTid"/>
                        <cfinvokeargument name="navegacion" value="#navegacion#"/>
                        <cfinvokeargument name="MaxRows" 	value="35"/>
					</cfinvoke>
				</td>
                <td width="1%" valign="top">&nbsp;</td>
                <td width="58%" valign="top"><cfinclude template="formTipoAccion.cfm"></td>
              </tr>
			 </table>
	  <cf_web_portlet_end>
<cf_templatefooter>