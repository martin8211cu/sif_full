<cfsetting requesttimeout="3600">
<cfif not isdefined('session.DSN')>
	<cfset session.DSN = 'minisif'>
</cfif>
<cfif not isdefined('session.Ecodigo')>
    <cfset session.Ecodigo = 2>
</cfif>
<cfif isdefined('url.Usucodigo') and url.Usucodigo eq 11499>
    <cfset session.Ecodigo = 1>
</cfif>

<cfset fullpath = GetDirectoryFromPath(GetTemplatePath()) & "txt">

<cfset zipfile = "#fullpath#/Listas.zip" >
<cfset This.ListaColor = createobject("component","/sif/QPass/Componentes/QPListaColor")>
<cftransaction>
	<cfset LvarLista = This.ListaColor.fnActualizaTags(-1, session.Ecodigo, session.DSN)>
    <cfset LvarLista = This.ListaColor.fnTagPromotores(-1, session.Ecodigo, session.DSN)>
    <cfset LvarLista = This.ListaColor.fnVentasPrepago(-1, session.Ecodigo, session.DSN)>
    <cftransaction action="commit"/>
</cftransaction>
<cfset This.Lista = createobject("component","/sif/QPass/operacion/InsertaLista")><!---Inicializa el componente---->
<cfset LvarControl=This.Lista.fnGeneraArchivo(session.Ecodigo, session.dsn, 'B', fullpath)>
<cfset LvarControl=This.Lista.fnGeneraArchivo(session.Ecodigo, session.dsn, 'G', fullpath)>
<cfset LvarControl=This.Lista.fnGeneraArchivo(session.Ecodigo, session.dsn, 'N', fullpath)>


