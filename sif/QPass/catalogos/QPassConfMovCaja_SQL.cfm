<!---NUEVO Movimiento--->
<cfif IsDefined("form.Nuevo")>
	<cflocation url="QPassConfMovCaja.cfm?Nuevo">
</cfif>

<cfif isdefined("Form.Alta")>
    <cfquery name="rsCodigo" datasource="#session.dsn#">
        select 1 from QPMovimiento
        where Ecodigo = #session.Ecodigo#
        and QPMovCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPMovCodigo#">
    </cfquery>
	
	<cfif rsCodigo.recordcount eq 0>
		<cfquery name="insertMovimiento" datasource="#session.dsn#">
			insert into QPMovimiento 
			(
				QPMovCodigo,
				QPMovDescripcion,
				Ecodigo,                   
				BMFecha,                
				BMUsucodigo        
			 )
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPMovCodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPMovDescripcion#">,
				#Session.Ecodigo#,	
				#Now()#,
				#Session.Usucodigo#
			)
			<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
		</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="insertMovimiento" verificar_transaccion="false" returnvariable="QPMovid">
	
		
	<cfif isdefined("form.QPCid") and len(trim(form.QPCid)) GT 0>
		<cfloop delimiters="," list="#form.QPCid#" index="i">
		
		<cfquery name="Cuenta" datasource="#session.dsn#">
			select QPCCuentaContable from QPCausa 
				where Ecodigo = #session.Ecodigo#
				and QPCid = #i#
		</cfquery>	
		<cfset cuenta = #Cuenta.QPCCuentaContable#>	
		
		
			<cfquery name="insert" datasource="#session.dsn#">
				insert into QPCausaxMovimiento 
				(
					QPCid, 
					QPMovid,
					QPCcuenta,
					Ecodigo,      
					BMFecha,   
					BMUsucodigo 
				 )
				values(	
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#QPMovid#">,
					'#cuenta#',
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>
		</cfloop>
	</cfif>
	<cfelse>
		<cfthrow message="El c&oacute;digo a ingresar ya se encuentra registrado">
	</cfif>
		<cflocation url="QPassConfMovCaja.cfm?QPMovid=#QPMovid#" addtoken="no">
	
<cfelseif isdefined("Form.Baja")>
  	<cfquery name="verificaBorrado" datasource="#session.dsn#">
		select count(1) as cantidad  from QPMovimiento a
			inner join QPCausaxMovimiento b
			on a.QPMovid  = b.QPMovid 
			where a.Ecodigo = #session.Ecodigo#
			and b.QPMovid = #form.QPMovid#
	</cfquery>

	<cfif verificaBorrado.cantidad gt 0>
		<cfquery datasource="#session.DSN#">
			delete from QPCausaxMovimiento
			where Ecodigo = #session.Ecodigo#
			  and QPMovid = #form.QPMovid#
		</cfquery>	
	</cfif>
	
	<cfquery datasource="#session.DSN#">
		delete from QPMovimiento
		where Ecodigo = #session.Ecodigo#
		  and QPMovid = #form.QPMovid#
	</cfquery>	
	<cflocation url="QPassConfMovCaja.cfm" addtoken="no">	
	
<cfelseif isdefined("Form.Cambio")>
		<cfquery name="verificaValor" datasource="#session.dsn#">
			select count(1) as Cantidad
            from QPCausaxMovimiento
			where Ecodigo = #session.Ecodigo#
			 and QPMovid = #form.QPMovid#
		</cfquery>
		
		<cfif verificaValor.Cantidad neq ''>
			<cfquery datasource="#session.dsn#">
				delete
				from QPCausaxMovimiento
				where QPMovid = #form.QPMovid#
				and Ecodigo = #session.Ecodigo#
			</cfquery>
		</cfif>	
		
		<cfif isdefined("form.QPCid") and len(trim(form.QPCid)) GT 0>
            <cfloop delimiters="," list="#form.QPCid#" index="i">
			
		<cfquery name="Cuenta" datasource="#session.dsn#">
			select QPCCuentaContable from QPCausa 
				where Ecodigo = #session.Ecodigo#
				and QPCid = #i#
		</cfquery>	
		<cfset cuenta = #Cuenta.QPCCuentaContable#>	
			
                <cfquery name="insert" datasource="#session.dsn#">
                   insert into QPCausaxMovimiento 
				(
					QPCid, 
					QPMovid,
					QPCcuenta,
					Ecodigo,      
					BMFecha,   
					BMUsucodigo 
				 )
				values(	
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#QPMovid#">,
					'#cuenta#',
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
                </cfquery>
            </cfloop>	
        </cfif>	

	<cfquery name="rsUpdate" datasource="#session.DSN#">
		update QPMovimiento
		set QPMovCodigo 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPMovCodigo#">,
			QPMovDescripcion  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPMovDescripcion#">,
			BMFecha           =  #now()#,   
			BMUsucodigo		  =  #Session.Usucodigo#	
		where Ecodigo   = #session.Ecodigo#
		and QPMovid  = #form.QPMovid#
	</cfquery>
	<cflocation url="QPassConfMovCaja.cfm?QPMovid=#form.QPMovid#&pagenum3=#form.Pagina3#">
</cfif>
<cfset form.Modo = "Cambio">
<cflocation url="QPassConfMovCaja.cfm?QPMovid=#form.QPMovid#" addtoken="no">