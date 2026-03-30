
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfif not REFind('erp.css',session.sitio.CSS)>
	<cf_importLibs>
</cfif>

<!----- Etiquetas de traduccion------>
<cfset LB_TiposPublicacion = t.translate('LB_TiposPublicacion','Tipos de Publicación','/rh/generales.xml')>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>

 <cfif isdefined ('url.RHPTid') and not isdefined ('form.RHPTid') and len(trim(url.RHPTid)) gt 0 >
 	<cfset form.RHPTid = url.RHPTid >
 </cfif>

 <cf_templateheader> 
	<cf_web_portlet_start>
		<div class="row">
			<div class="col-sm-4">
				<cf_translatedata name="get" tabla="RHPublicacionTipo" col="RHPTDescripcion" returnvariable="LvarRHPTDescripcion">
				<cfquery name="rsTipoPublic" datasource="#session.dsn#">
					select RHPTid, RHPTcodigo, #LvarRHPTDescripcion# as RHPTDescripcion 
					from RHPublicacionTipo
					order by #LvarRHPTDescripcion#
				</cfquery>

				<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#rsTipoPublic#"
						columnas="RHPTid,RHPTcodigo,RHPTDescripcion"
						desplegar="RHPTcodigo,RHPTDescripcion"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						showEmptyListMsg="yes"
						ira=""
						ajustar="true"
						keys="RHPTid"	
						MaxRows="20"
					/>
			</div>	
			<div class="col-sm-8">
				<cfinclude template="PublicacionesTipo-form.cfm">
			</div>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>