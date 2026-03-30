
<cfquery datasource="#Session.DSN#" name="rsCentroEducativo">
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
<cfif isdefined("url.Grupo") and not isdefined("Form.Grupo")>
	<cfparam name="Form.Grupo" default="#url.Grupo#">
</cfif>
<cfif isdefined("url.Imprimir") and not isdefined("Form.Imprimir")>
	<cfparam name="Form.Imprimir" default="#url.Grupo#">
</cfif>
<!--- <cfquery name="cons1" datasource="#Session.DSN#">
	select Papellido1 + ' ' + Papellido1 + ' ' + a.Pnombre as Nombre, 
		d.GRnombre as Grupo, 
		substring(e.Ndescripcion,1,50) as Ndescripcion,
		Norden, 
		Gorden, 
		convert(varchar,d.GRcodigo) as Gcodigo,
		substring(f.Gdescripcion,1,50) as NombGrado
	   from PersonaEducativo a, Alumnos b, GrupoAlumno c, Grupo d, Nivel e , Grado f, PeriodoEscolar g, SubPeriodoEscolar h, PeriodoVigente i
	where a.CEcodigo = b.CEcodigo
	  and a.persona = b.persona
	  and a.CEcodigo = c.CEcodigo
	  and b.CEcodigo = c.CEcodigo
	  and b.Ecodigo = c.Ecodigo
	  and c.GRcodigo = d.GRcodigo
	  and d.Ncodigo = e.Ncodigo
	  and a.CEcodigo = e.CEcodigo
	  and b.CEcodigo = e.CEcodigo
	  and c.CEcodigo = e.CEcodigo
	  and d.Gcodigo = f.Gcodigo
	  and d.Ncodigo = f.Ncodigo
	  <!--- Grupos con el periodo vigente --->
	  and d.PEcodigo = i.PEcodigo
	  and d.SPEcodigo = i.SPEcodigo
	  
	  and e.Ncodigo = g.Ncodigo
	  and g.PEcodigo = h.PEcodigo
	  and e.Ncodigo = i.Ncodigo
	  and g.PEcodigo = i.PEcodigo
	  and h.SPEcodigo = i.SPEcodigo
	  <!--- Hasta aqui grupos con el periodo vigente --->
	  and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
	  <cfif isdefined("form.Grupo") and #form.Grupo# NEQ -1>
	  	and convert(varchar,d.GRcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Grupo#">
	  </cfif>
	  order by Norden, f.Gorden,  Papellido1 + ' ' + Papellido1 + ' ' + a.Pnombre
</cfquery> --->
<!--- <cfdump var="#Session.usuario#">
<cfdump var="#Session.CEcodigo#"> 
<cfif isdefined("Form.Grupo")>
	<cfdump var="#Form.Grupo#"> 
</cfif>   
--->
<cfif isdefined("Form.Generar")>
	<cfstoredproc datasource="#Session.DSN#" procedure="sp_ALUMNOGRUPO" returncode="yes">
		<cfprocresult name="cons1">
		<cfprocparam cfsqltype="cf_sql_integer" dbvarname="@empresa" value="#Session.CEcodigo#">
		<cfprocparam cfsqltype="cf_sql_integer" dbvarname="@Grupo" value="#Form.Grupo#">
	</cfstoredproc>
	
	<cfif #form.Grupo# EQ -1 >
<!--- 		<cfquery name="rsGrupos" dbtype="query">
			select distinct Nombre, Grupo, Ndescripcion
			from cons1 
			order by Norden, Gorden
		</cfquery> --->
		
		<cfquery name="rsNivelConsulta" dbtype="query">
			select distinct Ndescripcion
			from cons1
			order by Norden 
		</cfquery>
	</cfif>	
</cfif>

<!--- <cfdump var="#cons1#">  --->
<cfquery datasource="#Session.DSN#" name="rsNiveles">
	select distinct convert(varchar, a.Ncodigo) as Ncodigo, a.Ndescripcion 
	from Nivel a, Grupo b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and a.Ncodigo = b.Ncodigo
    <cfif isdefined("form.Grupo") and #form.Grupo# NEQ -1>
	  	and convert(varchar,b.GRcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Grupo#">
	</cfif>
	order by a.Norden
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsFiltroGruposCons">  
	<!--- 	select d.GRnombre as Grupo, 
		e.Ndescripcion as Ndescripcion, 
		Norden, 
		Gorden, 
		convert(varchar,d.GRcodigo) as GRcodigo,
		substring(f.Gdescripcion,1,50) as NombGrado
	   from  Grupo d, Nivel e , Grado f, PeriodoEscolar g, SubPeriodoEscolar h , PeriodoVigente i
	where  d.Ncodigo = e.Ncodigo
	  and d.Gcodigo = f.Gcodigo
	  and d.Ncodigo = f.Ncodigo
	  <!--- Grupos con el periodo vigente --->
	  and d.PEcodigo = i.PEcodigo
	  and d.SPEcodigo = i.SPEcodigo
	  
	  and e.Ncodigo = g.Ncodigo
	  and g.PEcodigo = h.PEcodigo
	  and e.Ncodigo = i.Ncodigo
	  and g.PEcodigo = i.PEcodigo
	  and h.SPEcodigo = i.SPEcodigo
	  <!--- Hasta aqui grupos con el periodo vigente --->
	  and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
	 order by Norden, f.Gorden  --->

  select  
        convert(varchar,a.Ecodigo) as Ecodigo
      , (Papellido1 + ' ' + Papellido1 + ' ' + Pnombre) as Nombre
      , convert(varchar,d.Ncodigo) as  Ncodigo
         , isnull(e.Ndescripcion,'No tiene Nivel Asociado') as Ndescripcion
      , isnull(convert(varchar,f.Gcodigo),'99999') as  Gcodigo
      , isnull(substring(f.Gdescripcion,1,50),'Sin Grado') as NombGrado
      , convert(varchar,h.GRcodigo) as  GRcodigo
      , isnull(GRnombre,'Sin Grupo') as Grupo 
      , isnull(convert(varchar,i.Norden),'99999') as Norden
      , isnull(convert(varchar,Gorden),'99999') as Gorden
     from Alumnos a
      , Estudiante b
      , PersonaEducativo c
      , Promocion d
      , Nivel e
      , Grado f
      , GrupoAlumno g
      , Grupo h
      , Nivel i
     where 
	     a.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
    	and Aretirado   = 0
     	and a.Ecodigo   = b.Ecodigo
	    and b.persona   = c.persona
    	and a.PRcodigo  = d.PRcodigo
	    and d.Ncodigo   = e.Ncodigo
    	and d.Gcodigo   = f.Gcodigo
	    and a.Ecodigo   *=g.Ecodigo
	    and g.GRcodigo  *=h.GRcodigo
    	and h.Ncodigo   *=i.Ncodigo
    	and h.SPEcodigo in (
	       	select SPEcodigo
    		   from PeriodoVigente
       		)
     order by i.Norden, Gorden, Nombre	
	 
</cfquery>
<cfquery name="rsFiltroGrupos" dbtype="query">
	 select distinct GRcodigo , Grupo
	 from rsFiltroGruposCons 
	 order by Norden, Gorden, Grupo 
</cfquery>
<cfquery name="rsNivelFiltro" dbtype="query">
	select distinct Ndescripcion
	from rsFiltroGruposCons
	<!---  <cfif isdefined("form.Grupo") and "form.Grupo" NEQ -1>
	  	where Grupo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Grupo#">
	  </cfif> --->
	order by Norden, Gorden, Grupo
</cfquery>
<!--- desde aqui la opcion de todos los alumnos registrados en el Centro Educativo --->
<cfquery name="consTodosOrden" datasource="#Session.DSN#">
	select Papellido1 + ' ' + Papellido1 + ' ' + a.Pnombre as Nombre 
   	from PersonaEducativo a, Alumnos b
	where a.CEcodigo = b.CEcodigo
	  and a.persona = b.persona
	  and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
	  order by Papellido1 + ' ' + Papellido1 + ' ' + a.Pnombre
</cfquery>
<!--- <cfif isdefined("Form.Generar")>
	<cfquery name="consNoAsignados" datasource="#Session.DSN#">
		select b.Ecodigo
		   from PersonaEducativo a, Alumnos b, GrupoAlumno c, Grupo d, Nivel e , Grado f, PeriodoVigente i
		where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
		  and a.CEcodigo = b.CEcodigo
		  and a.persona = b.persona
	
		  and a.CEcodigo *= c.CEcodigo
		  and b.CEcodigo *= c.CEcodigo
		  and b.Ecodigo *= c.Ecodigo
		  and d.GRcodigo *= c.GRcodigo
		  and e.CEcodigo *= c.CEcodigo
	
		  and d.Ncodigo = e.Ncodigo
		  and a.CEcodigo = e.CEcodigo
		  and b.CEcodigo = e.CEcodigo
	
		  and d.Gcodigo = f.Gcodigo
		  and d.Ncodigo = f.Ncodigo
	--	  <!--- Grupos con el periodo vigente --->
		  and d.PEcodigo = i.PEcodigo
		  and d.SPEcodigo = i.SPEcodigo
		  and e.Ncodigo = i.Ncodigo
	
		 
		  and b.Ecodigo not in (select Ecodigo from GrupoAlumno 
		  						where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">)
		 
	</cfquery>
	
<!--- 	<cfquery name="rsGruposNoAsignados" dbtype="query">
		select distinct Nombre, Grupo, Ndescripcion
		from cons1
		where cons1.Nombre = consNoAsignados.Nombre  
		order by Norden, Gorden
	</cfquery>
	<cfdump var="#rsGruposNoAsignados#">  --->
</cfif> --->
<!--- <cfquery datasource="#Session.DSN#" name="rsNivelesNoAsignados">
	select distinct Ndescripcion 
	from consNoAsignados
	order by Norden, Gorden
<!---   and a.Ndescripcion = #consNoAsignados.Ndescripcion# --->
<!---     <cfif isdefined("form.Grupo") and #form.Grupo# NEQ -1>
	  	and convert(varchar,b.GRcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Grupo#">
	</cfif> --->
</cfquery> --->


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
	
	function OcultaGrupo(f) {

	//alert(f.radiofiltro[0].checked);
		if (f.radiofiltro[0].checked == 0) {      
			f.Grupo.style.visibility = 'hidden';
			f.Label_Grupo.style.visibility = 'hidden';
		} else {    
			f.Grupo.style.visibility = 'visible';
			f.Label_Grupo.style.visibility = 'visible';
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
								<b>Listado de Estudiantes<br>	(En orden Alfabetico)</b> 
							<cfelse>
								<b>Listado de Estudiantes</b>
							</cfif>
						</strong>
					</td>
				</tr> 

			</cfif>
			<tr>
				<td colspan="5"  class="tituloAlterno" align="center"><strong><b><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></b><strong></td>
			</tr>
			<tr align="center"> 
				<td colspan="5">&nbsp; </td>
			</tr>
	<!--- 	</table> --->			
		<cfif not isdefined("Url.Grupo") >
			<table width="75%" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr> 
					<td  align="right"><input type="radio"  onClick="javascript: OcultaGrupo(this.form);" name="radiofiltro"  value="0" <cfif isdefined("Form.radiofiltro") and Form.radiofiltro EQ 0>checked<cfelseif not isdefined("Form.radiofiltro")>checked</cfif>> 
					</td>
					<td align="left" valign="middle" nowrap>Separar p&aacute;gina por grupo </td>
					<td align="right" valign="middle">
						<input name="Label_Grupo" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="Grupo:"  size="22" readonly="">
					</td>
					<td  colspan="2" align="right">
						<select name="Grupo" id="Grupo"> 
							<cfif isdefined("form.Grupo") and #form.Grupo# EQ "-1">
								<option value="-1" selected>-- Todos --</option>
							<cfelse>
								<option value="-1">-- Todos --</option>
							</cfif>
							<cfif isdefined("form.Grupo") and #form.Grupo# EQ "-2">
								<option value="-2" selected>-- Alumnos sin asignar (para éste Periodo) --</option>
							<cfelse>
								<option value="-2" >-- Alumnos sin asignar (para éste Periodo) --</option>
							</cfif> 
							<cfoutput query="rsFiltroGrupos"> 
								<cfif isdefined("form.Grupo") and #form.Grupo# EQ #rsFiltroGrupos.GRcodigo#>
									<option value="#rsFiltroGrupos.GRcodigo#" selected>#rsFiltroGrupos.Grupo#</option>
								<cfelse>
									<option value="#rsFiltroGrupos.GRcodigo#">#rsFiltroGrupos.Grupo#</option>
								</cfif>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr> 
					<td align="right"> 
						<input type="radio" name="radiofiltro"  onClick="javascript: OcultaGrupo(this.form);" value="1" <cfif isdefined("Form.radiofiltro") and Form.radiofiltro EQ 1>checked</cfif>> 
					</td>
					<td align="left" valign="middle" nowrap>Todos 
						por orden alfab&eacute;tico
					</td>
					<td colspan="3"  align="center"> </td>
				</tr>
				<tr> 
					<td colspan="5"  align="center"> </td>
				</tr>
				<tr> 
					<cfif not isdefined("Url.Grupo") >
						<td colspan="5" align="center"> 
							<input name="Generar" type="submit" value="Generar"  >
							<cfoutput> 
								<cfif isdefined("form.Generar")>
									<cfif #form.radiofiltro# EQ 0>
										<input type="button"  name="Imprimir" value="Imprimir" onClick="javascript:printURL('ListadoEstudiantesDimpr.cfm?radioFiltro=#Form.radioFiltro#&Generar=#form.Generar#&Grupo=#form.Grupo#');">
									<cfelse>
										<input type="button"  name="Imprimir" value="Imprimir" onClick="javascript:printURL('ListadoEstudiantesDimpr.cfm?radioFiltro=#Form.radioFiltro#&Generar=#form.Generar#');">			
									</cfif>	
								</cfif>
							</cfoutput> 
						</td>
					</cfif> 	
				</tr>
			</table> 	
		</cfif>
	</cfif>
	
     <cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 0>
      <cfif isdefined("form.Generar") and len(trim(form.Generar)) NEQ 0 >
        <cfif cons1.recordCount GT 0 >
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0"> 
          <tr> 
            <td colspan="5"> 
           		<cfif rsNiveles.recordCount GT 0 and cons1.GRnombre NEQ "Sin Grupo" >
					<cfloop query="rsNiveles">
						<cfoutput> 
								<!---  <cfif isdefined("form.Grupo") and #form.Grupo# EQ "-1"> --->
								<cfset Nivel = rsNiveles.Ndescripcion>
								<!--- <tr>  --->
								<td colspan="5">&nbsp;</td>
								<!--- </tr> --->
								<tr> 
									<td width="16%" ></td>
								</tr>
								<cfquery name="rsGruposConsulta" dbtype="query">
									select distinct GRnombre from cons1 where Ndescripcion = 
									<cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
									order by Norden, Gorden, GRnombre 
								</cfquery>
								<cfdump var="#rsGruposConsulta#">
								<cfquery name="rsGradosConsulta" dbtype="query">
									select distinct NombGrado from cons1 where Ndescripcion 
									= 
									<cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
									order by Norden, Gorden, GRnombre 
								</cfquery>
								<cfdump var="#rsGradosConsulta#">
								<cfloop query="rsGruposConsulta">
									<cfset GrupoNombre = rsGruposConsulta.GRnombre>
									<cfset GradoNombre  = rsGradosConsulta.NombGrado>
										<tr> 
											<td colspan="5"  class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">#Nivel# 
											: #GradoNombre# : #GrupoNombre#</td>
										</tr>
										<tr> 
											<td width="16%" align="left" nowrap class="subTitulo" style="padding-left: 10px">No.</td>
											<td width="63%" nowrap class="subTitulo">Nombre Estudiante</td>
											<td width="17%" align="right" nowrap class="subTitulo">&nbsp;</td>
											<td width="0%" align="right" nowrap class="subTitulo">&nbsp;</td>
											<td width="4%" align="right" nowrap class="subTitulo">&nbsp;</td>
										</tr>
										<cfquery name="rsConsulta" dbtype="query">
											select * from cons1 where Ndescripcion = 
											<cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
											and GRnombre = 
											<cfqueryparam cfsqltype="cf_sql_char" value="#GrupoNombre#">
										</cfquery>
										<cfloop query="rsConsulta">
											<tr> 
												<td align="left" > #rsConsulta.CurrentRow# </td>
												<td nowrap > #rsConsulta.Nombre# </td>
												<td align="right" ></td>
												<td align="right" >&nbsp;</td>
												<td align="right" >&nbsp;</td>
											</tr>
										</cfloop>
										<tr> 
											<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" colspan="2">Total 
											Alumnos del Grupo: #GrupoNombre#</td>
											<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">#rsConsulta.recordCount#</td>
											<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
											<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
											<!--- <cfif isdefined("form.Imprimir") and isdefined("form.radiofiltro") and  #form.radiofiltro# NEQ 1> --->
										</tr>
										<tr>
											<td height="20" colspan="5" valign="top"><br class="pageEnd"></td>
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
																<b>Listado de Estudiantes <br>	(En orden Alfabetico)</b> 
															<cfelse>
																<b>Listado de Estudiantes</b>
															</cfif>
														</strong>
													</td>
												</tr>														
											</cfif>
										<tr>
											<td colspan="5"  class="tituloAlterno" align="center"><strong><b><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></b><strong></td>
										</tr>
								</cfloop>
							</cfoutput> 
							<td> 
						</cfloop>
					<tr> 
					<td colspan="5">&nbsp;</td>
					</tr>
				<!--- 	<tr> 
						<td colspan="5" align="center"> ------------------ Fin del 
						Reporte ------------------ </td>
					</tr> --->
					</cfif>
                <cfif cons1.recordCount GT 0 and #form.Grupo# NEQ -2>
                  <tr> 
                    <td colspan="5" align="center"> 
                   <!---  <table width="100%" border="0" cellspacing="0"> --->
                        <cfoutput> 
							<tr> 
							   
                        <td colspan="3"  class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold"> 
                          Alumnos sin asignar (para éste Periodo) </td>
							</tr>
							<tr> 
								<td width="16%" align="left" nowrap class="subTitulo" style="padding-left: 10px">No.</td>
								<td width="75%" nowrap class="subTitulo">Nombre Estudiante</td>
								<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
								<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
								<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
							</tr>
							<cfset HayAlumnosSinGrupo = 0>
							<cfloop query="cons1">
								<cfif cons1.GRnombre EQ "Sin Grupo" >
									  <cfset HayAlumnosSinGrupo = HayAlumnosSinGrupo + 1>
									  <tr> 
										<td align="center">#cons1.CurrentRow#</td>
										<td nowrap >#cons1.Nombre#</td>
										<td align="right" >&nbsp;</td>
									  </tr>
								</cfif>
							</cfloop>
							<cfif  HayAlumnosSinGrupo EQ 0>
								<tr> 
									<td colspan="3" align="center"> 
										------------------ No existen alumnos sin asignar ------------------ 
									</td>
								</tr>
							   	<tr> 
									<td colspan="5" align="center"> ------------------ Fin del Reporte ------------------ </td>
								</tr> 
							<cfelse>
								<tr> 
									<td colspan="3">&nbsp;</td>
								</tr>
								<tr> 
									<td colspan="3" align="center"> 
										------------------ Fin del Reporte ------------------ 
									</td>
								</tr>
							</cfif>
                        </cfoutput>
					<!--- </table> --->
						</td>
                  </tr>
				
						  
               </cfif>
         
				</td>
          	</tr>
			</table>
			<cfif isdefined("form.Generar") and len(trim(form.Generar)) NEQ 0 >
				<table width="100%" border="0" cellspacing="0">
					<cfelseif #form.Grupo# NEQ -2 and  rsNivelConsulta.recordCount EQ 0 and  rsNiveles.recordCount EQ 0>
				
						  <tr> 
							<td colspan="5">
	
								<cfloop query="rsNivelFiltro">
								  <cfoutput> 
									<cfset Nivel = rsNivelFiltro.Ndescripcion>
									<tr> 
									  <td colspan="5">&nbsp;</td>
									</tr>
									<tr> 
									  <td class="subTitulo" colspan="5"></td>
									</tr>
									<cfquery name="rsGruposConsulta" dbtype="query">
										select distinct Grupo from rsFiltroGruposCons where Ndescripcion 
											= <cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
										order by Norden, Gorden, Grupo 
									</cfquery>
									<cfdump var="rsGruposConsulta">
									<cfquery name="rsGradosConsulta" dbtype="query">
										select distinct NombGrado 
										from rsFiltroGruposCons 
										where Ndescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
										    
										order by Norden, Gorden, Grupo 
									</cfquery>
										<cfdump var="rsGradosConsulta">
										<cfloop query="rsGruposConsulta">
										  <cfset GrupoNombre = rsGruposConsulta.Grupo>
										  <cfset GradoNombre = rsGradosConsulta.NombGrado>
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
											  select * from rsFiltroGruposCons 
											  where Ndescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Nivel#">
												and Grupo = <cfqueryparam cfsqltype="cf_sql_char" value="#GrupoNombre#">
										  </cfquery>
												<tr> 
													<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" colspan="2">Total 
													  Alumnos del Grupo: #GrupoNombre#</td>
													<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">0</td>
													<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
													<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">&nbsp;</td>
													<!--- <cfif isdefined("form.Imprimir") and isdefined("form.radiofiltro") and  #form.radiofiltro# NEQ 1> --->
													<tr>
														<td height="20" colspan="5" valign="top"><br class="pageEnd"></td>
															<!--- <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0"> --->
																<cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 0>
																	<cfif isdefined("Url.radioFiltro")>
																		<tr>
																			<td align="left" nowrap><strong>Servicios Digitales del Ciudadano</strong></td>
																			<td colspan="2" align="right" nowrap>Fecha: #LSdateFormat(Now(),'dd/MM/YY')#</td>
																		</tr>
																		<tr>
																			<td align="left" nowrap> <strong>www.migestion.net</strong> </td>
																			<td align="right" nowrap>Hora:&nbsp; #TimeFormat(Now(),'hh:mm:ss')#</td>
																		</tr>
																	</cfif>
																
																	<tr>
																		<td colspan="5" class="tituloAlterno" align="center">
																			<strong>
																				<cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 1>
																					<b>Listado de Estudiantes <br>	(En orden Alfabetico)</b> 
																				<cfelse>
																					<b>Listado de Estudiantes</b>
																				</cfif>
																			</strong>
																		</td>
																	</tr> 
																	<tr>
																		<td colspan="5" class="tituloAlterno" align="center">
																			<strong>
																				<b>#rsCentroEducativo.CEnombre#</b>
																			</strong>
																		</td>
																	</tr>
																</cfif> 
																<!--- </table> --->		
														</tr>
												</tr>
										</cfloop>
									</cfoutput> 
								  <td > 
								</cfloop>
					
							 </td>
						  </tr>
					<cfelse>
						  <tr> 
							<td colspan="5" align="center"> ------------------ 1 - No existen 
							  Alumnos para la consulta solicitada------------------ </td>
						  </tr>
					</cfif>
				</table> 
			</cfif>
		
      	</cfif>
	
	<cfelseif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 1>
		<cfif isdefined("form.Generar") and len(trim(form.Generar)) NEQ 0 >
			<!--- desde aqui --->
			<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
				<cfif isdefined("Url.radioFiltro")>
					<cfoutput> 
						<tr> 
							<td align="left" nowrap><strong>Servicios Digitales del Ciudadano</strong></td>
							<td align="right">&nbsp;</td>
							<td align="right">&nbsp;</td>
							<td colspan="2" align="right" nowrap>Fecha: #LSdateFormat(Now(),'dd/MM/YY')#</td>
						</tr>
						<tr> 
							<td align="left" nowrap> <strong>www.migestion.net</strong> </td>
							<td align="right">&nbsp;</td>
							<td align="right">&nbsp;</td>
							<td colspan="2" align="right" nowrap>Hora:&nbsp; #TimeFormat(Now(),'hh:mm:ss')#</td>
						</tr>
					</cfoutput> 
						<tr>
							<td colspan="5" class="tituloAlterno" align="center">
								<strong>
									<cfif isdefined("form.radiofiltro") and #form.radiofiltro# EQ 1>
										<b>Listado de Estudiantes <br>	(En orden Alfabetico)</b> 
									<cfelse>
										<b>Listado de Estudiantes</b>
									</cfif>
								</strong>
							</td>
						</tr> 
				</cfif>
			
				<tr>
					<td colspan="5" class="tituloAlterno" align="center"><strong><b><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></b></strong>
					</td>
				</tr>
				<tr align="center"> 
					<td colspan="5">&nbsp; </td>
				</tr>
				</table>
				<table width="75%" border="0" align="center" cellpadding="0" cellspacing="0">
					<cfif not isdefined("Url.Grupo") >
						<tr> 
							<td  align="right"><input type="radio"  onClick="javascript: OcultaGrupo(this.form);" name="radiofiltro"  value="0" <cfif isdefined("Form.radiofiltro") and Form.radiofiltro EQ 0>checked<cfelseif not isdefined("Form.radiofiltro")>checked</cfif>> 
							</td>
							<td  align="left" valign="middle">Separar 
								p&aacute;gina por grupo </td>
							<td align="right" valign="middle"> 
								<input name="Label_Grupo" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="Grupo:"  size="22" readonly=""> 
							</td>
							<td  align="right">
								<select name="Grupo" id="Grupo">
									<cfif isdefined("form.Grupo") and #form.Grupo# EQ "-1">
										<option value="-1" selected>-- Todos --</option>
									<cfelse>
										<option value="-1">-- Todos --</option>
									</cfif>
									<option value="-2" >-- Alumnos sin asignar (para éste Periodo) --</option>
									<cfoutput query="rsFiltroGrupos"> 
										<cfif isdefined("form.Grupo") and #form.Grupo# EQ #rsFiltroGrupos.GRcodigo#>
											<option value="#rsFiltroGrupos.GRcodigo#" selected>#rsFiltroGrupos.Grupo#</option>
										<cfelse>
											<option value="#rsFiltroGrupos.GRcodigo#">#rsFiltroGrupos.Grupo#</option>
										</cfif>
									</cfoutput> 
								</select> 
							</td>
						</tr>
						<tr> 
							<td align="right"> 
								<input type="radio" name="radiofiltro"  onClick="javascript: OcultaGrupo(this.form);" value="1" <cfif isdefined("Form.radiofiltro") and Form.radiofiltro EQ 1>checked</cfif>> 
							</td>
							<td align="left" valign="middle">Todos 
								por orden alfab&eacute;tico
							</td>
						</tr>
					</cfif>
				
				<tr> 
					<td colspan="5" align="center"> <input name="Generar" type="submit" value="Generar"  > 
						<cfoutput> 
							<cfif isdefined("form.Generar")>
								<cfif #form.radiofiltro# EQ 0>
									<input type="button"  name="Imprimir" value="Imprimir" onClick="javascript:printURL('ListadoEstudiantesDimpr.cfm?radioFiltro=#Form.radioFiltro#&Generar=#form.Generar#&Grupo=#form.Grupo#');">
								<cfelse>
									<input type="button"  name="Imprimir" value="Imprimir" onClick="javascript:printURL('ListadoEstudiantesDimpr.cfm?radioFiltro=#Form.radioFiltro#&Generar=#form.Generar#');">
								</cfif>
							</cfif>
						</cfoutput> 
					</td>
				</tr>
			</table>
			<!--- hasta aqui --->
	
		<cfif consTodosOrden.recordCount GT 0 >
		    <table width="100%" border="0" cellspacing="0">
				<cfoutput>
					<tr>
						<td width="16%" align="left" nowrap class="subTitulo" style="padding-left: 10px">No.</td>
						<td width="75%" nowrap class="subTitulo">Nombre Estudiante</td>
						<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
						<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
						<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
					</tr>
					<cfloop query="consTodosOrden">
						<tr> 
							<td align="center"> 
								#consTodosOrden.CurrentRow# </td>
							<td nowrap> 
								#consTodosOrden.Nombre# 
							</td>
						</tr>
					</cfloop>
				</cfoutput>
				<tr> 
					<td colspan="5" align="center"> ------------------ Fin del Reporte ------------------ 
				</td>
			</tr>
			</table>
		<cfelse>
			<table width="100%" border="0" cellspacing="0">
				<tr> 
					<td width="16%" align="left" nowrap class="subTitulo" style="padding-left: 10px">No.</td>
					<td width="75%" nowrap class="subTitulo">Nombre Estudiante</td>
					<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
					<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
					<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="5" align="center"> ------------------- No existen 
					Alumnos para la consulta solicitada------------------ </td>
				</tr>
				<tr> 
					<td colspan="5" align="center"> ------------------ Fin del Reporte ------------------ 
				</td>
			</tr>
			</table>
		</cfif>
	</cfif>
</cfif>
	<!--- </table> --->
	<!--- <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">  --->
		<!--- desde aqui --->
	<cfif isdefined("form.Generar") and len(trim(form.Generar)) NEQ 0 >
		<table width="100%" border="0" cellspacing="0">
		<cfif #form.Grupo# EQ -2  and cons1.recordCount GT 0>
			<tr> 
				<td colspan="5"  class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold"> 
					Alumnos sin asignar (para éste Periodo) 
				</td>
			</tr>
			<cfoutput> 
				<tr> 
					<td width="16%" align="left" nowrap class="subTitulo" style="padding-left: 10px">No.</td>
					<td width="75%" nowrap class="subTitulo">Nombre Estudiante</td>
					<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
					<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
					<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
				</tr>
				<cfloop query="cons1">
					<tr> 
						<td align="center"> #cons1.CurrentRow# </td>
						<td nowrap> #cons1.Nombre#</td>
						<td align="right" >&nbsp;</td>
						<td align="right" >&nbsp;</td>
						<td align="right" >&nbsp;</td>
					</tr>
				</cfloop>
			</cfoutput>
				
			<!--- 	</td>
				</tr> --->
			
			<tr> 
				<td colspan="5" align="center"> ------------------ Fin del Reporte ------------------ 
				</td>
			</tr>
		</table>
		<cfelseif #form.Grupo# NEQ -1 and cons1.recordCount EQ 0>
			<table width="100%" border="0" cellspacing="0">
				<cfif #form.Grupo# NEQ -2>
					<tr> 
					   <td colspan="5"  class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold"> 
							No existen Alumnos Matriculados en el grupo Solicitado
						</td>
					</tr>
					<tr> 
					  <td width="16%" align="left" nowrap class="subTitulo" style="padding-left: 10px">No.</td>
					  <td width="75%" nowrap class="subTitulo">Nombre Estudiante</td>
					  <td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
					  <td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
					  <td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
					</tr>
					<tr> 
						<td colspan="5" align="center"> ------------------ Fin del Reporte ------------------ 
						</td>
					</tr>
				
				<cfelse>
					<tr> 
			        	<td colspan="5"  class="subTitulo" style="background-color: #F5F5F5; font-weight: bold"> 
            		  		Alumnos sin asignar (para éste Periodo) 
						</td>
					</tr>
					<tr> 
						<td width="16%" align="left" nowrap class="subTitulo" style="padding-left: 10px">No.</td>
						<td width="75%" nowrap class="subTitulo">Nombre Estudiante</td>
						<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
						<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
						<td width="3%" align="right" nowrap class="subTitulo">&nbsp;</td>
					</tr>
					<tr> 
						<td colspan="5" align="center"> ------------------ No existen alumnos 
							sin asignar ------------------ 
						</td>
					</tr>
				</cfif>
			</table>
		</cfif>
    </cfif>
    <!---  hasta aqui --->
  <!--- </table>  --->
</form>
<cfif not isdefined("Url.Grupo") >
	<script>
		OcultaGrupo(form1); 
	</script>
</cfif>
