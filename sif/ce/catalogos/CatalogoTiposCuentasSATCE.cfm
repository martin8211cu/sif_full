<cfset filtro="1=1 order by Codigo">

<cfif isdefined("form.filtros")>
<cfif isdefined('form.Codigo') and form.Codigo neq '' >
		<cfset filtro = "Codigo = '" & form.Codigo & "' order by Codigo">
</cfif>

<cfif isdefined('form.Descripcion') and form.Descripcion neq '' >
		<cfset filtro = "Descripcion like '%" & form.Descripcion & "%' order by Codigo">
</cfif>

<cfif isdefined('form.Codigo') and form.Codigo neq '' and isdefined('form.Descripcion') and form.Descripcion neq ''>
	<cfset filtro = "Descripcion = " & form.Descripcion & " and Codigo like '%" & form.Codigo & "%' order by Codigo">
</cfif>
</cfif>

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
<cfset navegacion= "">

<cfif isdefined("url.Codigo") and not isdefined("form.Codigo")>
	<cfset form.Codigo = url.Codigo >
</cfif>

<cfif isdefined('form.Codigo') and LEN(TRIM(form.Codigo))>
	<cfset navegacion = "Codigo=" & form.Codigo>
</cfif>
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">

<cf_templateheader title="Procedimiento de Contratación">
<cf_web_portlet_start titulo="Cat&aacute;logo Clasificaci&oacute;n de Cuentas al SAT">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<table width="95%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" width="50%">
			<cfinvoke component="sif.Componentes.pListas" method="pListaRH"	 returnvariable="pListaTran">
				<cfinvokeargument name="tabla" 		value="CEClasificacionCuentasSAT"/>
				query="#lista#"
				<cfinvokeargument name="columnas" 	value="Id_CCS,Codigo,Descripcion"/>
				<cfinvokeargument name="desplegar" 	value="Codigo,Descripcion"/>
				<cfinvokeargument name="etiquetas" 	value="Código, Descripción"/>
				<cfinvokeargument name="formatos" 	value=""/>
				<cfinvokeargument name="filtro" 	value="#filtro#"/>
				<cfinvokeargument name="align" 		value="left, left, left"/>
				<cfinvokeargument name="ajustar" 	value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="keys" 		value="Id_CCS"/>
				<cfinvokeargument name="irA"	 	value="CatalogoTiposCuentasSATCE.cfm"/>
				<cfinvokeargument name="maxRows" 	value="#form.MaxRows#"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
		<td><cfinclude template="formCatalogoTiposCuentasSATCE.cfm"></td>
	</tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>
