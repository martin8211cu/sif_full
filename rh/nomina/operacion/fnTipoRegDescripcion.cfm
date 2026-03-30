<cffunction name="fnTipoRegDescripcion" access="private" output="false" returntype="string">
	<cfargument name="tiporeg" type="string">
	
	<cfif tiporeg EQ "10">
		<cfreturn 'SALARIOS'>
	<cfelseif tiporeg EQ "11">
		<cfreturn 'SALARIOS MES ANTERIOR'>
	<cfelseif tiporeg EQ "20">
		<cfreturn 'INCIDENCIAS'>
	<cfelseif tiporeg EQ "21">
		<cfreturn 'INCIDENCIAS MES ANTERIOR'>
	<cfelseif tiporeg EQ "25">
		<cfreturn 'PAGOS NO REALIZADOS'>
	<cfelseif tiporeg EQ "50">
		<cfreturn 'CARGAS EMPLEADO'>
	<cfelseif tiporeg EQ "60">
		<cfreturn 'DEDUCCIONES'>
	<cfelseif tiporeg EQ "61">
		<cfreturn 'INTERESES DEDUCCIONES'>
	<cfelseif tiporeg EQ "70">
		<cfreturn 'RENTA'>

	<cfelseif tiporeg EQ "30">
		<cfreturn 'CARGAS EMPRESA (GASTO)'>
	<cfelseif tiporeg EQ "31">
		<cfreturn 'CARGAS EMPRESA MES ANTERIOR (GASTO)'>
	<cfelseif tiporeg EQ "40">
		<cfreturn 'CARGAS EMPRESA (CxC)'>
	<cfelseif tiporeg EQ "55">
		<cfreturn 'CARGAS EMPRESA (CxP)'>
	<cfelseif tiporeg EQ "91">		
		<cfreturn 'ACTIVIDAD EMPRESARIAL'>
	</cfif>
</cffunction>
