<!--- 
	BORRA LAS TABLAS TEMPORALES PARA NO DEJAR BASURA EN DISCO
	Se debe usar en el OnRequestEnd.cfm
	Hecho por: Ing. Óscar Bonilla, MBA. 02/AGO/2006
	*	<CF_dbTemp_deletes>
	*
---->
<cfparam name="attributes.drop" default="false" type="boolean">

<cfif isdefined("request.cf_dbtemp_deletes_names")>
	<cfloop list="#request.cf_dbtemp_deletes_names#" index="LvarDbTemp">
		<cfset LvarTemp = listToArray(LvarDbTemp,"|")>
		<cftry>
			<cfquery datasource="#LvarTemp[1]#">
				<cfif Application.dsinfo[LvarTemp[1]].type EQ "db2">
					drop table #LvarTemp[2]#
				<cfelse>
					delete from #LvarTemp[2]#
				</cfif>
			</cfquery>
		<cfcatch type="any"></cfcatch>
		</cftry>
	</cfloop>
	<cfset request.cf_dbtemp_deletes_names = "">
</cfif>
