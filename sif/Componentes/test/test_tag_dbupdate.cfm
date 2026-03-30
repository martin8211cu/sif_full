<cfset x=" ">
<!--- <cfdump var="#x#"> --->
<table><tr>
<cfloop list="a,b" index="tabla">
	<cftry>
		<cfquery datasource="minisif">
		drop table #tabla# 
		</cfquery>
		<cfcatch type="any">exception ignored: <cfoutput>#cfcatch.Message#</cfoutput></cfcatch>
	</cftry>
	<cftry>
		<cfquery datasource="minisif">
		create table #tabla# (n int, k int, name varchar(10), extra varchar(10), constraint pk_#tabla# primary key (n))
		</cfquery>
		<cfcatch type="any">exception ignored: <cfoutput>#cfcatch.Message#</cfoutput></cfcatch>
	</cftry>

	<cfquery datasource="minisif">
	delete  #tabla#
	</cfquery>

	<cfloop list="1,2,3,4" index="n">
		<cfquery datasource="minisif">
		insert into #tabla# values (#n#, 0, '#tabla##n#', 'extra')
		</cfquery>
	</cfloop>
	<cfquery datasource="minisif" name="datos"> select * from #tabla# </cfquery>
	<td valign="top"><!--- <cfdump var="#datos#" label="#tabla# antes &nbsp; &nbsp; "> ---></td>
</cfloop>
</tr></table>

<cf_dbupdate table="a" datasource="minisif">
	<cf_dbupdate_join table="b" type="inner">
		on a.n = b.n
		and a.n != <cf_dbupdate_param type="integer" value="999">
		and a.n != <cf_dbupdate_param type="integer" value="997">
	</cf_dbupdate_join>
	<cf_dbupdate_set name='a.name' expr="b.name" />
	<cf_dbupdate_set name='a.k' type="integer" value="42" />
	<cf_dbupdate_set name='a.extra' type="varchar" value="s" null="yes" />
	<cf_dbupdate_where>
		WHERE a.n >  <cf_dbupdate_param type="integer" value="3">
		  and a.n >= <cf_dbupdate_param type="integer" value="4">
	</cf_dbupdate_where>
</cf_dbupdate>

<table><tr><td valign="top">
<cfquery datasource="minisif" name="datos"> select * from a </cfquery> <!--- <cfdump var="#datos#" label="a despues"> --->
</td><td valign="top">
<cfquery datasource="minisif" name="datos"> select * from b </cfquery> <!--- <cfdump var="#datos#" label="b despues"> --->
</td></tr></table>
