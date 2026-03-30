<cfif IsDefined('form.ok') or IsDefined('url.ok')>
<cfinvoke component="asp.parches.comp.parche" method="olvidar_parche" />
</cfif>
<cflocation url="admguardar.cfm">