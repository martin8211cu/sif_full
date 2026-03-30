<!--- Tag de Cuentas --->
<cfscript>
	GvarUrlToFormParam = "";
	// Parametros del Tag de Cuentas
	fnUrlToFormParam ("form", "");
	fnUrlToFormParam ("id", "");
	fnUrlToFormParam ("idF", "");
	fnUrlToFormParam ("desc", "");
	fnUrlToFormParam ("fmt", "");
	fnUrlToFormParam ("mayor", "");
	fnUrlToFormParam ("movimiento", "N");
	fnUrlToFormParam ("auxiliares", "N");
	fnUrlToFormParam ("Cnx", "#session.DSN#");
	fnUrlToFormParam ("Ecodigo", "#session.Ecodigo#");
	fnUrlToFormParam ("Ocodigo", "-1", "-1");
	fnUrlToFormParam ("CFid", 	 "-1", "-1");
	// Parametros del Filtro 
	fnUrlToFormParam ("Cmayor", "");
	fnUrlToFormParam ("FCuenta", "");
	fnUrlToFormParam ("FDesc", "");
	fnUrlToFormParam ("CFdetalle", "");
	fnUrlToFormParam ("CPVfecha", "#DateFormat(Now(),'DD/MM/YYYY')#");
	fnUrlToFormParam ("Ctipo", "");

	navegacion = GvarUrlToFormParam;
</cfscript>

<cffunction name="fnUrlToFormParam">
	<cfargument name="LprmNombre"  			type="string" required="yes">
	<cfargument name="LprmDefault" 			type="string" required="yes">
	<cfargument name="LprmDefaultOnBlank"	type="string" default="">
	
	<cfparam name="url[LprmNombre]" default="#LprmDefault#">
	<cfparam name="form[LprmNombre]" default="#url[LprmNombre]#">
	<cfif form[LprmNombre] EQ "" AND LprmDefaultOnBlank NEQ "">
		<cfset form[LprmNombre]	= LprmDefaultOnBlank>
	</cfif>
	<cfset url[LprmNombre]	= form[LprmNombre]>
	<cfif isdefined("GvarUrlToFormParam")>
		<cfif len(trim(GvarUrlToFormParam))>
			<cfset GvarUrlToFormParam = GvarUrlToFormParam & "&">
		</cfif>
		<cfset GvarUrlToFormParam = GvarUrlToFormParam & "#LprmNombre#=" & Form[LprmNombre]>
	</cfif>
</cffunction>

<cffunction name="fnComodinToMascara" access="private" output="false">
	<cfargument name="Comodin" type="string" required="yes">

	<cfset var LvarComodines = "?,*,!">

	<cfset var LvarMascara = Arguments.Comodin>
	<cfloop index="LvarChar" list="#LvarComodines#">
		<cfset LvarMascara = replace(LvarMascara,mid(LvarChar,1,1),"_","ALL")>
	</cfloop>

	<cfreturn LvarMascara>
</cffunction>

