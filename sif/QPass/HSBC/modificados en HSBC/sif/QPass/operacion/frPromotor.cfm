<cfif isdefined("url.QPTidTag")>
	<cfif len(trim(url.QPTidTag)) eq 0>
    	<cfset url.QPTidTag = -1>
    </cfif>
	<cf_dbfunction name="op_concat" returnvariable="_Cat">
	<cfquery name="rsBuscaPromotor" datasource="#session.dsn#">
		select a.QPPid, a.QPPcodigo #_Cat# ' ' #_Cat# a.QPPnombre as Promotor
		from QPPromotor a
        	inner join QPassTag b
            	on b.QPPid = a.QPPid
		where b.QPTidTag = #url.QPTidTag#
	</cfquery>
	<cfoutput>
        <script language="javascript" type="text/javascript">
            <cfif rsBuscaPromotor.recordcount gt 0>
                window.parent.document.form1.QPPid.value = "#rsBuscaPromotor.QPPid#";
                window.parent.document.form1.QPPnombre.value = "#rsBuscaPromotor.Promotor#";
                window.parent.document.getElementById("trpromotor").style.display 	= '';
                window.parent.document.form1.QPvtaAutoriza.focus();
            <cfelse>
                window.parent.document.form1.QPPid.value = "";
                window.parent.document.form1.QPPnombre.value = "";
                window.parent.document.getElementById("trpromotor").style.display 	= 'none';
                window.parent.document.form1.QPvtaConvid.focus();
            </cfif>
            </script>
    </cfoutput>
</cfif>