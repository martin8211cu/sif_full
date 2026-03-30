<!---***************************************************************************************************----->
<cfif isdefined("Form.Alta")>
	<cfquery name="rsExiste" datasource="#Session.DSN#">
		select Ucodigo 
		from Unidades 
		where Ucodigo = <cfqueryparam  value="#Form.Ucodigo#" cfsqltype="cf_sql_varchar">
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfif rsExiste.recordcount GT 0>
		<cfthrow type="toUser" message="El registro que desea ingresar ya existe.">
		<cflocation url="formUnidades.cfm">
	</cfif>

</cfif>
<!---***************************************************************************************************----->

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into Unidades (Ecodigo, Ucodigo, Udescripcion, Uequivalencia, Utipo)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ucodigo#" >,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Udescripcion#" >,
						<cfqueryparam cfsqltype="cf_sql_float"   value="#Replace(Form.Uequivalencia,',','','all')#" >,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Utipo#" >
				)	
		</cfquery>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsValida" datasource="#Session.DSN#">
			select a.Ucodigo
			from Unidades a
				inner join MIGMetricas c
					on rtrim(a.Ucodigo)=rtrim(c.Ucodigo)
					and a.Ecodigo=c.Ecodigo
			where rtrim(a.Ucodigo) = '#trim(Form.Ucodigo)#'
			and c.Ecodigo = #Session.Ecodigo# 
		</cfquery>
		<cfquery name="rsValida2" datasource="#Session.DSN#">
			select a.Ucodigo
			from Unidades a
				inner join MIGProductos c
					on rtrim(a.Ucodigo)=rtrim(c.id_unidad_medida)
					and a.Ecodigo=c.Ecodigo
			where rtrim(a.Ucodigo) = '#trim(Form.Ucodigo)#'
			and c.Ecodigo = #Session.Ecodigo# 
		</cfquery>
		<cfif rsValida.recordCount GT 0 or rsValida2.recordCount GT 0>	
			<cfthrow type="toUser" message="La Unidad #rsValida.Ucodigo# no puede ser eliminada ya que tiene asociaciones con M&eacute;tricas o Indicadores.">
		<cfelse>
			<cfquery name="delete" datasource="#Session.DSN#">
				delete from Unidades
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and Ucodigo = '#trim(Form.Ucodigo)#'
			</cfquery>
		</cfif>
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="Unidades"
						redirect="Unidades.cfm"
						timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="Ucodigo" 
						type2="char" 
						value2="#form.Ucodigo#"	>

		<cfquery name="update" datasource="#Session.DSN#">
			update Unidades set
				Udescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Udescripcion#" >,
				Uequivalencia = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Form.Uequivalencia,',','','all')#" >,
				Utipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Utipo#" >
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Ucodigo = <cfqueryparam value="#Form.Ucodigo#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cfif>
</cfif>
<!--- Fin del <cfif not isdefined("Form.Nuevo")> --->

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.Ucodigo') and form.Ucodigo NEQ ''>
		<cfset params= params&'&Ucodigo='&form.Ucodigo>	
	</cfif>
</cfif>

<cfif isdefined('form.filtro_Ucodigo') and form.filtro_Ucodigo NEQ ''>
	<cfset params= params&'&filtro_Ucodigo='&form.filtro_Ucodigo>	
	<cfset params= params&'&hfiltro_Ucodigo='&form.filtro_Ucodigo>		
</cfif>
<cfif isdefined('form.filtro_Udescripcion') and form.filtro_Udescripcion NEQ ''>
	<cfset params= params&'&filtro_Udescripcion='&form.filtro_Udescripcion>	
	<cfset params= params&'&hfiltro_Udescripcion='&form.filtro_Udescripcion>		
</cfif>
<cfif isdefined('form.filtro_Uequivalencia') and form.filtro_Uequivalencia NEQ ''>
	<cfset params= params&'&filtro_Uequivalencia='&form.filtro_Uequivalencia>	
	<cfset params= params&'&hfiltro_Uequivalencia='&form.filtro_Uequivalencia>		
</cfif>

<cflocation url="Unidades.cfm?Pagina=#Form.Pagina#&Empresa=#session.Ecodigo##params#">

