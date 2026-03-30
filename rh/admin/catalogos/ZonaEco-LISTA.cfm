<cfparam name="navegacion" default="">
<cfquery name="rsLista" datasource="#session.dsn#">
	select 	ZEid,
		CEcodigo,
		{fn concat({fn concat(rtrim(b.Ppais) , '  ' )},  b.Pnombre )}  as Pnombre,
		ZEcodigo,
		ZEdescripcion,
		a.BMUsucodigo
	from ZonasEconomicas a
		inner join Pais b on a.Ppais = b.Ppais
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session..CEcodigo#">
	<cfif isdefined("form.fZEcodigo") and len(trim(form.fZEcodigo))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'fZEcodigo=' & form.fZEcodigo>
		and upper(rtrim(ltrim(ZEcodigo))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fZEcodigo))#%">
	</cfif>
	<cfif isdefined("form.fZEdescripcion") and len(trim(form.fZEdescripcion))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'fZEdescripcion=' & form.fZEdescripcion>
		and upper(rtrim(ltrim(ZEdescripcion))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fZEdescripcion))#%">
	</cfif>
	order by Pnombre
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
	cortes="Pnombre"
	desplegar="ZEcodigo,ZEdescripcion"
	etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
	formatos="S,S"
    keys="ZEid"
	align="left,left"
	irA="#CurrentPage#"
	navegacion="#navegacion#"
	maxrows="15">