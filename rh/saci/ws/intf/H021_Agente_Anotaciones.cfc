<cfcomponent extends="base">
	<cffunction name="registro_de_anotaciones" access="public" returntype="void" output="false">
		<cfargument name="origen" type="string" required="yes" default="siic">	
		<cfargument name="lid" type="string" required="yes">
		<cfargument name="AGid" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="IEstado" type="string" required="yes">
		<cfargument name="INfechaCrea" type="string" required="yes">
		<cfargument name="INusuarioCrea" type="string" required="yes">
		<cfargument name="INfechaCorrige" type="string" required="yes">
		<cfargument name="INobsCrea" type="string" required="yes">
										
<!---		
		1.	S02VA1 = “código error*código de agente*login*estado*fecha_creación*usuario_crea_anotación*fecha_correción*Observación"
		
--->		
		<cfset control_inicio( Arguments, 'H021','AGid=' & Arguments.AGid)>
		<cftry>
			<cfset control_servicio( 'siic' )>
			
			<cfset sdfDatetime1 = CreateObject("java", "java.text.SimpleDateFormat").init('yyyyMMdd')>
			<cfset fecha_creacion = sdfDatetime1.parse(Arguments.INfechaCrea)>
			<cfset fecha_corrige = sdfDatetime1.parse(Arguments.INfechaCorrige)>
			
			<cfquery datasource="#session.dsn#" name="querylogin">
				select lo.Contratoid,CTid from ISBlogin lo
				inner join ISBproducto pro
				on lo.Contratoid = pro.Contratoid
				where LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">			
			</cfquery>
			
			
			<cfquery datasource="#session.dsn#" name="rsAlta">
			insert ISBagenteIncidencia (
				Iid
				, AGid
				, CTid
				, Contratoid
				, IEstado
				, INfechaCrea
				, INusuarioCrea
				, INobsCrea
				, INfechaCorrige
				, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.lid#" null="#Len(Arguments.lid) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#querylogin.CTid#" null="#Len(querylogin.CTid) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#querylogin.Contratoid#" null="#Len(querylogin.Contratoid) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.IEstado#" null="#Len(Arguments.IEstado) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#fecha_creacion#" null="#Len(fecha_creacion) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="0">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.INobsCrea#" null="#Len(Arguments.INobsCrea) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#fecha_corrige#" null="#Len(fecha_corrige) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		
	</cfquery>

			<cfset control_final( )>
		<cfcatch type="any">
			<!--- error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>