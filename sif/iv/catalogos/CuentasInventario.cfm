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
<cfif isdefined('url.filtro_IACcodigogrupo') and not isdefined('form.filtro_IACcodigogrupo')>
	<cfset form.filtro_IACcodigogrupo = url.filtro_IACcodigogrupo>
</cfif>
<cfif isdefined('url.filtro_IACdescripcion') and not isdefined('form.filtro_IACdescripcion')>
	<cfset form.filtro_IACdescripcion = url.filtro_IACdescripcion>
</cfif>
<cfif isdefined('url.IACcodigo') and not isdefined('form.IACcodigo')>
	<cfset form.IACcodigo = url.IACcodigo>
</cfif>
<cfif isdefined('url.Empresa') and not isdefined('form.Empresa')>
	<cfset form.Empresa = url.Empresa>
</cfif>								

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="25">									
			
<cf_templateheader title="Cuentas de Inventario ">
	<cfinclude template="../../portlets/pNavegacionIV.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cuentas Contables de Inventario'>	
		<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		  <tr> 
			<td valign="top" width="40%">
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
					<cfinvokeargument name="tabla" 				value="IAContables"/>
					<cfinvokeargument name="columnas" 			value="Ecodigo as Empresa, IACcodigo, rtrim(IACcodigogrupo) as IACcodigogrupo, IACdescripcion"/>
					<cfinvokeargument name="desplegar" 			value="IACcodigogrupo, IACdescripcion"/>
					<cfinvokeargument name="etiquetas" 			value="C&oacute;digo, Cuentas de Inventario"/>
					<cfinvokeargument name="formatos" 			value="S,S"/>
					<cfinvokeargument name="filtro" 			value="Ecodigo = #Session.Ecodigo# order by IACcodigogrupo, IACdescripcion"/>
					<cfinvokeargument name="align" 				value="left, left"/>
					<cfinvokeargument name="ajustar" 			value="N"/>
					<cfinvokeargument name="checkboxes" 		value="N"/>
					<cfinvokeargument name="irA" 				value="CuentasInventario.cfm"/>
					<cfinvokeargument name="showEmptyListMsg"   value="true"/>
					<cfinvokeargument name="keys" 			    value="Empresa,IACcodigo"/>
					<cfinvokeargument name="debug"              value="N"/>									
					<cfinvokeargument name="maxRows"            value="#form.MaxRows#"/>	
					<cfinvokeargument name="mostrar_filtro"     value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>									
				</cfinvoke>
			</td>
			<td><cfinclude template="formCuentasInventario.cfm"></td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>