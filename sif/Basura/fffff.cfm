<cftransaction>

<cfquery datasource="asp">
select db_name()
</cfquery>

<cftransaction action="commit" />
<cftransaction action="begin" />

<cfquery datasource="minisif">
select db_name()
</cfquery>

</cftransaction>