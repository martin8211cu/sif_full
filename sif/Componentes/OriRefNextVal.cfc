<!---
	Autor: Ing. Óscar Bonilla, MBA.
	*
	* Permite crear números de documento únicos por Ecodigo+ORI+REF, sin bloquear la transacción (utiliza jdbc_query)
	* Si no existe el Ecodigo+ORI+REF, lo crea y devuelve el número de documento 1.
	* 
	* Utilización:
	*	<cfinvoke	component		= "sif.Componentes.OriRefNextVal"
	*				method			= "nextVal"
	*				returnvariable	= "LvarDocumento"
	*			
	*				Ecodigo			= "1"
	*				ORI				= "CGDC"
	*				REF				= "2006-01-AS"
	*				datasource		= "minisif"
	*	/>
--->
<cfcomponent> 
	<cffunction name="nextVal" access="public" returntype="numeric">
		<cfargument name="ORI"				type="string"	required="yes">
		<cfargument name="REF"				type="string"	required="yes">
		<cfargument name="Ecodigo"			type="numeric"	required="no" default="#session.Ecodigo#">
		<cfargument name="datasource"		type="string"	required="no" default="#session.DSN#">

		<cfset var rsSQL = 0>
		<cfset var LvarNextVal = 0>

		<cflock scope="server" type="exclusive" timeout="2" throwontimeout="yes">
			<cftry>
				<cf_jdbcquery_open name="rsSQL" datasource="#Arguments.datasource#">
					<cfoutput>
					select ORNlastVal
					  from OriRefNextVal
					 where Ecodigo			= #fnSQLnumeric(Arguments.Ecodigo)#
					   and Oorigen			= #fnSQLchar(Arguments.ORI)#
					   and ORNreferencia	= #fnSQLchar(Arguments.REF)#
					</cfoutput>
				</cf_jdbcquery_open>

				<cfset LvarLastVal = "">
				<cfoutput query="rsSQL">
					<cfset LvarLastVal = ORNlastVal>
				</cfoutput>
				<cfif LvarLastVal NEQ "">
					<cfset LvarNextVal = LvarLastVal + 1>
					<cf_jdbcquery_open name="rsSQL" update="yes" datasource="#Arguments.datasource#">
						<cfoutput>
						update OriRefNextVal
						   set ORNlastVal		= #fnSQLnumeric(LvarNextVal)#
						 where Ecodigo			= #fnSQLnumeric(Arguments.Ecodigo)#
						   and Oorigen			= #fnSQLchar(Arguments.ORI)#
						   and ORNreferencia	= #fnSQLchar(Arguments.REF)#
						</cfoutput>
					</cf_jdbcquery_open>
				<cfelse>
					<cfset LvarNextVal = 1>
					<cf_jdbcquery_open name="rsSQL" datasource="#Arguments.datasource#">
						<cfoutput>
						select Oorigen
						  from Origenes
						 where Oorigen = #fnSQLchar(Arguments.ORI)#
						</cfoutput>
					</cf_jdbcquery_open>

					<cfset LvarOorigen = "">
					<cfoutput query="rsSQL">
						<cfset LvarOorigen = Oorigen>
					</cfoutput>

					<cfif LvarOorigen EQ "">
						<cf_errorCode	code = "51236"
										msg  = "No existe Origen='@errorDat_1@'"
										errorDat_1="#Arguments.ORI#"
						>
					</cfif>
					<cf_jdbcquery_open name="rsSQL" update="yes" datasource="#Arguments.datasource#">
						<cfoutput>
						insert into OriRefNextVal
							(Ecodigo, Oorigen, ORNreferencia, ORNlastVal)
						values (
								#fnSQLnumeric(Arguments.Ecodigo)#,
								#fnSQLchar(Arguments.ORI)#,
								#fnSQLchar(Arguments.REF)#,
								1
							)
						</cfoutput>
					</cf_jdbcquery_open>
				</cfif>
				<cf_jdbcquery_close>
			<cfcatch type="any">
				<cf_jdbcquery_close>
				<cfrethrow>
			</cfcatch>
			</cftry>
		</cflock>
		
		<cfreturn LvarNextVal>
	</cffunction>

	<cffunction name="fnSQLnumeric" access="private" returntype="string">
		<cfargument name="valor" type="string"	required="yes">
		
		<cfif NOT isnumeric(Arguments.valor)>
			<cf_errorCode	code = "51237"
							msg  = "El valor '@errorDat_1@' no es tipo numeric"
							errorDat_1="#Arguments.valor#"
			>
		</cfif>
		
		<cfreturn replace(rtrim(Arguments.valor),",","","ALL")>
	</cffunction>

	<cffunction name="fnSQLchar" access="private" returntype="string">
		<cfargument name="valor" type="string"	required="yes">
		
		<cfreturn "'#replace(rtrim(Arguments.valor),"'","''","ALL")#'">
	</cffunction>
</cfcomponent>

