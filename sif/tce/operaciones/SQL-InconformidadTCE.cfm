<!---Rechazar los movimientos escogidos con inconformidad--->
<cfif IsDefined("form.rechazo")>
 	<cfif IsDefined("form.chk")>
  		<cfloop list="#form.chk#" index="Lvarchk">
 			<cfset chequeadosBancos = ListToArray(Lvarchk,",",false)>
			<cfset LvarEcid = "#ListGetAt(chequeadosBancos[1], 1 ,'|')#"> 
			<cfset CDBlinea = "#ListGetAt(chequeadosBancos[1], 2 ,'|')#"> 
 			<cfquery name="rsUpdateInconformidad" datasource="#Session.DSN#">
				UPDATE  CDBancos SET 
					CDBjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
					CDBinconformidad = 0 
				WHERE 
					Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEcid#">
					and  CDBlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CDBlinea#">
					and  CDBconciliado= <cfqueryparam cfsqltype="cf_sql_char" value="N">
			</cfquery>
 		</cfloop>
	</cfif>
<cfelse>
<!---Actualizar los estados de los movimientos y justificar su inconformidad--->
 	<cfif IsDefined("form.chk")>
    		<cfloop list="#form.chk#" index="Lvarchk">
 			<cfset chequeadosInconforme = ListToArray(Lvarchk,",",false)>
			<cfset LvarEcid = "#ListGetAt(chequeadosInconforme[1], 1 ,'|')#"> 
			<cfset CDBlinea = "#ListGetAt(chequeadosInconforme[1], 2 ,'|')#"> 
			<cfquery name="rsUpdateInconformidad" datasource="#Session.DSN#">
				UPDATE  CDBancos SET 
					CDBjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.justificacion#">,
					CDBinconformidad = 1 
				WHERE 
					Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEcid#">
					and  CDBlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CDBlinea#">
					and  CDBconciliado= <cfqueryparam cfsqltype="cf_sql_char" value="N">
 			</cfquery>
 					
		</cfloop>
	</cfif>
 </cfif>
<cflocation url="TCEInconformidades.cfm?LvarECid=#LvarEcid#">
