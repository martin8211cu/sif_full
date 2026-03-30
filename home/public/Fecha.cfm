<cfset l=DateDiff("m","2/28/04","3/28/04")>
<cfset s = DateDiff("m","2/29/04","3/29/04")>
Esto esta malo:<br />
<cfoutput>#l#</cfoutput><br />
<cfoutput>#s#</cfoutput><br />

Usando Createdate de CF:<br />
<cfset Lv= createdate(2004,2, 28)>
<cfset Lc= createdate(2004,3,28)>

<cfset Lv2= createdate(2004,2,29)>
<cfset Lc2= createdate(2004,3,29)>



<cfoutput>
lv: #lv#<br />
lc: #lc#<br />
<br />
lv2: #lv2#<br />
lc2: #lc2#<br />
</cfoutput>


<cfset l=DateDiff("m",lv,lc)>
<cfset s=DateDiff("m",lv2,lc2)>

<cfoutput>#l#</cfoutput><br />
<cfoutput>#s#</cfoutput><br />



<!--- <cfdump var="#DateFormat(CreateDate(dateFormat(Now(), 'yyyy'),dateFormat(Now(), 'mm'),1),'dd/mm/yyyy')#"> --->