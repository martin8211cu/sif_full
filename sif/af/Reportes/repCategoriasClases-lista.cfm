<cfif isdefined('url.ACcodigodesde') and not isdefined('form.ACcodigodesde')>
	<cfset form.ACcodigodesde = url.ACcodigodesde>
</cfif>
<cfif isdefined('url.ACcodigohasta') and not isdefined('form.ACcodigohasta')>
	<cfset form.ACcodigohasta = url.ACcodigohasta>
</cfif>

<!--- Query para Categorias --->
<cfquery name="lista" datasource="#session.DSN#">
	select ACcodigo, ACdescripcion, ACmetododep
	from ACategoria a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif form.ACcodigodesde GT 0>
		and a.ACcodigo >= <cfoutput>#form.ACcodigodesde#</cfoutput>
	</cfif>
	<cfif form.ACcodigohasta GT 0>
		and a.ACcodigo <= <cfoutput>#form.ACcodigohasta#</cfoutput>
	</cfif>
	order by a.ACcodigo
</cfquery>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>
 		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaCategorias">
			<cfinvokeargument name="query" value="#lista#"/>
			<cfinvokeargument name="desplegar" value="ACcodigo, ACdescripcion, ACmetododep"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo de Categor&iacute;a, Descripci&oacute;n de la Categor&iacute;a, M&eacute;todo de Depreciaci&oacute;n"/>
			<cfinvokeargument name="formatos" value="V, V, V"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="align" value="left, left, left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="repCategoriasClases.cfm"/>
			<cfinvokeargument name="keys" value="ACcodigo"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="radios" value="S"/>
			<cfinvokeargument name="botones" value="Descargar"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td>
  </tr>
</table>

<script language="javascript" type="text/javascript">
	<!--
	function funcDescargar(){
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				if (document.lista.chk.checked) {
					return confirm("¿Desea Descargar El Archivo Seleccionado?");
				}
			} else {
				for (var i=0;i<document.lista.chk.length;i++) {
					if (document.lista.chk[i].checked){
						return confirm("¿Desea Descargar El Archivo Seleccionado?");
					}
				}
			}
			alert("Debe seleccionar la transacción a descargar!");
		} else {
			alert("No hay ninguna transacción para descargar!");
		}
		return false;
	}
	-->
</script>