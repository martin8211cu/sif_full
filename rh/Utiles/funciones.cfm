<cffunction access="public" name="get_vacaciones_disf" returntype="numeric">
	<cfargument name="RHAlinea" type="numeric" 	required="true" default="0">
	<cfargument name="RHJid" 	type="numeric" 	required="true" default="0">
	<cfargument name="Conexion" type="string" 	required="false">
    
    <cfif not isdefined('Arguments.Conexion')>
    	<cfset Arguments.Conexion = Session.DSN>
    </cfif>
	
	<cfquery name="rsGetAccion" datasource="#Arguments.Conexion#">
		select coalesce(RHJid, #Arguments.RHJid#) as RHJid, DLfvigencia as Fdesde, DLffin as Fhasta
		from RHAcciones
		where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfif rsGetAccion.recordCount GT 0>
		<cfset Fdesde = rsGetAccion.Fdesde>
		<cfset Fhasta = rsGetAccion.Fhasta>
		<cfset RHJid = Val(rsGetAccion.RHJid)>
		<cfif Len(Fdesde) IS 0 or Len(Fhasta) IS 0>
			<cfreturn 0>
		<cfelse>
			<cfreturn get_dias_habiles( Fdesde, Fhasta, RHJid, -1, Arguments.Conexion ) >
		</cfif>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>

<cffunction access="public" name="get_dias_habiles" returntype="numeric">
	<cfargument name="Fdesde"   type="date"    required="true">
	<cfargument name="Fhasta"   type="date"    required="true">
	<cfargument name="RHJid"    type="numeric" required="true"  default="0">
	<cfargument name="Ocodigo"  type="numeric" required="false" default="-1">
	<cfargument name="Conexion" type="string"  required="false" default="#Session.DSN#">
	
    <cfif not isdefined('Arguments.Conexion')>
    	<cfset Arguments.Conexion = Session.DSN>
    </cfif>

	<cfquery name="rsJornadas" datasource="#Arguments.Conexion#">
		select * from RHJornadas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#">
	</cfquery>
	
	<cfset diassem="2,3,4,5,6"><!--- Lunes a viernes, por si no encuentro la jornada --->

	<cfoutput query="rsJornadas">
		<cfset diassem = "#RHJsun#," & "#RHJmon*2#," & "#RHJtue*3#," & "#RHJwed*4#," & "#RHJthu*5#," & "#RHJfri*6#," & "#RHJsat*7#">
	</cfoutput>
	
	<cfquery name="rsFeriados" datasource="#Arguments.Conexion#">
		select 1 
		from RHFeriados a
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fdesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fhasta#">
		  and <cf_dbfunction name="date_part" args="dw,RHFfecha" datasource="#session.dsn#"> in (#diassem#)
		<cfif Ocodigo NEQ -1>
		  and (RHFregional = 0
		   or exists( select 1 from RHDFeriados b 
		              where b.Ecodigo = a.Ecodigo
					    and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and b.RHFid   = a.RHFid
						and b.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ocodigo#">
			)
		)
		</cfif>
	</cfquery>
	
	<cfset CantDias = datediff("d", Fdesde, Fhasta) + 1>
	<cfset FControl = Fdesde>
	
	<cfset laborados = 0>
	<cfif CantDias LT (365 * 2)>
		<!--- este es un parche para que cuando la fecha hasta sea de 6100/01/01 no se tarde dos minutos en responder
			ahi luego se cambia por otra cosa 
		 --->
		<cfloop index="i" from="1" to="#CantDias#">
			<cfif diassem contains "#Dayofweek(Fcontrol)#">
				<cfset laborados = laborados + 1>
			</cfif> 
			<cfset FControl = dateadd('d',1,FControl)>
		</cfloop>
	<cfelse>
		<cfset laborados = CantDias>
	</cfif>
	<cfreturn laborados - rsFeriados.RecordCount>
</cffunction>
