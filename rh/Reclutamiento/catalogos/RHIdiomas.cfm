<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfif not REFind('erp.css',session.sitio.CSS)>
	<cf_importLibs>
</cfif>

<!----- Etiquetas de traduccion------>
<cfset LB_IdiomasDeOferente = t.translate('LB_IdiomasDeOferente','Idiomas de Oferente','/rh/generales.xml')>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>

 <cfif isdefined ('url.RHIid') and not isdefined ('form.RHIid') and len(trim(url.RHIid)) gt 0 >
 	<cfset form.RHIid = url.RHIid >
 </cfif>

<cf_templateheader> 
	<cf_web_portlet_start>
		<div class="row">
			<div class="col-sm-4">
				<cf_translatedata name="get" tabla="RHIdiomas" col="RHDescripcion" returnvariable="LvarRHDescripcion">
				<cfquery name="rsIdiomas" datasource="#session.dsn#">
					select RHIid, RHIcodigo, #LvarRHDescripcion# as RHDescripcion from RHIdiomas
				</cfquery>

				<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#rsIdiomas#"
						columnas="RHIid,RHIcodigo,RHDescripcion"
						desplegar="RHIcodigo,RHDescripcion"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						ira=""
						showEmptyListMsg="yes"
						keys="RHIid"	
						MaxRows="20"
					/>
			</div>	
			<div class="col-sm-8">
				<cfinclude template="RHIdiomas-form.cfm">
			</div>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>

