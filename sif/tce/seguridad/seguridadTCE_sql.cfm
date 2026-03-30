<cfif isdefined("Form.Alta")>
	<cfquery name="rsUsuarios" datasource="#session.dsn#">
		select count(1) as Total from CBUsuariosTCE
		where  Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Usucodigo#">
	</cfquery>
	
	<cfif #rsUsuarios.Total# eq 0>
		<cfquery name="createCBUsuariosTCE" datasource="#Session.DSN#">
			insert into CBUsuariosTCE
					(	
						Usucodigo,
						BMUsucodigo
					)
	
			values (
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Usucodigo#">, 
						#session.Usucodigo#
					)
				 <cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="createCBUsuariosTCE" verificar_transaccion="false">
		
	<cfelse>
		<cfthrow message="El registro que desea insertar ya existe.">
	</cfif>
	
	<cflocation url="seguridadTCE.cfm?Usucodigo=#form.Usucodigo#&us=#createCBUsuariosTCE.identity#&modo=CAMBIO">	

<cfelseif isdefined("Form.Delete")>

	<cfquery datasource="#Session.DSN#">
		delete from  CBDusuarioTCE
			where CBUid	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.user#">
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		delete from  CBUsuariosTCE
			where CBUid	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.user#">
	</cfquery>
	<cflocation url="seguridadTCE.cfm">	


<cfelseif isdefined("Form.addDet") and len(trim(Form.addDet)) gt 0>
	<cfquery datasource="#Session.DSN#">
		insert into CBDusuarioTCE
		(CBUid, CBTCid, BMUsucodigo, Conciliador, CBDUmovimientos)
		values
			(
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.user#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.id#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
            <cfif isdefined("TCEConciliar")>1<cfelse>0</cfif>,
            <cfif isdefined("TCEConsultar")>1<cfelse>0</cfif>
			) 

	</cfquery>
	
	<cfoutput><cflocation url="seguridadTCE.cfm?Usucodigo=#form.Usucodigo#&usuario=#form.user#&modo=CAMBIO"></cfoutput>	

</cfif>

<cfif isdefined("Form.cambiarD")>
	<cfquery datasource="#Session.DSN#">
        Update CBDusuarioTCE 
        set CBUid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.user#">,
        CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Id#">,
        Conciliador = <cfif isdefined("TCEConciliar")>1<cfelse>0</cfif>,
        CBDUmovimientos = <cfif isdefined("TCEConsultar")>1<cfelse>0</cfif>,
        BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">
        where CBDUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBDUid#">
            and CBUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.user#">
   </cfquery>
   
   <cfoutput><cflocation url="seguridadTCE.cfm?Usucodigo=#form.Usucodigo#&usuario=#form.user#&modo=CAMBIO"></cfoutput>
</cfif>

<cfif isdefined("form.btnBajaDet") and len(trim(form.btnBajaDet))>
    <cfquery datasource="#Session.DSN#">
        delete from  CBDusuarioTCE 
            where CBTCid	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CBTCid#">
                and CBUid	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CBUid#">
    </cfquery>
	<cfoutput><cflocation url="seguridadTCE.cfm?Usucodigo=#form.Usucodigo#&usuario=#form.CBUid#&modo=CAMBIO"></cfoutput>	
</cfif>
	
<cfif isdefined("Form.nuevoD")>
	<cfoutput><cflocation url="seguridadTCE.cfm?Usucodigo=#form.Usucodigo#&usuario=#form.user#&modo=CAMBIO"></cfoutput>
<cfelseif isdefined ("Form.modo") and form.modo eq "CAMBIO">
	<cfoutput><cflocation url="seguridadTCE.cfm?Usucodigo=#form.Usucodigo#&usuario=#form.CBUid#&modo=CAMBIO&CBTCid=#form.CBTCid#&CBDUid=#form.CBDUid#"></cfoutput>
</cfif>


<cflocation url="seguridadTCE.cfm">	
