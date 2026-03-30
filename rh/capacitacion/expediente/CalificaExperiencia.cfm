<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puesto"
	Default="Puesto"
	returnvariable="LB_Puesto"/> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/> 	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Annos_de_Servicio"
	Default="A&ntilde;os de Servicio"
	returnvariable="LB_Annos_de_Servicio"/> 	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Annos_de_Servicio2"
	Default="Años de Servicio"
	returnvariable="LB_Annos_de_Servicio2"/> 	


<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td width="50%" valign="top">
			<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaRH"
				columnas="a.RHEEEid,a.DEid,coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigo,b.RHPdescpuesto,a.RHEEEannos,3 as o, 1 as sel, '3' as tab" 
				desplegar="RHPcodigo,RHPdescpuesto,RHEEEannos"
				filtrar_por="RHPcodigo,RHPdescpuesto,RHEEEannos"
				etiquetas="#LB_Puesto#,#LB_Descripcion#,#LB_Annos_de_Servicio#"
				align="left,left,right"
				formatos="S,S,N"
				ajustar="S"
				
				tabla=" RHExpExternaEmpleado a
						inner join RHPuestos b
							on ltrim(rtrim(a.RHPcodigo)) = ltrim(rtrim(b.RHPcodigo))
							and a.Ecodigo = b.Ecodigo"
				filtro="a.Ecodigo = #session.Ecodigo#
						and a.DEid = #form.DEid#"
				ira="expediente.cfm"
				showemptylistmsg="true"
				debug="N"
			/>

			
		</td>
		<td width="50%" valign="top"><cfinclude template="CalificaExperiencia-form.cfm"></td>
	</tr>
</table>