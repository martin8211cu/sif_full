<cfinvoke component="asp.parches.comp.misc" method="esquema2sourceds"
	esquema="#form.esquema#" returnvariable="mydatasource"/>
<cfif ListLen(form.nombre) EQ 0>
	<cfset form.nombre = '*'>
</cfif>
<cfloop list="#form.nombre#" index="el_nombre">
  <cftry>
	<cfset nombre_like = el_nombre>
	<cfset nombre_like = Replace(nombre_like, '*', '%')>
	<cfset nombre_like = Replace(nombre_like, '?', '_')>
	<cfquery datasource="#mydatasource#" name="objetos" maxrows="100">
		select id, type, name, crdate
		from sysobjects
		where crdate > <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.crdesde)#">
		  and upper(name) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%# UCase( nombre_like )#%">
		  and type in ('U', 'P', 'TR')
		  <!--- Eliminar los objetos internos del sistema --->
		  and name not like 'tm[0-9][0-9]%'
		  and name not like 'bitins[_]%'
		  and name not like 'bitupd[_]%'
		  and name not like 'bitdel[_]%'
		  and name not like 'tmp[_]%'
	</cfquery>

    <cfloop query="objetos">
		<cfif Trim(objetos.type) EQ 'U'>
			<!---
				hay que cambiarlo por un query que regrese el contenido del objeto, y que regrese el mismo
				resultado en SYBASE, ORACLE y DB2.
				Este mismo query se debe invocar en el proceso de validación, así que debe ser uniforme.
			--->
			<cfinvoke component="asp.parches.comp.dbmetadata" method="get_table"
				datasource="#mydatasource#"
				objname="#objetos.name#"
				returnvariable="metadata" />
			<cfinvoke component="asp.parches.comp.parche"
				method="add_entry" collection="tabla"
				mapkey="#form.esquema#.#objetos.name#"
				nombre="#objetos.name#"
				esquema="#form.esquema#"
				contar="true" 
				crdate="#objetos.crdate#"
				columna="#metadata.columna#"
				indice="#metadata.indice#"/>
		<cfelse>
			<cfinvoke component="asp.parches.comp.parche"
				method="add_entry" collection="procedimiento"
				mapkey="syb.#form.esquema#.#objetos.name#"
				nombre="#objetos.name#"
				dbms="syb" 
				esquema="#form.esquema#"
				crdate="#objetos.crdate#"
				checksum="" />
		</cfif>
    </cfloop>
    <cfcatch type="any">
      <cfset str = StructNew()>
      <cfset str.msg = cfcatch.Message & ' ' & cfcatch.Detail>
      <cfset str.archivo = #el_nombre#>
      <cfset ArrayAppend(session.parche.errores, str)>
    </cfcatch>
  </cftry>
</cfloop>
<cflocation url="objconfirmar.cfm">
