<cfif isdefined("Form.o") and Form.o EQ 1 and isdefined("Form.chk") and Len(Trim(Form.chk)) NEQ 0>
	<cfloop index="i" list="#Form.chk#" delimiters=",">
		<cfquery name="rsDeleteMsg" datasource="#Session.Edu.DSN#">
			delete Buzon
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
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
		<input type="hidden" name="O" id="O" value="<cfif isdefined("Form.o") and Len(Trim(Form.o)) NEQ 0>#Form.o#<cfelse>1</cfif>">
		<cfif isdefined("Form.PageNum")>
		<input type="hidden" name="PageNum" id="PageNum" value="#Form.PageNum#">
		</cfif>
	</form>
</cfoutput>
<script language="JavaScript" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
