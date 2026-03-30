
<!--- Pregunta si Existe el empleado con rol de vendedor --->
<cfif not IsDefined("form.Alta")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
				select coalesce(count(1),0) as existen 
				from RolEmpleadoSNegocios
				where 
				<cfif IsDefined("form.Alta")>
					Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
					and DEid = <cfqueryparam value="#DEid#" cfsqltype="cf_sql_integer">
					and RESNtipoRol	= 2
				<cfelse>
					Ecodigo = <cfqueryparam value="#form.hiden_Ecodigo#" cfsqltype = "cf_sql_integer"> 
					and DEid = <cfqueryparam value="#form.hiden_DEid#" cfsqltype="cf_sql_integer">
					and RESNtipoRol	= 2
				</cfif>  
	</cfquery>
</cfif>

 <cfif IsDefined("form.Cambio")>
 	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAM021"
		redirect="vendedores.cfm"
		timestamp="#form.ts_rversion#"
		field1="FAX04CVD"
		type1="varchar"
		value1="#form.FAX04CVD#">

	<!--- Si el emplado ya existe en la tabla de Rol de Empleados Modifica --->
	<cfif rsExiste.existen NEQ 0>
	<!--- Borra en la tabla de roles de Empleado --->
		<cfquery name="updateRolEmpleado" datasource="#session.DSN#">
			delete from RolEmpleadoSNegocios
					where Ecodigo = <cfqueryparam value="#form.hiden_Ecodigo#" cfsqltype = "cf_sql_integer"> 
					and DEid = <cfqueryparam value="#form.hiden_DEid#" cfsqltype="cf_sql_integer">
					and RESNtipoRol	= 2
			
			insert into RolEmpleadoSNegocios( Ecodigo,DEid,BMUsucodigo,RESNtipoRol)
			values(<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					2)
		</cfquery>
	<!---  --->
	</cfif>
	
	<cfquery name="update" datasource="#session.DSN#">
		update FAM021
		set			
			DEid = <cfqueryparam value="#form.DEid#" cfsqltype="cf_sql_integer">,
			CFid = <cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric">,
			FAM21NOM	= <cfqueryparam value="#form.FAM21NOM#" cfsqltype="cf_sql_varchar">,
			FAM21PUE	= <cfqueryparam value="#form.FAM21PUE#" cfsqltype="cf_sql_varchar">,
			FAM21PAD 	= <cfif isdefined('form.FAM21PAD')> 1, <cfelse> 0, </cfif>
			FAM21PCP 	= <cfif isdefined('form.FAM21PCP')> 1, <cfelse> 0, </cfif>
			FAM21PCO	= <cfqueryparam value="#form.FAM21PCO#" cfsqltype="cf_sql_money">,
			FAM21CDI	= <cfqueryparam value="#form.FAM21CDI#" cfsqltype="cf_sql_smallint">,
			FAM21CED	= <cfqueryparam value="#form.FAM21CED#" cfsqltype="cf_sql_varchar">,
			FAM21SUP	= <cfqueryparam value="#form.FAM21SUP#" cfsqltype="cf_sql_varchar">,	
			BMUsucodigo	= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
			FAM21PSW 	=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAM21PSW#">
		where Ecodigo 	= <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    	and FAX04CVD 	= <cfqueryparam value="#form.FAX04CVD#" cfsqltype= "cf_sql_varchar">
	</cfquery> 
	
<cfelseif IsDefined("form.Baja")>
	
	<!--- Si el emplado existe en la tabla de Rol de Empleados lo borra --->
	<cfif #rsExiste.existen# NEQ 0>
		
		<!--- Borra en la tabla de roles de Empleado --->
		<cfquery datasource="#session.dsn#">
		delete from RolEmpleadoSNegocios
		where Ecodigo = <cfqueryparam value="#form.hiden_Ecodigo#" cfsqltype = "cf_sql_integer"> 
		and DEid = <cfqueryparam value="#form.hiden_DEid#" cfsqltype="cf_sql_integer">
		and RESNtipoRol	= 2
		</cfquery>
		<!---  --->
	</cfif>
	
	<!----- BORRA TANTO LOS VENDEDORES COMO SUS COMISIONES--->	
	<cfquery datasource="#session.dsn#">
		
		delete from FAM022 
		where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		and FAX04CVD = <cfqueryparam value="#form.FAX04CVD#" cfsqltype= "cf_sql_varchar">
				
		delete from FAM021
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
		and FAX04CVD = <cfqueryparam value="#form.FAX04CVD#" cfsqltype= "cf_sql_varchar">
		
	</cfquery>
			
<cfelseif IsDefined("form.Alta")>
	<!--- moneda --->
	<cfquery name="moneda" datasource="#session.DSN#">
		select Mcodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cftransaction>

	<cfif not ( isdefined("form.DEid") and len(trim(form.DEid)) ) >
		<cfquery name="empleado" datasource="#session.DSN#">
			insert into DatosEmpleado(	Ecodigo, 
										NTIcodigo, 
										DEidentificacion, 
										DEnombre, 
										CBcc, 
										Mcodigo, 
										DEcivil, 
										DEfechanac, 
										DEsexo, 
										DEcantdep, 
										DEsistema,
										BMUsucodigo)
			values( #session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">,
					<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM21CED#">,
					<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM21NOM#">,
					'0',
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#moneda.mcodigo#">,
					0,
					'19000101',
					'M',
					0,
					1,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
					
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>	
		<cf_dbidentity2 datasource="#session.DSN#" name="empleado">
		<cfset form.DEid = empleado.identity >
	</cfif>
	
	<cfquery  name="insert_FAM" datasource="#session.dsn#">
	   insert into FAM021 ( Ecodigo,  FAX04CVD, DEid, Usucodigo, CFid, FAM21NOM,   
	   						FAM21PSW, FAM21PUE, FAM21PAD, FAM21PCP,  FAM21PCO,FAM21CDI, 
							FAM21CED, FAM21SUP, BMUsucodigo, fechaalta)
	   values(	
		   		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAX04CVD#">,
			    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">,
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM21NOM#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAM21PSW#">,
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM21PUE#">,
				<cfif isdefined('form.FAM21PAD')>
					1,				
				<cfelse>
					0,
				</cfif>
				<cfif isdefined('form.FAM21PCP')>
					1,				
				<cfelse>
					0,
				</cfif>				
				<cfqueryparam cfsqltype= "cf_sql_money" value="#form.FAM21PCO#">,
				<cfqueryparam cfsqltype= "cf_sql_smallint" value="#form.FAM21CDI#">,
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM21CED#">,
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM21SUP#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
		
		
		
		</cfquery>
		
		<!--- Si el emplado no existe en la tabla de Rol de Empleados lo inserta --->
		<!--- Agrega en la tabla de roles de Empleado --->
		<cfquery name="existe" datasource="#session.DSN#">
			select 1
			from RolEmpleadoSNegocios
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RESNtipoRol = 2
		</cfquery>

		<cfif existe.recordcount eq 0>
			<cfquery name="insert_EmpRol" datasource="#session.dsn#">
				insert into RolEmpleadoSNegocios( Ecodigo, DEid, BMUsucodigo, RESNtipoRol)
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						2)
			</cfquery>
		</cfif>
	</cftransaction>
</cfif>


<form action="vendedores.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="FAX04CVD" type="hidden" value="#form.FAX04CVD#"> 	
		</cfif>
		
		<cfif isdefined('form.Baja') and isDefined('VerificaComision')>
			<input name="FAX04CVD" type="hidden" value="#form.FAX04CVD#"> 	
		</cfif>
		
		<cfif isdefined('form.FAM21CED_F') and len(trim(form.FAM21CED_F))>
			<input type="hidden" name="FAM21CED_F" value="#form.FAM21CED_F#">	
		</cfif>
		
		<cfif isdefined('form.FAM21NOM_F') and len(trim(form.FAM21NOM_F))>
			<input type="hidden" name="FAM21NOM_F" value="#form.FAM21NOM_F#">	
		</cfif>			
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>