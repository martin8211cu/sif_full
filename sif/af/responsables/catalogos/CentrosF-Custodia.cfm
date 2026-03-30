<form name="fBusqueda" id="fBusqueda" action="CentrosF-CustodiaSQL.cfm" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 		
			<td  class="tituloAlterno" width="48%" valign="top"><div align="center">Centros Funcionales</div></td>
			<td valign="top">&nbsp;
				
			</td>			
			<td  class="tituloAlterno" width="48%" valign="top"><div align="center">Centros Funcionales Asignados</div></td>		
		</tr>
		<tr> 		
			<td valign="top">		
					<cfinvoke 
						component="sif.Componentes.pListas"
						method="pLista"
						returnvariable="pListaRet"
						columnas="a.CFid,a.CFcodigo,a.CFdescripcion"
						tabla="CFuncional a "
						filtro=" a.Ecodigo = #session.Ecodigo# 
								and a.CFid not in (select CFid 	from CRCCCFuncionales where CRCCid = #form.CRCCid# )				
								order by CFcodigo "
						desplegar="CFcodigo, CFdescripcion"
						filtrar_por="a.CFcodigo,a.CFdescripcion"
						etiquetas="C&oacute;digo, Descripci&oacute;n"
						formatos="S,S"
						align="left, left"
						checkboxes="S"
						showemptylistmsg="true"
						keys="CFid"
						botones="Agregar"
						showlink="false"
						mostrar_filtro="true"
						formname="fBusqueda"
						filtrar_automatico="true"
						maxrows="15"
						incluyeform="false"
						PageIndex="1"
						/>
			</td>			
			<td valign="top">&nbsp;
			</td>
			<td valign="top">
					<cfinvoke 
						component="sif.Componentes.pListas"
						method="pLista"
						returnvariable="pListaRet"
						columnas="a.CFid,b.CFcodigo as CFcodigoD,b.CFdescripcion as CFdescripcionD,
								'<img border=''0'' src=''/cfmx/sif/imagenes/Borrar01_S.gif''>' as Eliminar	"
						tabla="	CRCCCFuncionales a
								inner join CFuncional b 
								on a.CFid = b.CFid
								and CRCCid = #form.CRCCid# "
						filtro=" b.Ecodigo = #session.Ecodigo# 
								order by b.CFcodigo "
						desplegar="CFcodigoD, CFdescripcionD,Eliminar"
						filtrar_por="b.CFcodigo,b.CFdescripcion,Eliminar"
						etiquetas="C&oacute;digo, Descripci&oacute;n,&nbsp;"
						formatos="S,S,G"
						align="left, left, right"
						checkboxes="N"
						showemptylistmsg="true"
						showlink="false"
						mostrar_filtro="true"
						formname="fBusqueda"
						filtrar_automatico="true"
						maxrows="15"
						keys="CFid"
						funcion="window.parent.eliminar"
						fparams="CFid"
						incluyeform="false"
						PageIndex="2"
						/>
			</td>
		</tr> 
	</table>
	<input type="hidden" 
	name="CRCCid" 
	value="<cfif isdefined("form.CRCCid") and len(trim(form.CRCCid))><cfoutput>#form.CRCCid#</cfoutput></cfif>">	
	<input name="modo"   value="ALTA" type="hidden">
	<input name="tab"  value="2" type="hidden">	
	<input name="CFidD" type="hidden">
</form>

<script language="javascript" type="text/javascript">
	function eliminar(llave){
		if (confirm('¿Desea eliminar el centro funcional?')){
			document.fBusqueda.modo.value = 'BAJA';
			document.fBusqueda.CFidD.value = llave;
			document.fBusqueda.action = "CentrosF-CustodiaSQL.cfm"
			document.fBusqueda.submit();
		}else{
			return false;
		}
	}
	document.fBusqueda.filtro_CFcodigo.focus();
</script>