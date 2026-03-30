<script language="javascript" type="text/javascript">
	<!--//
		window.cambio = true;
		window.parent.HDdocumento.value = "";
		window.parent.Ddocumento.value = "";
		window.parent.idDocumento.value = "";			
		window.parent.EDsaldo.value = "0.00";
		window.parent.Dmonto.value = "0.00";
	//-->
</script>
<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo)) GT 0
	and isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) GT 0
	and isdefined("url.Mcodigo") and len(trim(url.Mcodigo)) GT 0
	and isdefined("url.Ddocumento") and len(trim(url.Ddocumento)) GT 0
>
	<cfquery name="rs" datasource="#session.dsn#">
		select rtrim(a.Ddocumento) as Ddocumento, rtrim(a.CPTcodigo) as CPTcodigo, a.IDdocumento, a.EDsaldo
		from EDocumentosCP a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.CPTcodigo#">
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
		and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Mcodigo#">
		and upper(rtrim(a.Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.Ddocumento))#">
		and a.EDsaldo > 0
		and a.Ddocumento not in(
			select Ddocumento 
			from DocumentoNeteoDCxP b inner join DocumentoNeteo c
			  on b.idDocumentoNeteo = c.idDocumentoNeteo
			  and c.Aplicado = 0
			where b.Ddocumento = a.Ddocumento
			  and b.CPTcodigo = a.CPTcodigo
		)
	</cfquery>
	<cfif rs.recordcount GT 0>
		<cfoutput>
		<script language="javascript" type="text/javascript">
			<!--//
				if (window.cambio == true){
					window.parent.HDdocumento.value = "#rs.Ddocumento#";
					window.parent.Ddocumento.value = "#rs.Ddocumento#";
					window.parent.idDocumento.value = "#rs.idDocumento#";
					window.parent.EDsaldo.value = "#LSCurrencyFormat(rs.EDsaldo,'none')#";
					window.parent.Dmonto.value = "#LSCurrencyFormat(rs.EDsaldo,'none')#";
					window.parent.Dmonto.focus();
				}
			//-->
		</script>
		</cfoutput>
	</cfif>
</cfif>