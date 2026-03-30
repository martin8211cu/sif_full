<cfif isdefined("url.CIcodigo") and Len(Trim(url.CIcodigo)) NEQ 0>
	<cfquery name="rsTipoAccion" datasource="#Session.DSN#">
		select CIid, CIcodigo, CIdescripcion, CInegativo
		from CIncidentes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and upper(rtrim(CIcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(url.CIcodigo))#">
		<cfif isdefined("url.IncluirTipo") and Len(Trim(url.IncluirTipo)) NEQ 0>
			and CItipo in (#url.IncluirTipo#)
		</cfif>
		<cfif isdefined("url.ExcluirTipo") and Len(Trim(url.ExcluirTipo)) NEQ 0>
			and CItipo not in (#url.ExcluirTipo#)
		</cfif>
		<cfif isdefined("url.IncluirAnticipo") and url.IncluirAnticipo NEQ 0>
			and CInoanticipo = 1
		</cfif>
		<cfif isdefined("url.CarreraP") and LEN(TRIM(url.CarreraP)) NEQ 0>
			and CIcarreracp = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CarreraP#">
		</cfif>

	</cfquery>
	<script language="JavaScript" type="text/javascript">
		parent.ctlid.value = "<cfoutput>#rsTipoAccion.CIid#</cfoutput>";
		parent.ctlcod.value = "<cfoutput>#rsTipoAccion.CIcodigo#</cfoutput>";
		parent.ctldesc.value = "<cfoutput>#rsTipoAccion.CIdescripcion#</cfoutput>";
		parent.ctlsigno.value = "<cfoutput>#rsTipoAccion.CInegativo#</cfoutput>";
		<cfif isdefined("url.onBlur") and Len(Trim(url.onBlur)) NEQ 0>
			parent.<cfoutput>#url.onBlur#</cfoutput>;
		</cfif>
	</script>
<cfelse>
	<script language="JavaScript" type="text/javascript">
		parent.ctlid.value = "";
		parent.ctlcod.value = "";
		parent.ctldesc.value = "";
		parent.ctlsigno.value = "1";
		<cfif isdefined("url.onBlur") and Len(Trim(url.onBlur)) NEQ 0>
			parent.<cfoutput>#url.onBlur#</cfoutput>;
		</cfif>
	</script>
</cfif>
