<cfif isdefined("url.Bcodigo") and Len(Trim(url.Bcodigo)) NEQ 0 and isdefined("url.DEid") and Len(Trim(url.DEid))>
	<cfquery name="rsBeneficio" datasource="#Session.DSN#">
		select a.BElinea, a.DEid, a.Bid, a.Mcodigo, a.SNcodigo, a.BEfdesde, a.BEfhasta, a.BEmonto, a.BEporcemp, a.BEactivo, a.fechainactiva, a.BMUsucodigo, a.fechaalta, 
			   b.Bcodigo, b.Bdescripcion, b.Btercero, c.SNnumero, c.SNnombre
		from RHBeneficiosEmpleado a
			
			inner join RHBeneficios b
				on a.Ecodigo = b.Ecodigo
				and a.Bid = b.Bid
				and b.Brequierereg = 1
			
			left outer join SNegocios c
				on a.Ecodigo = c.Ecodigo
				and a.SNcodigo = c.SNcodigo
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.DEid#">
		<cfif isdefined("Url.Bcodigo") and Len(Trim(Url.Bcodigo)) NEQ 0>
			and upper(b.Bcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Url.Bcodigo)#">
		</cfif>
		order by b.Bcodigo, b.Bdescripcion
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		if (parent.p1) {
			parent.p1.value = "<cfoutput>#rsBeneficio.BElinea#</cfoutput>";
			parent.p2.value = "<cfoutput>#rsBeneficio.Bcodigo#</cfoutput>";
			parent.p3.value = "<cfoutput>#JSStringFormat(rsBeneficio.Bdescripcion)#</cfoutput>";
			<!--- Es un combo --->
			for (var i=0; i<parent.p4.length; i++) {
				if (parent.p4.options[i].value == "<cfoutput>#rsBeneficio.Mcodigo#</cfoutput>") {
					parent.p4.selectedIndex = i;
					break;
				}
			}
			parent.p5.value = "<cfoutput>#LSNumberFormat(rsBeneficio.BEmonto, ',9.00')#</cfoutput>";
			parent.p6.value = "<cfoutput>#LSNumberFormat(rsBeneficio.BEporcemp, ',9.00')#</cfoutput>";
			parent.p7.value = "<cfoutput>#rsBeneficio.Btercero#</cfoutput>";
			parent.p8.value = "<cfoutput>#rsBeneficio.SNcodigo#</cfoutput>";
			parent.p9.value = "<cfoutput>#rsBeneficio.SNnumero#</cfoutput>";
			parent.p10.value = "<cfoutput>#rsBeneficio.SNnombre#</cfoutput>";
		}
	</script>
</cfif>
