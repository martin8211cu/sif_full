<cfset navegacion = "paso=" & Form.paso>

<script language="javascript" type="text/javascript">
	function funcSeleccionar(id) {
		document.form1.RHAID.value = id;
		document.form1.paso.value = '1';
		document.form1.submit();
	}
</script>

<!---================ TRADUCCION =====================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"	
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"	
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_Desde"
	Default="Fecha Desde"	
	returnvariable="LB_Fecha_Desde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_Hasta"
	Default="Fecha Hasta"	
	returnvariable="LB_Fecha_Hasta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_se_encontraron_registros"
	Default="No se Encontraron Registros"	
	returnvariable="MSG_No_se_encontraron_registros"/>

<cfoutput>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">
				<form name="form1" method="post" action="#CurrentPage#">
					<input type="hidden" name="paso" value="#Form.paso#" />
					<cfinvoke 
						component="rh.Componentes.pListas" 
						method="pListaRH" 
						returnvariable="Lvar_Lista" 
						columnas="a.RHAid,a.RHTAid,a.RHAcodigo,a.RHAdescripcion,a.RHAfdesde,a.RHAfhasta"
						tabla="RHAccionesMasiva a"
						filtro="a.Ecodigo = #Session.Ecodigo# and a.RHAaplicado = 0 order by a.RHAfdesde,a.RHAfhasta"
						desplegar="RHAcodigo,RHAdescripcion,RHAfdesde, RHAfhasta"
						etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_Fecha_Desde#,#LB_Fecha_Hasta#"
						filtrar_por="a.RHAcodigo,a.RHAdescripcion,a.RHAfdesde,a.RHAfhasta"
						maxrows="10"
						formatos="S,S,D,D"
						align="left,left,left,left"
						ajustar="S,S,S,S"
						mostrar_filtro="true"
						filtrar_automatico="true"
						showemptylistmsg="true"
						emptylistmsg=" --- #MSG_No_se_encontraron_registros# --- "
						ira="#CurrentPage#"
						checkboxes="N"
						formName="form1"
						incluyeForm="false"
						navegacion="#navegacion#"
						funcion="funcSeleccionar"
						fparams="RHAid"
						keys="RHAid" />
				</form>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
	</table>
</cfoutput>
