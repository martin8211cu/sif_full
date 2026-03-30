<cfcomponent>
	<!---=======Agrega una nueva Clasificacion de Concepto de Gasto o Ingreso=======--->
	<cffunction name="AltaClasificacionConcepto"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 		    type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="FPCCcodigo" 	    type="string"  required="yes">
		<cfargument name="FPCCdescripcion"  type="string"  required="yes">
		<cfargument name="FPCCtipo" 	    type="string"  required="no">
		<cfargument name="FPCCconcepto"     type="string"  required="no">
		<cfargument name="FPCCcomplementoC" type="string"  required="no">
		<cfargument name="FPCCcomplementoP" type="string"  required="no">
		<cfargument name="FPCCidPadre" 		type="numeric" required="yes" default="-1">
		<cfargument name="FPCCTablaC"       type="numeric" required="no">
		<cfargument name="FPCCExigeFecha"   type="numeric" required="no" default="0">
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		
		<cfif Arguments.FPCCidPadre EQ -1>
			<cfset Arguments.FPCCidPadre = "null">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsAltaConcepto">
			insert into FPCatConcepto
			(Ecodigo,FPCCcodigo,FPCCdescripcion,FPCCtipo,FPCCconcepto,FPCCcomplementoC,FPCCcomplementoP,FPCCidPadre,BMUsucodigo,FPCCExigeFecha
			 <cfif isdefined('Arguments.FPCCTablaC')>
			 ,FPCCTablaC
			 </cfif>)
			values
			(
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCCcodigo)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCCdescripcion)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCtipo)#" 			null="#LEN(TRIM(Arguments.FPCCtipo)) EQ 0#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCconcepto)#" 		null="#LEN(TRIM(Arguments.FPCCconcepto)) EQ 0#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCCcomplementoC)#" 	null="#LEN(TRIM(Arguments.FPCCcomplementoC)) EQ 0#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCCcomplementoP)#" 	null="#LEN(TRIM(Arguments.FPCCcomplementoP)) EQ 0#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Trim(Arguments.FPCCidPadre)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPCCExigeFecha#">
		  <cfif isdefined('Arguments.FPCCTablaC')>
			,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCTablaC#">
		  </cfif>
			)
		<cf_dbidentity1>
		</cfquery>
			  <cf_dbidentity2 name="rsAltaConcepto">
			  <cfreturn #rsAltaConcepto.identity#>
	</cffunction>
	<!---=======Agrega un nuevo Concepto de Gasto o Ingreso=======--->
	<cffunction name="AltaConcepto"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 		    type="numeric" required="no">
		<cfargument name="FPCcodigo" 	    type="string"  required="yes">
		<cfargument name="FPCdescripcion"  	type="string"  required="yes">
		<cfargument name="FPCCid" 			type="numeric" required="yes">
		<cfargument name="BMUsucodigo"      type="numeric" required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>	
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>	
		<cfif not fnValidaCodigo(Trim(Arguments.FPCcodigo))>
			<cfthrow message="Código ya existe.">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsAltaConcepto">
			insert into FPConcepto
			(Ecodigo,FPCCid,FPCcodigo,FPCdescripcion,BMUsucodigo)
			values
			(
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPCCid#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCcodigo)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCdescripcion)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
			)
		<cf_dbidentity1>
		</cfquery>
			  <cf_dbidentity2 name="rsAltaConcepto">
			  <cfreturn #rsAltaConcepto.identity#>
	</cffunction>
	<!---=======Modifica Clasificacion de Concepto de gasto o Ingreso===============--->
	<cffunction name="CambioClasificacionConcepto" access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 		    type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		<cfargument name="FPCCcodigo" 	    type="string"  required="yes">
		<cfargument name="FPCCdescripcion"  type="string"  required="yes">
		<cfargument name="FPCCtipo" 	    type="string"  required="no">
		<cfargument name="FPCCconcepto"     type="string"  required="no">
		<cfargument name="FPCCcomplementoC" type="string"  required="no">
		<cfargument name="FPCCcomplementoP" type="string"  required="no">
		<cfargument name="FPCCidPadre" 		type="numeric" required="yes" default="-1">
		<cfargument name="FPCCTablaC"       type="numeric" required="no">
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		<cfargument name="ts_rversion"      type="any" 		required="yes">
		<cfargument name="FPCCExigeFecha"   type="numeric" required="no" default="0">
				
		<cfif Arguments.FPCCidPadre EQ -1>
			<cfset Arguments.FPCCidPadre = "null">
		</cfif>
		
		 <cf_dbtimestamp datasource="#Arguments.Conexion#" table="FPCatConcepto"redirect="ClasificacionConcepto.cfm?FPCCid=#Arguments.FPCCid#" timestamp="#Arguments.ts_rversion#"				
			field1="FPCCid" 
			type1="numeric"
			value1="#Arguments.FPCCid#">
		<cfif fnTienenPlantillas(Arguments.Conexion,Arguments.FPCCid)>
			<cfthrow message="La Clasificación no se puede modificar, ya que posee Plantillas asociadas">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
			Update FPCatConcepto set 	 
			 FPCCcodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCCcodigo)#">,
			 FPCCdescripcion 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCCdescripcion)#">,
			 FPCCtipo 			= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCtipo)#" 			null="#LEN(TRIM(Arguments.FPCCtipo)) EQ 0#">,
			 FPCCconcepto 		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCconcepto)#" 		null="#LEN(TRIM(Arguments.FPCCconcepto)) EQ 0#">,
			 FPCCcomplementoC 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCCcomplementoC)#" 	null="#LEN(TRIM(Arguments.FPCCcomplementoC)) EQ 0#">,
			 FPCCcomplementoP 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCCcomplementoP)#" 	null="#LEN(TRIM(Arguments.FPCCcomplementoP)) EQ 0#">,
			 FPCCidPadre 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Trim(Arguments.FPCCidPadre)#">,
			 BMUsucodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">,
			 FPCCExigeFecha		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCExigeFecha#">
			
			,FPCCTablaC			= 
				<cfif isdefined('Arguments.FPCCTablaC')>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCTablaC#">
				<cfelse>
					null
				</cfif>
		    where FPCCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
		</cfquery>
		<cfset hijos = fnCambioHijos(Arguments.FPCCid,Arguments.FPCCtipo,Arguments.FPCCconcepto,Arguments.FPCCExigeFecha,Arguments.BMUsucodigo,Arguments.Conexion)>
	</cffunction>
	<!---=======Modifica un Concepto de gasto o Ingreso===============--->
	<cffunction name="CambioConcepto" access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 		    type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="FPCid" 	    	type="numeric" required="yes">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		<cfargument name="FPCcodigo" 	    type="string"  required="yes">
		<cfargument name="FPCdescripcion"   type="string"  required="yes">
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		<cfargument name="ts_rversion"      type="any" 	   required="yes">
	
		 <cf_dbtimestamp datasource="#Arguments.Conexion#" table="FPConcepto" redirect="ConceptoGI.cfm?FPCid=#Arguments.FPCid#" timestamp="#Arguments.ts_rversion#"				
			field1="FPCid" 
			type1="numeric"
			value1="#Arguments.FPCid#">
		<cfif not fnValidaCodigo(Trim(Arguments.FPCcodigo),FPCid)>
			<cfthrow message="Código ya existe.">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
			Update FPConcepto set 
			 FPCCid			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">,
			 FPCcodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCcodigo)#">,
			 FPCdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCdescripcion)#">,
			 BMUsucodigo 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">
		    where FPCid     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCid#">
		</cfquery>
	</cffunction>
	<!---=======Elimina Clasificacion de Concepto de gasto o Ingreso================--->
	<cffunction name="BajaClasificacionConcepto"  access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		<cfargument name="ts_rversion"      type="any" 	   required="yes">
		<cf_dbtimestamp datasource="#Arguments.Conexion#" table="FPCatConcepto"redirect="ClasificacionConcepto.cfm" timestamp="#Arguments.ts_rversion#"				
			field1="FPCCid" 
			type1="numeric"
			value1="#Arguments.FPCCid#">
		
		<cfif fnEsPadre(Arguments.Conexion,Arguments.FPCCid)>
			<cfthrow message="La Clasificación no se puede eliminar, ya que posee Categorías Hijas">
		</cfif>
		<cfif fnTienenConceptos(Arguments.Conexion,Arguments.FPCCid)>
			<cfthrow message="La Clasificación no se puede eliminar, ya que posee Conceptos asociados">
		</cfif>
		<cfif fnTienenPlantillas(Arguments.Conexion,Arguments.FPCCid)>
			<cfthrow message="La Clasificación no se puede eliminar, ya que posee Plantillas asociadas">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
			delete from FPCatConcepto
				where FPCCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
		</cfquery>
	</cffunction>
	<!---=======Elimina el Concepto de gasto o Ingreso================--->
	<cffunction name="BajaConcepto"  access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPCid" 	    	type="numeric" required="yes">
		<cfargument name="ts_rversion"      type="any" 	   required="yes">
		 <cf_dbtimestamp datasource="#Arguments.Conexion#" table="FPConcepto" redirect="ConceptoGI.cfm" timestamp="#Arguments.ts_rversion#"				
			field1="FPCid" 
			type1="numeric"
			value1="#Arguments.FPCid#">
			
		<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
			delete from FPConcepto
				where FPCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCid#">
		</cfquery>
	</cffunction>
	<!---=======Valida si la Categoria es Padre================--->
	<cffunction name="fnEsPadre"  access="public" returntype="boolean">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsHijos">
			select count(1) cantidad from FPCatConcepto
				where FPCCidPadre = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
		</cfquery>
		<cfif rsHijos.cantidad GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cffunction>
	<!---=======Valida si la Categoria es tienen ya conceptos Asociados================--->
	<cffunction name="fnTienenConceptos"  access="public" returntype="boolean">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsHijos">
			select count(1) cantidad from FPConcepto
				where FPCCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
		</cfquery>
		<cfif rsHijos.cantidad GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cffunction>
	<!---=======Valida si la Categoria tienen ya Plantillas Asociados================--->
	<cffunction name="fnTienenPlantillas"  access="public" returntype="boolean">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsPlantillas">
			select count(1) cantidad from FPDPlantilla
				where FPCCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
		</cfquery>
		<cfif rsPlantillas.cantidad GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cffunction>
	
	<cffunction name="fnCambioHijos" returntype="query" access="private">
		<cfargument name='idPadre'			type='numeric' 	required='true'>
		<cfargument name='tipo'				type='string' 	required='true'>
		<cfargument name='concepto'			type='string' 	required='true'>
		<cfargument name="FPCCExigeFecha"   type="numeric" 	required="no" default="0">
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
	   <cfquery datasource="#Arguments.Conexion#" name="rsSQL">
			select 	FPCCid,
			(select count(1) from FPCatConcepto as hijos where hijos.FPCCidPadre = padre.FPCCid) as hijos
			from FPCatConcepto padre
			where padre.FPCCidPadre = #arguments.idPadre#
			order by padre.FPCCcodigo, padre.FPCCdescripcion
		</cfquery>
		<cfloop query="rsSQL">
			<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
				Update FPCatConcepto set 	 
					FPCCtipo 			= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.tipo)#" 			null="#LEN(TRIM(Arguments.tipo)) EQ 0#">,
					FPCCconcepto		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.concepto)#" 		null="#LEN(TRIM(Arguments.tipo)) EQ 0#">,
					FPCCExigeFecha		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCExigeFecha#">,
					BMUsucodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">
				where FPCCid 			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#FPCCid#">
			</cfquery>
			<cfif hijos>
				<cfset hijos = fnCambioHijos(FPCCid,Arguments.tipo,Arguments.concepto,Arguments.FPCCExigeFecha,Arguments.BMUsucodigo,Arguments.Conexion)>
			</cfif>
		</cfloop>
		<cfreturn rsSQL>
	</cffunction>
	
<cffunction name="fnGetHijos" returntype="query" access="public">
  	<cfargument name='idPadre'	type='numeric' 	required='true'>	
  	<cfquery datasource="#session.dsn#" name="rsSQL">
		select 	FPCCid,FPCCtipo, FPCCcodigo, FPCCidPadre, FPCCconcepto, FPCCTablaC,FPCCdescripcion,FPCCExigeFecha,FPCCcomplementoP,
		(select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #session.Ecodigo# and hijos.FPCCidPadre = FPCatConcepto.FPCCid) as hijos
		from FPCatConcepto as FPCatConcepto
		where Ecodigo = #session.Ecodigo# and FPCCidPadre = #arguments.idPadre#
		order by FPCCcodigo, FPCCdescripcion
	</cfquery>

	<cfreturn rsSQL>
</cffunction>

<cffunction name="fnListaClasificaciones" returntype="string" access="public">
  	<cfargument name='idClasificacion'	type='numeric' 	required='true'>
		<cfparam name="lista" default="">
		<cfset lista &= Arguments.idClasificacion & ','>
		<cfset hijosC = fnGetHijos(Arguments.idClasificacion)>
		<cfif hijosC.recordcount lt 1>
			<cfreturn  Mid(lista,1,len(lista)-1)>
		<cfelse>
			<cfloop query="hijosC">
				<cfif hijos>
					<cfset lista &= fnListaClasificaciones(FPCCid) & ','>
				<cfelse>
					<cfset lista &= FPCCid & ','>
				</cfif>
			</cfloop>
		</cfif>
	<cfreturn Mid(lista,1,len(lista)-1)>
</cffunction>

<cffunction name="fnValidaCodigo" returntype="boolean" access="public">
	<cfargument name="FPCcodigo" 		type="string"  required="yes">
	<cfargument name="FPCid" 			type="numeric"  required="no"><!---Si viene definida es un update--->
	<cfargument name="Ecodigo" 			type="numeric"  required="no">
	<cfargument name="Conexion" 		type="string"  	required="no">
	
	<cfif not isdefined('Arguments.Conexion')>
		<cfset Arguments.Conexion = session.dsn>
	</cfif>
	<cfif not isdefined('Arguments.Ecodigo')>
		<cfset Arguments.Ecodigo = session.Ecodigo>
	</cfif>	
	<cfquery datasource="#Arguments.Conexion#" name="rsFPConcepto">
		select 	FPCcodigo
		from FPConcepto
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
			and FPCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FPCcodigo#"> 
		<cfif isdefined('Arguments.FPCid') and len(trim(Arguments.FPCid)) gt 0><!---Es un update--->
			and FPCid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPCid#">
		</cfif>
	</cfquery>
	<cfif rsFPConcepto.recordcount gt 0>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

</cfcomponent>