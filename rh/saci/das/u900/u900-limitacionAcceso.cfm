<table width="100%"  border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td class="menuhead">Limitaci&oacute;n de Acceso<hr></td>
  </tr>
  <tr>
    <td>
		<cfinclude template="u900-limitacionAcceso-form.cfm">
	</td>
  </tr>
  <tr>
    <td>
		<cfset navegacion = "paso=3">
	
		<cfinvoke 
			component="sif.Componentes.pListas"
			method="pLista"
			returnvariable="pListaRet"
			columnas="	a.MDref
						, coalesce(a.MDlimite,0) as Limite
						, coalesce(b.MCacumulado,0) as Saldo
						, coalesce(((b.MCacumulado * 100) / a.MDlimite),0) as Uso
						, ' ' as espacio
						, 3 as paso"
			tabla="ISBmedio a
					left outer join ISBmedioConsumo b
						on b.MDref=a.MDref"
			filtro=" 1=1 order by a.MDref"
			desplegar="MDref,Limite,Saldo,Uso,espacio"
			etiquetas="Tel&eacute;fono, L&iacute;mite, Saldo, % Uso, "
			formatos="S,M,M,M,U"
			align="left, Right, Right, Right, Right"
			showemptylistmsg="true"
			keys="MDref"
			ira="u900.cfm"
			filtrar_por_array="#ListToArray('a.MDref
						|coalesce(a.MDlimite,0)
						|coalesce(b.MCacumulado,0)
						|coalesce(((b.MCacumulado * 100) / a.MDlimite),0)
						|espacio','|')#"
			mostrar_filtro="true"
			filtrar_automatico="true"
			navegacion="#navegacion#"			
			maxrows="10"
			debug="N"
			formname="lista_TELs"
			maxRowsQuery="250"	
			/>			
	</td>
  </tr>
</table>

<script language="javascript" type="text/javascript">
	function funcFiltrar(){
		document.lista_TELs.PASO.value=3;
		return true;
	}
</script>
