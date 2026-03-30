<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Notas del Alumno</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<!--- <link href="../../css/portlets.css" rel="stylesheet" type="text/css"> --->
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>
		<cfinclude template="../../Utiles/general.cfm">
		<!--- <cfif isdefined("Url.Grupo") and not isdefined("Form.Grupo")>
			<cfparam name="Form.Grupo" default="#Url.Grupo#">
		</cfif> 
		<cfif isdefined("Url.Ecodigo") and not isdefined("Form.Ecodigo")>
			<cfparam name="Form.Ecodigo" default="#Url.Ecodigo#">
		</cfif>  --->

		<cfquery name="rsNiveles" datasource="#Session.Edu.DSN#">
				select Ncodigo, Ndescripcion 
				from Nivel 
				where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and Preesco = 0
				order by Norden 
			</cfquery>
			<cfquery datasource="#Session.Edu.DSN#" name="rsFiltroGrupos">
				Select distinct (convert(varchar,b.GRcodigo) + '|' + convert(varchar,c.Ncodigo)) as codigoGrupo,GRnombre , c.SPEcodigo as SPEcodigo
				from Alumnos a , GrupoAlumno b , Grupo c , Nivel d , Grado e 
				where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
					and Aretirado=0 
					and a.CEcodigo=b.CEcodigo 
					and a.Ecodigo=b.Ecodigo 
					and b.GRcodigo = c.GRcodigo 
					and c.Ncodigo=d.Ncodigo 
					and c.SPEcodigo in ( select SPEcodigo from PeriodoVigente ) 
					and c.Gcodigo=e.Gcodigo 
				order by Norden, Gorden, GRnombre 
			</cfquery>


 <script language="JavaScript" type="text/JavaScript">  
		
		function doConlis(f, opc) {
			if(opc == 1){	// Alumnos
				popUpWindow("conlisAlumnosEnc.cfm?form=formNotaFinal"
						+"&NombreAl=Alumno"
						+"&Ecodigo=Ecodigo" 
						+"&Ncodigo=" + f.Ncodigo.value
						+"&GRcodigo=" + f.Grupo.value,250,200,650,350);
			}
		} 
		
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}		 		
</script>

 <body>           
            <form name="formNotaFinal" method="post" action="ListaNotasFinalesEnc.cfm" >
				<input name="CursoSel" type="hidden" value="" id="CursoSel">
				<!--- <input name="Ecodigo" type="hidden" value="<cfif isdefined('form.Ecodigo') and form.Ecodigo NEQ '-1'><cfoutput>#form.Ecodigo#</cfoutput><cfelse>-1</cfif>" id="Ecodigo">				
				<input name="Grupo" type="hidden" value="<cfif isdefined('form.Grupo') ><cfoutput>#form.Grupo#</cfoutput></cfif>" id="Grupo">				
				 ---><input name="ECcodigo" type="hidden" value="<cfif isdefined('form.ECcodigo') and form.ECcodigo NEQ '-1'><cfoutput>#form.ECcodigo#</cfoutput><cfelse>-1</cfif>" id="ECcodigo">

					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr> 
						<td> <cfinclude template="formNotasFinalesEnc.cfm"> 
						</td>
					  </tr>
					</table>

            </form>
</body>
</html>