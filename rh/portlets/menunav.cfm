<!---<cfset session.menues.id_root=8397>--->

<!--- Revisar esto de los menues, se supone que un empleado tiene acceso a x roles noa todos 
      como esta ahora. Esta parte se copio de portal_control.cfm   --->
<!---
<cfquery name="dataMenu" datasource="asp" maxrows="1">
	select a.id_menu, a.id_root
	from SMenu a
	
	inner join SMenuItem b
	on a.id_root = b.id_item
	
	where a.ocultar_menu = 0
	order by a.orden_menu
</cfquery>

<cfif len(trim(dataMenu.id_menu)) and len(trim(dataMenu.id_root))>
	<cfparam name="session.menues.id_root" default="#dataMenu.id_root#">
<cfelse>--->
	<!--- Administrador --->
<!---</cfif>--->
<!--- ---------------------------------------------------- --->

<!---<cfinclude template="/home/menu/portlets/menu-content.cfm">--->