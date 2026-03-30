<cfparam name="navegacion" default="">
<cfquery name="rsLista" datasource="#session.dsn#">
	select 	RHCSATid, RHCSATcodigo, RHCSATdescripcion, RHCSATtipo, FechaAlta, BMUsucodigo
	from RHCFDIConceptoSAT
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	<cfif isdefined("form.fCScodigo") and len(trim(form.fCScodigo))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'RHCSATcodigo=' & form.fCScodigo>
		and upper(rtrim(ltrim(RHCSATcodigo))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fCScodigo))#%">
	</cfif>
	<cfif isdefined("form.fCSdescripcion") and len(trim(form.fCSdescripcion))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'RHCSATdescripcion=' & form.fCSdescripcion>
		and upper(rtrim(ltrim(RHCSATdescripcion))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fCSdescripcion))#%">
	</cfif>
	order by RHCSATtipo,RHCSATcodigo
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

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_TIPO"
Default="Tipo"
XmlFile="/rh/generales.xml"
returnvariable="LB_TIPO"/>

<cfinvoke 
	component="rh.Componentes.pListas"
	method="pListaQuery"
	returnvariable="retLista"
	query="#rsLista#"
	desplegar="RHCSATcodigo,RHCSATdescripcion,RHCSATtipo"
	etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#,#LB_TIPO#"
	formatos="S,S,S"
    keys="RHCSATid"
	align="left,left,left"
	irA="#CurrentPage#"
	navegacion="#navegacion#"
	maxrows="15">