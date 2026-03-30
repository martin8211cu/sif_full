<!--- 
	Creado por Gustavo Fonseca Hernández.
		Fecha: 10-6-2005.
		Motivo: Creación del Mantenimiento para beneficiarios.
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 26-7-2005.
		Motivo: Se incluyen las Cuentas destino del benefiario.	
 --->
<cfset params = ''>
<cfif isdefined('form.fTESbeneficiario') and LEN(TRIM(form.fTESbeneficiario))>
	<cfset params = params & '&fTESbeneficiario=#form.fTESbeneficiario#'>
</cfif>
<cfif isdefined('form.fTESbeneficiarioID') and LEN(TRIM(form.fTESbeneficiarioID))>
	<cfset params = params & '&fTESbeneficiarioID=#form.fTESbeneficiarioID#'>
</cfif>
<cfif isdefined('form.Pagina')>
	<cfset params = params & '&Pagina=#form.Pagina#'>
</cfif>
<cfif IsDefined("form.Cambio")>
	<cfquery datasource="#session.dsn#" name="datos_actuales">
		select id_direccion, TESBid
		from TESbeneficiario
		where TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>

	<cf_sifdireccion action="readform" name="la_direccion">
		<cfset la_direccion.id_direccion = datos_actuales.id_direccion>
	<cf_sifdireccion action="update" key="#datos_actuales.id_direccion#" name="la_direccion" data="#la_direccion#">

	<cf_dbtimestamp
	datasource="#session.DSN#"
	table="TESbeneficiario"
	redirect="Beneficiarios_form.cfm"
	timestamp="#form.ts_rversion#"
	field1="CEcodigo" type1="numeric" value1="#session.CEcodigo#"
	field2="TESBid" type2="numeric" value2="#Form.TESBid#">

	<cftransaction>
    	<cfparam name="form.TESBactivo" default="0">
        <cfquery datasource="#session.dsn#">
            update TESbeneficiario
            set TESBeneficiario		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBeneficiario)#">,
                TESBeneficiarioId	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESBeneficiarioId#">,
                TESRPTCid 	 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#" null="#TESRPTCid EQ ""#">,
                id_direccion		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">,
                TESBtelefono 	    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TESBtelefono#">,
                TESBfax 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TESBFax#">,
                TESBemail 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TESBemail#">,
                TESBactivo 			= <cfqueryparam cfsqltype="cf_sql_bit" value="#Form.TESBactivo#">,
                TESBidentificacion  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TESBidentificacion#">
            where TESBid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
              and CEcodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
        </cfquery>
        <cfquery name="rsSQL" datasource="#session.dsn#">
            select max(TESBfecha) as TESBfecha
             from TESbeneficiarioBitacora
            where TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
        </cfquery>
        <cfquery datasource="#session.dsn#">
            insert into TESbeneficiarioBitacora (
               TESBid,
               TESBtipoId,
               TESBeneficiarioId,
               TESBeneficiario,
               TESRPTCid,
               DEid,
               TESBactivo,
               BMUsucodigo
               )
            select    TESBid,
               TESBtipoId,
               TESBeneficiarioId,
               TESBeneficiario,
               TESRPTCid,
               DEid,
               TESBactivo,
               #session.usucodigo#
            from TESbeneficiario b
           where TESBid = #form.TESBid#
		   <cfif rsSQL.TESBfecha NEQ "">
             and 
                ( select count(1)
                    from TESbeneficiarioBitacora bb
                   where bb.TESBid 					= b.TESBid
                     and bb.TESBfecha 				= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsSQL.TESBfecha#">

                     and bb.TESBtipoId 				= b.TESBtipoId
                     and bb.TESBeneficiarioId		= b.TESBeneficiarioId
                     and bb.TESBeneficiario			= b.TESBeneficiario
                     and coalesce(bb.TESRPTCid,0)	= coalesce(b.TESRPTCid,0)
                     and coalesce(bb.DEid,0)		= coalesce(b.DEid,0)
                     and bb.TESBactivo				= b.TESBactivo
                ) = 0
			</cfif>
        </cfquery>
	</cftransaction>
	<cflocation url="Beneficiarios_form.cfm?TESBId=#URLEncodedFormat(form.TESBId)##params#">
<cfelseif IsDefined("form.Baja")>
		<cfquery datasource="#session.dsn#">
            insert into TESbeneficiarioBitacora (
               TESBid,
               TESBtipoId,
               TESBeneficiarioId,
               TESBeneficiario,
               TESRPTCid,
               DEid,
               TESBactivo,
               BMUsucodigo)
            select TESBid,
               TESBtipoId,
               TESBeneficiarioId,
               TESBeneficiario,
               TESRPTCid,
               DEid,
               TESBactivo,
               BMUsucodigo
            from TESbeneficiario
           where TESBid = #form.TESBid#
		</cfquery>

		<cfquery datasource="#session.dsn#">
			update TESbeneficiario
			set TESBactivo = 0
			where TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"value="#session.CEcodigo#">
		</cfquery>
	<cflocation url="Beneficiarios.cfm?1=1#params#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="Beneficiarios_form.cfm?1=1#params#">
<cfelseif IsDefined("form.Alta")>
	<cf_sifdireccion action="readform" name="la_direccion">
	<cf_sifdireccion action="insert" name="la_direccion" data="#la_direccion#">
	<cftransaction>
    	<cfparam name="form.TESBactivo" default="0">
		<cfquery name="rsInsertaTESbeneficiario" datasource="#session.dsn#">
			insert into TESbeneficiario (
				CEcodigo,
				TESBeneficiarioId,
				TESBeneficiario,
				TESBtipoId, 
				TESRPTCid, 
				id_direccion,
				TESBtelefono, 
				TESBfax, 
				TESBemail,
                TESBactivo,
				BMUsucodigo,
                TESBidentificacion
                <cfif IsDefined("form.DEid") and form.DEid NEQ ''>
                ,DEid
                </cfif>
				)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBeneficiarioId)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBeneficiario)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBtipoId)#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#" null="#TESRPTCid EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">,  
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBtelefono)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBfax)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBemail)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Form.TESBactivo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBidentificacion)#">
                <cfif IsDefined("form.DEid") and form.DEid NEQ ''>
                ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                </cfif>      
				)
				<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.dsn#" name="rsInsertaTESbeneficiario">
		<cfquery datasource="#session.dsn#">
            insert into TESbeneficiarioBitacora (
               TESBid,
               TESBtipoId,
               TESBeneficiarioId,
               TESBeneficiario,
               TESRPTCid,
               DEid,
               TESBactivo,
               BMUsucodigo)
            select    TESBid,
               TESBtipoId,
               TESBeneficiarioId,
               TESBeneficiario,
               TESRPTCid,
               DEid,
               TESBactivo,
               BMUsucodigo
            from TESbeneficiario
           where TESBid = #rsInsertaTESbeneficiario.identity#
		</cfquery>
	</cftransaction>
	
	<cfif isdefined("form.solicitudmanual")>
		<cfquery datasource="#session.DSN#" name="rsSolicitudmanual">
			select TESBeneficiarioId, TESBeneficiario, TESBid
			from TESbeneficiario
			where TESBid = #rsInsertaTESbeneficiario.identity#
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfquery>
		<cfif rsSolicitudmanual.recordcount EQ 1>
			<script language="JavaScript"> 
				if (window.opener != null) {
					<cfoutput>
					window.opener.document.form1.TESBid.value = "<cfoutput>#rsSolicitudmanual.TESBid#</cfoutput>";
					window.opener.document.form1.TESBeneficiarioId.value = "<cfoutput>#rsSolicitudmanual.TESBeneficiarioId#</cfoutput>";
					window.opener.document.form1.TESBeneficiario.value = "<cfoutput>#rsSolicitudmanual.TESBeneficiario#</cfoutput>"; 
					<cfoutput>if (window.opener.funcLimpiaTESBid) {window.opener.funcLimpiaTESBid()}</cfoutput>
					</cfoutput>
					window.close();
				} 
			</script>
		</cfif>
	<cfelseif not isdefined("form.solicitudmanual")>
		<cflocation addtoken="no" url="Beneficiarios_form.cfm?TESBId=#URLEncodedFormat(rsInsertaTESbeneficiario.identity)##params#">
	</cfif>
<cfelse>
	
</cfif>

