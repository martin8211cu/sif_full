<cfquery name="rsRelaciones" datasource="#session.Conta.dsn#">
Select ltrim(str(AF8NUM,5, 0)) as Num, AF8DES as Dsc,AF8TIP as Tip
from af_relaciones A
where not exists(Select 1 
				from tbl_transaccionescf B, tbl_det_relaciones C 
				where B.id = C.id
				   and A.AF8NUM = C.numero_relacion	
				   and B.estado = 'P'			   
				)	
  <cfif txt_desde neq "" and txt_hasta neq "">
  	and AF8NUM BETWEEN #Val(txt_desde)# and #Val(txt_hasta)#
  </cfif> 				
  order by AF8NUM
</cfquery>

<cfif rsRelaciones.recordcount gt 0>

	<A HREF="javascript:checkALL()" style="color: ##000000; text-decoration: none; "><strong>Seleccionar todos</strong></A> 
	- 
	<A HREF="javascript:UncheckALL()" style="color: ##000000; text-decoration: none; "><strong>Limpiar todos</strong></A>
	<br>
	<table cellpadding="0" cellspacing="0" align="center" width="100%">
	<tr>
		<td></td>
		<td><strong>Número</strong></td>
		<td><strong>Descripción</strong></td>
		<td><strong>Tipo</strong></td>
	</tr>
	<cfoutput query="rsRelaciones">
	<tr>
		<td><input type="checkbox" name="chktran" value="#Num#"></td>
		<td>#Num#</td>
		<td>#Dsc#</td>
		<td>#Tip#</td>
	</tr>
	</cfoutput>
	<tr>
		<td><input type="hidden" name="Cantidad" value="<cfoutput>#rsRelaciones.recordcount#</cfoutput>"></td>
	</tr>	
	</table>
<cfelse>
	<table cellpadding="0" cellspacing="0" align="center" width="100%">
	<tr>
		<td colspan="4" align="center">No hay relaciones para postear</td>
	</tr>
	</table>
	<script>document.getElementById("Generar").style.visibility = "hidden"</script>
</cfif>