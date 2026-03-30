	<cfif isdefined("Url.ckEsc") and not isdefined("Form.ckEsc")>
		<cfparam name="Form.ckEsc" default="#Url.ckEsc#">
	</cfif> 
	<cfif isdefined("Url.imprime") and not isdefined("Form.imprime")>
		<cfparam name="Form.imprime" default="#Url.imprime#">
	</cfif> 	
	<cfif isdefined("Url.Ncodigo") and not isdefined("Form.Ncodigo")>
		<cfparam name="Form.Ncodigo" default="#Url.Ncodigo#">
	</cfif> 
	<cfif isdefined("Url.Grupo") and not isdefined("Form.Grupo")>
		<cfparam name="Form.Grupo" default="#Url.Grupo#">
	</cfif> 
	<cfif isdefined("Url.Ecodigo") and not isdefined("Form.Ecodigo")>
		<cfparam name="Form.Ecodigo" default="#Url.Ecodigo#">
	</cfif>
  	<cfquery datasource="#Session.Edu.DSN#" name="rsNotasFinales_Principal">
		set nocount on
			exec sp_NOTASFINALES1
				@CCentro=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				,@grupo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">			
				
				<cfif isdefined('form.Ecodigo') and form.Ecodigo NEQ '-1'>
					,@alumno=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">			
				</cfif>
				<cfif isdefined('form.Ncodigo') and form.Ncodigo NEQ '-1' >
					,@nivel=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">			
				</cfif>				
		set nocount off
	</cfquery>	
	<cfquery name="rsNotasFinales" dbtype="query">
		Select *
		from rsNotasFinales_Principal
		where TipoNI = 'N'
		order by NombreAl, Orden, Morden, Orden_Comp
		<!--- order by NombreAl, Norden, Gorden, Morden, GRnombre, PEorden, PEdescripcion, fecha --->
	</cfquery>

	<cfquery name="rsPeriodos" dbtype="query">
		Select distinct PEcodigo,PEdescripcion
		from rsNotasFinales
		order by PEorden
	</cfquery> 
	<cfif isdefined('form.ckInci')>	
		<!--- Sub Consulta para las Incidencias por alumno --->
		<cfquery name="cons1" dbtype="query">
			select *
			from rsNotasFinales_Principal 
			where TipoNI = 'I'
			order by Norden, Gorden, Morden, Cnombre, NombreAl, fecha asc
		</cfquery>	
	</cfif>
	<cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
		select CEnombre from CentroEducativo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
	</cfquery>
	
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
		  //alert(url);
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
					html += '<head>';
					html += '<title>Notas del Alumno<\/title>';
					html += '<\/head>';
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
<script language="JavaScript1.1">
	<!-- Begin
	function derecho(e) {
		//alert(event.button);
		if (navigator.appName == 'Netscape' &&
			(e.which == 2 || e.which == 3))
			return false;
		else if (navigator.appName == 'Microsoft Internet Explorer' &&
				(event.button == 3 || event.button == 2 )) {
				alert("Solicitud no permitida, solo puede imprimir las notas.");
				return false;
			}
		return true;
		}
		document.onmousedown=derecho;
		if (document.layers) window.captureEvents(Event.MOUSEDOWN);
		window.onmousedown=derecho;
	// End -->
</script>
<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="tituloAlterno"> 
    <td width="100%" colspan="3" align="center" class="tituloAlterno"> <strong> 
      <cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
        <cfoutput>#form.TituloRep#</cfoutput> 
        <cfelse>
        REPORTE DE NOTAS FINALES 
      </cfif>
      </strong> </td>
  </tr>
	<cfset vMateria ="">
	<cfset vMateriaDescr ="">
	<cfset vConcepto ="">
	<cfset vComponente ="">
	<cfset vAlumno ="">
	<cfset vContConcepto = 0>
	<cfset vContAlumnos = 0>
	<cfset vContMaterias = 0>
	<cfset vExisteNota = 0>
	<cfset NumAplazos = 0>
	<cfset HayEstado = 0>
	<input name="Ecodigo" type="hidden" value="<cfif isdefined('form.Ecodigo') and form.Ecodigo NEQ '-1'><cfoutput>#form.Ecodigo#</cfoutput><cfelse>-1</cfif>" id="Ecodigo">				
	<input name="Grupo" type="hidden" value="<cfif isdefined('form.Grupo') ><cfoutput>#form.Grupo#</cfoutput></cfif>" id="Grupo">				
	<cfif not isdefined("Url.imprimir")>
		<cfoutput>
			<tr>
				<td align="right">
					<input type="button"  name="imprime" value="Imprimir Reporte" onClick="javascript:printURL('imprime/ListaNotasFinalesEncImpr.cfm?Ecodigo=#Ecodigo#&Grupo=#form.Grupo#&imprimir=1');">
				</td>
			</tr>
		</cfoutput>		
	</cfif>
  <tr> 
  <td colspan="3">
	<cfif rsNotasFinales.recordCount GT 0> 
		<table width="100%" border="0" cellspacing="1" cellpadding="1"><cfloop query="rsNotasFinales"><cfoutput><cfif vAlumno NEQ rsNotasFinales.NombreAl>
        <cfset NumTitElect = 0>
        <cfset vContAlumnos = vContAlumnos + 1>
        <cfif vContMaterias GT 0>
          <!--- Materia --->
          <tr> 
            <td>&nbsp; 
            </td>
          </tr>
          <tr> 
            <td> 
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
                <tr> 
                  <td  nowrap width="4%"></td>
                  <td><strong>PROMEDIO FINAL</strong> <cfset prom = 0> <cfquery name="rsPromedio" dbtype="query">
                    select sum(Cal_Per) as Promedio, count(*) as num , max(EstadoPeriodo) 
                    as EstadoPeriodo from rsNotasFinales where NombreAl = 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#vAlumno#">
                    and Cal_Per > 0 and Orden in (0,1,3) and Orden_Comp in (0) 
                    group by PEdescripcion </cfquery> </td>
                  <cfloop query="rsPromedio">
                    <cfif rsPeriodos.RecordCount EQ rsPromedio.Recordcount>
                      <td width="15%" align="center"> 
                        <strong> 
                        <cfset prom = rsPromedio.Promedio / rsPromedio.num >
                        #LSNumberFormat(prom,"0.00")# </strong> </td>
                      <cfelse>
                      <cfloop  query="rsPeriodos">
                        <cfif rsPromedio.PEdescripcion EQ rsPeriodos.PEdescripcion >
                          <cfset prom = rsPromedio.Promedio / rsPromedio.num >
                          <td width="15%" align="center"><strong>#LSNumberFormat(prom,"0.00")# 
                            </strong></td>
                          <cfelse>
                          <td width="15%" align="center">&nbsp; 
                          </td>
                        </cfif>
                      </cfloop>
                    </cfif>
                  </cfloop>
                  <cfset PromFin = 0>
                  <cfquery name="rsPromedioFin" dbtype="query">
                  select sum(Cal_Per) as PromedioFin, count(*) as numFin, max(EstadoPeriodo) 
                  as EstadoPeriodo from rsNotasFinales where NombreAl = 
                  <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
                  and Cal_Per > 0 and Orden in (0,1,3) and Orden_Comp in (0) group 
                  by NombreAl 
                  </cfquery>
                  <td width="15%" align="center" > <strong> <cfoutput> 
                      <cfif len(trim(rsPromedioFin.PromedioFin)) GT 0 and  len(trim(rsPromedioFin.NumFin)) GT 0>
                        <cfset UltPromGen = rsPromedioFin.PromedioFin / rsPromedioFin.NumFin>
                        #LSNumberFormat(UltPromGen,"0.00")# 
                        <cfelse>
                        &nbsp; 
                      </cfif>
                    </cfoutput> </strong> </td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td  class="areaFiltro" align="center"><strong>ESCALA DE VALORACI&Oacute;N</strong></td>
          </tr>
          <cfquery name="rsEvaluacValores" dbtype="query">
          Select distinct EVTcodigo from rsNotasFinales where NombreAl = 
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#vAlumno#">
          </cfquery>
          <cfif rsEvaluacValores.recordCount GT 0>
            <cfset ListaEVTcodigos = ValueList(rsEvaluacValores.EVTcodigo)>
            <cfif ListLen(ListaEVTcodigos) GT 0>
              <cfquery datasource="#Session.Edu.DSN#" name="rsEscValoracion">
              select EVvalor, EVdescripcion, ev.EVTcodigo, EVorden, EVTnombre
			  from EvaluacionValoresTabla evt, EvaluacionValores ev 
			  where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
                and evt.EVTcodigo=ev.EVTcodigo 
				and evt.EVTcodigo in (#ListaEVTcodigos#) 
              order by ev.EVTcodigo, EVorden
              </cfquery>
            </cfif>
          </cfif>
        <cfif rsEscValoracion.RecordCount EQ 0>
			<tr> 
			  <td align="center"  class="subrayado">N / A = No Aplica</td>
			</tr>
		</cfif>
         <cfif isdefined('rsEscValoracion')>
			<cfoutput>
				<cfset Tabla_desc = "">
				<cfloop query="rsEscValoracion">
					<cfif rsEscValoracion.EVTnombre NEQ Tabla_desc >
						<cfset Tabla_desc = rsEscValoracion.EVTnombre>
						<td align="center" class="subrayado"><strong>#rsEscValoracion.EVTnombre#</strong></td>
					</cfif>
					<tr> 
						<td align="center" class="subrayado">#rsEscValoracion.EVvalor# = #rsEscValoracion.EVdescripcion#</td>
					</tr>
				</cfloop>	
			</cfoutput>
		</cfif>
        </cfif>
        <cfset vAlumno ="#rsNotasFinales.NombreAl#">
        <cfset vMateria ="">
        <cfset vContMaterias = 0>
        <cfset NumAplazos = 0>
        <cfset HayEstado = 0><cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PxA' and vContAlumnos GT 1 and isdefined('form.imprime')>
        <tr> 
          <td align="center"> 
            ------------------ Fin del Reporte ------------------ </td>
        </tr>
      </table></td>
  </tr>
  <tr class="pageEnd"> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3"> <table width="100%" border="0" cellspacing="1" cellpadding="1">
        <tr> 
          <td> <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr class="tituloAlterno"> 
                <td width="100%" colspan="3" align="center" class="tituloAlterno"> 
                  <strong> 
                  <cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
                    <cfoutput>#form.TituloRep#</cfoutput> 
                    <cfelse>
                    REPORTE DE NOTAS FINALES 
                  </cfif>
                  </strong> </td>
              </tr>
            </table></td>
        </tr></cfif>
        <tr> 
          <td class="areaFiltro"> <table width="100%" border="0" cellspacing="1" cellpadding="1">
              <tr> 
                <td width="50%">Alumno :#rsNotasFinales.NombreAl#</td>
                <td width="50%">Grupo: #rsNotasFinales.GRnombre#</td>
              </tr>
              <tr> 
                <td>Nivel: #rsNotasFinales.Ndescripcion#</td>
                <cfif not isdefined('url.imprimir')>
                  <cfquery name="rsSinNotas" dbtype="query">
                  select count(Calificacion_Final) as SinNota from rsNotasFinales 
                  where NombreAl = 
                  <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
                  and Calificacion_Final is null 
                  </cfquery>
                  <cfif rsSinNotas.SinNota GT 0>
                    <td>Nota: 
                      Las calificaciones con asterisco (<FONT color="Red" >*</font>) 
                      no han sido cerrados por el Docente en el curso final</td>
                    <cfelse>
                    &nbsp; 
                  </cfif>
                  <cfelse>
                  <td>&nbsp; </td>
                </cfif>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td> <table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
              <tr> 
                <td width="4%">&nbsp;</td>
                <td><strong>MATERIA</strong></td>
                <cfset numPeriodos = 0>
                <cfloop query="rsPeriodos">
                  <cfset numPeriodos = numPeriodos +1>
                  <td width="15%" align="center"><strong>#rsPeriodos.PEdescripcion#</strong></td>
                </cfloop>
                <td width="15%" align="center"><strong>%Promedio</strong></td>
              </tr>
            </table></td>
        </tr></cfif>
        <cfif vMateria NEQ rsNotasFinales.Mconsecutivo>
          <cfset vContMaterias = vContMaterias + 1>
          <cfif vContMaterias GT 0>
            <cfset vMateria ="#rsNotasFinales.Mconsecutivo#">
            <cfset vMateriaDescr ="#rsNotasFinales.Mnombre#">
            <tr> 
              <td> 
                <cfif rsNotasFinales.Orden EQ 3  and NumTitElect EQ 0>
                  <table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
                    <cfset NumTitElect = 1>
                    <tr> 
                      <td width="4%">&nbsp;</td>
                      <td><strong>ELECTIVAS</strong></td>
                    </tr>
                  </table>
                </cfif> </td>
            </tr>
            <tr> 
              <td> <table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
                  <tr> 
                    <td width="4%">&nbsp;</td>
                    <td>#vMateriaDescr#</td>
                    <cfquery name="rsNotas" dbtype="query">
						select * from rsNotasFinales 
						where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
						  and Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">
						order by PEorden 
                    </cfquery>
                    <cfset cant = 0>
                    <cfset PeriodoNotas =  rsNotas.PEdescripcion>
                    <!--- Inicio Calificaciones por periodo --->
					
					<cfset cant = 0>
					<cfif rsNotas.Mtipoevaluacion EQ '0'>
						<cfset PeriodoNotas =  rsNotas.PEdescripcion>
						<cfif rsPeriodos.RecordCount EQ rsNotas.Recordcount>
							<cfloop query="rsNotas">
								<td width="15%" align="center">
									<cfif rsNotas.Orden EQ 1 and rsNotas.Orden_Comp EQ 0>
										<cfif rsNotas.Calificacion_Periodo LT rsNotas.NotaMinima and IsNumeric(rsNotas.Calificacion_Periodo)>
											<!--- <FONT color="Red" > ---><b>#LSNumberFormat(rsNotas.Calificacion_Periodo,"0.00")#</b><!--- </font> --->
										<cfelseif rsNotas.Calificacion_Periodo GTE rsNotas.NotaMinima and IsNumeric(rsNotas.Calificacion_Periodo)>
											<b>#LSNumberFormat(rsNotas.Calificacion_Periodo,"0.00")#</b>
										<cfelseif not IsNumeric(rsNotas.Calificacion_Periodo)>	
											#rsNotas.Calificacion_Periodo#		  
										</cfif>	
									<cfelse>
										<cfif rsNotas.Calificacion_Periodo LT rsNotas.NotaMinima and IsNumeric(rsNotas.Calificacion_Periodo)>
											<!--- <FONT color="Red" > --->#LSNumberFormat(rsNotas.Calificacion_Periodo,"0.00")#<!--- </font> --->
										<cfelseif rsNotas.Calificacion_Periodo GTE rsNotas.NotaMinima and IsNumeric(rsNotas.Calificacion_Periodo)>
											#LSNumberFormat(rsNotas.Calificacion_Periodo,"0.00")#
										<cfelseif not IsNumeric(rsNotas.Calificacion_Periodo)>	
											#rsNotas.Calificacion_Periodo#
										</cfif>
									</cfif>
									
								</td>
							 </cfloop>  	
						<cfelse>
					
								<cfset NombrePeriodo = "">
								 <cfloop query="rsPeriodos">
									<cfset NombrePeriodo =  rsPeriodos.PEdescripcion>
									<cfquery name="rsNotasPeriodo" dbtype="query">
										 select *
										 from rsNotas
										 where PEdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#NombrePeriodo#"> 
									</cfquery>
									
									<cfif rsNotasPeriodo.RecordCount GT 0 and rsNotasPeriodo.PEdescripcion EQ rsPeriodos.PEdescripcion >
											<td width="15%" align="center">
												<cfif rsNotasPeriodo.Orden EQ 1 and rsNotasPeriodo.Orden_Comp EQ 0>
													<cfif  rsNotasPeriodo.Calificacion_Periodo LT rsNotasPeriodo.NotaMinima and IsNumeric(rsNotasPeriodo.Calificacion_Periodo)>
														<!--- <FONT color="Red" > ---><b>#LSNumberFormat(rsNotasPeriodo.Calificacion_Periodo,"0.00")#</b><!--- </font> --->
													<cfelseif rsNotasPeriodo.Calificacion_Periodo GTE rsNotasPeriodo.NotaMinima and IsNumeric(rsNotasPeriodo.Calificacion_Periodo)>
														<b>#LSNumberFormat(rsNotasPeriodo.Calificacion_Periodo,"0.00")#</b>
													<cfelseif not IsNumeric(rsNotasPeriodo.Calificacion_Periodo)>	
														#rsNotasPeriodo.Calificacion_Periodo#
													</cfif>
												<cfelse>
													<cfif rsNotasPeriodo.Calificacion_Periodo LT rsNotasPeriodo.NotaMinima and IsNumeric(rsNotasPeriodo.Calificacion_Periodo)>
														<!--- <FONT color="Red"> --->#LSNumberFormat(rsNotasPeriodo.Calificacion_Periodo,"0.00")#<!--- </font> --->
													<cfelseif rsNotasPeriodo.Calificacion_Periodo GTE rsNotasPeriodo.NotaMinima and IsNumeric(rsNotasPeriodo.Calificacion_Periodo)>
														#LSNumberFormat(rsNotasPeriodo.Calificacion_Periodo,"0.00")#
													<cfelseif not IsNumeric(rsNotasPeriodo.Calificacion_Periodo)>	
														#rsNotasPeriodo.Calificacion_Periodo#
													</cfif>
												</cfif>
												<cfif rsNotasPeriodo.EVTcodigo NEQ 0 and isNumeric(rsNotasPeriodo.Calificacion_Periodo)>
													<!--- aqui va el Valor de los cursos pintados --->
													<cfquery datasource="#Session.Edu.DSN#" name="rsEvaluacionValores">
														select EVTcodigo , EVvalor, EVdescripcion, EVequivalencia
														from EvaluacionValores
														where EVTcodigo = #rsNotasPeriodo.EVTcodigo#
														  and EVminimo <= #rsNotasPeriodo.Cal_Per#
														  and EVmaximo >= #rsNotasPeriodo.Cal_Per#
													</cfquery>
													<cfif rsEvaluacionValores.RecordCount GT 0>
														= #rsEvaluacionValores.EVvalor# 
													</cfif>
												</cfif>
											</td>
									<cfelse>		
										<td width="15%" align="center">&nbsp;</td>
									</cfif> 
								</cfloop>
						</cfif>
					<cfelse>	
						<cfif rsPeriodos.RecordCount EQ rsNotas.Recordcount>
							<cfloop query="rsNotas">
								<td width="15%" align="center">
								 #LSNumberFormat(rsNotas.Cal_Per,"0.00")# 
									<!--- aqui va el Valor de los cursos pintados --->
									<cfquery datasource="#Session.Edu.DSN#" name="rsEvaluacionValores">
										select EVTcodigo , EVvalor, EVdescripcion, EVequivalencia
										from EvaluacionValores
										where EVTcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNotas.EVTcodigo#">  
										  and EVminimo <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNotas.Cal_Per#"> 
										  and EVmaximo >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNotas.Cal_Per#"> 
									</cfquery>

									<cfif rsEvaluacionValores.RecordCount GT 0>
										= #rsEvaluacionValores.EVvalor# 
									</cfif>
								</td>
							</cfloop>
						<cfelse>
								<cfset NombrePeriodo = "">
								<cfloop query="rsPeriodos">
									<cfset NombrePeriodo =  rsPeriodos.PEdescripcion>
									<cfquery name="rsNotasPeriodo" dbtype="query">
										 select *
										 from rsNotas
										 where PEdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#NombrePeriodo#"> 
									</cfquery>
									<cfif rsNotasPeriodo.RecordCount GT 0 and rsNotasPeriodo.PEdescripcion EQ rsPeriodos.PEdescripcion >
										<td width="15%" align="center">
										#LSNumberFormat(rsNotasPeriodo.Cal_Per,"0.00")#  
											<!--- aqui va el Valor de los cursos pintados --->
											<cfquery datasource="#Session.Edu.DSN#" name="rsEvaluacionValores">
												select EVTcodigo , EVvalor, EVdescripcion, EVequivalencia
												from EvaluacionValores
												where EVTcodigo = #rsNotasPeriodo.EVTcodigo#
												  and EVminimo <= #rsNotasPeriodo.Cal_Per#
												  and EVmaximo >= #rsNotasPeriodo.Cal_Per#
											</cfquery>
											<cfif rsEvaluacionValores.RecordCount GT 0>
												= #rsEvaluacionValores.EVvalor# 
											</cfif>
										</td>
									<cfelse>		
										<td width="15%" align="center">&nbsp;</td>
									</cfif> 
								</cfloop>		
						</cfif> <!--- si hay la misma cantidad de notas y periodos --->
					</cfif> <!--- fin de Mtipoevaluacion = '0' --->
					<!--- Inicio promedio final del Curso  --->
					<cfif rsNotas.Calificacion_Final GT 0>
						<td width="15%" align="center">
							<strong>
								<cfif rsNotas.Mtipoevaluacion EQ '1'>
									#LSNumberFormat(rsNotas.Cal_Per,"0.00")# =
								</cfif>
								<cfif IsNumeric(rsNotas.Calificacion_Final)>
									#LSNumberFormat(rsNotas.Calificacion_Final,"0.00")#&nbsp; 
								<cfelse>
									#rsNotas.Calificacion_Final#
								</cfif>	
							</strong>
							</td>
					<cfelse>
						<cfquery name="rsNotasPromedio" dbtype="query">
								select sum(Cal_Per) as Promedio, max(EVTcodigo) as EVTcodigo,
								count(*) as num  
								from rsNotasFinales
								where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
								  and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#">  
								group by Mconsecutivo
						</cfquery>
						<cfloop query="rsNotasPromedio">
							<td width="15%" align="center">
								<strong>
									<cfset prom = rsNotasPromedio.Promedio / rsNotasPromedio.num > 
									#LSNumberFormat(prom,"0.00")# 
									<cfif rsNotasPromedio.EVTcodigo NEQ 0 >
										<!--- aqui va el Valor de los cursos pintados --->
										<cfquery datasource="#Session.Edu.DSN#" name="rsEvaluacionValores">
											select EVTcodigo , EVvalor, EVdescripcion, EVequivalencia
											from EvaluacionValores
											where EVTcodigo = #rsNotasPromedio.EVTcodigo#
											  and EVminimo <= #prom#
											  and EVmaximo >= #prom#
										</cfquery>
										<cfif rsEvaluacionValores.RecordCount GT 0>
											= #rsEvaluacionValores.EVvalor# 
										</cfif>
									</cfif>
									<cfif isdefined('form.rdCortes') and not isdefined('url.btnGenerar')>
										<FONT color="Red">*</font>
									</cfif>
								</strong>
							</td>
						</cfloop>
					</cfif>

					<!--- Fin promedio final del Curso --->
                   
                  </tr>
                </table></td>
            </tr>
          </cfif>
        </cfif></cfoutput></cfloop>
        <cfoutput> 
          <cfif vContMaterias GT 0>
            <tr> 
              <td> 
                <table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
                  <cfif rsNotasFinales.Orden EQ 3 and NumTitElect EQ 0>
                    <cfset NumTitElect = 1>
                    <tr> 
                      <td width="4%">&nbsp;</td>
                      <td><strong>ELECTIVAS</strong></td>
                    </tr>
                    <tr> 
                      <td width="4%">&nbsp;</td>
                      <td><strong>#rsNotasFinales.MateriaElectiva# :</strong></td>
                    </tr>
                  </cfif>
                </table></td>
            </tr>
            <tr> 
              <td> <table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
                  <tr> 
                    <td  nowrap width="4%">&nbsp;</td>
                    <td><strong>PROMEDIO FINAL</strong> <cfset prom = 0> <cfquery name="rsPromedio" dbtype="query">
                      select sum(Cal_Per) as Promedio, count(*) as num , max(EstadoPeriodo) 
                      as EstadoPeriodo from rsNotasFinales where NombreAl = 
                      <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
                      and Cal_Per > 0 and Orden in (0,1,3) and Orden_Comp in (0) 
                      group by PEdescripcion </cfquery> </td>
                    <cfloop query="rsPromedio">
                      <cfif rsPeriodos.RecordCount EQ rsPromedio.Recordcount>
                        <td width="15%" align="center"> 
                          <strong> 
                          <cfset prom = rsPromedio.Promedio / rsPromedio.num >
                          #LSNumberFormat(prom,"0.00")# </strong> </td>
                        <cfelse>
                        <cfloop  query="rsPeriodos">
                          <cfif rsPromedio.PEdescripcion EQ rsPeriodos.PEdescripcion >
                            <cfset prom = rsPromedio.Promedio / rsPromedio.num >
                            <td width="15%" align="center"><strong>#LSNumberFormat(prom,"0.00")#</strong></td>
                            <cfelse>
                            <td width="15%" align="center">&nbsp; 
                            </td>
                          </cfif>
                        </cfloop>
                      </cfif>
                    </cfloop>
                    <cfset PromFin = 0>
                    <cfquery name="rsPromedioFin" dbtype="query">
                    select sum(Cal_Per) as PromedioFin, count(*) as numFin, max(EstadoPeriodo) 
                    as EstadoPeriodo from rsNotasFinales where NombreAl = 
                    <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
                    and Cal_Per > 0 and Orden in (0,1,3) and Orden_Comp in (0) 
                    group by NombreAl 
                    </cfquery>
                    <td width="15%" align="center" >
						<strong> 
							<cfif rsNotasFinales.Mtipoevaluacion EQ '1'>
								 #LSNumberFormat(rsNotasFinales.Cal_Per,"0.00")# =
							</cfif>
							<cfoutput>
								<cfif len(trim(rsPromedioFin.PromedioFin)) GT 0 and  len(trim(rsPromedioFin.NumFin)) GT 0>
									<cfset UltPromGen = rsPromedioFin.PromedioFin / rsPromedioFin.NumFin>
									 #LSNumberFormat(UltPromGen,"0.00")# 
								<cfelse>
									&nbsp; 	
								</cfif>
							</cfoutput>
						</strong>
				   </td> 
                  </tr>
                </table></td>
            </tr>
            <tr> 
              <td  class="areaFiltro" align="center"><strong>ESCALA DE VALORACI&Oacute;N</strong></td>
            </tr>
          	<cfquery name="rsEvaluacValores" dbtype="query">
				Select distinct EVTcodigo
				from rsNotasFinales
				where NombreAl =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#vAlumno#">
			</cfquery>	
			<cfif rsEvaluacValores.recordCount GT 0>
				<cfset ListaEVTcodigos = ValueList(rsEvaluacValores.EVTcodigo)>
				<cfif ListLen(ListaEVTcodigos) GT 0>
					<cfquery datasource="#Session.Edu.DSN#" name="rsEscValoracion">
						select EVvalor, EVdescripcion, ev.EVTcodigo, EVorden, EVTnombre
						from EvaluacionValoresTabla evt, EvaluacionValores ev
						where CEcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
							and evt.EVTcodigo=ev.EVTcodigo
							and evt.EVTcodigo in (#ListaEVTcodigos#)
						order by ev.EVTcodigo, EVorden
					</cfquery>
					
				</cfif> 
			</cfif>
			<cfif rsEscValoracion.RecordCount EQ 0>
				<tr> 
				  <td align="center"  class="subrayado">N / A = No Aplica</td>
				</tr>
			</cfif>
			<cfset Tabla_desc = "">
			<cfloop query="rsEscValoracion">
				<cfif rsEscValoracion.EVTnombre NEQ Tabla_desc >
					<cfset Tabla_desc = rsEscValoracion.EVTnombre>
					<td align="center" class="subrayado"><strong>#rsEscValoracion.EVTnombre#</strong></td>
				</cfif>
				<tr> 
					<td align="center" class="subrayado">#rsEscValoracion.EVvalor# = #rsEscValoracion.EVdescripcion#</td>
				</tr>										
			</cfloop>
          </cfif>
        </cfoutput> 
      </table>
      <cfelse> &nbsp; </cfif> </td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="1" cellpadding="1">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center">------------------ Fin del Reporte ------------------</td>
	</tr>
				
	<cfif not isdefined("Url.imprimir")>
		<cfoutput>
			<tr>
				<td align="right">
					<input type="button"  name="imprime" value="Imprimir Reporte" onClick="javascript:printURL('imprime/ListaNotasFinalesEncImpr.cfm?Ecodigo=#Ecodigo#&Grupo=#form.Grupo#&imprimir=1');">
				</td>
			</tr>
		</cfoutput>		
	</cfif>
</table>

