<cfif isdefined("url.RHTcodigo") and Len(Trim(url.RHTcodigo)) NEQ 0>
	<cfquery name="rsTipoAccion" datasource="#Session.DSN#">
		select a.RHTid, a.RHTdesc, rtrim(a.RHTcodigo) as RHTcodigo , a.RHTpfijo, a.RHTpmax, a.RHTcomportam, a.RHTcempresa
		from RHTipoAccion a, RHUsuarioTipoAccion b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and upper(a.RHTcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(UCase(url.RHTcodigo))#">
		and a.RHTcomportam not in (7, 8)
		and a.Ecodigo = b.Ecodigo
		and a.RHTid  = b.RHTid 
		and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		<cfif isdefined("url.ag") and Len(Trim(url.ag)) NEQ 0>
		and a.RHTautogestion = 1
		</cfif>
		union
		select RHTid, RHTdesc, RHTcodigo , RHTpfijo, RHTpmax, a.RHTcomportam, a.RHTcempresa
		from RHTipoAccion a 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and upper(a.RHTcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(UCase(url.RHTcodigo))#">
		and a.RHTcomportam not in (7, 8) 
		and not exists(select 1 from RHUsuarioTipoAccion b where b.RHTid = a.RHTid)
		<cfif isdefined("url.ag") and Len(Trim(url.ag)) NEQ 0>
		and a.RHTautogestion = 1
		</cfif>
		order by 3, 2
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		if (parent.ctlid){
			parent.ctlid.value = "<cfoutput>#rsTipoAccion.RHTid#</cfoutput>";
			parent.ctlacc.value = "<cfoutput>#rsTipoAccion.RHTdesc#</cfoutput>";
			parent.ctlpmax.value = "<cfoutput>#rsTipoAccion.RHTpmax#</cfoutput>";
			parent.ctlcod.value = "<cfoutput>#rsTipoAccion.RHTcodigo#</cfoutput>";
			parent.ctlcompor.value = "<cfoutput>#rsTipoAccion.RHTcomportam#</cfoutput>";
			if (parent.hideControls) {
				parent.hideControls("<cfoutput>#rsTipoAccion.RHTpfijo#</cfoutput>", 1, 2);
				<cfif rsTipoAccion.RHTcomportam NEQ 9>
					parent.hideControls("0", 3);
				<cfelse>
					parent.hideControls("<cfoutput>#rsTipoAccion.RHTcempresa#</cfoutput>", 3);
				</cfif>
			}
		}
	</script>
</cfif>
