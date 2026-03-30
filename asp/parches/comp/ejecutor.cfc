<cfcomponent>
	<cfset This.DEBUG = -1>
	<cfset This.INFO    = 0>
	<cfset This.WARN = 1>
	<cfset This.ERROR = 2>
	

	<cffunction name="ejecuta">
		<cfargument name="num_tarea" type="numeric" required="yes">
		<cfargument name="ruta" type="string" required="yes">
		<cfargument name="datasources" type="string">
	</cffunction>
	
	<cffunction name="inicio">
		<cfargument name="num_tarea" type="numeric" required="yes">
		<cfargument name="msg" type="string" required="yes" hint="Mensaje por almacenar">

		<cfset This.logmsg(Arguments.num_tarea, 'inicio', This.INFO, 'Inicia: ' & Arguments.msg)>
		<cfquery datasource="asp" name="siguiente">
			update APTareas
			set inicio = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
			  and num_tarea = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.num_tarea#">
		</cfquery>
	</cffunction>
	
	<cffunction name="fin">
		<cfargument name="num_tarea" type="numeric" required="yes">

		<cfset This.logmsg(Arguments.num_tarea, 'fin', This.INFO, 'Termina tarea')>
		<cfquery datasource="asp">
			update APTareas
			set fin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
			  and num_tarea = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.num_tarea#">
		</cfquery>
	</cffunction>
	
	<cffunction name="logmsg">
		<cfargument name="num_tarea" type="numeric" required="yes">
		<cfargument name="nombre" type="string" required="yes" hint="Objeto afectado">
		<cfargument name="severidad" type="numeric" required="yes" hint="Severidad (-1=DEBUG,0=INFO,1=WARN,2=ERROR)">
		<cfargument name="msg_corto" type="string" required="yes" hint="Mensaje por almacenar">
		<cfargument name="msg_largo" type="string" required="no" default="" hint="Texto adicional por almacenar">
		
		<cfquery datasource="asp" name="siguiente">
			select coalesce (max (num_msg), 0) as siguiente
			from APMensajes
			where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
		</cfquery>
		<cfquery datasource="asp">
			insert into APMensajes (
				instalacion, num_tarea, num_msg,
				fecha, nombre, severidad, msg_corto, msg_largo)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.num_tarea#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#siguiente.siguiente+1#">,
				
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nombre#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.severidad#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Arguments.msg_corto,255)#" null="#Len(Arguments.msg_corto) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_clob" value="#Arguments.msg_largo#" null="#Len(Arguments.msg_largo) EQ 0#">
				)
		</cfquery>
		
	</cffunction>
	
	<cffunction name="get_xml" returntype="xml">
		<cfquery datasource="asp" name="ejecutorcfc_get_xml_query">
			select xml
			from APParche
			where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.parche#">
		</cfquery>
		<cfreturn XmlParse(ejecutorcfc_get_xml_query.xml)>
	</cffunction>


</cfcomponent>