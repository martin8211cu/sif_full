<!--- 
	BORRA LAS TABLAS TEMPORALES PARA NO DEJAR BASURA EN DISCO
	Se debe usar en el OnRequestEnd.cfm
	Hecho por: Ing. Óscar Bonilla, MBA. 02/AGO/2006
	*	<CF_dbTemp_deletes>
	*
---->

<cfif isdefined("request.cf_dbtemp_deletes_names")>
	<cfloop list="#request.cf_dbtemp_deletes_names#" index="LvarDbTemp">
		<cfset LvarTemp = listToArray(LvarDbTemp,"|")>
		<cftry>
			<cfquery datasource="#LvarTemp[1]#">
				delete from #LvarTemp[2]#
			</cfquery>
		<cfcatch type="any"></cfcatch>
		</cftry>
	</cfloop>
	<cfset request.cf_dbtemp_deletes_names = "">
</cfif>
