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
<cfif isdefined("url.Grupo") and not isdefined("Form.Grupo")>
	<cfparam name="Form.Grupo" default="#url.Grupo#">
</cfif>
<cfif isdefined("url.Imprimir") and not isdefined("Form.Imprimir")>
	<cfparam name="Form.Imprimir" default="#url.Imprimir#">
</cfif>
<cfif isdefined("Form.Generar")>
	<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_MATERIAGRUPO" returncode="yes">
		<cfprocresult name="cons1">
		<cfprocparam cfsqltype="cf_sql_integer" dbvarname="@empresa" value="#Session.Edu.CEcodigo#">
		<cfprocparam cfsqltype="cf_sql_integer" dbvarname="@Grupo" value="#Form.Grupo#">
	</cfstoredproc>
	
	<cfif #form.Grupo# EQ -1 >
		<cfquery name="rsGrupos" dbtype="query">
			select distinct Nombre, Grupo, Ndescripcion
			from cons1 
			order by Norden, Gorden
		</cfquery>
		
		<cfquery name="rsNivelConsulta" dbtype="query">
			select distinct Ndescripcion
			from cons1
			order by Norden 
		</cfquery>
	</cfif>	
</cfif>

<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
	select distinct convert(varchar, a.Ncodigo) as Ncodigo, a.Ndescripcion 
	from Nivel a, Grupo b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  and a.Ncodigo = b.Ncodigo
    <cfif isdefined("form.Grupo") and #form.Grupo# NEQ -1>
	  	and convert(varchar,b.GRcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Grupo#">
	</cfif>
	order by a.Norden
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsFiltroGruposCons">  
		select a.GRnombre as Grupo, 
		b.Ndescripcion as Ndescripcion, 
		Norden, 
		Gorden, 
		convert(varchar,a.GRcodigo) as GRcodigo,
		substring(c.Gdescripcion,1,50) as NombGrado
		from Grupo a, Nivel b, Grado c, PeriodoVigente d, Materia e, Curso f, Staff g, PersonaEducativo h
    	where b.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
<!--- 		<cfif isdefined("form.Grupo") and #form.Grupo# NEQ -1>
	  		and convert(varchar,a.GRcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Grupo#">
	  	</cfif>
 --->      	and e.Melectiva = 'R'
        	and a.Ncodigo   = b.Ncodigo
        	and b.Ncodigo   = c.Ncodigo
        	and a.Gcodigo   = c.Gcodigo
        	and c.Ncodigo   = d.Ncodigo
        	and d.Ncodigo   = e.Ncodigo
        	and c.Gcodigo   = e.Gcodigo
        	and e.Mconsecutivo = f.Mconsecutivo
        	and b.CEcodigo  = f.CEcodigo
        	and a.GRcodigo  = f.GRcodigo
        	and d.PEcodigo  = f.PEcodigo
        	and d.SPEcodigo = f.SPEcodigo
        	and f.CEcodigo  *= g.CEcodigo
        	and f.Splaza    *= g.Splaza
        	and g.CEcodigo  *= h.CEcodigo
        	and g.persona   *= h.persona
    	order by b.Norden, c.Gorden
	 
	 
</cfquery>
<cfquery name="rsFiltroGrupos" dbtype="query">
	 select distinct GRcodigo , Grupo
	 from rsFiltroGruposCons 
	 order by Norden, Gorden, Grupo 
</cfquery>
<cfquery name="rsNivelFiltro" dbtype="query">
	select distinct Ndescripcion, GRcodigo
	from rsFiltroGruposCons
	 <cfif isdefined("form.Grupo") and "form.Grupo" NEQ -1>
	  	where Grupo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Grupo#">
	  </cfif>
	order by Norden 
</cfquery>
<!--- desde aqui la opcion de las mateias registradas en el Centro Educativo con o sin profesor--->
<cfquery name="consTodosOrden" datasource="#Session.Edu.DSN#">
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
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">

 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
/*	function OcultaGrupo(f) {
	//alert(f.radiofiltro[0].checked);
		if (f.radiofiltro[0].checked == 0) {      
			f.Grupo.style.visibility = 'hidden';
			f.Label_Grupo.style.visibility = 'hidden';
		} else {    
			f.Grupo.style.visibility = 'visible';
			f.Label_Grupo.style.visibility = 'visible';
		}
	}  
*/
	function OcultaOpt(f) {
	//alert(f.radiofiltro[0].checked);
		//f.Imprimir.style.visibility = 'hidden';
		if (new Number(f.Grupo.value) ==-1 ) {      
			f.Label_PxGrupo.style.visibility = 'visible';
			f.Label_Pcontinua.style.visibility = 'visible';
			f.radiofiltro[0].style.visibility = 'visible';
			f.radiofiltro[1].style.visibility = 'visible';
			
		} else {    
			f.Label_PxGrupo.style.visibility = 'hidden';
			f.Label_Pcontinua.style.visibility = 'hidden';
			f.radiofiltro[0].style.visibility = 'hidden';
			f.radiofiltro[1].style.visibility = 'hidden';
			//alert(f.radiofiltro[0].checked);
			//alert(f.radiofiltro[1].checked);
			f.radiofiltro[0].checked = 1;
			f.radiofiltro[1].checked = 0;
			
		}
	}  

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
								<b>Listado de Materias<br>	(En orden Alfabetico)</b> 
							<cfelse>
								<b>Listado de Materias por Grupo</b>
							</cfif>
						</strong>
					</td>
				</tr> 

			</cfif>
			
	 	</table>
	
	<cfif not isdefined("Url.Grupo") >
		<table  width="75%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="5"  class="tituloAlterno" align="center"><strong><b><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></b><strong></td>
			</tr>
			<tr> 
					
        <td width="12%"  align="right">&nbsp; </td>
					
       				
        <td width="38%"  align="right" valign="middle" nowrap><input name="Label_FiltroGrupo" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="Grupo"  size="22" readonly=""> 
          <select name="Grupo" id="Grupo" onChange="javascript: OcultaOpt(this.form);" >
							<cfif isdefined("form.Grupo") and #form.Grupo# EQ "-1">
								<option value="-1" selected>-- Todos --</option>
							<cfelse>
								<option value="-1">-- Todos --</option>
							</cfif>
	<!--- 						<cfif isdefined("form.Grupo") and #form.Grupo# EQ "-2">
								<option value="-2" selected>-- Materias No asignados (para éste Periodo) --</option>
							<cfelse>
								<option value="-2" >-- Materias No asignados (para éste Periodo) --</option>
							</cfif> 
	 --->					<cfoutput query="rsFiltroGrupos"> 
								<cfif isdefined("form.Grupo") and #form.Grupo# EQ #rsFiltroGrupos.GRcodigo#>
									<option value="#rsFiltroGrupos.GRcodigo#" selected>#rsFiltroGrupos.Grupo#</option>
								<cfelse>
									<option value="#rsFiltroGrupos.GRcodigo#">#rsFiltroGrupos.Grupo#</option>
								</cfif>
							</cfoutput>
						 
						</select>
        <td width="29%" align="right" valign="middle">
						<!--- <input name="Label_Grupo" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="Grupo:"  size="22" readonly=""> --->
					</td>
					
        <td colspan="2"  align="left" nowrap> 
          <input type="radio"  name="radiofiltro"  value="0" 
						<cfif isdefined("Form.radiofiltro") and Form.radiofiltro EQ 0>checked<cfelseif not isdefined("Form.radiofiltro")>checked</cfif>>
          <input name="Label_PxGrupo" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="P&aacute;gina por grupo"  size="22" readonly=""></td>						
					<td width="0%"></td>
				</tr>
				<tr> 
					<td align="right"> 
						<!--- <input type="radio" name="radiofiltro"  onClick="javascript: OcultaGrupo(this.form);" value="1" <cfif isdefined("Form.radiofiltro") and Form.radiofiltro EQ 1>checked</cfif>> ---> 
						
					</td>
			        <td align="left" valign="middle" nowrap>
						
					</td>
					<td >&nbsp;
					</td>
					
					
        <td  colspan="2" align="left" nowrap> 
          <input type="radio" name="radiofiltro"  value="1" <cfif isdefined("Form.radiofiltro") and Form.radiofiltro EQ 1>checked</cfif>>
          <input name="Label_Pcontinua" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="P&aacute;gina Continua "  size="22" readonly="">
        </td>
				</tr>
				<tr> 
					<td colspan="5"  align="center"> 
					</td>
				</tr>
				<tr> 
					<cfif not isdefined("Url.Grupo") >
						<td colspan="5" align="center"> 
							<input name="Generar" type="submit" value="Generar"  >
							<cfoutput> 
								<cfif isdefined("form.Generar")>
									<cfif #form.radiofiltro# EQ 0>
										<input type="button"  name="Imprimir" value="Imprimir" onClick="javascript:printURL('ListadoMateriasGrupoimpr.cfm?radioFiltro=#Form.radioFiltro#&Generar=#form.Generar#&Grupo=#form.Grupo#');">
									<cfelse>
										<input type="button"  name="Imprimir" value="Imprimir" onClick="javascript:printURL('ListadoMateriasGrupoimpr.cfm?radioFiltro=#Form.radioFiltro#&Generar=#form.Generar#&Grupo=-1');">			
									</cfif>	
								</cfif>
							</cfoutput> 
						</td>
					</cfif>	
				</tr>
			</cfif>
		</table> 
	</cfif> 	
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
    <cfif isdefined("form.radiofiltro") <!--- and #form.radiofiltro# EQ 0 --->>
      <cfif isdefined("form.Generar") and len(trim(form.Generar)) NEQ 0 >
        <cfif cons1.recordCount GT 0 >
          <tr> 
          <table width="100%" border="0" cellspacing="0">
			<cfif rsNiveles.recordCount GT 0 and cons1.Grupo NEQ "Sin Grupo" >
				<cfoutput> 
					<cfloop query="rsNiveles">
						
						<!---  <cfif isdefined("form.Grupo") and #form.Grupo# EQ "-1"> --->
						<cfset Nivel = rsNiveles.Ndescripcion>
						
						<cfquery name="rsGruposConsulta" dbtype="query">
							select distinct Grupo, NombGrado
							from cons1 where Ndescripcion = 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
							order by Norden, Gorden, Grupo 
						</cfquery>

						<!--- <cfquery name="rsGradosConsulta" dbtype="query">
							select distinct NombGrado from cons1 where Ndescripcion 
							= 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
							order by Norden, Gorden, Grupo 
						</cfquery> --->
						
						<cfloop query="rsGruposConsulta">
							<cfset GrupoNombre = rsGruposConsulta.Grupo>
							<cfset GradoNombre  = rsGruposConsulta.NombGrado>
							<tr> 
								<td colspan="5" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">#Nivel# 
								: #GradoNombre# : #GrupoNombre#</td>
							</tr>
							<tr> 
								<td width="17%" align="left" nowrap class="subTitulo" style="padding-left: 10px">No.</td>
								<td width="38%" nowrap class="subTitulo">Materia</td>
								
								<td width="25%" align="left" nowrap class="subTitulo">Nombre 
								Profesor</td>
								<td width="17%" align="right" nowrap class="subTitulo">&nbsp;</td>
								<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
							</tr>
							<cfquery name="rsConsulta" dbtype="query">
								select * from cons1 where Ndescripcion = 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
								and Grupo = 
								<cfqueryparam cfsqltype="cf_sql_char" value="#GrupoNombre#">
								</cfquery>
							<cfloop query="rsConsulta">
								<tr> 
									<cfif #rsConsulta.SinNombre# EQ 1>
										<cfif isdefined("Url.Grupo") and #form.radiofiltro# EQ 0>
											<td align="left">#rsConsulta.CurrentRow#</td>
											<td nowrap>#rsConsulta.Mnombre#</td>
											<td nowrap>#rsConsulta.Nombre#</td>
											<td align="right" >&nbsp;</td>
											<td align="right" >&nbsp;</td>
										<cfelse>
											<td align="left"><strong><font color="##FF0000">#rsConsulta.CurrentRow#</font></strong></td>
											<td nowrap><strong><font color="##FF0000">#rsConsulta.Mnombre#</font></strong></td>
											<td nowrap align="left"><strong><font color="##FF0000">#rsConsulta.Nombre#</font></strong></td>
											<td align="right" >&nbsp;</td>
											<td align="right" >&nbsp;</td>
										</cfif>
									<cfelse>
										<td align="left">#rsConsulta.CurrentRow#</td>
										<td nowrap>#rsConsulta.Mnombre#</td>
										<td nowrap>#rsConsulta.Nombre#</td>
										<td align="right" >&nbsp;</td>
										<td align="right" >&nbsp;</td>
									</cfif>
								</tr>
							</cfloop>
							<tr> 
								<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" colspan="2">Total 
								Materias del Grupo: #GrupoNombre#</td>
								<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">#rsConsulta.recordCount#</td>
								<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
								<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
								<!--- <cfif isdefined("form.Imprimir") and isdefined("form.radiofiltro") and  #form.radiofiltro# NEQ 1> --->
							</tr>
							<tr> 
								<td colspan="5">&nbsp;</td>
							</tr>
							<cfif isdefined("Url.Grupo") and #form.radiofiltro# EQ 0 and #form.Grupo# EQ -1 >
								<tr>
									<td colspan="5" >&nbsp;</td>
								</tr>
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
											<b>Listado de Materias <br>	(En orden Alfabetico)</b> 
										<cfelse>
											<b>Listado de Materias por Grupo</b>
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
							<tr>
								<td colspan="5" >&nbsp;</td>
							</tr>
					</cfloop>
				</cfoutput> 
				<tr> 
					<td colspan="5">&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="5" align="center"> ------------------ Fin del Reporte ------------------ </td>
				</tr>
			</cfif>
			</table>
		</tr>
		<cfif isdefined("form.Generar") and len(trim(form.Generar)) NEQ 0 >
		<cfelseif <!---  #form.Grupo# NEQ -2 and  ---> rsNivelConsulta.recordCount EQ 0 and  rsNiveles.recordCount EQ 0>
					  <tr> 
						<td colspan="5"> 
						<table width="85%" border="0" cellspacing="0">
							<cfloop query="rsNivelFiltro">
							  <cfoutput> 
								<cfset Nivel = rsNivelFiltro.Ndescripcion>
								<cfset GRcod = rsNivelFiltro.GRcodigo>
								<tr> 
								  <td colspan="5">&nbsp;</td>
								</tr>
								<tr> 
								  <td class="superSubTitulo" colspan="5">Hola</td>
								</tr>
								<cfquery name="rsGruposConsulta" dbtype="query">
								select distinct Grupo, NombGrado
								from rsFiltroGruposCons where Ndescripcion 
								= 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
								and GRcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#GRcod#">
								order by Norden, Gorden, Grupo 
								</cfquery>
								
								<!--- <cfquery name="rsGradosConsulta" dbtype="query">
								select distinct NombGrado from rsFiltroGruposCons where Ndescripcion 
								= 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
								order by Norden, Gorden, Grupo 
								</cfquery> --->

								<cfloop query="rsGruposConsulta">
								  <cfset GrupoNombre = rsGruposConsulta.Grupo>
								  <cfset GradoNombre = rsGruposConsulta.NombGrado>
								  <cfif isdefined("form.Grupo") and #form.Grupo# EQ "-1">
									<tr> 
									  <td colspan="5" class="tbline" style="background-color: ##F5F5F5; font-weight: bold">: 
										#Nivel# : #GradoNombre# : #GrupoNombre#</td>
									</tr>
								  </cfif>
								  <tr> 
									<td width="16%" align="left" nowrap class="subTitulo" style="padding-left: 10px">No.</td>
									<td width="75%" nowrap class="subTitulo">Nombre Estudiante</td>
									<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
									<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
									<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
								  </tr>
								  <cfquery name="rsConsulta" dbtype="query">
								  select * from rsFiltroGruposCons where Ndescripcion = 
								  <cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
								  and Grupo = 
								  <cfqueryparam cfsqltype="cf_sql_char" value="#GrupoNombre#">
								  </cfquery>
								  <tr> 
									<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" colspan="2">Total 
									  Materias del Grupo: #GrupoNombre#</td>
									<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">0</td>
									<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
									<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
								  </tr>
								  <tr> 
									<td colspan="5">&nbsp;</td>
								  </tr>
								  <tr> 
									<td colspan="5">&nbsp;</td>
								  </tr>
								</cfloop>
							  </cfoutput> 
							  <td > 
							</cfloop>
							<tr> 
								<td colspan="5" align="center"> ------------------ Fin del Reporte ------------------ 
								</td>
							</tr>
						  </table>
						  </td>
					  </tr>
				<cfelse>
					  <tr> 
						<td colspan="5" align="center"> ------------------ No existen materias para la consulta solicitada ------------------ </td>
					  </tr>
				
				</cfif>
			</cfif>
		
      	</cfif>


	</table>
</cfif>

</form>

<cfif not isdefined("Url.Grupo") >
	<script>
		OcultaOpt(document.form1); 
	</script>
</cfif>
