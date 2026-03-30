<cfparam name="form.tab"				default="1">
<cfparam name="Param" 					default="tab=#form.tab#&">
<cfparam name="form.PCGDmultiperiodo" 	default="0">
<cfparam name="form.FPEPnomodifica"   	default="0">
<cfif isdefined('form.PCGDxCantidad')>
	<cfset PCGDxCantidad = 1>
<cfelse>
	<cfset PCGDxCantidad = 0>
</cfif>
<cfif isdefined('form.CFid') and len(trim(form.CFid))>
	<cfset form.CFid = form.CFid>
<cfelse>
	<cfset form.CFid = - 1>
</cfif>
<cfif (NOT ISDEFINED('form.FPDCFid') OR NOT LEN(TRIM(form.FPDCFid))) AND ISDEFINED('url.FPDCFid')>
	<cfset form.FPDCFid = url.FPDCFid>
</cfif>

<cfif isdefined('form.CFComplementoId') and len(trim(form.CFComplementoId))>
	<cfset form.CFComplementoId = form.CFComplementoId>
<cfelse>
	<cfset form.CFComplementoId = - 1>
	<cfset form.CFComplemento	= "">
</cfif>

<cfif isdefined('ALTA')>
	<cfinvoke component="sif.Componentes.PlantillaFormulacion" method="AltaPlantilla" returnvariable="FPEPid">
		<cfinvokeargument name="FPEPdescripcion" 	 value="#form.FPEPdescripcion#">
		<cfinvokeargument name="FPCCtipo" 			 value="#form.FPCCtipo#">
		<cfinvokeargument name="FPEPnotas"  	     value="#form.FPEPnotas#">
		<cfinvokeargument name="FPCCconcepto"  	     value="#form.FPCCconcepto#">
		<cfinvokeargument name="PCGDxCantidad" 		 value="#PCGDxCantidad#">
		<cfinvokeargument name="PCGDxPlanCompras" 	 value="#form.PCGDxPlanCompras#">
		<cfinvokeargument name="PCGDmultiperiodo"	 value="#form.PCGDmultiperiodo#">
		<cfinvokeargument name="CFid"	 			 value="#form.CFid#">
		<cfif isdefined('form.FPEPmultiperiodo')>
			<cfinvokeargument name="FPEPmultiperiodo"	 value="1">
		</cfif>
		<cfinvokeargument name="FPAEid"	 			 value="#form.CFComplementoId#">
		<cfinvokeargument name="CFComplemento"	 	 value="#form.CFComplemento#">
		<cfinvokeargument name="FPEPnomodifica"	 	 value="#form.FPEPnomodifica#">
	</cfinvoke>
	<cfset Param &= "FPEPid=#FPEPid#">
<cfelseif isdefined('CAMBIO')>
	<cfset Param &= "FPEPid=#FPEPid#">
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FPEPlantilla"
		redirect="Plantillas.cfm?#param#"
		timestamp="#form.ts_rversion#"
		field1="FPEPid" 
		type1="numeric" 
		value1="#form.FPEPid#">
	<cfinvoke component="sif.Componentes.PlantillaFormulacion" method="CambioPlantilla" returnvariable="FPEPid">
		<cfinvokeargument name="FPEPid" 			 value="#form.FPEPid#">
		<cfinvokeargument name="FPEPdescripcion" 	 value="#form.FPEPdescripcion#">
		<cfinvokeargument name="FPCCtipo" 			 value="#form.FPCCtipo#">
		<cfinvokeargument name="FPEPnotas"  	     value="#form.FPEPnotas#">
		<cfinvokeargument name="ts_rversion" 		 value="#form.ts_rversion#">
		<cfinvokeargument name="FPCCconcepto"  	     value="#form.FPCCconcepto#">
		<cfinvokeargument name="PCGDxCantidad"		 value="#PCGDxCantidad#">
		<cfinvokeargument name="PCGDxPlanCompras" 	 value="#form.PCGDxPlanCompras#">
		<cfinvokeargument name="PCGDmultiperiodo"	 value="#form.PCGDmultiperiodo#">
		<cfinvokeargument name="CFid"	 			 value="#form.CFid#">
		<cfif isdefined('form.FPEPmultiperiodo')>
			<cfinvokeargument name="FPEPmultiperiodo"	 value="1">
		</cfif>
		<cfinvokeargument name="FPAEid"	 			 value="#form.CFComplementoId#">
		<cfinvokeargument name="CFComplemento"	 	 value="#form.CFComplemento#">
		<cfinvokeargument name="FPEPnomodifica"	 	 value="#form.FPEPnomodifica#">
	</cfinvoke>
<cfelseif isdefined('BAJA')>
	<cfinvoke component="sif.Componentes.PlantillaFormulacion" method="BajaPlantilla" returnvariable="FPEPid">
		<cfinvokeargument name="FPEPid" 		value="#form.FPEPid#">
	</cfinvoke>
<cfelseif isdefined('btnAgregarConcep')>
	<cfquery datasource="#session.dsn#" name="rsExistePlantilla">
		select FPCCid as idConcep
		from FPDPlantilla
		where FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPEPid#">
	</cfquery>
	<cfset existe = false>
	<cfloop query="rsExistePlantilla">
		<cfset existe=existePlantillaConceptoEnPadre(session.dsn, session.Ecodigo, idConcep, form.FPCCid)>
		<cfif existe>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfif not existe>
		<cfset hijosPC= BajaHijosPlantillaConceptos(session.dsn, session.Ecodigo, form.FPEPid, form.FPCCid)>
		<cfinvoke component="sif.Componentes.PlantillaFormulacion" method="AltaPlantillaConcep" returnvariable="FPDPid">
			<cfinvokeargument name="FPEPid" 	value="#form.FPEPid#">
			<cfinvokeargument name="FPCCid" 	value="#form.FPCCid#">
		</cfinvoke>
	</cfif>
	<cfset Param &= "FPEPid=#form.FPEPid#&tab1=true">
<cfelseif isdefined('btnEliminarConcep')>
	<cfinvoke component="sif.Componentes.PlantillaFormulacion" method="BajaPlantillaConcep" returnvariable="FPDPid">
		<cfinvokeargument name="FPDPid" 		value="#form.FPDPid#">
	</cfinvoke>
	<cfset Param &= "FPEPid=#form.FPEPid#">
<cfelseif isdefined('btnAgregarCentro')>
	<cfif not existePlantillaCentro(session.dsn, session.Ecodigo, form.CFid, form.FPEPid) gt 0>
		<cfinvoke component="sif.Componentes.PlantillaFormulacion" method="AltaPlantillaCentro" returnvariable="FPDCFid">
				<cfinvokeargument name="FPEPid" 	value="#form.FPEPid#">
				<cfinvokeargument name="CFid" 		value="#form.CFid#">
			<cfif isdefined('form.includeAll')>
				<cfinvokeargument name="includeAll" value="true">	
			</cfif>
		
		</cfinvoke>
	</cfif>
	<cfset Param &= "FPEPid=#form.FPEPid#">
<cfelseif isdefined('btnEliminarCentro')>
	<cfinvoke component="sif.Componentes.PlantillaFormulacion" method="BajaPlantillaCentro" returnvariable="FPDCFid">
		<cfinvokeargument name="FPDCFid" 		value="#form.FPDCFid#">
	</cfinvoke>
	<cfset Param &= "FPEPid=#form.FPEPid#&tab2=true">
<cfelseif isdefined('NUEVO')>
	<cfset Param &= "btnNuevo=true">
</cfif>
<cflocation url="Plantillas.cfm?#param#" addtoken="no">

<cffunction name="BajaHijosPlantillaConceptos"  access="public">
	<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
	<cfargument name="Ecodigo" 		    type="numeric" required="no" default="#session.Ecodigo#">
	<cfargument name="FPEPid" 	    	type="numeric" required="yes">
	<cfargument name="idConcepto" 	    	type="numeric" required="yes">
	
	<cfquery datasource="#Arguments.Conexion#" name="rsRecorreConceptosP">
		select 	FPCCid,
			(select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #Arguments.Ecodigo# and hijos.FPCCidPadre = padre.FPCCid) as cantHijos 
		from FPCatConcepto padre
		where Ecodigo = #Arguments.Ecodigo# and FPCCidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.idConcepto#">
		order by FPCCcodigo
	</cfquery>
	<cfloop query="rsRecorreConceptosP">
		<cfquery datasource="#Arguments.Conexion#" name="rsExistePlantilla">
			select FPDPid
			from FPDPlantilla
			where FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
				and FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FPCCid#">
		</cfquery>
		<cfif len(trim(rsExistePlantilla.FPDPid))>
			<cfinvoke component="sif.Componentes.PlantillaFormulacion" method="BajaPlantillaConcep" returnvariable="FPDPid">
				<cfinvokeargument name="FPDPid" 		value="#rsExistePlantilla.FPDPid#">
			</cfinvoke>
		</cfif>
		<cfif cantHijos>
			<cfset hijos = BajaHijosPlantillaConceptos(Arguments.Conexion, Arguments.Ecodigo, Arguments.FPEPid, FPCCid)>
		</cfif> 
	</cfloop>
</cffunction>

<cffunction name="existePlantillaConceptoEnPadre"  access="public" returntype="boolean">
	<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
	<cfargument name="Ecodigo" 		    type="numeric" required="no" default="#session.Ecodigo#">
	<cfargument name="idConcepto" 	    type="numeric" required="yes">
	<cfargument name="idConceptoInsertar" 	    type="numeric" required="yes">
	
	<cfquery datasource="#Arguments.Conexion#" name="rsRecorreConceptos">
		select 	FPCCid as idC,
			(select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #Arguments.Ecodigo# and hijos.FPCCidPadre = padre.FPCCid) as cantHijos 
		from FPCatConcepto padre
		where Ecodigo = #Arguments.Ecodigo# and FPCCidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.idConcepto#">
		order by FPCCcodigo
	</cfquery>
	<cfif idConcepto eq idConceptoInsertar>
		<cfreturn true>
	</cfif>
	<cfloop query="rsRecorreConceptos">
		<cfif idC eq idConceptoInsertar>
			<cfreturn true>
		</cfif>
		<cfif cantHijos>
			<cfset existe= existePlantillaConceptoEnPadre(Arguments.Conexion, Arguments.Ecodigo, idC, idConceptoInsertar)> 	
			<cfif existe>
				<cfbreak>
			</cfif>
		</cfif>
	</cfloop>
	<cfreturn existe>
</cffunction>

<cffunction name="existePlantillaCentro"  access="public" returntype="boolean">
	<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
	<cfargument name="Ecodigo" 		    type="numeric" required="no" default="#session.Ecodigo#">
	<cfargument name="CFid" 	    	type="numeric" required="yes">
	<cfargument name="FPEPid" 	    	type="numeric" required="yes">
	<cfquery datasource="#Arguments.Conexion#" name="rsExisteCentro">
		select 1 as existeCen
		from FPDCentrosF 
		where FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPid#">
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CFid#">
	</cfquery>
	<cfreturn len(trim(rsExisteCentro.existeCen))>
</cffunction>