<cfcomponent>
	<cffunction name="init">
		<cfreturn this >
	</cffunction>
	<!----=========== Funcion que elimina los items a evaluar de una relacion (Machote) ===========--->
	<cffunction name="funcBorrarItem" output="true">
		<cfargument name="RHRSid" type="numeric" required="yes">
		<cfquery datasource="#session.DSN#">
			delete from RHItemEvaluar where RHEid = (select RHEid 
												from RHEvaluados
												where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
													and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		</cfquery>
	</cffunction>	
	<!----=========== Funcion que elimina los evaluadores de una relacion (Machote) ===========--->
	<cffunction name="funcBorrarEvaluadores" output="true">
		<cfargument name="RHRSid" type="numeric" required="yes">
		<cfquery datasource="#session.DSN#">
			delete from RHEvaluadores where RHEid = (select RHEid 
												from RHEvaluados 
												where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
												and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		</cfquery>
	</cffunction>
	<!----=========== Funcion que elimina los evaluados de una relacion (Machote) ===========--->
	<cffunction name="funcBorrarEvaluados" output="true">
		<cfargument name="RHRSid" type="numeric" required="yes">
		<cfquery datasource="#session.DSN#">
			delete from RHEvaluados 
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cffunction>		
	<!----=========== Funcion que elimina las respuestas de todas las instancias de una relacion de evaluacion (machote) ===========--->
	<cffunction name="funcBorrarRespuestas" output="true">
		<cfargument name="RHRSid" type="numeric" required="yes">		
		<cfquery datasource="#session.DSN#">
			delete from RHRespuestas 
			where exists(select 1 
						from RHDRelacionSeguimiento b, RHRSEvaluaciones d, RHRERespuestas c
						where b.RHDRid = d.RHDRid
							and d.RHRSEid = c.RHRSEid
							and b.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
							)
		</cfquery>
	</cffunction>		
	<!----=========== Funcion que elimina los encabezados de las respuestas de todas las instancias de una relacion de evaluacion (machote) ===========--->
	<cffunction name="funcBorrarEncabRespuestas" output="true">
		<cfargument name="RHRSid" type="numeric" required="yes">		
		<cfquery datasource="#session.DSN#">
			delete from RHRERespuestas
			where RHERid in (select c.RHERid from RHDRelacionSeguimiento a, RHRSEvaluaciones b, RHRERespuestas c
							where a.RHDRid = b.RHDRid
								and b.RHRSEid = c.RHRSEid
								and a.RHRSid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
							) 
			<!----
			where RHERid in (select b.RHERid
							from RHDRelacionSeguimiento a, RHRERespuestas b
							where a.RHDRid = b.RHDRid
								and a.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
							)
			----->				
		</cfquery>
	</cffunction>			
	<!----=========== Funcion  ===========--->
	<cffunction name="funcBorrarEncabInstancias" output="true">
		<cfargument name="RHRSid" type="numeric" required="yes">
		<cfquery datasource="#session.DSN#">	
			delete from RHRSEvaluaciones
			where RHRSEid in (select b.RHRSEid
							from RHDRelacionSeguimiento a, RHRSEvaluaciones b
							where a.RHDRid = b.RHDRid
								and a.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
							)		
		</cfquery>
	</cffunction>			

	<!----=========== Funcion que elimina todas las instancias de una relacion de evaluacion (machote) ===========--->
	<cffunction name="funcBorrarInstancias" output="true">
		<cfargument name="RHRSid" type="numeric" required="yes">
		<cfquery datasource="#session.DSN#">			
			delete from RHDRelacionSeguimiento 
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
		</cfquery>
	</cffunction>			
	<!----=========== Funcion que el resumen de una relacion de evaluacion (machote) ===========--->
	<cffunction name="funcBorrarResumen" output="true">
		<cfargument name="RHRSid" type="numeric" required="yes">
		<cfquery datasource="#session.DSN#">
			delete from RHResumen
			where RHDRid in (select RHDRid 
							from RHDRelacionSeguimiento 
							where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
							)
		</cfquery>			
	</cffunction>			
	<!----=========== Funcion que elimina una relacion de evaluacion (machote) ===========--->
	<cffunction name="funcBorrarRelacion" output="true">
		<cfargument name="RHRSid" type="numeric" required="yes">
		<cfquery datasource="#session.DSN#">
			delete from RHRelacionSeguimiento 
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
		</cfquery>
	</cffunction>			
	<!----=========== Funcion que elimina TODA la relacion de seguimiento (machote) ===========--->
	<cffunction name="funcBorrarTodaRelacion" output="true">
		<cfargument name="RHRSid" type="numeric" required="yes">
			<cftransaction>
				<cfset this.funcBorrarRespuestas(arguments.RHRSid)>			<!---RHRespuestas---->
				<cfset this.funcBorrarEncabRespuestas(arguments.RHRSid)>	<!---RHRERespuestas---->
				<cfset this.funcBorrarEncabInstancias(arguments.RHRSid)>	<!---RHRSEvaluaciones---->
				<cfset this.funcBorrarResumen(arguments.RHRSid)>			<!---RHResumen---->
				<cfset this.funcBorrarInstancias(arguments.RHRSid)>			<!---RHDRelacionSeguimiento--->
				<cfset this.funcBorrarEvaluadores(arguments.RHRSid)>		<!---RHEvaluadores---->
				<cfset this.funcBorrarItem(arguments.RHRSid)>				<!---RHItemEvaluar---->
				<cfset this.funcBorrarEvaluados(arguments.RHRSid)>			<!---RHEvaluados---->
				<cfset this.funcBorrarRelacion(arguments.RHRSid)>			<!---RHRelacionSeguimiento---->			
			</cftransaction>
	</cffunction>			
</cfcomponent>
