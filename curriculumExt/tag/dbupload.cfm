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
<cfparam name="Attributes.accept"  default="image/*">
<cfparam name="Attributes.datasource" default="">
<cfparam name="Attributes.returnvariable" default="dbupload">
<cfparam name="Attributes.queryparam" default="yes">

<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cfthrow message="Falta el atributo datasource, y session.dsn no est&aacute; definida.">
	</cfif>
</cfif>
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cfthrow message="Datasource no definido: #HTMLEditFormat(Attributes.datasource)#">
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
	<cffile action="Upload" filefield="form.#Attributes.fileField#" 
		destination="#gettempdirectory()#" nameConflict="overwrite" accept="#Attributes.accept#">
		
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
