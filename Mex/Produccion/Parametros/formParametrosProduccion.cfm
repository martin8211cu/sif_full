<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

 <!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor,Pdescripcion
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<!--- PARAMETROS RELACIONADOS CON ELIMINACIÓN DE CUENTAS --->
<cfset SolCompra = ObtenerDato(1150)>

<cfset definidos = ObtenerDato(5)>
<cfset existenParametrosDefinidos = false >
<cfif definidos.RecordCount GT 0 >
	<cfif definidos.Pvalor NEQ "N" >
		<cfset existenParametrosDefinidos = true >
	</cfif>
</cfif>

<form action="SQLParametrosProduccion.cfm" method="post" name="form1">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">
				<table width="85%" border="0" cellpadding="2" cellspacing="2">
                <tr>
					<td colspan="2" nowrap align="center">
					    <table border="0">
                        <tr>
            				<td>
                                <input type="radio" name="APinterno" id="Interno0" align="left" value=<cfoutput>"0"</cfoutput> 
								<cfif "#SolCompra.Pvalor#" eq "0"> checked </cfif>
                                <label for="Interno0">Permitir solo una orden de trabajo por solicitud de compra</label>
                            </td>
        				</tr>
        				<tr>	
            				<td>
                  				<input type="radio" name="APinterno" id="Interno1" align="left" value=<cfoutput>"1"</cfoutput> 
								<cfif "#SolCompra.Pvalor#" eq "1"> checked </cfif>
                                <label for="Interno1">Permitir varias ordenes de trabajo por solicitud de compra</label>
            				</td>
        				</tr>
             			<tr><td colspan="3">&nbsp;</td></tr>
                        <tr> 
                            <td colspan="3"><div align="center"> <input type="submit" name="Aceptar" value="Aceptar" onClick="javascript: return valida();"> 
                            </div> </td>
                        </tr>
                        </table>
                    </td>
                </tr> 
             	</table>  
          	</td>
         </tr>       
     </table>           
	<!--- Variables para saber si hay que hacer un insert o un update en el .sql de cada uno de estos registros ---->
    <cfif definidos.Recordcount GT 0 ><cfset hayParametrosDefinidos = 1 ></cfif>
</form>
	
<script language="JavaScript1.2" >
	// valida los campos
	function valida() {
		<cfif not existenParametrosDefinidos >		
			alert('¡No están definidos los parámetros generales!');
			return false;
		</cfif>			
		return true;
	}	
</script>
