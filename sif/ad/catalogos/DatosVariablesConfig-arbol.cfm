<cfquery datasource="#session.dsn#" name="ARBOL">
	select RTRIM(DVTcodigo) DVTcodigo, DVTdescripcion, DVTcodigoValor,
       case when (select count(1) from DVtipificacion hijos where hijos.DVTcodigoValor =DVtipificacion .DVTcodigo ) > 0  then 0 else 1 end as nivel  
 from DVtipificacion
 <!---Si se requiere Implementar Datos Variables o Eventos para otra Modulo, solo es de meterlo aqui, para que salga en el Arbol--->
 where DVTcodigoValor IN ('AF','FA','OF')
</cfquery>

<style type="text/css">
	<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
	.ar1 {background-color:#D4DBF2;cursor:pointer;}
	.ar2 {background-color:#ffffff;cursor:pointer;}
</style>
<script language="JavaScript" type="text/javascript">
	<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
	function eovr(row){<!--- event: MouseOver --->
		row.style.backgroundColor='#e4e8f3';
	}
	function eout(row){<!--- event: MouseOut --->
		row.style.backgroundColor='#ffffff';
	}
	function eclk(arbol_pos){<!--- event: Click --->
		 location.href='DatosVariablesConfig.cfm?DVTcodigo='+arbol_pos+'&TipoConfig=<cfoutput>#URL.TipoConfig#</cfoutput>';
	}
</script>

<cfoutput>
<div style="width:400px;height:350px;overflow:auto;margin-top:4px">
<table cellpadding="0" cellspacing="1" border="0" width="100%">
	<cfloop query="ARBOL">
		<cfif len(trim(ARBOL.nivel))>
			<cfif ARBOL.nivel EQ 0>
				<tr valign="middle"	class='ar2' onMouseOver="eovr(this)" onMouseOut="eout(this)">
					<td nowrap>
						#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
						<img src="../../js/xtree/images/foldericon.png" width="16" height="16" border="0" align="absmiddle">
						#HTMLEditFormat(Trim(ARBOL.DVTdescripcion))#
					</td>
				</tr>
			</cfif>
				<tr valign="middle"	class='ar2' onMouseOver="eovr(this)" onMouseOut="eout(this)" onClick="eclk('#ARBOL.DVTcodigo#')">
					<td nowrap>
						<cfif ARBOL.nivel EQ 0>
						   <cfset ARBOL.nivel = 1>
						  </cfif>
							#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
						<img src="../../js/xtree/images/file.png" width="16" height="16" border="0" align="absmiddle">
						#HTMLEditFormat(Trim(ARBOL.DVTdescripcion))#
					</td>
				</tr>
		</cfif>
	</cfloop>
</table>
</div>
</cfoutput>