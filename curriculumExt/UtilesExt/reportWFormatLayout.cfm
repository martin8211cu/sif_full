<cfswitch expression="#url.formato#">
	<cfcase value="HTML">
		<cfsilent>
			<cfset lTitle = ""><cfif isdefined("nav__SPdescripcion")> <cfset lTitle = "#nav__SPdescripcion#"> </cfif>
    	    <cfset lFileName = "">
			<cfif isdefined("url.url")> 
				<cfloop list="#url.url#" delimiters="/" index="section">
					<cfset lFileName = Replace(section,'.cfm','#LSDATEFORMAT(NOW(),'YYYYMMDD_HH_MM_SS')#.xls')> 
                </cfloop>
			</cfif>
        </cfsilent>
        <cfoutput>
        	<cf_htmlReportsHeaders irA="#url.url#" FileName="#lFileName#" 
        	method="get" title="#lTitle#" back="false" close="false" 
            print="true" download="true" preview="false">
		</cfoutput>
    	<cfinclude template="#url.url#">
    </cfcase>
    <cfdefaultcase>
		<cfdocument format="#url.formato#" 
                marginleft="2" 
                marginright="2" 
                marginbottom="3"
                margintop="1" 
                unit="cm" 
                pagetype="letter"
                orientation="#url.orientacion#"> 
				<cfif isdefined('url.pagina') and LEN(TRIM(url.pagina))>
				<!--- Se define pie de pagina --->
					<cfdocumentitem type="footer">
						<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td align="right" valign="top" style="font-family:Arial, Helvetica, sans-serif;  " height="12px">
								<cfoutput>#cfdocument.currentpagenumber# - #cfdocument.totalpagecount#</cfoutput>
							</td>
							</td>
						  </tr>
						</table>
					</cfdocumentitem>
				</cfif>
			<cfinclude template="#url.url#">
        </cfdocument>
    </cfdefaultcase>
</cfswitch>

