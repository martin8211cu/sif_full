<cfparam name="navegacion" default="">
<cfquery name="rsLista" datasource="#session.dsn#">
	select 	RHRiesgoid, RHRiesgocodigo, RHRiesgodescripcion, FechaAlta, BMUsucodigo
	from RHCFDI_Riesgo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	<cfif isdefined("form.fRPcodigo") and len(trim(form.fRPcodigo))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'fRPcodigo=' & form.fRPcodigo>
		and upper(rtrim(ltrim(RHRiesgocodigo))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fRCcodigo))#%">
	</cfif>
	<cfif isdefined("form.fRPdescripcion") and len(trim(form.fRPdescripcion))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'fRPdescripcion=' & form.fRPdescripcion>
		and upper(rtrim(ltrim(RHRiesgodescripcion))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fRPdescripcion))#%">
	</cfif>
	order by RHRiesgocodigo
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CODIGO"
Default="C&oacute;digo"
XmlFile="/rh/generales.xml"
returnvariable="LB_CODIGO"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_DESCRIPCION"
Default="Descripci&oacute;n"
XmlFile="/rh/generales.xml"
returnvariable="LB_DESCRIPCION"/>

<cfinvoke 
	component="rh.Componentes.pListas"
	method="pListaQuery"
	returnvariable="retLista"
	query="#rsLista#"
	desplegar="RHRiesgocodigo,RHRiesgodescripcion"
	etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
	formatos="S,S"
    keys="RHRiesgoid"
	align="left,left"
	irA="#CurrentPage#"
	navegacion="#navegacion#"
	maxrows="15">