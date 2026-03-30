<cfset vDebug = false>

<cfquery datasource="#Arguments.datasource#" name="IClimita">
	select
		ic.ICid, ci.CIid, ci.CIidexceso, ci.CIafectaSBC, ic.ICvalor, round(ic.ICmontores,2) as ICmontores, i.Iid, i.DEid
		, ci.CImontolimite, i.CFid, i.Ifecha, i.Ivalor, ci.CItipo , ci.CItipometodo, ci.CItipolimite
	from CIncidentes ci
		inner join Incidencias i
			on ci.CIid = i.CIid 
			<cfif IsDefined('Arguments.pDEid')>	and i.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"> </cfif>
			<!---and ci.CItipometodo = 4--->
		inner join IncidenciasCalculo ic
			on i.Iid = ic.Iid
			and i.CIid = ic.CIid
	where ci.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		and ci.CIlimitaconcepto = 1 
		and ic.ICfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
	order by ci.CIid, i.Ifecha
</cfquery>


<cfif vDebug>
	<cfdump var="#IClimita#">
</cfif>

<cfif IClimita.recordCount GT 0>
	<cfset vAcumulado = 0>
	<cfset vCIid = 0>
	<cfset vDivideIncidencia = 1>
	
	<cfloop query="IClimita">
		<cfif IClimita.CIid NEQ vCIid>
			<cfset vAcumulado = 0>
			<cfset vCIid = IClimita.CIid >
			<cfset vDivideIncidencia = 1>
		</cfif>
		
		<cfquery datasource="#Arguments.datasource#" name="HIClimita">
			select  coalesce(sum(hic.ICvalor),0) as ICvalor
				from HIncidenciasCalculo hic
					inner join CalendarioPagos cp
						on hic.RCNid = cp.CPid
							and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPperiodo#">
							and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPmes#">
					inner join CIncidentes ci
						on hic.CIid = ci.CIid
						and ci.CItipolimite = 0
				where (hic.CIid = #IClimita.CIidexceso# or hic.CIid = #IClimita.CIid#)
					and hic.DEid = #IClimita.DEid#
		</cfquery>

		<cfset vAcumulado = vAcumulado + IClimita.ICvalor + HIClimita.ICvalor>
		
		<cfif vDebug>
			HIClimita: <cfdump var="#HIClimita#"> <br>
			vDivideIncidencia: <cfdump var="#vDivideIncidencia#"> <br>
			vAcumulado :<cfdump var="#vAcumulado#"> </br>
			vCIid :<cfdump var="#vCIid#"> </br>
			CIid:<cfdump var="#IClimita.ICid#"><br><br><br>
		</cfif>
		
		<cfif IClimita.CItipometodo EQ 4>
			<cfset limite = IClimita.CImontolimite * #SMG(IClimita.DEid)# >
		<cfelse>
			<cfset limite = IClimita.CImontolimite >
		</cfif>

		<cfif HIClimita.ICvalor GT limite >
			<cfset vDivideIncidencia = 0>
		</cfif>

		<cfif vAcumulado GT limite >
			<cfif vDivideIncidencia EQ 1 <!---and  HIClimita.ICvalor EQ 0---> >
			
				<cfset vDivideIncidencia = 0>
						
				<cfset ICvalorN = abs(((vAcumulado - limite))) >
		
				<cfset ICvalorV = abs(ICvalorN - IClimita.ICvalor) >
				<cfset vhora = IClimita.ICmontores / IClimita.ICvalor>
				<cfset vhoraN = vhora * ICvalorN>
				<cfset vhoraV = vhora * ICvalorV>
					
				<!---ljimenez: inserta en la parte 2 de la incidencia en incidenciascalculo para que se refleje en la pantalla--->	
				<cfquery datasource="#Arguments.datasource#" name="rsInsert">	
					insert into IncidenciasCalculo (
					RCNid, DEid, CIid, Iid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion,	ICcalculo, ICbatch,
					ICmontoant, ICmontores, CFid, RHSPEid, ICmontoexentorenta, Mcodigo, ICmontoorigen, BMUsucodigo, RHJid,
					Iusuaprobacion, Ifechaaprobacion, NAP, NRP, Inumdocumento, CFcuenta, CPmes, CPperiodo
					)
					select ic.RCNid, ic.DEid, #IClimita.CIidexceso#, #IClimita.Iid#, ic.ICfecha, #ICvalorN#,
						ic.ICfechasis, ic.Usucodigo, ic.Ulocalizacion, ic.ICcalculo, ic.ICbatch, ic.ICmontoant,
						#vhoraN#, ic.CFid, ic.RHSPEid, ic.ICmontoexentorenta, ic.Mcodigo, ic.ICmontoorigen,
						ic.BMUsucodigo, ic.RHJid, ic.Iusuaprobacion, ic.Ifechaaprobacion, ic.NAP, ic.NRP, ic.Inumdocumento, ic.CFcuenta
						,ic.CPmes, ic.CPperiodo
					from CIncidentes ci
						inner join IncidenciasCalculo ic
							on ci.CIid = ic.CIid
					where ci.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					 and ic.Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IClimita.Iid#"> 
				</cfquery>
				<cfif vDebug>
					rsInsert 
					<cfdump var="#rsInsert#">
				</cfif>
				
				<!---ljimenez: Aca se actualiza el registro de que ya estaba incluido en incidencias calculo--->	
				
				<cfquery datasource="#Arguments.datasource#"> 
					update IncidenciasCalculo set ICvalor = #ICvalorV#, ICmontores = #vhoraV#
						where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IClimita.ICid#"> 
							and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
							and DEid = #IClimita.DEid#
				</cfquery>	
			<cfelse>
				<cfquery datasource="#Arguments.datasource#" name="rsInsert">	
					insert into IncidenciasCalculo (
						RCNid, DEid, CIid, Iid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant,
						ICmontores, CFid, RHSPEid, ICmontoexentorenta, Mcodigo, ICmontoorigen, BMUsucodigo, RHJid, Iusuaprobacion, Ifechaaprobacion,
						NAP, NRP, Inumdocumento, CFcuenta, CPmes, CPperiodo
						)
						select 
							ic.RCNid, ic.DEid, ic.CIid, #IClimita.Iid#, ic.ICfecha, ic.ICvalor, ic.ICfechasis, ic.Usucodigo, ic.Ulocalizacion,
							ic.ICcalculo, ic.ICbatch, ic.ICmontoant, ic.ICmontores, ic.CFid, ic.RHSPEid, ic.ICmontoexentorenta, ic.Mcodigo, ic.ICmontoorigen,
							ic.BMUsucodigo, ic.RHJid, ic.Iusuaprobacion, ic.Ifechaaprobacion, ic.NAP, ic.NRP, ic.Inumdocumento, ic.CFcuenta
							,ic.CPmes, ic.CPperiodo
						from CIncidentes ci
							inner join IncidenciasCalculo ic
								on ci.CIid = ic.CIid
						where ci.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
						 and ic.Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IClimita.Iid#"> 
				</cfquery>

				<cfquery datasource="#Arguments.datasource#" name="xx"> 
					delete from  IncidenciasCalculo
						where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IClimita.ICid#"> 
							and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
							and DEid = #IClimita.DEid#
				</cfquery>	
			</cfif>
		</cfif>
	</cfloop>
	
	
	<cfif vDebug>
		<cfquery datasource="#Arguments.datasource#" name="xx">
			select *
			from  IncidenciasCalculo
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			
		</cfquery>
		IncidenciasCalculo
		<cfdump var="#xx#">
	</cfif>
	
	<cfquery datasource="#Arguments.datasource#" name="xx"> 
		delete from  IncidenciasCalculo
			where ICvalor = 0
				and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
<!---				and DEid = #IClimita.DEid#--->
	</cfquery>	
</cfif>
<cfif vDebug>
	<cfabort>
</cfif>
