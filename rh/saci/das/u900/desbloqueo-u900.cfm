<table width="100%"  border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td class="menuhead">Solicitud de Desbloqueo<hr></td>
  </tr>
  <tr>
    <td align="center">
		<cfinvoke 
			component="sif.Componentes.pListas"
			method="pLista"
			returnvariable="pListaRet"
			columnas="a.MDref
					, b.MBdescripcion
					, c.BTfecha
					, 2 as paso"
			tabla="ISBmedio a
					left outer join ISBmotivoBloqueo b
						on b.MBmotivo=a.MBmotivo
							and b.Ecodigo=#session.Ecodigo#
				
					inner join ISBbitacoraMedio c
						on c.MDref=a.MDref
							and c.EMid=c.EMid"
			filtro=" a.MDbloqueado=1				
					order by a.MDref "
			desplegar="MDref,MBdescripcion,BTfecha"
			filtrar_por="a.MDref
						, b.MBdescripcion
						, c.BTfecha"
			etiquetas="Medio,Origen Bloqueo,Fecha Desde"
			formatos="S,S,D"
			align="left, left, left"
			checkboxes="S"
			showemptylistmsg="true"
			keys="MDref"
			ira="u900-aply.cfm"
			botones="Bloquear"
			showlink="false"
			mostrar_filtro="true"
			filtrar_automatico="true"
			maxrows="15"
			/>	
<!--- 
			formname="fBusqueda"
			incluyeform="false"

 --->			
	</td>
  </tr>
</table>
