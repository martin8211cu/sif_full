
 <cfdump var="#form#">
<!---<cfdump var="#session#"> --->

<!--- <script language="JavaScript" src="../../js/fechas.js"></script>  --->

<form name="form1" method="post" action="validafechas.cfm">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td><div align="right">Fecha&nbsp;Arribo:</div></td>
			<td>
				<cf_sifcalendario name="EDfechaarribo" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1" conexion = "minisif">			  			  
			</td>
		
			<td><div align="right">Fecha&nbsp;Factura:</div></td>
			<td>
				<cf_sifcalendario name="EDfecha" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1" conexion = "minisif" >			  			  
			</td>
		</tr>
	</table>
	<input type="submit" name="Agregar" value="Agregar" onClick="return Validar();">
	
</form>










<script type="text/javascript" language="javascript"> 

function dateadd (NumeroDias, Fecha)
{
	var LvarDias = NumeroDias * 86400000;
	var LvarFecha = toFecha(Fecha).getTime();
	return formatFecha(new Date(LvarFecha + LvarDias));
}

function datediff (FechaMenor, FechaMayor)
{
	var LvarMayor = toFecha(FechaMayor).getTime();
	var LvarMenor = toFecha(FechaMenor).getTime();
	return (Int((LvarMayor-LvarMenor) / 86400000));
}

function toFecha (FechaDD_MM_YYYY)
{

	return (new Date (FechaDD_MM_YYYY.substr(6,4),parseInt(FechaDD_MM_YYYY.substr(3,2),10)-1,FechaDD_MM_YYYY.substr(0,2)));
}

function Int(Numero)
{
	if (Numero >= 0)
	{
		return Math.floor(Numero);
	}
	else
	{
		return Math.ceil(Numero);
	}
}

function formatFecha(Fecha)
{
	return (
			(Fecha.getDate()<10 ? "0" : "") + (Fecha.getDate()) + "/" + (Fecha.getMonth()<9 ? "0" : "") + (Fecha.getMonth()+1) + "/" + Fecha.getFullYear()
			);
	
}



	function Validar()
	{alert( 'FARRIBO: ' + toFecha(document.form1.EDfechaarribo.value).getTime() + ' , ' + 'FFAC:' + toFecha(document.form1.EDfecha.value).getTime());
	alert(datediff(document.form1.EDfecha.value, document.form1.EDfechaarribo.value));
	if (datediff(document.form1.EDfecha.value, document.form1.EDfechaarribo.value) <0) 
	{
			
		alert ('La fecha de arribo debe ser mayor a la fecha del documento')
		return false;
	
	} 
	else {
		alert('Menor que 0');
		return true;
	}
	

	}

</script>