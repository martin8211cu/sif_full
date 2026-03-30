<!--- <cfdump var="#form#"> 	
<cf_dump var="#url#">  ---> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<cfset filtrar_por_array = ArrayNew(1)>
			<cfset ArrayAppend(filtrar_por_array,"
						(select a.Aplaca
							from Activos a
							where a.Aid = ad.Aid
								and a.Ecodigo = ad.Ecodigo
						)")>
			<cfset ArrayAppend(filtrar_por_array,"		
						(select a.Adescripcion
							from Activos a
							where a.Aid = ad.Aid
								and a.Ecodigo = ad.Ecodigo
						)")>
			<cfset ArrayAppend(filtrar_por_array,"
						(TAvaladq + TAvalmej + TAvalrev)")>
			<cfset ArrayAppend(filtrar_por_array,"
						(TAdepacumadq + TAdepacummej  + TAdepacumrev)")>
			<cfset ArrayAppend(filtrar_por_array,"
					
						(TAvaladq + TAvalmej + TAvalrev) - (TAdepacumadq + TAdepacummej + TAdepacumrev)")>
			<cfset ArrayAppend(filtrar_por_array,"
					
						(select cta.ACcodigodesc
							from ACategoria cta
							where cta.Ecodigo = ad.Ecodigo
								and cta.ACcodigo = ad.ACcodigoori
						)")>
			<cfset ArrayAppend(filtrar_por_array,"
						
						(select cta.ACcodigodesc
							from ACategoria cta
							where cta.Ecodigo = ad.Ecodigo
								and cta.ACcodigo = ad.ACcodigodest
						)")>
			<cfset ArrayAppend(filtrar_por_array,"
						
					
						(select cla.ACcodigodesc
							from AClasificacion cla
							where cla.Ecodigo = ad.Ecodigo
								and cla.ACcodigo = ad.ACcodigoori
								and cla.ACid = ad.ACidori
						)")>
			<cfset ArrayAppend(filtrar_por_array,"
						
						(select cla.ACcodigodesc
							from AClasificacion cla
							where cla.Ecodigo = ad.Ecodigo
								and cla.ACcodigo = ad.ACcodigoori
								and cla.ACid = ad.ACiddest
						)")>
			<!--- <form name="form1" method="post" action="agtProceso_registro_camcatclas.cfm"> --->
			<cfif isdefined("form.AGTPid") and len(trim(#form.AGTPid#)) neq 0>
				<cfset navegacion = navegacion & "&AGTPid="&form.AGTPid>
			</cfif>
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaRH"
					returnvariable="pListaRet"
						columnas="
							ad.ADTPlinea,
							(select a.Aplaca
								from Activos a
								where a.Aid = ad.Aid
									and a.Ecodigo = ad.Ecodigo
							) as Placa,
						
							(select a.Adescripcion
								from Activos a
								where a.Aid = ad.Aid
									and a.Ecodigo = ad.Ecodigo
							) as Descripcion,
						
							(TAvaladq + TAvalmej + TAvalrev) as Valor,
							(TAdepacumadq + TAdepacummej  + TAdepacumrev) as DepAcum,
						
							(TAvaladq + TAvalmej + TAvalrev) - (TAdepacumadq + TAdepacummej + TAdepacumrev) as ValorLibros,
						
							(select cta.ACcodigodesc
								from ACategoria cta
								where cta.Ecodigo = ad.Ecodigo
									and cta.ACcodigo = ad.ACcodigoori
							) as  Categoria_anterior,
							
							(select cta.ACcodigodesc
								from ACategoria cta
								where cta.Ecodigo = ad.Ecodigo
									and cta.ACcodigo = ad.ACcodigodest
							) as Categoria_Nueva,
							
						
							(select cla.ACcodigodesc
								from AClasificacion cla
								where cla.Ecodigo = ad.Ecodigo
									and cla.ACcodigo = ad.ACcodigoori
									and cla.ACid = ad.ACidori
							) as Clasificacion_anterior,
							
							(select cla.ACcodigodesc
								from AClasificacion cla
								where cla.Ecodigo = ad.Ecodigo
									and cla.ACcodigo = ad.ACcodigodest
									and cla.ACid = ad.ACiddest
							) as Clasificacion_Nueva
							"
						tabla=" AGTProceso ag
								inner join ADTProceso ad
									on ad.AGTPid = ag.AGTPid"
						filtro=" ag.IDtrans = 6
									and ag.Ecodigo = #session.Ecodigo#
									and ag.AGTPid = #form.AGTPid#
									Order by Placa"
						desplegar="Placa, Descripcion, Valor, DepAcum, ValorLibros, Categoria_anterior, Categoria_Nueva, Clasificacion_anterior, Clasificacion_Nueva"
						etiquetas="Placa, Descripci&oacute;n, Valor, DepAcum, ValorLibros, Cat.Ant., Cat.N., Clas.Ant., Clas.N."
						formatos="S,S,M,M,M,S,S,S,S"
						align="left,left,right,right,right,center,center,center,left"
						showlink="false"
						incluyeForm="false"
						formName="fagtproceso"
						ajustar="N,N,N,N,N,N,N,N,N"
						keys="ADTPlinea"
						checkboxes="S"
						botones="Eliminar,EliminarTodo"
						MaxRows="25"
						navegacion="#navegacion#"
						filtrar_automatico="true"
						filtrar_por_array="#filtrar_por_array#"
						mostrar_filtro="true"
						 />
					<cfif isdefined("form.AGTPid") and len(trim(form.AGTPid))>
						<cfoutput>
							<input name="AGTPid" type="hidden" value="#form.AGTPid#">
						</cfoutput>
					</cfif>
					<input name="modocambio" type="hidden" value="<cfif isdefined ("form.AGTPid") and len(trim(form.AGTPid))><cfoutput>true</cfoutput></cfif>">
					<!--- <cfdump var="#form#">
					<cfdump var="#url#"> --->
			<!--- </form> --->
		</td>
	</tr>
</table>



<script language="javascript1.2" type="text/javascript">
	function algunoMarcado(){
		var aplica = false;
		if (document.fagtproceso.chk) {
			if (document.fagtproceso.chk.value) {
				aplica = document.fagtproceso.chk.checked;
			} else {
				for (var i=0; i<document.fagtproceso.chk.length; i++) {
					if (document.fagtproceso.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		return aplica;
	}
	
	function funcEliminar() {
		if (!algunoMarcado()) {
			alert('Debe de seleccionar al menos un activo.');
			return false;			
		}	
	}
	
	function funcEliminarTodo(){
		if (confirm('¿Está seguro que desea Eliminar esta relación?')){
		}else{
			return false;
		}
	}
</script>