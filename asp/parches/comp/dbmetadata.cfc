<cfcomponent>

	<cffunction name="get_table" access="public" returntype="struct" output="false">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="objname" type="string" required="yes">
		
		<cfset ret = StructNew()>
		<cfset ret.columna = StructNew()>
		<cfset ret.indice = StructNew()>
		
		<cfset dbms = Application.dsinfo[datasource].type>
		
		<cfif dbms is 'sybase'>
			<cftry>
				<cfquery datasource="#datasource#" name="cols_query">
					select
						c.name as column_name, t.name as typename, 
						convert (bit, (c.status & 8)) as nulos,
						coalesce (c.prec, c.length, 0) as longitud,
						coalesce (c.scale, 0) as decimales
					from sysobjects o
						join syscolumns c
							on c.id = o.id
						join systypes t
							on c.usertype = t.usertype
					where o.type = 'U'
					  and o.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#objname#">
					order by o.name, c.name
				</cfquery>
				<cfquery datasource="#datasource#" name="index_query">
					exec sp_helpindex <cfqueryparam cfsqltype="cf_sql_varchar" value="#objname#">
				</cfquery>
			<cfcatch type="any">
			</cfcatch>
			</cftry>
		<cfelse>
			<cfthrow message="DBMS no soportado: #dbms#">
		</cfif>
		<cfif IsDefined('cols_query')>
			<cfloop query="cols_query">
				<cfset ThisItem = StructNew()>
				<cfset ThisItem.mapkey = Trim(column_name)>
				<cfset ThisItem.nombre = Trim(column_name)>
				<cfset ThisItem.tipo = Trim(typename)>
				<cfset ThisItem.nulos = nulos>
				<cfset ThisItem.longitud = longitud>
				<cfset ThisItem.decimales = decimales>
				<cfset ret.columna[ThisItem.mapkey] = ThisItem>
			</cfloop>
		</cfif>
		<cfif IsDefined('index_query')>
			<!--- sp_helpindex no regresa resultset si no hay indices --->
			<cfloop query="index_query">
				<cfset ThisItem = StructNew()>
				<cfset ThisItem.mapkey = Trim(index_name)>
				<cfset ThisItem.nombre = Trim(index_name)>
				<cfset ThisItem.unico = FindNoCase(index_description, 'unique') NEQ 0>
				<cfset ThisItem.agrupado = FindNoCase(index_description, 'nonclustered') EQ 0>
				<cfset ThisItem.columna = StructNew()>
				<cfloop from="1" to="#ListLen(index_keys)#" index="i">
					<cfset ThisSubItem = StructNew()>
					<cfset ThisSubItem.mapkey = i>
					<cfset ThisSubItem.posicion = i>
					<cfset ThisSubItem.columna = Trim(ListGetAt( index_keys, i))>
					<cfset ThisItem.columna[ThisSubItem.mapkey] = ThisSubItem>
				</cfloop>
				<cfset ret.indice[ThisItem.mapkey] = ThisItem>
			</cfloop>
		</cfif>
 		<cfreturn ret>
	</cffunction>
	
	<cffunction name="get_table_from_xml" access="public" output="false" hint="Lee un XML y lo pone en un formato comparable con get_table()">
		<cfargument name="tabla">
		
		<cfset xmlmd = StructNew()>
		<cfset xmlmd.columna = StructNew()>
		<cfset xmlmd.indice = StructNew()>
		<cfloop from="1" to="#ArrayLen(Arguments.tabla.columna)#" index="i">
			<cfset elem = Arguments.tabla.columna[i]>
			<cfset ThisItem = StructNew()>
			<cfset ThisItem.mapkey = Trim(elem.XmlAttributes.mapkey)>
			<cfset ThisItem.nombre = Trim(elem.XmlAttributes.nombre)>
			<cfset ThisItem.tipo = Trim(elem.XmlAttributes.tipo)>
			<cfset ThisItem.nulos = elem.XmlAttributes.nulos>
			<cfset ThisItem.longitud = elem.XmlAttributes.longitud>
			<cfset ThisItem.decimales = elem.XmlAttributes.decimales>
			<cfset xmlmd.columna[ThisItem.mapkey] = ThisItem>
		</cfloop>
		<cfif IsDefined('Arguments.tabla.indice')>
			<cfloop from="1" to="#ArrayLen(Arguments.tabla.indice)#" index="i">
				<cfset elem = Arguments.tabla.indice[i]>
				<cfset ThisItem = StructNew()>
				<cfset ThisItem.mapkey = Trim(elem.XmlAttributes.mapkey)>
				<cfset ThisItem.nombre = Trim(elem.XmlAttributes.nombre)>
				<cfset ThisItem.unico = elem.XmlAttributes.unico>
				<cfset ThisItem.agrupado = elem.XmlAttributes.agrupado>
				<cfset ThisItem.columna = StructNew()>
				<cfloop from="1" to="#ArrayLen(elem.columna)#" index="j">
					<cfset elem2 = elem.columna[j]>
					<cfset ThisSubItem = StructNew()>
					<cfset ThisSubItem.mapkey = elem2.XmlAttributes.mapkey>
					<cfset ThisSubItem.posicion = elem2.XmlAttributes.posicion>
					<cfset ThisSubItem.columna = Trim(elem2.XmlAttributes.columna)>
					<cfset ThisItem.columna[ThisSubItem.mapkey] = ThisSubItem>
				</cfloop>
				<cfset xmlmd.indice[ThisItem.mapkey] = ThisItem>
			</cfloop>
		</cfif>
		<cfreturn xmlmd>
	</cffunction>
	
</cfcomponent>