<cfquery datasource="#Session.DSN#" name="rsCentroEducativo123">
	select CEnombre from CentroEducativo
 	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
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
<cfif isdefined("url.Imprimir") and not isdefined("Form.Imprimir")>
	<cfparam name="Form.Imprimir" default="#url.Imprimir#">
</cfif>
<cfquery datasource="#Session.DSN#" name="rsNivel">
	select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion from Nivel 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsGrado">
	select convert(varchar, b.Ncodigo)
	       + '|' + convert(varchar, b.Gcodigo) as Codigo, 
		   substring(b.Gdescripcion ,1,50) as Gdescripcion 
	from Nivel a, Grado b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
		and a.Ncodigo = b.Ncodigo 
 	order by a.Norden, b.Gorden
</cfquery>
<cfif isdefined("Form.Generar")>
	<cfstoredproc datasource="#Session.DSN#" procedure="sp_HORARIOGRUPO" returncode="no">
		<cfprocresult name="cons1">
		<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@empresa" value="#Session.CEcodigo#">
		<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Materia" value="#Form.Mcodigo#">
		<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Nivel" value="#Form.Ncodigo#">
		<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Grado" value="#Form.Gcodigo#">
		<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Corte" value="#Form.Corte#">
	</cfstoredproc>
<!--- 	<cfdump var="#cons1#"> --->
	<cfif #form.Mcodigo# EQ -1 >
		
		<cfquery name="rsNivelConsulta" dbtype="query">
			select distinct Ndescripcion
			from cons1
			order by MateriaNombre, Profesor 
		</cfquery>
	</cfif>	
</cfif>
<cfquery datasource="#Session.DSN#" name="rsNiveles">
	select distinct convert(varchar, a.Ncodigo) as Ncodigo, a.Ndescripcion 
	from Nivel a, Grado b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and a.Ncodigo = b.Ncodigo
    <cfif isdefined("form.Gcodigo") and #form.Gcodigo# NEQ -1>
	  	and convert(varchar,b.Gcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Gcodigo#">
	</cfif>
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsFiltroGruposCons">  
 select CentroEducativo.CEnombre, 
		Nivel.Ndescripcion + ' ' + Grado.Gdescripcion as Ndescripcion, <!---  NivelGrado,  --->
		SubPeriodoEscolar.SPEdescripcion, 
		case when Materia.Melectiva = 'S' then Curso.Cnombre when Materia.Melectiva = 'R' then Materia.Mcodigo + ' : ' + Materia.Mnombre end as MateriaNombre ,  
		case when Materia.Melectiva = 'S' then convert(varchar,Curso.Mconsecutivo) when Materia.Melectiva = 'R' then convert(varchar,Materia.Mconsecutivo) end as Mconsecutivo ,  
		Grupo.GRnombre as Grupo, 
		isnull(PersonaEducativo.Pnombre,'Sin Asignar') 
			+ ' ' + isnull(PersonaEducativo.Papellido1,' ') 
			+ ' ' + isnull(PersonaEducativo.Papellido2,' ') as Profesor, 
		substring('LKMJVSD',convert(integer,HorarioGuia.HRdia)+1,1) as HDia, 
		 HorarioTipo.Hnombre + ' : ' +  Horario.Hbloquenombre as Bloque, 
		Horario.Hentrada, 
		Horario.Hsalida, 
		Recurso.Rcodigo as Aula ,
		convert(varchar,Grupo.GRcodigo) as GRcodigo, 
		convert(varchar,Grado.Gcodigo) as Gcodigo, 
		Nivel.Norden as Norden,
		Grado.Gorden as Gorden
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
		CentroEducativo 
	where Nivel.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
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
		
	order by Materia.Mnombre, Grupo.GRnombre, HorarioGuia.HRdia, Horario.Hentrada,Aula 
	
	<cfquery datasource="#Session.DSN#" name="rsFiltroGruposCons">  
 select CentroEducativo.CEnombre, 
		Nivel.Ndescripcion + ' ' + Grado.Gdescripcion as Ndescripcion, <!---  NivelGrado,  --->
		SubPeriodoEscolar.SPEdescripcion, 
		case when Materia.Melectiva = 'S' then Curso.Cnombre when Materia.Melectiva = 'R' then Materia.Mcodigo + ' : ' + Materia.Mnombre end as MateriaNombre ,  
		case when Materia.Melectiva = 'S' then convert(varchar,Curso.Mconsecutivo) when Materia.Melectiva = 'R' then convert(varchar,Materia.Mconsecutivo) end as Mconsecutivo ,  
		Grupo.GRnombre as Grupo, 
		isnull(PersonaEducativo.Pnombre,'Sin Asignar') 
			+ ' ' + isnull(PersonaEducativo.Papellido1,' ') 
			+ ' ' + isnull(PersonaEducativo.Papellido2,' ') as Profesor, 
		substring('LKMJVSD',convert(integer,HorarioGuia.HRdia)+1,1) as HDia, 
		 HorarioTipo.Hnombre + ' : ' +  Horario.Hbloquenombre as Bloque, 
		Horario.Hentrada, 
		Horario.Hsalida, 
		Recurso.Rcodigo as Aula ,
		convert(varchar,Grupo.GRcodigo) as GRcodigo, 
		convert(varchar,Grado.Gcodigo) as Gcodigo, 
		Nivel.Norden as Norden,
		Grado.Gorden as Gorden
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
		CentroEducativo 
	where Nivel.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
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
		
	order by Materia.Mnombre, Grupo.GRnombre, HorarioGuia.HRdia, Horario.Hentrada,Aula 
</cfquery>
<cfquery name="rsFiltroGrupos" dbtype="query">
	 select distinct Mconsecutivo , MateriaNombre
	 from rsFiltroGruposCons 
	 order by Norden, Gorden, Grupo 
</cfquery>
<cfquery name="rsNivelFiltro" dbtype="query">
	select distinct Ndescripcion
	from rsFiltroGruposCons
	 <cfif isdefined("form.Mcodigo") and "form.Mcodigo" NEQ -1>
	  	where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Mcodigo#">
	  </cfif>
	order by Norden 
</cfquery>
<!--- desde aqui la opcion de las mateias registradas en el Centro Educativo con o sin profesor--->
<cfquery name="consTodosOrden" datasource="#Session.DSN#">
	select Papellido1 + ' ' + Papellido1 + ' ' + a.Pnombre as Nombre 
   	from PersonaEducativo a, Alumnos b
	where a.CEcodigo = b.CEcodigo
	  and a.persona = b.persona
	  and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
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

		function cargarGrados(csource, ctarget, vdefault){
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
	
	 
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">

<form name="form1" method="post">
	<cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 0>
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
				<td colspan="5"  class="tituloAlterno" align="center"><strong><b><cfoutput>#rsCentroEducativo123.CEnombre#</cfoutput></b><strong></td>
			</tr>
	 	</table>
		<cfif not isdefined("Url.Mcodigo") >	
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr align="center"> 
				<td width="28%" height="20">&nbsp; </td>
			  	<td width="19%" align="right">Nivel:</td>
		        <td width="26%" align="left">&nbsp; 
					
				</td>
			  <td width="27%">&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td align="right">Grado:</td>
				<td>
					<select name="Gcodigo" id="Gcodigo" tabindex="1">
						<cfif isdefined("form.Gcodigo") and #form.Gcodigo# EQ "-1">
							<option value="-1|-1" selected>-- Todos --</option>
						<cfelse>
							<option value="-1|-1">-- Todos --</option>
						</cfif>
						<cfoutput query="rsGrado"> 
					<option value="#Codigo#">#rsGrado.Gdescripcion#</option>
						</cfoutput> 
					</select>
				</td>
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
			  <td align="left"> 
				<input type="radio"  name="corte"  value="0" <cfif isdefined("Form.corte") and Form.corte EQ 0>checked<cfelseif not isdefined("Form.corte")>checked</cfif>>
				<input name="Label_CortePMateria" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="Por Materia"  size="22" readonly=""></td>
			  <td>&nbsp;</td>
			</tr>
			<tr align="center">
			  <td height="20">&nbsp;</td>
			  <td>&nbsp;</td>
			  <td align="left"> 
				<input type="radio"  name="corte"  value="0" <cfif isdefined("Form.corte") and Form.corte EQ 0>checked<cfelseif not isdefined("Form.corte")>checked</cfif>>
          <input name="Label_CorteXAlumno" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="Por Alumno"  size="22" readonly=""> 
        </td>
			  <td>&nbsp;</td>
			</tr>
	  </table>
	 </cfif>
	</cfif>
</form>
