               
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

<cfif isdefined('url.filtro_Ccodigo') and not isdefined('form.filtro_Ccodigo')>
	<cfset form.filtro_Ccodigo = url.filtro_Ccodigo>
</cfif>
<cfif isdefined('url.filtro_Aid') and not isdefined('form.filtro_Aid')>
	<cfset form.filtro_Aid = url.filtro_Aid>
</cfif>
<cfif isdefined('url.filtro_Cdescripcion') and not isdefined('form.filtro_Cdescripcion')>
	<cfset form.filtro_Cdescripcion = url.filtro_Cdescripcion>
</cfif>
<cfif isdefined('url.filtro_Bdescripcion') and not isdefined('form.filtro_Bdescripcion')>
	<cfset form.filtro_Bdescripcion = url.filtro_Bdescripcion>
</cfif>


<cfif isdefined('url.Ccodigoclas') and not isdefined('form.Ccodigoclas')>
	<cfset form.Ccodigoclas = url.Ccodigoclas>
</cfif>
<cfif isdefined('url.Almcodigo') and not isdefined('form.Almcodigo')>
	<cfset form.Almcodigo = url.Almcodigo>
</cfif>
<cfif isdefined('url.Cdescripcion') and not isdefined('form.Cdescripcion')>
	<cfset form.Cdescripcion = url.Cdescripcion>
</cfif>
<cfif isdefined('url.Bdescripcion') and not isdefined('form.Bdescripcion')>
	<cfset form.Bdescripcion = url.Bdescripcion>
</cfif>
			
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">					
                
  	
<cf_templateheader title="Mantenimiento de Almacenes por Categor&iacute;a">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento de Almacenes por Categor&iacute;a'>
    <cfinclude template="../../../sif/portlets/pNavegacion.cfm">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="75%" valign="top"> 
                  
                <cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="Prod_ClasificacionAlmacen p
																inner join Clasificaciones c on
																p.Ecodigo = c.Ecodigo
																and p.Ccodigo = c.Ccodigo
																inner join Almacen a on
																p.Ecodigo = a.Ecodigo
																and p.Almid = a.Aid"/>
					<cfinvokeargument name="columnas" value="p.Ecodigo, p.Ccodigo, a.Aid, c.Ccodigoclas, c.Cdescripcion, a.Almcodigo, a.Bdescripcion"/> 
						<cfinvokeargument name="desplegar" value="Ccodigoclas, Cdescripcion, Almcodigo, Bdescripcion"/> 
						<cfinvokeargument name="etiquetas" value="C&oacute;digo, Clasificaci&oacute;n, C&oacute;digo, Almac&eacute;n"/> 
						<cfinvokeargument name="formatos" value="S,S,S,S"/> 
						<cfinvokeargument name="filtro" value="p.Ecodigo = #Session.Ecodigo#
                                                                    order by p.Ccodigo, a.Almcodigo"/>
						<cfinvokeargument name="align" value="left,left,left,left"/> 
						<cfinvokeargument name="checkboxes" value="N"/> 
						<cfinvokeargument name="irA" value="AlmacenesXCateg.cfm"/> 
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="Ecodigo, Ccodigo, Aid, Ccodigoclas, Almcodigo"/> 
						<cfinvokeargument name="mostrar_filtro" value="true"/>
                        <cfinvokeargument name="filtrar_por" value="c.Ccodigoclas, c.Cdescripcion, a.Almcodigo, a.Bdescripcion"/>									
						<cfinvokeargument name="filtrar_automatico" value="true"/>
                        <cfinvokeargument name="ajustar" value="S"/>
				</cfinvoke>
                  
                </td>
                <td width="25%" valign="top">
                    <cfinclude template="formAlmacenesXCateg.cfm">
                </td>
          </tr>
        </table>
	<cf_web_portlet_end>	
<cf_templatefooter>>
