<cfinclude template="/edu/Utiles/general.cfm">
<html>
<head>
<title>Salida de Notas según tabla de Evaluación</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link href="/cfmx/edu/css/sif.css" rel="stylesheet" type="text/css">
</head>
<body>
	<cfif isdefined("Url.Ncodigo") and not isdefined("Form.Ncodigo")>
		<cfparam name="Form.Ncodigo" default="#Url.Ncodigo#">
	</cfif>
	<cfif isdefined("Url.GRcodigo") and not isdefined("Form.GRcodigo")>
		<cfparam name="Form.GRcodigo" default="#Url.GRcodigo#">
	</cfif>
	<cfif isdefined("Url.form") and not isdefined("Form.form")>
		<cfparam name="Form.form" default="#Url.form#">
	</cfif>
	<cfif isdefined("Url.cursos") and not isdefined("Form.cursos")>
		<cfparam name="Form.cursos" default="#Url.cursos#">
	</cfif>
	 <cfquery name="rsCursoLectivo" datasource="#Session.Edu.DSN#">
		set nocount on 
			select distinct convert(varchar, c.SPEcodigo) as SPEcodigo
			from Nivel a
					, PeriodoEscolar b
					, SubPeriodoEscolar c
					, PeriodoVigente 
			d where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ncodigo = b.Ncodigo 
				and b.PEcodigo = c.PEcodigo 
				and a.Ncodigo = d.Ncodigo 
				and b.PEcodigo = d.PEcodigo 
				and c.SPEcodigo = d.SPEcodigo 
			order by a.Norden 
		set nocount off 
	</cfquery>
	<cfloop query="rsCursoLectivo">
		<cfset codCursoLectivo = rsCursoLectivo.SPEcodigo>
		<cfbreak>
	</cfloop>
	<cfquery datasource="#Session.Edu.DSN#" name="rsCursos">
		select convert(varchar,c.Ccodigo) as Ccodigo,
		Cnombre=case m.Melectiva
			when 'S' then c.Cnombre
			else m.Mnombre + ' - ' + gr.GRnombre
		end,
		Ctabla=case
			when m.EVTcodigo is null then 0
			else 1
		end
		from Curso c, Materia m, Grupo gr, Grado g
		where m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
			and c.Mconsecutivo = m.Mconsecutivo
			and c.GRcodigo *= gr.GRcodigo
			and m.Gcodigo *= g.Gcodigo
			and (c.GRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GRcodigo#">
				or (c.GRcodigo is null and m.Melectiva = 'S'))
		order by g.Gorden,m.Morden
	</cfquery>
	
	<cfif isdefined("Form.checkTabla")>
		<cfset codigosTablas = Form.checkTabla & ",">
	</cfif>
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td></td>
              </tr>
              <tr> 
    <td align="center"> 
      <form name="filtros" action="../consultas/ConlisMateriaTabla.cfm" method="post">
        &nbsp; <strong>Materias del Nivel para mostrar según Tablas de Evaluación:</strong> 
      </form></td>
              </tr>
              <tr> 
                <!--- <td><strong> &nbsp;&nbsp;&nbsp; 
                  <input name="chkTodos" type="checkbox" value="" border="1" onClick="javascript:Marcar(this);">
                  Seleccionar Todos</strong></td> --->
				  
				  
              </tr>
              <tr> 
                <td>
					<form name="lista" method="post" action="../consultas/ConlisMateriaTabla.cfm">
					<input type="hidden" name="Ncodigo" value="<cfif isdefined("Form.Ncodigo")><cfoutput>#Form.Ncodigo#</cfoutput></cfif>">
				<!--- 	<input type="hidden" name="Gnombre" value="<cfif isdefined("Form.Gnombre")><cfoutput>#Form.Gnombre#</cfoutput></cfif>"> --->
					<input name="Cual_Grupo" type="hidden" id="Cual_Grupo" value="">
					<input name="Cual_Nivel" type="hidden" id="Cual_Nivel" value="">
					<input name="Cual_Materia" type="hidden" id="Cual_Materia" value="">
					<input name="form" type="hidden" id="form" value="<cfoutput>#form.form#</cfoutput>">
					<input name="cursos" type="hidden" id="cursos" value="<cfoutput>#form.form#</cfoutput>">
					<input name="GRcodigo" type="hidden" id="GRcodigo" value="<cfif isdefined("Form.GRcodigo")><cfoutput>#Form.GRcodigo#</cfoutput></cfif>">
					<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
                    	<cfset Pagenum_lista = #Form.Pagina#>
                  	</cfif> 
					
					<cfif isdefined("rsCursos")>
						<tr>
							<td colspan="2">
								<table border="0" cellpadding="0" cellspacing="0" width="80%">
									<tr> 
										<td class="subTitulo">&nbsp;</td>
										<td class="subTitulo">Curso</td>
										<td class="subTitulo" style="text-align:center">Usar Tabla</td>
									</tr>
									<cfset hayTablas = 0>
									
									<cfoutput query="rsCursos">
										<cfif rsCursos.Ctabla EQ 1>
											<tr>
												<td>
				
												</td>
												<td>
													#rsCursos.Cnombre#
												</td>
												<td style="text-align:center">
													<span style="visibility:<cfif rsCursos.Ctabla EQ 1><cfset hayTablas = 1>visible<cfelse>hidden</cfif>">
													<input type="checkbox" name="checkTabla" value="#rsCursos.Ccodigo#" class="areaFiltro"
													<cfif (isdefined("codigosTablas") AND Find(rsCursos.Ccodigo&",",codigosTablas) IS NOT 0)
													OR isdefined("Form.chkTodos")>checked</cfif>>
													</span>
												</td>
											</tr>
										</cfif>
									</cfoutput>
									<tr>
										<td colspan="2">&nbsp;
										
										</td>
									</tr>
									<tr>
										<td></td>
										<td><strong>TODOS</strong></td>
										<td style="text-align:center"><cfif hayTablas EQ 1>
											<input type="checkbox" name="checkTodosTablas" value="1" class="areaFiltro" onClick="javascript:checkTodos2()"
											<cfif isdefined("Form.checkTodosTablas")>checked</cfif>>
											<cfelse>&nbsp;
											</cfif>
										</td>
									</tr>
									
								</table>
							</td>
							<td></td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<input name="btnSalir" type="submit" value="Salir" onClick="javascript: Asignar();">
							</td>
						</tr>
					</cfif>
					<script type="text/javascript">
						function checkTodos2() {
							for (var i = 0; i < lista.elements.length; ++i){
								if (lista.elements[i].type == "checkbox"
								&& lista.elements[i].name == "checkTabla") {
									lista.elements[i].checked = lista.checkTodosTablas.checked;
								}
							  }	
						}
					</script>
					<cfif isdefined("form.btnSalir")> 
						<script language="JavaScript1.2" type="text/javascript">
							function Asignar() {
								window.opener.document.formNotaFinal.CursoTabla.value='<cfoutput>#form.checkTabla#</cfoutput>';
								window.close();
							}
						</script>
		 			</cfif> 
				</form>
				 </td>
              </tr>
            </table>

</body>
</html>