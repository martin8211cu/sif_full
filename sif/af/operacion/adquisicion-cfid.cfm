<cfif isdefined("Url.DEid") and len(trim(Url.DEid)) and isNumeric(Url.DEid)>
	<cfquery name="rs" datasource="#Session.DSN#">
		select c.CFid, c.CFcodigo, c.CFdescripcion
		from LineaTiempo a 
			inner join RHPlazas b on a.RHPid = b.RHPid
			inner join CFuncional c on b.CFid = c.CFid
		where DEid = #Url.DEid#
		and <cf_dbfunction name="now"> between LTdesde and LThasta
	</cfquery>
	<cfif rs.recordcount>
		<cfoutput>
		<script language="JavaScript" type="text/javascript">
			parent.ctlcfid.value = "#rs.CFid#";
			parent.ctlcfcodigo.value = "#rs.CFcodigo#";
			parent.ctlcfdesc.value = "#rs.CFdescripcion#";
		</script>
		</cfoutput>
	</cfif>
</cfif>
OK