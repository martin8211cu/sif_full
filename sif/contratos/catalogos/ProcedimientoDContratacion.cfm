<!---  --->
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfset filtro="1=1 order by CTPCcodigo">

<cfif isdefined("form.filtros")>
<cfif isdefined('form.CTPCcodigo') and form.CTPCcodigo neq '' >
		<cfset filtro = "CTPCcodigo = '" & form.CTPCcodigo & "' order by CTPCcodigo">
</cfif>

<cfif isdefined('form.CTPCdescripcion') and form.CTPCdescripcion neq '' >
		<cfset filtro = "CTPCdescripcion like '%" & form.CTPCdescripcion & "%' order by CTPCcodigo">
</cfif>

<cfif isdefined('form.CCTcodigo') and form.CCTcodigo neq '' and isdefined('form.CTPCdescripcion') and form.CTPCdescripcion neq ''>
	<cfset filtro = "CTPCdescripcion = " & form.CTPCdescripcion & " and CTPCcodigo like '%" & form.CTPCcodigo & "%' order by CTPCcodigo">
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

<cfif isdefined("url.CCTcodigo") and not isdefined("form.CCTcodigo")>
	<cfset form.CCTcodigo = url.CCTcodigo >
</cfif>

<cfif isdefined('form.CCTcodigo') and LEN(TRIM(form.CCTcodigo))>
	<cfset navegacion = "CTPCcodigo=" & form.CTPCcodigo>
</cfif>
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">

<cf_templateheader title="Procedimiento de Contratación">
<cf_web_portlet_start titulo="Procedimiento de Contratación">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<table width="95%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" width="50%">
			<cfinvoke component="sif.Componentes.pListas" method="pListaRH"	 returnvariable="pListaTran">
				<cfinvokeargument name="tabla" 		value="CTProcedimientoContratacion"/>
				query="#lista#"
				<cfinvokeargument name="columnas" 	value="CTPCid,CTPCcodigo,CTPCdescripcion"/>
				<cfinvokeargument name="desplegar" 	value="CTPCcodigo,CTPCdescripcion"/>
				<cfinvokeargument name="etiquetas" 	value="Código, Descripción"/>
				<cfinvokeargument name="formatos" 	value=""/>
				<cfinvokeargument name="filtro" 	value="#filtro#"/>
				<cfinvokeargument name="align" 		value="left, left, left"/>
				<cfinvokeargument name="ajustar" 	value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="keys" 		value="CTPCid"/>
				<cfinvokeargument name="irA"	 	value="ProcedimientoDContratacion.cfm"/>
				<cfinvokeargument name="maxRows" 	value="#form.MaxRows#"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
		<td><cfinclude template="ProcedimientoDContratacion-form.cfm"></td>
	</tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>
