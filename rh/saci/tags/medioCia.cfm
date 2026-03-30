<cfparam	name="Attributes.id"				type="string"	default="">						<!--- Id de referencia del medio --->
<cfparam	name="Attributes.nombre"			type="string"	default="">						<!--- nombre del medio --->

<cfparam 	name="Attributes.form" 				type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">		<!--- cache de conexión --->
<cfparam 	name="Attributes.readOnly" 			type="boolean"	default="false">				<!--- se usa para indicar si se muestra en modo consulta --->

<cfset ExisteMedio = (isdefined("Attributes.id") and Len(Trim(Attributes.id)))>

<table width="100%" cellpadding="2" cellspacing="0" border="0">
	<tr><td>
		
		<cfset array = ArrayNew(1)>
		
		<cfif len(trim(Attributes.id)) and len(trim(Attributes.nombre))>
			<cfset temp = ArraySet(array, 1,2, "")>
			<cfset array[1] = Attributes.id>
			<cfset array[2] = Attributes.nombre>
		</cfif>
		
		<cf_conlis 
			title="Medios"
			campos = "EMid,EMnombre" 
			desplegables = "N,S" 
			modificables = "N,S"
			size = "0,30"
			tabla = "ISBmedioCia a"
			columnas = "a.EMid,a.EMnombre" 
			desplegar = "EMnombre"
			filtro = ""
			filtrar_por = "EMnombre"
			etiquetas = "Nombre"
			formatos = "S"
			align = "left"
			asignar = "EMid,EMnombre"
			asignarformatos = "S,S"
			Form = "#Attributes.form#"
			Conexion = "#Attributes.Conexion#"
			funcion = ""
			valuesArray="#array#"
			closeOnExit="true"
			tabindex="1"
		>
	</td></tr>
</table>

