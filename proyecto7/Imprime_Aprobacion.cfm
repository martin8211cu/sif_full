<cfparam name="Attributes.location" default="">
<cfif isdefined ('url.TESSPid')>
	<cfinclude template="SP_imprimir.cfm">
	<script language="javascript">
            window.parent.document.form1.action = "gastosEmpleados.cfm";
            window.parent.document.form1.submit();
    </script>
<cfelse>	
		<cfinclude template="ImprimeTransac.cfm">
		<cfoutput>
			<script language="javascript">
                fnImgPrint();
                <cfif isdefined("form.devolver") and form.devolver EQ true>
                    window.setTimeout("location.href='/cfmx/proyecto7/AprobarTrans_formCom.cfm?GECid_comision=#form.GECid_comision#&tipo=COMISION&LvarComision=true'",1000);
                <cfelse>
                    window.parent.document.form1.action = "gastosEmpleados.cfm";
                    window.parent.document.form1.submit();
                </cfif>
            </script>
		</cfoutput>
		<cfabort>	
</cfif>

