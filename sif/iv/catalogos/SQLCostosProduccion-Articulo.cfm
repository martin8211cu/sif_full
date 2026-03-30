
<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<!---- Verificar que no exista un costo asignado para ese periodo y ese mes ----->
		<cfquery name="rsExiste" datasource="#Session.DSN#">
			select 1 
			from CostoProduccionSTD
			where  Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and CTDmes = <cfqueryparam cfsqltype="cf_sql_integer"   value="#Form.CTDmes#">
				and CTDperiodo = <cfqueryparam cfsqltype="cf_sql_integer"   value="#Form.CTDperiodo#">
		</cfquery>
		<cfif rsExiste.RecordCount  GTE 1>			
			<cfset Request.Error.Backs = 1>
			<cf_errorCode	code = "50396" msg = "Ya existe el período y mes de costo para este artículo">
		</cfif>
		<cftransaction>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into CostoProduccionSTD (Aid, Ecodigo, CTDcosto, CTDperiodo, CTDmes, fechaalta, BMUsucodigo)
					values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Form.CTDcosto#" >,						
							<cfqueryparam cfsqltype="cf_sql_integer"   value="#Form.CTDperiodo#" >,
							<cfqueryparam cfsqltype="cf_sql_integer"   value="#Form.CTDmes#" >,	
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,					
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">						
					)	
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		</cftransaction>	
		<cfif isdefined('insert')>
			<cfset form.CTDid=insert.identity>
		</cfif>		
	<cfelseif isdefined("Form.Baja")>
		<!----- Se obtiene el periodo actual----->
		<cfquery name="rsPeriodo" datasource="#Session.DSN#">
			select Pvalor as periodo
			from Parametros
			where Pcodigo = 50
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >				
		</cfquery>
		<!----- Se obtiene el mes actual----->
		<cfquery name="rsMes" datasource="#Session.DSN#">
			select Pvalor as mes
			from Parametros
			where Pcodigo = 60
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >				
		</cfquery>
		
		<!---- Si el periodo(año) a eliminar  es igual al vigente(actual)----->
		<cfif form.CTDperiodo EQ rsPeriodo.periodo>	
			<!---- Si el mes a eliminar es mayor al vigente SI se elimina sino mensaje ----->
			<cfif form.CTDmes GTE rsMes.mes> 
				<cfquery name="delete" datasource="#Session.DSN#">
					delete from CostoProduccionSTD
					where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
						and CTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTDid#">
				</cfquery>						
			<cfelse>
				<cfset Request.Error.Backs = 1>
				<cf_errorCode	code = "50397" msg = "No se puede eliminar el costo porque el período ya fue cerrado">
			</cfif>
		<!--- Si el periodo(año) a eliminar es mayor al periodo vigente(actual) SI se elimina ---->	
		<cfelseif form.CTDperiodo GT rsPeriodo.periodo> 	
			<cfquery name="delete" datasource="#Session.DSN#">
				delete from CostoProduccionSTD
				where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
					and CTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTDid#">
			</cfquery>
		</cfif>		
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="CostoProduccionSTD"
						redirect="CostosProducion-Articulo.cfm"
						timestamp="#form.ts_rversion#"				
						field1="Aid" 
						type1="numeric" 
						value1="#form.Aid#"
						field2="Ecodigo" 
						type2="integer" 
						value2="#session.Ecodigo#"
						field3="CTDid" 
						type3="numeric" 
						value3="#form.CTDid#"
					>

		<cfquery name="update" datasource="#Session.DSN#">
			update CostoProduccionSTD 
			set	CTDcosto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.CTDcosto#" >,
				CTDperiodo = <cfqueryparam cfsqltype="cf_sql_integer"   value="#Form.CTDperiodo#">,
				CTDmes = <cfqueryparam cfsqltype="cf_sql_integer"   value="#Form.CTDmes#" >	
			where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				and CTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTDid#" >
		</cfquery>
		
		<cfset modo="CAMBIO">
	</cfif>
</cfif>


<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja')>
	<cfif isdefined('form.CTDid') and form.CTDid NEQ ''>
		<cfset params= params&'&CTDid='&form.CTDid>	
	</cfif>
</cfif>
<cfif isdefined("form.Pagina4") and len(trim(form.Pagina4))>
	<cfset params= params&'&Pagina4='&form.Pagina4>		
</cfif>
<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>
	<cfset params= params&'&filtro_Acodigo='&form.filtro_Acodigo>	
	<cfset params= params&'&hfiltro_Acodigo='&form.filtro_Acodigo>		
</cfif>
<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>
	<cfset params= params&'&filtro_Acodalterno='&form.filtro_Acodalterno>	
	<cfset params= params&'&hfiltro_Acodalterno='&form.filtro_Acodalterno>	
</cfif>
<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>
	<cfset params= params&'&filtro_Adescripcion='&form.filtro_Adescripcion>	
	<cfset params= params&'&hfiltro_Adescripcion='&form.filtro_Adescripcion>	
</cfif>

<cfif isdefined('form.Regresar')>
	<cflocation url="articulos-lista.cfm?Pagina=#Form.Pagina##params#">
<cfelse>
	<cflocation url="CostosProduccion-Articulo.cfm?Aid=#form.Aid#&Pagina=#Form.Pagina##params#">
</cfif>

