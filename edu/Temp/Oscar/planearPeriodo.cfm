<cfparam name="Session.CENEDCODIGO" default="5">
<cfset Session.CENEDCODIGO = "5">
Session.CENEDCODIGO=5<br>
Soy Asistente<BR>
<cffunction name="sbInitFromSession">
           <cfargument name="LprmControl" required="true" type="string">
           <cfargument name="LprmDefault" required="true" type="string">
           <cfargument name="LprmNoChange" required="false" type="boolean" default=false>
  <cfparam name="Session.calificarEvaluaciones.#LprmControl#" default="#LprmDefault#">
  <cfif LprmNoChange>
    <cfset form[LprmControl] = Session.calificarEvaluaciones[LprmControl]>
  <cfelse>
    <cfparam name="form.#LprmControl#" default="#Session.calificarEvaluaciones[LprmControl]#">
  </cfif>
  <cfset Session.calificarEvaluaciones[LprmControl] = form[LprmControl]>
</cffunction>

<cffunction name="sbInitFromSessionChks">
           <cfargument name="LprmChk"     required="true" type="string">
           <cfargument name="LprmDefault" required="true" type="string">
  <cfif isdefined("form.chkXAlumno")>
    <cfparam name="form.#LprmChk#" default="0">
  <cfelse>
    <cfparam name="Session.calificarEvaluaciones.#LprmChk#" default="#LprmDefault#">
    <cfparam name="form.#LprmChk#" default="#Session.calificarEvaluaciones[LprmChk]#">
  </cfif>
  <cfset Session.calificarEvaluaciones[LprmChk] = form[LprmChk]>
</cffunction>

<cfscript>
  sbInitFromSession("cboProfesor", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboCurso", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboPeriodo", "-999",isDefined("form.btnGrabar"));
</cfscript>
<cfparam name="form.hdnTipoOperacion" default="">
<cfparam name="form.hdnCodigo" default="">
<cfparam name="form.hdnFecha" default="">
<cfset Session.javascript_txtFecha = false>
<cfquery datasource="Educativo" name="qryProfesores">
  select distinct s.Splaza as Codigo,  Papellido1+' '+Papellido2+' '+Pnombre as Descripcion
    from Staff s, PersonaEducativo pe, Curso c
   where s.CEcodigo = #Session.CENEDCODIGO#
     and pe.persona = s.persona
     and c.Splaza   = s.Splaza
     and c.CEcodigo = s.CEcodigo
     and exists ( 
	     select *
           from Nivel n, PeriodoVigente pv , PeriodoEscolar pe , SubPeriodoEscolar spe
          where n.CEcodigo    = s.CEcodigo
            and n.Ncodigo     = pv.Ncodigo
            and pe.Ncodigo    = pv.Ncodigo
            and spe.PEcodigo  = pe.PEcodigo
            and spe.SPEcodigo = pv.SPEcodigo
			and spe.SPEcodigo = c.SPEcodigo 
			)
  UNION
    select 0,  '* Cursos sin Profesor'
  order by  2
</cfquery>
<!--- 
VERIFICAR QUE EL USUARIO TENGA DERECHO A UTILIZAR EL PROFESOR INDICADO
 --->
<cfif form.cboProfesor neq "-999">
  <cfquery dbtype="query" name="qryPermiso">
    select count(*) as Permiso
	  from qryProfesores
	 where Codigo = #form.cboProfesor#
  </cfquery>
  <cfif qryPermiso.Permiso eq "0">
    NO TIENE AUTORIZACION PARA CALIFICAR LOS CURSOS DEL PROFESOR INDICADO
	<cfabort>
  </cfif>
</cfif>

<cfinclude template="planearPeriodo_Grabar.cfm">

<cfquery datasource="Educativo" name="qryCursos">
  <cfif #form.cboProfesor# neq "0">
    select Ccodigo as Codigo, Cnombre as Descripcion
      from Curso c, Materia m, Grupo g, PeriodoVigente v
     where c.CEcodigo = #Session.CENEDCODIGO#
       and c.Mconsecutivo = m.Mconsecutivo
	   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
       and c.Splaza = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboProfesor#">
       and c.GRcodigo *= g.GRcodigo
       and m.Ncodigo = v.Ncodigo
       and c.PEcodigo = v.PEcodigo
       and c.SPEcodigo = v.SPEcodigo
     order by c.GRcodigo,Cnombre
  <cfelse>
    select Ccodigo as Codigo, Ndescripcion+': '+Cnombre as Descripcion
      from Curso c, Materia m, PeriodoVigente v, Nivel n
     where c.CEcodigo     = #Session.CENEDCODIGO#
       and c.Mconsecutivo = m.Mconsecutivo
	   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
       and c.Splaza       = null
       and m.Ncodigo      = v.Ncodigo
       and c.PEcodigo     = v.PEcodigo
       and c.SPEcodigo    = v.SPEcodigo
       and m.Ncodigo      = n.Ncodigo
    order by n.Norden, Cnombre
  </cfif>
</cfquery>
<cfquery datasource="Educativo" name="qryPeriodos">
  select p.PEcodigo Codigo, p.PEdescripcion as Descripcion, PEevaluacion as Actual, 
         sp.SPEfechainicio, sp.SPEfechafin, datediff(dd,sp.SPEfechainicio,sp.SPEfechafin) as SPEdias
    from Curso c, Materia m, PeriodoEvaluacion p, PeriodoVigente v, SubPeriodoEscolar sp
   where c.CEcodigo     = #Session.CENEDCODIGO#
     and c.Ccodigo      = #form.cboCurso#
     and c.Mconsecutivo = m.Mconsecutivo
     and m.Ncodigo      = p.Ncodigo
     and v.Ncodigo   = m.Ncodigo
     and v.PEcodigo  = c.PEcodigo
     and v.SPEcodigo = c.SPEcodigo
     and sp.PEcodigo  = c.PEcodigo
     and sp.SPEcodigo = c.SPEcodigo
  order by p.PEorden
</cfquery>
<cfquery datasource="Educativo" name="qryPlanes">
  select 'E' as tipo, e.Ccodigo as curso, e.ECcomponente as codigo, e.ECnombre as nombre, 
         isnull(e.ECreal, e.ECplaneada) as fecha, isnull(convert(char(1),e.ECreal,112),'N') as cubierto
    from EvaluacionCurso e
   where e.Ccodigo    = #form.cboCurso#
     and e.PEcodigo   = #form.cboPeriodo#
UNION
  select 'T', t.Ccodigo, t.CPcodigo, t.CPnombre, 
         t.CPfecha, t.CPcubierto
    from CursoPrograma t
   where t.Ccodigo    = #form.cboCurso#
     and t.PEcodigo   = #form.cboPeriodo#
order by fecha
</cfquery>
<cfquery dbtype="query" name="qryLimites">
    select min(fecha) as Primera, max(fecha) as Ultima
	  from qryPlanes
</cfquery>
<cfquery datasource="Educativo" name="qryHorarios">
  select distinct convert(int,HRdia)+2 as HRdia
    from HorarioGuia
   where Ccodigo      = #form.cboCurso#
</cfquery>
<cfset GvarHorarios="*">
<cfloop query="qryHorarios">
  <cfif HRdia eq 8>
    <cfset GvarHorarios = GvarHorarios & "1*">
  <cfelse>
    <cfset GvarHorarios = GvarHorarios & HRdia & "*">
  </cfif>
</cfloop>
<cfset LvarSelected1 = "">
<cfset LvarSelectedCbo = "">
<cfset LvarSelectedAct = "">
<cfloop query="qryPeriodos">
  <cfif currentRow eq 1>
    <cfset LvarSelected1 = Codigo>
  </cfif>
  <cfif Codigo eq form.cboPeriodo>
    <cfset LvarSelectedCbo = Codigo>
  <cfelseif Codigo eq Actual>
    <cfset LvarSelectedAct = Codigo>
  </cfif>
</cfloop>
<cfif LvarSelectedCbo neq "">
  <cfset form.cboPeriodo = LvarSelectedCbo>
<cfelseif LvarSelectedAct neq "">
  <cfset form.cboPeriodo = LvarSelectedAct>
<cfelse>
  <cfset form.cboPeriodo = LvarSelected1>
</cfif>
<cfset LvarIni=qryPeriodos.SPEfechainicio>
<cfset LvarFin=qryPeriodos.SPEfechafin>
<cfloop query="qryPeriodos">
  <cfif Codigo eq form.cboPeriodo>
    <cfset LvarIni=dateadd("d",qryPeriodos.SPEdias/qryPeriodos.recordCount * (qryPeriodos.currentRow-1),qryPeriodos.SPEfechainicio)>
	<cfif qryLimites.Primera neq "" and LvarIni gt qryLimites.Primera><cfset LvarIni = qryLimites.Primera></cfif>
    <cfset LvarFin=dateadd("d",qryPeriodos.SPEdias/qryPeriodos.recordCount*qryPeriodos.currentRow,qryPeriodos.SPEfechainicio)>
	<cfif qryLimites.Ultima neq "" and LvarFin lt qryLimites.Ultima><cfset LvarFin = qryLimites.Ultima></cfif>
	<cfbreak>
  </cfif>
</cfloop>

<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
.TxtNormal {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11;
	margin: 0px;
	padding: 0px;
}
.CeldaTxt {
	text-indent: -12;
	margin-left: 12;
	margin-right: -4;
	margin-top: 0;
	margin-bottom: 0;
}
.CeldaHdr {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14;
	font-weight:bold;
	color: #FFFFFF;
	background-color: #ADADCA;
	vertical-align: middle;
	border-right: 1px solid;
	border-top: 1px solid;
	margin: 0px;
	padding: 1px;
	text-align: center;
}
.CeldaNoCurso {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: normal;
	background-color: #E6E6E6;
	vertical-align: top;
	height: 30px;
	border-right: 1px solid;
	border-top: 1px solid;
	margin: 0px;
	padding: 0px;
}
.CeldaCurso {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: normal;
	background-color: #C0C0C0;
	vertical-align: top;
	border-right: 1px solid;
	border-top: 1px solid;
	margin: 0px;
	padding: 0px;
}
.CeldaRef {
    text-decoration:none; 
	color:#000000; 
	font-size: 10px;
	font-weight: normal;
}
.CeldaFechaRef {
    text-decoration:none; 
	color:#000000; 
	font-size: 11px;
	font-weight: normal;
}
-->
</style>
<script language="JavaScript">
<!--
     <cfif qryPeriodos.SPEfechainicio neq "">
	 <cfoutput>
       var GvarFechaInicial = "#lsDateFormat(qryPeriodos.SPEfechainicio,"YYYYMMDD")#";
       var GvarFechaFinal = "#lsDateFormat(dateadd("d",30,qryPeriodos.SPEfechafin),"YYYYMMDD")#";
	 </cfoutput>
	 </cfif>
      function fnFormat(LprmValor,LprmDec,LprmPuntoDec)
      {
        if (LprmValor == "")
		  return "";
        var LvarValOriginal = LprmValor;
        var LvarSigno = 1;
        var LvarPunto = 0;
        var LvarCeros = 0;
        var i = 0;

        // AJUSTA PARAMETROS, PRIMERO LOS CONVIERTE A STRING, Y LUEGO PONE VALORES DEFAULT

        LprmValor += "";
        if( (LprmValor.length == 0) || (isNaN(parseFloat(LprmValor))) )
          LprmValor = 0;
        else
        {
          LprmValor = parseFloat(LprmValor);
          if(LprmValor < 0)
          {
            LvarSigno = -1;
            LprmValor = Math.abs(LprmValor);
          }
        }

        LprmDec += "";
        if((parseInt(LprmDec,10)) || (parseInt(LprmDec,10) == 0))
        {
          LprmDec = Math.abs(parseInt(LprmDec,10));
        }
        else
        {
          LprmDec = 0;
        }

        LprmPuntoDec += "";
        if((LprmPuntoDec == "") || (LprmPuntoDec.length > 1))
          LprmPuntoDec = ".";

        // REDONDEA EL VALOR AL NUMERO DE DEC
        if (LprmDec == 0)
          LprmValor = "" + Math.round(LprmValor);
        else
          LprmValor = "" + Math.round(LprmValor * Math.pow(10,LprmDec)) / Math.pow(10,LprmDec);

        //if ((LprmValor.substring(1,2) == ".") || ((LprmValor + "")=="NaN"))
          //return(LvarValOriginal);

        if (LprmDec > 0)
        {
          // RELLENA CON CEROS A LA DERECHA DEL PUNTO DECIMAL
          LvarPunto = LprmValor.indexOf(LprmPuntoDec);
          if (LvarPunto == -1)
          {
            LprmValor += LprmPuntoDec;
            LvarPunto = LprmValor.indexOf(LprmPuntoDec);
          }
          LvarCeros =  LprmDec - (LprmValor.length - LvarPunto - 1);
          for(i = 0; i < LvarCeros; i++)
            LprmValor += "0";
        }

        if(LvarSigno == -1)
          LprmValor = "-" + LprmValor;

        return(LprmValor);
      }
	  function fnKeyPress(txtBox, e)
      {
        if (txtBox.type != "text")
          return true;

        var keycode;
        if (window.event)
          keycode = window.event.keyCode;
        else if (e)
          keycode = e.which;
        else
          return true;

        if (((keycode>47) && (keycode<58) ) || (keycode==8))
          return true;
        else if ((keycode==46) && (txtBox.value != "") &&
                 (txtBox.value.indexOf(".") == -1))
          return true;
        else
          return false;
      }
      function fnReLoad()
      {
//	    if (fnVerificarCambios())
          document.frmPlan.submit();
      }
      function fnNuevoEvento(LprmFecha)
      {
         document.getElementById("hdnTipoOperacion").value = "";
         document.getElementById("hdnFecha").value = "{ts '" + LprmFecha.substr(0,4)+"-"+LprmFecha.substr(4,2)+"-"+LprmFecha.substr(6,2) + " 00:00:00'}";
		 document.frmPlan.submit();
      }
      function fnTrabajarConEvento(LprmTipo,LprmFecha,LprmCodigo)
      {
         document.getElementById("hdnTipoOperacion").value = LprmTipo;
         document.getElementById("hdnFecha").value = "{ts '" + LprmFecha.substr(0,4)+"-"+LprmFecha.substr(4,2)+"-"+LprmFecha.substr(6,2) + " 00:00:00'}";
         document.getElementById("hdnCodigo").value = LprmCodigo;
		 document.frmPlan.submit();
      }
      function fnVerificarDatos()
      {
	     var LvarTipoOperacion = document.getElementById("hdnTipoOperacion").value;
		 if (LvarTipoOperacion == "") 
		 {
		   alert ('ERROR: Escoja el tipo de Evento');
		   return false;
		 }
         if ((LvarTipoOperacion == "E") && (document.frmPlan.cboECcodigo.value == ""))
  	     {
	       alert("ERROR: El curso no ha sido planeado para el período indicado");
		   return false;
         }
	     if (document.frmPlan.txtNombre.value == "")
		 {
		   alert("ERROR: Digite el nombre corto del Evento");
		   return false;
		 }
		 if (document.frmPlan.txtFecha.value == "")
		 {
		   alert("ERROR: Digite la fecha planeada del Evento");
		   return false;
		 }
		 else 
		 { 
		   var LvarFecha = fnToDateYYYYMMDD(document.frmPlan.txtFecha.value);
           if (LvarFecha < GvarFechaInicial || LvarFecha > GvarFechaFinal)
           {
		     alert("ERROR: La fecha planeada esta fuera del ciclo lectivo");
		     return false;
		   }
		 }
		 if (document.frmPlan.txtDuracion.value == "")
	     {
		   alert("ERROR: Digite la duración del Evento");
		   return false;
	     }
         if ((LvarTipoOperacion == "T") && (document.frmPlan.txtOrden.value == ""))
  	     {
	       alert("ERROR: Digite el Orden del Evento");
		   return false;
         }
         if ((LvarTipoOperacion == "E") && (document.frmPlan.txtFechaReal.value != ""))
		 { 
		   var LvarFecha = fnToDateYYYYMMDD(document.frmPlan.txtFechaReal.value);
           if (LvarFecha < GvarFechaInicial || LvarFecha > GvarFechaFinal)
           {
		     alert("ERROR: La fecha real esta fuera del ciclo lectivo");
		     return false;
		   }
		 }
		 return true;
      }
	  function fnToDate(LprmFecha)
	  {
    	if (LprmFecha == "") 
		  return "";
	    var LvarPartes = LprmFecha.split ("/");
		return new Date(parseInt(LvarPartes[2], 10), parseInt(LvarPartes[1], 10)-1, parseInt(LvarPartes[0], 10));
	  }
	  function fnToDateYYYYMMDD(LprmFecha)
	  {
    	if (LprmFecha == "") 
		  return "";
	    var LvarPartes = LprmFecha.split ("/");
		return LvarPartes[2] + LvarPartes[1] + LvarPartes[0];
	  }
-->
</script>
</head>

<body>

<form name="frmPlan" method="POST" action=""
          style="font:10px Verdana, Arial, Helvetica, sans-serif;">
      <br>
      Profesor:
      <select name="cboProfesor"
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='if (this.value != "-999") fnReLoad();'>
          <option value="-999"></option>
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
      </select>
      Período:
      <select name="cboPeriodo" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='if (this.value == "-999") 
			              fnLoadcalificarCurso();
						else
						  fnReLoad();'>
		<cfset LvarSelected="0">
		<cfset LvarSelectedActual="0">
		<cfset LvarSelectedPrimero="">
        <cfloop query="qryPeriodos">
		  <cfif currentRow eq 1>
		    <cfset LvarSelectedPrimero=Codigo>
		  </cfif>
          <cfif #form.cboPeriodo# eq #Codigo# >
		    <cfset LvarSelected="1">
		  </cfif>
          <cfif #form.cboPeriodo# eq #qryPeriodos.Actual# >
		    <cfset LvarSelectedActual="1">
		  </cfif>
        </cfloop>			  
		<cfif #LvarSelected# eq "0">
  		  <cfif #LvarSelectedActual# eq "0">
		    <cfset form.cboPeriodo=LvarSelectedPrimero>
		  <cfelse>
		    <cfset form.cboPeriodo=qryPeriodos.Actual>
		  </cfif>
		</cfif>
        <cfoutput query="qryPeriodos">
          <option value="#Codigo#"<cfif (#form.cboPeriodo# eq #Codigo#) > selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfoutput>			  
      </select>
  <br>
  <br>
  <cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999" or #form.cboPeriodo# eq "-999">
    
    
    
    
    <cfabort>
	  </cfif>
	  
  <table border="0" cellpading="0" cellspacing="0"><tr><td valign="top">
    <table border="0" cellpading="-1" cellspacing="-1">
      <tr> 
        <td class="CeldaHdr"><div style="width:20px;font:9px;">Semana&nbsp;</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Domingo</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Lunes</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Martes</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Miercoles</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Jueves</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Viernes</div></td>
        <td class="CeldaHdr"><div style="width:60px;">Sabado</div></td>
      </tr>
      <cfset LvarSem = 1>
      <tr> 
        <td class="CeldaHdr">1</td>
        <cfset LvarDW = datepart("w", LvarIni)-1>
        <cfloop from="1" to="#LvarDW#" index="LvarCol">
          <td class="CeldaNoCurso">&nbsp;</td>
        </cfloop><cfoutput>
        <cfif Find("*" & (LvarDW+1) & "*", GvarHorarios) eq 0>
          <cfset LvarCeldaCurso="CeldaNoCurso">
          <cfelse>
          <cfset LvarCeldaCurso="CeldaCurso">
        </cfif>
        <cfset LvarFecha=LvarIni>
        <td  class="#LvarCeldaCurso#"><a href="javascript:fnNuevoEvento('#lsdateformat(LvarFecha,"YYYYMMDD")#')" class="CeldaFechaRef">#lsdateformat(LvarFecha,"DD MMM YY")#</a>
		<cfloop query="qryPlanes"> 
		<cfloop condition="LvarFecha lt Fecha"> 
          <cfset LvarFecha = dateadd("D",1,LvarFecha)> <cfset LvarDW = datepart("w",LvarFecha)> 
        </td><cfif LvarDW eq 1>
      </tr>
      <tr> 
        <cfset LvarSem = LvarSem + 1 >
        <td class="CeldaHdr">#LvarSem#</td></cfif>
        <cfif Find("*" & (LvarDW) & "*", GvarHorarios) eq 0>
          <cfset LvarCeldaCurso="CeldaNoCurso">
          <cfelse>
          <cfset LvarCeldaCurso="CeldaCurso">
        </cfif>
        <td  class="#LvarCeldaCurso#"><a href="javascript:fnNuevoEvento('#lsdateformat(LvarFecha,"YYYYMMDD")#')" class="CeldaFechaRef"> 
          <cfif datepart("d",LvarFecha) eq 1>
            #lsdateformat(LvarFecha,"D MMM YY")# 
          <cfelse>
            #lsdateformat(LvarFecha,"D")# 
          </cfif>
          </a> </cfloop> <cfif Fecha eq LvarFecha>
            <p class="CeldaTxt"><img src="planea<cfif Tipo eq "T"><cfif Cubierto neq "N">TC<cfelse>TA</cfif><cfelse><cfif Cubierto neq "N">EC<cfelse>EA</cfif></cfif>.gif"> 
              <a href="javascript:fnTrabajarConEvento('<cfif Tipo eq "T">T<cfelse>E</cfif>','#lsdateformat(LvarFecha,"YYYYMMDD")#','#Codigo#');" class="celdaRef">#Nombre#</a></p>
          </cfif> </cfloop> <cfloop condition="LvarFecha lt LvarFin"> </td>
        <cfset LvarFecha = dateadd("d",1,LvarFecha)>
        <cfset LvarDW = datepart("w",LvarFecha)><cfif LvarDW eq "1">
      </tr>
      <tr> 
        <cfset LvarSem = LvarSem + 1 >
        <td class="CeldaHdr">#LvarSem#</td></cfif>
        <cfif Find("*" & (LvarDW) & "*", GvarHorarios) eq 0>
          <cfset LvarCeldaCurso="CeldaNoCurso">
          <cfelse>
          <cfset LvarCeldaCurso="CeldaCurso">
        </cfif>
        <td  class="#LvarCeldaCurso#"><a href="javascript:fnNuevoEvento('#lsdateformat(LvarFecha,"YYYYMMDD")#')" class="CeldaFechaRef">
          <cfif lsdateformat(LvarFecha,"DD") eq "1">
            #lsdateformat(LvarFecha,"D MMM YY")# 
            <cfelse>
            #lsdateformat(LvarFecha,"D")# 
          </cfif>
          </a> </cfloop> <cfset LvarDW = datepart("w",LvarFin)+1> <cfloop from="#LvarDW#" to="7" index="LvarCol"> 
        </td>
        <td class="CeldaNoCurso">&nbsp;</td></cfloop></td></tr>
    </table>
	</cfoutput>
	  </td>
      <td valign="top" class="TxtNormal" style="background-color: #E6E6E6;"> 
	  <cfif form.hdnTipoOperacion eq "">
          <cfquery datasource="Educativo" name="qryMateria">
          select EVTcodigo, m.Mconsecutivo from Curso c, Materia m, Grupo g, PeriodoVigente 
          v where c.CEcodigo = #Session.CENEDCODIGO# and c.Ccodigo = #form.cboCurso# 
          and c.Mconsecutivo = m.Mconsecutivo and c.GRcodigo = g.GRcodigo and 
          m.Ncodigo = v.Ncodigo and c.PEcodigo = v.PEcodigo and c.SPEcodigo = 
          v.SPEcodigo order by c.GRcodigo,Cnombre 
          </cfquery>
          <cfquery datasource="Educativo" name="qryConceptos">
          select ec.ECcodigo as Codigo, ec.ECnombre as Descripcion from Curso 
          c, EvaluacionConceptoCurso ecc, EvaluacionConcepto ec where c.CEcodigo 
          = #Session.CENEDCODIGO# and c.Ccodigo = #form.cboCurso# and ecc.Ccodigo 
          = c.Ccodigo and ecc.PEcodigo = #form.cboPeriodo# and ec.CEcodigo = c.CEcodigo 
          and ec.ECcodigo = ecc.ECcodigo order by ec.ECorden 
          </cfquery>
          <cfset LvarTipo="">
          <cfset LvarCodigo="">
          <cfset LvarNombre="">
          <cfset LvarDescripcion="">
          <cfset LvarFecha=form.hdnFecha>
          <cfif form.hdnFecha neq "" and find("{", form.hdnFecha) gt 0>
            <cfset LvarFecha=lsDateFormat(CreateODBCDate(form.hdnFecha),"DD/MM/YYYY")>
          </cfif>
          <cfset LvarDuracion="">
          <cfset LvarOrden="">
          <cfset LvarCubierto="">
          <cfset LvarTabla=qryMateria.EVTcodigo>
          <cfset LvarFechaReal="">
          <cfset LvarRef="">
          <cfset LvarUsucodigo="">
          <div class="CeldaHdr">Agregar Nuevo Evento</div>
          <br>
          <input type="radio" name="optTipo" value="1" onClick="document.getElementById('hdnTipoOperacion').value = 'T';document.getElementById('spnEvaluacion').style.display='none';document.getElementById('spnTema').style.display='';">
          <strong><font color="#0066CC">Tema</font></strong><br>
          <input type="radio" name="optTipo" value="0" onClick="document.getElementById('hdnTipoOperacion').value = 'E'; document.getElementById('spnEvaluacion').style.display='';document.getElementById('spnTema').style.display='none';">
          <strong> <font color="#FF8000">Evaluacion:</font></strong> 
          <select class="TxtNormal" size="1" name="cboECcodigo">
            <cfoutput query="qryConceptos"> 
              <option value="#Codigo#">#Descripcion#</option>
            </cfoutput> 
          </select>
          <br>
          <cfelseif form.hdnTipoOperacion eq "T">
          <cfquery datasource="educativo" name="qryEvento">
          select CPcodigo, CPnombre, CPdescripcion, CPfecha, str(CPduracion,4,2) 
          as CPduracion, isnull(CPcubierto,'N') as CPcubierto, CPorden, MPcodigo, 
          CPusucodigo from CursoPrograma where Ccodigo = #form.cboCurso# and CPcodigo 
          = #form.hdnCodigo# 
          </cfquery>
          <cfset LvarTipo="T">
          <cfset LvarCodigo=qryEvento.CPcodigo>
          <cfset LvarNombre=qryEvento.CPnombre>
          <cfset LvarDescripcion=qryEvento.CPdescripcion>
          <cfset LvarFecha=lsdateformat(qryEvento.CPfecha,"DD/MM/YYYY")>
          <cfset LvarDuracion=qryEvento.CPduracion>
          <cfset LvarOrden=qryEvento.CPorden>
          <cfset LvarCubierto=qryEvento.CPcubierto>
          <cfset LvarTabla="">
          <cfset LvarFechaReal="">
          <cfset LvarRef=qryEvento.MPcodigo>
          <cfset LvarUsucodigo=qryEvento.CPusucodigo>
          <div class="CeldaHdr">Trabajar con Evento</div>
          <br>
          <input type="radio" name="optTipo" value="1" checked>
          <strong><font color="#0066CC">Tema</font></strong><br>
          <cfelse>
          <cfquery datasource="educativo" name="qryEvento">
          select cec.ECcomponente, cec.ECnombre, cec.ECenunciado, cec.ECplaneada, 
          str(cec.ECduracion,4,2) as ECduracion, cec.ECreal, cec.EMcomponente, 
          cec.EVTcodigo, ecc.ECcodigo as ECcodigoC, ecc.ECnombre as ECnombreC 
          from EvaluacionCurso cec, EvaluacionConcepto ecc where cec.ECcomponente 
          = #form.hdnCodigo# and cec.ECcodigo = ecc.ECcodigo 
          </cfquery>
          <cfset LvarTipo="E">
          <cfset LvarCodigo=qryEvento.ECcomponente>
          <cfset LvarNombre=qryEvento.ECnombre>
          <cfset LvarDescripcion=qryEvento.ECenunciado>
          <cfset LvarFecha=lsdateformat(qryEvento.ECplaneada,"DD/MM/YYYY")>
          <cfset LvarDuracion=qryEvento.ECduracion>
          <cfset LvarOrden="">
          <cfset LvarCubierto="">
          <cfset LvarTabla=qryEvento.EVTcodigo>
          <cfif qryEvento.ECreal eq "">
            <cfset LvarFechaReal = "">
          <cfelse>
            <cfset LvarFechaReal=lsdateformat(qryEvento.ECreal,"DD/MM/YYYY")>
          </cfif>
          <cfset LvarRef=qryEvento.EMcomponente>
          <cfset LvarUsucodigo="">
          <div class="CeldaHdr">Trabajar con Evento</div>
          <br>
          <input type="radio" name="optTipo" value="0" checked>
          <strong> <font color="#FF8000">Evaluacion:</font></strong>&nbsp; 
          <select class="TxtNormal" size="1" name="cboECcodigo">
            <cfoutput> 
              <option selected value="#qryEvento.ECcodigoC#">#qryEvento.ECnombreC#</option>
            </cfoutput> 
          </select>
          <br>
        </cfif> <cfoutput> 
          <input type="hidden" id="hdnTipoOperacion" name="hdnTipoOperacion" value="#LvarTipo#">
          <input type="hidden" id="hdnCodigo" name="hdnCodigo" value="#LvarCodigo#">
          <input type="hidden" id="hdnFecha" name="hdnFecha" value="#LvarFecha#">
          <input type="hidden" name="hdnReferencia" value="#LvarRef#">
		<br>
        <table border="0" cellpading="0" cellspacing="0" class="TxtNormal">
          <tr> 
            <td width="85">Nombre:</td>
            <td width="253"><input type="text" name="txtNombre" class="TxtNormal" size="20" value="#LvarNombre#"></td>
          </tr> 
          <tr> 
            <td colspan="2">
            <textarea name="txtDescripcion" class="TxtNormal" rows="4" cols="39">#LvarDescripcion#</textarea>
	  		</td>
          </tr>
          <tr> 
            <td>Planeado para el</td>
            <td><cf_txtFecha name="txtFecha" class="TxtNormal" value="#LvarFecha#"></td>
          </tr>
          <tr> 
            <td>Duraci&oacute;n</td>
            <td><input type="text" name="txtDuracion" class="TxtNormal" size="3" value="#LvarDuracion#" onKeyPress="return fnKeyPress(this, event);" onBlur="this.value=fnFormat(this.value,2)">
              lecciones</td>
          </tr>
          <cfif form.hdnTipoOperacion eq "" or form.hdnTipoOperacion eq "T">
          <tr id="spnTema"<cfif form.hdnTipoOperacion eq ""> style="display:none"</cfif>> 
            <td colspan="2"><input type="hidden" name="hdnUsucodigo" value="#LvarUsucodigo#">
			<table border="0" cellpading="0" cellspacing="0" class="TxtNormal">
                  <tr> 
                    <td width="86">Orden</td>
                    <td width="246"><input type="text" name="txtOrden" class="TxtNormal" size="3" value="#LvarOrden#"  onKeyPress="return fnKeyPress(this, event);" onBlur="this.value=fnFormat(this.value,0)"></td>
                  </tr>
                  <tr>
                    <td>Materia Cubierta</td>
                    <td><input type="checkbox" name="chkCubierto" class="TxtNormal" value="S" <cfif LvarCubierto neq "N" and LvarCubierto neq "">checked</cfif>></td>
                  </tr>
                </table></td>
          </tr>
		  </cfif>
          <cfif form.hdnTipoOperacion eq "" or form.hdnTipoOperacion eq "E">
            <cfquery datasource="educativo" name="qryTablas">
            select EVTcodigo as Codigo, EVTnombre as Descripcion from EvaluacionValoresTabla 
            --where CEcodigo = #Session.CENEDCODIGO# 
            </cfquery>
          <tr id="spnEvaluacion"<cfif form.hdnTipoOperacion eq ""> style="display:none"</cfif>> 
            <td colspan="2"><table border="0" cellpading="0" cellspacing="0" class="TxtNormal"><tr> 
                    <td width="85">Tipo Calificacion</td>
                    <td width="247">
                      <select class="TxtNormal" size="1" name="cboEVTcodigo">
                        <option value="null" <cfif LvarTabla eq "">selected</cfif>>[Digitar Porcentaje]</option>
                        <cfloop query="qryTablas">
                          <option value="#Codigo#" <cfif LvarTabla eq Codigo>selected</cfif>>#Descripcion#</option>
                        </cfloop>
                      </select>
                      </td>
                  </tr>
                  <tr>
                    <td>Fecha real</td>
                    <td><cf_txtFecha name="txtFechaReal" class="TxtNormal" value="#LvarFechaReal#"></td>
                  </tr>
                </table></td>
          </tr>
		  </cfif>
          <tr> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>

        <p align="center"> 
      <cfif form.hdnTipoOperacion eq ""> 
	    <input name="btnAgregar" type="submit" value="Agregar" onClick="if (!fnVerificarDatos()) return false;">
      <cfelse>
	    <input type="submit" name="btnCambiar" value="Cambiar" onClick="if (!fnVerificarDatos()) return false;">&nbsp;
	    <input type="submit" name="btnBorrar" value="Borrar" onClick="if (!fnVerificarDatos()) return false;">
      </cfif>
</p>
	  </cfoutput>
        
	  </td>
    </tr>
  </table>
	  

</form>
</body>

</html>
