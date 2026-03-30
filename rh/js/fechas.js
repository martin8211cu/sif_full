function today()
{
	var Fecha = new Date();
	return (new Date (Fecha.getFullYear(),Fecha.getMonth(),Fecha.getDate()));
}

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

