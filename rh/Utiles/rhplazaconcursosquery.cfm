<!--- Recibe conexion, form, name, desc, ecodigo, dato, RHPpuesto y CFid por URL  --->
<!--- Si se sabe el código lo digita y le recupera la descripción en pantalla. Se invoca desde rhplaza concursos --->

<cfparam name="Url.vfyplz" default="0">

<cfif isdefined("url.dato") and Len(Trim(url.dato))>
	<cfquery name="rs" datasource="#url.conexion#">
		select  rtrim(a.RHPcodigo) as RHPcodigo, a.RHPdescripcion, a.RHPid, a.RHPpuesto, a.CFid, 
				100.00 - coalesce(sum(b.LTporcplaza), 0.00) as Disponible
		from RHPlazas a
			left outer join LineaTiempo b
				on a.RHPid = b.RHPid
				and a.Ecodigo = b.Ecodigo
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between b.LTdesde and b.LThasta
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.Ecodigo#">
		and a.RHPactiva = 1
		and rtrim(ltrim(upper(a.RHPcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
		<cfif isdefined("url.RHPpuesto") and (Len(Trim(url.RHPpuesto GT 0)))>
		and rtrim(ltrim(upper(a.RHPpuesto))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.RHPpuesto))#">
		</cfif>
		<cfif isdefined("url.CFid") and (Len(Trim(url.CFid GT 0)))>
		and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
		</cfif>
		group by rtrim(a.RHPcodigo), a.RHPdescripcion, a.RHPid, a.RHPpuesto, a.CFid
		<cfif Url.vfyplz EQ 0>
		having coalesce(sum(b.LTporcplaza), 0) < 100
		</cfif>
	</cfquery>

	<script language="JavaScript">
		var descAnt = parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.RHPid#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.RHPcodigo#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.RHPdescripcion#</cfoutput>";

		<!--- Esto es utilizado para limpiar el tag de plazaconcursos en Reclutamieto y Selección --->
		if (descAnt != parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value && parent.ClearPlaza) {
			parent.ClearPlaza();
		}
	</script>
</cfif>
