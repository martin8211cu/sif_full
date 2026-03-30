<style type="text/css">
<!--
.style1 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<cfoutput>

<cfif not isdefined("Gastos") >
	<cfset Gastos = "../operacion/cjc_PrincipalGasto.cfm">
</cfif>
<cfif not isdefined("Anticipos") >
	<cfset Anticipos = "../operacion/cjc_PrincipalAnticipos.cfm">
</cfif>
<cfif not isdefined("Posteo") >
	<cfset Posteo = "../operacion/cjc_PrincipalPosteo.cfm">
</cfif>

<cfif not isdefined("Consulta") >
	<cfset Posteo = "../operacion/cjc_PrincipalConsulta.cfm">
</cfif>


<table width="100%" border="0" cellpadding="4" cellspacing="0" >
  <tr align="left"> 
	<td  id="GAT"  style="background-color:dodgerblue " width="10%"><a  href="#Gastos#" class="style1">Digitaci&oacute;n de Gastos</a></td>
	<td  id="ANT"  style="background-color:dodgerblue" width="10%"><a  href="#Anticipos#" class="style1">Digitaci&oacute;n de Anticipos y vales</a></td>
    <td  id="PST"  style="background-color:dodgerblue" width="10%"><a  href="#Posteo#" class="style1">Resumen</a></td>
    <td  id="CON"  style="background-color:dodgerblue" width="10%"><a  href="#Consulta#" class="style1">Consultar</a></td>
    <td  id="BLA"  style="background-color:dodgerblue" width="10%"></td>
  </tr>
</table>
</cfoutput>
<script language="JavaScript1.2" type="text/javascript">	
	function seleccionado(campo){
		var GAT  	= document.getElementById("GAT")
		var ANT  	= document.getElementById("ANT")
		var PST  	= document.getElementById("PST")
		var CON  	= document.getElementById("CON")
		if (campo == "GAT") {
			GAT.style.backgroundColor='steelblue'
			ANT.style.backgroundColor='dodgerblue'
			PST.style.backgroundColor='dodgerblue'
			CON.style.backgroundColor='dodgerblue'
		} 
		if (campo == "ANT") {
			ANT.style.backgroundColor='steelblue'
			GAT.style.backgroundColor='dodgerblue'
			PST.style.backgroundColor='dodgerblue'
			CON.style.backgroundColor='dodgerblue'
		}
		if (campo == "PST") {
			PST.style.backgroundColor='steelblue'
			GAT.style.backgroundColor='dodgerblue'
			ANT.style.backgroundColor='dodgerblue'
			CON.style.backgroundColor='dodgerblue'			
		}		
		if (campo == "CON") {
			CON.style.backgroundColor='steelblue'
			GAT.style.backgroundColor='dodgerblue'
			ANT.style.backgroundColor='dodgerblue'
			PST.style.backgroundColor='dodgerblue'			
		}		
	}
</script> 	