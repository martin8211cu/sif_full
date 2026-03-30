<cfparam name="navegacion" default="">
<cfquery name="rsLista" datasource="#session.dsn#">
	select 	RHIncapid, RHIncapcodigo, RHIncapdescripcion, FechaAlta, BMUsucodigo
	from RHCFDIIncapacidad
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	<cfif isdefined("form.fTIcodigo") and len(trim(form.fTIcodigo))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'fTIcodigo=' & form.fTIcodigo>
		and upper(rtrim(ltrim(RHIncapcodigo))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fTIcodigo))#%">
	</cfif>
	<cfif isdefined("form.fTIdescripcion") and len(trim(form.fTIdescripcion))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'fTIdescripcion=' & form.fTIdescripcion>
		and upper(rtrim(ltrim(RHIncapdescripcion))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fTIdescripcion))#%">
	</cfif>
	order by RHIncapcodigo
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
	desplegar="RHIncapcodigo,RHIncapdescripcion"
	etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
	formatos="S,S"
    keys="RHIncapid"
	align="left,left"
	irA="#CurrentPage#"
	navegacion="#navegacion#"
	maxrows="15">