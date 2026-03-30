	<cfif isdefined("Form.Alta")>
	<cflock name="consecutivoT_#session.Ecodigo#"  timeout="3" type="exclusive">
		<cfquery name="rsNewDiq" datasource="#session.dsn#">
			select coalesce(max(<cf_dbfunction name="to_integer" args="QPTtrasDocumento">),0) + 1 as newDoc
			from QPassTraslado
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	
		<cfquery name="insertTras" datasource="#session.dsn#">
			insert into QPassTraslado (Usucodigo, Ecodigo, OcodigoOri, OcodigoDest, QPTtrasDocumento, QPTtrasDescripcion, QPTtrasEstado, BMFecha )
				values(
					#session.Usucodigo#,
					#session.Ecodigo#,
					#form.OficinaIni#,
					#form.OficinaDes#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewDiq.newDoc#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPTtrasDescripcion#">,
					0,
					#now()#
					)
			<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="insertTras" verificar_transaccion="false" returnvariable="QPTid">
	</cflock>	
	<cflocation url="TrasladoQPass.cfm?QPTid=#QPTid#" addtoken="no">
<cfelseif isdefined("Form.btnSeleccionar")>
	<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
		<cfloop delimiters="," list="#form.chk#" index="i">
			<cfquery name="insertTRaslado" datasource="#session.dsn#">
				insert into QPassTrasladoOfi 
					(	
						QPTid,
						QPTidTag,
						QPTOEstado, 
						BMFecha
					)
					values
					(
						#form.QPTid#,
						#i#,
						0,
						#now()#
					)
			</cfquery>
		
			<cfquery name="updateEstado" datasource="#session.dsn#">
				update QPassTag
				set QPTEstadoActivacion = 8
				where QPTidTag=#i#
			</cfquery>
		</cfloop>
			<cflocation url="Traslado.cfm?QPTid=#form.QPTid#">
	</cfif>

<cfelseif isdefined("form.btnAceptar")>
	<cfif isdefined("form.QPTid") and len(trim(form.QPTid)) GT 0>
		<cfquery name="rsDoc" datasource="#session.dsn#">
			select QPTidTag from QPassTrasladoOfi
			where QPTid = #form.QPTid#
		</cfquery>
		
	<cftransaction>		
		<cfloop query="rsDoc">
			<cfquery name="InsertMov" datasource="#session.DSN#">
				insert into QPassTagMov 
				(
					QPTidTag, 
					QPTMovtipoMov, 
					QPTNumParte, 
					QPTFechaProduccion, 
					QPTNumSerie, 
					QPTPAN, 
					QPTNumLote, 
					QPTNumPall, 
					QPTEstadoActivacion, 
					Ecodigo, 
					Ocodigo, 
					OcodigoDest, 
					QPidLote, 
					QPidEstado, 
					BMFecha, 
					BMusucodigo
				)
				select
					a.QPTidTag, 
					3, 
					a.QPTNumParte, 
					a.QPTFechaProduccion, 
					a.QPTNumSerie, 
					a.QPTPAN, 
					a.QPTNumLote, 
					a.QPTNumPall, 
					QPTEstadoActivacion, 
					a.Ecodigo, 
					a.Ocodigo, 
					#form.OcodigoDest#, 
					a.QPidLote, 
					a.QPidEstado, 
					#now()#, 
					#session.Usucodigo#
				from QPassTag a
					inner join QPassTrasladoOfi b
					on a.QPTidTag = b.QPTidTag
				where b.QPTid = #form.QPTid#
				and a.QPTidTag = #rsDoc.QPTidTag#
			</cfquery>
		</cfloop>
		
		<cfquery datasource="#session.DSN#">
			update QPassTraslado
				set QPTtrasEstado = 1,
				BMFecha 	= #now()#,
                Usucodigo	= #session.Usucodigo#
				where QPTid=#form.QPTid#
		</cfquery>		
	</cftransaction>	
	</cfif>
<cflocation url="TrasladoQPass.cfm?QPTid=#form.QPTid#">
<cfelseif isdefined("form.BorrarDet") and len(trim(form.BorrarDet))>
	<cfquery name="rsDelete" datasource="#session.DSN#">
		delete from QPassTrasladoOfi
		where  QPTidTag  = #form.BorrarDet#
	</cfquery>	

	<cfquery name="rsDelete" datasource="#session.DSN#">
		update QPassTag
			set QPTEstadoActivacion = 1
			where QPTidTag=#form.BorrarDet#
	</cfquery>	
			<cflocation url="Traslado.cfm?QPTid=#form.QPTid#">
</cfif>
		<cflocation url="TrasladoQPass.cfm" addtoken="no">

<cfset form.Modo = "Cambio">
<cflocation url="Traslado.cfm" addtoken="no">


