<cfscript>
	bcheck1 = false; // Checa Centro Funcional
	bcheck2 = false; // Checa Total de los porcentaje
	bcheck3 = false; // Checa Centro Funcional Duplicado
	bcheck4 = false; // Valida que no existan registros introducidos a mano.
</cfscript>

<!--- Checa Centro Funcional--->
<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select count(1) as check1
		from #table_name# a
		where not exists(
			select 1
			from CFuncional b
			where b.CFcodigo = a.CFcodigo
			and b.Ecodigo = #Session.Ecodigo#
		)
</cfquery>
<cfset bcheck1 = rsCheck1.check1 LT 1>

<!--- Checa Total de los porcentaje--->
<cfif bcheck1>
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select count(1) as check2
		from #table_name# a
		having convert(integer,round(sum(Porcentaje),0)) != 100
</cfquery>
<cfset bcheck2 = rsCheck2.check2 LT 1>
</cfif>

<!----Checa Centro Funcional Duplicado---->
<cfif bcheck2>
<cfquery name="rsCheck3" datasource="#Session.DSN#">
		select count(1) as check3
		from #table_name# 		
		group by CFcodigo having count(CFcodigo) > 1
</cfquery>
	<cfset bcheck3 = rsCheck3.check3 LT 1>
</cfif>
 
<!----Valida que no existan registros introducidos a mano.--->
<cfif bcheck3>
	<cfquery name="rsCheck4" datasource="#Session.DSN#">
		select count(1) as check4
		from #table_name# 		
		where exists (select 1 
		from CPDistribucionCostosCF
		where CPDCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CPDCid#">)
	</cfquery>
	<cfset bcheck4 = rsCheck4.check4 LT 1>
</cfif>

<cfif bcheck4>
	
	<cftransaction action="begin">
	<cftry>	
		<cfquery name="rsRegistros" datasource="#Session.DSN#">
			select CFcodigo, Porcentaje, VDefault
			from #table_name# 
		</cfquery>
	
		<cfloop query="rsRegistros">
			<!---Se obtiene el Id del Centro Funcional--->
			<cfquery name="rsCF" datasource="#Session.DSN#">
				select CFid
				from CFuncional
				where CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRegistros.CFcodigo#"> 
			</cfquery>
			
			<cfset varCF = rsCF.CFid>
			
			<cfquery datasource="#Session.DSN#">
				insert into CPDistribucionCostosCF(
					CPDCid,
					CFid,
					CPDCCFporc,
					CPDCCFdefault)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.CPDCid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#rsRegistros.Porcentaje#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#rsRegistros.VDefault#">)
			</cfquery>
			
			<cfquery datasource="#Session.DSN#">
				update CPDistribucionCostos set CPDCporcTotal = 100
				where CPDCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CPDCid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
		</cfloop> 	
	<cftransaction action="commit"/>
	<cfcatch>
	<cftransaction action="rollback"/>
		<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
		<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
	    <cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	</cfcatch>
	</cftry>
	</cftransaction>
<cfelse>
	<cfif not bcheck1>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'El código del Centro Funcional no existe' as MSG, a.CFcodigo as CENTRO_FUNCIONAL
			from #table_name# a
			where not exists(
				select 1
				from CFuncional b
				where b.CFcodigo = a.CFcodigo
				and b.Ecodigo = #Session.Ecodigo#
			)
		</cfquery>

	<cfelseif not bcheck2>
		<cfquery name="ERR" datasource="#session.DSN#">
			select 'La sumatoria del porcentaje es incorrecta.' as MSG, round(sum(Porcentaje),0) as PORCENTAJE
			from #table_name# 				
		</cfquery>
		
	<cfelseif not bcheck3>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'El Centro Funcional esta mas de una vez en la distribución.' as MSG, a.CFcodigo as CENTRO_FUNCIONAL
			from #table_name# a  			
			where CFcodigo in (select CFcodigo from #table_name#
			group by CFcodigo having count(CFcodigo) > 1)
		</cfquery>
		
	<cfelseif not bcheck4>
		<cfquery name="ERR" datasource="#session.DSN#">
			select 'Debe eliminar registros insertados manualmente' as MSG
		</cfquery>
	</cfif>
</cfif>

