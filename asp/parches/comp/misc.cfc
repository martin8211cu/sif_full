<cfcomponent>
	
	<cffunction name="new_guid" access="public" returntype="string" output="false" hint="Regresa un GUID sin guiones ni espacios">
		<cfreturn Replace( CreateUUID(), '-', '','all')>
	</cffunction>
	
	<cffunction name="dbms2dbmsdir" access="public" returntype="string" output="false" hint="Obtiene el directorio donde se guardan los archivos para un DBMS">
		<cfargument name="dbms" type="string" required="yes">
		<cfswitch expression="#Arguments.dbms#">
			<cfcase value="db2"><cfreturn "DB2"></cfcase>
			<cfcase value="ora"><cfreturn "Oracle"></cfcase>
			<cfcase value="syb"><cfreturn "Sybase"></cfcase>
			<cfcase value="mss"><cfreturn "SqlServer"></cfcase>
		</cfswitch>
		<cfthrow message="DBMS inválido: #Arguments.dbms#">
	</cffunction>
	
	<cffunction name="esquema2sourceds" access="public" returntype="string" output="false" hint="Obtiene el datasource fuente para generar los parches (desarrollo)">
		<cfargument name="esquema" type="string" required="yes">
		
		<cfquery datasource="asp" name="buscar_esquema">
			select datasource
			from APEsquema
			where esquema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.esquema#">
		</cfquery>
		<cfif buscar_esquema.RecordCount EQ 0>
			<cfthrow message="Esquema inválido: #Arguments.esquema#">
		</cfif>
		<cfreturn buscar_esquema.datasource>
	</cffunction>

	<cffunction name="esquema2dslist" access="public" returntype="string" output="false" hint="Obtiene la lista de datasources para un esquema">
		<cfargument name="esquema" type="string" required="yes">
		
		<cfif Arguments.esquema EQ 'SIF'>
			<cfreturn session.instala.ds>
		<cfelse>
			<cfreturn esquema2sourceds(Arguments.esquema)>
		</cfif>
	</cffunction>
	
	<cffunction name="dsinfotype2dbms" access="public" returntype="string" output="false" hint="Convierte el dsinfo[].type as dbms(char 3)">
		<cfargument name="dsinfotype" type="string" required="yes">
		
		<cfswitch expression="#LCase( Arguments.dsinfotype)#">
			<cfcase value="sqlserver"><cfreturn "mss"></cfcase>
			<cfcase value="sybase"><cfreturn "syb"></cfcase>
			<cfcase value="oracle"><cfreturn "ora"></cfcase>
			<cfcase value="db2"><cfreturn "db2"></cfcase>
		</cfswitch>
		<cfthrow message="Esquema inválido: #Arguments.esquema#">
	</cffunction>
	
	<cffunction name="sev2sevname" access="public" returntype="string" output="false" hint="Obtiene el nombre de la severidad">
		<cfargument name="severidad" type="numeric">
		
		<cfswitch expression="#Arguments.severidad#">
			<cfcase value="-1"><cfreturn "DEBUG"></cfcase>
			<cfcase value="0"><cfreturn "INFO"></cfcase>
			<cfcase value="1"><cfreturn "WARN"></cfcase>
			<cfcase value="2"><cfreturn "ERROR"></cfcase>
		</cfswitch>
		<cfthrow message="Severidad inválida">
	</cffunction>
	
	<cffunction name="struct_compare" access="public" returntype="array" output="false" hint="Compara dos estructuras">
		<cfargument name="a" type="struct" required="yes" hint="Estructura modelo esperada">
		<cfargument name="b" type="struct" required="yes" hint="Estructura que debe ser igual al modelo">
		<cfargument name="name" type="string" required="yes" hint="Nombre de la estructura en comparación">

		<cfset var errores = ArrayNew(1)>
		
		<cfloop collection="#a#" item="ai">
			<cfif Not StructKeyExists(b, ai)>
				<cfset ArrayAppend(errores, 'Falta #name#.#LCase(ai)#')>
			<cfelseif (IsStruct(a[ai]) And StructCount(a[ai])) Neq (IsStruct(b[ai]) And StructCount(b[ai]))>
				<cfset ArrayAppend(errores,'#name#.# LCase(ai) # debía tener #IsStruct(a[ai])#-#StructCount(a[ai])# elementos, y tiene #IsStruct(b[ai])#-#StructCount(b[ai])# elementos')>
			<cfelseif IsStruct(a[ai])>
				<cfset ret2 = struct_compare(a[ai], b[ai], name & '.' & LCase( ai ))>
				<cfloop from="1" to="#ArrayLen(ret2)#" index="i">
					<cfset ArrayAppend(errores, ret2[i])>
				</cfloop>
			<cfelseif a[ai] Neq b[ai]>
				<cfset ArrayAppend(errores,'#name#.# LCase( ai )# debía ser #a[ai]# y es #b[ai]#')>
			</cfif>
		</cfloop>
		
		<cfloop collection="#b#" item="bi">
			<cfif Not StructKeyExists(a, bi)>
				<cfset ArrayAppend(errores, 'Sobra #name#.#LCase(bi)#')>
			</cfif>
		</cfloop>
		<cfreturn errores>
	</cffunction>
</cfcomponent>