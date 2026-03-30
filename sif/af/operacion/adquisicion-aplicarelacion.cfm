<!---
	20 de Febrero del 2004
	DAG: Se modifica la funcionalidad de esta validaci&oacute;n.
	Esta validaci&oacute;n verifica que esta relaci&oacute;n este lista para ser Aplicada y si es as&iacute;!.. se Activa el Bot&oacute;n "Preparar Relaci&oacute;n"
		para que el usuario pueda ponerla lista para ser Aplicada!. Al lado del bot&oacute;n se brindan las explicaciones del caso.
--->

<cfset RelacionBalanceada = true>
<cfset RelacionCompleta = true>
<cfset valido = true>
<cfset qry_unvalid_msg = QueryNew("DAlinea,lin")>
<cfset qry_unvalid_msg_balance = QueryNew("DAlinea")>

<!--- Valida si la relaci&oacute;n está balanceada --->
	<cfquery name="rsValmontosD" datasource="#Session.DSN#">
		select a.DAlinea, a.DAmonto, sum(b.DSmonto) as DSmonto
		from DAadquisicion a inner join DSActivosAdq b on
			b.Ecodigo = a.Ecodigo
			and b.EAcpidtrans = a.EAcpidtrans
			and b.EAcpdoc = a.EAcpdoc
			and b.EAcplinea = a.EAcplinea
			and b.DAlinea = a.DAlinea
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and b.EAcpidtrans = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EAcpidtrans#">
			and b.EAcpdoc = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EAcpdoc#">
			and b.EAcplinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAcplinea#">
		group by a.DAlinea, a.DAmonto
	</cfquery>

	<cfloop query="rsValmontosD">
		<cfif rsValmontosD.DSmonto NEQ rsValmontosD.DAmonto>
			<cfset QueryAddRow(qry_unvalid_msg_balance, 1)>
			<cfset QuerySetCell(qry_unvalid_msg_balance,"DAlinea",DAlinea)>
			<cfset valido = false>
			<cfset RelacionBalanceada = false>
		</cfif>
	</cfloop>

	<cfquery name="rsValdatos" datasource="#Session.DSN#">
		select DAlinea
				, lin
				, AFMid 
				, AFMMid 
				, CFid 
				, DEid 
				, Alm_Aid 
				, ACcodigo 
				, ACid 
				, DSdescripcion 
				, DSplaca 
				, DSfechainidep 
				, DSfechainirev 
				, DSmonto 
		from DSActivosAdq
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and EAcpidtrans = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EAcpidtrans#">
		  and EAcpdoc = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EAcpdoc#">
		  and EAcplinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAcplinea#">
		order by DAlinea, lin
	</cfquery>

	<cfloop query="rsValdatos">
		<cfif 
				NOT (
				(len(trim(AFMid)))
				and (len(trim(AFMMid)))
				and (len(trim(CFid)))
				and ((len(trim(DEid))) or (len(trim(Alm_Aid))))
				and (len(trim(ACcodigo)))
				and (len(trim(ACid)))
				and (len(trim(DSdescripcion)))
				and (len(trim(DSplaca)))
				and (len(trim(DSfechainidep)))
				and (len(trim(DSfechainirev)))
				and (len(trim(DSmonto)))
				)>
			<cfset QueryAddRow(qry_unvalid_msg, 1)>
			<cfset QuerySetCell(qry_unvalid_msg,"DAlinea",DAlinea)>
			<cfset QuerySetCell(qry_unvalid_msg,"lin",lin)>
			<cfset valido = false>
			<cfset RelacionCompleta = false>
		</cfif>
	</cfloop>
	
<cfset MensajeError = "">
<cfif not valido>
	<cfset MensajeError = MensajeError & "<ol>">
	<cfset MensajeError = MensajeError & "<span style='color: ##FF0000'>">
	<cfif qry_unvalid_msg.Recordcount>
	  <!--- L&iacute;neas imcompletas--->
		<cfset MensajeError = MensajeError & #iif(Compare(right(MensajeError,5),'</li>'),DE(""),DE('<br><br>'))# & "<li>">
		<cfif qry_unvalid_msg.RecordCount eq 1>
			<cfset MensajeError = MensajeError & "Una subl&iacute;nea de detalle se encuentra incompleta, la subl&iacute;nea incompleta es la 1 que se encuentra en la l&iacute;nea #qry_unvalid_msg.DAlinea#,">
		<cfelseif qry_unvalid_msg.RecordCount gt 1>
			<cfquery dbtype="query" name="rsEEE">
				select distinct DAlinea from qry_unvalid_msg
			</cfquery>
				<cfset MensajeError = MensajeError & "Varias subl&iacute;neas de detalle se encuentran incompletas,">
					<cfloop query="rsEEE">
						<cfquery dbtype="query" name="rsLLL">
							select lin from qry_unvalid_msg where DAlinea  = #rsEEE.DAlinea#
						</cfquery>
						<cfset MensajeError = MensajeError & " en la l&iacute;nea #DAlinea#,">
						<cfif rsLLL.Recordcount eq 1>
							<cfset MensajeError = MensajeError & " la subl&iacute;nea 1">
						<cfelseif rsLLL.Recordcount gt 1>
							<cfset MensajeError = MensajeError & " las subl&iacute;neas">
							<cfloop query="rsLLL">
								<cfset MensajeError = MensajeError & " #rsLLL.currentrow#,">
							</cfloop>
						</cfif>
					</cfloop>
		</cfif>
		<cfset MensajeError = MensajeError & " todos los datos de estas subl&iacute;neas de detalle deben ser completados para poder preparar esta relaci&oacute;n para ser aplicada.</li>">
	</cfif>
	<cfif qry_unvalid_msg_balance.Recordcount>
		<!--- L&iacute;neas imcompletas--->
		<cfset MensajeError = MensajeError & #iif(Compare(right(MensajeError,5),'</li>'),DE(""),DE('<br><br>'))# & "<li>">
		<cfif qry_unvalid_msg_balance.RecordCount eq 1>
			<cfset MensajeError = MensajeError & "Una l&iacute;nea de detalle se encuentra desbalanceada, la suma de todas las subl&iacute;neas de una l&iacute;nea deben sumar el monto de la l&iacute;nea, la l&iacute;nea que se encuentra desbalanceda es la #qry_unvalid_msg_balance.DAlinea#, ">
		<cfelseif qry_unvalid_msg_balance.RecordCount gt 1>
			<cfset MensajeError = MensajeError & "Varias l&iacute;neas de detalle se encuentran desbalanceadas, la suma de las subl&iacute;neas que las componen no es igual al monto de la l&iacute;nea, las l&iacute;neas que se encuentran desbalanceadas son ">
			<cfloop query="qry_unvalid_msg_balance">
				<cfset MensajeError = MensajeError & "#DAlinea#, ">
			</cfloop>
		</cfif>
		<cfset MensajeError = MensajeError & " todas las l&iacute;neas de detalle deben ser balanceadas para poder preparar la relaci&oacute;n para ser aplicada.</li>">
	</cfif>
	<cfset MensajeError = MensajeError & "</span>">
	<cfset MensajeError = MensajeError & "</ol>">
</cfif>