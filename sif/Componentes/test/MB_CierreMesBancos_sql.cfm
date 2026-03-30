<cftry>
	<cftransaction>
		<cfinvoke component="sif.Componentes.MB_CierreMesBancos" method="CierreMesBancos" 
			Ecodigo="#Session.Ecodigo#" 
			periodo="2003"
			mes="4"
			conexion="#session.dsn#">
		</cfinvoke>			
		
		<cftransaction action="rollback"/>
	
	</cftransaction>
<cfcatch type="any">
	<cfinclude template="../../errorPages/BDError.cfm">
	<cftransaction action="rollback"/>
</cfcatch>
</cftry>

<form action="CG_CierreAuxiliares_test.cfm" method="post" name="sql">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

