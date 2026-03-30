<script language="JavaScript1.2" type="text/javascript">
	function Editar(value){
		document.listaDetalle.DFElinea.value = value;
		document.listaDetalle.submit();
	}

	// para la lista, que se hizo a pata
	function mover(llave,index,dir){
		var dummy = new Date().getTime();
		var index2 =  (dir == -1) ? index-1 : index+1;

		for (var i=0; i<=3; i++){
			var id1 = document.getElementById('a'+index+i);
			var id2 = document.getElementById('a'+index2+i);
			
			var temp = id1.innerHTML;
			id1.innerHTML = id2.innerHTML;
			id2.innerHTML = temp;
		}
		
		//cambia el valor de los objetos llaves
		var name1 = 'document.listaDetalle.DFElinea' + index;
		var name2 = 'document.listaDetalle.DFElinea' + index2;
		temp = eval(name1).value;

		eval(name1).value = eval(name2).value
		eval(name2).value = temp
		
		document.getElementById("updLista").src="/cfmx/rh/admin/catalogos/listaQuery.cfm?&llave1=" + eval(name1).value + "&llave2=" + eval(name2).value + "&dir="+dir+"&dummy="+dummy;
		return;
	}
</script>

<cfquery name="rsLineas" datasource="#session.DSN#">
	select DFElinea, EFEid, DFEetiqueta, DFEfuente, DFEtamfuente, DFEorden
	from DFormatosExpediente
	where EFEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EFEid#">
	order by DFEorden
</cfquery>

<form method="post" name="listaDetalle" action="FormatosPrincipal.cfm" >
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr class="tituloListas">
		<td>&nbsp;</td>
		<td><b><cf_translate key="LB_Etiqueta">Etiqueta</cf_translate></b></td>
		<td><b><cf_translate key="LB_TipoDeFuente">Tipo de Fuente</cf_translate></b></td>
		<td><b><cf_translate key="LB_TamanoDeFuente">Tamaño de Fuente</cf_translate></b></td>
		<td colspan="3">&nbsp;</td>
	</tr>
	<cfoutput query="rsLineas">
	<!---<tr <cfif rsLineas.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" onClick="javascript:Editar('#rsLineas.DFElinea#');" >--->
	<tr <cfif rsLineas.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" >
		<td height="18" width="1%" nowrap onClick="javascript:Editar('#rsLineas.DFElinea#');">
			<a id="a#rsLineas.CurrentRow#0" href="javascript:Editar('#rsLineas.DFElinea#');">
			<cfif ( ef_modo neq 'ALTA' and df_modo neq 'ALTA' ) and ( isdefined("form.DFElinea") and form.DFElinea eq rsLineas.DFElinea )>
				<img border="0" src="/cfmx/rh/imagenes/addressGo.gif" width="18" height="18"> 
			</cfif>
			</a>
		</td>
		<td height="18" nowrap onClick="javascript:Editar('#rsLineas.DFElinea#');"><a id="a#rsLineas.CurrentRow#1" href="javascript:Editar('#rsLineas.DFElinea#');">#rsLineas.DFEetiqueta#</a></td>
		<td height="18" nowrap onClick="javascript:Editar('#rsLineas.DFElinea#');"><a id="a#rsLineas.CurrentRow#2" href="javascript:Editar('#rsLineas.DFElinea#');">#rsLineas.DFEfuente#</a></td>
		<td height="18" nowrap onClick="javascript:Editar('#rsLineas.DFElinea#');"><a id="a#rsLineas.CurrentRow#3" href="javascript:Editar('#rsLineas.DFElinea#');">#rsLineas.DFEtamfuente#</a></td>
		
		<cfif rsLineas.CurrentRow neq rsLineas.RecordCount >
			<td width="1%" height="18" nowrap><a href="javascript:mover('#rsLineas.DFElinea#', #rsLineas.CurrentRow#, 1);"><img border="0" src="/cfmx/rh/imagenes/abajo.gif"></a></td>
		<cfelse>
			<td width="1%" height="18" nowrap></td>
		</cfif>

		<cfif rsLineas.CurrentRow neq 1>
			<td width="1%" height="18" nowrap><a href="javascript:mover('#rsLineas.DFElinea#', #rsLineas.CurrentRow#, -1);"><img border="0" src="/cfmx/rh/imagenes/arriba.gif"></a></td>
		<cfelse>
			<td width="1%" height="18" nowrap></td>
		</cfif>
		
		<td><input type="hidden" name="DFElinea#rsLineas.CurrentRow#" value="#rsLineas.DFElinea#"></td>
	</tr>
	</cfoutput>

	<cfoutput>
	<tr>
		<td>
			<input type="hidden" name="EFEid"    value="#form.EFEid#">
			<input type="hidden" name="TEid"     value="#form.TEid#">
			<input type="hidden" name="DFElinea" value="">
			<input type="hidden" name="CAMBIO" value="CAMBIO">
		</td>
	</tr>
	</cfoutput>
</table>
<iframe name="updLista" id="updLista" marginheight="" marginwidth="" frameborder="1" height="0" width="0" scrolling="auto" src=""></iframe>
</form>