<cfinvoke Key="LB_Empleado" Default="Empleado"	 returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>						
<cfinvoke Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros"	 returnvariable="LB_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Todos" Default="Todos"	 returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Marca" Default="Marca"	 returnvariable="LB_Marca" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke Key="LB_FDesde" Default="F.Desde"	 returnvariable="LB_FDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FHasta" Default="F.Hasta"	 returnvariable="LB_FHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Jornada" Default="Jornada"	 returnvariable="LB_Jornada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CJornada" Default="Combinaci&oacute;n<br> de Jornadas"	 returnvariable="LB_CJornada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_HorasTrabajadas" Default="H.T"	 returnvariable="LB_HT" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_HorasOcio" Default="H.O"	 returnvariable="LB_HO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_HorasLaboradas" Default="H.L"	 returnvariable="LB_HL" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_HorasARebajar" Default="H.R"	 returnvariable="LB_HR" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_HorasNormales" Default="H.N"	 returnvariable="LB_HN" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_HorasExtraA" Default="H.EA"	 returnvariable="LB_HEA" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_HorasExtraB" Default="H.EB"	 returnvariable="LB_HEB" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_MontoFeriado" Default="M.Feriado"	 returnvariable="LB_MFeriado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Permiso" Default="Permiso"	 returnvariable="LB_Permiso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Feriado" Default="Feriado" returnvariable="LB_Feriado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Aplicar" Default="Aplicar"	 returnvariable="BTN_Aplicar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="BTN_Eliminar" Default="Eliminar"	 returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ConfirmaAplicar" Default="Esta seguro que desea aplicar las marcas?"	 returnvariable="MSG_ConfirmaAplicar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ConfirmaEliminar" Default="Esta seguro que desea eliminar las marcas?"	 returnvariable="MSG_ConfirmaEliminar" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke Key="BTN_GeneraMarcasPorPermisos" Default="Generar Marcas por Permisos"	 returnvariable="BTN_GeneraMarcasPorPermisos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_DeseaGenerarMarcasPorPermisos" Default="Desea generar Marcas por Permisos?" returnvariable="BTN_DeseaGenerarMarcasPorPermisos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_MarcaInconsistente" Default="Marca Inconsistente" returnvariable="LB_MarcaInconsistente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_MarcasInconsistentes" Default="Marcas Inconsistentes" returnvariable="LB_MarcasInconsistentes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_LasMarcasQueAparecenEnColorRojoEstanInconsistentes" Default="Las marcas que aparecen en color rojo est&aacute;n inconsistentes" returnvariable="LB_LasMarcasQueAparecenEnColorRojoEstanInconsistentes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_HayMarcasInconsistentesNoSePuedeAplicar" Default="Hay marcas inconsistentes no se puede aplicar."	 returnvariable="MSG_HayMarcasInconsistentesNoSePuedeAplicar" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" Default="Debe seleccionar al menos un registro para relizar esta acción" returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" component="sif.Componentes.Translate" method="Translate"/>
<cfset vnMaxrows = 20>
<cfquery name="rsLista" datasource="#session.DSN#">
	select {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)} as Empleado, 
			a.FechaDesde,
			a.FechaHasta,
			case when a.CantJornadas > 1 then 
				'<img src=/cfmx/rh/imagenes/checked.gif>'
			else
				'<img src=/cfmx/rh/imagenes/unchecked.gif>'
			end as Jornada,
			a.HT,
			a.HO,
			a.HL,
			a.HR,
			a.HN,
			a.HEA,
			a.HEB,
			a.MontoFeriado
	from TMP_MarcasSemanal a
		inner join DatosEmpleado b
			on a.DEid = b.DEid
	where  a.usuario  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	and a.consecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.consecutivo#">	
	order by {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)}, a.FechaDesde, a.FechaHasta
</cfquery>

<cfif isdefined("rsLista") >
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaQuery"
	  returnvariable="pListaEmpl">
		<cfinvokeargument name="query" value="#rsLista#"/>
		<cfinvokeargument name="desplegar" value="Empleado,FechaDesde,FechaHasta,HT,HO,HL,HR,HN,HEA,HEB,MontoFeriado,Jornada"/>
		<cfinvokeargument name="etiquetas" value="#LB_Empleado#,#LB_FDesde#,#LB_FHasta#,#LB_HT#,#LB_HO#,#LB_HL#,#LB_HR#,#LB_HN#,#LB_HEA#,#LB_HEB#,#LB_MFeriado#,#LB_CJornada#"/>
		<cfinvokeargument name="formatos" value="V,D,D,M,M,M,M,M,M,M,M,V"/>
		<cfinvokeargument name="align" value="left,left,left,center,center,center,center,center,center,center,left,center"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="maxRows" value="#vnMaxrows#"/>
		<cfinvokeargument name="incluyeForm" value="false"/>
		<cfinvokeargument name="formName" value="form1"/>
		<cfinvokeargument name="showEmptyListMsg" value="yes"/>
		<cfinvokeargument name="showLink" value="false"/>
	</cfinvoke>	
</cfif>


