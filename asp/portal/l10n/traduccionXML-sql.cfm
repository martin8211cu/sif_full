<cfif isdefined("form.Iid") and len(trim(form.Iid))>
	<cfset session.IdiomaXml = form.Iid>
</cfif>

<!--- Separador --->
<cfset separador = CreateObject("java","java.lang.System").getProperty("file.separator")>

<cfif isdefined("form.Guardar") or ( isdefined("form.quieremodificar") and  form.quieremodificar eq 1 )>
	<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="translate">
	<cfif len(trim(form._Iid)) EQ 0>
		<cfset form._Iid = Form.Iid>
	</cfif>
	<cfquery datasource="sifcontrol" name="idiomas">
		select Iid,Icodigo,Descripcion,Icodigo as locale_lang
		from Idiomas
		where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form._Iid#">
	</cfquery>
	<cfset idioma = trim(idiomas.Icodigo) >
	
	<cfif len(trim(idioma)) gt 6 >
		<cfset p = separador & form.p >
		<cfset path = expandpath(p) >
	<cfelse>
		<cfset path = expandpath(form.p) >
	</cfif>
	
	
	<!--- crea el directorio si no existe --->
	<cfif not directoryexists(path)>
		<cfdirectory directory="#path#" action="create" >
	</cfif>

	<cfloop from="1" to="#form.total#" index="i">
		<cfset name = trim(path)&separador&trim(form['name_#i#']) >
		<cfif fileexists(name) >
			<cftry>
				<cfset f = translate.OpenXML(name) >
			<cfcatch type="any">
				<cfthrow message="Error abriendo archivo #trim(form['name_#i#'])#. El archivo indicado no tiene un formato v&aacute;lido XML.">
			</cfcatch>
			</cftry>
		<cfelse>
			<cfset f = translate.newXML() >
		</cfif>

		<cfif isdefined("form.total_datos_#i#")>
			<cfset hasta = form['total_datos_#i#'] >
			<cfloop from="1" to="#hasta#" index="j">
				<cfset translate.updateXML(f, idioma, trim(form['key_#i#_#j#']), trim(form['texto_#i#_#j#']) ) >
			</cfloop>
			
			<cftry>
				<cfset translate.saveXML(name, f) >
			<cfcatch type="any">
				<cfthrow message="Error. No existe la estructura de directorios #mid(p,2,len(p))# para el archivo #trim(form['name_#i#'])#">
			</cfcatch>
			</cftry>

		</cfif>
	</cfloop>
	
	<cfquery datasource="sifcontrol">
		delete from VSnuevo
			where ruta like '#p#/%' 
				and ruta not like '#p#/%/%'
	</cfquery>
	
	<cflocation url="traduccionXML.cfm?p=#form._p#&Iid=#form.Iid#&archivo=#form.archivo#">
<cfelseif isdefined("form.quieremodificar") and form.quieremodificar eq 0 >
	<cflocation url="traduccionXML.cfm?p=#form._p#&Iid=#form.Iid#&archivo=#form.archivo#">
<cfelse>
	<cflocation url="/cfmx/home/menu/modulo.cfm?s=sys&m=apps">
</cfif>