<!----1. Verificar que exista la competencia para el puesto---->
<cfquery name="rsVPuesto" datasource="#session.DSN#">
	select a.peso,
			a.pesojefe,
			a.codigopuesto
	from  #table_name# a
		inner join RHPuestos d
			on a.codigopuesto = d.RHPcodigo
			and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
</cfquery>

<cfif rsVPuesto.RecordCount EQ 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'El codigo de puesto indicado no existe.'
		from dual
	</cfquery>
<cfelse>
	<cfquery name="rsVCompetencia" datasource="#session.DSN#">
		<!----Habilidades--->
		select 	d.RHHid, 
				null as RHCid,
				a.peso,
				a.pesojefe,
				a.codigopuesto
		from  #table_name# a
			inner join RHPuestos x
				on x.RHPcodigo = a.codigopuesto
				and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
			inner join RHHabilidadesPuesto b
				on x.RHPcodigo = b.RHPcodigo
				and x.Ecodigo = b.Ecodigo
			inner join RHHabilidades d
				on b.RHHid = d.RHHid
				and b.Ecodigo = d.Ecodigo				
				and d.RHHcodigo = a.codigocompetencia	
		
		union
		
		<!---Competencias---->
		select 	null as RHHid, 
				d.RHCid,
				a.peso,
				a.pesojefe,
				a.codigopuesto
		from  #table_name# a
			inner join RHPuestos x
				on x.RHPcodigo = a.codigopuesto
				and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			inner join RHConocimientosPuesto b
				on x.RHPcodigo = b.RHPcodigo
				and x.Ecodigo = b.Ecodigo
			inner join RHConocimientos d
				on b.RHCid = d.RHCid
				and b.Ecodigo = d.Ecodigo
				and d.RHCcodigo = a.codigocompetencia											
	</cfquery>
	
	<cfif rsVCompetencia.RecordCount NEQ 0 and ( len(trim(rsVCompetencia.RHHid)) NEQ 0 or len(trim(rsVCompetencia.RHCid)) NEQ 0 )>
		<cfloop query="rsVCompetencia"><!----Procesar las filas del excel---->
			<cfif len(trim(rsVCompetencia.RHHid))><!----Es una habilidad---->
				<cfquery datasource="#session.DSN#">
					update RHHabilidadesPuesto 
						set RHHpeso = <cfqueryparam cfsqltype="cf_sql_money" value="#rsVCompetencia.peso#">
							,RHHpesoJefe = <cfqueryparam cfsqltype="cf_sql_money" value="#rsVCompetencia.pesojefe#">
					where RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVCompetencia.RHHid#">
						and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVCompetencia.codigopuesto#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			<cfelseif len(trim(rsVCompetencia.RHCid))><!----Es un conocimiento---->
				<cfquery datasource="#session.DSN#">
					update RHConocimientosPuesto
						set RHCpeso = <cfqueryparam cfsqltype="cf_sql_money" value="#rsVCompetencia.peso#">
					where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVCompetencia.RHCid#">
						and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVCompetencia.codigopuesto#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>
			</cfif>
		</cfloop>
	<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			select 'La competencia no existe, o no esta asociada al puesto indicado.'
			from dual
		</cfquery>	
	</cfif>
</cfif>

