	<cfset LvarRH = (rtrim(session.menues.SScodigo) EQ 'RH')>
	<cfif LvarRH>
		<cfif isdefined("btnFiltroMateria")>
			<cfset form.btnFiltroMateria = 1>
			<cfset form.PEScodigo = "0">
		<cfelseif isdefined("btnFiltroPDI") or (isdefined("url.F4") AND url.F4 EQ "-1")>
			<cfset form.btnFiltroPDI = 1>
			<cfset form.PEScodigo = "-1">
		<cfelseif isdefined("btnFiltroCompetencias") or (isdefined("url.F4") AND url.F4 EQ "-2")>
			<cfset form.btnFiltroCompetencias = 1>
			<cfset form.PEScodigo = "-2">
		<cfelse>
			<cfset form.btnFiltroMateria = 1>
			<cfset form.PEScodigo = "0">
		</cfif>
	<cfelseif NOT isdefined("form.EScodigo")>
		<cfset form.btnFiltroMateria = 1>
		<cfset form.PEScodigo = "0">
	</cfif>
	<cfif isdefined("Url.Tper") and not isdefined("Form.Tper")>
		<cfparam name="Form.Tper" default="#Url.Tper#">
	</cfif>	
	<cfif isdefined("Url.Apersona") and not isdefined("Form.Apersona")>
		<cfparam name="Form.Apersona" default="#Url.Apersona#">
	</cfif>	
	
		
	<cfparam name="form.EScodigo" 	default="#url.F1#">
	<cfparam name="form.CARcodigo" 	default="#url.F2#"><cfif form.CARcodigo EQ ""><cfset form.CARcodigo="0"></cfif>
	<cfparam name="form.GAcodigo" 	default="#url.F3#"><cfif form.GAcodigo EQ ""><cfset form.GAcodigo="0"></cfif>
	<cfparam name="form.PEScodigo" 	default="#url.F4#"><cfif form.PEScodigo EQ ""><cfset form.PEScodigo="0"></cfif>
	<cfparam name="form.txtMnombreFiltro" default="#url.F5#">
	<cfparam name="form.MPcodigo" 	default="">

	<cfparam name="form.Scodigo" default="0">
	<cfparam name="form.Ccodigo" default="">

	<!--- Períodos de Matrícula --->
	<cfquery name="rsPeriodo" datasource="#Session.DSN#">
		select 	convert(varchar, PLcodigo) as PLcodigo, 
				convert(varchar, PEcodigo) as PEcodigo
		from PeriodoMatricula
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and PMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PM#">
	</cfquery>
<cfif rsPeriodo.recordCount EQ 0>
	<cfabort>
</cfif>	
	<!--- Escuelas --->
	<cfquery name="rsEscuela" datasource="#session.DSN#">
		Select 
			  convert(varchar,EScodigo) as EScodigo
			, '#session.parametros.Facultad#: ' + convert(varchar(20),Fnombre) + ', #session.parametros.Escuela#: ' + convert(varchar(20),ESnombre) as ESnombre
		from Facultad f, Escuela e
		where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 and f.Fcodigo = e.Fcodigo
		order by ESnombre
	</cfquery>
	<cfif form.EScodigo EQ "">
		<cfset form.EScodigo = rsEscuela.EScodigo>
	</cfif>
		
	<!--- Carreras --->
	<cfquery name="rsCarrera" datasource="#Session.DSN#">
		select convert(varchar, a.CARcodigo) as CARcodigo, 
			   a.CARnombre
		from Carrera a
		<cfif form.EScodigo GT 0>
		where a.EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EScodigo#">
		</cfif>
		order by CARcodificacion
	</cfquery>

	<!--- Grados Academicos --->
	<cfquery name="rsGrados" datasource="#Session.DSN#">
		select convert(varchar, a.GAcodigo) as GAcodigo, 
			   a.GAnombre
		from GradoAcademico a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by GAorden
	</cfquery>

	<!--- Sedes --->
	<cfquery name="rsSedes" datasource="#Session.DSN#">
		select convert(varchar, a.Scodigo) as Scodigo, 
				rtrim(a.Scodificacion) || ':&nbsp;&nbsp;' || a.Snombre as Nombre
		from Sede a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by Sorden
	</cfquery>

	<cfif NOT LvarRH>
		<!--- Planes Académicos --->
		<cfquery name="rsPlanes" datasource="#Session.DSN#">
			set nocount on
			declare @hoy datetime
			select @hoy = convert(varchar,getdate(),112)
			select convert(varchar, a.PEScodigo) as PEScodigo, 
				   b.GAnombre + ' en ' + a.PESnombre as PESnombre
				from PlanEstudiosAlumno pea
					, PlanEstudios a
				, GradoAcademico b
				, Carrera c
			  where pea.Apersona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.matricula.Apersona#">
				and pea.PEScodigo=a.PEScodigo			
				and a.GAcodigo = b.GAcodigo
				and a.CARcodigo = c.CARcodigo
				and a.PESestado > -1
				and @hoy BETWEEN convert(varchar,PESdesde,112) and isnull(convert(varchar,PESmaxima,112),isnull(convert(varchar,PEShasta,112),@hoy))
			order by CARcodificacion, GAorden, PEScodificacion
			set nocount off
		</cfquery>
		
		<cfif form.PEScodigo GT 0>
			<cfset LvarPlan = false>
			<cfloop query="rsPlanes">
				<cfif form.PEScodigo eq rsPlanes.PEScodigo>
					<cfset LvarPlan = true>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif not LvarPlan>
				<cfset form.PEScodigo = 0>
			</cfif>
		</cfif>
	</cfif>
<head>
<title>Lista de Materias</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/educ/css/educ.css" rel="stylesheet" type="text/css">
</head>
<body>
	<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>			
	<form name="formmateria_filtro" method="post" action="" style="margin: 0">
    <input name="MPcodigo" type="hidden"> 
	<cfoutput>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="##CCCCCC">
		<cfif LvarRH>
        <tr>
          <td width="5%" rowspan="4">&nbsp;</td>
          <td width="27%" rowspan="4" align="right" class="fileLabel">&nbsp;</td>
          <td width="41%" valign="middle">
			<input name="btnFiltroPDI" type="submit" id="btnFiltroPDI" value="Plan de Desarrollo Individual">
		  </td>
		</tr>
        <tr>
          <td width="41%" style=" padding-left:70px;" valign="middle">
			<strong>o</strong>
		  </td>
		</tr>
        <tr>
          <td width="41%" valign="middle">
			<input name="btnFiltroCompetencias" type="submit" id="btnFiltroCompetencias" value="Competencias del Puesto">
		  </td>
		</tr>
        <tr>
          <td width="41%" style=" padding-left:70px;" valign="middle">
			<strong>o</strong>
			<input type="hidden" name="PEScodigo" value="#form.PEScodigo#">
		  </td>
		</tr>
		</cfif>
        <tr> 
          <td width="5%" rowspan="6">&nbsp;</td>
          <td width="27%" align="right" class="fileLabel">#session.parametros.Escuela#: </td>
          <td width="32%">
			<select name="EScodigo" onChange="javascript:this.form.PEScodigo.selectedIndex=0;this.form.submit();">
              <cfloop query="rsEscuela">
                <option value="#EScodigo#" <cfif isDefined("Form.EScodigo") and Trim(Form.EScodigo) EQ rsEscuela.EScodigo>selected</cfif>>#rsEscuela.ESnombre#</option>
              </cfloop>
            </select> </td>
          <td width="41%" rowspan="5" align="center" valign="middle">
			<input name="btnFiltroMateria" type="submit" id="btnFiltroMateria" value="Buscar">
		  </td>
        </tr>
        <tr> 
          <td align="right" class="fileLabel">Carrera: </td>
          <td> <select name="CARcodigo" onChange="javascript:this.form.PEScodigo.selectedIndex=0;this.form.submit();">
              <option value="0" <cfif isDefined("Form.CARcodigo") and Trim(Form.CARcodigo) EQ '0'>selected</cfif>> 
              -- Cualquiera -- </option>
              <cfloop query="rsCarrera">
                <option value="#rsCarrera.CARcodigo#" <cfif isDefined("Form.CARcodigo") and Trim(Form.CARcodigo) EQ rsCarrera.CARcodigo>selected</cfif>>#rsCarrera.CARnombre#</option>
              </cfloop>
            </select></td>
        </tr>
        <tr> 
          <td align="right" class="fileLabel">Grado Acad&eacute;mico: </td>
          <td> <select name="GAcodigo" onChange="javascript:this.form.PEScodigo.selectedIndex=0;this.form.submit();">
              <option value="0" <cfif isDefined("Form.GAcodigo") and Trim(Form.GAcodigo) EQ '0'>selected</cfif>> 
              -- Cualquiera -- </option>
              <option value="-1" <cfif isDefined("Form.GAcodigo") and Trim(Form.GAcodigo) EQ '-1'>selected</cfif>> 
              -- Ninguno -- </option>
              <cfloop query="rsGrados">
                <option value="#rsGrados.GAcodigo#" <cfif isDefined("Form.GAcodigo") and Trim(Form.GAcodigo) EQ rsGrados.GAcodigo>selected</cfif>>#rsGrados.GAnombre#</option>
              </cfloop>
            </select></td>
        </tr>
        <tr> 
          <td align="right" class="fileLabel">Materia que contenga: </td>
          <td colspan="2"> 
		  <input name="txtMnombreFiltro" type="text" size="60" <cfif isdefined("form.txtMnombreFiltro")>value="#form.txtMnombreFiltro#"</cfif>> 
          </td>
          <td>&nbsp;</td>
        </tr>
	<cfif NOT LvarRH>
        <tr><td align="center" class="fileLabel">o</td></tr>
        <tr> 
			<td align="right" class="fileLabel">
				Por 
				<cfif form.Tper EQ 'A'>	<!--- Alumno --->
					mi
				<cfelse>					<!--- Profesor Guia y Administrativo --->
					su
				</cfif>					
				Plan de Estudios:
			</td>
			<td> 
				<select name="PEScodigo"
					<cfif isdefined("Form.btnMaterias")>onChange="javascript:this.form.submit();"</cfif>>
					<option value="0" <cfif isDefined("Form.GAcodigo") and Trim(Form.GAcodigo) EQ '0'>selected</cfif>>
						-- No buscar por Plan de Estudios --</option>
				<cfif isdefined("rsPlanes")>
			  	<cfloop query="rsPlanes">
					<option value="#rsPlanes.PEScodigo#" <cfif isDefined("Form.PEScodigo") and Trim(Form.PEScodigo) EQ rsPlanes.PEScodigo>selected</cfif>>#rsPlanes.PESnombre#</option>
			  	</cfloop>
				</cfif>
				</select>
			</td>
		</tr>
	</cfif>
    </table>
		</cfoutput>
	</form>	   
<cfif isdefined("btnFiltroMateria") or isdefined("btnFiltroPDI") or isdefined("btnFiltroCompetencias") or form.MPcodigo NEQ "">
	<cfquery name="listaMaterias" datasource="#Session.DSN#">
	<cfif isdefined("btnFiltroPDI") or isdefined("btnFiltroCompetencias")>
	<!--- INICIA PARA PDI O COMPETENCIAS --->
		select convert(varchar, b.Mcodigo) as Mcodigo, 
			   b.Mcodificacion, 
			   b.Mnombre,
			   b.Mcreditos,
			   b.Mrequisitos,
			   e.RHCcodigo as PBLsecuencia, 'Conocimiento ' + e.RHCdescripcion as PBLnombre,
		   ( select count(1) from Curso c
			 where c.Mcodigo = b.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PLcodigo#">
			 <cfif rsPeriodo.PEcodigo NEQ "">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PEcodigo#">
			 </cfif>
		   ) as Generados,
	
		   ( select count(1) from Curso c
			 where c.Mcodigo = b.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PLcodigo#">
			 <cfif rsPeriodo.PEcodigo NEQ "">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PEcodigo#">
			 </cfif>
 			 and c.Cestado = 1
		   ) as Activos
		from Materia b, RHConocimientos e, RHConocimientosMaterias f
		where exists (select * from Curso c
								where PLcodigo = #rsPeriodo.PLcodigo#
								<cfif rsPeriodo.PEcodigo NEQ "">
								  and PEcodigo = #rsPeriodo.PEcodigo#
								</cfif>
								  and b.Mcodigo = c.Mcodigo)
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and f.Ecodigo = b.Ecodigo
		and f.Mcodigo = b.Mcodigo
		and exists(
		<cfif isdefined("btnFiltroCompetencias")>
			select 1
			  from PersonaDatos p, asp..UsuarioReferencia a, LineaTiempo b, 
				   RHPuestos c, RHConocimientosPuesto d
			 where p.Ppersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.matricula.Apersona#">
			   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			   and a.Usucodigo = p.Usucodigo
			   and a.STabla = 'DatosEmpleado'
			   and b.DEid = convert(numeric, a.llave)
			   and convert(varchar, b.DEid) = a.llave
			   and getdate() between b.LTdesde and b.LThasta
			   and b.Ecodigo = c.Ecodigo
			   and b.RHPcodigo = c.RHPcodigo
			   and c.RHPcodigo = d.RHPcodigo
			   and c.Ecodigo = d.Ecodigo
			   and c.RHPcodigo = d.RHPcodigo
			   and d.Ecodigo=e.Ecodigo
			   and d.RHCid=e.RHCid
		<cfelse>
			select 1
			  from PersonaDatos p, asp..UsuarioReferencia a, LineaTiempo b, 
				   RHPuestos c, RHConocimientosPuesto d, 
				   RHEEvaluacionCap f, RHDEvaluacionCap g, RHEvaluadoresCap h
			 where p.Ppersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.matricula.Apersona#">
			   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			   and a.Usucodigo = p.Usucodigo
			   and a.STabla = 'DatosEmpleado'
			   and b.DEid = convert(numeric, a.llave)
			   and convert(varchar, b.DEid) = a.llave
			   and getdate() between b.LTdesde and b.LThasta
			   and b.Ecodigo = c.Ecodigo
			   and b.RHPcodigo = c.RHPcodigo
			   and c.RHPcodigo = d.RHPcodigo
			   and c.Ecodigo = d.Ecodigo
			   and c.RHPcodigo = d.RHPcodigo
			   and d.Ecodigo = e.Ecodigo
			   and d.RHCid = e.RHCid
			   and b.Ecodigo = f.Ecodigo
			   and f.RHEECestado = 3
			   and f.RHEECfdesde =
				(
					select max(x.RHEECfdesde)
					  from RHEEvaluacionCap x, RHListaEvalCap y
					 where x.Ecodigo = b.Ecodigo
					   and x.Ecodigo = y.Ecodigo
					   and x.RHEECid = y.RHEECid
					   and y.DEid = b.DEid
					   and x.RHEECestado = 3
				)
			   and f.RHEECid = g.RHEECid
			   and e.RHCid = g.RHCid
			   and b.DEid = g.DEid
			   and g.RHDECdesarrollar = 'S'
			   and g.RHEECid = h.RHEECid
			   and g.DEid = h.DEid
			   and g.RHECidevaluador = h.RHECidevaluador
			   and h.RHECtipo = 'J'
		</cfif>
		)
	UNION
		select convert(varchar, b.Mcodigo) as Mcodigo, 
			   b.Mcodificacion, 
			   b.Mnombre,
			   b.Mcreditos,
			   b.Mrequisitos,
			   e.RHHcodigo as PBLsecuencia, 'Habilidad ' + e.RHHdescripcion as PBLnombre,
		   ( select count(1) from Curso c
			 where c.Mcodigo = b.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PLcodigo#">
			 <cfif rsPeriodo.PEcodigo NEQ "">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PEcodigo#">
			 </cfif>
		   ) as Generados,
	
		   ( select count(1) from Curso c
			 where c.Mcodigo = b.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PLcodigo#">
			 <cfif rsPeriodo.PEcodigo NEQ "">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PEcodigo#">
			 </cfif>
 			 and c.Cestado = 1
		   ) as Activos
		from Materia b, RHHabilidades e, RHHabilidadesMaterias f
		where exists (select * from Curso c
								where PLcodigo = #rsPeriodo.PLcodigo#
								<cfif rsPeriodo.PEcodigo NEQ "">
								  and PEcodigo = #rsPeriodo.PEcodigo#
								</cfif>
								  and b.Mcodigo = c.Mcodigo)
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and f.Ecodigo = b.Ecodigo
		and f.Mcodigo = b.Mcodigo
		and exists(
		<cfif isdefined("btnFiltroCompetencias")>
			select 1
			  from PersonaDatos p, asp..UsuarioReferencia a, LineaTiempo b, 
				   RHPuestos c, RHHabilidadesPuesto d
			 where p.Ppersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.matricula.Apersona#">
			   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			   and a.Usucodigo = p.Usucodigo
			   and a.STabla = 'DatosEmpleado'
			   and b.DEid = convert(numeric, a.llave)
			   and convert(varchar, b.DEid) = a.llave
			   and getdate() between b.LTdesde and b.LThasta
			   and b.Ecodigo = c.Ecodigo
			   and b.RHPcodigo = c.RHPcodigo
			   and c.RHPcodigo = d.RHPcodigo
			   and c.Ecodigo = d.Ecodigo
			   and c.RHPcodigo = d.RHPcodigo
			   and d.Ecodigo=e.Ecodigo
			   and d.RHHid=e.RHHid
		<cfelse>
			select 1
			  from PersonaDatos p, asp..UsuarioReferencia a, LineaTiempo b, 
				   RHPuestos c, RHHabilidadesPuesto d, 
				   RHEEvaluacionCap f, RHDEvaluacionCap g, RHEvaluadoresCap h
			 where p.Ppersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.matricula.Apersona#">
			   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			   and a.Usucodigo = p.Usucodigo
			   and a.STabla = 'DatosEmpleado'
			   and b.DEid = convert(numeric, a.llave)
			   and convert(varchar, b.DEid) = a.llave
			   and getdate() between b.LTdesde and b.LThasta
			   and b.Ecodigo = c.Ecodigo
			   and b.RHPcodigo = c.RHPcodigo
			   and c.RHPcodigo = d.RHPcodigo
			   and c.Ecodigo = d.Ecodigo
			   and c.RHPcodigo = d.RHPcodigo
			   and d.Ecodigo=e.Ecodigo
			   and d.RHHid=e.RHHid
			   and b.Ecodigo = f.Ecodigo
			   and f.RHEECestado = 3
			   and f.RHEECfdesde =
					(
						select max(x.RHEECfdesde)
						  from RHEEvaluacionCap x, RHListaEvalCap y
						 where x.Ecodigo = b.Ecodigo
						   and x.Ecodigo = y.Ecodigo
						   and x.RHEECid = y.RHEECid
						   and y.DEid = b.DEid
						   and x.RHEECestado = 3
					)
			   and f.RHEECid = g.RHEECid
			   and e.RHHid = g.RHHid
			   and b.DEid = g.DEid
			   and g.RHDECdesarrollar = 'S'
			   and g.RHEECid = h.RHEECid
			   and g.DEid = h.DEid
			   and g.RHECidevaluador = h.RHECidevaluador
			   and h.RHECtipo = 'J'
		</cfif>
		)
	<cfelseif form.PEScodigo EQ "0">
		select convert(varchar, b.Mcodigo) as Mcodigo, 
			   b.Mcodificacion, 
			   b.Mnombre,
			   b.Mcreditos,
			   b.Mrequisitos,
			   convert(varchar,null) as PBLsecuencia,
		   ( select count(1) from Curso c
			 where c.Mcodigo = b.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PLcodigo#">
			 <cfif rsPeriodo.PEcodigo NEQ "">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PEcodigo#">
			 </cfif>
		   ) as Generados,
	
		   ( select count(1) from Curso c
			 where c.Mcodigo = b.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PLcodigo#">
			 <cfif rsPeriodo.PEcodigo NEQ "">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PEcodigo#">
			 </cfif>
 			 and c.Cestado = 1
		   ) as Activos
		from Materia b
		where exists (select * from Curso c
								where PLcodigo = #rsPeriodo.PLcodigo#
								<cfif rsPeriodo.PEcodigo NEQ "">
								  and PEcodigo = #rsPeriodo.PEcodigo#
								</cfif>
								  and b.Mcodigo = c.Mcodigo)
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigo#">
		<cfif Form.GAcodigo NEQ "0">
			<cfif Form.GAcodigo NEQ "-1">
				and b.GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GAcodigo#">
			<cfelse>
				and b.GAcodigo is null
			</cfif>
		</cfif>
		and b.Mtipo = 'M'
		and b.Mactivo = 1
		<cfif isdefined("form.txtMnombreFiltro") AND trim(form.txtMnombreFiltro) NEQ "">
		and upper(b.Mnombre) like '%#ucase(form.txtMnombreFiltro)#%'
		</cfif>
		order by b.Mcodificacion
	<!--- FIANALIZA PARA PDI O COMPETENCIAS --->
	<cfelse>
	<!--- INICIA FILTRO NORMAL --->
		select convert(varchar, m.Mcodigo) as Mcodigo, convert(varchar, MPcodigo) as MPcodigo, 
			   isnull(MPcodificacion,Mcodificacion) as Mcodificacion, 
			   isnull(MPnombre,Mnombre) as Mnombre,
			   m.Mcreditos,
			   m.Mrequisitos,
			   convert(varchar,mp.PBLsecuencia) as PBLsecuencia, PBLnombre, 
			   mp.MPsecuencia, 
			   case Mtipo when 'M' then 'Regular' else 'Electiva' end as Mtipo,
		   ( select count(1) from Curso c
			 where c.Mcodigo = m.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PLcodigo#">
			 <cfif rsPeriodo.PEcodigo NEQ "">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PEcodigo#">
			 </cfif>
		   ) as Generados,
	
		   ( select count(1) from Curso c
			 where c.Mcodigo = m.Mcodigo
			 <cfif Form.Scodigo gt 0>
			 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			 </cfif>
			 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PLcodigo#">
			 <cfif rsPeriodo.PEcodigo NEQ "">
			 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PEcodigo#">
			 </cfif>
			 and c.Cestado = 1
		   ) as Activos
		  from PlanEstudiosBloque b, MateriaPlan mp, Materia m
		 where b.PEScodigo = #form.PEScodigo#
		   and mp.PEScodigo = b.PEScodigo
		   and mp.PBLsecuencia = b.PBLsecuencia
		   and mp.Mcodigo *= m.Mcodigo
		   and m.Mactivo = 1
		<cfif form.MPcodigo NEQ "">
			UNION		   
			select convert(varchar, m.Mcodigo) as Mcodigo, convert(varchar, MPcodigo) as MPcodigo, 
				   m.Mcodificacion, 
				   m.Mnombre,
				   m.Mcreditos,
				   m.Mrequisitos,
				   convert(varchar,mp.PBLsecuencia) as PBLsecuencia, PBLnombre, 
				   mp.MPsecuencia,
				   'Elegible' as Mtipo,
			   ( select count(1) from Curso c
				 where c.Mcodigo = m.Mcodigo
				 <cfif Form.Scodigo gt 0>
				 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
				 </cfif>
				 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PLcodigo#">
				 <cfif rsPeriodo.PEcodigo NEQ "">
				 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PEcodigo#">
				 </cfif>
			   ) as Generados,
		
			   ( select count(1) from Curso c
				 where c.Mcodigo = m.Mcodigo
				 <cfif Form.Scodigo gt 0>
				 and c.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
				 </cfif>
				 and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PLcodigo#">
				 <cfif rsPeriodo.PEcodigo NEQ "">
				 and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.PEcodigo#">
				 </cfif>
				 and c.Cestado = 1
			   ) as Activos
			  from PlanEstudiosBloque b, MateriaPlan mp, Materia m, MateriaElegible me
			 where b.PEScodigo = #form.PEScodigo#
			   and mp.PEScodigo = b.PEScodigo
			   and mp.PBLsecuencia = b.PBLsecuencia
			   and mp.MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPcodigo#">
			   and mp.Mcodigo = me.Mcodigo
			   and m.Mcodigo = me.McodigoElegible
			   and m.Mactivo = 1
		</cfif>
		order by mp.PBLsecuencia, mp.MPsecuencia, mp.Mtipo
	<!--- FINALIZA FILTRO NORMAL --->
	</cfif>
	</cfquery>
	<cfoutput>
		<form name="frmMaterias" id="frmMaterias" method="post" style="margin: 0;">
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td width="10%" nowrap class="tituloListas">Codigo</td>
					<td width="30%" nowrap class="tituloListas">Materia</td>
					<cfif isdefined("listaMaterias.Mtipo")>
						<td width="10%" nowrap class="tituloListas">Tipo</td>
					</cfif>
					<td width="10%" nowrap class="tituloListas">#session.parametros.Creditos#</td>
					<td width="30%" nowrap class="tituloListas">Requisitos</td>
					<td width="5%" nowrap class="tituloListas">Cursos<BR>Generados</td>
					<td width="5%" nowrap class="tituloListas">Cursos<BR>Activos</td>
				</tr>
				<cfset LvarPBLsecuencia = "">
				<cfloop query="listaMaterias">
					<cfif LvarPBLsecuencia NEQ listaMaterias.PBLsecuencia>
						<cfset LvarPBLsecuencia = listaMaterias.PBLsecuencia>
						<tr>
							<td colspan="10"><font size="3"><strong>#listaMaterias.PBLnombre#</strong></font></td>
						</tr>
					</cfif>
					
					<tr class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>"
						<cfset LvarStyle = "">
						<cfif listaMaterias.Activos GT 0>
							style="cursor:pointer;"
							onMouseOver="javascript:sbMouseOver(event,this);" 
							onMouseOut="javascript:sbMouseOut(event,this);" 
							onClick="javascript:fnSelecciona(#listaMaterias.Mcodigo#);"
						<cfelseif isdefined("listaMaterias.Mtipo") AND listaMaterias.Mtipo EQ "Electiva">
							style="cursor:pointer;"
							onMouseOver="javascript:sbMouseOver(event,this,true);" 
							onMouseOut="javascript:sbMouseOut(event,this);" 
							onClick="javascript:fnElectiva(#listaMaterias.MPcodigo#);"
							<cfset LvarStyle = "style=""cursor:pointer; font-weight:bold;""">
						</cfif>	> 
							<td nowrap #LvarStyle#>#listaMaterias.Mcodificacion#</td>
							<td nowrap  #LvarStyle#>#listaMaterias.Mnombre#</td>
						<cfif isdefined("listaMaterias.Mtipo")>
							<td nowrap  #LvarStyle#>#listaMaterias.Mtipo#</td>
						</cfif>
						
						<cfif isdefined("listaMaterias.Mtipo") and listaMaterias.Mtipo EQ "Electiva">
							<td colspan="4" #LvarStyle#>Seleccione para ver sus Materias Elegibles</td>
						<cfelse>
							<td nowrap >#listaMaterias.Mcreditos#</td>
							<td nowrap >#listaMaterias.Mrequisitos#</td>
							<td align="center" >#listaMaterias.Generados#</td>
							<td align="center" >#listaMaterias.Activos#</td>
						</cfif>
					</tr>
				</cfloop>
			</table>
		</form>
	</cfoutput>
</cfif>
	
	<script language="JavaScript" type="text/javascript">
		var GvarColorAnterior;
		function sbMouseOver(e,obj,rojo){
			GvarColorAnterior=obj.style.backgroundColor;
			if (rojo)
				obj.style.backgroundColor="#FFF000";
			else
				obj.style.backgroundColor="#91D2FF";
		}
	
		function sbMouseOut(e,obj){
		  obj.style.backgroundColor=GvarColorAnterior;
		}

		function fnElectiva(MPcodigo){
			document.formmateria_filtro.MPcodigo.value = MPcodigo;
			document.formmateria_filtro.submit();
		}		

		function fnSelecciona(Mcodigo){
			if (opener.fnMateria_conlis_filtros)
			  opener.fnMateria_conlis_filtros (document.formmateria_filtro.EScodigo.value,document.formmateria_filtro.CARcodigo.value,document.formmateria_filtro.GAcodigo.value,document.formmateria_filtro.PEScodigo.value,document.formmateria_filtro.txtMnombreFiltro.value);
			if (opener.fnMateria_conlis)
			  opener.fnMateria_conlis (Mcodigo);
			window.close();
		}		
	</script>
</body>
</html>