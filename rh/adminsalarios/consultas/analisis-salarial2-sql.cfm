<cfif isdefined("Form.paso") and Len(Trim(Form.paso))>
	<cfif Form.paso EQ 1>
		<cfinclude template="analisis-salarial2-sqlpaso1.cfm">
	<cfelseif Form.paso EQ 2>
		<cfinclude template="analisis-salarial2-sqlpaso2.cfm">
	</cfif>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="analisis-salarial2.cfm">
		<cfif isdefined("Form.paso") and Len(Trim(Form.paso))>
			<input type="hidden" name="paso" value="#Form.paso#">
		</cfif>
		<cfif isdefined("Form.RHASid") and Len(Trim(Form.RHASid))>
			<input type="hidden" name="RHASid" value="#Form.RHASid#">
		</cfif>
	</form>
</cfoutput>

<HTML>
  <head>
  </head>
  <body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
  </body>
</HTML>
