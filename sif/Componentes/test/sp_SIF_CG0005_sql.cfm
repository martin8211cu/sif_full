<cftry>
	<cftransaction>		
		<cfinvoke returnvariable="rs_Res" component="sif.Componentes.sp_SIF_CG0005" method="balanceGeneral" 
			Ecodigo="#Session.Ecodigo#"
			Ocodigo="0"
			periodo="2003"
			mes="2"
			nivel="3"
			Mcodigo="1">
		</cfinvoke>			
	</cftransaction>
<cfcatch type="any">
	<cfinclude template="../../errorPages/BDError.cfm">
	<cftransaction action="rollback"/>
</cfcatch>
</cftry>


<HTML>
<head>
</head>
<body>
	<form action="sp_SIF_CG0005_test.cfm" method="post" name="sql">
		<cfif isdefined('rs_Res') and rs_Res.recordCount GT 0>
			<table width="200" border="0" align="center">
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>
					<input type="submit" name="Submit" value="Pagina anterior">
				</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>
					<!--- <cfdump var="#rs_Res#">	 --->							
				</td>
              </tr>
            </table>
		</cfif>	
	</form>
	<cfif not isdefined('rs_Res')>
		<script language="JavaScript1.2" type="text/javascript">
			document.forms[0].submit();
		</script>
	</cfif>
</body>
</HTML>

