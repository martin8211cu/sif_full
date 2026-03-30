	<cfinvoke 
	 component="sif.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="PRJRecurso a inner join Unidades u on u.Ecodigo = a.Ecodigo and u.Ucodigo = a.Ucodigo"/>
		<cfinvokeargument name="columnas" value="PRJRid, PRJRcodigo, case when datalength(PRJRdescripcion) > 50 then substring(PRJRdescripcion,1,47) + '...' else PRJRdescripcion end as PRJRdescripcion, 
																							case PRJtipoRecurso 
																								when '1' then 'Mano Obra'
																								when '2' then 'Materiales'
																								when '3' then 'Servicios'
																								else 'Desconocido'
																							end as PRJRtipo,
																							Udescripcion"/>
		<cfinvokeargument name="cortes" value="PRJRtipo"/>
		<cfinvokeargument name="desplegar" value="PRJRcodigo, PRJRdescripcion, Udescripcion"/>
		<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Unidad"/>
		<cfinvokeargument name="formatos" value="V, V, V"/>
		<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
												 order by a.PRJtipoRecurso, a.PRJRcodigo, a.PRJRdescripcion"/>
		<cfinvokeargument name="align" value="left, left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="keys" value="PRJRid"/>
		<cfinvokeargument name="irA" value="Recursos.cfm"/>
	</cfinvoke>
	<!---
		when 1 then (isnull(select puesto.RHPcodigo + ' - ' + puesto.RHPdescpuesto from RHPuestos puesto where puesto.Ecodigo = a.Ecodigo and puesto.RHPcodigo = a.RHPcodigo,'Desconocido')) 
		when 2 then (isnull(select articulo.Acodigo + ' - ' + articulo.Adescripcion from Articulos articulo where articulo.Ecodigo = a.Ecodigo and articulo.Aid = a.Aid,'Desconocido'))
		when 3 then (isnull(select concepto.Ccodigo + ' - ' + concepto.Cdescripcion from Conceptos concepto where concepto.Ecodigo = a,Ecodigo and concepto.Cid = a.Cid,'Desconocido'))
	--->