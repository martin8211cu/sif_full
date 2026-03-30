<!---- *****************************************************************************************************----->
<cfset params="">

<!---SQL que trae registros cuando el codigo aduanal digitado por el usuario ya existe--->
<cfif isdefined("form.Alta")>
	<cfquery name="rsExiste" datasource="#Session.DSN#">
		select Almcodigo 
		from Almacen
		where Almcodigo = <cfqueryparam value="#form.Almcodigo#" cfsqltype="cf_sql_char">
	</cfquery>
	<cfif rsExiste.recordcount GE 1>
		<cf_errorCode	code = "50394" msg = "El registro que desea ingresar ya existe">
		<cflocation url="formAlmacen.cfm">
	</cfif>
</cfif>

<!--- Si la opcion elegida es la de Modificar un Codigo existente verifica que lo que se esta modificando es el codigo el resto no importa--->
<cfif isdefined("form.Cambio") and form.Almcodigo2 NEQ form.Almcodigo>
	<cfquery name="rsExiste" datasource="#Session.DSN#">
		select Almcodigo 
		from Almacen
		where Almcodigo = <cfqueryparam value="#form.Almcodigo#" cfsqltype="cf_sql_char">
	</cfquery>

	<cfif rsExiste.recordcount GE 1>
		<cf_errorCode	code = "50394" msg = "El registro que desea ingresar ya existe">
		<cflocation url="formAlmacen.cfm">
	</cfif>
</cfif>
<!---- *****************************************************************************************************----->

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert INTO Almacen ( Ecodigo, Almcodigo, Bdescripcion, Bdireccion, Btelefono, Ocodigo, Dcodigo )
							values( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
									<cfqueryparam value="#Form.Almcodigo#" cfsqltype="cf_sql_char">, 
									<cfqueryparam value="#Form.Bdescripcion#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Form.Bdireccion#" cfsqltype="cf_sql_varchar">, 
									<cfqueryparam value="#Form.Btelefono#" cfsqltype="cf_sql_varchar">, 
									<cfqueryparam value="#Form.Ocodigo#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Form.Dcodigo#" cfsqltype="cf_sql_integer"> 
								  )
					 <cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert"> 	
			</cftransaction>
		<cfset Form.Aid = rsInsert.identity>
		<cfset params= params&'&Aid='&form.Aid>
	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#session.DSN#">
			delete from AResponsables
			where Aid = <cfqueryparam value="#Form.Aid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			delete from AlmacenCercano
			where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
		</cfquery>
 
		<cfquery datasource="#session.DSN#">
			delete from Almacen
			where Aid = <cfqueryparam value="#Form.Aid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cf_sifcomplementofinanciero action='delete'
					tabla="Almacen"
					form = "almacen"
					llave="#form.Aid#" />	
	<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="Almacen" 
				redirect="Almacen.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo,integer,#Session.Ecodigo#"
				field2="Aid,numeric,#form.Aid#">			

		<cfquery datasource="#session.DSN#">
			 update Almacen 
			 set Almcodigo    = <cfqueryparam value="#Form.Almcodigo#"    cfsqltype="cf_sql_char">,
				 Bdescripcion = <cfqueryparam value="#Form.Bdescripcion#" cfsqltype="cf_sql_varchar">,
				 Bdireccion   = <cfqueryparam value="#Form.Bdireccion#"   cfsqltype="cf_sql_varchar">,
				 Btelefono    = <cfqueryparam value="#Form.Btelefono#"    cfsqltype="cf_sql_varchar">,
				 Ocodigo      = <cfqueryparam value="#Form.Ocodigo#"      cfsqltype="cf_sql_integer">,
				 Dcodigo      = <cfqueryparam value="#Form.Dcodigo#"      cfsqltype="cf_sql_integer">
			 where Ecodigo = <cfqueryparam value="#Session.Ecodigo#"      cfsqltype="cf_sql_integer">
			   and Aid = <cfqueryparam value="#Form.Aid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<cfif form.Ocodigo NEQ form.Ocodigo2>
			<cfquery datasource="#session.DSN#">
				 update AResponsables set  
					 Ocodigo = <cfqueryparam value="#Form.Ocodigo#" cfsqltype="cf_sql_integer">
				where Aid = <cfqueryparam value="#Form.Aid#" cfsqltype="cf_sql_numeric">
			</cfquery>		
		</cfif>
		
		<cf_sifcomplementofinanciero action='update'
			tabla="Almacen"
			form = "almacen"
			llave="#form.Aid#" />
			
			<cfset params= params&'&Aid='&form.Aid>
	</cfif>
</cfif>

<cfif isdefined('form.filtro_Almcodigo') and form.filtro_Almcodigo NEQ ''>
	<cfset params= params&'&filtro_Almcodigo='&form.filtro_Almcodigo>	
	<cfset params= params&'&hfiltro_Almcodigo='&form.filtro_Almcodigo>		
</cfif>
<cfif isdefined('form.filtro_Bdescripcion') and form.filtro_Bdescripcion NEQ ''>
	<cfset params= params&'&filtro_Bdescripcion='&form.filtro_Bdescripcion>	
	<cfset params= params&'&hfiltro_Bdescripcion='&form.filtro_Bdescripcion>	
</cfif>		

<cflocation url="Almacen.cfm?Pagina=#Form.Pagina##params#">



