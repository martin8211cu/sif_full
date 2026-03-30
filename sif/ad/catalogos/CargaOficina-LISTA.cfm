<cfparam name="navegacion" default="">
<cfquery name="rsLista" datasource="#session.dsn#">
    select o.Ecodigo,o.Ocodigo, o.Oficodigo ,o.Odescripcion, d.DClinea, d.DCcodigo, d.DCdescripcion
    from CargasOficina co
    inner join Oficinas o
    on o.Ocodigo = co.Ocodigo
    and o.Ecodigo = co.Ecodigo
    inner join DCargas d
    on d.DClinea = co.DClinea
    and d.Ecodigo = co.Ecodigo
    where o.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ocodigo#">
	<cfif isdefined("form.fDCcodigo") and len(trim(form.fDCcodigo))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'fDCcodigo=' & form.fDCcodigo>
		and upper(rtrim(ltrim(DClinea))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fDCcodigo))#%">
	</cfif>
	<cfif isdefined("form.fDCdescripcion") and len(trim(form.fDCdescripcion))>
		<cfset navegacion = navegacion & iif(len(navegacion),DE('&'),DE('?')) & 'fDCdescripcion=' & form.fDCdescripcion>
		and upper(rtrim(ltrim(DCdescripcion))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#Ucase(Trim(form.fDCdescripcion))#%">
	</cfif>
	order by Oficodigo
</cfquery>
<cfinvoke 
	component="rh.Componentes.pListas"
	method="pListaQuery"
	returnvariable="retLista"
	query="#rsLista#"
	desplegar="DCcodigo,DCdescripcion"
	etiquetas="#LB_CODIGO#,#LB_CARGA#"
	formatos="S,S"
    keys="Ecodigo,Ocodigo,DClinea"
	align="left,left"
	irA="#CurrentPage#"
	navegacion="#navegacion#"
	maxrows="15">