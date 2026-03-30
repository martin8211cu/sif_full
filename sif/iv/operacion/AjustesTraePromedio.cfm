<cfif isdefined("url.aAid") and url.aAid NEQ ""  and isdefined("url.Aid") and url.Aid NEQ "" and isdefined("url.DAcantidad") and url.DAcantidad NEQ "">
	<cfinvoke 
	component="sif.Componentes.IN_PosteoLin" 
	method="IN_CostoActual"  
		Ecodigo = "#Session.Ecodigo#"
		Aid="#url.aAid#"
		Alm_Aid="#url.Aid#"
		Cantidad="#url.DAcantidad#"
		tcFecha="#now()#"
		returnvariable="struc"/>
	<script language="JavaScript" type="text/JavaScript" src="../../js/utilesMonto.js"></script>
	<cfoutput>
		<cfif isdefined("struc.valuacion.costo") and struc.valuacion.costo NEQ "">
			<script language="JavaScript">
				window.parent.document.ajustes.DAcosto.value="#struc.valuacion.costo#";
				fm(window.parent.document.ajustes.DAcosto,2);
			</script>
		</cfif>
	</cfoutput>
</cfif>
