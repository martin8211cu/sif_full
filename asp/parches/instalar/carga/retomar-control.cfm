<cfset session.instala = StructNew ()>
<cfset session.instala.parche = form.parche>
<cfset session.instala.instalacion = form.instalacion>
<cfset session.instala.nombre = form.nombre>
<cfinvoke component="asp.parches.comp.instala" method="retomar"/>

<cflocation url="ver.cfm">
