<cfprocessingdirective pageEncoding="utf-8">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloCat	= t.Translate('LB_Titulo','Origenes de Datos', 'CategoriaOrigenDatos.xml')>
<cfset LB_Codigo	= t.Translate('LB_Codigo','Código', 'CategoriaOrigenDatos.xml')>
<cfset LB_Desc		= t.Translate('LB_Desc','Descripción', 'CategoriaOrigenDatos.xml')>

<!--- DEFINE PROCESO ORIGEN COMO CATEGORIA DE ORIGENES DE DATOS --->
<cfset varProc = "COD">
<cfinclude template="OrigenDatos.cfm">

<cfset modo = "ALTA">
<cfset varfiltro = "">

<cf_templateheader titulo="#LB_TituloCat#">
	<cf_web_portlet_start titulo="#LB_TituloCat#">
		<div class="row">
			<div class="col-sm-6">
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="RT_OrigenCategoria">
					<cfinvokeargument name="columnas" value="COId, COCodigo, CODescripcion">
					<cfinvokeargument name="desplegar" value="COCodigo, CODescripcion">
					<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Desc#">
					<cfinvokeargument name="formatos" value="S,S">
					<cfinvokeargument name="filtro" value="1=1"/>
					<cfinvokeargument name="align" value="left,left">
					<cfinvokeargument name="ajustar" value="S">
					<cfinvokeargument name="keys" value="COId">
					<cfinvokeargument name="irA" value="CategoriaOrigenDatos.cfm">
				</cfinvoke>
			</div>
			<div class="col-sm-6" style="padding-left:10px;">
				<cfinclude template="formCatOrigenDatos.cfm">
			</div>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>