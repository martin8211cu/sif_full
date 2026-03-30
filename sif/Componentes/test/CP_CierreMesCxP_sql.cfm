<cftry>
	<cftransaction>
		<cfinvoke component="sif.Componentes.CP_CierreMesCxP" method="CierreMesCxP" 
			Ecodigo="#Session.Ecodigo#" 
			usuario="#session.usuario#"
			conexion="#session.dsn#">
		</cfinvoke>			
		
		<cftransaction action="rollback"/>
	
	</cftransaction>
	
<cfcatch type="any">
	<cfinclude template="../../errorPages/BDError.cfm">
	<cftransaction action="rollback"/>
</cfcatch>
</cftry>

<form action="CP_CierreMesCxP_test.cfm" method="post" name="sql">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

