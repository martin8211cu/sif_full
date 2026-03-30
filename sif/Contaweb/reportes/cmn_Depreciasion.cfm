<cfif txt_tipodep eq 1>

	<!--- Plantas y Centrales --->
	<cfquery name="rsDepresiacion" datasource="#session.Conta.dsn#">
	Select AF2CAT, AF2NOM 
	from ICE_SIF..AFM002
	where char_length(ltrim(rtrim(AF2CAT))) > 6
	  <cfif isdefined("txt_desde") and txt_desde neq "" and isdefined("txt_hasta") and txt_hasta neq "">	  
	  	and AF2CAT between <cfqueryparam cfsqltype="cf_sql_varchar" value="#txt_desde#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#txt_hasta#">
	  </cfif>
	order by AF2CAT
	</cfquery>

<cfelse>

	<!--- Inmovilizados por Categoria --->
	<cfquery name="rsDepresiacion" datasource="#session.Conta.dsn#">
	Select AF2CAT, AF2NOM 
	from ICE_SIF..AFM002 A
	where char_length(ltrim(rtrim(AF2CAT))) < 7
	  <cfif isdefined("txt_desde") and txt_desde neq "" and isdefined("txt_hasta") and txt_hasta neq "">	  
	  	and AF2CAT between <cfqueryparam cfsqltype="cf_sql_varchar" value="#txt_desde#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#txt_hasta#">
	  </cfif>
	   and not exists (Select 1 
					from tbl_transaccionescf B, tbl_depreciacioncf C 
					where B.id = C.id
					   and A.AF2CAT = C.categoriainicial 
					   and B.tipo_proceso = 2
					   and B.estado = 'P') 
	order by AF2CAT
	</cfquery>

</cfif>

<cfif rsDepresiacion.recordcount gt 0>
	
	<cfif txt_tipodep eq 2>
	<A HREF="javascript:checkALL()" style="color: ##000000; text-decoration: none; "><strong>Seleccionar todos</strong></A> 
	- 
	<A HREF="javascript:UncheckALL()" style="color: ##000000; text-decoration: none; "><strong>Limpiar todos</strong></A>
	</cfif>
	
	<br>
	<table cellpadding="0" cellspacing="0" align="center" width="100%">
	<tr>
		<td></td>
		<td><strong>Código</strong></td>
		<td><strong>Descripción</strong></td>		
	</tr>
	<cfoutput query="rsDepresiacion">
	<tr>
		<td><cfif txt_tipodep eq 2><input type="checkbox" name="chktran" value="#AF2CAT#"></cfif></td>
		<td>#AF2CAT#</td>
		<td>#AF2NOM#</td>
	</tr>
	</cfoutput>
	<tr>
		<td><input type="hidden" name="Cantidad" value="<cfoutput>#rsDepresiacion.recordcount#</cfoutput>"></td>
	</tr>
	</table>
<cfelse>
	<table cellpadding="0" cellspacing="0" align="center" width="100%">
	<tr>
		<td colspan="4" align="center">No hay Categorias para depreciar o ya estan dentro de una relación</td>
	</tr>
	</table>
	<script>document.getElementById("Generar").style.visibility = "hidden"</script>
</cfif>