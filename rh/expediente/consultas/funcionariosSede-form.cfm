
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ordenar_por" Default="Ordenar por" returnvariable="LB_Ordenar_por"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado" Default="Estado" returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CMB_Nombre" Default="Nombre" returnvariable="CMB_Nombre" />
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CMB_Escuela" Default="Escuela" returnvariable="CMB_Escuela" />
<cfoutput>

<body onLoad="Evaluar()">
<form action="funcionariosSede-sql.cfm" method="get" name="form1" style="margin:0">
	<table width="95%" border="0" cellspacing="1" cellpadding="1" style="margin:0">	  
	  <tr>
		<td  align="right" nowrap><strong>#LB_Ordenar_por#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="OrderBy">
				<option value="1">#CMB_Nombre#</option>
				<option value="2">#CMB_Escuela#</option>			
			</select>
		</td>
	  </tr>	 
	  	<td align="right" nowrap="nowrap"><strong>#LB_Estado#&nbsp;:&nbsp;</strong>&nbsp;</td>
	  	<td>
			<select name="Estado">
				<option value="1">Activo</option>
				<option value="2">Inactivo</option>
			</select>
		</td>
	  <tr>
	  
	  </tr>
	</table>
	<cf_botones values="Consultar,Limpiar">
</form>
</body>
</cfoutput>


