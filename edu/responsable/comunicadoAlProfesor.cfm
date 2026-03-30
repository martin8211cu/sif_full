<cfif isdefined("Session.RolActual") and Session.RolActual eq 6>
	<cfset monitoreo_modulo="EDU EST">
	<cfinclude template="../monitoreo.cfm">
<cfelseif isdefined("Session.RolActual") and Session.RolActual eq 7>
	<cfset monitoreo_modulo="EDU RES">
	<cfinclude template="../monitoreo.cfm">
</cfif>

<cfif url.Tipo eq "M0">
	<cfinclude template="commonDocencia.cfm">
	<cfif isdefined("Session.RolActual") and Session.RolActual eq 6>
	  <cfquery name="rsEstSel" datasource="#Session.Edu.DSN#">
		 select convert(varchar, Ecodigo) as Ecodigo
		 from Estudiante
		 where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
		 and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
	  </cfquery>
	  <cfif rsEstSel.recordCount GT 0>
		  <cfset Form.cboAlumno = rsEstSel.Ecodigo>
	  <cfelse>
		  <cfset Form.cboAlumno = "0">
	  </cfif>
	<cfelse>
	  <cfset form.cboAlumno = url.Codigo>
	</cfif>
	<cfquery datasource="#Session.Edu.DSN#" name="qryAlumno">
	  select distinct convert(varchar,a.Ecodigo) as Codigo,  
		Pnombre+' '+Papellido1+' '+Papellido2 as Nombre
		from Alumnos a, PersonaEducativo pe
	   where a.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		 and pe.persona  = a.persona
		 and a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno#">
	  order by  2
	</cfquery>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Comunicado al Profesor</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/edu.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.CeldaHdr {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 14;
    font-weight:bold;
    color: #E6E6E6;
    background-color: #666666;
    vertical-align: middle;
    border-right: 1px solid;
    border-top: 1px solid;
    margin: 0px;
    padding: 1px;
    text-align: center;
}
-->
</style>
</head>
<body style="background-color: #E6E6E6">
</cfif>
<script language="JavaScript" type="text/JavaScript">
function fnVerificarDatos()
{
  if (document.frmMail.txtAsunto.value == "")
  {
    alert("ERROR: Digite el asunto del Comunicado al Profesor");
	return false;
  }
  if (document.frmMail.txtMSG.value == "")
  {
    alert("ERROR: Digite el mensaje del Comunicado al Profesor");
	return false;
  }
  if (document.frmMail.cboProfesor.value == "-999")
  {
    if (!confirm("¿Esta seguro que desea enviar el comunicado a TODOS lo profesores del alumno?"))
 	  return false;
  }
}
</script>
<cfoutput>

<cfquery datasource="#Session.Edu.DSN#" name="qryUsuActual">
  select Pnombre+' '+Papellido1+' '+Papellido2 as Nombre, 
         convert(varchar(18),Usucodigo)        as USUcodigo, 
		 Ulocalizacion                         as USUlocalizacion, 
		 Usulogin                              as Login 
    from Usuario
   where Usucodigo = #Session.Edu.Usucodigo#
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="qryProfesores">
  select distinct convert(varchar,s.Splaza) as Codigo,
  	     Papellido1+' '+Papellido2+' '+Pnombre as Nombre,
		 <cfif url.Tipo eq 'M0'>m.Mnombre as Curso,</cfif>
         convert(varchar(18), s.Usucodigo) as Usucodigo, s.Ulocalizacion, pe.Pemail1 as eMail, convert(varchar, c.Ccodigo) as CodCurso
    from Staff s, PersonaEducativo pe, Curso c, Materia m, Grupo g, PeriodoVigente v, AlumnoCalificacionCurso a
     where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
       and c.Mconsecutivo = m.Mconsecutivo
	   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
       and c.GRcodigo = g.GRcodigo
       and m.Ncodigo = v.Ncodigo
       and c.PEcodigo = v.PEcodigo
       and c.SPEcodigo = v.SPEcodigo
	   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cboAlumno#">
	   and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	   and a.Ccodigo = c.Ccodigo
	   <cfif url.Tipo neq 'M0'>
	   		and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryCurso.Ccodigo#">
	   </cfif>
	   and c.Splaza = s.Splaza
	   and pe.persona = s.persona
</cfquery>
		  <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">COMUNICADO AL PROFESOR</div>
	    </td>
		</tr><tr>
      <cfif isdefined("url.btnEnviar")>
	    <td>
	<br><br>
	
    <cfquery dbtype="query" name="qryCorreos">
      select distinct Nombre as NombreDestino, Usucodigo, Ulocalizacion, eMail
		from qryProfesores
		<cfif #url.cboProfesor# neq "-999">
	      where Codigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.cboProfesor#">
		</cfif>
	</cfquery>
	<cfif Session.RolActual eq 6>
	  <cfset LvarAsunto = "Comunicado de Alumno">
	  <cfset LvarOrigen = qryUsuActual.Nombre & " (Alumno)">
	<cfelse>
	  <cfset LvarAsunto = "Comunicado de Encargado de Alumno">
	  <cfset LvarOrigen = qryUsuActual.Nombre & " (Encargado de "& qryAlumno.Nombre & ")">
	</cfif>
    <cfset LvarError = fnNotificarCorreoBuzon ("","","","",url.txtAsunto,url.txtMSG,LvarOrigen, LvarAsunto, qryCorreos, false)>
	#LvarAsunto & ': ' & url.txtAsunto#<br>
	De:		#LvarOrigen#<br><br>
    <cfif LvarError eq "">
      <p align="center" style="font-size:14px"><b>Mensaje enviado con éxito</b></p>
	<cfelse>
	  #LvarError#
	</cfif>
	
	    </td>
	  <cfelse> 
  <form name="frmMail">
    <input type="hidden" name="Tipo" value="#url.Tipo#">
    <input type="hidden" name="Codigo" value="#url.Codigo#">
    <input type="hidden" name="Periodo" value="#url.Periodo#">
    <input type="hidden" name="TipoLista" value="M">
    <table border="0" width="100%">
      <tr>
        <td width="80">De:</td>
        <td>#qryUsuActual.Nombre#</td>
      </tr>
      <tr>
        <td width="80">Para:</td>
        <td><select size="1" name="cboProfesor"> 
<cfif url.Tipo eq 'M0'>
        <option value="-999">* * TODOS LOS PROFESORES * *</option>
</cfif>		
		<cfloop query="qryProfesores">
           <option value="#Codigo#" <cfif (isDefined("qryCurso") and Codigo eq qryCurso.Splaza) or (isdefined("url.C") and Trim(url.C) eq CodCurso)>selected</cfif>>#Nombre#<cfif url.Tipo eq 'M0'> (#Curso#)</cfif></option>
		</cfloop>
          </select></td>
      </tr>
      <tr>
        <td width="80">Asunto:</td>
        <td>
          <input type="text" size="31" name="txtAsunto">
        </td>
      </tr>
    </table> 
    Mensaje<br>
    <textarea rows="10" cols="45" style="font:10px Verdana, Arial, Helvetica, sans-serif;" name="txtMSG"></textarea>
    <p align="center"><input type="submit" value="Enviar" name="btnEnviar" class="boxNormal" onClick="return fnVerificarDatos();"></p>
  </form>
      </cfif>
<cfif url.Tipo eq "M0">
</body></html>
</cfif>

</cfoutput>