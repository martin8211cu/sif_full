<cfif isdefined("url.dato") and Len(Trim(url.dato)) and isdefined("url.fechaAcc") and Len(Trim(url.fechaAcc))>
	<cfquery name="rs" datasource="#url.conexion#">
		select  rtrim(a.RHPcodigo) as RHPcodigo, a.RHPdescripcion, a.RHPid, a.RHPpuesto, a.Dcodigo, a.Ocodigo, 
				100.00 - coalesce(sum(b.LTporcplaza), 0.00) as Disponible
		from RHPlazas a
			left outer join LineaTiempo b
				on a.RHPid = b.RHPid
				and a.Ecodigo = b.Ecodigo
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaAcc)#"> between b.LTdesde and b.LThasta
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Ecodigo#">
		and a.RHPactiva = 1
		and rtrim(ltrim(upper(a.RHPcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
		and a.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_char" value="#Url.RHPpuesto#">
		and a.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Dcodigo#">
		and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Ocodigo#">
		group by rtrim(a.RHPcodigo), a.RHPdescripcion, a.RHPid, a.RHPpuesto, a.Dcodigo, a.Ocodigo
		<cfif Url.vfyplz EQ 0>
		having coalesce(sum(b.LTporcplaza), 0) < 100
		</cfif>
	</cfquery>
	<script language="JavaScript">
		<cfoutput>
		parent.document.#url.form#.#url.atrRHPcodigo#.value = "#Trim(rs.RHPcodigo)#";
		parent.document.#url.form#.#url.atrRHPdescripcion#.value = "#rs.RHPdescripcion#";
		parent.document.#url.form#.#url.atrRHPid#.value = "#rs.RHPid#";
		<cfif rs.recordCount>
		if (parent.document.#url.form#.LTporcplaza) {
			<cfif Url.vfyplz EQ 0>
			if (#rs.Disponible# > 0) {
				parent.document.#url.form#.LTporcplaza.value = "#LSNumberFormat(rs.Disponible, ',9.00')#";
			} else {
				parent.document.#url.form#.LTporcplaza.value = "0.00";
			}
			<cfelse>
				parent.document.#url.form#.LTporcplaza.value = "100.00";
			</cfif>
		}
		<cfelse>
		if (parent.document.#url.form#.LTporcplaza) {
			parent.document.#url.form#.LTporcplaza.value = "0.00";
		}
		</cfif>
		</cfoutput>
	</script>
</cfif>