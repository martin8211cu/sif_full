<cfparam 	name="Attributes.id"					type="string"	default="">						<!--- Id de la Persona--->
<cfparam 	name="Attributes.form" 					type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 				type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam	name="Attributes.funcion"				type="string"	default="">						<!--- Función a invocar después del llamado al conlis --->
<cfparam 	name="Attributes.CEcodigo" 				type="string"	default="#Session.CEcodigo#">	<!--- código de empresa del Portal --->
<cfparam 	name="Attributes.Conexion" 				type="string"	default="#Session.DSN#">		<!--- cache de conexion --->

<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>
	<cfquery datasource="#Attributes.Conexion#" name="rsUsuario">
		select a.Usucodigo, a.Usulogin
		from Usuario a
		where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
	</cfquery>
</cfif>

<cfset array = ArrayNew(1)>
<cfif isdefined("rsUsuario") and rsUsuario.RecordCount NEQ 0>
	<cfset temp = ArraySet(array, 1, 2, "")>
	<cfset array[1] = rsUsuario.Usucodigo>
	<cfset array[2] = rsUsuario.Usulogin>
</cfif>

<cf_conlis 
	title="Usuario"
	campos = "Usucodigo#Attributes.sufijo#, Usulogin#Attributes.sufijo#"
	desplegables = "N,S" 
	modificables = "N,S"
	size = "0,30"
	tabla="Usuario a"
	columnas="a.Usucodigo#Attributes.sufijo#, a.Usulogin#Attributes.sufijo#" 
	desplegar="Usulogin#Attributes.sufijo#"
	filtro="a.CEcodigo = #Attributes.CEcodigo#"
	filtrar_por="a.Usulogin"
	etiquetas="Login"
	formatos="S"
	align="left"
	asignar="Usucodigo#Attributes.sufijo#, Usulogin#Attributes.sufijo#"
	asignarformatos="S,S"
	Form="#Attributes.form#"
	Conexion="#Attributes.Conexion#"
	funcion="#Attributes.funcion#"
	valuesArray="#array#"
	closeOnExit="true"
	tabindex="1">

