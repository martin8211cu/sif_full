
		<cfquery name="MyQuery" datasource="minisif" maxrows="50">
			set rowcount 50
			Select *
 from DCGRBalanceComprobacion d
            , CGRBalanceComprobacion e
where d.Ecodigo=1
<!---    and d.CGRBCid=$P{CGRBCid} --->
    and d.Ecodigo=e.Ecodigo
    and d.CGRBCid=e.CGRBCid
order by corte, mayor, formato

			set rowcount 0

		</cfquery> 

<cfreport template="BalCompCFR.cfr" format="flashpaper" query="MyQuery">
	<cfreportparam name="Ecodigo" value="MyValue"> <!-- Integer -->
	<cfreportparam name="periodo" value="MyValue"> <!-- Integer -->
	<cfreportparam name="mes" value="MyValue"> <!-- Integer -->
	<cfreportparam name="nivel" value="MyValue"> <!-- Integer -->
	<cfreportparam name="usuario" value="MyValue"> <!-- String -->
	<cfreportparam name="Mcodigo" value="MyValue"> <!-- Big Decimal -->
	<cfreportparam name="Ocodigo" value="MyValue"> <!-- Big Decimal -->
	<cfreportparam name="cuentaini" value="MyValue"> <!-- String -->
	<cfreportparam name="cuentafin" value="MyValue"> <!-- String -->
	<cfreportparam name="ceros" value="MyValue"> <!-- String -->
	<cfreportparam name="CGRBCid" value="MyValue"> <!-- Big Decimal -->
</cfreport>