<cfsetting requesttimeout="120">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Borrado de Reglas Contables</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
* { font-family:Verdana, Arial, Helvetica, sans-serif; font-size:11px; }
</style>
</head>
<body>
<cfset start = Now()>
<cfset LvarDiasVenc = 60>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br><br>

<!---Eliminación de todas las reglas hijas de esos padres--->
<cfquery name="rsEliminaHijos" datasource="#session.dsn#">
    DELETE FROM HPCReglas
    WHERE exists (SELECT 1
                  FROM HPCReglas a
                  WHERE <cf_dbfunction name="datediff"  args="a.HBMfechaalta, now"> >= #LvarDiasVenc# 
                    AND a.PCRref IS NULL
                    AND a.PCRid = HPCReglas.PCRref)
</cfquery>


<!---Eliminación de todos los padres que cumplen con la restriccion de días superior a 60--->
<cfquery name="rsEliminaPadres" datasource="#session.dsn#">
    DELETE FROM HPCReglas
	WHERE <cf_dbfunction name="datediff"  args="HBMfechaalta, now"> >= #LvarDiasVenc# 
      AND PCRref IS NULL
      AND not exists(SELECT 1
                  	 FROM HPCReglas a
                     WHERE <cf_dbfunction name="datediff"  args="a.HBMfechaalta, now"> >= #LvarDiasVenc#                      
                        AND a.PCRref = HPCReglas.PCRid)
</cfquery>

<!---Eliminación de todas las reglas hijas que cumplen con la restriccion de días superior a 60--->
<cfquery name="rsEliminaHijos" datasource="#session.dsn#">
    DELETE FROM HPCReglas
	WHERE <cf_dbfunction name="datediff"  args="a.HBMfechaalta, now"> >= #LvarDiasVenc# 
    	AND PCRref IS NOT NULL
</cfquery>

<cfset finish = Now()>
<br> 
Proceso terminado <cfoutput>#TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>
</body>
</html>