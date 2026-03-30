<cfinclude template="CalificaEducacion-translate.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td width="50%" valign="top">
			<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaRH"
				columnas="RHECEid,DEid,RHCEDNivel,RHECEnota,RHECEfdesde,RHECEfhasta,3 as o, 1 as sel, '4' as tab,
							case RHECEaplicada when 1 then '<img src=''/cfmx/rh/imagenes/w-check.gif '' border=0>' else '&nbsp;' end as Aplicada" 
				desplegar="RHCEDNivel,RHECEnota,RHECEfdesde,RHECEfhasta,Aplicada"
				filtrar_por="RHCEDNivel,RHECEnota,RHECEfdesde,RHECEfhasta"
				etiquetas="#LB_Nivel#,#LB_Nota#,#LB_FechaDesde#,#LB_FechaHasta#,#LB_Aplicada#"
				align="left,center,left,left, center"
				formatos="S,S,D,D,I"
				ajustar="S"
				tabla="RHEmpleadoCalificaEd a
						inner join RHCalificaEduc b
							on b.RHCEDid = a.RHCEDid
							and b.Ecodigo = a.Ecodigo"
				filtro="a.Ecodigo = #session.Ecodigo#
						and DEid = #form.DEid#"
				ira="expediente.cfm"
				showemptylistmsg="true"
				debug="N"
			/>
		</td>
		<td width="50%" valign="top"><cfinclude template="CalificaEducacion-form.cfm"></td>
	</tr>
</table>