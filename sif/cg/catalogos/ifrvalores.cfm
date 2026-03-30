<cfoutput>
<cfif isdefined ('url.valor') and len(trim(#url.valor#)) eq 0>
		<script language="javascript1.2" type="text/javascript">
			window.parent.document.getElementById("Valor_" + #url.id#).value ="0.000000";
		</script>
</cfif>


<cfquery name="rsSQL" datasource="#session.dsn#">
	select CGCvalor from CGParamConductores 
	where
	CGCid=#url.CGCid#
	and CGCmes=#url.smes#
	and CGCperiodo=#url.speriodo#
	<cfif #url.modo# eq 1>
		and PCDcatid=#url.id#
	<cfelseif #url.modo# eq 2>
		and PCCDclaid=#url.id#
	</cfif>
</cfquery>


<cfif isdefined ('url.valor') and #url.valor# lt 0>
	<script language="javascript1.2" type="text/javascript">
		alert("El valor no puede ser menor a 0 (cero)");
		<cfif len(trim(#rsSQL.CGCvalor#)) eq 0>
			window.parent.document.getElementById("Valor_" + #url.id#).value ="0.000000";
		<cfelse>
			window.parent.document.getElementById("Valor_" + #url.id#).value =#rsSQL.CGCvalor#;
		</cfif>
	</script>

<cfelse>
<cfif not isdefined ('url.borra')>
	<cfif rsSQL.recordcount eq 0>
		<cfquery name="insert" datasource="#session.dsn#">				
			insert into CGParamConductores (
				Ecodigo, 
				CGCperiodo, 
				CGCmes, 
				CGCid, 
				PCCDclaid, 
				PCDcatid, 
				CGCvalor, 
				BMUsucodigo)				
			values (
				#session.ecodigo# ,
				#url.speriodo# ,
				#url.smes#,
				#url.CGCid#,
				<cfif #url.modo# eq 1>
				0,
				#url.id#,
				<cfelseif #url.modo# eq 2>
				#url.id#,
				null,				
				</cfif>
				#url.valor#,
				#session.usucodigo#
			)				
			</cfquery>	
	<cfelseif rsSQL.recordcount eq 1>
		<cfquery name="upValor" datasource="#session.dsn#">
			update CGParamConductores set CGCvalor=#url.valor# 
			where
				CGCid=#url.CGCid#
				and CGCmes=#url.smes#
				and CGCperiodo=#url.speriodo#
				<cfif #url.modo# eq 1>
					and PCDcatid=#url.id#
				<cfelseif #url.modo# eq 2>
					and PCCDclaid=#url.id#
				</cfif> 
		</cfquery>
	</cfif>
</cfif>
</cfif>

<cfif isdefined ('url.borra') >
	<cfquery name="dlDet" datasource="#session.dsn#">
		delete from CGParamConductores 
		where
		CGCid=#url.CGCid#
		and CGCmes=#url.smes#
		and CGCperiodo=#url.speriodo#
		<cfif #url.modo# eq 1>
			and PCDcatid=#url.id#
		<cfelseif #url.modo# eq 2>
			and PCCDclaid=#url.id#
		</cfif>
	</cfquery>
	<script language="javascript1.2" type="text/javascript">
		window.parent.document.form1.submit();
	</script>
</cfif>
</cfoutput>