<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>
<!---
	Autor Ing. Óscar Bonilla, MBA, 2-AGO-2006
	*
	* Implementa la condición SQL para una lista de valores aunque sean muchos valores (SQL tiene una limitación en la 
	*	cantidad de valores dentro de un IN (lista_valores).
	* Por default los valores son numéricos. El cfsqltype son los del <cfqueryparam>
	* Esta función es muy util, por ejemplo, para procesar masivamente todos los chkBoxes escogidos en el form.
	*
	* Utilización:
	*	<CF_whereInList column="CAMPO" valueList="1,2,3,..." cfSQLtype="cf_sql_integer">
	*		genera: (CAMPO in (1,2,3) OR CAMPO in (...))
	* Si el campo es STRING (por ejemplo cfSQLtype="cf_sql_char"), los valores no deben enviarse entre apóstrofes
	*
--->
<cfparam name="Attributes.Column"			type="String">				 <!--- Nombre del Campo (incluye alias) --->
<cfparam name="Attributes.ValueList"		type="String">				 <!--- Lista de Valores --->
<cfparam name="Attributes.cfsqltype" 		type="string" default="cf_sql_integer">
<cfparam name="Attributes.returnVariable"	type="String" default="">	 <!--- Nombre Variable --->
</cfsilent> 
<cfif Attributes.returnVariable EQ "">
	<cfoutput>#fnWhereInList(Attributes.Column, Attributes.valueList,Attributes.cfsqltype)#</cfoutput>
<cfelse>
	<cfset caller[Attributes.returnVariable] = fnWhereInList(Attributes.Column, Attributes.valueList,Attributes.cfsqltype)>
</cfif>
<cffunction name="fnWhereInList" output="false" access="private">
	<cfargument name="name"			required="yes" type="string">
	<cfargument name="values"		required="yes" type="string">
	<cfargument name="cfsqltype"	required="yes" type="string">

	<cfset LvarValues = listToArray(Arguments.values)>
	<cfif arrayLen (LvarValues) EQ 0>
		<cfreturn "#Arguments.name# is NULL">
	<cfelseif arrayLen (LvarValues) EQ 1>
		<CF_JDBCquery_param cfsqltype="#cfsqltype#" value="#LvarValues[1]#" returnVariable="LvarValor">
		<cfreturn "#Arguments.name# = #LvarValor#">
	</cfif>
	<cfset LvarWhere = createObject("java","java.lang.StringBuffer")>
	<cfloop index="LvarIdx" from="1" to="#ArrayLen(LvarValues)#">
		<cfif LvarIdx EQ 1>
			<cfset LvarWhere.append(" (#Arguments.name# in (")>
		<cfelseif (LvarIdx mod 10) EQ 1>
			<cfset LvarWhere.append(") or #Arguments.name# in (")>
		<cfelse>
			<cfset LvarWhere.append(",")>
		</cfif>
		<CF_JDBCquery_param cfsqltype="#cfsqltype#" value="#LvarValues[LvarIdx]#" returnVariable="LvarValor">
		<cfset LvarWhere.append("#LvarValor#")>
	</cfloop>
	<cfset LvarWhere.append("))")>

	<cfreturn LvarWhere.toString()>
</cffunction>
