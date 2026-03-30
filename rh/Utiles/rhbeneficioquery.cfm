<cfif isdefined("url.Bcodigo") and Len(Trim(url.Bcodigo)) NEQ 0>
	<cfquery name="rsBeneficio" datasource="#Session.DSN#">
		select a.Bid, a.Mcodigo, a.Bcodigo, a.Bdescripcion, a.Bmontostd, a.Bporcemp, a.Btercero, 
			   a.SNcodigo, a.Brequierereg, a.Bperiodicidad, a.Bobs, a.BMUsucodigo, a.fechaalta,
			   b.SNnumero, b.SNnombre
		from RHBeneficios a
		
			left outer join SNegocios b
				on a.Ecodigo = b.Ecodigo
				and a.SNcodigo = b.SNcodigo
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfif isdefined("Url.Bcodigo") and Len(Trim(Url.Bcodigo)) NEQ 0>
			and upper(a.Bcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Url.Bcodigo)#">
		</cfif>
		order by Bcodigo, Bdescripcion
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		if (parent.p1) {
			parent.p1.value = "<cfoutput>#rsBeneficio.Bid#</cfoutput>";
			parent.p2.value = "<cfoutput>#rsBeneficio.Bcodigo#</cfoutput>";
			parent.p3.value = "<cfoutput>#JSStringFormat(rsBeneficio.Bdescripcion)#</cfoutput>";
			<!--- Es un combo --->
			for (var i=0; i<parent.p4.length; i++) {
				if (parent.p4.options[i].value == "<cfoutput>#rsBeneficio.Mcodigo#</cfoutput>") {
					parent.p4.selectedIndex = i;
					break;
				}
			}
			parent.p5.value = "<cfoutput>#LSNumberFormat(rsBeneficio.Bmontostd, ',9.00')#</cfoutput>";
			parent.p6.value = "<cfoutput>#LSNumberFormat(rsBeneficio.Bporcemp, ',9.00')#</cfoutput>";
			parent.p7.value = "<cfoutput>#rsBeneficio.Btercero#</cfoutput>";
			parent.p8.value = "<cfoutput>#rsBeneficio.SNcodigo#</cfoutput>";
			parent.p9.value = "<cfoutput>#rsBeneficio.SNnumero#</cfoutput>";
			parent.p10.value = "<cfoutput>#rsBeneficio.SNnombre#</cfoutput>";
		}
	</script>
</cfif>
