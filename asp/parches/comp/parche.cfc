<cfcomponent output="no">
	<cffunction name="add_entry" access="public" output="false" returntype="void">
		<cfargument name="collection" type="string" required="yes">
		<cfargument name="mapkey" type="string" required="yes">
		
		<cfset ret = StructNew()>
		<cfloop list="#StructKeyList(Arguments)#" index="argname">
			<cfif StructKeyExists(Arguments,argname)>
				<cfset StructInsert(ret, argname, Arguments[argname], true)>
			</cfif>
		</cfloop>
		<cfset StructDelete(ret, 'collection')>
		<cfset StructInsert(session.parche[collection], Arguments.mapkey, ret, true)>
	</cffunction>

	<cffunction name="get_entries" returntype="struct">
		<cfargument name="collection" type="string" required="yes">
		
		<cfreturn session.parche[collection]>
	</cffunction>

	<cffunction name="remove_entry" returntype="void">
		<cfargument name="collection" type="string" required="yes">
		<cfargument name="mapkey" type="string" required="yes">
		<cfset StructDelete(session.parche[collection], Arguments.mapkey)>
	</cffunction>
	
	<cffunction name="dirparches" returntype="string">
		<cfreturn ExpandPath("/Mis Parches/")>
	</cffunction>
	
		<!--- crea un directorio para el parche, y regresa la ruta completa
		del directorio, excluyendo el '/' del final --->
	<cffunction name="mkdirparche" returntype="string">
		<cfargument name="nombre" required="yes">
		<cfif Not DirectoryExists (dirparches())>
			<cfdirectory action="create" directory="#dirparches()#">
		</cfif>
		<cfset dirparche = dirparches() & nombre>
		<cfif Not DirectoryExists (dirparche)>
			<cfdirectory action="create" directory="#dirparche#">
		</cfif>
		<cfreturn dirparche>
	</cffunction>
	
	<cffunction name="add_hash" output="false">
		<cfargument name="file">
		<cfargument name="destPath">
		<cfargument name="checksum_name">
		<cfargument name="checksum_md5">
		<cfargument name="checksum_sha1">
		
		<cfinvoke component="path" method="concat"
			dir="#destPath#" file="#file#"
			returnvariable="destFullFile"/>
			
		<cfset md5sum = calc_hash(destFullFile, 'MD5')>
		<cfset sha1sum = calc_hash(destFullFile, 'SHA1')>
		<cfif Len(md5sum)>
			<cffile action="append" file="#checksum_md5#" output="#md5sum# *#checksum_name#">
		</cfif>
		<cfif Len(sha1sum)>
			<cffile action="append" file="#checksum_sha1#" output="#sha1sum# *#checksum_name#">
		</cfif>
		<cfif Len(md5sum) or Len(sha1sum)>
			<cfquery datasource="asp">
				update APFuente
				set checksum = <cfqueryparam cfsqltype="cf_sql_varchar" value="MD5:#md5sum#;SHA1:#sha1sum#">
				where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
				and nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file#">
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="calc_hash" returntype="string" output="false">
		<!--- No se usa la funcion Hash de coldfusion porque al leer el archivo en string, 
			que es requerido por Hash con cffile se pierde el BOM y detalles de la codificacion --->
		<cfargument name="file" type="string">
		<cfargument name="algorithm" type="string">
		
		<cfif FileExists (Arguments.file)>
			<cffile action="readbinary" file="#arguments.file#" variable="filecontents">
			<cfreturn calc_hash_binary(filecontents, algorithm)>
		<cfelse>
			<cfreturn ''>
		</cfif>
	</cffunction>


	<cffunction name="calc_hash_binary" returntype="string" output="false">
		<!--- No se usa la funcion Hash de coldfusion porque al leer el archivo en string, 
			que es requerido por Hash con cffile se pierde el BOM y detalles de la codificacion --->
		<cfargument name="filecontents" type="binary">
		<cfargument name="algorithm" type="string">
		
		<cfset md = CreateObject("java", "java.security.MessageDigest").getInstance(Arguments.algorithm)>
	
		<cfset md.update(filecontents, 0, ArrayLen(Arguments.filecontents))>
		<!---
		
		Este codigo de abajo sí funciona pero puede ser menos eficiente en velocidad, pero más en espacio
		Debería utilizarse para archivos grandes
		
		<cfset f = CreateObject("java", "java.io.FileInputStream").init(Arguments.file)>
		<cfset buffer = ToBinary( RepeatString('A', 4096) )>
		<cfset b_read = f.read(buffer)>
		<cfloop condition="b_read GT 0">
			<cfset md.update(buffer, 0, b_read)>
			<cfset b_read = f.read(buffer)>
		</cfloop>
		<cfset f.close()>
		--->
		<cfreturn LCase( BinaryEncode(md.digest(),'Hex') )>
	</cffunction>
	
	<cffunction name="get_xml_atts_from_query" returntype="string" output="false">
		<cfargument name="struc" type="query">
		<cfargument name="keyList" type="string" default="#LCase(StructKeyList(Arguments.struc))#">
		<cfset ret = ''>
		<cfloop list="#keyList#" index="keyEntry">
			<cfset keyname = ListFirst(keyEntry,':')>
			<cfset keytype = ListRest(keyEntry,':')>
			<cfif StructKeyExists(struc,keyname)>
				<cfset ret = ret & Chr(13) & ' ' & keyname & '="'  >
				<cfset value = Evaluate("struc.#keyname#")>
				<cfif keytype is 'date'>
					<cfset ret = ret & DateFormat(value, 'yyyy-mm-dd') & 'T' & TimeFormat(value, 'HH:mm:ss') & 'Z' >
				<cfelseif keytype is 'boolean'>
					<cfif value>
						<cfset ret = ret & 'true' >
					<cfelse>
						<cfset ret = ret & 'false' >
					</cfif>
				<cfelse>
					<cfset ret = ret & XMLFormat( value ) >
				</cfif>
				<cfset ret = ret & '"' >
			</cfif>
		</cfloop>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="get_xml_atts" returntype="string" output="false">
		<cfargument name="struc" type="struct">
		<cfargument name="keyList" type="string" default="#LCase(StructKeyList(Arguments.struc))#">
		<cfset ret = ''>
		<cfloop list="#keyList#" index="keyEntry">
			<cfset keyname = ListFirst(keyEntry,':')>
			<cfset keytype = ListRest(keyEntry,':')>
			<cfif StructKeyExists(struc,keyname)>
				<cfset ret = ret & Chr(13) & ' ' & keyname & '="'  >
				<cfset value = struc[keyname]>
				<cfif keytype is 'date'>
					<cfset ret = ret & DateFormat(value, 'yyyy-mm-dd') & 'T' & TimeFormat(value, 'HH:mm:ss') & 'Z' >
				<cfelseif keytype is 'boolean'>
					<cfif value>
						<cfset ret = ret & 'true' >
					<cfelse>
						<cfset ret = ret & 'false' >
					</cfif>
				<cfelse>
					<cfset ret = ret & XMLFormat(value) >
				</cfif>
				<cfset ret = ret & '"' >
			</cfif>
		</cfloop>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="get_xml" returntype="string" output="false">
		<cfoutput>
		<cfsavecontent variable="ret"><?xml version="1.0" encoding="utf-8"?>
<parche #get_xml_atts(session.parche.info,'nombre,creado,autor,pdir,pnum,psec,psub,svnrev,modulo,vistas')# >
<cfquery datasource="asp" name="items">
	select nombre,revision,autor,fecha,msg,checksum
	from APFuente
	where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
</cfquery>
<cfloop query="items">
<archivo_fuente  #get_xml_atts_from_query(items,'nombre,revision,autor,fecha:date,msg,checksum')#  />
</cfloop>
<cfloop collection="#session.parche.tabla#" item="n">
<tabla  #get_xml_atts(session.parche.tabla[n],'mapkey,nombre,esquema,contar:boolean,crdate:date')# >
<cfloop collection="#session.parche.tabla[n].columna#" item="m">
<columna #get_xml_atts(session.parche.tabla[n].columna[m],'mapkey,nombre,tipo,nulos:boolean,longitud,decimales')# />
</cfloop>
<cfloop collection="#session.parche.tabla[n].indice#" item="m">
<indice #get_xml_atts(session.parche.tabla[n].indice[m],'mapkey,nombre,unico:boolean,agrupado:boolean')# >
<cfloop collection="#session.parche.tabla[n].indice[m].columna#" item="p">
<columna #get_xml_atts(session.parche.tabla[n].indice[m].columna[p],'mapkey,posicion,columna')# />
</cfloop>
</indice>
</cfloop>
</tabla>
</cfloop>
<cfloop collection="#session.parche.procedimiento#" item="n">
<procedimiento  #get_xml_atts(session.parche.procedimiento[n],'mapkey,nombre,dbms,esquema,crdate:date,checksum')#  />
</cfloop>
<cfloop collection="#session.parche.importar#" item="n">
<importacion  #get_xml_atts(session.parche.importar[n],'mapkey,EIcodigo,EIdescripcion,EImodulo,checksum')#  />
</cfloop>
<cfquery datasource="asp" name="items">
	select nombre,dbms,esquema,secuencia,longitud,checksum
	from APParcheSQL
	where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
</cfquery>
<cfloop query="items">
<archivo_sql  #get_xml_atts_from_query(items,'nombre,dbms,esquema,secuencia,longitud,checksum')#  />
</cfloop>
</parche></cfsavecontent>
		</cfoutput>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="guardar">
		<cfparam name="session.parche.guid" default="">
		
		<cfif Len(session.parche.guid)>
			<!--- Asegurarme de que exista en la base de datos, si no lo voy a tener que insertar con un guid nuevo --->
			<cfquery datasource="asp" name="existe">
				select parche from APParche
				where parche = <cfqueryparam cfsqltype="cf_sql_char" value="#session.parche.guid#">
			</cfquery>
			<cfif existe.RecordCount EQ 0>
				<cfset session.parche.guid = ''>
			</cfif>
		</cfif>		      

        
		<cfif Len(session.parche.guid)>
			<cfquery datasource="asp">
				update APParche
				set nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.nombre#">,
					modificado = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					autor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.autor#">,
					pdir = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.pdir#">,
					pnum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.pnum#">,
					psec = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.psec#">,
					psub = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.psub#">,
					descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.descripcion#">,
					instrucciones= <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.instrucciones#">,
                    svnrev =
						<cfif isdefined('session.parche.info.svnrev') and len(trim(session.parche.info.svnrev)) and isnumeric(session.parche.info.svnrev)>
                             <cfqueryparam cfsqltype="cf_sql_integer" value="#session.parche.info.svnrev#">,
                        <cfelse>
                            null,
                        </cfif>
					modulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.modulo#">,
					vistas = <cfqueryparam cfsqltype="cf_sql_bit" value="#session.parche.info.vistas#">,
					xml = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#get_xml()#">
				where parche = <cfqueryparam cfsqltype="cf_sql_char" value="#session.parche.guid#">
			</cfquery>
		<cfelse>
			<cfinvoke component="misc" method="new_guid" returnvariable="newguid"/>
            <cfquery datasource="asp" name="existe">
				select count(1) as existe from APParche
				where 
                      pnum = <cfqueryparam cfsqltype="cf_sql_char" value="#session.parche.info.pnum#"> and 
                      psec = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.psec#">
			</cfquery>
			<cfif existe.existe gt 0 >
				<cfthrow message="El número de parche y secuencia ya existen! Proceso cancelado! ">
			</cfif>
            
			<cfquery datasource="asp">
				insert into APParche (
					parche, nombre, creado, modificado, autor,
					pdir, pnum, psec, psub, svnrev,
					entregado, cerrado, modulo, vistas, xml)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#newguid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.nombre#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					null,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.autor#">,
		
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.pdir#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.pnum#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.psec#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.psub#">,
                    <cfif isdefined('session.parche.info.svnrev') and len(trim(session.parche.info.svnrev))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.parche.info.svnrev#">,
                    <cfelse>
                    	null,
                    </cfif>
		
					null,
					null,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.info.modulo#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#session.parche.info.vistas#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#get_xml()#">)
			</cfquery>
			<cfset session.parche.guid = newguid>
		</cfif>
	</cffunction>
	
	<cffunction name="olvidar_parche">
		<cfloop list="#StructKeyList(session.parche)#" index="item">
			<cfif Not ListFindNoCase('svnuser,svnpasswd,form_format', item)>
				<cfset StructDelete(session.parche, item)>
			</cfif>
		</cfloop>
		<cfset parametros_parche()>
	</cffunction>
	
	<cffunction name="parametros_parche">
		<cfparam name="session.parche.form_format" default="html">
		<cfparam name="session.parche.tabla" default="#StructNew()#" type="struct">
		<cfparam name="session.parche.procedimiento" default="#StructNew()#" type="struct">
		<cfparam name="session.parche.importar" default="#StructNew()#" type="struct">
		<cfparam name="session.parche.errores" default="#ArrayNew(1)#" type="array">
		<cfparam name="session.parche.svnuser" default="">
		<cfparam name="session.parche.svnpasswd" default="">
		<cfparam name="session.parche.svnBranch" default="">
		<cfparam name="session.parche.generado" default="false">
		<cfparam name="session.parche.cant_seg" default="0">
		<cfparam name="session.parche.cant_sql" default="0">
		<cfparam name="session.parche.cant_dbm" default="0">
		<cfparam name="session.parche.cant_fuentes" default="0">
		<cfparam name="session.parche.guid" default="">
		<!---***********************************--->
		<cfparam name="session.parche.cant_menus" default="0">
		<!---***********************************--->
		
		<cfparam name="session.parche.info.pdir" default="">
		<cfparam name="session.parche.info.pnum" default="">
		<cfparam name="session.parche.info.psec" default="">
		<cfparam name="session.parche.info.psub" default="">
		<cfparam name="session.parche.info.modulo" default=""> 
		<cfparam name="session.parche.info.nombre" default="">
		<cfparam name="session.parche.info.autor" default="">
		<cfparam name="session.parche.info.vistas" default="true" type="boolean">
		<cfparam name="session.parche.info.svnrev" default="0">
		<cfparam name="session.parche.info.descripcion" default="">
		<cfparam name="session.parche.info.instrucciones" default="">
		
		<cfif Not IsDefined('session.parche.reposURL') or Not IsDefined('session.parche.svnBranch')>
		<cfinvoke component="svnclient" method="get_info" wc="#ExpandPath('/')#" returnvariable="svninfo" />
		<cfset session.parche.reposURL = svninfo.URL>
		<cfset session.parche.svnBranch = ListLast(session.parche.reposURL, '/')>
		<cfset session.parche.reposURL = Mid(session.parche.reposURL, 1, Len(session.parche.reposURL) - Len(session.parche.svnBranch))>
		</cfif>
	</cffunction>
	
	<cffunction name="cargar_arreglo_xml">
		<cfargument name="collectionname" type="string">
		<cfargument name="collection" type="struct">
		<cfargument name="arreglo" type="xml">
		<cfargument name="keys" type="string">
	<!--- Falta parse Date y parse boolean --->
	
		<cfset mydateformat = CreateObject("java", "java.text.SimpleDateFormat")>
		<cfset mydateformat.init("yyyy-MM-dd'T'HH:mm:ss")>
	
		<cfloop from="1" to="#ArrayLen(arreglo)#" index="i">
			<cfset NewEntry = StructNew()>
			<cfloop list="#keys#" index="keyitem">
				<cfset key = ListFirst(keyitem,':')>
				<cfset type = ListRest(keyitem,':')>
				<cfif StructKeyExists(arreglo[i].XmlAttributes, key)>
					<cfif type is 'date'>
						<cfset NewEntry[key] = mydateformat.parse(arreglo[i].XmlAttributes[key])>
					<cfelseif type is 'boolean'>
						<cfset NewEntry[key] = arreglo[i].XmlAttributes[key] EQ 'true'>
					<cfelse>
						<cfset NewEntry[key] = arreglo[i].XmlAttributes[key]>
					</cfif>
				<cfelse>
					<cfif type is 'date'>
						<cfset NewEntry[key] = Now()>
					<cfelseif type is 'boolean'>
						<cfset NewEntry[key] = true>
					<cfelse>
						<cfset NewEntry[key] = ''>
					</cfif>
					<cfset str = StructNew()>
					<cfset str.msg = "La entrada #key# no existe">
					<cfset str.archivo = "#collectionname# ###i#">
					<cfset ArrayAppend(session.parche.errores, str)>
				</cfif>
			</cfloop>
			<cfset collection[NewEntry.mapkey] = NewEntry>
		</cfloop>
	</cffunction>

	<cffunction name="agregar_seguridad" output="false">
		<cfargument name="mapkey" type="string" required="yes">
		<cfargument name="SScodigo" type="string" required="yes">
		<cfargument name="SMcodigo" type="string" required="yes">
		<cfargument name="SSdescripcion" type="string" required="yes">
		<cfargument name="SMdescripcion" type="string" required="yes">
		
		<cfloop list="db2,ora,syb,mss" index="dbms">
			<cfset form.tipo = 'sql'><!--- sql/xml --->
			<cfif Arguments.SScodigo EQ '*'>
				<cfset form.rango = 't'>
			<cfelseif Arguments.SMcodigo EQ '*'>
				<cfset form.rango = 's'>
			<cfelse>
				<cfset form.rango = 'm'>
			</cfif>
			<cfset form.SScodigo = Arguments.SScodigo>
			<cfset form.SMcodigo = Arguments.SScodigo & ',' & Arguments.SMcodigo>
			
			<cfset form.dbms = '#dbms#'>
			<cfset form.included = 1>
			<cfset start_time = GetTickCount()>
			<cfinvoke component="asp.parches.comp.misc" method="dbms2dbmsdir"
				dbms="#dbms#" returnvariable="dbmsdir"/>
			<cfsavecontent variable="exportar_contents"><cfinclude
				template="/asp/portal/exportar/exportar-apply.cfm"></cfsavecontent>
			<cfset binary_contents = CharsetDecode( exportar_contents, 'iso-8859-1' )>
			<cfinvoke component="#This#" method="agregar_sql"
				dbms="#dbms#"
				esquema="ASP"
				contenido="# binary_contents #"
				descripcion="Seguridad para #Arguments.SSdescripcion# - #Arguments.SMdescripcion#"
				nombre="framework-# LCase( Arguments.mapkey ) #.sql" />
		</cfloop>
	</cffunction>
	
	<cffunction name="agregar_sql">
		<cfargument name="dbms" type="string" required="yes">
		<cfargument name="esquema" type="string" required="yes">
		<cfargument name="filefield" type="string" required="no">
		<cfargument name="contenido" type="binary" required="no">
		<cfargument name="nombre" type="string" required="no">
		<cfargument name="descripcion" type="string" required="yes">
		
		<cfif Len(session.parche.guid) EQ 0>
			<cfset This.guardar()>
		</cfif>
		
		<cfquery datasource="asp" name="sigte">
			select coalesce (max (archivo), 0) + 1 as sigte,
				coalesce (max (secuencia), 0) + 1 as sig_secuencia
			from APParcheSQL
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		</cfquery>
		<cfset secuencia = sigte.sig_secuencia>
		
		<cfquery datasource="asp">
			insert into APParcheSQL (
				parche, archivo, dbms, esquema, secuencia, descripcion,
				contenido, checksum, longitud, nombre)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#sigte.sigte#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.dbms#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.esquema#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#secuencia#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Arguments.descripcion, 255)#">,
				<cfif IsDefined('Arguments.filefield')>
					<cf_dbupload filefield="#Arguments.filefield#" accept="*/*" datasource="asp">,
					<cfset Arguments.nombre = dbupload.filename>
					<cfset Arguments.contenido = dbupload.contents>
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_blob" value="#Arguments.contenido#">,
				</cfif>
				<cfset checksum = This.calc_hash_binary(Arguments.contenido,'MD5')>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#checksum#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Len(Arguments.contenido)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nombre#">
		)
		</cfquery>
		
		<cfset mapkey = Arguments.dbms & '/' & Arguments.esquema & '/' & Arguments.nombre>
	</cffunction>

	<cffunction name="contar">
	
		<cfquery datasource="asp" name="cantidad">
			select count(1) as cantidad
			from APFuente
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		</cfquery>
		<cfset session.parche.cant_fuentes = cantidad.cantidad>
		
		<cfquery datasource="asp" name="cantidad">
			select count(1) as cantidad
			from APParcheSQL
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		</cfquery>
		<cfset session.parche.cant_sql = cantidad.cantidad>
		
		<cfquery datasource="asp" name="cantidad">
			select count(1) as cantidad
			from APParcheSQL
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
			  and nombre like <cfqueryparam cfsqltype="cf_sql_varchar" value="%framework-%.sql%">
		</cfquery>
		<cfset session.parche.cant_seg = cantidad.cantidad>

		<cfquery datasource="asp" name="cantidad">
			select count(1) as cantidad
			  from DBMversiones
			 where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		</cfquery>
		<cfset session.parche.cant_dbm = cantidad.cantidad>

		<cfquery datasource="asp" name="cantidad">
			select count(1) as cantidad
			from APOpciones
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		</cfquery>
		<cfset session.parche.cant_menus = cantidad.cantidad>
	
	</cffunction>
	<!----************************************--->
	<cffunction name="agregar_opciones" hint="Inserta en APOpciones (Opciones de menu nuevas y modificadas)" returntype="string">
		<cfargument name="tipo" type="string" required="yes">
		<cfargument name="SScodigo" type="string" required="yes">
		<cfargument name="SMcodigo" type="string" required="yes">
		<cfargument name="SMNcodigo" type="numeric" required="no" default="-1">
		<cfargument name="detalle" type="string" required="no">

		<cfset mensaje = ''>
		<cfquery name="rsVerifica" datasource="asp">
			select count(1) as cantidad from APOpciones
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
				and SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SScodigo#">
				and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SMcodigo#">
				<cfif isdefined("arguments.SMNcodigo") and len(trim(arguments.SMNcodigo)) and arguments.SMNcodigo NEQ -1>
					and SMNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SMNcodigo#">
				</cfif>
		</cfquery>
		<cfif rsVerifica.RecordCount NEQ 0 and rsVerifica.cantidad EQ 0>
			<cfquery datasource="asp">
				insert APOpciones (parche, tipo, SScodigo, SMcodigo, SMNcodigo, detalle)
				values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tipo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SScodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SMcodigo#">,
						<cfif isdefined("arguments.SMNcodigo") and len(trim(arguments.SMNcodigo)) and arguments.SMNcodigo NEQ -1>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SMNcodigo#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined("arguments.detalle") and len(trim(arguments.detalle))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detalle#">
						<cfelse>
							null
						</cfif>)	
			</cfquery>
		<cfelse>
			<cfset mensaje = 'El modulo/opcion ya habia sido agregado'>
		</cfif>		
		<cfquery name="rsCantidad" datasource="asp">
			select coalesce(count(1),0) as cantidad from APOpciones
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		</cfquery>
		<cfset session.parche.cant_menus = rsCantidad.cantidad>
		<cfreturn mensaje>
	</cffunction>
	
	<cffunction name="quitar_opciones" hint="Elimina de APOpciones (Opciones de menu nuevas y modificadas)">
		<cfargument name="SScodigo" type="string" required="yes">
		<cfargument name="SMcodigo" type="string" required="yes">
		<cfargument name="SMNcodigo" type="numeric" required="no" default="-1">
		
		<cfquery datasource="asp">
			delete from APOpciones
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
				and SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SScodigo#">
				and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SMcodigo#">
				<cfif isdefined("arguments.SMNcodigo") and len(trim(arguments.SMNcodigo)) and arguments.SMNcodigo NEQ -1>
					and SMNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SMNcodigo#">
				</cfif>
		</cfquery>	
		<cfquery name="rsCantidad" datasource="asp">
			select coalesce(count(1),0) as cantidad from APOpciones
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		</cfquery>
		<cfset session.parche.cant_menus = rsCantidad.cantidad>
		
	</cffunction>
	

</cfcomponent>
