<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_mserror = t.Translate('LB_mserror','El codigo ya existe, intentelo nuevamente.','/home/menu/GrpModulos.xml')>

<cfif isDefined("url.SScodigo")>
	<cfset form.SScodigo = url.SScodigo></cfif>
<cfif isDefined("url.Pagina")>
	<cfset form.Pagina = url.Pagina>
</cfif>
<cf_templateheader title="Grupo de modulos">
	<cf_web_portlet_start titulo="Grupo de modulos">
		<cfinclude template="frame-header.cfm">
		<div class="row">
			<div class="row">
				<cfinclude template="/home/menu/pNavegacion.cfm">
			</div>
			<cfif isdefined ('url.error') and url.error eq 1>
				<div class="row">
					<div class="alert alert-success" role="alert">#LB_mserror#</div>
				</div>
			</cfif>
			<div class="col-md-6">
				<cfinvoke
				 component="commons.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="SGModulos sg"/>
					<cfinvokeargument name="columnas" value="SGcodigo, SGdescripcion, SScodigo,SGorden,IconFonts,SGhablada"/>
					<cfinvokeargument name="desplegar" value="SGcodigo, SGdescripcion, SScodigo"/>
					<cfinvokeargument name="etiquetas" value="Código, Descripción del Sistema, Sistema "/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="1=1 order by SGcodigo, SScodigo, SGdescripcion"/>
					<cfinvokeargument name="align" value="right, left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="GrpModulos.cfm"/>
					<cfinvokeargument name="maxRows" value="20"/>
					<cfinvokeargument name="keys" value="SGcodigo"/>
					<cfinvokeargument name="conexion" value="asp"/>
					<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
				</cfinvoke>
			</div>
			<div class="col-md-6">
				<cfinclude template="GrpModulos-form.cfm">
			</div>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>
