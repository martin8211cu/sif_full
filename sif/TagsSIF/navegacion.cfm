<!---
	Tag para facilitar la implementación de la funcionalidad de navegacion
	
	Funcionalidad:

		1- Pasa url.CAMPO a form.CAMPO						(atributo <name="CAMPO"> obligatorio)
		
		2- Arma la hilera de la variable navegacion			(el nombre default de la variable es "navegacion")
															(se puede cambiar indicando atributo <navegacion="VARIABLE">)
															(se puede omitir el armado de la hilera indicando atributo <navegacion="">)
		
		3- Puede crear o cambiar el form.CAMPO con un valor	(se debe indicar atributo <value="VALOR">)
		   forzado											(si no se indica no se crea el campo nuevo pero puede utilizar <default>)
		
		4- Puede crear el form.CAMPO con un valor default	(se debe indicar atributo <default="VALOR">)
															(si no se indica no se crea el campo nuevo pero puede utilizar <session>)
	
		5- Puede guardar el valor default en session		(se debe indicar atributo <session>, y se guarda en session.navegacion)
															(se puede cambiar la estructura indicando atributo <navegacion="ESTRUCTURA">
															 y se guarda en session.navegacion.ESTRUCTURA)
	Ejemplos:

		<cf_navegacion name="CAMPO">	
			Pasa url.CAMPO a form.CAMPO, si tiene valor lo incluye en variable navegacion
			Si no existe ni url.CAMPO ni form.CAMPO no lo crea

		<cf_navegacion name="CAMPO" default="1">	
			Pasa url.CAMPO a form.CAMPO, si tiene valor lo incluye en variable navegacion
			Si no existe ni url.CAMPO ni form.CAMPO lo crea con valor=1

		<cf_navegacion name="CAMPO" navegacion="">	
			Unicamente pasa url.CAMPO a form.CAMPO, si existe url.CAMPO, si no no crea la variable

		<cf_navegacion name="CAMPO" default="1" navegacion="">	
			Pasa url.CAMPO a form.CAMPO, no construye variable navegacion
			Si no existe ni url.CAMPO ni form.CAMPO lo crea con valor=1

		<cf_navegacion name="CAMPO" default="1" session>	
			Pasa url.CAMPO a form.CAMPO, si tiene valor lo incluye en variable navegacion
			Si no existe ni url.CAMPO ni form.CAMPO lo crea con valor guardado en session.navegacion.CAMPO y la primera vez con valor=1
--->

<cfparam name="Attributes.name"			type="string"> 		  				<!--- Nombres del campo del filtro --->
<cfparam name="Attributes.value"		type="string" default="#chr(1)#"> 	<!--- Valor forzado --->
<cfparam name="Attributes.default" 		type="string" default="#chr(1)#">	<!--- Valor default cuando no esta en session o si hay que inicializar --->
<cfparam name="Attributes.session"		type="string" default="#chr(1)#">	<!--- Si se quiere guardar el default en una estructura de session --->
<cfparam name="Attributes.incluirNull"	type="boolean" default="false">		<!--- Incluir en Navegacion campos en blanco --->
<cfparam name="Attributes.navegacion"	type="string" default="navegacion"> <!--- Nombres de variable a concatenar --->

<cfif Attributes.session EQ "" OR Attributes.session EQ "true">
	<cfset Attributes.session = "default">
</cfif>
<cfif Attributes.value NEQ chr(1)>
	<!--- Si hay valor forzado lo asigna --->
	<cfset form[Attributes.name] = Attributes.value>
<cfelseif isdefined("form.#Attributes.name#")>
	<!--- Si viene por form lo preserva --->
<cfelseif isdefined("url.#Attributes.name#")>
	<!--- Si viene por url lo asigna --->
	<cfset form[Attributes.name] = url[Attributes.name]>
<cfelseif not isdefined("form.#Attributes.name#")>
	<!--- Si no viene por form lo toma del default --->
	<cfif Attributes.session NEQ chr(1)>
		<cfparam name="session.navegacion" default="#structNew()#">
		<!--- Si el default se guarda en session lo toma de session --->
		<cfif Attributes.default NEQ chr(1)>
			<cfset LvarDefault = Attributes.default>
		<cfelse>
			<cfset LvarDefault = "">
		</cfif>
		<cfif Attributes.session NEQ "">
			<cfparam name="session.navegacion.#Attributes.session#" default="#structNew()#">
			<cfparam name="session.navegacion.#Attributes.session#.#Attributes.name#" default="#LvarDefault#">
			<cfset form[Attributes.name] = session.navegacion[Attributes.session][Attributes.name]>
		<cfelse>
			<cfparam name="session.navegacion.#Attributes.name#" default="#LvarDefault#">
			<cfset form[Attributes.name] = session.navegacion[Attributes.name]>
		</cfif>
	<cfelseif Attributes.default NEQ chr(1)>
		<cfset form[Attributes.name] = Attributes.default>
	</cfif>
</cfif>

<!--- Si el default se guarda en session lo guarda en session --->
<cfif Attributes.session neq chr(1)>
	<cfif Attributes.session NEQ "">
		<cfif not isdefined("session.navegacion.#Attributes.session#")>
			<cfset session.navegacion[Attributes.session] = structNew()>
		</cfif>
		<cfset session.navegacion[Attributes.session][Attributes.name] = form[Attributes.name]>
	<cfelse>
		<cfset session.navegacion[Attributes.name] = form[Attributes.name]>
	</cfif>
</cfif>
<cfif isdefined("form.#Attributes.name#")>
	<cfset url[Attributes.name] = form[Attributes.name]>
</cfif>

<!--- Arma la variable navegacion --->
<cfif Attributes.navegacion NEQ "">
	<cfif not isdefined("caller.#Attributes.navegacion#")>
		<cfset caller[Attributes.navegacion] = "">
	</cfif>
	<cfif isdefined("Form.#Attributes.name#")>
		<cfif Len(Trim(form[Attributes.name])) NEQ 0 or Attributes.incluirNull>
			<cfset caller[Attributes.navegacion] = caller[Attributes.navegacion] & Iif(Len(Trim(caller[Attributes.navegacion])) NEQ 0, DE("&"), DE("")) & "#Attributes.name#=#urlEncodedFormat(trim(form[Attributes.name]))#">
		</cfif>				
	</cfif>				
</cfif>
