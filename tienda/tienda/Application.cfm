<cfinclude template="/home/Application.cfm"><cfsetting enablecfoutputonly="yes">
<!---  los cambios de aquí podrían necesitar duplicarse en private/Application.cfm  --->
<cfinclude template="/sif/Utiles/SIFfunciones.cfm">
<cfinclude template="cambiar_de_tienda.cfm">
<cfinclude template="carrito_asignar_a_usuario.cfm">
<cfset encryption_key = 'mX65tre9fJIdfuF83D'>

<cfsetting enablecfoutputonly="no">