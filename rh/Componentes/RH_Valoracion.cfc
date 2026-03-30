<cfcomponent>
	
	<cffunction name="fnAltaE" access="public" returntype="numeric">
		<cfargument name="RHEVFcodigo" 		type="string" 	required="true">
        <cfargument name="RHEVFdescripcion" type="string" 	required="true">
        <cfargument name="RHEVFfecha" 		type="date" 	required="true">
        <cfargument name="Usucodigo"		type="numeric">
		<cfargument name="Ecodigo" 			type="numeric" >	
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
		<cfset fnExisteE(Arguments.RHEVFcodigo, -1, Arguments.Ecodigo, Arguments.Conexion)>
		<cfquery name="rsInsertE" datasource="#Arguments.Conexion#">
			insert into RHEValoracionFactores (RHEVFcodigo, RHEVFdescripcion, RHEVFfecha, Ecodigo, BMUsucodigo)
            values(
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEVFcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEVFdescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_date" 	 value="#Arguments.RHEVFfecha#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            )
			<cf_dbidentity1 datasource="#Arguments.Conexion#">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertE">
        <cfreturn #rsInsertE.identity#>
	</cffunction>
    
   <cffunction name="fnCambioE" access="public" returntype="numeric">
   		<cfargument name="RHEVFid" 			type="string" 	required="true">
		<cfargument name="RHEVFcodigo" 		type="string" 	required="true">
        <cfargument name="RHEVFdescripcion" type="string" 	required="true">
        <cfargument name="RHEVFfecha" 		type="date" 	required="true">
        <cfargument name="Usucodigo"		type="numeric">
		<cfargument name="Ecodigo" 			type="numeric" >	
		<cfargument name="Conexion" 		type="string">	

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
		<cfset fnExisteE(Arguments.RHEVFcodigo, Arguments.RHEVFid, Arguments.Ecodigo, Arguments.Conexion)>
		<cfquery datasource="#Arguments.Conexion#">
			update RHEValoracionFactores set
            	RHEVFcodigo 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEVFcodigo#">,
                RHEVFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEVFdescripcion#">,
                RHEVFfecha 		 = <cfqueryparam cfsqltype="cf_sql_date" 	 value="#Arguments.RHEVFfecha#">,
                Ecodigo 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                BMUsucodigo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			where RHEVFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVFid#">
		</cfquery>
        <cfreturn Arguments.RHEVFid>
	</cffunction>
    
   	<cffunction name="fnBajaE" access="public">
   		<cfargument name="RHEVFid" 			type="string" 	required="true">
		<cfargument name="Conexion" 		type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHEValoracionFactores
			where RHEVFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVFid#">
		</cfquery>
	</cffunction>
    
    <cffunction name="fnExisteE" access="public">
		<cfargument name="RHEVFcodigo" 		type="string" 	required="true">
        <cfargument name="RHEVFid" 			type="numeric">
		<cfargument name="Ecodigo" 			type="numeric" >	
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsE" datasource="#Arguments.Conexion#">
			select count(1) cantidad
            from RHEValoracionFactores
            where 
            	RHEVFcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEVFcodigo#">
                and Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                <cfif isdefined('Arguments.RHEVFid') and Arguments.RHEVFid neq -1>
                	and RHEVFid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVFid#">
                </cfif>
		</cfquery>
        
        <cfif rsE.cantidad gt 0>
			<cfthrow message="Ya existe el código ingresdo">        
        </cfif>
	</cffunction>
    
    <cffunction name="fnGetE" access="public" returntype="query">
		<cfargument name="RHEVFid" 			type="numeric">
		<cfargument name="Ecodigo" 			type="numeric" >	
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsSelectE" datasource="#Arguments.Conexion#">
			select  RHEVFid, RHEVFcodigo, RHEVFdescripcion, RHEVFfecha, Ecodigo, BMUsucodigo, ts_rversion
            from RHEValoracionFactores
			where Ecodigo = #Arguments.Ecodigo#
            	<cfif isdefined('Arguments.RHEVFid')>
                	and RHEVFid = #Arguments.RHEVFid#
                </cfif>
            order by RHEVFcodigo, RHEVFdescripcion
		</cfquery>
        <cfreturn rsSelectE>
	</cffunction>
    
    <cffunction name="fnAltaD" access="public" returntype="numeric">
		<cfargument name="RHEVFid" 			type="numeric" required="true">
        <cfargument name="RHPcodigo" 		type="string"  required="true">
        <cfargument name="RHDVFdesripcion"  type="string">
        <cfargument name="Usucodigo"		type="numeric">
		<cfargument name="Ecodigo" 			type="numeric" >	
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
		<cfset fnExisteD(Arguments.RHPcodigo, Arguments.RHEVFid, -1, Arguments.Ecodigo, Arguments.Conexion)>
        <cfset fnCrearTabla(Arguments.Conexion)>
        <cftransaction>
            <cfquery name="rsInsertD" datasource="#Arguments.Conexion#">
                insert into RHDValoracionFactores (RHEVFid, RHPcodigo, Ecodigo, BMUsucodigo, RHDVFdesripcion)
                values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVFid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHPcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#Arguments.RHDVFdesripcion#">
                )
                <cf_dbidentity1 datasource="#Arguments.Conexion#">
            </cfquery>
            <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertD">
            <cfset RHDVFid = rsInsertD.identity>
			<cfset rsHabilidades = fnGetHabilidades(Arguments.RHPcodigo, Arguments.Ecodigo, Arguments.Conexion)>
            <cfloop query="rsHabilidades">
                <cfset fnAltaS(RHDVFid, rsHabilidades.RHIHorden, rsHabilidades.pts, rsHabilidades.RHIHorden, rsHabilidades.pts, rsHabilidades.RHHid, -1, -1, Arguments.Usucodigo, Arguments.Ecodigo, Arguments.Conexion)>
            </cfloop>
            <cfset rsCompetencias = fnGetCompetenciasTecnicas(Arguments.RHPcodigo, Arguments.Ecodigo, Arguments.Conexion)>
            <cfloop query="rsCompetencias">
                <cfset fnAltaS(RHDVFid, rsCompetencias.RHECgrado, rsCompetencias.pts, rsCompetencias.RHECgrado, rsCompetencias.pts, -1 , -1, rsCompetencias.RHECGid, Arguments.Usucodigo, Arguments.Ecodigo, Arguments.Conexion)>
            </cfloop>
            <cfset rsCondiciones = fnGetCondicionesLaborales(Arguments.RHPcodigo, Arguments.Ecodigo, Arguments.Conexion)>
            <cfloop query="rsCondiciones">
                <cfset fnAltaS(RHDVFid, rsCondiciones.RHECgrado, rsCondiciones.pts, rsCondiciones.RHECgrado, rsCondiciones.pts, -1 , rsCondiciones.RHDDVlinea, -1, Arguments.Usucodigo, Arguments.Ecodigo, Arguments.Conexion)>
            </cfloop>
       	</cftransaction>
        <cfreturn #RHDVFid#>
	</cffunction>
    
    <cffunction name="fnCambioD" access="public" returntype="numeric">
    	<cfargument name="RHEVFid" 			type="numeric" required="true">
		<cfargument name="RHDVFid" 			type="numeric" required="true">
        <cfargument name="RHPcodigo" 		type="string"  required="true">
        <cfargument name="RHDVFdesripcion"  type="string">
        <cfargument name="Usucodigo"		type="numeric">
		<cfargument name="Ecodigo" 			type="numeric" >	
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
		<cfset fnExisteD(Arguments.RHPcodigo, Arguments.RHEVFid, Arguments.RHDVFid, Arguments.Ecodigo, Arguments.Conexion)>
        <cfquery datasource="#Arguments.Conexion#">
            update RHDValoracionFactores set 
                RHPcodigo 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHPcodigo#">,
                Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                RHDVFdesripcion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.RHDVFdesripcion#">
			where RHDVFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVFid#">
        </cfquery>
           
        <cfreturn #Arguments.RHDVFid#>
	</cffunction>
    
   	<cffunction name="fnBajaD" access="public">
   		<cfargument name="RHDVFid" 		type="numeric" 	required="true">
		<cfargument name="Conexion" 	type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>


		<cfquery datasource="#Arguments.Conexion#">
			delete from RHDValoracionFactores
            where RHDVFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVFid#">
        </cfquery>
	</cffunction>
    
   	<cffunction name="fnAltaS" access="public" returntype="numeric">
		<cfargument name="RHDVFid" 				type="numeric" 	required="true">
        <cfargument name="RHSVFgrado" 			type="numeric" 	required="true">
        <cfargument name="RHSVFpuntos" 			type="numeric" 	required="true">
        <cfargument name="RHSVFgradoPropuesta" 	type="numeric">
        <cfargument name="RHSVFpuntosPropuesta"	type="numeric">
        <cfargument name="RHHid" 				type="numeric">
        <cfargument name="RHDDVlinea" 			type="numeric">
        <cfargument name="RHECGid" 				type="numeric">
        <cfargument name="Usucodigo"			type="numeric">
		<cfargument name="Ecodigo" 				type="numeric" >	
		<cfargument name="Conexion" 			type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
        <cfif not isdefined('Arguments.RHSVFgradoPropuesta')>
			<cfset Arguments.RHSVFgradoPropuesta = "#Arguments.RHSVFgrado#">
		</cfif>
       	<cfif not isdefined('Arguments.RHSVFpuntosPropuesta')>
			<cfset Arguments.RHSVFpuntosPropuesta = "#Arguments.RHSVFpuntos#">
		</cfif>
        
        <cfif not isdefined('Arguments.RHHid') or Arguments.RHHid eq -1>
			<cfset Arguments.RHHid = "null">
		</cfif>
        <cfif not isdefined('Arguments.RHDDVlinea') or Arguments.RHDDVlinea eq -1>
			<cfset Arguments.RHDDVlinea = "null">
		</cfif>
        <cfif not isdefined('Arguments.RHECGid') or Arguments.RHECGid eq -1>
			<cfset Arguments.RHECGid = "null">
		</cfif>
        
		<cfquery name="rsInsertS" datasource="#Arguments.Conexion#">
			insert into RHSValoracionFactores (
            	RHDVFid, RHSVFgrado, RHSVFpuntos, 
                RHSVFgradoPropuesta, RHSVFpuntosPropuesta, RHHid, 
                RHDDVlinea, RHECGid, Ecodigo, BMUsucodigo
            )
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVFid#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHSVFgrado#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHSVFpuntos#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHSVFgradoPropuesta#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHSVFpuntosPropuesta#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHHid#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHDDVlinea#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHECGid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            )
			<cf_dbidentity1 datasource="#Arguments.Conexion#">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertS">
        <cfreturn #rsInsertS.identity#>
	</cffunction>
    
   	<cffunction name="fnExisteD" access="public">
		<cfargument name="RHPcodigo" 		type="string" 	required="true">
        <cfargument name="RHEVFid" 			type="numeric"  required="true">
        <cfargument name="RHDVFid" 			type="numeric">
		<cfargument name="Ecodigo" 			type="numeric" >	
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsD" datasource="#Arguments.Conexion#">
			select count(1) cantidad
            from RHDValoracionFactores
            where 
            	RHEVFid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVFid#">
                and RHPcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHPcodigo#">
                <cfif isdefined('Arguments.RHDVFid') and Arguments.RHDVFid neq -1>
                	and RHDVFid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVFid#">
                </cfif>
		</cfquery>
        
        <cfif rsD.cantidad gt 0>
			<cfthrow message="Para esta configuración ya existe el puesto a ingresar.">        
        </cfif>
	</cffunction>
    
    <cffunction name="fnGetD" access="public" returntype="query">
		<cfargument name="RHEVFid" 		type="numeric" required="yes">
        <cfargument name="RHDVFid" 		type="numeric">
		<cfargument name="Conexion" 	type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsSelectD" datasource="#Arguments.Conexion#">
			select  d.RHDVFid, d.RHEVFid, d.Ecodigo, d.BMUsucodigo, d.ts_rversion,
            	p.RHPcodigo, coalesce(p.RHPcodigoext,p.RHPcodigo) as RHPcodigoext, p.RHPdescpuesto, d.RHDVFdesripcion
            from RHDValoracionFactores d
            	inner join RHPuestos p
                	 on p.RHPcodigo = d.RHPcodigo and p.Ecodigo = d.Ecodigo
			where RHEVFid = #Arguments.RHEVFid#
            	<cfif isdefined('Arguments.RHDVFid')>
                	and RHDVFid = #Arguments.RHDVFid#
                </cfif>
            order by coalesce(p.RHPcodigoext,p.RHPcodigo), p.RHPdescpuesto
		</cfquery>
        <cfreturn rsSelectD>
	</cffunction>
    
    <cffunction name="fnGetHabilidades" access="public" returntype="query">
		<cfargument name="RHPcodigo" 	type="string" required="yes">
        <cfargument name="Ecodigo" 		type="numeric">
		<cfargument name="Conexion" 	type="string">	
		
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsHabilidades" datasource="#Arguments.Conexion#">
        	select 
                h.RHHid,
                h.RHHdescripcion,
                ih.RHIHid, 
                ih.RHIHdescripcion,
                ih.RHIHorden,
                sf.RHHSFponderacion, 
                sf.RHHSFpuntuacion,
                <cf_dbfunction name="to_float" args="(sf.RHHSFpuntuacion / (select count(1) from RHIHabilidad iha where iha.RHHid = hp.RHHid) * ih.RHIHorden)" dec="2" datasource="#Arguments.Conexion#"> as pts
          	from RHHabilidadesPuesto hp 
            inner join RHHabilidades h 
                on h.RHHid = hp.RHHid 
            inner join RHIHabilidad ih 
                on ih.RHIHid = hp.RHIHid 
            inner join RHHFactores f 
                on f.RHHFid = h.RHHFid 
            inner join RHHSubfactores sf 
                on sf.RHHSFid = h.RHHSFid 
			where hp.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
				and hp.Ecodigo = #Arguments.Ecodigo#
            order by RHHdescripcion
		</cfquery>
        <cfreturn rsHabilidades>
	</cffunction>
    
    <cffunction name="fnGetCompetenciasTecnicas" access="public" returntype="query">
		<cfargument name="RHPcodigo" 	type="string" required="yes">
        <cfargument name="Ecodigo" 		type="numeric">
		<cfargument name="Conexion" 	type="string">	
		
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        
        <cfquery name="rsCompetencias" datasource="#Arguments.Conexion#">
        	select
                ecg.RHHFid,
                ecg.RHHSFid,
                ecg.RHECgrado,
                ecg.RHECGid
            from RHValoresPuesto vp 
            inner join RHECatalogosGenerales ecg
                on ecg.RHECGid = vp.RHECGid
			where vp.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHPcodigo#">
				and vp.Ecodigo = #Arguments.Ecodigo#
		</cfquery>
        <cfquery name="rsCompetenciasMax" dbtype="query">
        	select
                RHHFid,
                RHHSFid,
                max(RHECgrado) as RHECgrado
            from rsCompetencias
            group by RHHFid, RHHSFid
		</cfquery>
        
        <cfloop query="rsCompetenciasMax">
        	<cfquery name="rsComp" dbtype="query">
                select
                    RHHFid,
                    RHHSFid,
                    RHECGid
                from rsCompetencias
               	where RHHFid = #iif(len(trim(rsCompetenciasMax.RHHFid)) gt 0 , rsCompetenciasMax.RHHFid, -1)#
                   and RHHSFid = #iif(len(trim(rsCompetenciasMax.RHHSFid)) gt 0 , rsCompetenciasMax.RHHSFid, -1)#
                   and RHECgrado = #iif(len(trim(rsCompetenciasMax.RHECgrado)) gt 0 , rsCompetenciasMax.RHECgrado, -1)#
            </cfquery>
			<cfif rsComp.recordcount gt 0>
				<cfquery datasource="#Arguments.Conexion#">
					insert into #CompTec# (ID)
					values(#rsComp.RHECGid#)
				</cfquery>
			</cfif>
        </cfloop>

		<cfquery name="rsCompetencias" datasource="#Arguments.Conexion#">
        	select
                ecg.RHECGid,
                ecg.RHECGdescripcion,
                ecg.RHECgrado,
                sf.RHHSFponderacion, 
                sf.RHHSFpuntuacion,
                <cf_dbfunction name="to_float" args="(sf.RHHSFpuntuacion / (select count(1) from RHECatalogosGenerales ecga where ecga.RHHSFid = ecg.RHHSFid) * ecg.RHECgrado)" dec="2" datasource="#Arguments.Conexion#"> as pts 
            from #CompTec# temporal
           	inner join RHECatalogosGenerales ecg
            	on ecg.RHECGid = temporal.ID
            inner join RHHFactores f 
                on f.RHHFid = ecg.RHHFid 
            inner join RHHSubfactores sf 
                on sf.RHHSFid = ecg.RHHSFid 
			where ecg.Ecodigo = #Arguments.Ecodigo#
            order by RHECGdescripcion
		</cfquery>
        
        <cfquery datasource="#Arguments.Conexion#">
               delete from #CompTec#
        </cfquery>
        <cfreturn rsCompetencias>
	</cffunction>
    
     <cffunction name="fnGetCondicionesLaborales" access="public" returntype="query">
		<cfargument name="RHPcodigo" 	type="string" required="yes">
        <cfargument name="Ecodigo" 		type="numeric">
		<cfargument name="Conexion" 	type="string">	
		
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

        <cfquery name="rsCondiciones" datasource="#Arguments.Conexion#">
        	select
                 ddv.RHHFid,
                 ddv.RHHSFid,
                 ddv.RHECgrado,
                 ddv.RHDDVlinea
            from RHDVPuesto dp 
            inner join RHDDatosVariables ddv
                on ddv.RHDDVlinea = dp.RHDDVlinea
			where dp.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHPcodigo#">
				and dp.Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsCondicionesMin" dbtype="query">
			select
                RHHFid,
                RHHSFid,
                max(RHECgrado) as RHECgrado
            from rsCondiciones
			where RHHFid is null
			or RHHSFid is null
			or RHECgrado is null
            group by RHHFid, RHHSFid
		</cfquery>
		<cfif rsCondicionesMin.recordcount gt 0>
			<cfthrow message="Existe uno o varios Datos Variables asociados al puesto que no tienen asociado un factor o subfactor o grado. Proceso Cancelado.">
		</cfif>
        <cfquery name="rsCondicionesMax" dbtype="query">
        	select
                RHHFid,
                RHHSFid,
                max(RHECgrado) as RHECgrado
            from rsCondiciones
            group by RHHFid, RHHSFid
		</cfquery>
        
        <cfloop query="rsCondicionesMax">
			<cfif len(trim(rsCondicionesMax.RHHFid)) gt 0 and len(trim(rsCondicionesMax.RHHSFid)) gt 0 and len(trim(rsCondicionesMax.RHECgrado)) gt 0>
        	<cfquery name="rsCond" dbtype="query">
                select
                    RHHFid,
                    RHHSFid,
                    RHDDVlinea
                from rsCondiciones
               	where RHHFid = #rsCondicionesMax.RHHFid#
                   and RHHSFid = #rsCondicionesMax.RHHSFid#
                   and RHECgrado = #rsCondicionesMax.RHECgrado#
            </cfquery>
             <cfquery datasource="#Arguments.Conexion#">
                insert into #CompTec# (ID)
                values(#rsCond.RHDDVlinea#)
            </cfquery>
			</cfif>
        </cfloop>

		<cfquery name="rsCondiciones" datasource="#Arguments.Conexion#">
        	select
                ddv.RHDDVlinea,
                ddv.RHDDVdescripcion,
                ddv.RHECgrado,
                sf.RHHSFponderacion, 
                sf.RHHSFpuntuacion,
                <cf_dbfunction name="to_float" args="(sf.RHHSFpuntuacion / (select count(1) from RHDDatosVariables ddva where ddva.RHEDVid = ddv.RHEDVid) * ddv.RHECgrado)" dec="2" datasource="#Arguments.Conexion#"> as pts 
            from #CompTec# temporal
           	inner join RHDDatosVariables ddv
            	on ddv.RHDDVlinea = temporal.ID
            inner join RHHFactores f 
                on f.RHHFid = ddv.RHHFid 
            inner join RHHSubfactores sf 
                on sf.RHHSFid = ddv.RHHSFid 
			where ddv.Ecodigo = #Arguments.Ecodigo#
            order by RHDDVdescripcion
		</cfquery>
        <cfquery datasource="#Arguments.Conexion#">
               delete from #CompTec#
        </cfquery>
        <cfreturn rsCondiciones>
	</cffunction>
    
    <cffunction name="fnGetS" access="public" returntype="query">
        <cfargument name="RHDVFid" 		type="numeric" required="yes">
        <cfargument name="Tipo" 		type="numeric"><!--- 1 Competencias , 2 Competencias técnica, 3 Condiciones Laborales --->
		<cfargument name="Conexion" 	type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsSelectS" datasource="#Arguments.Conexion#">
			select
            	case when fh.RHHFdescripcion is not null then 1 when fcg.RHHFdescripcion is not null then 2 when fdv.RHHFdescripcion is not null then 3 else 4 end as ord,
                coalesce(h.RHHdescripcion,coalesce(cg.RHECGdescripcion,dv.RHDDVdescripcion)) as descripcion,
                coalesce(h.RHHcodigo,coalesce(cg.RHECGcodigo,dv.RHDDVcodigo)) as codigo,
                case when fh.RHHFdescripcion is not null then 'H' when fcg.RHHFdescripcion is not null then 'C' when fdv.RHHFdescripcion is not null then 'V' else 'D' end as tipo,
                coalesce(fh.RHHFcodigo,coalesce(fcg.RHHFcodigo,fdv.RHHFcodigo)) as codigoF,
                coalesce(coalesce(fh.RHHFdescripcion,coalesce(fcg.RHHFdescripcion,fdv.RHHFdescripcion)),'Factor Desconfigurado') as descripcionF,
                coalesce(sfh.RHHSFcodigo,coalesce(sfcg.RHHSFcodigo,sfdv.RHHSFcodigo)) as codigoSF,
                coalesce(sfh.RHHSFdescripcion,coalesce(sfcg.RHHSFdescripcion,coalesce(sfdv.RHHSFdescripcion,'Subfactor Desconfigurado'))) as descripcionSF,
                coalesce(sfh.RHHSFpuntuacion,coalesce(sfcg.RHHSFpuntuacion,sfdv.RHHSFpuntuacion)) as ptsSF,
                s.RHSVFid,
                s.RHDVFid,
                s.RHSVFgrado,
                s.RHSVFpuntos,
                s.RHSVFgradoPropuesta,
                s.RHSVFpuntosPropuesta,
                s.RHHid,
                s.RHDDVlinea,
                s.RHECGid,
                s.Ecodigo,
                s.BMUsucodigo,
                s.ts_rversion,
                coalesce(fh.RHHFid,coalesce(fcg.RHHFid,fdv.RHHFid)) as RHHFid,
                coalesce(sfh.RHHSFid,coalesce(sfcg.RHHSFid,sfdv.RHHSFid)) as RHHSFid
            from RHSValoracionFactores s
                left outer join RHHabilidades h
                    left outer join RHHFactores fh
                        on fh.RHHFid = h.RHHFid
                    left outer join RHHSubfactores sfh
                        on sfh.RHHSFid = h.RHHSFid
                    on h.RHHid = s.RHHid
                left outer join RHECatalogosGenerales cg
                    left outer join RHHFactores fcg
                        on fcg.RHHFid = cg.RHHFid
                    left outer join RHHSubfactores sfcg
                        on sfcg.RHHSFid = cg.RHHSFid
                    on cg.RHECGid = s.RHECGid
                left outer join RHDDatosVariables dv
                    left outer join RHHFactores fdv
                        on fdv.RHHFid = dv.RHHFid
                    left outer join RHHSubfactores sfdv
                        on sfdv.RHHSFid = dv.RHHSFid
                    on dv.RHDDVlinea = s.RHDDVlinea
			where RHDVFid = #Arguments.RHDVFid#
            <cfif isdefined('Arguments.Tipo') and Arguments.Tipo eq 1>
            	and s.RHHid is not null
            <cfelseif isdefined('Arguments.Tipo') and Arguments.Tipo eq 2>
            	and s.RHECGid is not null
            <cfelseif isdefined('Arguments.Tipo') and Arguments.Tipo eq 3>
            	and  s.RHDDVlinea is not null
            </cfif>
            order by ord,codigoF,codigoSF,descripcionF,descripcionSF
		</cfquery>
        <cfreturn rsSelectS>
	</cffunction> 
    
    <cffunction name="fnCambioS" access="public" returntype="numeric">
        <cfargument name="RHSVFid" 				type="numeric" required="yes">
        <cfargument name="RHSVFgradoPropuesta" 	type="numeric" required="yes">
        <cfargument name="RHSVFpuntosPropuesta" type="numeric" required="yes">
        <cfargument name="Usucodigo" 			type="numeric">
        <cfargument name="Ecodigo" 				type="numeric">
		<cfargument name="Conexion" 			type="string">	
		
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			update RHSValoracionFactores set
            	RHSVFgradoPropuesta = <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHSVFgradoPropuesta#">,
                RHSVFpuntosPropuesta = <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHSVFpuntosPropuesta#">,
                Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			where RHSVFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHSVFid#">
		</cfquery>
        <cfreturn Arguments.RHSVFid>
	</cffunction>
    
     <cffunction name="fnBajaS" access="public">
        <cfargument name="RHDVFid" 		type="numeric" required="yes">
		<cfargument name="Conexion" 	type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHSValoracionFactores where RHDVFid = #Arguments.RHDVFid#  
		</cfquery>
        
	</cffunction> 
    
    <cffunction name="fnGetGrados" access="public" returntype="query">
		<cfargument name="RHHid" 		type="numeric">
        <cfargument name="RHECGid" 		type="numeric">
        <cfargument name="RHDDVlinea" 	type="numeric">
        <cfargument name="Ecodigo" 		type="numeric">
		<cfargument name="Conexion" 	type="string">	
		
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif isdefined('Arguments.RHHid')>
            <cfquery name="rsGrados" datasource="#Arguments.Conexion#">
                select RHIHorden as grado, RHIHdescripcion as descripcion
                from RHIHabilidad
                where RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHHid#">
            </cfquery>
        <cfelseif isdefined('Arguments.RHECGid')>
        	<cfquery name="rsGrados" datasource="#Arguments.Conexion#">
            	select RHECgrado as grado, RHECGdescripcion as descripcion
                from RHECatalogosGenerales
                where RHHSFid = (select RHHSFid 
                                from RHECatalogosGenerales
                                where RHECGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECGid#">)
               	order by RHECgrado
            </cfquery>
        <cfelseif isdefined('Arguments.RHDDVlinea')>
        	<cfquery name="rsGrados" datasource="#Arguments.Conexion#">
            	select RHECgrado as grado, RHDDVdescripcion as descripcion
                from RHDDatosVariables
                where RHEDVid = (select RHEDVid
                                from RHDDatosVariables
                                where RHDDVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDDVlinea#">)
                order by RHECgrado
            </cfquery>
        </cfif>

        <cfreturn rsGrados>
	</cffunction>
    
   	<cffunction name="fnCrearTabla" access="private">
		<cfargument name="Conexion" type="string">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        
         <cf_dbtemp name="CompTec_V1" returnvariable="CompTec" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="ID" 			type="numeric" 		mandatory="yes">
			<cf_dbtempkey cols="ID">
            <cf_dbtempindex cols="ID">
		</cf_dbtemp>
        
	</cffunction>
    
	<cffunction name="fnRedondear" access="private" returntype="string">
		<cfargument name="Monto" type="numeric">
		<cfargument name="Decimales" type="numeric" default="2">
		
		<cfreturn NumberFormat(Arguments.Monto,".#RepeatString('9', Arguments.Decimales)#")>
	</cffunction>
	 
	<cffunction name="fnFormatMoney" access="private" returntype="string">
		<cfargument name="Monto" type="numeric">
		<cfargument name="Decimales" type="numeric" default="2">
		<cfreturn LsCurrencyFormat(NumberFormat(Arguments.Monto,".99"),'none')>
	</cffunction>
    
</cfcomponent>


