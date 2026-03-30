<!---*******************************************
*******Sistema Financiero Integral**************
*******Gestión de Activos Fijos*****************
*******Conciliacion de Activos Fijos************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->
<cf_dbfunction name="spart" args="a.GATdescripcion,1,25" returnvariable= "GATdescripcion" >
<cf_dbfunction name="concat" args="'Centro Funcional: ',d.CFcodigo,' - ',d.CFdescripcion" returnvariable="CentroFuncional">
<cf_dbfunction name="concat" args="'Categoría: ',e.ACcodigodesc,' - ',e.ACdescripcion" returnvariable="Categoria">
<cf_dbfunction name="concat" args="'Clase: ' ,f.ACcodigodesc,' - ' ,f.ACdescripcion" returnvariable="Clase">

<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="lista_HDContables_recordcount"
	columnas="a.ID, a.GATplaca, #GATdescripcion# as GATdescripcion, #CentroFuncional# as CentroFuncional, #Categoria# as Categoria, #Clase# as Clase, a.GATmonto as MontoGestion, case coalesce(act.Aid,0) when 0 then 'Adquisición' else case when a.GATmonto < 0 then 'Retiro' else 'Mejora' end end as Movimiento"
	tabla="GATransacciones a
			inner join CFinanciera c
				on c.CFcuenta = a.CFcuenta
				and	c.Ecodigo = a.Ecodigo
			left outer join CFuncional d
				on d.Ecodigo = a.Ecodigo
				and d.CFid = a.CFid
			left outer join ACategoria e
				on e.Ecodigo = a.Ecodigo
				and e.ACcodigo = a.ACcodigo
			left outer join AClasificacion f
				on f.Ecodigo = a.Ecodigo
				and f.ACcodigo = a.ACcodigo
				and f.ACid = a.ACid
			left outer join Activos act
				on act.Ecodigo = a.Ecodigo
				and act.Aplaca = a.GATplaca"
	filtro="a.Ecodigo = #Session.Ecodigo#
			and a.GATperiodo = #Form.GATperiodo#
			and a.GATmes = #Form.GATmes#
			and a.Cconcepto = #Form.Cconcepto#
			and a.Edocumento = #Form.Edocumento#
			and a.Ocodigo = #Form.Ocodigo#
			and a.CFcuenta = #Form.CFcuenta#
			order by a.GATdescripcion"
	
	cortes="CentroFuncional, Categoria, Clase"
	desplegar="GATplaca, GATdescripcion, Movimiento, MontoGestion"
	etiquetas="Placa, Descripcion, Movimiento, Monto"
	formatos="S,S,S,M"
	align="left, left, left, right"
	totales="MontoGestion"
	
	funcion="consultarGATransacciones"
	fparams="ID"
	
	irA="Conciliacion.cfm"
	showlink="true"
	showemptylistmsg="true"
	
	keys="ID"
	
	pageIndex="4"
/>
<cfoutput>
<script language="javascript" type="text/javascript">
	<!--//
	var popUpWinGATransacciones=null;
	function popUpWindowGATransacciones(URLStr, left, top, width, height)
	{
	  if(popUpWinGATransacciones)
	  {
		if(!popUpWinGATransacciones.closed) popUpWinGATransacciones.close();
	  }
	  popUpWinGATransacciones = open(URLStr, 'popUpWinGATransacciones', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function consultarGATransacciones(x) {
		//alert(x);
		popUpWindowGATransacciones('Conciliacion-gatransaccionespopup.cfm?gatid='+x,100,100,600,400);
		return false;
	}	
	//-->
</script>
</cfoutput>