<cfif isdefined("Form.btnGenerar")>
		<cfquery name="rsPeriodoReporte" datasource="#Session.Edu.DSN#">
			select PEdescripcion
			from PeriodoEvaluacion pe, Nivel n
			where CEcodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and pe.Ncodigo	= n.Ncodigo
				and pe.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			order by PEorden
		</cfquery>
		
		<cfquery name="cons1" datasource="#Session.Edu.DSN#">
			select *
			from sp_EVALUACIONES 
			where TipoNI = 'I'
			order by Norden, Gorden, Morden, Cnombre, NombreAl, fecha asc
		</cfquery>
	
	</cfif> 
		 <cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
			select CEnombre from CentroEducativo
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		</cfquery>			
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">		
 <cfif isdefined("form.btnGenerar")>
 	<cfset maxCols = 3>
 	<cfif cons1.recordCount GT 0>
	<!--- 	<cfif cons1.recordCount GT 0 > --->
	<cfset Prof = "">
	<cfset Materia = "">
	<cfset NombreAlumno = "">
	<cfoutput> 
		<table width="100%" cellspacing="0" >
			<cfloop query="cons1">
				<cfif Materia NEQ cons1.Mnombre>
					<cfset Materia = Cons1.Mnombre>
					<!--- <cfset Concepto = Cons1.NombConcepto> --->
					<cfif #form.rdCortes# EQ 'CxG' and #cons1.CurrentRow# NEQ 1 and isdefined("url.rdCortes")>
						<!--- <table border="0" cellpadding="0" cellspacing="0" width="100%"> --->
						<tr class="pageEnd"> 
							<td colspan="10" valign="top">&nbsp;</td>
						</tr>
						<tr class="area"> 
							<td colspan="9">Servicios 
							Digitales al Ciudadano</td>
							<!--- <td width="20%">&nbsp;</td> --->
							<td width="12%"  align="right">Fecha: 
							#LSdateFormat(Now(),'dd/MM/YY')#</td>
						</tr>
						<tr class="area"> 
							<td colspan="9">www.migestion.net</td>
							<!--- <td>&nbsp;</td> --->
							<td align="right">Hora: 
							#TimeFormat(Now(),"hh:mm:ss")# </td>
						</tr>
						<tr class="area" align="center"> 
							<td colspan="10" class="tituloAlterno" align="center"> 
							<strong>Listado de Incidencias por Alumno</strong></td>
						</tr>
						<tr> 
							<td colspan="10" class="tituloAlterno" align="center">#rsCentroEducativo.CEnombre#</td>
						</tr>
						<tr> 
						<td height="22" colspan="10">&nbsp;</td>
						</tr>
						<!--- </table>  --->
					</cfif>
					<!--- <cfif Prof NEQ cons1.Profesor> --->
				<!--- 	<cfset Prof = cons1.Profesor>
					<cfif #form.rdCortes# EQ 'CxG' and #cons1.CurrentRow# NEQ 1 and isdefined("url.rdCortes")>
						<tr class="subTitulo"> 
							<td width="21%"  align="left" nowrap   class="encabReporte" ><strong>Profesor: 
							&nbsp; &nbsp; #cons1.Profesor# &nbsp; </strong></td>
							<td colspan="9" align="right" nowrap  class="encabReporte" ><strong> 
							&nbsp; </strong></td>
						</tr>
					</cfif> --->
					<!--- pintar aqui los datos de la Alumno --->
					<tr class="subTitulo"> 
						
              <td  width="21%" align="left"  nowrap  class="encabReporte" style="border: 1px solid ##000000"><strong><font size="1">Materia: 
                </font>&nbsp; &nbsp; #Cons1.Mnombre# &nbsp; </strong></td>
						<td colspan="3" align="center"  nowrap  class="encabReporte" style="border: 1px solid ##000000"><strong>Observaciones:&nbsp;</strong></td>
						<td colspan="6" align="center"  nowrap  class="encabReporte"  style="border: 1px solid ##000000"><strong> 
						&nbsp; &nbsp; </strong><strong>Asistencia:&nbsp; &nbsp; &nbsp; 
						</strong></td>
						<!--- <td  width="20%"align="left"  class="encabReporte"  nowrap ><strong>&nbsp; </strong></td> --->
					</tr>
					<tr > 
						<td width="21%" nowrap style="border: 1px solid ##000000"><strong>Incidencias:</strong></td>
						<td width="9%" align="center" valign="top" nowrap style="border: 1px solid ##000000">Reforzamiento</td>
						<td width="6%" align="center" valign="top" style="border: 1px solid ##000000">Llamada de Atenci&oacute;n</td>
						<td width="11%" align="center" valign="top" nowrap style="border: 1px solid ##000000">Advertencia</td>
						<td colspan="2" align="center" valign="top" nowrap style="border: 1px solid ##000000">Ausencias</td>
						<td colspan="2" align="center" valign="top" nowrap style="border: 1px solid ##000000">Llegada Tard&iacute;a </td>
						<td colspan="2" align="center" valign="top" nowrap style="border: 1px solid ##000000">Salida Temprano </td>
					</tr>
					<tr class="subTitulo" <cfif #cons1.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #cons1.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" > 
						
						<td width="21%" nowrap style="border: 1px solid ##000000">
						<!--- <cfif Compare(Trim(NombreNombreAl),Trim(cons1.NombreAl)) EQ 0> --->
							
					  Alumno: 
					<!---   <cfelse>
							&nbsp; 
						</cfif>  --->
						</td>
						<td width="9%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
						<td width="6%" nowrap align="center" style="border: 1px solid ##000000">&nbsp;</td>
						<td width="11%" align="center" nowrap style="border: 1px solid ##000000">&nbsp;</td>
						<td width="9%" nowrap align="center" style="border: 1px solid ##000000">Just</td>
						<td width="8%" nowrap align="center" style="border: 1px solid ##000000">Injust</td>
						<td width="8%" nowrap align="center" style="border: 1px solid ##000000">Just</td>
						<td width="10%" nowrap align="center" style="border: 1px solid ##000000">Injust</td>
						<td width="6%" align="center"  nowrap style="border: 1px solid ##000000">Just</td >
						<td  nowrap align="center" style="border: 1px solid ##000000">Injust</td>
					</tr>
				</cfif>
				<cfif "#NombreAlumno#" NEQ "#cons1.NombreAl#">
					<cfset NombreAlumno = cons1.NombreAl>
					<tr class="subTitulo" <cfif cons1.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif cons1.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" > 
						<td width="21%" nowrap  style="border: 1px solid ##000000" >
							#NombreAlumno# 
						</td>
						<td width="9%" nowrap align="center"  style="border: 1px solid ##000000">
							<cfif len(trim(#cons1.codigo#)) NEQ 0 >
							<!--- 	<cfif len(trim(#cons1.justificado#)) EQ 0> --->
									<cfquery name="rsObservacion" dbtype="query">
										 select count(codigo) as R
										 from cons1
										 where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#NombreAlumno#">
										   and Mnombre  = <cfqueryparam cfsqltype="cf_sql_char" value="#Materia#"> 
										   and tipo = 'O'
										   and subtipo = 'P'
									</cfquery>
									<cfif rsObservacion.RecordCount NEQ 0>
										#rsObservacion.R#
									<cfelse>
									 	&nbsp;
									</cfif>
								<!--- </cfif> --->
							<cfelse>
								&nbsp;
							</cfif> 
						</td>
						<td width="6%" nowrap align="center"  style="border: 1px solid ##000000">
							<cfif len(trim(#cons1.codigo#)) NEQ 0 >
							<!--- 	<cfif len(trim(#cons1.justificado#)) EQ 0> --->
									<cfquery name="rsObservacion" dbtype="query">
										 select count(codigo) as N
										 from cons1
										 where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#NombreAlumno#">
										   and Mnombre  = <cfqueryparam cfsqltype="cf_sql_char" value="#Materia#"> 
										   and tipo = 'O'
										   and subtipo = 'N'
									</cfquery>
									<cfif rsObservacion.RecordCount NEQ 0>
										#rsObservacion.N#
									<cfelse>
									 	&nbsp;
									</cfif>
								<!--- </cfif> --->
							<cfelse>
								&nbsp;
							</cfif> 
						</td>
						<td width="11%" align="center" nowrap  style="border: 1px solid ##000000">
							<cfif len(trim(#cons1.codigo#)) NEQ 0 >
							<!--- 	<cfif len(trim(#cons1.justificado#)) EQ 0> --->
									<cfquery name="rsObservacion" dbtype="query">
										 select count(codigo) as A
										 from cons1
										 where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#NombreAlumno#">
										   and Mnombre  = <cfqueryparam cfsqltype="cf_sql_char" value="#Materia#"> 
										   and tipo = 'O'
										   and subtipo = 'A'
									</cfquery>
									<cfif rsObservacion.RecordCount NEQ 0>
										#rsObservacion.A#
									<cfelse>
									 	&nbsp;
									</cfif>
								<!--- </cfif> --->
							<cfelse>
								&nbsp;
							</cfif> 
						</td>
						<td width="9%" nowrap align="center"  style="border: 1px solid ##000000">
							<cfif len(trim(#cons1.codigo#)) NEQ 0 >
								<!--- <cfif #cons1.justificado# EQ 'S'> --->
									<cfquery name="rsAsistencia" dbtype="query">
										 select count(codigo) as AJ
										 from cons1
										 where justificado = 'S'
										   and NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#NombreAlumno#">
										   and Mnombre  = <cfqueryparam cfsqltype="cf_sql_char" value="#Materia#"> 
										   and tipo = 'A'
										   and subtipo = 'A'
									</cfquery>
									<cfif rsAsistencia.RecordCount NEQ 0>
										#rsAsistencia.AJ#
									<cfelse>
										&nbsp;
									</cfif>
								<!--- </cfif> --->
							<cfelse>
								&nbsp;
							</cfif> 
						</td>
						<td width="8%" nowrap align="center"  style="border: 1px solid ##000000">
							<cfif len(trim(#cons1.codigo#)) NEQ 0 >
								<!--- <cfif len(trim(#cons1.justificado#)) EQ 0> --->
									<cfquery name="rsAsistencia" dbtype="query">
										 select count(codigo) as AIJ
										 from cons1
										 where justificado = 'N'
										   and NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#NombreAlumno#">
										   and Mnombre  = <cfqueryparam cfsqltype="cf_sql_char" value="#Materia#"> 
										   and tipo = 'A'
										   and subtipo = 'A'
									</cfquery>
									<cfif rsAsistencia.RecordCount NEQ 0>
										#rsAsistencia.AIJ#
									<cfelse>
										&nbsp;
									</cfif>
								<!--- </cfif> --->
							<cfelse>
								&nbsp;
							</cfif> 
						</td>
						<td width="8%" nowrap align="center"  style="border: 1px solid ##000000">
							<cfif len(trim(#cons1.codigo#)) NEQ 0 >
									<cfquery name="rsAsistencia" dbtype="query">
										 select count(codigo) as TJ
										 from cons1
										 where justificado = 'S'
										   and NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#NombreAlumno#">
										   and Mnombre  = <cfqueryparam cfsqltype="cf_sql_char" value="#Materia#"> 
										   and tipo = 'A'
										   and subtipo = 'T'
									</cfquery>
									<cfif rsAsistencia.RecordCount NEQ 0>
										#rsAsistencia.TJ#
									<cfelse>
										&nbsp;
									</cfif>
							<cfelse>
								&nbsp;
							</cfif> 
						</td>
						<td width="10%" nowrap align="center"  style="border: 1px solid ##000000">
							<cfif len(trim(#cons1.codigo#)) NEQ 0 >
								<cfquery name="rsAsistencia" dbtype="query">
									 select count(codigo) as TIJ
									 from cons1
									 where justificado = 'N'
									   and NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#NombreAlumno#">
									   and Mnombre  = <cfqueryparam cfsqltype="cf_sql_char" value="#Materia#"> 
									   and tipo = 'A'
									   and subtipo = 'T'
									</cfquery>
									<cfif rsAsistencia.RecordCount NEQ 0>
										#rsAsistencia.TIJ#
									<cfelse>
										&nbsp;	
									</cfif>
							<cfelse>
								&nbsp;
							</cfif> 
						</td>
						<td width="6%" align="center"  nowrap  style="border: 1px solid ##000000">
							<cfif len(trim(#cons1.codigo#)) NEQ 0 >
									<cfquery name="rsAsistencia" dbtype="query">
										 select count(codigo) as RT
										 from cons1
										 where justificado = 'S'
										   and NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#NombreAlumno#">
										   and Mnombre  = <cfqueryparam cfsqltype="cf_sql_char" value="#Materia#"> 
										   and tipo = 'A'
										   and subtipo = 'R'
									</cfquery>
									<cfif rsAsistencia.RecordCount NEQ 0>
										#rsAsistencia.RT#
									<cfelse>
										&nbsp;
									</cfif>
							<cfelse>
								&nbsp;
							</cfif> 
						</td >
						<td  nowrap align="center"  style="border: 1px solid ##000000">
							<cfif len(trim(#cons1.codigo#)) NEQ 0 >
								<!--- <cfif len(trim(#cons1.justificado#)) EQ 0> --->
									<cfquery name="rsAsistencia" dbtype="query">
										 select count(codigo) as RTIJ
										 from cons1
										 where justificado = 'N'
										   and NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#NombreAlumno#">
										   and Mnombre  = <cfqueryparam cfsqltype="cf_sql_char" value="#Materia#"> 
										   and tipo = 'A'
										   and subtipo = 'R'
									</cfquery>
									<cfif rsAsistencia.RecordCount NEQ 0>
										#rsAsistencia.RTIJ#
									<cfelse>
										&nbsp;
									</cfif>
								<!--- </cfif> --->
							<cfelse>
								&nbsp;
							</cfif> 
						</td>
					</tr>
				</cfif> 
				<cfif len(trim(cons1.codigo)) NEQ 0>
					<tr class="subTitulo" <cfif cons1.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif cons1.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" > 
						<td width="21%" style="border-left: 1px solid ##000000" >&nbsp;
						
						</td>
						<td align="center" width="9%"  style="border: 1px solid ##000000">
						#LSdateFormat(cons1.fecha,'dd/MM/YYYY')#	
						</td>
						<td width="70%" colspan="8"  style="border: 1px solid ##000000">
							#cons1.descripcion#
						</td>
					</tr>
				</cfif>
		</cfloop>
		</table>
		</cfoutput> 
			<table width="100%"  cellspacing="0">
				<tr> 
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="4" align="center"> ------------------ Fin del Reporte ------------------ </td>
				</tr>
			</table>
		<!--- </cfif> --->
	<cfelse>
		<table width="100%" border="1" cellspacing="0"> 			
			<tr> 
				
        <td colspan="4" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">La 
          Materia no tiene Incidencias definidos para ese periodo</td>
			</tr>
			<tr> 
				<td colspan="4" align="center"> ------------------ 1 - No existen 
				Incidencias, para la Materia solicitada  ------------------ </td>
			</tr>
			<tr> 
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr> 
				<td colspan="4" align="center"> ------------------ Fin del Reporte ------------------ </td>
			</tr>
		</table>
	</cfif>
</cfif>