<cfif isdefined("Session.Compras.OrdenCompra")>
	<cfset StructDelete(Session.Compras, "OrdenCompra")>
	<!--- Limpiar los resultados de Evaluación --->
	<cfquery name="delLineas" datasource="#Session.DSN#">
		delete from CMResultadoEval
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
	</cfquery>
</cfif>
<form name="form1" method="post" >
	<input type="hidden" name="opt" value="">
	<table align="center" width="100%" border="0" cellspacing="0" cellpadding="4">
 		<tr>
		   <td width="50%" valign="top">
				<table align="center" width="51%" border="0" >
					<tr>
						<td  width="40%"  nowrap> <input  name="metodo" type="radio" value="C" checked> 
							<label for="metodo"><strong>Total</strong></label></td>
					</tr>
					<tr>
						<td  nowrap> <input name="metodo" type="radio" value="L">
							<label for="metodo"><strong>Por Item</strong></label></td>
					</tr>
					<tr>
					  <td colspan="2" >&nbsp;</td>
				  </tr>
					<tr>
						<td colspan="2" ><cf_botones values="<< Anterior, Siguiente >>" names="Anterior,Siguiente"></td>							
					</tr>
					</table>
		  </td>
			<td width="50%">
				<table align="center" class="ayuda"  cellpadding="0" cellspacing="4">
					<td valign="top" align="center" style="text-align:justify; "> 
						<strong style="font-size:11px ">Seleccione el método de evaluación</strong><br><br>
						 El método de evaluación se refiere a la forma por medio de 
						 la cual se obtendrá la opción de compra sugerida.  Si el método 
 						 seleccionado es <strong style="color:#006699 ">"Total"</strong> la sugerencia será la 
						 cotización(completa) del proveedor que constituya la mejor opción. 
						 Si el método seleccionado es <strong style="color:#006699 ">"Por Item"</strong> la sugerencia 
						 estará constituida por las líneas que representan la mejor opción.
					</td>
				</table>			
			</td>
		</tr>
	</table>
	<cfoutput>
		<input type="hidden" name="CMPid" value="#Form.CMPid#">
	</cfoutput>
</form>
<script language="javascript" type="text/javascript">
	function funcSiguiente(){
		document.form1.opt.value=4;
	}
	function funcAnterior(){
		document.form1.opt.value=0;
	}
</script>
