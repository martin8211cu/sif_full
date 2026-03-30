<!---
	Este tag solito 
		-lee el archivo del file field
		-lo pone en un archivo temporal
		-lo convierte a binario
		-pone el cfqueryparam correspondiente
		- se puede usar directamente en el insert o el update
		- requiere el driver de jdbc de macromedia
	Ejemplo de como se usa:
	
		<cfquery name="rs" datasource="asp">
		update SSistemas 
		   set SSdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SSdescripcion#">,
		   /******/
			  SSlogo = <cf_dbupload filefield="logo" accept="image/*" datasource="asp">,
		   /******/
			   SShablada = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.SShablada#">
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
	</cfquery>
	
	Modificado por danim, 2-feb-2006
		Se genera la estructura dbupload, con los siguientes atributos:
			dbupload.filename: Nombre del archivo
			dbupload.contents: Contenido del archivo


--->
<cfparam name="Attributes.filefield">
<cfparam name="Attributes.accept" default="">
<cfparam name="Attributes.datasource" default="">
<cfparam name="Attributes.returnvariable" default="dbupload">
<cfparam name="Attributes.queryparam" default="yes">
<cfparam name="Attributes.foto" default="false"><!--- se coloca en true si para que se haga un resize de la imagen de la foto para un tipo de perfil de 80px x 100px---->
<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cf_errorCode	code = "50597" msg = "Falta el atributo datasource, y session.dsn no está definida.">
	</cfif>
</cfif>
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cf_errorCode	code = "50599"
					msg  = "Datasource no definido: @errorDat_1@"
					errorDat_1="#HTMLEditFormat(Attributes.datasource)#"
	>
</cfif>

<cfparam name="form.#Attributes.fileField#" default="">

<cfset dbupload_ret = StructNew()>
<cfset dbupload_ret.filename = ''>
<cfset dbupload_ret.contents = BinaryDecode( '', 'Hex')>

<cfif Len(form[Attributes.fileField]) Is 0>
	<!--- no hay imagen --->
	<cfif Attributes.queryparam>
		<cfoutput>null</cfoutput>
	</cfif>
<cfelse>
	<cfif len(trim(Attributes.accept)) gt 0>
		<cffile action="Upload" filefield="form.#Attributes.fileField#" destination="#gettempdirectory()#" nameConflict="overwrite" accept="#Attributes.accept#">
	<cfelse>
		<cffile action="Upload" filefield="form.#Attributes.fileField#" destination="#gettempdirectory()#" nameConflict="overwrite">
	</cfif>
	<cfif attributes.foto>
		<cfimage source="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" action="resize" width="80"  height="100" destination="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" overwrite="yes">	
	</cfif>
		
	<!--- lee la imagen de la carpeta del servidor y la almacena en la variable tmp --->
	<cffile action="readbinary" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" variable="tmp" >
	<cffile action="delete" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" >
	<cfif Attributes.queryparam>
		<!--- poner el queryparam --->
		<cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#">
	</cfif>
	<cfset dbupload_ret.contents = tmp>
	<cfset dbupload_ret.filename = cffile.clientfile>
</cfif>
<cfset Caller[Attributes.returnvariable] = dbupload_ret>


