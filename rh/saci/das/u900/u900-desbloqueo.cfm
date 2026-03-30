<table width="100%"  border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td class="menuhead">Solicitud de Desbloqueo<hr></td>
  </tr>
  <tr>
    <td align="center">
		<cfset navegacion = "paso=2">
	
		<cfinvoke 
			component="sif.Componentes.pListas"
			method="pLista"
			returnvariable="pListaRet"
			columnas="	a.MDref
					, b.MBdescripcion as MBdescripcion
					, (select max(c.BTfecha) from ISBbitacoraMedio c
						where c.MDref=a.MDref
						and c.EMid=c.EMid) as BTfecha
					, '' as BTobs
					, '' as Boton					
					, 2 as paso
					,case when(b.MBdesbloqueable = 0) then
					        MDref
					    else
					        null
					 end as x
					"
			tabla="ISBmedio a inner join ISBmotivoBloqueo b
			on b.MBmotivo=a.MBmotivo and b.Ecodigo=#session.Ecodigo#"
			filtro=" a.MDbloqueado=1				
					order by a.MDref "
			desplegar="MDref,MBdescripcion,BTfecha"
			filtrar_por_array="#ListToArray('a.MDref
					|(select min(b.MBdescripcion) from ISBmotivoBloqueo b
						where b.MBmotivo=a.MBmotivo
						and b.Ecodigo=#session.Ecodigo#)
					|(select max(c.BTfecha) from ISBbitacoraMedio c
						where c.MDref=a.MDref
						and c.EMid=c.EMid)','|')#"
			etiquetas="Medio,Origen Bloqueo,Fecha Desde"
			formatos="S,S,D"
			align="left, left, left"
			checkboxes="S"
			showemptylistmsg="true"
			keys="MDref"
			ira="u900-aply.cfm"
			botones="Desbloquear"
			showlink="false"
			mostrar_filtro="true"
			filtrar_automatico="true"
			navegacion="#navegacion#"			
			maxrows="15"
			formname="lista_Bloqueados"
			inactivecol="x"
			/>	
	</td>
  </tr>
</table>

<script language="javascript" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin) {
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function funcFiltrar(){
		document.lista_Bloqueados.PASO.value=2;
		return true;
	}
	function funcDesbloquear(){
		document.lista_Bloqueados.PASO.value=2;
		doConlisObs();
		return false;
	}
	function doConlisObs() {
		var params ="";
		params = "?formulario=lista_Bloqueados";
		popUpWindow("/cfmx/saci/das/u900/conlisObs.cfm"+params,185,200,660,200);
	}
</script>

