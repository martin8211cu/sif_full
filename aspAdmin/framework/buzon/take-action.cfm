<cfif isdefined("Form.chk") and Len(Trim(Form.chk)) NEQ 0 and not isdefined('btnRegresa')>
	<cfloop index="i" list="#Form.chk#" delimiters=",">
 		<cfquery name="rsDeleteMsg" datasource="#Session.DSN#">
			delete Buzon
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
			and Bcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(i)#">
		</cfquery>
	</cfloop>
</cfif>

<HTML>
<head>
</head>
<body>
<cfoutput>
	<form action="index.cfm" method="post" name="sql">
		<cfif isdefined("Form.PageNum")>
		<input type="hidden" name="PageNum" id="PageNum" value="#Form.PageNum#">
		</cfif>
	</form>
</cfoutput>
<script language="JavaScript" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
