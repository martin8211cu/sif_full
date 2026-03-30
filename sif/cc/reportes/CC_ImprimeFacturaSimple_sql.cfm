<cfif isdefined('form.Reporte') and isdefined('form.lista1')>
	<cf_htmlReportsHeaders 
		title="Facturacion" 
		filename="Facturacion#dateformat(now(),'dd/mm/yyyy')#.xls"
		irA="CC_ImprimeFacturaSimple_form.cfm?Imprime=1"
		>
	<cfset LvarCantidad = listlen(form.chk,',')>
	<cfset LvarContador = 0>
	<cfloop list="#form.chk#" delimiters="," index="i">
		<cfset LvarContador = LvarContador + 1>
		<cfset LvarLlave = ListToArray(i,'|') >
		<cfinvoke component="sif.Componentes.CC_ImprimeFacturaSimple" method="ImprimeFacturaCxC" returnvariable="pagina"
			Ecodigo = "#LvarLlave[1]#"
			CCTcodigo = "#LvarLlave[2]#"
			Ddocumento = "#LvarLlave[3]#"
			ImpAsiento = "#LvarLlave[4]#"
			datasource = "#session.DSN#"/>
		<cfoutput>#pagina#</cfoutput>
		
		<cfif LvarContador LT LvarCantidad>
			<br />
			<STYLE>
			.Pw { page-break-after: always}
			</STYLE>
			<div id="Pw" class="Pw">&nbsp;</div>
		</cfif>
	</cfloop>
</cfif>