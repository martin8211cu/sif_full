<!--- 
Obtiene el Valor del Parámetro para saber el status en que se encuentra AF 
0. AF Abierto (Las transacciones que vienen desde CR se aplican)
1. AF Cerrado (Las transacciones que vienen desde CR se encolan)
2. Procesando la Cola (La cola de proceso )
No Existe.  AF Abierto (Las transacciones que vienen desde CR se aplican)
--->
<style type="text/css">
.style1 {
	color: #FF0000;
	font-weight: bold;
}
</style>
<cfquery datasource="#Session.DSN#" name="ValorParam">
	Select Pvalor 
	from Parametros 
	where Pcodigo=970 
	  and Ecodigo =  #session.Ecodigo# 
</cfquery>

<cfif ValorParam.recordcount eq 0 or ValorParam.Pvalor EQ 0>
	<cfset Paramvalor = 0>	
	<cfset msgEstado="El Registro de transacciones de traslados y Retiros desde Control de responsables se encuentra  <span class='style1'>Inactivo</span>">	
	<cfset msgAccion="¿Desea cerrar el registro de transacciones para que no reciba transacciones de desde Control de Responsables?">
	<cfset lblboton = "Activar Cierre">
<cfelseif ValorParam.Pvalor EQ 1>
	<cfset Paramvalor = ValorParam.Pvalor>	
	<cfset msgEstado="El Registro de transacciones de traslados y Retiros desde Control de responsables se encuentra <span class='style1'>Activo</span>">	
	<cfset msgAccion="¿Desea abrir nuevamente el módulo, para que se continuen registrando transacciones?"> 
	<cfset lblboton = "Desactivar Cierre">
<cfelse>
	<cfset Paramvalor = ValorParam.Pvalor>	
	<cfset msgEstado="El Registro de transacciones de traslados y Retiros desde Control de responsables se encuentra <strong>Procesando</strong>">	
	<cfset msgAccion="Por favor espere, hasta que que el proceso de Control de Transacciones termine de Procesar.">
	<cfset lblboton = "">
</cfif>

<form method="post" name="form1" action="SQLCierreCtrResp.cfm">
		<tr><td align="center">
			<cfoutput>#msgEstado#</cfoutput>  
		</td></tr>
		<tr><td align="center">
			<cfoutput>#msgAccion#</cfoutput>  
		</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center">
			<cfif len(#lblboton#)>
				<input type="submit" name="btnCierre" value="<cfoutput>#lblboton#</cfoutput>" onclick="javascript:return procesar(this);"/>
			</cfif>
		</td></tr>
</form>
<script language="javascript" type="text/javascript">
	function procesar(btn)
	{
		var procesar  = confirm('¿Está seguro de <cfoutput>#lblboton#</cfoutput> el cierre de Activos Fijos?');
		if(procesar){
			btn.onclick  = "";
		}
		return procesar;
	}
</script>
