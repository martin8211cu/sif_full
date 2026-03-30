<cfif isdefined('form.BOTON')>
	<cftransaction >
	<cfif form.BOTON EQ 'Eliminar'>
		<cfparam name="form.chk" type="string" default="">
		<cfset ListaChk = ListToArray(form.chk)>
		<cfloop from="1" to="#ArrayLen(ListaChk)#" index="i">
			<cfset dato = ListToArray(ListaChk[i],'|')>			
			<!--- ELIMINA LOS PUNTOS DE LA EVALUACION DEL PLAN DE SUCESION PARA EL EMPLEADO --->
			<cfquery name="rsDelete" datasource="#session.DSN#">
				delete from RHEvalPlanSucesion
				where  RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				  and  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[1]#">
			</cfquery>
			<!--- ELIMINA LOS PUNTOS  DE LA EVALUACION PARA HABILIDADES Y CONOCIMIENTOS DEL PUESTO DEL EMPLEADO --->
			<cfquery name="rsDelete" datasource="#session.DSN#">
				delete from RHEvaluacionComp
				where  RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				  and  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[1]#">
			</cfquery>
			<!--- ELIMINA EL EMPLEADO DE LA RELACION --->		
			<cfquery name="data" datasource="#session.DSN#">
				delete from RHEmpleadosCF 
				where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato[1]#">
			</cfquery>
		</cfloop>
	</cfif>
	</cftransaction>
</cfif>
<cflocation url="actCompetencias.cfm?RHRCid=#FORM.RHRCID#&SEL=5">