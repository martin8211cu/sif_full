<!--- 
	CF_cascadianlogin (CascadianLogin) - A Custom ColdFusion tag by Summer S. Wilson
	Last Updated: June 4, 2002
	Version: 2.0
	
	To Call:
	
		<cf_cascadianlogin
			tablename="tablename"
			datasourcename="datasourcename"
			fieldlist="field1,field2"
			logoutreturn="loggedout.cfm"
			usernamefield="name of your username field; optional, defaults to username"
			passwordfield="name of the field in your table for the password; optional, defaults to password"
			>
			
		REQUIRED ATTRIBUTES:
		tablename - the name of the table in your database to retrieve user info from.  You can
			use joins here, but make sure you use the table.fieldname syntax in the usernamefield
			and passwordfield attributes;
		
		datasourcename - Well, duh...ColdFusion datasource name for the database to use
		
		OPTIONAL ATTRIBUTES:
		fieldlist - a list of fields to be pulled from the table and set as session variables;
			variables will be set as session.fieldname.  If this is not passed, the default 
			field list is "userid,firstname,lastname,email" If you used joined tables in the 
			tablename attribute, you may want to use the AS syntax to rename each field so something 
			other than tablename.fieldname, otherwise your session variables will be 
			session.tablename.fieldname.
			
		usernamefield - the field in the table where the username is stored; defaults to username
		
		passwordfield - the field in the table where the password is stored; defaults to password
		
		logoutreturn - page name or URL to send a user to when they have logged out; defaults to index.cfm
		
	If you have a login link, simply have it go to any page that uses this tag with action=logout as it's
	query string.
 --->

<cfif Not IsDefined("attributes.tablename") OR Not IsDefined("attributes.datasourcename")>
	<cfabort showerror="You must pass the tablename, and datasource name to this custom tag.">
</cfif>

<cfset dns = attributes.datasourcename>
<cfset tablename = attributes.tablename>

<cfif IsDefined("attributes.fieldlist")>
	<cfset fieldlist = attributes.fieldlist>
<cfelse>
	<cfset fieldlist = "userid,firstname,lastname,email">
</cfif>

<cfif IsDefined("attributes.passwordfield")>
	<cfset passwordfield = attributes.passwordfield>
<cfelse>
	<cfset passwordfield = "password">
</cfif>

<cfif IsDefined("attributes.usernamefield")>
	<cfset usernamefield = attributes.usernamefield>
<cfelse>
	<cfset usernamefield = "username">
</cfif>

<cfif IsDefined("attributes.logoutreturn")>
	<cfset logoutreturn = attributes.logoutreturn>
<cfelse>
	<cfset logoutreturn = "indexSif.cfm">
</cfif>

<!--- This ensures that the calling template gets returned all variables it 
was passed. --->
<cfset FINAL_SCRIPT_NAME = cgi.Script_Name & "?" & cgi.query_string>

<!--- Processes logouts.  To call use login.cfm?action=logout --->
<cfif (IsDefined("Action") and Action IS "logout" and IsDefined("session.loggedin"))>
	<!--- Actual logging out --->
	<cflock timeout="30" name="Clear_session" type="exclusive">
		<cfset StructClear(session)>
	</cflock>

	<cflocation url="#logoutreturn#" addtoken="No">
	<cfabort>

<!--- Begin main login test --->
<cfelse>
	<CFIF (NOT IsDefined("session.loggedin")) OR (IsDefined("UserValue"))>
		<!--- Check to see if user is logged into system --->
		<CFIF (IsDefined("UserValue"))>
		<!--- Have already gotten name and password --->
				<!--- Pulls the info from the user tables that will be used for setting
				session variables.  Add fields as needed, being sure to all add
				matching session sets below. --->
			<CFQUERY datasource="#dns#" name="login">
				SELECT #fieldlist#
				FROM #tablename#
				WHERE #usernamefield# = '#uservalue#'
				AND #passwordfield# = '#hash(password)#'
			</CFQUERY>
				
			<!--- Reprompts for login, it was invalid --->
			<CFIF login.RecordCount IS "0">
				<CFPARAM name="UserValue" default="">
				<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
				<html>
				<head>
					<title>Please Log-In</title>
					<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
				</head>
				
				<body bgcolor="#003366" text="#FFFFFF" link="#FFFF00" vlink="#FFFF00" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10">
				<p align="center"><strong>Invalid Username/Password Combination, please try again.</strong> Username and password are case sensitive!</p>
				<CFFORM action="#FINAL_SCRIPT_NAME#" name="SecureForm" method="POST">
					<table width="300" border="0" cellspacing="5" cellpadding="5" align="center" bgcolor="#FFFFFF">
					<tr valign="middle"> 
						<td align="right"><font color="#000066"><strong>Username:</strong></font></td>
						<td><cfoutput><input type="text" name="uservalue" maxlength="15" value="#UserValue#"></cfoutput></td>
					</tr>
					<tr valign="middle"> 
						<td align="right"><font color="#000066"><strong>Password:</strong></font></td>
						<td><input type="password" name="password" maxlength="15"></td>
					</tr>
					<tr valign="middle"> 
						<td colspan="2" align="center" valign="top"><input type="submit" name="submit" value="Login"></td>
					</tr>
					</table>
					<p>&nbsp;</p>
					<p align="center">Powered by CascadianLogin v2 created by <a href="http://eclectic-designs.com" target="_blank">Summer S. Wilson</a></p>
				</cfform>
				</body>
				</html>
				<cfabort>
			</CFIF>
			
			<!--- User has been validated.  Log them in and send them on their way. --->
			
			<!--- Always lock things when you are setting session variables.
				To add additional variables pulled from the login query,
				Just use the format of <cfset session.fieldname = login.fieldname> --->
			<cflock TimeOut="30" type="exclusive" scope="session">
				<CFSET session.loggedin = "yes">
				
				<cfloop list="#fieldlist#" index="thisfieldname">
					<cfset value = Evaluate("login.#Trim(thisfieldname)#")>
					<cfset variablename = "session.#Trim(thisfieldname)#">
					<CFSET "#variablename#" = value>
				</cfloop>
			</cflock>
			
			<cflocation url="#FINAL_SCRIPT_NAME#" addtoken="No">
			
		<CFELSE>
			<!--- Prompt user for name and password HTML can be edited 
				as desired, but be sure to leave in the uservalue and password fields! --->
			<CFPARAM name="UserValue" default="">
			<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
			<html>
			<head>
				<title>Please Log In</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			</head>

			<body bgcolor="#003366" text="#FFFFFF" link="#FFFF00" vlink="#FFFF00" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10">
			<CFFORM action="#FINAL_SCRIPT_NAME#" name="SecureForm" method="POST">
				<p align="center"><strong>Please enter your username and password.  Entries ARE case sensitive!</strong></p>
				<table width="300" border="0" cellspacing="5" cellpadding="5" align="center" bgcolor="#FFFFFF">
				<tr valign="middle"> 
					<td align="right"><font color="#000066"><strong>Username:</strong></font></td>
					<td><cfoutput><input type="text" name="uservalue" maxlength="15" value="#UserValue#"></cfoutput></td>
				</tr>
				<tr valign="middle"> 
					<td align="right"><font color="#000066"><strong>Password:</strong></font></td>
					<td><input type="password" name="password" maxlength="15"></td>
				</tr>
				<tr valign="middle"> 
					<td colspan="2" align="center" valign="top"><input type="submit" name="submit" value="Login"></td>
				</tr>
				</table>
				<p>&nbsp;</p>
				<p align="center">Powered by CascadianLogin v2 created by <a href="http://eclectic-designs.com" target="_blank">Summer S. Wilson</a></p>
			</cfform>
			</body>
			</html>
			<cfabort>
		</CFIF>
	</CFIF>
</cfif>