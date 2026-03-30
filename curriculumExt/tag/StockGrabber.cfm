<!------------------------------------------------------------------------
NAME:           CF_StockGrabber
FILE:			StockGrabber.cfm
CREATED:		09/20/1997
LAST MODIFIED:	06/02/1998
VERSION:	    2.0
AUTHOR:         Rob Bilson (rbils@amkor.com)
DESCRIPTION:    This tag queries Yahoo with a list of ticker symbols.
			    The results are parsed and presented to the user as
			    variables.  These variables can be used in a wide varity
			    of ways such as sending the quotes in an e-mail,  to a
			    pager's e-mail address, in a table, inserted into a query,
			    stored in a database, or as a text file.  Error handling
				is built into the tag.	This tag makes use of CFHttp and
				requires Cold Fusion 3.01 or later to ensure reliability.
NEW THIS VER:   The following are new additions in this version:
					1.  Added support for Canadian exchanges.
					2.  Added support for indexes such as the Dow Jones
					    Industrial Index (^DJI)
					3.  Added support for mutual funds
					4.  Fixed a small bug that caused the tag to crash
					    if an invalid ticker symbol was passed
					5.  Added additional variable:  Exchange 
					6.  Added more control over custom error pages
COPYRIGHT:		Copyright (C) 1997-1998 by Rob Bilson, All Rights Reserved
				This program is free software; you can redistribute it
				and/or modify it under the terms of the GNU General Public
				License as published by the Free Software Foundation;
				either version 2 of the License, or any later version.

				This program is distributed in the hope that it will be
				useful, but WITHOUT ANY WARRANTY; without even the implied
				warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
				PURPOSE.  See the GNU General Public License for more
				details.
				
				You should have received a copy of the GNU General Public
				License along with this program; if not, write to the Free
				Software Foundation, Inc., 59 Temple Place - Suite 330,
				Boston, MA  02111-1307, USA.
KNOWN ISSUES:   None
------------------------------------------------------------------------->

<!--------------------------------------------------------------------
		Check to see if the user has error checking turned on
		or not.  If they do, assign all appropriate error
		checking values.  If not, ignore this section. If an error
		occurs, route the user to the error page.  This line can be
		customized to refer the user to a different page.
--------------------------------------------------------------------->
<cfif isdefined('attributes.ErrorCheck')>
	<CFIF #Attributes.ErrorCheck# IS "Yes">

	<CFIF NOT ISDEFINED('attributes.ErrorPage')>
		<CFSET #Attributes.ErrorPage#="error.cfm">
	</CFIF>
	
	<CFIF NOT ISDEFINED('attributes.ErrorMailTo')>
		<CFSET #Attributes.ErrorMailTo#="">
	</CFIF>

	<CFERROR type="request"
			 template="#Attributes.ErrorPage#"
			 mailto="#Attributes.ErrorMailTo#">
	</CFIF>
</CFIF>

<!--------------------------------------------------------------------
        BECAUSE OF A BUG IN THE WAY THAT CFHTTP INTERACTS WITH COMMA
		SEPERATED TEXT FILES, IT IS NECESSARY TO INSERT AN EXTRA
		RECORD IN THE BEGINNING THAT GETS OMITTED BY CFHTTP.  THIS EXTRA
		RECORD IS ADDED BY APPENDING A DUPLIUCATE TICKER SYMBOL TO THE
		LIST BEING PASSED TO YAHOO                                         
--------------------------------------------------------------------->
<CFSET #Symbol_List# = #ListFirst(Attributes.TickerSymbols)#>

<!--------------------------------------------------------------------
		CHECKS TO SEE IF A LIST OF SYMBOLS WAS PASSED, AND IF SO,
		STRIPS THE COMMA DELIMITERS AND ADDS THE + SIGN INSTEAD
		SO THAT IT CAN BE PASSED TO YAHOO IN A URL.  IF NO SYMBOLS
		ARE PASSED, CF_STOCKGRABBER WILL STILL EXECUTE, USING
		YAHOO'S SYMBOL :-)
--------------------------------------------------------------------->
<CFIF #ParameterExists(Attributes.TickerSymbols)# IS "Yes">
	<CFIF #Attributes.TickerSymbols# IS "">
		<CFSET #TickerSymbols# ="yhoo">
		<CFSET #Symbol_List# = ListAppend(#Symbol_List#,#TickerSymbols#)>
	<CFELSE>
		<CFSET #TickerSymbols# ="#Attributes.TickerSymbols#">
		<CFSET #Symbol_List# = ListAppend(#Symbol_List#,#TickerSymbols#)>
	</CFIF>
<CFELSE>
	<CFSET #TickerSymbols# ="yhoo">
	<CFSET #Symbol_List# = ListAppend(#Symbol_List#,#TickerSymbols#)>
</CFIF>

<!-------------------------------------------------------------------
		THIS IS WHERE THE DELIMITERS ARE CHANGED TO + SIGNS
-------------------------------------------------------------------->
<CFSET #Symbol_List# = ListChangeDelims(#Symbol_List#, "+")>

<!-------------------------------------------------------------------
		BECAUSE AN EXTRA + SIGN IS ADDED TO THE LIST, IT
		NEEDS TO BE REMOVED OR IT WILL CAUSE AN ERROR
-------------------------------------------------------------------->
<CFSET #RemovePlus# = Len(#Symbol_List#)>
<CFSET #Symbol_List# = RemoveChars(#Symbol_List#, #RemovePlus#, 1)>

<CFIF #ParameterExists(Attributes.QueryName)# IS "Yes">
	<CFIF #Attributes.QueryName# IS "">
		<CFSET #QueryName# ="GetQuotes">
		<CFSET #Caller.QueryName# ="GetQuotes">		
	<CFELSE>
		<CFSET #QueryName# ="#Attributes.QueryName#">
	</CFIF>
<CFELSE>
	<CFSET #QueryName# ="GetQuotes">
	<CFSET #Caller.QueryName# ="GetQuotes">	
</CFIF>

<!-------------------------------------------------------------------
		Using CFHttp, go out to Yahoo's site, query the
		server for the desired quotes, returning the results
		as a comma seperated list, parsing the list into
		variables, and returning them to the user.
-------------------------------------------------------------------->


<!--- Get the Us/Canada quotes --->
<CFHTTP METHOD="GET"
		URL="http://quote.yahoo.com/download/quotes.csv?Symbols=#Symbol_List#&format=sl1d1t1c1ohgv&ext=.csv"
		NAME="#QueryName#"
		COLUMNS="Symbol,Last_Traded_Price,Last_Traded_Date,Last_Traded_Time,Change,Opening_Price,Days_High,Days_Low,Volume"
		DELIMITER=","
		TEXTQUALIFIER="">
		
<!--- RECREATE QUERY --->
<CFSET MyArray = ArrayNew(1)>
<CFSET MyQuery = Evaluate("#QueryName#")>
<CFSET NewColumns = "#MyQuery.ColumnList#, EXCHANGE">
<CFSET NewQuery = QueryNew(NewColumns)>

<!--- ADD ROWNUMBER TO END OF EACH ROW'S VALUE --->
<CFOUTPUT QUERY="MyQuery">
  <CFSET MyArray[CurrentRow] = NumberFormat(CurrentRow, "000009")>
  <CFSET Temp = QueryAddRow(NewQuery)>
</CFOUTPUT>

  	
<!--- POPULATE THE NEW QUERY WITH THE INFO FROM THE OLD ONE, BUT WITH ALL QUOTES REMOVED --->
<CFLOOP FROM=1 TO=#MyQuery.RecordCount# INDEX="This">
  <CFSET Row = Val(Right(MyArray[This], 6))>
  <CFLOOP LIST="#MyQuery.ColumnList#" INDEX="Col">

  <CFIF RIGHT(Evaluate("MyQuery.Symbol[Row]"),3) IS ".M""">
  	<CFSET Exch="Montreal">
  <CFELSEIF RIGHT(Evaluate("MyQuery.Symbol[Row]"),3) IS ".V""">
  	<CFSET Exch="Vancouver">
  <CFELSEIF RIGHT(Evaluate("MyQuery.Symbol[Row]"),4) IS ".TO""">
  	<CFSET Exch="Toronto">
  <CFELSEIF RIGHT(Evaluate("MyQuery.Symbol[Row]"),4) IS ".AL""">
  	<CFSET Exch="Alberta">
  <CFELSE>
  	<CFSET Exch="US">
  </CFIF>
  
    <CFSET Temp = QuerySetCell(NewQuery, Col, Replace(Evaluate("MyQuery.#Col#[Row]"),"""","","All"), This)>
  </CFLOOP>
 <CFSET Temp = QuerySetCell(NewQuery, "EXCHANGE", Exch, this)>
</CFLOOP>

<!--- PASS QUERY WITH QUOTATION MARKS REMOVED BACK TO CALLING TEMPLATE --->
<CFSET "Caller.#QueryName#" = NewQuery>

