<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 23 de agosto del 2005
	Motivo: Correccion del titulo de la forma, cuando entraba por CxP dejaba el titulo "Cuentas por Cobrar".
			Esto porque solo existen un proceso de neteo de documentos y este se encuentra dentro de la carpeta 
			de CxC. Creando un archivo dentro de CxP y haciendo la llamada del proceso, hace la corrección. Además 
			cambios en la seguridad de CxP.
			Se cambia la direccion de retorno condicionado a el modulo en q me encuentro. 
			Utilizando la variable de session modulo.
 --->

<cfset params = "">
<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
	<cfset params = params & "&Fecha_F=#form.Fecha_F#">
</cfif>
<cfif isdefined("form.DocumentoNeteo_F") and LEN(TRIM(form.DocumentoNeteo_F))>
	<cfset params = params & "&DocumentoNeteo_F=#form.DocumentoNeteo_F#">
</cfif>
<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
	<cfset params = params & "&SNcodigo_F=#form.SNcodigo_F#">
</cfif>
<cfif isdefined("form.Altacxc")>
	<cftry>
	<cfquery name="rsInsert" datasource="#session.dsn#">
		insert into DocumentoNeteoDCxC
		(
			idDocumentoNeteo, Ecodigo, CCTcodigo, Ddocumento, BMUsucodigo, 
			Dmonto, DmontoRet
		)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Ddocumento#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfif isdefined("form.DmontoDocCxC")>
				<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoDocCxC,",","","ALL") - replace(form.DmontoRetCxC,",","","ALL")#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoRetCxC,",","","ALL")#">
			<cfelse>
<!---				<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmonto#">,--->
               	<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.Dmonto,",","","ALL")#">,
				0
			</cfif>
		)
	</cfquery>
		<cfcatch type = "Database">
			<!--- TODO --->
		</cfcatch>
	</cftry>
<cfelseif isdefined("form.Cambiocxc")>
	<cfquery datasource="#session.dsn#">
		update DocumentoNeteoDCxC
		set CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#"> 
			, Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ddocumento#"> 
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			<cfif isdefined("DmontoDocCxC")>
				, Dmonto	= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoDocCxC,",","","ALL") - replace(form.DmontoRetCxC,",","","ALL")#">
				, DmontoRet	= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.DmontoRetCxC,",","","ALL")#">
			<cfelse>
				, Dmonto	= <cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmonto#"> 
				, DmontoRet	= 0
			</cfif>
		where idDetalle = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDetalle#">
		  and idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfelseif isdefined("form.Bajacxc")>
	<cfquery datasource="#session.dsn#">
		delete from DocumentoNeteoDCxC
		where idDetalle = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDetalle#">
		  and idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>
<cfquery datasource="#session.dsn#">
	update DocumentoNeteo
	set Dmonto =
		coalesce(	
				(select sum(a.Dmonto * case when b.CCTtipo = 'D' then 1 else -1 end)
				from DocumentoNeteoDCxC a, CCTransacciones b 
				where a.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
					and b.CCTcodigo = a.CCTcodigo 
					and b.Ecodigo = a.Ecodigo), 0.00)
		+
		coalesce(	
				(select sum(a.Dmonto * case when b.CPTtipo = 'D' then 1 else -1 end)
				from DocumentoNeteoDCxP a, EDocumentosCP d, CPTransacciones b 
				where a.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
					and d.IDdocumento = a.idDocumento 
					and b.Ecodigo = d.Ecodigo
					and b.CPTcodigo = d.CPTcodigo), 0.00)
	where idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>
<cflocation url="../../#lcase(Session.monitoreo.smcodigo)#/operacion/Neteo#form.TipoNeteo#.cfm?idDocumentoNeteo=#form.idDocumentoNeteo##params#">