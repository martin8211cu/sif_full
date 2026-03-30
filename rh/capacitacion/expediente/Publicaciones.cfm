
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfif not REFind('erp.css',session.sitio.CSS)>
	<cf_importLibs>
</cfif>

<!----- Etiquetas de traduccion------>
<cfset LB_Publicaciones = t.translate('LB_Publicaciones','Publicaciones','/rh/generales.xml')>
<cfset LB_Publicacion = t.translate('LB_Publicacion','Publicación','/rh/generales.xml')>
<cfset LB_PendienteAprobacion = t.translate('LB_PendienteAprobacion','Pendiente de aprobación','/rh/generales.xml')>

<cfif isdefined ('LvarAutog') and LvarAutog eq 1 >
	<cfset self = "autogestion.cfm?o=9&tab=9" >
	<cfset destino = "operacion/Publicaciones-sql.cfm" >
<cfelseif isdefined("fromExpediente")>
	<cfset self = "expediente.cfm?DEid=#form.DEid#&tab=12">
	<cfset destino = "Publicaciones-sql.cfm" >	
<cfelseif  isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
	<cfset self = "AprobacionCV.cfm?tab=5" >
	<cfset destino = "AprobacionCV-sql.cfm" >	
<cfelse>
	<cfset self = "Publicaciones.cfm" >
	<cfset destino = "Publicaciones-sql.cfm" >	
</cfif>

<cfif isdefined ('url.RHPid') and not isdefined ('form.RHPid') and len(trim(url.RHPid)) gt 0 >
 	<cfset form.RHPid = url.RHPid >
 </cfif>

 <cfif isdefined ('url.DEid') and not isdefined ('form.DEid') and len(trim(url.DEid)) gt 0 >
 	<cfset form.DEid = url.DEid >
 </cfif>

<cf_dbfunction name="op_concat" returnvariable="concat"/>
<cfquery name="rsListPublic" datasource="#session.DSN#">
	select RHP.RHPid, RHP.DEid, RHP.RHPTitulo #concat# case when RHP.RHPAnoPub is not null then ' (' #concat# convert(varchar,RHP.RHPAnoPub) #concat# ')' else '' end #concat# case when RHPEstado = 0 then ' -> #LB_Pendienteaprobacion#' else '' end  as Publicacion
	from RHPublicaciones RHP
	where RHP.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cf_web_portlet_start titulo="#LB_Publicaciones#">
	<div class="row">
		<div class="col-sm-5">
			<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaPub">
				<cfinvokeargument name="query" value="#rsListPublic#"/>
				<cfinvokeargument name="desplegar" value="Publicacion"/>
				<cfinvokeargument name="etiquetas" value="#LB_Publicacion#"/>
				<cfinvokeargument name="formato" value="string"/>
				<cfinvokeargument name="align" value="left"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="RHPid"/>
				<cfinvokeargument name="ira" value="#self#"/>
				<cfinvokeargument name="formName" value="formPublicacionLista"/>
				<cfinvokeargument name="PageIndex" value="1"/>
			</cfinvoke>
		</div>
		<div class="col-sm-7">
			<cfinclude template="Publicaciones-form.cfm">
		</div>
	</div>
<cf_web_portlet_end>
