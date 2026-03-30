<!---<cf_dump var="#form#">
NUEVO Convenio--->
<cfif IsDefined("form.Nuevo")>
	<cflocation url="QPassConvenio.cfm?Nuevo">
</cfif>

<cfif isdefined("Form.Alta")>
    <cfquery name="rsCodigo" datasource="#session.dsn#">
        select 1 from QPventaConvenio
        where Ecodigo = #session.Ecodigo#
        and QPvtaConvCod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPvtaConvCod#">
    </cfquery>
	
	<cfif rsCodigo.recordcount eq 0>
		<cfset conTexto= Replace(form.QPvtaConvCont,'<p>&nbsp;</p>','','all')>
		<cfset conTexto= Replace(conTexto,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>
	
	
		<cfquery name="insertConvenio" datasource="#session.dsn#">
			insert into QPventaConvenio 
			(
				QPvtaConvCod,  
				QPvtaConvDesc,   
				QPvtaConvFecIni,       
				QPvtaConvFecFin,      
				QPvtaConvPrecioTag,         
				QPvtaConvMembrecia,       
				QPvtaConvFrecuencia,       
				QPvtaConvCambio,             
				QPvtaConvCuotasCambio,
				QPvtaConvPrecioReinstal,
				QPvtaConvPrecioRepos,  
				QPvtaConvPrecioControv,
				Mcodigo,        
				BMusucodigo,    
				BMFecha, 
				QPvtaConvCont,       
				Ecodigo,
                QPvtaConvTipo     
			 )
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPvtaConvCod#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPvtaConvDesc#">,
				<cfqueryparam cfsqltype="cf_sql_date"	 value="#LSParseDateTime(form.QPvtaConvFecIni)#">,
				<cfqueryparam cfsqltype="cf_sql_date"	 value="#LSParseDateTime(form.QPvtaConvFecFin)#">,
				0,
				0,	
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.QPvtaConvFrecuencia#">,	
				0,	
				1,	
				0,	
				0,	
				0,	
				1,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(conTexto)#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                #form.QPvtaConvTipo#
			)
			<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
		</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="insertConvenio" verificar_transaccion="false" returnvariable="QPvtaConvid">

	
	<cfif isdefined("form.QPCid") and len(trim(form.QPCid)) GT 0>
		<cfloop delimiters="," list="#form.QPCid#" index="i">
			<cfquery name="insert" datasource="#session.dsn#">
				insert into QPCausaxConvenio 
				(
					QPvtaConvid,     
					QPCid,           
					Ecodigo,        
					BMFecha,     
					BMUsucodigo 
				 )
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#QPvtaConvid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
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
		<cflocation url="QPassConvenio.cfm?QPvtaConvid=#QPvtaConvid#" addtoken="no">
	
<cfelseif isdefined("Form.Baja")>

	<cfquery name="verificaBorrado" datasource="#session.dsn#">
		select count(1) as cantidad  from QPventaConvenio a
			inner join QPventaTags v 
				on a.QPvtaConvid = v.QPvtaConvid
			inner join QPCausaxConvenio b
				on a.QPvtaConvid = b.QPvtaConvid
			inner join QPCausa c
				on b.QPCid = c.QPCid
			where a.Ecodigo = #session.Ecodigo#
			and b.QPvtaConvid = #form.QPvtaConvid#
	</cfquery>
	<cfif verificaBorrado.cantidad eq 0>
		<cfquery datasource="#session.DSN#">
			delete from QPCausaxConvenio
			where Ecodigo = #session.Ecodigo#
			  and QPvtaConvid = #form.QPvtaConvid#
		</cfquery>	
		<cfquery datasource="#session.DSN#">
			delete from QPventaConvenio
			where Ecodigo = #session.Ecodigo#
			  and QPvtaConvid = #form.QPvtaConvid#
		</cfquery>
	<cfelse>
		<cfthrow message="No se puede eliminar el convenio num: #form.QPvtaConvCod# porque tiene ventas asociadas">
	</cfif>	
	<cflocation url="QPassConvenio.cfm" addtoken="no">	

	
<cfelseif isdefined("form.Cambio")>
	
		<cfquery name="verificaValor" datasource="#session.dsn#">
			select count(1) as Cantidad
            from QPCausaxConvenio
			where Ecodigo = #session.Ecodigo#
			 and QPvtaConvid = #form.QPvtaConvid#
		</cfquery>
		
		<cfif verificaValor.Cantidad neq ''>
			<cfquery datasource="#session.dsn#">
				delete
				from QPCausaxConvenio
				where QPvtaConvid = #form.QPvtaConvid#
				and Ecodigo = #session.Ecodigo#
			</cfquery>
		</cfif>	
		<cfif isdefined("form.QPCid") and len(trim(form.QPCid)) GT 0>
            <cfloop delimiters="," list="#form.QPCid#" index="i">
                <cfquery name="insert" datasource="#session.dsn#">
                    insert into QPCausaxConvenio 
                    (
                        QPvtaConvid,     
                        QPCid,           
                        Ecodigo,        
                        BMFecha,     
                        BMUsucodigo 
                     )
                    values(
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#QPvtaConvid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                        #now()#,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                    )
                </cfquery>
            </cfloop>	
        </cfif>	

	<cfquery name="rsCodigo" datasource="#session.dsn#">
        select 1 from QPventaConvenio
        where Ecodigo = #session.Ecodigo#
        and QPvtaConvCod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPvtaConvCod#">
    </cfquery>
	<cfset conTexto= Replace(form.QPvtaConvCont,'<p>&nbsp;</p>','','all')>
    <cfset conTexto= Replace(conTexto,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>
	<cfquery datasource="#session.DSN#">
		update QPventaConvenio
		set 
		<cfif rsCodigo.recordcount eq 0>
			QPvtaConvCod			=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPvtaConvCod#">,
		</cfif>
			QPvtaConvDesc			=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPvtaConvDesc#">,
			QPvtaConvFecIni  		=  #LSParseDateTime(form.QPvtaConvFecIni)#,      
			QPvtaConvFecFin  		=  #LSParseDateTime(form.QPvtaConvFecFin)#,
            QPvtaConvTipo  			=  #form.qpvtaconvtipo#,
			QPvtaConvFrecuencia 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.QPvtaConvFrecuencia#">,     
			BMusucodigo 			=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
			QPvtaConvCont 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(conTexto)#">
		where Ecodigo   = #session.Ecodigo#
		and QPvtaConvid = #form.QPvtaConvid#
	</cfquery>
	
	<cflocation url="QPassConvenio.cfm?QPvtaConvid=#form.QPvtaConvid#" addtoken="no">
</cfif>

<cfset form.Modo = "Cambio">
<cflocation url="QPassConvenio.cfm?QPvtaConvid=#form.QPvtaConvid#" addtoken="no">