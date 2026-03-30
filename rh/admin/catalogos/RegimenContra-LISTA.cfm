<cfparam name="navegacion" default="">
<cfquery name="rsLista" datasource="#session.dsn#">
	select 	RHRegimenid, RHRegimencodigo, RHRegimendescripcion, FechaAlta, BMUsucodigo
	from RHCFDI_Regimen
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	<cfif isdefined("form.fRCcodigo") and len(trim(form.fRCcodigo))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'fRCcodigo=' & form.fRCcodigo>
		and upper(rtrim(ltrim(RHRegimencodigo))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fRCcodigo))#%">
	</cfif>
	<cfif isdefined("form.fRCdescripcion") and len(trim(form.fRCdescripcion))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'fRCdescripcion=' & form.fRCdescripcion>
		and upper(rtrim(ltrim(RHRegimendescripcion))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fRCdescripcion))#%">
	</cfif>
	order by RHRegimencodigo
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
	desplegar="RHRegimencodigo,RHRegimendescripcion"
	etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
	formatos="S,S"
    keys="RHRegimenid"
	align="left,left"
	irA="#CurrentPage#"
	navegacion="#navegacion#"
	maxrows="15">