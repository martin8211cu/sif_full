<cfparam name="Param" default="">
<cfif isdefined('ALTA')>
	<cfquery datasource="#session.dsn#" name="rsPadre">
		select 
			c.CFid, 
			c.CFcodigo as codigo, 
			c.CFdescripcion as descripcion, 
			1 as nivel,  
			(
				select count(1) from CFuncional c2
				where c2.CFidresp = c.CFid
				and c2.Ecodigo = c.Ecodigo
			) as  hijos
		from CFuncional c
		where c.Ecodigo = #Session.Ecodigo#
		and c.CFuresponsable = #session.usucodigo#
		order by CFpath
	</cfquery>
	<cfset CFvalido = false>
	<cfloop query="rsPadre">
		<cfif form.CFid eq CFid>
			<cfset CFvalido = true>
			<cfbreak>
		</cfif>
		<cfif hijos>
			<cfset CFvalido = fnGetHijos(CFid)>
		</cfif>
	</cfloop>
	<cfif CFvalido or (isdefined('form.ADM') and form.ADM eq 'true')>
		<cfinvoke component="sif.Componentes.FP_SeguridadUsuario" method="Alta" returnvariable="FPSUid">
			<cfinvokeargument name="Usucodigo" 		value="#form.Usucodigo#">
			<cfinvokeargument name="CFid" 			value="#form.CFid#">
			<cfinvokeargument name="FPSUestimar"  	value="1">
		</cfinvoke>
		<cfset Param = "CFid=#CFid#&FPSUid=#FPSUid#">
	</cfif>
<cfelseif isdefined('BAJA')>
	<cfinvoke component="sif.Componentes.FP_SeguridadUsuario" method="Baja" returnvariable="FPSUid">
		<cfinvokeargument name="FPSUid" 	value="#form.FPSUid#">
	</cfinvoke>
	<cfset Param = "CFid=#CFid#">
</cfif>
<cflocation url="#CurrentPage#?#param#" addtoken="no">

<cffunction name="fnGetHijos" returntype="boolean" access="private">
  	<cfargument name='idPadre'		type='numeric' 	required='true'>		
   	<cfquery datasource="#session.dsn#" name="Arguments.rsSQL">
		select 
		c.CFid
		from CFuncional c
		where c.Ecodigo = #Session.Ecodigo#
		  and c.CFidresp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idPadre#">
		order by c.CFpath
	</cfquery>
	<cfloop query="Arguments.rsSQL">
		<cfif form.CFid eq Arguments.rsSQL.CFid>
			<cfset CFvalido = true>
			<cfbreak>
		</cfif>
		<cfif Arguments.rsSQL.recordcount gt 0>
			<cfset fnHijos = fnGetHijos(Arguments.rsSQL.CFid)>
		</cfif>
	</cfloop>
	<cfreturn CFvalido>
</cffunction>