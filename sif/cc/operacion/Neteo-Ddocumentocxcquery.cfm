<script language="javascript" type="text/javascript">
	<!--//
		window.cambio = true;
		window.parent.HDdocumento.value = "";
		window.parent.Ddocumento.value = "";
		window.parent.Dsaldo.value = "0.00";
		window.parent.Dmonto.value = "0.00";
	//-->
</script>
<cfif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo)) GT 0
	and isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) GT 0
	and isdefined("url.Mcodigo") and len(trim(url.Mcodigo)) GT 0
	and isdefined("url.Ddocumento") and len(trim(url.Ddocumento)) GT 0
>
	<cfquery name="rs" datasource="#session.dsn#">
		select rtrim(a.Ddocumento) as Ddocumento, rtrim(a.CCTcodigo) as CCTcodigo, a.Dsaldo
		from Documentos a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.CCTcodigo#">
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
		and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Mcodigo#">
		and upper(rtrim(a.Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.Ddocumento))#">
		and a.Dsaldo > 0
		and a.Ddocumento not in(
			select Ddocumento 
			from DocumentoNeteoDCxC b 
				inner join DocumentoNeteo c
					on b.idDocumentoNeteo = c.idDocumentoNeteo
					and b.Ecodigo = c.Ecodigo
					and c.Aplicado = 0
			where b.Ecodigo = a.Ecodigo
			  and b.Ddocumento = a.Ddocumento
			  and b.CCTcodigo = a.CCTcodigo
		)
	</cfquery>
	<cfif rs.recordcount GT 0>
		<cfoutput>
		<script language="javascript" type="text/javascript">
			<!--//
				if (window.cambio == true){
					window.parent.HDdocumento.value = "#rs.Ddocumento#";
					window.parent.Ddocumento.value = "#rs.Ddocumento#";
					window.parent.Dsaldo.value = "#LSCurrencyFormat(rs.Dsaldo,'none')#";
					window.parent.Dmonto.value = "#LSCurrencyFormat(rs.Dsaldo,'none')#";
					window.parent.Dmonto.focus();
				}
			//-->
		</script>
		</cfoutput>
	</cfif>
</cfif>