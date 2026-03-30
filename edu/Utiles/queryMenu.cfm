<cfquery name="rsMenuPrincipal" datasource="asp">
select distinct
 '' as STdescripcion,
 '' as Snombre,
 '' as Scodigo, 
 '' as STcodigo, 
 '' as Stipo, 
 '' as Suri,
 '' as Sproceso
from dual
where 1 = 2
</cfquery>
<script type="text/javascript">
	var menuPrincipalOptions = new Array (
<cfoutput query="rsMenuPrincipal">
	new Array('#rsMenuPrincipal.Snombre#','/cfmx#rsMenuPrincipal.Suri#'),
</cfoutput>
	new Array('','')
	);
</script>
