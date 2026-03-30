<cftransaction>
1 = mio
<cfquery datasource="minisif">
	insert jfk values (1)
</cfquery>


<cftransaction action="commit" >

2=oscar y compras
<cfquery datasource="minisif">
	insert jfk values (2)
</cfquery>

<cftransaction action="rollback" >

3=resto mio
<cfquery datasource="minisif">
	insert jfk values (3)
</cfquery>

</cftransaction>