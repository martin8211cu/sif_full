<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>

<cfloop list="bcp.tool,bcp.opt,bcp.in,bcp.out,bcp.id,bcp.user,bcp.server,path" index="item">
	<cfset Politicas.modifica_parametro_global('respaldo.' & item, form[ 'respaldo_' & Replace(item, '.', '_') ])>
</cfloop>

<cfset session.statusmsg = 'Opciones modificadas'>
<cflocation url="../empresas.cfm">