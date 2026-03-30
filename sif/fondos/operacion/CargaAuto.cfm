 <cfquery name="rs" datasource="#session.Fondos.dsn#">
	set nocount on	
	SELECT convert(varchar,CJX12IMP,1) CJX12IMP,CJX012.EMPCED,convert(varchar(14),CJX12FEC,103) CJX12FEC,
	PLM001.EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE,EMPCOD
	FROM CJX012 , PLM001
	WHERE  PERCOD  = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(url.PERCOD)#">
	  AND MESCOD   = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(url.MESCOD)#">
	  AND TS1COD   = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(url.TS1COD)#">
	  AND TR01NUT  = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(url.TR01NUT)#">
	  AND CJX12AUT = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(url.CJX12AUT)#">
	  AND CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(url.CJM00COD)#">	
	  AND CJX012.EMPCED = PLM001.EMPCED
	set nocount off	
</cfquery>
<script language="JavaScript">
	<cfif rs.recordcount gt 0>
		var num = new Number(window.parent.document.form1.CJX23MON.value)
		if(num == 0)
			window.parent.document.form1.CJX23MON.value = '<cfoutput>#trim(rs.CJX12IMP)#</cfoutput>';
		window.parent.document.form1.EMPCED.value   = '<cfoutput>#trim(rs.EMPCED)#</cfoutput>';
		window.parent.document.form1.EMPCOD.value   = '<cfoutput>#trim(rs.EMPCOD)#</cfoutput>';
		window.parent.document.form1.NOMBRE.value   = '<cfoutput>#trim(rs.NOMBRE)#</cfoutput>';
		window.parent.document.form1.CJX23FEC.value = '<cfoutput>#trim(rs.CJX12FEC)#</cfoutput>';
		window.parent.document.form1.EMPCED.focus() ;
	</cfif>	
</script>


