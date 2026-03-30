<cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
	select CEnombre from CentroEducativo
 	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
</cfquery>

<cfif isdefined("url.radioFiltro") and not isdefined("Form.radioFiltro")>
	<cfparam name="Form.radioFiltro" default="#url.radioFiltro#">
</cfif>
<cfif not isdefined("url.radioFiltro") and not isdefined("Form.radioFiltro")>
	<cfparam name="Form.radioFiltro" default="0">
</cfif>
<cfif isdefined("url.Generar") and not isdefined("Form.Generar")>
	<cfparam name="Form.Generar" default="#url.Generar#">
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("Form.Mcodigo")>
	<cfparam name="Form.Mcodigo" default="#url.Mcodigo#">
</cfif>
<cfif isdefined("url.Ncodigo") and not isdefined("Form.Ncodigo")>
	<cfparam name="Form.Ncodigo" default="#url.Ncodigo#">
</cfif>
<cfif isdefined("url.Gcodigo") and not isdefined("Form.Gcodigo")>
	<cfparam name="Form.Gcodigo" default="#url.Gcodigo#">
</cfif>
<cfif isdefined("url.Corte") and not isdefined("Form.Corte")>
	<cfparam name="Form.Corte" default="#url.Corte#">
</cfif>

<cfif isdefined("url.Imprimir") and not isdefined("Form.Imprimir")>
	<cfparam name="Form.Imprimir" default="#url.Imprimir#">
</cfif>
<cfquery datasource="#Session.Edu.DSN#" name="rsNivel">
	select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion from Nivel 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
</cfquery>
<cfquery datasource="#Session.Edu.DSN#" name="rsGrado">
	select convert(varchar, b.Ncodigo)
	       + '|' + convert(varchar, b.Gcodigo) as Codigo, 
		   substring(b.Gdescripcion ,1,50) as Gdescripcion 
	from Nivel a, Grado b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		and a.Ncodigo = b.Ncodigo 
 	order by a.Norden, b.Gorden
</cfquery>

<cfif isdefined("Form.Generar")>
	<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_HORARIOGRUPO" returncode="yes">
		<cfprocresult name="cons1">
		<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@empresa" value="#Session.Edu.CEcodigo#">
		<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Materia" value="#Form.Mcodigo#">
		<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Nivel" value="#Form.Ncodigo#">
		<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Grado" value="#Form.Gcodigo#">
		<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Corte" value="#Form.Corte#">
	</cfstoredproc>
 
	<cfif #form.Mcodigo# EQ -1 >
		<cfquery name="rsNivelConsulta" dbtype="query">
			select distinct Ndescripcion
			from cons1
			order by MateriaNombre, Profesor 
		</cfquery>
	</cfif>	
</cfif>

<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
	select distinct convert(varchar, a.Ncodigo) as Ncodigo, a.Ndescripcion 
	from Nivel a
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	order by a.Norden
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsFiltroAlumnoCons">  
select CentroEducativo.CEnombre, 
    		Nivel.Ndescripcion + ' ' + Grado.Gdescripcion as NivelGrado, 
    		SubPeriodoEscolar.SPEdescripcion, 
    		case when Materia.Melectiva = 'S' then Curso.Cnombre when Materia.Melectiva = 'R' then Materia.Mnombre end as MateriaNombre , 
    		isnull(Grupo.GRnombre,'Sin Grupo') as Grupo, 
    		ltrim(rtrim(isnull(PersonaEducativo.Papellido1,' ') 
    		+ ' ' + isnull(PersonaEducativo.Papellido2,' ')  + ' ' + isnull(PersonaEducativo.Pnombre,'Sin Asignar'))) as Profesor, 
			(isnull(PersonaEducativo.Pnombre,'1')) as SinNombre,
    		substring('LKMJVSD',convert(integer,HorarioGuia.HRdia)+1,1) as HDia, 
    		 HorarioTipo.Hnombre + ' : ' +  Horario.Hbloquenombre as Bloque, 
    		Horario.Hentrada, 
    		Horario.Hsalida, 
    		Recurso.Rcodigo as Aula ,
			convert(varchar,Grupo.GRcodigo) as GRcodigo, 
			convert(varchar,Grado.Gcodigo) as Gcodigo, 
			Nivel.Norden as Norden,
			Grado.Gorden as Gorden,
			substring(Nivel.Ndescripcion,1,50) as Ndescripcion,
			substring(Grado.Gdescripcion,1,50) as NombGrado,
			convert(varchar,Materia.Mconsecutivo) as Mconsecutivo ,
			ltrim(rtrim(isnull(PE.Papellido1,' ') 
    		+ ' ' + isnull(PE.Papellido2,' ')  + ' ' + isnull(PE.Pnombre,'Sin Curso'))) as Alumno,
			convert(varchar,PE.persona) as persona

    	from Materia, 
    		Grado, 
    		SubPeriodoEscolar, 
    		Grupo, 
    		Staff, 
    		PersonaEducativo, 
    		Curso, 
    		HorarioTipo, 
    		Nivel, 
    		HorarioGuia, Horario, 
    		Recurso, 
    		CentroEducativo , 
			PeriodoVigente, 
			PeriodoEscolar,
			AlumnoCalificacionCurso ACC,
			Alumnos,
		    PersonaEducativo PE
    	where Nivel.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and Materia.Melectiva in ('R','S')
        	and Nivel.Ncodigo = Materia.Ncodigo 
    		and Grado.Gcodigo = Materia.Gcodigo 
    		and SubPeriodoEscolar.SPEcodigo = Curso.SPEcodigo 
    		and CentroEducativo.CEcodigo = Nivel.CEcodigo 
    		and Curso.Mconsecutivo = Materia.Mconsecutivo 
    		and Curso.GRcodigo = Grupo.GRcodigo 
    		and Curso.Splaza *= Staff.Splaza 
    		and Staff.persona *= PersonaEducativo.persona 
    		and Curso.Ccodigo = HorarioGuia.Ccodigo  
    		and HorarioGuia.Hbloque = Horario.Hbloque 
    		and HorarioGuia.Hcodigo = Horario.Hcodigo 
    		and Horario.Hcodigo = HorarioTipo.Hcodigo 
    		and HorarioGuia.Rconsecutivo = Recurso.Rconsecutivo 
			and Nivel.Ncodigo = PeriodoEscolar.Ncodigo
			and Nivel.Ncodigo = PeriodoEscolar.Ncodigo
			and PeriodoEscolar.PEcodigo = SubPeriodoEscolar.PEcodigo
			and Nivel.Ncodigo = PeriodoVigente .Ncodigo
			and PeriodoEscolar.PEcodigo = PeriodoVigente .PEcodigo
			and SubPeriodoEscolar.SPEcodigo = PeriodoVigente .SPEcodigo

			and ACC.Ccodigo = Curso.Ccodigo
			and ACC.Ecodigo = Alumnos.Ecodigo
			and Alumnos.persona = PE.persona

    	order by PE.Papellido1, Materia.Mnombre, Grupo.GRnombre, HorarioGuia.HRdia, Horario.Hentrada,Aula  


</cfquery>
<cfquery datasource="#Session.Edu.DSN#" name="rsFiltroMateriasCons">  
		select distinct case when Materia.Melectiva = 'S' then Curso.Cnombre + ' ' + Grupo.GRnombre when Materia.Melectiva = 'R' then Materia.Mnombre + ' ' + Grupo.GRnombre end as MateriaNombre ,  
			case when Materia.Melectiva = 'S' then convert(varchar,Curso.Mconsecutivo) when Materia.Melectiva = 'R' then convert(varchar,Materia.Mconsecutivo) end as Mconsecutivo   
		from		
			Materia, 
    		Grado, 
    		SubPeriodoEscolar, 
    		Grupo, 
    		Staff, 
    		PersonaEducativo, 
    		Curso, 
    		HorarioTipo, 
    		Nivel, 
    		HorarioGuia, Horario, 
    		Recurso, 
    		CentroEducativo , 
			PeriodoVigente, 
			PeriodoEscolar
    	where Nivel.CEcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and Materia.Melectiva in ('R','S')
    		and Nivel.Ncodigo = Materia.Ncodigo 
    		and Grado.Gcodigo = Materia.Gcodigo 
    		and SubPeriodoEscolar.SPEcodigo = Curso.SPEcodigo 
    		and CentroEducativo.CEcodigo = Nivel.CEcodigo 
    		and Curso.Mconsecutivo = Materia.Mconsecutivo 
    		and Curso.GRcodigo = Grupo.GRcodigo 
    		and Curso.Splaza *= Staff.Splaza 
    		and Staff.persona *= PersonaEducativo.persona 
    		and Curso.Ccodigo = HorarioGuia.Ccodigo  
    		and HorarioGuia.Hbloque = Horario.Hbloque 
    		and HorarioGuia.Hcodigo = Horario.Hcodigo 
    		and Horario.Hcodigo = HorarioTipo.Hcodigo 
    		and HorarioGuia.Rconsecutivo = Recurso.Rconsecutivo 

			and Nivel.Ncodigo = PeriodoEscolar.Ncodigo

			and Nivel.Ncodigo = PeriodoEscolar.Ncodigo
			and PeriodoEscolar.PEcodigo = SubPeriodoEscolar.PEcodigo

			and Nivel.Ncodigo = PeriodoVigente .Ncodigo
			and PeriodoEscolar.PEcodigo = PeriodoVigente .PEcodigo
			and SubPeriodoEscolar.SPEcodigo = PeriodoVigente .SPEcodigo

	order by Materia.Mnombre

</cfquery>
<cfquery name="rsFiltroMaterias" dbtype="query">
	 select distinct Mconsecutivo, MateriaNombre
	 from rsFiltroMateriasCons
	 order by MateriaNombre
</cfquery>

<cfquery name="rsFiltroAlumno" dbtype="query">
	 select distinct persona, Alumno
	 from rsFiltroAlumnoCons
	 order by Alumno
</cfquery>

<!--- desde aqui la opcion de las Alumnos registradas en el Centro Educativo con o sin Grupo--->
<cfquery name="rsAlumnos" datasource="#Session.Edu.DSN#">
	select Papellido1 + ' ' + Papellido1 + ' ' + a.Pnombre as Nombre 
   	from PersonaEducativo a, Alumnos b
	where a.CEcodigo = b.CEcodigo
	  and a.persona = b.persona
	  and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
	  order by Papellido1 + ' ' + Papellido1 + ' ' + a.Pnombre
</cfquery>

<!--- hasta aqui --->
	
<style type="text/css">
		.encabReporte {
			background-color: #006699;
			font-weight: bold;
			color: #FFFFFF;
			padding-top: 5px;
			padding-bottom: 5px;
		}
		.tbline {
			border-width: 1px;
			border-style: solid;
			border-color: #CCCCCC;
		}
		.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
			border-top-color: #CCCCCC;
		}
		.bottomline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
			border-bottom-color: #CCCCCC;
		}
		.subTituloRep {
			font-weight: bold; 
			font-size: x-small; 
			background-color: #F5F5F5;
		}
	}
	</style>
<style type="text/css">
		#printerIframe {
		  position: absolute;
		  width: 0px; height: 0px;
		  border-style: none;
		  /* visibility: hidden; */
		}
		</style>
		<script type="text/javascript">
		function printURL (url) {
		  if (window.print && window.frames && window.frames.printerIframe) {
			var html = '';
			html += '<html>';
			html += '<body onload="parent.printFrame(window.frames.urlToPrint);">';
			html += '<iframe name="urlToPrint" src="' + url + '"><\/iframe>';
			html += '<\/body><\/html>';
			var ifd = window.frames.printerIframe.document;
			ifd.open();
			ifd.write(html);
			ifd.close();
		  }
		  else {
					var win = window.open('', 'printerWindow', 'width=600,height=300,resizable,scrollbars,toolbar,menubar');
					var html = '';
					html += '<html>';
					html += '<frameset rows="100%, *" ' 
						 +  'onload="opener.printFrame(window.urlToPrint);">';
					html += '<frame name="urlToPrint" src="' + url + '" \/>';
					html += '<frame src="about:blank" \/>';
					html += '<\/frameset><\/html>';
					win.document.open();
					win.document.write(html);
					win.document.close();
		  }

		}
		
		function printFrame (frame) {
		  if (frame.print) {
			frame.focus();
			frame.print();
			frame.src = "about:blank"
		  }
		}
		
	</script>
		<script language="JavaScript" type="text/javascript">
		gradostext = new Array();
		grados = new Array();
		niveles = new Array();
		

		function obtenerGrados(f) {
			for(i=0; i<f.Gcodigo.length; i++) {
				var s = f.Gcodigo.options[i].value.split("|");
				// Códigos de los detalles
				niveles[i]= s[0];
				grados[i] = s[1];
				gradostext[i] = f.Gcodigo.options[i].text;
			}
		}
		
		function cargarGrados(csource, ctarget, vdefault, t){
			// Limpiar Combo
			for (var i=ctarget.length-1; i >=0; i--) {
				ctarget.options[i]=null;
			}
			var k = csource.value;
			var j = 0;

			for (var i=0; i<grados.length; i++) {
				if (niveles[i] == k) {
					nuevaOpcion = new Option(gradostext[i],grados[i]);
					ctarget.options[j]=nuevaOpcion;
					if (vdefault != null && grados[i] == vdefault) {
						ctarget.selectedIndex = j;
					}
					j++;
				}
			}
		}
	</script>
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">

 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
/*	function OcultaOpt(f) {
	//alert(f.radiofiltro[0].checked);
		//f.Imprimir.style.visibility = 'hidden';
		if (new Number(f.Mcodigo.value) ==-1 ) {      
			f.Label_PxGrupo2.style.visibility = 'visible';
			f.Label_Pcontinua2.style.visibility = 'visible';
			f.radiofiltro[0].style.visibility = 'visible';
			f.radiofiltro[1].style.visibility = 'visible';
			
		} else {    
			f.Label_PxGrupo2.style.visibility = 'hidden';
			f.Label_Pcontinua.style.visibility = 'hidden';
			f.radiofiltro[0].style.visibility = 'hidden';
			f.radiofiltro[1].style.visibility = 'hidden';
			//alert(f.radiofiltro[0].checked);
			//alert(f.radiofiltro[1].checked);
			f.radiofiltro[0].checked = 1;
			f.radiofiltro[1].checked = 0;
			
		}
	}
	*/  

/*	function VerImprimir(f) {
		f.Imprimir.style.visibility = 'visible';
	}
*/


</script>
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">
<form name="form1" method="post">
	<cfif isdefined("form.radiofiltro") <!--- and #form.radiofiltro# EQ 0 --->>
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<cfif isdefined("Url.radioFiltro")>
				<cfoutput> 
				<tr> 
					<td colspan="3" align="left" nowrap><strong>Servicios Digitales del Ciudadano</strong></td>
					<td colspan="2" align="right" nowrap>Fecha: #LSdateFormat(Now(),'dd/MM/YY')#</td>
				</tr>
				<tr> 
					<td colspan="3" align="left" nowrap> <strong>www.migestion.net</strong> </td>
					<td colspan="2" align="right" nowrap>Hora:&nbsp; #TimeFormat(Now(),'hh:mm:ss')#</td>
				</tr>
				</cfoutput> 
				<tr>
					<td colspan="5" class="tituloAlterno" align="center">
						<strong>
							<cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 1>
								<b>Listado de Horarios<br>	(En orden Alfabetico)</b> 
							<cfelse>
								<b>Listado de Horarios por Grupo</b>
							</cfif>
						</strong>
					</td>
				</tr> 

			</cfif>
			<tr>
				<td colspan="5"  class="tituloAlterno" align="center"><strong><b><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></b><strong></td>
			</tr>
	 	</table>
		<cfif not isdefined("Url.Mcodigo") > 
	<cfif not isdefined("Url.Mcodigo") >	
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr align="center"> 
        <td width="28%" height="20">&nbsp; </td>
        <td width="19%" align="right">Nivel:</td>
        <td width="26%" align="left"> <select name="Ncodigo" id="Ncodigo" onchange="javascript: cargarGrados(this, this.form.Gcodigo, '<cfif isdefined("Form.Gcodigo")><cfoutput>#Form.Gcodigo#</cfoutput></cfif>', true); ">
            <cfif isdefined("form.Ncodigo") and #form.Ncodigo# EQ "-1">
              <option value="-1" selected>-- Todos --</option>
              <cfelse>
              <option value="-1">-- Todos --</option>
            </cfif>
            <cfoutput query="rsNiveles"> 
              <option value="#rsNiveles.Ncodigo#" >#rsNiveles.Ndescripcion#</option>
            </cfoutput> </select> </td>
        <td width="27%">&nbsp;</td>
      </tr>
      <tr > 
        <td>&nbsp;</td>
        <td align="right">Grado:</td>
        <td> <select name="Gcodigo" id="Gcodigo" tabindex="1">
            <cfif isdefined("form.Gcodigo") and #form.Gcodigo# EQ "-1">
              <option value="-1|-1" selected>-- Todos --</option>
              <cfelse>
              <option value="-1|-1">-- Todos --</option>
            </cfif>
            <cfoutput query="rsGrado"> 
              <option value="#Codigo#">#rsGrado.Gdescripcion#</option>
            </cfoutput> </select> </td>
        <td>&nbsp;</td>
      </tr>
      <tr align="center"> 
        <td height="20">&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr align="center"> 
        <td height="20">&nbsp;</td>
        <td align="right">Corte:</td>
        <td align="left"> <input type="radio"  name="corte"  value="0" <cfif isdefined("Form.corte") and Form.corte EQ 0>checked<cfelseif not isdefined("Form.corte")>checked</cfif>> 
          <input name="Label_CortePMateria" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="Por Materia"  size="22" readonly=""></td>
        <td>&nbsp;</td>
      </tr>
      <tr align="center">
        <td height="20">&nbsp;</td>
        <td>&nbsp;</td>
        <td align="left"><input type="radio"  name="corte"  value="1" <cfif isdefined("Form.corte") and Form.corte EQ 1>checked<cfelseif not isdefined("Form.corte")>checked</cfif>>
          <input name="Label_CorteXAlumno2" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="Por Alumno"  size="22" readonly=""></td>
        <td>&nbsp;</td>
      </tr>
      <tr align="center"> 
        <td height="20">&nbsp;</td>
        <td>&nbsp;</td>
        <td align="left"> <input type="radio"  name="corte"  value="2" <cfif isdefined("Form.corte") and Form.corte EQ 2>checked<cfelseif not isdefined("Form.corte")>checked</cfif>> 
          <input name="Label_CorteXGrupo" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="Por  Grupo "  size="22" readonly=""> 
        </td>
        <td>&nbsp;</td>
      </tr>
    </table>
	 </cfif>
			
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td  align="right">&nbsp;</td>
      <td  align="right" valign="middle" nowrap><input name="Label_Grupo" style="text-align:left" type="text" class="cajasinborde" tabindex="-1" value="Materia:"  size="22" readonly=""></td>
      <td align="right" valign="middle">&nbsp;</td>
      <td  align="right">&nbsp;</td>
    </tr>
    <tr> 
      <td  align="right">&nbsp;</td>
      <td  align="right" valign="middle" nowrap>&nbsp; </td>
      <td align="left" valign="middle"> 

	    <select name="Mcodigo" id="Mcodigo" >
          <cfif isdefined("form.Mcodigo") and #form.Mcodigo# EQ "-1">
            <option value="-1" selected>-- Todos --</option>
            <cfelse>
            <option value="-1">-- Todos --</option>
          </cfif>
		  
          <cfoutput query="rsFiltroMaterias"> 
            <cfif isdefined("form.Mcodigo") and #form.Mcodigo# EQ #rsFiltroMaterias.Mconsecutivo#>
              <option value="#rsFiltroMaterias.Mconsecutivo#" selected>#rsFiltroMaterias.MateriaNombre#</option>
              <cfelse>
              <option value="#rsFiltroMaterias.Mconsecutivo#">#rsFiltroMaterias.MateriaNombre#</option>
            </cfif>
          </cfoutput> </select></td>
      <td  align="right">&nbsp;</td>
    </tr>
    <tr> 
      <td width="28%"  align="right"> 
        <!--- <input type="radio"  onClick="javascript: OcultaGrupo(this.form);" name="radiofiltro"  value="0" <cfif isdefined("Form.radiofiltro") and Form.radiofiltro EQ 0>checked<cfelseif not isdefined("Form.radiofiltro")>checked</cfif>> --->
      </td>
      <td width="19%"  align="left" valign="middle" nowrap>&nbsp; </td>
      <td width="26%" align="right" valign="middle">&nbsp; </td>
      <td width="27%"  align="left" nowrap> 
        <input type="radio"  name="radiofiltro"  value="0" <cfif isdefined("Form.radiofiltro") and Form.radiofiltro EQ 0>checked<cfelseif not isdefined("Form.radiofiltro")>checked</cfif>>
        <input name="Label_PxGrupo2" style="text-align:left" type="text" class="cajasinborde" tabindex="-1" value="Separa página por materia / alumno"  size="38" readonly="">
      </td>
    </tr>
    <tr> 
      <td align="right"> 
      </td>
      <td align="left" valign="middle" nowrap>&nbsp; </td>
	  <td align="left" valign="middle" nowrap>&nbsp; </td>
      <td align="left" valign="middle" nowrap> 
        <input type="radio" name="radiofiltro"  value="1" <cfif isdefined("Form.radiofiltro") and Form.radiofiltro EQ 1>checked</cfif>>
        <input name="Label_Pcontinua2" style="text-align:left" type="text" class="cajasinborde" tabindex="-1" value="Todos sin separar página "  size="35" readonly="">
      </td>
    </tr>
    <tr> 
      <td colspan="5"  align="center"> </td>
    </tr>
    <tr> 
      <cfif not isdefined("Url.Mcodigo") >
        <td colspan="5" align="center"> 
          <input name="Generar" type="submit" value="Generar"  > <cfoutput> 
            <cfif isdefined("form.Generar")>
              <cfif #form.radiofiltro# EQ 0>
                <input type="button"  name="Imprimir" value="Imprimir" onClick="javascript:printURL('ListadoHorariosGrupoimpr.cfm?radioFiltro=#Form.radioFiltro#&Generar=#form.Generar#&Mcodigo=#form.Mcodigo#&Ncodigo=#form.Ncodigo#&Gcodigo=#form.Gcodigo#&Corte=#form.Corte#');">
                <cfelse>
                <input type="button"  name="Imprimir" value="Imprimir" onClick="javascript:printURL('ListadoHorariosGrupoimpr.cfm?radioFiltro=#Form.radioFiltro#&Generar=#form.Generar#&Mcodigo=-1&Ncodigo=#form.Ncodigo#&Gcodigo=#form.Gcodigo#&Corte=#form.Corte#');">
              </cfif>
            </cfif>
          </cfoutput> </td>
      </cfif>
    </tr></cfif></cfif>
  </table> 
<cfif isdefined("form.Corte") and form.Corte EQ 0>		
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
    <cfif isdefined("form.radiofiltro")<!---  and #form.radiofiltro# EQ 0 --->>
      <cfif isdefined("form.Generar") and len(trim(form.Generar)) NEQ 0 >
        <cfif cons1.recordCount GT 0 >
		 <!--- <tr>  --->
       		<table width="100%" border="0" cellspacing="0">
			<cfif cons1.Grupo NEQ "Sin Grupo" >
				<cfoutput> 
					<cfloop query="rsFiltroMaterias">
						<cfset Materia = rsFiltroMaterias.Mconsecutivo>
							<cfquery name="rsMateriasConsulta" dbtype="query">
								select * from cons1
								where  Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_char" value="#Materia#">
								order by MateriaNombre
							</cfquery>
							<cfset MateriaCorte = "">
							<cfset Prof = "">
							<cfif rsMateriasConsulta.RecordCount neq 0>
								<cfif rsMateriasConsulta.MateriaNombre NEQ MateriaCorte>
									<cfset MateriaCorte = rsMateriasConsulta.MateriaNombre>
									<cfset Prof = rsMateriasConsulta.Profesor>
									<tr> 
										<td  colspan="5" align="left">&nbsp;</td>
									</tr> 
									<tr> 
										<cfif #rsMateriasConsulta.SinNombre# EQ 1>
											<td  colspan="5" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold"><strong><font color="##FF0000">Materia: #MateriaCorte# Profesor: #Prof#</font></strong></td>
										<cfelse>
											<td  colspan="5" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold"><strong><font color="##9999FF">Materia: #MateriaCorte# Profesor: #Prof#</font></strong></td>
										</cfif>		
									</tr> 
								</cfif>
								<tr> 
									<td width="10%" align="left" nowrap class="subTitulo" style="padding-left: 10px">&nbsp; &nbsp; Día</td>
									<td width="35%" nowrap class="subTitulo">Bloque</td>
									<td width="20%" align="right" nowrap class="subTitulo">Entrada</td>
									<td width="20%" align="right" nowrap class="subTitulo">Salida</td>
									<td width="15%" align="right" nowrap class="subTitulo">Aula</td>
								</tr>
							</cfif>
							<cfloop query="rsMateriasConsulta">
									<tr> 
										<td nowrap align="center">#rsMateriasConsulta.HDia#</td>
										<td align="left" >#rsMateriasConsulta.Bloque#</td>
										<td align="right" >#LSCurrencyFormat(rsMateriasConsulta.Hentrada,"none")#</td>
										<td align="right" >#LSCurrencyFormat(rsMateriasConsulta.Hsalida,"none")#</td>
										<td align="right" >#rsMateriasConsulta.Aula#</td>
									</tr>
							</cfloop>
							
							<cfif isdefined("Url.Mcodigo") and #form.radiofiltro# EQ 0>
								 <tr class="pageEnd">
									<td height="20" colspan="5" valign="top">&nbsp;</td>
								</tr>
								<cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 0>
									<cfif isdefined("Url.radioFiltro")>
										<tr>
											<td align="left" nowrap><strong>Servicios Digitales del Ciudadano</strong></td>
											<td colspan="4" align="right" nowrap>Fecha: #LSdateFormat(Now(),'dd/MM/YY')#</td>
										</tr>
										<tr>
											<td align="left" nowrap> <strong>www.migestion.net</strong> </td>
											<td colspan="4" align="right" nowrap>Hora:&nbsp; #TimeFormat(Now(),'hh:mm:ss')#</td>
										</tr>
									</cfif>
									<tr>
										<td colspan="5" class="tituloAlterno" align="center">
											<strong>
												<cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 1>
													<b>Listado de Horarios <br>	(En orden Alfabetico)</b> 
												<cfelse>
													<b>Listado de Horarios <br>
													<cfif #form.Corte# EQ 0>
														(Corte por Materia)
													<cfelseif #form.Corte# EQ 1>
														(Corte por Alumno)
													<cfelse>
														(Corte por Grupo)
													</cfif>
													</b>
												</cfif>
											</strong>
										</td>
									</tr>														
								</cfif>
								<tr>
									<td colspan="5"  class="tituloAlterno" align="center"><strong><b>#rsCentroEducativo.CEnombre#</b><strong></td>
								</tr>
							</cfif>
					</cfloop>
				</cfoutput> 
				<tr> 
					<td colspan="5">&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="5" align="center"> ------------------ Fin del Reporte ------------------ </td>
				</tr>
			</cfif>
	<!--- 	</tr>  --->	
		<cfelse>	
				<tr> 
					<td colspan="5" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">El Grupo no tiene Horarios Definidos</td>
				</tr>
				<tr> 
					<td width="10%" align="left" nowrap class="subTitulo" style="padding-left: 10px">&nbsp; &nbsp; Día</td>
					<td width="35%" nowrap class="subTitulo">Bloque</td>
					
					<td width="20%" align="right" nowrap class="subTitulo">Entrada</td>
					<td width="20%" align="right" nowrap class="subTitulo">Salida</td>
					<td width="15%" align="right" nowrap class="subTitulo">Aula</td>
				</tr>
			<tr> 
				<td colspan="5" align="center"> ------------------ 1 - No existen 
				  Horarios para la consulta solicitada------------------ </td>
			</tr>
		</cfif>
		</table>
	</cfif>
	</cfif>
	</table>
</cfif>

<!--- Desde aqui es para alumnos --->
<cfif isdefined("form.Corte") and form.Corte EQ 1>		

  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">   
    <cfif isdefined("form.radiofiltro")<!---  and #form.radiofiltro# EQ 0 --->>
      <cfif isdefined("form.Generar") and len(trim(form.Generar)) NEQ 0 >
        <cfif cons1.recordCount GT 0 >
          <tr> 
			<table width="100%" border="0" cellspacing="0">
			<cfif rsFiltroMaterias.recordCount GT 0 and cons1.Grupo NEQ "Sin Grupo" >
				<cfoutput> 
					<cfloop query="rsFiltroAlumno">
						<cfset persona = rsFiltroAlumno.persona>

						<cfquery name="rsAlumnoConsulta" dbtype="query">
							select distinct Alumno 
							from cons1 
							where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#persona#">
							order by Alumno
						</cfquery>
						<cfquery name="rsMateriaConsulta" dbtype="query">
							select distinct MateriaNombre from cons1 
							where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#persona#">
							order by MateriaNombre
						</cfquery>
						<cfloop query="rsAlumnoConsulta">
							<cfset NombreAlumno = rsAlumnoConsulta.Alumno>
							
							<cfquery name="rsConsulta" dbtype="query">
								select * from cons1 
								where <!--- Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_char" value="#Materia#">
								  and ---> Alumno = <cfqueryparam cfsqltype="cf_sql_char" value="#NombreAlumno#">
							</cfquery>
							<tr> 
								<td colspan="5" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">Alumno: #NombreAlumno# - Nivel + Grado:	#rsConsulta.NivelGrado# </td>
							</tr>
							<tr> 
								<td width="10%" align="left" nowrap class="subTitulo" style="padding-left: 10px">&nbsp; &nbsp; Día</td>
								<td width="35%" nowrap class="subTitulo">Bloque</td>
								
								<td width="20%" align="right" nowrap class="subTitulo">Entrada</td>
								<td width="20%" align="right" nowrap class="subTitulo">Salida</td>
								<td width="15%" align="right" nowrap class="subTitulo">Aula</td>
							</tr>
							<cfset MateriaCorte = "">
							<cfset Prof = "">
							<cfloop query="rsConsulta">
								<cfif rsConsulta.MateriaNombre NEQ MateriaCorte>
									<cfset MateriaCorte = rsConsulta.MateriaNombre>
									<cfset Prof = rsConsulta.Profesor>
									<tr> 
										<cfif #rsConsulta.SinNombre# EQ 1>
											<td  colspan="5" align="left"><strong><font color="##FF0000">&nbsp; &nbsp; &nbsp; Materia: #MateriaCorte# Profesor: #Prof#</font></strong></td>
										<cfelse>
											<td  colspan="5" align="left"><strong><font color="##9999FF">&nbsp; &nbsp; &nbsp; Materia: #MateriaCorte# Profesor: #Prof#</font></strong></td>
										</cfif>		
									</tr> 
								</cfif>
									<tr> 
										<td nowrap align="center">#rsConsulta.HDia#</td>
										<td align="left" >#rsConsulta.Bloque#</td>
										<td align="right" >#LSCurrencyFormat(rsConsulta.Hentrada,"none")#</td>
										<td align="right" >#LSCurrencyFormat(rsConsulta.Hsalida,"none")#</td>
										<td align="right" >#rsConsulta.Aula#</td>
									</tr>
							</cfloop>
							<tr> 
								<td  colspan="5" class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
							</tr>
							<tr> 
								<td  colspan="5" align="left">&nbsp;</td>
							</tr> 
							<cfif isdefined("Url.Mcodigo") and #form.radiofiltro# EQ 0>
								 <tr class="pageEnd">
									<td height="20" colspan="5" valign="top">&nbsp;</td>
								</tr>
								<cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 0>
									<cfif isdefined("Url.radioFiltro")>
										<tr>
											<td align="left" nowrap><strong>Servicios Digitales del Ciudadano</strong></td>
											<td colspan="4" align="right" nowrap>Fecha: #LSdateFormat(Now(),'dd/MM/YY')#</td>
										</tr>
										<tr>
											<td align="left" nowrap> <strong>www.migestion.net</strong> </td>
											<td colspan="4" align="right" nowrap>Hora:&nbsp; #TimeFormat(Now(),'hh:mm:ss')#</td>
										</tr>
									</cfif>
									<tr>
										<td colspan="5" class="tituloAlterno" align="center">
											<strong>
												<cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 1>
													<b>Listado de Horarios <br>	(En orden Alfabetico)</b> 
												<cfelse>
													<b>Listado de Horarios <br>
													<cfif #form.Corte# EQ 0>
														(Corte por Materia)
													<cfelseif #form.Corte# EQ 1>
														(Corte por Alumno)
													<cfelse>
														(Corte por Grupo)
													</cfif>
													</b>
												</cfif>
											</strong>
										</td>
									</tr>														
								</cfif>
								<tr>
									<td colspan="5"  class="tituloAlterno" align="center"><strong><b>#rsCentroEducativo.CEnombre#</b><strong></td>
								</tr>
							</cfif>
						</cfloop>
					</cfloop>
				</cfoutput> 
				<tr> 
					<td colspan="5">&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="5" align="center"> ------------------ Fin del Reporte ------------------ </td>
				</tr>
			</cfif>
		
		</tr>
			<cfelse>	
				<tr> 
					<td colspan="5" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">La Materia no tiene Horarios Definidos</td>
				</tr>
				<tr> 
					<td width="10%" align="left" nowrap class="subTitulo" style="padding-left: 10px">&nbsp; &nbsp; Día</td>
					<td width="35%" nowrap class="subTitulo">Bloque</td>
					
					<td width="20%" align="right" nowrap class="subTitulo">Entrada</td>
					<td width="20%" align="right" nowrap class="subTitulo">Salida</td>
					<td width="15%" align="right" nowrap class="subTitulo">Aula</td>
				</tr>
			<tr> 
				<td colspan="5" align="center"> ------------------ 1 - No existen 
				  Horarios para la Materia solicitada------------------ </td>
			</tr>
			</cfif> 
		</table>
	</cfif>
  </cfif>
  </table>
</cfif>
<!--- Hasta aqui --->
<cfif isdefined("form.Corte") and form.corte EQ 2>
 <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">   
    <cfif isdefined("form.radiofiltro")<!---  and #form.radiofiltro# EQ 0 --->>
      <cfif isdefined("form.Generar") and len(trim(form.Generar)) NEQ 0 >
        <cfif cons1.recordCount GT 0 >
          <tr> 
			<table width="100%" border="0" cellspacing="0">
			<cfif rsNiveles.recordCount GT 0 and cons1.Grupo NEQ "Sin Grupo" >
				<cfoutput> 
					<cfset MateriaCorte = "">
					<cfset Prof = "">
					<cfset GrupoNombre = "">
					<cfset GradoNombre = "">
					<cfset NumHora = 0>
					<cfloop query="cons1">
						<cfset Nivel = cons1.Ndescripcion>
						<cfset GRcod = cons1.GRcodigo>
						<!--- <cfquery name="rsGruposConsulta" dbtype="query">
							select distinct Grupo, NombGrado 
							from cons1 
							where Ndescripcion =  <cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
							and GRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#GRcod#">
							order by Norden, Gorden, Grupo 
						</cfquery> --->
					<!--- 	<cfquery name="rsGradosConsulta" dbtype="query">
							select distinct NombGrado from cons1 where Ndescripcion 
							= 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
							order by Norden, Gorden, Grupo 
						</cfquery> --->
						
						<!--- <cfloop query="rsGruposConsulta"> --->
							<cfset NumHora = NumHora + 1>
							<cfif cons1.Grupo NEQ GrupoNombre >
								<cfset GrupoNombre = cons1.Grupo>
								<cfset GradoNombre  = cons1.NombGrado>
								<cfif  cons1.CurrentRow neq 1>
									<tr> 
										<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" colspan="2">Total Horarios del Grupo: #GrupoNombre#</td>
										<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">#NumHora#</td>
										<cfset NumHora = 0>
										<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
										<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
										<!--- <cfif isdefined("form.Imprimir") and isdefined("form.radiofiltro") and  #form.radiofiltro# NEQ 1> --->
									</tr>
								</cfif>
								<tr class="subTitulo"> 
									<td class="subTitulo" colspan="5" align="left">&nbsp;</td>
								</tr> 
								<tr class="subTitulo"> 
									<td colspan="5" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">#Nivel# 
									: #GradoNombre# : #GrupoNombre#</td>
								</tr>
								<tr class="subTitulo"> 
									<td width="10%" align="left" nowrap class="subTitulo" style="padding-left: 10px">&nbsp; &nbsp; Día</td>
									<td width="35%" nowrap class="subTitulo">Bloque</td>
									
									<td width="20%" align="right" nowrap class="subTitulo">Entrada</td>
									<td width="20%" align="right" nowrap class="subTitulo">Salida</td>
									<td width="15%" align="right" nowrap class="subTitulo">Aula</td>
								</tr>
								
							</cfif>
<!--- 						 	<cfquery name="rsConsulta" dbtype="query">
								select * from cons1 where Ndescripcion = 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
								and Grupo = 
								<cfqueryparam cfsqltype="cf_sql_char" value="#GrupoNombre#">
							</cfquery>  --->
															
							<!---  <cfloop query="rsConsulta">  --->
								<cfif cons1.MateriaNombre NEQ MateriaCorte>
									<cfset MateriaCorte = cons1.MateriaNombre>
									<cfset Prof = cons1.Profesor>
									<tr> 
										<cfif #cons1.SinNombre# EQ 1>
											<cfif isdefined("Url.radioFiltro")> 
												<td  colspan="5" align="left"><strong>Materia: #MateriaCorte# Profesor: #Prof#</strong></td>
											<cfelse>
												<td  colspan="5" align="left"><strong><font color="##FF0000">Materia: #MateriaCorte# Profesor: #Prof#</font></strong></td>
											</cfif>
										<cfelse>
											<td  colspan="5" align="left"><strong>Materia: #MateriaCorte# Profesor: #Prof#</strong></td>
										</cfif>		
									</tr> 
								</cfif>
									<tr> 
										<td nowrap align="center">#cons1.HDia#</td>
										<td align="left" >#cons1.Bloque#</td>
										<td align="right" >#LSCurrencyFormat(cons1.Hentrada,"none")#</td>
										<td align="right" >#LSCurrencyFormat(cons1.Hsalida,"none")#</td>
										<td align="right" >#cons1.Aula#</td>
									</tr>
							<!---  </cfloop>  --->
							<tr> 
								<td  colspan="5" align="left">&nbsp;</td>
							</tr> 
							<cfif isdefined("Url.Mcodigo") and #form.radiofiltro# EQ 0>
								 <tr class="pageEnd">
									<td height="20" colspan="5" valign="top">&nbsp;</td>
								</tr>
								<!--- <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0"> --->
								<cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 0>
									<cfif isdefined("Url.radioFiltro")>
										<tr>
											<td align="left" nowrap><strong>Servicios Digitales del Ciudadano</strong></td>
											<td colspan="4" align="right" nowrap>Fecha: #LSdateFormat(Now(),'dd/MM/YY')#</td>
										</tr>
										<tr>
											<td align="left" nowrap> <strong>www.migestion.net</strong> </td>
											<td colspan="4" align="right" nowrap>Hora:&nbsp; #TimeFormat(Now(),'hh:mm:ss')#</td>
										</tr>
									</cfif>
									<tr>
										<td colspan="5" class="tituloAlterno" align="center">
											<strong>
												<cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 1>
													<b>Listado de Horarios <br>	(En orden Alfabetico)</b> 
												<cfelse>
													<b>Listado de Horarios <br>
													<cfif #form.Corte# EQ 0>
														(Corte por Materia)
													<cfelseif #form.Corte# EQ 1>
														(Corte por Alumno)
													<cfelse>
														(Corte por Grupo)
													</cfif>
													</b>
												</cfif>
											</strong>
										</td>
									</tr>														
								</cfif>
								<tr>
									<td colspan="5"  class="tituloAlterno" align="center"><strong><b>#rsCentroEducativo.CEnombre#</b><strong></td>
								</tr>
							</cfif>
						<!--- </cfloop> --->
					</cfloop>
					<tr> 
						<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" colspan="2">Total Horarios </td>
						<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">#Cons1.RecordCount#</td>
						<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
						<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
						<!--- <cfif isdefined("form.Imprimir") and isdefined("form.radiofiltro") and  #form.radiofiltro# NEQ 1> --->
					</tr>
				</cfoutput> 
				<tr> 
					<td colspan="5">&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="5" align="center"> ------------------ Fin del Reporte ------------------ </td>
				</tr>
			</cfif>
		
		</tr>
		<cfelse>	
				<tr> 
					<td colspan="5" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">La Materia no tiene Horarios Definidos</td>
				</tr>
				<tr> 
					<td width="10%" align="left" nowrap class="subTitulo" style="padding-left: 10px">&nbsp; &nbsp; Día</td>
					<td width="35%" nowrap class="subTitulo">Bloque</td>
					
					<td width="20%" align="right" nowrap class="subTitulo">Entrada</td>
					<td width="20%" align="right" nowrap class="subTitulo">Salida</td>
					<td width="15%" align="right" nowrap class="subTitulo">Aula</td>
				</tr>
			<tr> 
				<td colspan="5" align="center"> ------------------ 1 - No existen 
				  Horarios para la Materia solicitada------------------ </td>
			</tr>
		</cfif> 
	</cfif>
  </cfif>
  </table>

</cfif>


</form>
<!--- <cfif not isdefined("Url.Mcodigo") >
	<script>
		OcultaOpt(form1); 
	</script>
</cfif> --->
<cfif not isdefined("Url.Corte")>
	<script language="JavaScript" type="text/javascript" >
	//------------------------------------------------------------------------------------------						
	//Para los grados
		obtenerGrados(document.form1);
		cargarGrados(document.form1.Ncodigo, document.form1.Gcodigo, '', true);
	//---------------------------------------
	</script>
</cfif>