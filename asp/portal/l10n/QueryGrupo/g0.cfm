
<cfquery datasource="sifcontrol" name="grupo">

	select ltrim(rtrim(VSvalor)) as valor, VSdesc as descr,VSgrupo as grupo, '' as refer
			from VSidioma
			where Iid = 1
			  and VSgrupo = 0
			order by VSvalor
</cfquery>
