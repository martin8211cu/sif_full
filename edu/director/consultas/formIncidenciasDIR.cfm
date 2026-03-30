<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Reporte de Observaciones y Anotaciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
<link href="../../css/portlets.css" rel="stylesheet" type="text/css">
<cfif isdefined("url.Nivel") and not isdefined("Form.Ncodigo")>
	<cfparam name="Form.Ncodigo" default="#url.Nivel#">
</cfif>
<cfif isdefined("url.profesor") and not isdefined("Form.cboProfesor")>
	<cfparam name="Form.cboProfesor" default="#url.profesor#">
</cfif>
<cfif isdefined("url.curso") and not isdefined("Form.cboCurso")>
	<cfparam name="Form.cboCurso" default="#url.curso#">
</cfif>
<cfif isdefined("url.periodo") and not isdefined("Form.cboPeriodo")>
	<cfparam name="Form.cboPeriodo" default="#url.periodo#">
</cfif>
<cfinclude template="commonDocenciaDIR.cfm">

<cfscript>
  sbInitFromSession("cboProfesor", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboCurso", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboPeriodo", "-999",isDefined("form.btnGrabar"));
</cfscript>
</head>
<body style="background-color: #E6E6E6">

<cfparam name="Form.hdnTipo" default="">
<cfparam name="Form.hdnEcodigo" default="">
<cfparam name="Form.hdnCodigo" default="">

<cfinclude template="qrysProfesorCursoPeriodoDIR.cfm">

<!--- <cfset qryOrigen = qryUsuActual> --->

<cfif not (#form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999" or #form.cboPeriodo# eq "-999")>
	<cfquery datasource="#Session.Edu.DSN#" name="qryPeriodoCerrado">
      set nocount on
	  select isnull(max(ACPEcerrado),'0') as Cerrado 
		from AlumnoCalificacionPerEval ac
	   where ac.PEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		 and ac.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		 and ac.Ccodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
      set nocount off
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="qryCursoCerrado">
      set nocount on
	  select isnull(max(ACCcerrado),'0') as Cerrado 
		from AlumnoCalificacionCurso ac
	   where ac.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		 and ac.Ccodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
      set nocount off
	</cfquery>

  <!--- <cfinclude template="/edu/docencia/incidencias_Grabar.cfm">
 --->
  <cfquery datasource="#Session.Edu.DSN#" name="qryEstudiantes">
    set nocount on
    select convert(varchar,a.Ecodigo) as Codigo, 
	p.Papellido1+' '+p.Papellido2+' '+p.Pnombre as Nombre,
           (select count(*)
		    from AlumnoCursoObservacion
		     where Ecodigo  = a.Ecodigo
		       and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cboCurso#">
			   and ACOtipo = 'P'
			   and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		   ) as Reforzamiento, 
           (select count(*)
		      from AlumnoCursoObservacion
		     where Ecodigo  = a.Ecodigo
		       and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cboCurso#">
			   and ACOtipo = 'N'
			   and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		   ) as Atencion, 
           (select count(*)
		    from AlumnoCursoObservacion
		     where Ecodigo  = a.Ecodigo
		       and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cboCurso#">
			   and ACOtipo = 'A'
			   and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		   ) as Advertencia, 
           (select count(*)
		      from AlumnoCursoAsistencia
		     where Ecodigo  = a.Ecodigo
		       and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cboCurso#">
			   and ACAtipo = 'A'
			   and isnull(ACAjustificado,'N') = 'S'
			   and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		   ) as AusenciaJus, 
           (select count(*)
		      from AlumnoCursoAsistencia
		     where Ecodigo  = a.Ecodigo
		       and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cboCurso#">
			   and ACAtipo = 'A'
			   and isnull(ACAjustificado,'N') <> 'S'
			   and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		   ) as AusenciaInjus, 
           (select count(*)
		      from AlumnoCursoAsistencia
		     where Ecodigo  = a.Ecodigo
		       and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cboCurso#">
			   and ACAtipo = 'T'
			   and isnull(ACAjustificado,'N') = 'S'
			   and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		   ) as TardiaJus, 
           (select count(*)
		      from AlumnoCursoAsistencia
		     where Ecodigo  = a.Ecodigo
		       and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cboCurso#">
			   and ACAtipo = 'T'
			   and isnull(ACAjustificado,'N') <> 'S'
			   and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		   ) as TardiaInjus, 
           (select count(*)
		      from AlumnoCursoAsistencia
		     where Ecodigo  = a.Ecodigo
		       and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cboCurso#">
			   and ACAtipo = 'R'
		       and isnull(ACAjustificado,'N') = 'S'
			   and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		   ) as TempranoJus, 
           (select count(*)
		      from AlumnoCursoAsistencia
		     where Ecodigo  = a.Ecodigo
		       and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cboCurso#">
 			   and ACAtipo = 'R'
			   and isnull(ACAjustificado,'N') <> 'S'
			   and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		   ) as TempranoInjus
      from AlumnoCalificacionCurso a, AlumnoCalificacionPerEval ac,
           Estudiante e, 
           PersonaEducativo p
     where a.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and a.Ecodigo      = e.Ecodigo
       and e.persona      = p.persona
       and ac.PEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
       and ac.Ecodigo     =* e.Ecodigo
  	   and ac.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
       and ac.Ccodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
    order by p.Papellido1, p.Papellido2, p.Pnombre
    set nocount off
  </cfquery>
</cfif>

<cfset LvarBorder = "border=1px solid ##CCCCCC;">
<style type="text/css">
    <!--
      .tdInvisible {
        border: 0px; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        background-color: #FF0000;
        WIDTH: 20px;
        HEIGHT:15px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
        display:'none';
      }
      .txtNormal {
        background-color: #E6E6E6;
        HEIGHT:19px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
      }
      .linEnc {
	background-color:#808080;
	font:  bold 10px Verdana, Arial, Helvetica, sans-serif;
	BORDER: 0;
	PADDING: 1px;
	MARGIN: 0px;
	border-right:1px solid #FFFFFF;
	border-top:1px solid #FFFFFF;
	text-align : center;
	vertical-align : middle;
	color: #FFFFFF;
      }
      .linPar {
	border: 0px;
	HEIGHT:19px;
	font:  10px Verdana, Arial, Helvetica, sans-serif;
	vertical-align: middle;
	text-align: center;
	background-color: #C0C0C0;
      }
      .linImpar {
	border: 0px;
	HEIGHT:19px;
	font:  10px Verdana, Arial, Helvetica, sans-serif;
	vertical-align: middle;
	text-align: center;
	background-color: #E6E6E6;
      }
      .linDetPar {
	border: 0px;
	HEIGHT:12px;
	font:  10px Verdana, Arial, Helvetica, sans-serif;
	vertical-align: middle;
	text-align: center;
	background-color: #C0C0C0;
      }
      .linDetImpar {
	border: 0px;
	HEIGHT:12px;
	font:  10px Verdana, Arial, Helvetica, sans-serif;
	vertical-align: middle;
	text-align: center;
	background-color: #E6E6E6;
      }
    -->
    </style>
<script language="JavaScript" src="/cfmx/edu/docencia/commonDocencia1_00.js"></script>
<script language="JavaScript" type="text/JavaScript">
    <!--
      function fnNuevaIncidencia(LprmEcodigo)
      {
         document.getElementById("hdnTipo").value = "";
         document.getElementById("hdnEcodigo").value = LprmEcodigo;
         document.frmIncidencias.submit();
      }
      function fnTrabajarConIncidencia(LprmTipo, LprmCodigo)
      {
         document.getElementById("hdnTipo").value = LprmTipo;
         document.getElementById("hdnCodigo").value = LprmCodigo;
         document.frmIncidencias.submit();
      }
      function fnReLoad()
      {
	    if (document.frmIncidencias.hdnTipo)
		{
          document.frmIncidencias.hdnTipo.value = "";
          document.frmIncidencias.hdnCodigo.value = "";
        }
        document.frmIncidencias.submit();
      }
      function fnVerificarDatos()
      {
         var LvarTipo = document.frmIncidencias.hdnTipo.value;
         if (LvarTipo == "") 
         {
		   if (document.frmIncidencias.optTipoComunicado)
		   { 
		     LvarTipo = "C";
		   }
		   else
		   {
             alert ('ERROR: Escoja el tipo de Incidencia');
             return false;
		   }
         }
         if (LvarTipo == "A")
		 {  
           if (fnVacio(document.frmIncidencias.txtFechaA.value))
           {
             alert("ERROR: Digite la fecha");
             return false;
           }
           if ( (document.frmIncidencias.chkJustificado.checked) && (fnVacio(document.frmIncidencias.txtJustifica.value)) )
           {
             alert("ERROR: Digite la persona que justifica");
             return false;
           }
           if ( (document.frmIncidencias.chkJustificado.checked) && (fnVacio(document.frmIncidencias.txtJustificacion.value)) )
           {
             alert("ERROR: Digite la Justificacion");
             return false;
           }
		 }
         else if (LvarTipo == "O")
		 {  
           if (fnVacio(document.frmIncidencias.txtFechaO.value))
           {
             alert("ERROR: Digite la fecha");
             return false;
           }
           if (fnVacio(document.frmIncidencias.txtObservacion.value) )
           {
             alert("ERROR: Digite la Observación");
             return false;
           }
		 }
         if (LvarTipo == "C")
		 {  
           if ( fnVacio(document.frmIncidencias.txtAsunto.value) )
           {
             alert("ERROR: Digite el Asunto");
             return false;
           }
           if ( fnVacio(document.frmIncidencias.txtMsg.value) )
           {
             alert("ERROR: Digite el Mensaje");
             return false;
           }

  	       if (document.frmIncidencias.optTipoC[0])
             for (var i=0; i<document.frmIncidencias.optTipoC.length; i++)
	 	       if ((document.frmIncidencias.optTipoC[i].checked) && (document.frmIncidencias.optTipoC[i].value == "T") )
			     if (!confirm("¿Desea enviar el mensaje a todos los alumnos del profesor?"))
                   return false;
		 }
         document.frmIncidencias.hdnTipo.value = LvarTipo;
		 return true;
      }
    -->
    </script>

<form name="frmIncidencias" method="POST" action=""
          style="font:10px Verdana, Arial, Helvetica, sans-serif;">
      <br>
      <p class="areaFiltro">
	  Profesor:
      <select name="cboProfesor"
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='if (this.value != "-999") fnReLoad();'>
          <cfif isdefined("RolActual") and RolActual EQ 11><option value="-999"></option></cfif>
		<cfset LvarSelected="0">
        <cfoutput query="qryProfesores">
          <option value="#Codigo#"<cfif #form.cboProfesor# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfoutput>			  
		<cfif #LvarSelected# eq "0">
		  <cfset form.cboProfesor="-999">
		</cfif>
      </select>
      Curso:
      <select name="cboCurso" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='if (this.value != "-999") fnReLoad();'>
          <option value="-999"></option>
		<cfset LvarSelected="0">
        <cfoutput query="qryCursos">
          <option value="#Codigo#"<cfif #form.cboCurso# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfoutput>			  
		<cfif #LvarSelected# eq "0">
		  <cfset form.cboCurso="-999">
		</cfif>
      </select><BR><BR>

      <cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999">
        <cfabort>
	  </cfif>

      Período:
      <select name="cboPeriodo" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='if (this.value == "-999") 
			              fnLoadcalificarCurso();
						else
						  fnReLoad();'>
        <cfoutput query="qryPeriodos">
          <option value="#Codigo#"<cfif (#form.cboPeriodo# eq #Codigo#) > selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfoutput>			  
      </select>
      <cfoutput> 
        <input type="hidden" name="txtRows" value="#qryEstudiantes.recordCount#">
	  </cfoutput>
      <br>
      <br>
	  </p>
      <cfoutput> 
      <input name="hdnEcodigo" id="hdnEcodigo" type="hidden" value="#Form.hdnEcodigo#">
      <input name="hdnCodigo" id="hdnCodigo" type="hidden" value="#Form.hdnCodigo#">
      <input name="hdnTipo" id="hdnTipo" type="hidden" value="#Form.hdnTipo#">
	  </cfoutput>
<table border="0" cellpading="0" cellspacing="0" width="100%" style="background-color:#E6E6E6;">
  <tr>
    <td valign="top">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class="LinEnc" rowspan="3" align="left"> 
            <font size="2">Estudiante</font>
          </td>
          <td class="LinEnc" colspan="3">&nbsp;Observaciones</td>
          <td class="linEnc" style="border-right:0" colspan="6">Control de Asistencia</td>
        </tr>
          <td class="LinEnc" rowspan="2">Reforza-<br>miento</td>
          <td class="LinEnc" rowspan="2">Llamada<br>Atención</td>
          <td class="LinEnc" rowspan="2">Adver-<br>tencia</td>
          <td class="LinEnc" colspan="2">Ausencia</td>
          <td class="LinEnc" colspan="2">Tardía</td>
          <td class="linEnc" style="border-right:0" colspan="2">Salida Temprano</td>
        <tr> 
          <td class="LinEnc">Justif.</td>
          <td class="LinEnc">Injus.</td>
          <td class="LinEnc">Justif.</td>
          <td class="LinEnc">Injus.</td>
          <td class="LinEnc">Justif.</td>
          <td class="linEnc" style="border-right:0">Injus.</td>
        </tr>
        <cfset GvarNombre = "Escoger un Estudiante">
        <cfset LvarPar="Impar">
        <cfoutput query="qryEstudiantes">
          <cfif LvarPar neq "Par">
            <cfset LvarPar="Par">
          <cfelse>
            <cfset LvarPar="Impar">
          </cfif>
          <tr class="lin#LvarPar#">
            <td nowrap>
			  <div style="width:150px; overflow:hidden;text-align:left; vertical-align:middle;">
              <a href="javascript:fnNuevaIncidencia('#Codigo#');" class="lin#LvarPar#">#Nombre#</a>
			  </div>
            </td>
            <td class="lin#LvarPar#"><cfif Reforzamiento gt 0>#Reforzamiento#</cfif></td>
            <td class="lin#LvarPar#"><cfif Atencion gt 0>#Atencion#</cfif></td>
            <td class="lin#LvarPar#"><cfif Advertencia gt 0>#Advertencia#</cfif></td>
            <td class="lin#LvarPar#"><cfif AusenciaJus gt 0>#AusenciaJus#</cfif></td>
            <td class="lin#LvarPar#"><cfif AusenciaInjus gt 0>#AusenciaInjus#</cfif></td>
            <td class="lin#LvarPar#"><cfif TardiaJus gt 0>#TardiaJus#</cfif></td>
            <td class="lin#LvarPar#"><cfif TardiaInjus gt 0>#TardiaInjus#</cfif></td>
            <td class="lin#LvarPar#"><cfif TempranoJus gt 0>#TempranoJus#</cfif></td>
            <td class="lin#LvarPar#"><cfif TempranoInjus gt 0>#TempranoInjus#</cfif></td>
          </tr>
		  <cfif Form.hdnEcodigo eq #Codigo#>
		    <cfset GvarNombre = #Nombre#>
            <cfquery datasource="#Session.Edu.DSN#" name="qryIncidencias">
		      set nocount on
			  select 'O' as TipoIncidencia, convert(varchar,ACOcodigo) as Codigo, 
			  	     ACOfecha as Fecha, ACOtipo as Tipo, 'N' as Justificado
			    from AlumnoCursoObservacion
			   where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryEstudiantes.Codigo#">
			     and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				 and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
				 and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			  UNION
			  select 'A', convert(varchar,ACAcodigo) as ACAcodigo, ACAfecha, ACAtipo, ACAjustificado
			    from AlumnoCursoAsistencia 
			   where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryEstudiantes.Codigo#">
			     and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				 and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
				 and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			  order by Fecha
		      set nocount off
			</cfquery>
			<cfloop query="qryIncidencias">
            <cfif LvarPar neq "Par">
              <cfset LvarPar="Par">
            <cfelse>
              <cfset LvarPar="Impar">
            </cfif>
            <tr class="linDet#LvarPar#">
              <td align="right">
			  		<!--- <a href="javascript:fnTrabajarConIncidencia('#TipoIncidencia#','#Codigo#')">#lsDateFormat(Fecha,"dd/mm/yy")#&nbsp;</a> --->
					#lsDateFormat(Fecha,"dd/mm/yy")#&nbsp;
			  </td>
			  <cfif TipoIncidencia eq "O">
 			    <cfset LvarTipo="Observación de ">
				<cfif Tipo eq "P">
				  <cfset LvarTipo=LvarTipo & " Reforzamiento">
				<cfelseif Tipo eq "N">
				  <cfset LvarTipo=LvarTipo & " Llamada de Atención">
				<cfelseif Tipo eq "A">
				  <cfset LvarTipo=LvarTipo & " Advertencia">
				</cfif>
			  <cfelse>
 			    <cfset LvarTipo="Control de ">
				<cfif Tipo eq "T">
				  <cfset LvarTipo=LvarTipo & "Llegada Tardía">
				<cfelseif Tipo eq "A">
				  <cfset LvarTipo=LvarTipo & "Ausencia">
				<cfelseif Tipo eq "R">
				  <cfset LvarTipo=LvarTipo & "Salida Temprano">
				</cfif>
				<cfif Justificado eq "S">
				  <cfset LvarTipo=LvarTipo & " Justificada">
				<cfelse>
				  <cfset LvarTipo=LvarTipo & " Injustificada">
				</cfif>
			  </cfif>
              <!--- <td align="left" colspan="9"><a href="javascript:fnTrabajarConIncidencia('#TipoIncidencia#','#Codigo#')">&nbsp;#LvarTipo#</a></td> --->
			  <td align="left" colspan="9">&nbsp;#LvarTipo#</td>
            </tr>
			</cfloop>
		  </cfif>
        </cfoutput>
      </table>
    </td>
    <td valign="top" style="border: 0px; background-color:#E6E6E6;">
	  <div style="width:10px;"></div>
	</td>
    <td valign="top" style="border-style: solid; border-width: 1; font:10px Verdana, Arial, Helvetica, sans-serif; background-color:#E6E6E6;">
  <cfoutput>

	<br>
</cfoutput>
    </td>
  </tr>
</table>

</form>
</body>
</html> 