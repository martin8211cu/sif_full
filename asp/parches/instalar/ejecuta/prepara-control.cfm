<cfif Len(session.instala.instalacion) EQ 0>
	<cfinvoke component="asp.parches.comp.instala" method="guardar"/>
</cfif>

<cfquery datasource="asp" name="APParche">
	select xml
	from APParche
	where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.parche#">
</cfquery>

<cfquery datasource="asp">
	delete
	from APTareas
	where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
</cfquery>

<cfset elems = XMLSearch(APParche.xml, '//archivo_sql[@dbms="' & session.instala.dbms & '"]')>

<cfset mystruct = StructNew()>
<cfloop from="1" to="#ArrayLen(elems)#" index="i">
	<cfset new_entry = StructNew()>
	<cfset new_entry.esquema = elems[i].XmlAttributes.esquema>
	<cfset new_entry.dbms = elems[i].XmlAttributes.dbms>
	<cfset new_entry.nombre = elems[i].XmlAttributes.nombre>
	<cfset new_entry.secuencia = elems[i].XmlAttributes.secuencia>
	<cfset mystruct[i] = new_entry>
</cfloop>
<cfset elems = ''>

<cfinvoke component="asp.parches.comp.instala" method="nueva_tarea"
	tipo="tst" datasource="Verificar integridad de parche"/>

<cfinvoke component="asp.parches.comp.instala" method="nueva_tarea"
	tipo="cn1" datasource="Conteo previo de datos"/>
	
<cfloop list="# ArrayToList(StructSort( mystruct, 'Numeric', 'asc', 'secuencia')) #" index="i">
		<cfset esquema = mystruct[i].esquema>
		<cfset dbms = mystruct[i].dbms>
		<cfset nombre = mystruct[i].nombre>
	
		<cfinvoke component="asp.parches.comp.misc" method="esquema2dslist"
			esquema="#esquema#"
			returnvariable="dslist" />
		<cfloop list="#dslist#" index="ds">
			<cfinvoke component="asp.parches.comp.instala" method="nueva_tarea"
				tipo="sql"
				datasource="#ds#"
				ruta="#nombre#" />
		</cfloop>
</cfloop>

<cfset elems = XMLSearch(APParche.xml, '//importacion')>
<cfif ArrayLen(elems)>
	<cfinvoke component="asp.parches.comp.misc" method="esquema2dslist"
		esquema="CNT"
		returnvariable="dslist" />
	<cfloop list="#dslist#" index="ds">
		<cfinvoke component="asp.parches.comp.instala" method="nueva_tarea"
			tipo="imp"
			datasource="#ds#"
			ruta="importador.xml" />
	</cfloop>
</cfif>


<cfset elems = XMLSearch(APParche.xml, '//archivo_fuente/@nombre')>
<cfif ArrayLen(elems)>
	<cfset mystruct = StructNew()>
	<cfloop from="1" to="#ArrayLen(elems)#" index="i">
		<cfset dirname = ListFirst(elems[i].XmlValue, '/\')>
		<cfif StructKeyExists(mystruct, dirname)>
			<cfset mystruct[dirname] = mystruct[dirname] + 1>
		<cfelse>
			<cfset mystruct[dirname] = 1>
		</cfif>
	</cfloop>
	
	<cfloop list="#ListSort (StructKeyList( mystruct ), 'textnocase', 'asc' )#" index="dirname">
		<cfinvoke component="asp.parches.comp.instala" method="nueva_tarea"
			tipo="cpy"
			datasource="#mystruct[dirname]# archivos"
			ruta="#dirname#" />
	</cfloop>
</cfif>

<cfinvoke component="asp.parches.comp.instala" method="nueva_tarea"
	tipo="chk" datasource="Validar checksum de archivos" />
<cfinvoke component="asp.parches.comp.instala" method="nueva_tarea"
	tipo="tbl" datasource="Validar estructura de tablas" />
<cfinvoke component="asp.parches.comp.instala" method="nueva_tarea"
	tipo="cn2" datasource="Validar conteo de datos" />

<cfinvoke component="asp.parches.comp.instala" method="nueva_tarea"
	tipo="msg" datasource="Notificar instalación" />

<cfset session.instala.preparado = 1>

<cflocation url="ejecuta.cfm">