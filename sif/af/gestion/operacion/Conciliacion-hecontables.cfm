<!---*******************************************
*******Sistema Financiero Integral**************
*******GestiÃ³n de Activos Fijos*****************
*******Conciliacion de Activos Fijos************
*******Fecha de CreaciÃ³n: Ene/2006**************
*******Desarrollado por: Dorian Abarca GÃ³mez****
********************************************--->
<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="lista_HDContables_recordcount"
	columnas="b.IDcontable, b.Dlinea, b.Ddescripcion, Dlocal * case Dmovimiento when 'D' then 1.00 else -1.00 end as MontoAsiento"
	tabla="HDContables b
		inner join CFinanciera c
			on c.CFcuenta = b.CFcuenta
			and	c.Ecodigo = b.Ecodigo"
	filtro="b.Ecodigo = #Session.Ecodigo#
			and b.Eperiodo = #Form.GATperiodo#
			and b.Emes = #Form.GATmes#
			and b.Cconcepto = #Form.Cconcepto#
			and b.Edocumento = #Form.Edocumento#
			and b.Ocodigo = #Form.Ocodigo#
			and b.CFcuenta = #Form.CFcuenta#
			order by b.Ddescripcion"
	
	desplegar="Dlinea, Ddescripcion, MontoAsiento"
	etiquetas="L&iacute;nea, Descripcion, Monto"
	formatos="S, S, M"
	align="left, left, right"
	totales="MontoAsiento"
	
	irA="Conciliacion.cfm"
	showlink="true"
	funcion="consultarHEContables"
	fparams="IDcontable,Dlinea"
	showemptylistmsg="true"
	
	keys="IDcontable, Dlinea"
	
	pageIndex="3"
/>
<script language="javascript" type="text/javascript">
	<!--//
	var popUpWinHEContables=null;
	function popUpWindowHEContables(URLStr, left, top, width, height)
	{
	  if(popUpWinHEContables)
	  {
		if(!popUpWinHEContables.closed) popUpWinHEContables.close();
	  }
	  popUpWinHEContables = open(URLStr, 'popUpWinHEContables', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function consultarHEContables(x,y) {
		//alert(x);alert(y);
		popUpWindowHEContables('Conciliacion-hecontablespopup.cfm?idcontable='+x+'&dlinea='+y,100,100,600,400);
		return false;
	}	
	//-->
</script>
