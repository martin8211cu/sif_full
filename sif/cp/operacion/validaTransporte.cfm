<cfif isdefined("url.OCTtransporte") and url.OCTtransporte NEQ "">
	<cfif isdefined("url.OCid") and url.OCid NEQ "">
		<cfquery name="rs" datasource="#session.dsn#">
			select a.OCTid ,a.OCTtipo,a.OCTtransporte,a.OCTfechaPartida 
			from OCtransporte a
			inner join OCtransporteProducto b
				on a.OCTid = b.OCTid
				and a.Ecodigo = b.Ecodigo
			inner join OCordenProducto c
				on b.OCid = c.OCid
				and b.Ecodigo = c.Ecodigo
				and c.OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OCid#">
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.OCTtransporte = <cfqueryparam cfsqltype="cf_sql_char" value="#url.OCTtransporte#">
			<cfif url.OCTtipo NEQ "">
			and a.OCTtipo 		= <cfqueryparam cfsqltype="cf_sql_char" value="#url.OCTtipo#">
			</cfif>
			and a.OCTestado     = 'A'
		</cfquery>
	<cfelse>
		<cfquery name="rs" datasource="#session.dsn#">
			select a.OCTid ,a.OCTtipo,a.OCTtransporte,a.OCTfechaPartida 
			from OCtransporte a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.OCTtransporte = <cfqueryparam cfsqltype="cf_sql_char" value="#url.OCTtransporte#">
			<cfif url.OCTtipo NEQ "">
			and a.OCTtipo 		= <cfqueryparam cfsqltype="cf_sql_char" value="#url.OCTtipo#">
			</cfif>
			and a.OCTestado     = 'T'
		</cfquery>
	</cfif>
	<cfoutput>
		<script language="JavaScript">
			<cfif rs.recordcount gt 0>
				if(window.parent.document.form1.OCTid)
					window.parent.document.form1.OCTid.value="<cfoutput>#trim(rs.OCTid)#</cfoutput>";
					
				if(window.parent.document.form1.OCTtipo)
					window.parent.document.form1.OCTtipo.value="<cfoutput>#trim(rs.OCTtipo)#</cfoutput>";
				if(window.parent.document.form1.OCTtransporte)
					window.parent.document.form1.OCTtransporte.value="<cfoutput>#trim(rs.OCTtransporte)#</cfoutput>";
				if(window.parent.document.form1.DDfembarque)
					window.parent.document.form1.DDfembarque.value="<cfoutput>#LSDateFormat(rs.OCTfechaPartida,'dd/mm/yyyy')#</cfoutput>";
			<cfelse>
				<cfif isdefined("url.DDtipo") and url.DDtipo eq 'T'>
					if(window.parent.document.form1.OCTid)
						window.parent.document.form1.OCTid.value="-1s";
				<cfelse>
					if(window.parent.document.form1.OCTid)
						window.parent.document.form1.OCTid.value="";
					if(window.parent.document.form1.OCTtransporte)
						window.parent.document.form1.OCTtransporte.value="";
					if(window.parent.document.form1.OCTtipo)
						window.parent.document.form1.OCTtipo.value="";
					alert("El transporte digitado no existe");
				</cfif>
				
	
			</cfif>
			<!--- var btn  = window.parent.document.getElementById("Consultar");
			if(btn)
				btn.disabled = false --->
		</script>
	</cfoutput>
</cfif>

