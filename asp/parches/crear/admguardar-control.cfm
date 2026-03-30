<cfset session.parche.info.pdir = form.pdir>
<cfset session.parche.info.pnum = form.pnum>
<cfset session.parche.info.psec = form.psec>
<cfset session.parche.info.psub = form.psub>
<cfset session.parche.info.modulo = form.modulo> 
<cfset session.parche.info.nombre = form.nombre>
<cfset session.parche.info.autor = form.autor>
<cfset session.parche.info.vistas = IsDefined('form.vistas')>
<cfset session.parche.info.descripcion = form.descripcion>
<cfset session.parche.info.instrucciones = form.instrucciones>

<cfif trim(session.parche.info.nombre) EQ "">
	<cfset session.parche.info.nombre = "Parche#session.parche.info.pnum#_#session.parche.info.psec#_#session.parche.info.pdir#_#session.parche.info.psub#">
</cfif>

<cfinvoke component="asp.parches.comp.parche" method="guardar"/>
<cfif IsDefined('siguiente')>
	<cflocation url="svnbuscar.cfm">
<cfelse>
	<cflocation url="admguardar.cfm">
</cfif>