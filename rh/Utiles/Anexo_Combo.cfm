<cfquery name="rsHojasDest" datasource="#Session.dsn#">
	select distinct AnexoHoja
	from AnexoCel
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#HTMLEditFormat(url.Anexodst)#">
	order by AnexoHoja
</cfquery>

<cfoutput>
	<select name="sel_Hojadst" id="sel_Hojadst" tabindex="1"> 
		<cfif HTMLEditFormat(url.Anexodst) NEQ HTMLEditFormat(url.Anexosrc)>
			<option  value="">{misma hoja}</option>
		</cfif>
		<cfloop query="rsHojasDest">
			<option  value="#rsHojasDest.AnexoHoja#">#rsHojasDest.AnexoHoja#</option>
		</cfloop>
	</select>
</cfoutput>





