<cfif isdefined('form.Alta')>
	<cfquery name="valida" datasource="#session.dsn#">
		select EAid from EAnualidad where 
		DEid=#form.DEid# and Ecodigo=#session.Ecodigo#
		and DAtipoConcepto=#form.concepto#
	</cfquery>
	<cfset LvarEAid=#valida.EAid#>

	<cfif valida.recordcount eq 0>
		<cfquery name="rsIn" datasource="#session.dsn#">
			insert into EAnualidad (DEid,EAtotal,Ecodigo,BMfalta,BMUsucodigo,DAtipoConcepto)
			values(#form.DEid#,
					0,
					#session.Ecodigo#,
					#now()#,
					#session.Usucodigo#,
					#form.concepto#
					)
					<cf_dbidentity1 datasource="#session.DSN#" name="rsIn">
		</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="rsIn" returnvariable="id">
		<cfset LvarEAid=#id#>
	</cfif>
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select DAfdesde,DAfhasta from DAnualidad where EAid=#LvarEAid#
	</cfquery>
	
	<cfloop query="rsSQL">
		<cfif form.fdesde gt rsSQL.DAfdesde and form.fdesde lt rsSQL.DAfhasta>
			<cfthrow message="Ya se tiene una anualidad registrada en el rango de fechas">
		</cfif>
	</cfloop>
	<cfquery name="inDet" datasource="#session.dsn#">
		insert into DAnualidad(EAid,DAfdesde,DAfhasta,DAanos,BMfalta,BMUsucodigo,DAtipo,DAtipoConcepto,DAdescripcion)
		values(#LvarEAid#,
				<cfqueryparam cfsqltype="cf_sql_date" value="#form.Fdesde#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#form.Fhasta#">,
				#form.Monto#,
				#now()#,
				#session.Usucodigo#,
				1,
				#form.concepto#,
				'#form.DAdescr#')<!---El tipo 1 me indica que se registro de forma manual--->
	<cf_dbidentity1 datasource="#session.DSN#" name="inDet">
		</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="inDet" returnvariable="LvarDAid">
	<cfset sbUpdateTotal()>
	<cflocation url="expediente-cons.cfm?DEid=#form.DEid#&tab=11&o=11&DAid=#LvarDAid#">
</cfif>

<cfif isdefined('form.Nuevo')>
	<cflocation url="expediente-cons.cfm?DEid=#form.DEid#&tab=11&o=11">
</cfif>

<cfif isdefined('form.Baja')>
	
	<cfquery name="rsDel" datasource="#session.dsn#">
		delete from DAnualidad where DAid=#form.DAid# 
	</cfquery>
	
	<cfset sbUpdateTotal()>
	<cflocation url="expediente-cons.cfm?DEid=#form.DEid#&tab=11&o=11">
</cfif>

<cfif isdefined('form.Cambio')>
	<cfquery name="rsUp" datasource="#session.dsn#">
		update DAnualidad 
			set DAfdesde=<cfqueryparam cfsqltype="cf_sql_date" value="#form.Fdesde#">,
				DAfhasta=<cfqueryparam cfsqltype="cf_sql_date" value="#form.Fhasta#">,
				DAtipoConcepto='#form.concepto#',
				DAanos=#form.Monto#,
				BMFmodificacion=#now()#,
				DAdescripcion='#form.DAdescr#'
		where DAid=#form.DAid# 
	</cfquery>
	<cfset sbUpdateTotal()>
	<cflocation url="expediente-cons.cfm?DEid=#form.DEid#&tab=11&o=11&DAid=#form.DAid#">
</cfif>

<cffunction name="sbUpdateTotal" output="false" access="private">
	<cfquery datasource="#session.dsn#">
		update EAnualidad 
		set EAtotal=(select sum(DAanos) from DAnualidad
					where EAid=EAnualidad.EAid
					and DAtipoConcepto=EAnualidad.DAtipoConcepto)
		where DEid=#form.DEid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
</cffunction>
