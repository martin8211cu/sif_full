               
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>

<cfif isdefined('url.filtro_APcodigo') and not isdefined('form.filtro_APcodigo')>
	<cfset form.filtro_APcodigo = url.filtro_APcodigo>
</cfif>
<cfif isdefined('url.filtro_APDescripcion') and not isdefined('form.filtro_APDescripcion')>
	<cfset form.filtro_APDescripcion = url.filtro_APDescripcion>
</cfif>

<cfif isdefined('url.APcodigo') and not isdefined('form.APcodigo')>
	<cfset form.APcodigo = url.APcodigo>
</cfif>
<cfif isdefined('url.APDescripcion') and not isdefined('form.APDescripcion')>
	<cfset form.APDescripcion = url.APDescripcion>
</cfif>
			
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">					
                
  	
<cf_templateheader title="Mantenimiento de Areas de Producci&oacute;n">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento de Areas de Producci&oacute;n'>
    <cfinclude template="../../../sif/portlets/pNavegacion.cfm">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="50%" valign="top"> 
                  
                <cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="Prod_Area"/>
						<cfinvokeargument name="columnas" value="ECodigo, APcodigo, APDescripcion"/> 
						<cfinvokeargument name="desplegar" value="APcodigo, APDescripcion"/> 
						<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/> 
						<cfinvokeargument name="formatos" value="S,S"/> 
						<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#"/> 
						<cfinvokeargument name="align" value="left,left"/> 
						<cfinvokeargument name="checkboxes" value="N"/> 
						<cfinvokeargument name="irA" value="ProdArea.cfm"/> 
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="ECodigo, APcodigo"/> 
						<cfinvokeargument name="mostrar_filtro" value="true"/>
                        <cfinvokeargument name="filtrar_por" value="APcodigo, APDescripcion,''"/>									
						<cfinvokeargument name="filtrar_automatico" value="true"/>
                        <cfinvokeargument name="ajustar" value="S"/>
				</cfinvoke>
                  
                </td>
                <td width="50%" valign="top">
                    <cfinclude template="formProdArea.cfm">
                </td>
          </tr>
        </table>
	<cf_web_portlet_end>	
<cf_templatefooter>>
