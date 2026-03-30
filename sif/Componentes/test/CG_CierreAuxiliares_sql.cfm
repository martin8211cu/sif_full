<cftry>
	<cftransaction>
		<cfinvoke component="sif.Componentes.CG_CierreAuxiliares" method="CierreAuxiliares" 
			Ecodigo="#Session.Ecodigo#" 
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

