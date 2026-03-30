<!--- SUSPEND OUTPUT TO ELIMINATE WHITESPACE --->
<CFSETTING ENABLECFOUTPUTONLY="YES">


<!--- TAG DEFAULTS --->
<CFSET ScopesAvail = "Client,URL,Form,Cookie">
<CFPARAM NAME="Attributes.Scopes" DEFAULT="">
<CFPARAM NAME="Attributes.Dump" DEFAULT="No">
<CFPARAM NAME="Attributes.DumpTitle" DEFAULT="Defined Variables">
<CFPARAM NAME="Attributes.Variable" DEFAULT="VariableList">
<CFPARAM NAME="Attributes.PrefixWithScope" DEFAULT="Yes">
<CFPARAM NAME="Attributes.PassToScope" DEFAULT="">
<CFPARAM NAME="Attributes.Except" DEFAULT="">
<CFPARAM NAME="Attributes.Additional" DEFAULT="">


<!--- IMPORTANT LOCAL VARIABLES --->
<CFSET Vars = "">        <!--- THIS VARIABLE HOLDS THE LIST OF FULLY-SCOPED VARIABLES NAMES AS WE WORK --->
<CFSET VarsOut = "">     <!--- THIS VARIABLE HOLDS THE NAMES WE'LL "EXPOSE" (MAY NOT BE FULLY-SCOPED) --->


<!--- ALLOW USER TO SIMPLY PUT "ALL" IN FOR THE TAG'S SCOPES PARAMETER --->
<CFIF Attributes.Scopes is "All">
  <CFSET Attributes.Scopes = ScopesAvail>
</CFIF>


<!--- IF SPECIFIC VARIABLE NAMES WERE SUPPLIED IN THE "ADDITIONAL" PARAMETER --->
<CFIF Attributes.Additional is not "">
  <CFLOOP INDEX="ThisVar" LIST="#Attributes.Additional#">
	  <CFIF IsDefined("Caller.#ThisVar#")>
	    <CFSET Vars = ListAppend(Vars, "Caller.#ThisVar#")>
		</CFIF>
	</CFLOOP>
</CFIF>


<!--- MOVE THROUGH ALL SPECIFIED SCOPES AND "SCOOP UP" THE VARIABLE NAMES FROM EACH --->
<CFLOOP INDEX="ThisScope" LIST="#Attributes.Scopes#">
  <CFSET ThisScope = Trim(ThisScope)>

	<!--- IF WE ARE SUPPOSED TO HANDLE CLIENT VARIABLES --->
	<CFIF ThisScope is "Client">
	  <CFLOOP INDEX="ThisVar" LIST="#GetClientVariablesList()#">
		  <CFSET Vars = ListAppend(Vars, "Client." & ThisVar)>
	  </CFLOOP>
	
	<!--- IF WE ARE SUPPOSED TO HANDLE FORM VARIABLES --->
	<CFELSEIF ThisScope is "Form">
	  <CFIF ParameterExists(Form.FIELDNAMES)>
		  <CFLOOP INDEX="ThisVar" LIST="#Form.FIELDNAMES#">
			  <CFSET Vars = ListAppend(Vars, "Form." & ThisVar)>
		  </CFLOOP>
	  </CFIF>
	
	<!--- IF WE ARE SUPPOSED TO HANDLE URL VARIABLES --->
	<CFELSEIF ThisScope is "URL">
	  <CFIF ParameterExists(CGI.QUERY_STRING)>
		  <CFLOOP LIST="#CGI.QUERY_STRING#" INDEX="This" DELIMITERS="&">
			  <CFSET Vars = ListAppend(Vars, "URL." & ListFirst(This, "="))>
			</CFLOOP>
		</CFIF>
	
	<!--- IF WE ARE SUPPOSED TO HANDLE COOKIE VARIABLES --->
	<CFELSEIF ThisScope is "Cookie">
		<CFPARAM NAME="HTTP_COOKIE" DEFAULT="">
		<CFLOOP LIST="#HTTP_COOKIE#" INDEX="This" DELIMITERS=";">
		  <CFSET Vars = ListAppend(Vars, "Cookie." & Trim(ListFirst(This, "=")))>
		</CFLOOP>

	<!--- IF WE ARE SUPPOSED TO HANDLE "VARIABLES" (COLUMNS) FROM A QUERY --->
	<CFELSEIF IsDefined("Caller.#ThisScope#")>
		<CFIF Evaluate("IsQuery(Caller.#ThisScope#)")>
			<CFLOOP LIST="#Evaluate('Caller.#ThisScope#.ColumnList')#" INDEX="This">
			  <CFSET Vars = ListAppend(Vars, "#ThisScope#." & This)>
				<CFOUTPUT>#Vars#</CFOUTPUT>
			</CFLOOP>
		</CFIF>

	</CFIF>

</CFLOOP>  <!--- DONE "SCOOPING UP" VARIABLE NAMES --->



<!--- STRIP OFF PREFIX IF SCOPE NOT DESIRED --->
<CFIF Attributes.PrefixWithScope is "Yes">
  <CFLOOP INDEX="ThisVar" LIST="#Vars#">
    <CFIF ListFirst(ThisVar, ".") is "Caller">
		  <CFSET VarsOut = ListAppend(VarsOut, ListRest(ThisVar, "."))>
		<CFELSE>	
		  <CFSET VarsOut = ListAppend(VarsOut, ThisVar)>
		</CFIF>
	</CFLOOP>
<CFELSE>
  <CFLOOP INDEX="ThisVar" LIST="#Vars#">
    <CFSET VarsOut = ListAppend(VarsOut, ListRest(ThisVar, "."))>
	</CFLOOP>
</CFIF>


<!--- DEAL WITH VARIABLES THAT WE ARE NOT SUPPOSED TO HANDLE, PER THE TAG'S "EXCEPT" PARAMETER --->
<CFIF Trim(Attributes.Except) is not "">
  <CFLOOP INDEX="ThisVar" LIST="#Attributes.Except#">
	  <CFSET IsInThere = ListContainsNoCase(VarsOut, ThisVar)>
    <CFIF IsInThere>
		  <CFSET Vars = ListDeleteAt(Vars, IsInThere)>
		  <CFSET VarsOut = ListDeleteAt(VarsOut, IsInThere)>
		</CFIF>
	</CFLOOP>
</CFIF>



<!--- IF PASSING TO ANOTHER VARIABLE "SCOPE" --->
<CFIF Trim(Attributes.PassToScope) is not "">
  <CFSET Pass = "">

  <!--- PASS AS URL VARIABLES --->
  <CFIF Attributes.PassToScope is "URL">
	  <CFLOOP INDEX="ThisVar" LIST="#Vars#">
		  <CFSET Pass = Pass & "&#ListRest(ThisVar, ".")#=#Evaluate("URLEncodedFormat(Evaluate(ThisVar))")#">
    </CFLOOP>
    <CFSET Caller.VariableList_PassToURL = Pass>

  <!--- PASS AS FORM VARIABLES --->
  <CFELSEIF Attributes.PassToScope is "Form">
	  <CFLOOP INDEX="ThisVar" LIST="#Vars#">
		  <CFOUTPUT><INPUT TYPE="Hidden" NAME="#ListRest(ThisVar, ".")#" VALUE="#Evaluate("URLEncodedFormat(Evaluate(ThisVar))")#"></CFOUTPUT>
    </CFLOOP>

  <!--- PASS AS OTHER TYPES OF VARIABLES --->
  <CFELSEIF ListContainsNoCase("Client,Cookie,Server,Application,Variables", Attributes.PassToScope)>
	  <CFLOOP INDEX="ThisVar" LIST="#Vars#">
		  <CFSET "#Attributes.PassToScope#.#ListRest(ThisVar, ".")#" = Evaluate("URLEncodedFormat(Evaluate(ThisVar))")>
    </CFLOOP>


  <!--- PASS AS AN EMAIL MESSAGE --->
  <CFELSEIF Attributes.PassToScope is "EMail">
	  <!--- ADDITIONAL TAG PARAMETERS TO DO WITH EMAIL --->
    <CFPARAM NAME="Attributes.From">
    <CFPARAM NAME="Attributes.To">
    <CFPARAM NAME="Attributes.Subject" DEFAULT="Form submission: #GetTemplatePath()# (#DateFormat(Now())# #TimeFormat(Now())#)">
    <CFPARAM NAME="Attributes.CC" DEFAULT="">
    <CFPARAM NAME="Attributes.Message" DEFAULT="">
    <CFPARAM NAME="Attributes.Type" DEFAULT="">
	
    <!--- PUT TOGETHER THE MESSAGE TO DISPLAY IN EMAIL MESSAGE --->
    <CFIF Attributes.Type is "HTML">
	    <CFSET Message = "<HTML><BODY>#Attributes.Message#<P><TABLE BORDER>">
		  <CFLOOP INDEX="ThisVar" LIST="#Vars#">
			  <CFSET Message = Message & "<TR><TD>" & ThisVar & "</TD><TD>" & Evaluate(ThisVar) & "</TD></TR>">
	    </CFLOOP>
			<CFSET Message = Message & "</TABLE></BODY></HTML>">

	    <!--- SEND THE COMPOSED MESSAGE VIA EMAIL --->
		  <CFMAIL
			  FROM="#Attributes.From#"
			  TO="#Attributes.To#"
				SUBJECT="#Attributes.Subject#"
				CC="#Attributes.CC#"
				TYPE="HTML">#Message#</CFMAIL>	

		<CFELSE>
	    <CFSET Message = Attributes.Message & Chr(10) & Chr(10)>
		  <CFLOOP INDEX="ThisVar" LIST="#Vars#">
			  <CFSET Message = Message & ThisVar & ": " & Evaluate(ThisVar) & Chr(10)>
	    </CFLOOP>

	    <!--- SEND THE COMPOSED MESSAGE VIA EMAIL --->
		  <CFMAIL
			  FROM="#Attributes.From#"
			  TO="#Attributes.To#"
				SUBJECT="#Attributes.Subject#"
				CC="#Attributes.CC#">#Message#</CFMAIL>	

		</CFIF>



  <!--- PASS AS A QUERY --->
  <CFELSE>
	  <!--- CAN'T PREFIX WITH SCOPE OR ELSE WE'LL END UP WITH ILLEGAL COLUMN NAMES --->
	  <CFIF Attributes.PrefixWithScope>
		  <CFABORT SHOWERROR="When providing a query name to PASSTOSCOPE, PREFIXWITHSCOPE must be ""No"".">
		</CFIF>

    <!--- USE THE LAST PART OF EACH VARIABLE NAME AS THE COLUMN NAMES FOR THE NEW QUERY --->
    <CFSET ColNames = "">
		<CFLOOP INDEX="This" LIST="#Vars#">
		  <CFSET ColNames = ListAppend(ColNames, ListGetAt(This, ListLen(This, "."), "."))>
		</CFLOOP>

    <!--- CREATE THE NEW QUERY AND ADD AN EMPTY ROW TO IT --->
    <CFSET NewQuery = QueryNew(ColNames)>
		<CFSET Temp = QueryAddRow(NewQuery)>

    <!--- POPULATE THE QUERY WITH THE VALUES OF THE VARIOUS VARIABLES --->
	  <CFLOOP INDEX="This" FROM="1" TO="#ListLen(VarsOut)#">
		  <CFSET ThisVar = ListGetAt(Vars, This)>
		  <CFSET ThisCol = ListGetAt(ColNames, This)>
		  <CFSET Temp = QuerySetCell(NewQuery, ThisCol, Evaluate(ThisVar))>
    </CFLOOP>
		
    <!--- PASS THE NEW QUERY OUT TO THE CALLING TEMPLATE --->
		<CFSET "Caller.#Attributes.PassToScope#" = NewQuery>
  </CFIF>

</CFIF>


<!--- SET APPROPRIATE VARIABLE IN CALLING TEMPLATE --->
<CFSET "Caller.#Attributes.Variable#" = VarsOut>


<!--- IF "DUMPING" VARIABLE NAMES AND VALUES IN TABLE --->
<CFIF Attributes.Dump is "Yes">
  <!--- START TABLE --->
  <CFOUTPUT><TABLE BORDER="1"></CFOUTPUT>
	<!--- TITLE --->
	<CFIF Trim(Attributes.DumpTitle) is not ""><CFOUTPUT><TR><TH COLSPAN="2">#Attributes.DumpTitle#</TH></TR></CFOUTPUT></CFIF>
	<!--- ROWS --->
	<CFLOOP INDEX="This" FROM="1" TO="#ListLen(VarsOut)#">
	   <CFSET ThisVar = ListGetAt(Vars, This)>
	   <CFSET ThisVarOut = ListGetAt(VarsOut, This)>
    <CFOUTPUT><TR VALIGN="TOP"><TD>#ThisVarOut#</TD><TD>#Evaluate("HTMLEditFormat(#ThisVar#)")# </TD></TR></CFOUTPUT>
	</CFLOOP>
	<!--- DONE WITH TABLE --->
  <CFOUTPUT></TABLE></CFOUTPUT>
</CFIF>


<!--- RESUME NORMAL OUTPUT --->
<CFSETTING ENABLECFOUTPUTONLY="NO">