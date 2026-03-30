<cfparam name="form.esquema">

<cfset LvarTipos = "syb,mss,ora,db2">
<cfloop list="#LvarTipos#" index="LvarTipo">
	<cfif form["ruta_#LvarTipo#"] NEQ "">
		<cfinvoke component="asp.parches.comp.parche" method="agregar_sql"
			dbms="#LvarTipo#"
			esquema="#form.esquema#"
			filefield="ruta_#LvarTipo#"
			descripcion="#form.descripcion#" />
	</cfif>
</cfloop>

<cfinvoke component="asp.parches.comp.parche" method="contar"/>

<cflocation url="sqlbuscar.cfm">
