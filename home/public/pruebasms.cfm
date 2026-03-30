<!--- --------------------------------------------------------------------------------------- ----
	
	Blog Entry:
	Sending Text Messages (SMS) With ColdFusion And CFMail
	
	Code Snippet:
	2
	
	Author:
	Ben Nadel / Kinky Solutions
	
	Link:
	http://www.bennadel.com/index.cfm?dax=blog:692.view
	
	Date Posted:
	May 9, 2007 at 10:27 AM
	
---- --------------------------------------------------------------------------------------- --->

Para:
88148340@sms.ice.cr

Asunto:Prueba
Mensaje:Hola Mundo SMS
<!--- Kill extra output. --->
<cfsilent>
 
	<!--- Param the form variable. --->
	<cfparam
		name="FORM.from"
		type="string"
		default=""
		/>
 
	<cfparam
		name="FORM.to"
		type="string"
		default=""
		/>
 
	<cfparam
		name="FORM.provider"
		type="string"
		default=""
		/>
 
	<cfparam
		name="FORM.subject"
		type="string"
		default=""
		/>
 
	<cfparam
		name="FORM.message"
		type="string"
		default=""
		/>
 
	<cftry>
		<cfparam
			name="FORM.submitted"
			type="numeric"
			default="0"
			/>
 
		<cfcatch>
			<cfset FORM.submitted = 0 />
		</cfcatch>
	</cftry>
 
 
	<!---
		This is the data validation error array. We will
		use this to keep track of any data errors.
	--->
	<cfset arrErrors = ArrayNew( 1 ) />
 
 
	<!---
		Let's build up a list of providers. Each provider
		will have a differen domain name for the mail usage.
	--->
	<cfset objProviders = StructNew() />
	<cfset objProviders[ "ICE" ] = "sms.ice.cr" />
 
 
	<!--- Check to see if the form has been submitted. --->
	<cfif FORM.submitted>
 
		<!---
			Strip out non-numeric data from To field. For
			now, we are only goint to allow phone numbers.
		--->
		<cfset FORM.to = FORM.to.ReplaceAll(
			"[^\d]+",
			""
			) />
 
		<!--- Validate form fields. --->
 
		<cfif NOT Len( FORM.from )>
			<cfset ArrayAppend(
				arrErrors,
				"Please enter your FROM number"
				) />
		</cfif>
 
		<cfif NOT Len( FORM.to )>
			<cfset ArrayAppend(
				arrErrors,
				"Please enter your TO number"
				) />
		</cfif>
 
		<cfif NOT Len( FORM.message )>
			<cfset ArrayAppend(
				arrErrors,
				"Please enter your text message"
				) />
		</cfif>
 
 
		<!---
			Check to see if we have any form validation
			errors. If we do not, then we can process
			the form.
		--->
		<cfif NOT ArrayLen( arrErrors )>
 
			<!---
				Check to see which provider was selected. If
				no provider was selected then we are just gonna
				try to loop over all of them.
			--->
			<cfif NOT StructKeyExists( objProviders, FORM.provider )>
 
				<!---
					Set the provider value to all keys in
					the provider struct. That will allow us
					to loop over them.
				--->
				<cfset FORM.provider = StructKeyList(
					objProviders
					) />
 
			</cfif>
 
 
			<!---
				Loop over the provider values to send the
				SMS text message.
			--->
			<cfloop
				index="strProvider"
				list="#FORM.provider#"
				delimiters=",">
 
 
				<!---
					When sending out the CFMail, be sure to put
					the full email address in the TO including
					the provider-specific domain.
				--->
				<cfmail
					to="#FORM.to#@#objProviders[ strProvider ]#"
					from="#FORM.from#"
					subject="New Message"
					type="text">
 
					<!---
						Set the text part of the message. This
						allows us to sent a text message without
						destroying our beloved tabbing.
					--->
					<cfmailpart
						type="text"
						>#FORM.message#</cfmailpart>
 
				</cfmail>
 
 
			</cfloop>
 
 
			<!---
				Send the user back to the same page with a
				new form (mostly so that they do not re-submit
				the form twice). I like to put in a RandRange()
				sometimes, just to make sure there is no
				strange caching taking place.
			--->
			<cflocation
				url="#CGI.script_name#?#RandRange( 1, 100 )#"
				addtoken="false"
				/>
 
		</cfif>
 
	</cfif>
 
</cfsilent>
 
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title>
		Sending Text Messages (SMS) With ColdFusion
		And CFMail
	</title>
</head>
<body>
 
	<cfoutput>
 
		<!---
			Check to see if we have any form validation
			errors to display.
		--->
		<cfif ArrayLen( arrErrors )>
 
			<p>
				Please review the following issues:
			</p>
 
			<ul>
				<cfloop
					index="intError"
					from="1"
					to="#ArrayLen( arrErrors )#"
					step="1">
 
					<li>
						#arrErrors[ intError ]#
					</li>
 
				</cfloop>
			</ul>
 
		</cfif>
 
		<form action="#CGI.script_name#" method="post">
 
			<!---
				This is our hidden value to flag that the
				form has been submitted (and is NOT loading
				for the first time).
			--->
			<input type="hidden" name="submitted" value="1" />
 
 
			<label for="from">
				From:
 
				<input
					type="text"
					name="from"
					id="from"
					value="#FORM.from#"
					/>
			</label>
			<br />
 
			<label for="to">
				To:
 
				<input
					type="text"
					name="to"
					id="to"
					value="#FORM.to#"
					/>
			</label>
 
			<select name="provider">
				<option value="">-- Not Sure --</option>
 
				<!--- Loop over providers. --->
				<cfloop
					index="strName"
					list="#StructKeyList( objProviders )#"
					delimiters=",">
 
					<option value="#strName#"
						<cfif (FORM.provider EQ strName)>
							selected="true"
						</cfif>
						>#strName#</option>
 
				</cfloop>
			</select>
			<br />
 
			<label for="message">
				Message:
 
				<input
					type="text"
					name="message"
					id="message"
					value="#FORM.message#"
					maxlength="160"
					/>
			</label>
			<br />
 
			<input
				type="submit"
				value="Send SMS Text Message"
				/>
 
		</form>
 
	</cfoutput>
</body>
</html>