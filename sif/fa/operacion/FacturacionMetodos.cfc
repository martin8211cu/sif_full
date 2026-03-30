<cfcomponent>
    <!---- Lllenar direcciones del socio ----->  
    <cffunction name="DireccionesSocio" access="remote" returntype="query" returnformat="json" output="true">
     <cfargument name="Ecodigo"  type="numeric" required="no" default="#session.Ecodigo#">
     <cfargument name="SNcodigo" type="numeric" required="yes">
     
      <cfquery datasource="#session.dsn#" name="direcciones">
		select 
			  b.id_direccion
			<!---
			, case rtrim(ltrim(isNull(a.sndireccion,'')))
				when '' then 
					case rtrim(ltrim(<cf_dbfunction name="concat" args="c.direccion1,'/',c.direccion2 ">))
						when '' then isNull(b.SNnombre,'')
						else rtrim(ltrim(<cf_dbfunction name="concat" args="c.direccion1,'/',c.direccion2 ">))
					end
				else isNull(a.sndireccion,'')
			  end as Texto_direccion
			--->
			, <cf_dbfunction name="concat" args="c.direccion1,' ',c.direccion2 "> as Texto_direccion
		from SNegocios a
			left join SNDirecciones b
				on a.SNid = b.SNid
			left join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo   =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	       and a.SNcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">   
		   and b.id_direccion is not null
	</cfquery>

    <cfreturn direcciones>
 </cffunction> 
</cfcomponent>