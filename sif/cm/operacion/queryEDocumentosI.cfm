<cfparam name="documento" type="string">
<cfquery name="rsdatos" datasource="#session.dsn#">
	select edi.EDIid, edi.Ddocumento
	from EDocumentosI edi
		inner join DDocumentosI ddi
			on ddi.EDIid = edi.EDIid
			and ddi.Ecodigo = edi.Ecodigo
			and ddi.cantidadrestante > 0
			and ddi.DDlinea not in  (
				select y.DDlinea from EPolizaDesalmacenaje x
					inner join DPolizaDesalmacenaje y
						on x.EPDid = y.EPDid
						and x.Ecodigo = y.Ecodigo
				where x.EPDestado = 0
				and x.Ecodigo = edi.Ecodigo
			)
			and ddi.DDlinea not in  (
				select y.DDlinea from EPolizaDesalmacenaje x
					inner join FacturasPoliza y
						on x.EPDid = y.EPDid
						and x.Ecodigo = y.Ecodigo
				where x.EPDestado = 0
				and x.Ecodigo = edi.Ecodigo
			)
			and ddi.DDlinea not in  (
				select y.DDlinea from EPolizaDesalmacenaje x
					inner join CMImpuestosPoliza y
						on x.EPDid = y.EPDid
						and x.Ecodigo = y.Ecodigo
				where x.EPDestado = 0
				and x.Ecodigo = edi.Ecodigo
			)
	where edi.EDIestado = 10
		and edi.EDIimportacion = 1
		and	upper(rtrim(ltrim(edi.Ddocumento))) = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(trim(url.documento))#">
		and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfoutput>
<cfif rsdatos.recordcount>
  <script language="javascript" type="text/javascript">
	window.parent.EDIid.value = "#rsdatos.EDIid#";
	window.parent.Ddocumento.value = "#rsdatos.Ddocumento#";
	window.parent.EPDdescripcion.focus();
	window.parent.EPDdescripcion.select();
  </script>
<cfelse>
  <script language="javascript" type="text/javascript">
	window.parent.EDIid.value = "";
	window.parent.Ddocumento.value = "";
	window.parent.Ddocumento.focus();
	window.parent.Ddocumento.select();
  </script>
</cfif>
</cfoutput>