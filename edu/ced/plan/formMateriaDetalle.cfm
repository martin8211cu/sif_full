<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 07 de febrero del 2006
	Motivo: Actualizacin de fuentes de educación a nuevos estndares de Pantallas y Componente de Listas.
 ---> 
<cfquery name="rsPeriodos" datasource="#Session.Edu.DSN#">
	select convert(varchar, b.PEcodigo) as PEcodigo, b.PEdescripcion
	from Materia a, PeriodoEvaluacion b
	where a.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	and a.Ncodigo = b.Ncodigo
	order by b.PEorden
</cfquery>

<cfif isdefined("Url.Filtro_PEcodigo") and not isdefined("Form.Filtro_PEcodigo")>
	<cfparam name="Form.Filtro_PEcodigo" default="#Url.Filtro_PEcodigo#">
<cfelseif not isdefined("Form.Filtro_PEcodigo") and rsPeriodos.recordCount GT 0>
	<cfparam name="Form.Filtro_PEcodigo" default="#rsPeriodos.PEcodigo#">
<cfelseif not isdefined('form.Filtro_PEcodigo')>
	<cfparam name="Form.Filtro_PEcodigo" default="0">
</cfif>

<cfparam name="form.MaxRows" default="15">
<cfparam name="Form.Filtro_Actividad" default="">
<cfparam name="Form.Filtro_Leccion" default="">
<cfparam name="Form.Filtro_Secuencia" default="">
<cfparam name="Form.Pagina" default="1">
<cfparam name="Form.Pagina2" default="1">

<cfset modoDet="ALTA">
<cfif isdefined("Form.CodAct") and form.CodAct NEQ ''>
	<cfset modoDet="CAMBIO">
</cfif>
<cfquery datasource="#Session.Edu.DSN#" name="rsMateria">
	select c.Mnombre, a.Ndescripcion, b.Gdescripcion,
	       case c.Melectiva
		        when 'R' then 'Regular'
				when 'S' then 'Sustitutiva'
				when 'E' then 'Electiva'
				when 'C' then 'Complementaria'
				else ''
			end as Modalidad,
			d.MTdescripcion,
			convert(varchar, c.EVTcodigo) as EVTcodigo
	from Nivel a, Grado b, Materia c, MateriaTipo d
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  and c.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	  and a.Ncodigo = c.Ncodigo 
	  and b.Ncodigo =* c.Ncodigo 
	  and b.Gcodigo =* c.Gcodigo 
	  and c.MTcodigo = d.MTcodigo
</cfquery>

<cfquery name="rsActividades" datasource="#Session.Edu.DSN#">
	select 'Detalle' as Detalle,
			0 as Tipo,
		   convert(varchar, MPcodigo) 
		   + '|' + convert(varchar, Mconsecutivo) 
		   + '|' + convert(varchar, PEcodigo) as Codigo, 
		   substring(MPnombre,1,45) as Nombre,
		   coalesce(MPleccion,0) as Leccion, 
		   coalesce(MPorden,0) as Secuencia,
		   Mconsecutivo,
		   MPcodigo as CodAct
		   <cfif isdefined('form.Pagina') and LEN(TRIM(form.Pagina))>
		   ,#form.Pagina# as Pagina
		   </cfif>
		   <cfif isdefined('form.Filtro_Actividad') and LEN(TRIM(form.Filtro_Actividad))>
		   ,'#form.Filtro_Actividad#' as Filtro_Actividad
		   </cfif>
		   <cfif isdefined('form.Filtro_Leccion') and form.Filtro_Leccion GT 0>
		   ,#form.Filtro_Leccion# as Filtro_Leccion
		   </cfif>
		   <cfif isdefined('form.Filtro_Secuencia') and form.Filtro_Secuencia GT 0>
		   ,#form.Filtro_Secuencia# as Filtro_Secuencia
		   </cfif>
		   <cfif isdefined('form.Filtro_PEcodigo') and form.Filtro_PEcodigo NEQ -1>
		   ,#form.Filtro_PEcodigo# as Filtro_PEcodigo
		   </cfif>
		   <cfif isdefined('form.Filtro_Mcodigo') and LEN(TRIM(form.Filtro_Mcodigo))>
		   ,'#form.Filtro_Mcodigo#' as Filtro_Mcodigo
		   </cfif>
		   <cfif isdefined('form.Filtro_MTdescripcion') and LEN(TRIM(form.Filtro_MTdescripcion))>
		   ,'#form.Filtro_MTdescripcion#' as Filtro_MTdescripcion
		   </cfif>
			<cfif isdefined('form.Filtro_Melectiva') and form.Filtro_Melectiva NEQ -1>
		   ,'#form.Filtro_Melectiva#' as Filtro_Melectiva
		   </cfif>
		   <cfif isdefined('form.Filtro_Mnombre') and LEN(TRIM(form.Filtro_Mnombre))>
		   ,'#form.Filtro_Mnombre#' as Filtro_Mnombre
		   </cfif>
			<cfif isdefined('form.FNcodigoC') and form.FNcodigoC NEQ -1>
		   	,#form.FNcodigoC# as FNcodigoC
		   	</cfif>
			<cfif isdefined('form.FGcodigoC') and form.FGcodigoC NEQ -1>
		   	,#form.FGcodigoC# as FGcodigoC
		   	</cfif>
		   
	from MateriaPrograma
	where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
	  and MPorden is not null
	<cfif isdefined('form.Filtro_Actividad') and LEN(TRIM(form.Filtro_Actividad))>
	  and upper(MPnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Actividad)#%">
	</cfif>
	<cfif isdefined('form.Filtro_Leccion') and form.Filtro_Leccion GT 0>
	  and MPleccion >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Leccion#">
	</cfif>
	<cfif isdefined('form.Filtro_Secuencia') and form.Filtro_Secuencia GT 0>
	  and MPorden >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Secuencia#">
	</cfif>
	union
	select 'Detalle' as Detalle,
		   1 as Tipo, 
		   convert(varchar, EMcomponente) 
		   + '|' + convert(varchar, Mconsecutivo) 
		   + '|' + convert(varchar, PEcodigo) as Codigo, 
		   substring(EMnombre,1,45) as Nombre,
		   isnull(EMleccion,0) as Leccion, 
		   isnull(EMorden,0) as Secuencia, 
		   Mconsecutivo,
		   EMcomponente as CodAct
		   <cfif isdefined('form.Pagina') and LEN(TRIM(form.Pagina))>
		   ,#form.Pagina# as Pagina
		   </cfif>
		   <cfif isdefined('form.Filtro_Actividad') and LEN(TRIM(form.Filtro_Actividad))>
		   ,'#form.Filtro_Actividad#' as Filtro_Actividad
		   </cfif>
		   <cfif isdefined('form.Filtro_Leccion') and form.Filtro_Leccion GT 0>
		   ,#form.Filtro_Leccion# as Filtro_Leccion
		   </cfif>
		   <cfif isdefined('form.Filtro_Secuencia') and form.Filtro_Secuencia GT 0>
		   ,#form.Filtro_Secuencia# as Filtro_Secuencia
		   </cfif>
		   <cfif isdefined('form.Filtro_PEcodigo') and form.Filtro_PEcodigo NEQ -1>
		   ,#form.Filtro_PEcodigo# as Filtro_PEcodigo
		   </cfif>
		   <cfif isdefined('form.Filtro_Mcodigo') and LEN(TRIM(form.Filtro_Mcodigo))>
		   ,'#form.Filtro_Mcodigo#' as Filtro_Mcodigo
		   </cfif>
		   <cfif isdefined('form.Filtro_MTdescripcion') and LEN(TRIM(form.Filtro_MTdescripcion))>
		   ,'#form.Filtro_MTdescripcion#' as Filtro_MTdescripcion
		   </cfif>
			<cfif isdefined('form.Filtro_Melectiva') and form.Filtro_Melectiva NEQ -1>
		   ,'#form.Filtro_Melectiva#' as Filtro_Melectiva
		   </cfif>
		   <cfif isdefined('form.Filtro_Mnombre') and LEN(TRIM(form.Filtro_Mnombre))>
		   ,'#form.Filtro_Mnombre#' as Filtro_Mnombre
		   </cfif>
			<cfif isdefined('form.FNcodigoC') and form.FNcodigoC NEQ -1>
		   	,#form.FNcodigoC# as FNcodigoC
		   	</cfif>
			<cfif isdefined('form.FGcodigoC') and form.FGcodigoC NEQ -1>
		   	,#form.FGcodigoC# as FGcodigoC
		   	</cfif>
	from EvaluacionMateria
	where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
	  and EMorden is not null
	<cfif isdefined('form.Filtro_Actividad') and LEN(TRIM(form.Filtro_Actividad))>
	  and upper(EMnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Actividad)#%">
	</cfif>
	<cfif isdefined('form.Filtro_Leccion') and form.Filtro_Leccion GT 0>
	  and EMleccion >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Leccion#">
	</cfif>
	<cfif isdefined('form.Filtro_Secuencia') and form.Filtro_Secuencia GT 0>
	  and EMorden >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Secuencia#">
	</cfif>
	order by Leccion, Secuencia, Tipo, Nombre
</cfquery>

<cfquery name="rsConceptosEval" datasource="#Session.Edu.DSN#">
	select convert(varchar, b.ECcodigo) as ECcodigo, rtrim(b.ECnombre) + ' (' + convert(varchar, a.ECMporcentaje, 1) + '%)' as ECnombre
	from EvaluacionConceptoMateria a, EvaluacionConcepto b
	where a.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
	and a.ECcodigo = b.ECcodigo
</cfquery>

<cfquery name="rsTablasEval" datasource="#Session.Edu.DSN#">
	select convert(varchar, EVTcodigo) as EVTcodigo, EVTnombre
	from EvaluacionValoresTabla
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	order by EVTnombre
</cfquery>

<cfif modoDet EQ "ALTA">
	<cfquery name="rsPendientes" datasource="#Session.Edu.DSN#">
		select '1' 
			   + '|' + convert(varchar, a.EMcomponente) 
			   + '|' + convert(varchar, a.ECcodigo)
			   + '|' + rtrim(convert(varchar, b.EVTcodigo))
			   + '|' + convert(varchar, isnull(b.EVTnombre, 'Ninguna'))
			   + '|' + convert(varchar, isnull(a.EMporcentaje, 0), 1) 
			   + '|' + isnull(a.EMnombre, '')
			   as Codigo, 
			   a.EMnombre as Nombre
		from EvaluacionMateria a, EvaluacionValoresTabla b
		where a.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		  and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
		  and a.EMorden is null
		  and a.EVTcodigo *= b.EVTcodigo
		order by a.EMnombre
	</cfquery>

	<cfquery name="rsLecciones" datasource="#Session.Edu.DSN#">
		select isnull(MPleccion, 0) as Leccion, floor(isnull(MPleccion, 0) + isnull(MPduracion, 0)) as ProxLeccion 
		from MateriaPrograma
		where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
		  and MPorden is not null
		  and MPleccion = 
					(select max(MPleccion) 
					from MateriaPrograma
					where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
					  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
					  and MPorden is not null
					)
	union
		select isnull(EMleccion, 0) as Leccion, isnull(EMleccion, 0) as ProxLeccion 
		from EvaluacionMateria
		where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
		  and EMorden is not null
		  and EMleccion = 
					(select max(EMleccion)
					from EvaluacionMateria
					where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
					  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
					  and EMorden is not null
					)
	</cfquery>
	<cfif rsLecciones.recordCount GT 0>
		<cfquery name="rsLeccionSugerida" dbtype="query">
			select max(Leccion) as Leccion, max(ProxLeccion) as ProxLeccion
			from rsLecciones
		</cfquery>
		<cfset LeccionTema = #rsLeccionSugerida.ProxLeccion#>
		<cfset LeccionEval = #rsLeccionSugerida.Leccion#>
	<cfelse>
		<cfset LeccionTema = 1>
		<cfset LeccionEval = 1>
	</cfif>

<cfelseif isdefined("Form.Tipo")>
	<cfif Form.Tipo EQ 0>
		<cfquery name="rsActividad" datasource="#Session.Edu.DSN#">
			select '0'
			       + '|' + convert(varchar, MPcodigo)
			       + '|' + convert(varchar, Mconsecutivo)
				   + '|' + convert(varchar, PEcodigo) as Codigo,
				   substring(MPnombre,1,45) as Nombre,
				   MPdescripcion,
				   MPleccion as Leccion,
				   MPduracion,
				   MPorden as Secuencia
			from MateriaPrograma
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
			and MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CodAct#">
		</cfquery>
	<cfelseif Form.Tipo EQ 1>
		<cfquery name="rsActividad" datasource="#Session.Edu.DSN#">
			select '1'
			       + '|' + convert(varchar, EMcomponente)
			       + '|' + convert(varchar, Mconsecutivo)
				   + '|' + convert(varchar, PEcodigo) as Codigo,
				   substring(EMnombre,1,45) as Nombre,
				   convert(varchar, ECcodigo) as ECcodigo,
				   convert(varchar, isnull(EVTcodigo, -1)) as EVTcodigo, 
				   EMleccion as Leccion,
				   EMporcentaje,
				   EMorden as Secuencia
			from EvaluacionMateria
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
			and EMcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CodAct#">
		</cfquery>
	</cfif>
</cfif>

<script language="JavaScript" type="text/javascript">

	function regresarMaterias() {
		location.href = "<cfoutput>#Session.Edu.RegresarUrl#</cfoutput>";
	}
	
	function Editar(data) {
		if (data!="") {
			document.form1.datos.value = data;
			document.form1.submit();
		}
		return false;
	}
	
	function crearNuevaTabla(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='tablaEvaluac.cfm?RegresarURL=MateriaDetalle.cfm'+'<cfoutput>#URLEncodedFormat("?")#Mconsecutivo#URLEncodedFormat("=")##Form.Mconsecutivo#</cfoutput>';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}
	<!---
	var restante = new Object();
	<cfloop query="rsPorcentajeRestante"><cfoutput>
		restante['#ECcodigo#'] = new Number('#Restante#');
	</cfoutput></cfloop>
	--->
	
</script>

<table width="100%" cellpadding="0" cellspacing="0" class="tituloAlterno">
	<thead><tr><td colspan="5" style="font-size: 14pt;" align="left">Datos de Materia</td></tr></thead>
	<tbody>
		<tr > 
			<td width="35%" rowspan="2" align="center" valign="middle" style="font-size: 13pt; font-weight: bold;" nowrap><cfoutput>#rsMateria.Mnombre#</cfoutput></td>
			<td nowrap><strong>Nivel:</strong> <cfoutput>#rsMateria.Ndescripcion#</cfoutput> </td>
			<td nowrap><strong>Tipo de Materia:</strong> <cfoutput>#rsMateria.MTdescripcion#</cfoutput></td>
		</tr>
		<tr> 
			<td nowrap> <strong>Grado:</strong> <cfoutput>#rsMateria.Gdescripcion#</cfoutput> </td>
			<td nowrap><strong>Modalidad:</strong> <cfoutput>#rsMateria.Modalidad#</cfoutput></td>
		</tr>
	</tbody>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
<table width="100%" border="0" cellpadding="1" cellspacing="0">
	<tr>
		<td valign="top">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" class="tituloListas">
				<form name="filtro" method="post" action="Materias.cfm">
				<cfoutput>
				<input name="MaxRows" type="hidden" value="#form.MaxRows#">
				<input name="Detalle" type="hidden" value="#form.Detalle#">
				<input name="Mconsecutivo" type="hidden" value="#form.Mconsecutivo#">
				<input name="Pagina" type="hidden" value="#form.Pagina#">
				<input name="Filtro_Mcodigo" type="hidden" value="<cfif isdefined('Form.Filtro_Mcodigo')>#form.Filtro_Mcodigo#</cfif>">
				<input name="Filtro_MTdescripcion" type="hidden" value="<cfif isdefined('Form.Filtro_MTdescripcion')>#form.Filtro_MTdescripcion#</cfif>">
				<input name="Filtro_Melectiva" type="hidden" value="<cfif isdefined('Form.Filtro_Melectiva')>#form.Filtro_Melectiva#</cfif>">
				<input name="Filtro_Mnombre" type="hidden" value="<cfif isdefined('Form.Filtro_Mnombre')>#form.Filtro_Mnombre#</cfif>">
				<input name="FNcodigoC" type="hidden" value="<cfif isdefined('form.FNcodigoC')>#form.FNcodigoC#</cfif>">
				<input name="FGcodigoC" type="hidden" value="<cfif isdefined('form.FGcodigoC')>#form.FGcodigoC#</cfif>">	
				</cfoutput>

					<tr>
						<td>&nbsp;</td>
						<td colspan="5" nowrap> <strong>Periodo de Evaluaci&oacute;n:&nbsp; </strong>
						  <select name="Filtro_PEcodigo" tabindex="1">
							<cfoutput query="rsPeriodos"> 
							  <option value="#PEcodigo#" <cfif isdefined('form.Filtro_PEcodigo') and rsPeriodos.PEcodigo EQ Form.Filtro_PEcodigo>selected</cfif>>#PEdescripcion#</option>
							</cfoutput> 
						  </select>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><strong>Actividad</strong></td>
						<td><strong>Lecci&oacute;n</strong></td>
						<td><strong>Secuencia</strong></td>
					</tr>
					<cfoutput>
					<tr>
						<td>&nbsp;</td>
						<td>
							<input name="Filtro_Actividad" type="text" size="35"
								value="<cfif isdefined('form.Filtro_Actividad')>#form.Filtro_Actividad#</cfif>">
						</td>
						<td>
							<input name="Filtro_Leccion" type="text" size="10"
								value="<cfif isdefined('form.Filtro_Leccion')>#form.Filtro_Leccion#</cfif>">
						</td>
						<td>
							<input name="Filtro_Secuencia" type="text" size="10"
								value="<cfif isdefined('form.Filtro_Secuencia')>#form.Filtro_Secuencia#</cfif>">
						</td>
						<td valign="top"><cf_botones values="Filtrar"></td>
					</tr>
					</cfoutput>
				</form>	
			</table>
			<cfset navegacion = "">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Detalle=" & Form.Detalle>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pagina=" & Form.Pagina>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mconsecutivo=" & Form.Mconsecutivo>
			<cfif isdefined('form.Filtro_PEcodigo')>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_PEcodigo=" & Form.Filtro_PEcodigo>
			</cfif>
			<cfif isdefined('form.Filtro_Actividad') and LEN(TRIM(form.Filtro_Actividad))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Actividad=" & Form.Filtro_Actividad>
			</cfif>
			<cfif isdefined('form.Filtro_Leccion') and LEN(TRIM(form.Filtro_Leccion))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Leccion=" & Form.Filtro_Leccion>
			</cfif>
			<cfif isdefined('form.Filtro_Secuencia') and LEN(TRIM(form.Filtro_Secuencia))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Secuencia=" & Form.Filtro_Secuencia>
			</cfif>
			<cfif isdefined('form.Filtro_Mcodigo') and LEN(TRIM(form.Filtro_Mcodigo))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Mcodigo=" & Form.Filtro_Mcodigo>
			</cfif>
			<cfif isdefined('form.Filtro_MTdescripcion') and LEN(TRIM(form.Filtro_MTdescripcion))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_MTdescripcion=" & Form.Filtro_MTdescripcion>
			</cfif>
			<cfif isdefined('form.Filtro_Melectiva') and LEN(TRIM(form.Filtro_Melectiva))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Melectiva=" & Form.Filtro_Melectiva>
			</cfif>
			<cfif isdefined('form.Filtro_Mnombre') and LEN(TRIM(form.Filtro_Mnombre))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Mnombre=" & Form.Filtro_Mnombre>
			</cfif>
			<cfif isdefined('form.FNcodigoC') and LEN(TRIM(form.FNcodigoC))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FNcodigoC=" & Form.FNcodigoC>
			</cfif>
			<cfif isdefined('form.FGcodigoC') and LEN(TRIM(form.FGcodigoC))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FGcodigoC=" & Form.FGcodigoC>
			</cfif>
			<cfinvoke 
			 component="sif.rh.Componentes.pListas"
			 method="pListaquery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" 			value="#rsActividades#"/>
				<cfinvokeargument name="desplegar" 		value="Nombre, Leccion, Secuencia"/>
				<cfinvokeargument name="etiquetas" 		value="Actividad,Lecci&oacute;n,Secuencia"/>
				<cfinvokeargument name="formatos" 		value="S,I,I"/>
				<cfinvokeargument name="align" 			value="left,center,center"/>
				<cfinvokeargument name="navegacion" 	value="#navegacion#"/>
				<cfinvokeargument name="ajustar" 		value="N"/>
				<cfinvokeargument name="checkboxes" 	value="N"/>
				<cfinvokeargument name="irA" 			value="Materias.cfm"/>
				<cfinvokeargument name="keys" 			value="CodAct"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="PageIndex" 		value="2"/>
				<cfinvokeargument name="MaxRows"		value="#form.MaxRows#"/>
				<cfinvokeargument name="conexion" 		value="#session.Edu.DSN#"/>			
			</cfinvoke>
		</td>
		<td valign="top">
			<script language="javascript" type="text/javascript" src="../../../sif/js/utilesMonto.js">//</script>
			<form name="form1" method="post" action="SQLMateriaDetalle.cfm">
			<cfoutput>
			<cfif modoDet EQ "ALTA">
				<input name="LeccionTema" type="hidden" id="LeccionTema" value="#LeccionTema#">
				<input name="LeccionEval" type="hidden" id="LeccionEval" value="#LeccionEval#">
			</cfif>
			<cfif isdefined('form.Detalle')><input name="Detalle" type="hidden" value="#form.Detalle#"></cfif>
			<input name="MaxRows" type="hidden" value="#form.MaxRows#">
			<input name="Filtro_Mcodigo" type="hidden" value="<cfif isdefined('Form.Filtro_Mcodigo')>#form.Filtro_Mcodigo#</cfif>">
			<input name="Filtro_MTdescripcion" type="hidden" value="<cfif isdefined('Form.Filtro_MTdescripcion')>#form.Filtro_MTdescripcion#</cfif>">
			<input name="Filtro_Melectiva" type="hidden" value="<cfif isdefined('Form.Filtro_Melectiva')>#form.Filtro_Melectiva#</cfif>">
			<input name="Filtro_Mnombre" type="hidden" value="<cfif isdefined('Form.Filtro_Mnombre')>#form.Filtro_Mnombre#</cfif>">
			<input name="FNcodigoC" type="hidden" value="<cfif isdefined('form.FNcodigoC')>#form.FNcodigoC#</cfif>">
			<input name="FGcodigoC" type="hidden" value="<cfif isdefined('form.FGcodigoC')>#form.FGcodigoC#</cfif>">	
			<input name="Filtro_PEcodigo" type="hidden" value="<cfif isdefined('form.Filtro_PEcodigo')>#form.Filtro_PEcodigo#</cfif>">
			<input name="Filtro_Actividad" type="hidden" value="<cfif isdefined('form.Filtro_Actividad')>#form.Filtro_Actividad#</cfif>">
			<input name="Filtro_Leccion" type="hidden" value="<cfif isdefined('form.Filtro_Leccion')>#form.Filtro_Leccion#</cfif>">
			<input name="Filtro_Secuencia" type="hidden" value="<cfif isdefined('form.Filtro_Secuencia')>#form.Filtro_Secuencia#</cfif>">
			<input name="Pagina" type="hidden" value="#form.Pagina#">
			<input name="Pagina2" type="hidden" value="#form.Pagina2#">
			<input name="Mconsecutivo" type="hidden" id="Mconsecutivo" value="#Form.Mconsecutivo#">
			
			</cfoutput>
				<table width="100%" border="0" cellspacing="1" cellpadding="2">
					<tr> 
						<td class="tituloAlterno" colspan="2" align="center">
							<cfif modoDet eq "ALTA">
								Nueva Actividad 
							<cfelse>
								Modificar Actividad
							</cfif>
						</td>
					</tr>
					<tr> 
						<td valign="middle" align="right" nowrap><strong>Actividad:</strong></td>
						<td nowrap> 
							<cfif modoDet NEQ "ALTA">
								<input name="Actividad" type="hidden" value="<cfoutput>#rsActividad.Codigo#</cfoutput>">
								<cfif isdefined("Form.Tipo") and Form.Tipo EQ 0>
									<cfoutput>Tema</cfoutput> 
								<cfelseif isdefined("Form.Tipo") and Form.Tipo EQ 1>
									<cfoutput>Evaluaci&oacute;n</cfoutput> 
								</cfif>
							<cfelse>
								<select name="Actividad" tabindex="2" onChange="javascript: refreshForm(this);">
									<cfoutput query="rsPendientes"> 
									<option value="#Codigo#">#Nombre#</option>
									</cfoutput> 
									<option value="">-------------------</option>
									<option value="0-<cfoutput>#rsMateria.EVTcodigo#</cfoutput>">Nuevo 
									Tema ...</option>
									<option value="1-<cfoutput>#rsMateria.EVTcodigo#</cfoutput>">Nueva 
									Evaluaci&oacute;n ...</option>
								</select>
							</cfif>
						</td>
					</tr>
					<tr> 
						<td width="40%" align="right" valign="middle" nowrap><strong>Lecci&oacute;n:</strong></td>
						<td width="60%" nowrap> 
						<input name="Leccion" type="text" id="Leccion" size="10" maxlength="8" tabindex="2" style="text-align: right;" onBlur="javascript: fm(this,0);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsActividad.Leccion#</cfoutput></cfif>">
						</td>
					</tr>
					<tr> 
						<td valign="middle" align="right" nowrap><strong>Nombre:</strong></td>
						<td nowrap> 
							<input name="Nombre" type="text" id="Nombre" size="40" maxlength="80" tabindex="2" 
								value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsActividad.Nombre#</cfoutput></cfif>">
						</td>
					</tr>
					<tr id="trContenido" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1><cfoutput>style="display: none"</cfoutput></cfif>> 
						<td valign="top" align="right" nowrap><strong>Contenido:</strong></td>
						<td nowrap> 
							<textarea name="MPdescripcion" cols="30" rows="4" id="MPdescripcion" tabindex="2"><cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>#rsActividad.MPdescripcion#</cfoutput></cfif></textarea>
						</td>
					</tr>
					<tr id="trDuracion" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1><cfoutput>style="display: none"</cfoutput></cfif>> 
						<td valign="middle" align="right" nowrap><strong>Duraci&oacute;n (en lecciones):</strong></td>
						<td nowrap> 
							<input name="MPduracion" type="text" id="MPduracion" size="10" maxlength="6" tabindex="2" 
								style="text-align: right;" 
								onBlur="javascript: fm(this,2);" 
								onFocus="javascript: this.value=qf(this); this.select();" 
								onKeyUp="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								value="<cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>#rsActividad.MPduracion#</cfoutput><cfelse><cfoutput>1.00</cfoutput></cfif>">
						</td>
					</tr>
					<tr id="trConcepto" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>style="display: none"</cfoutput></cfif>> 
						<td valign="middle" align="right" nowrap><strong>Concepto de Evaluaci&oacute;n:</strong></td>
						<td nowrap> 
							<select name="ECcodigo" id="ECcodigo" tabindex="2">
								<option value="">(Seleccione un Concepto)</option>
								<cfoutput query="rsConceptosEval"> 
								<option value="#ECcodigo#" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1 and rsActividad.ECcodigo EQ rsConceptosEval.ECcodigo>selected</cfif>>#ECnombre#</option>
								</cfoutput> 
							</select>
						</td>
					</tr>
					<tr id="trTabla" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>style="display: none"</cfoutput></cfif>> 
						<td valign="middle" align="right" nowrap><strong>Tipo de Evaluaci&oacute;n:</strong></td>
						<td nowrap> 
							<select name="EVTcodigo" id="EVTcodigo">
								<option value="-1" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1 and rsActividad.EVTcodigo EQ "-1">selected</cfif>>-- 
								Seleccione un tipo --</option>
								<cfoutput query="rsTablasEval"> 
								<option value="#EVTcodigo#" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1 and rsActividad.EVTcodigo EQ rsTablasEval.EVTcodigo>selected</cfif>>Usar 
								Tabla: #EVTnombre#</option>
								</cfoutput> 
								</select>
						</td>
					</tr>
					<tr> 
						<td valign="middle" align="right" nowrap><strong>Secuencia:</strong></td>
						<td nowrap> 
							<input name="Secuencia" type="text" id="Secuencia" size="10" maxlength="8" tabindex="2" style="text-align: right;" onBlur="javascript: fm(this,0);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsActividad.Secuencia#</cfoutput></cfif>">
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr align="center"><td colspan="2" nowrap><cf_botones modo="#modoDet#" Regresar="#Session.Edu.RegresarUrl#"></td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>
			</form>
		</td>
	</tr>
</table>
<!--- <table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr> 
		<td  class="tituloListas" valign="top">
			<form name="filtro" method="post" action="Materias.cfm">
				<cfoutput>
				<input name="Detalle" type="hidden" value="#form.Detalle#">
				<input name="Mconsecutivo" type="hidden" value="#form.Mconsecutivo#">
				<input name="Pagina" type="hidden" value="#form.Pagina#">
				<input name="Filtro_Mcodigo" type="hidden" value="<cfif isdefined('Form.Filtro_Mcodigo')>#form.Filtro_Mcodigo#</cfif>">
				<input name="Filtro_MTdescripcion" type="hidden" value="<cfif isdefined('Form.Filtro_MTdescripcion')>#form.Filtro_MTdescripcion#</cfif>">
				<input name="Filtro_Melectiva" type="hidden" value="<cfif isdefined('Form.Filtro_Melectiva')>#form.Filtro_Melectiva#</cfif>">
				<input name="Filtro_Mnombre" type="hidden" value="<cfif isdefined('Form.Filtro_Mnombre')>#form.Filtro_Mnombre#</cfif>">
				<input name="FNcodigoC" type="hidden" value="<cfif isdefined('form.FNcodigoC')>#form.FNcodigoC#</cfif>">
				<input name="FGcodigoC" type="hidden" value="<cfif isdefined('form.FGcodigoC')>#form.FGcodigoC#</cfif>">	
				</cfoutput>
				<table width="100%" cellpadding="2" cellspacing="2" border="0">
					<tr>
						<td>&nbsp;</td>
						<td colspan="5" nowrap> <strong>Periodo de Evaluaci&oacute;n:&nbsp; </strong>
						  <select name="Filtro_PEcodigo" tabindex="1">
							<cfoutput query="rsPeriodos"> 
							  <option value="#PEcodigo#" <cfif isdefined('form.Filtro_PEcodigo') and rsPeriodos.PEcodigo EQ Form.Filtro_PEcodigo>selected</cfif>>#PEdescripcion#</option>
							</cfoutput> 
						  </select>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><strong>Actividad</strong></td>
						<td><strong>Lecci&oacute;n</strong></td>
						<td><strong>Secuencia</strong></td>
					</tr>
					<cfoutput>
					<tr>
						<td>&nbsp;</td>
						<td>
							<input name="Filtro_Actividad" type="text" size="45"
								value="<cfif isdefined('form.Filtro_Actividad')>#form.Filtro_Actividad#</cfif>">
						</td>
						<td>
							<input name="Filtro_Leccion" type="text" size="10"
								value="<cfif isdefined('form.Filtro_Leccion')>#form.Filtro_Leccion#</cfif>">
						</td>
						<td>
							<input name="Filtro_Secuencia" type="text" size="10"
								value="<cfif isdefined('form.Filtro_Secuencia')>#form.Filtro_Secuencia#</cfif>">
						</td>
						<td valign="top"><cf_botones values="Filtrar"></td>
					</tr>
				</cfoutput>
				</table>
			</form>	
		</td>
		<script language="javascript" type="text/javascript" src="../../../sif/js/utilesMonto.js">//</script>
		<form name="form1" method="post" action="SQLMateriaDetalle.cfm">
			<cfoutput>
			<cfif modoDet EQ "ALTA">
				<input name="LeccionTema" type="hidden" id="LeccionTema" value="#LeccionTema#">
				<input name="LeccionEval" type="hidden" id="LeccionEval" value="#LeccionEval#">
			</cfif>
			<cfif isdefined('form.Detalle')><input name="Detalle" type="hidden" value="#form.Detalle#"></cfif>
			<input name="Filtro_Mcodigo" type="hidden" value="<cfif isdefined('Form.Filtro_Mcodigo')>#form.Filtro_Mcodigo#</cfif>">
			<input name="Filtro_MTdescripcion" type="hidden" value="<cfif isdefined('Form.Filtro_MTdescripcion')>#form.Filtro_MTdescripcion#</cfif>">
			<input name="Filtro_Melectiva" type="hidden" value="<cfif isdefined('Form.Filtro_Melectiva')>#form.Filtro_Melectiva#</cfif>">
			<input name="Filtro_Mnombre" type="hidden" value="<cfif isdefined('Form.Filtro_Mnombre')>#form.Filtro_Mnombre#</cfif>">
			<input name="FNcodigoC" type="hidden" value="<cfif isdefined('form.FNcodigoC')>#form.FNcodigoC#</cfif>">
			<input name="FGcodigoC" type="hidden" value="<cfif isdefined('form.FGcodigoC')>#form.FGcodigoC#</cfif>">	
			<input name="Filtro_PEcodigo" type="hidden" value="<cfif isdefined('form.Filtro_PEcodigo')>#form.Filtro_PEcodigo#</cfif>">
			<input name="Filtro_Actividad" type="hidden" value="<cfif isdefined('form.Filtro_Actividad')>#form.Filtro_Actividad#</cfif>">
			<input name="Filtro_Leccion" type="hidden" value="<cfif isdefined('form.Filtro_Leccion')>#form.Filtro_Leccion#</cfif>">
			<input name="Filtro_Secuencia" type="hidden" value="<cfif isdefined('form.Filtro_Secuencia')>#form.Filtro_Secuencia#</cfif>">
			<input name="Pagina" type="hidden" value="#form.Pagina#">
			<input name="Pagina2" type="hidden" value="#form.Pagina2#">
			<input name="Mconsecutivo" type="hidden" id="Mconsecutivo" value="#Form.Mconsecutivo#">
			
			</cfoutput>
			<td width="60%" valign="top" rowspan="10"> 
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr> 
						<td valign="middle" align="right" nowrap><strong>Actividad:</strong></td>
						<td nowrap> 
							<cfif modoDet NEQ "ALTA">
								<input name="Actividad" type="hidden" value="<cfoutput>#rsActividad.Codigo#</cfoutput>">
								<cfif isdefined("Form.Tipo") and Form.Tipo EQ 0>
									<cfoutput>Tema</cfoutput> 
								<cfelseif isdefined("Form.Tipo") and Form.Tipo EQ 1>
									<cfoutput>Evaluaci&oacute;n</cfoutput> 
								</cfif>
							<cfelse>
								<select name="Actividad" tabindex="2" onChange="javascript: refreshForm(this);">
									<cfoutput query="rsPendientes"> 
									<option value="#Codigo#">#Nombre#</option>
									</cfoutput> 
									<option value="">-------------------</option>
									<option value="0-<cfoutput>#rsMateria.EVTcodigo#</cfoutput>">Nuevo 
									Tema ...</option>
									<option value="1-<cfoutput>#rsMateria.EVTcodigo#</cfoutput>">Nueva 
									Evaluaci&oacute;n ...</option>
								</select>
							</cfif>
						</td>
					</tr>
					<tr> 
						<td width="40%" align="right" valign="middle" nowrap><strong>Lecci&oacute;n:</strong></td>
						<td width="60%" nowrap> 
						<input name="Leccion" type="text" id="Leccion" size="10" maxlength="8" tabindex="2" style="text-align: right;" onBlur="javascript: fm(this,0);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsActividad.Leccion#</cfoutput></cfif>">
						</td>
					</tr>
					<tr> 
						<td valign="middle" align="right" nowrap><strong>Nombre:</strong></td>
						<td nowrap> 
							<input name="Nombre" type="text" id="Nombre" size="40" maxlength="80" tabindex="2" 
								value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsActividad.Nombre#</cfoutput></cfif>">
						</td>
					</tr>
					<tr id="trContenido" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1><cfoutput>style="display: none"</cfoutput></cfif>> 
						<td valign="top" align="right" nowrap><strong>Contenido:</strong></td>
						<td nowrap> 
							<textarea name="MPdescripcion" cols="30" rows="4" id="MPdescripcion" tabindex="2"><cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>#rsActividad.MPdescripcion#</cfoutput></cfif></textarea>
						</td>
					</tr>
					<tr id="trDuracion" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1><cfoutput>style="display: none"</cfoutput></cfif>> 
						<td valign="middle" align="right" nowrap><strong>Duraci&oacute;n (en lecciones):</strong></td>
						<td nowrap> 
							<input name="MPduracion" type="text" id="MPduracion" size="10" maxlength="6" tabindex="2" 
								style="text-align: right;" 
								onBlur="javascript: fm(this,2);" 
								onFocus="javascript: this.value=qf(this); this.select();" 
								onKeyUp="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								value="<cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>#rsActividad.MPduracion#</cfoutput><cfelse><cfoutput>1.00</cfoutput></cfif>">
						</td>
					</tr>
					<tr id="trConcepto" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>style="display: none"</cfoutput></cfif>> 
						<td valign="middle" align="right" nowrap><strong>Concepto de Evaluaci&oacute;n:</strong></td>
						<td nowrap> 
							<select name="ECcodigo" id="ECcodigo" tabindex="2">
								<option value="">(Seleccione un Concepto)</option>
								<cfoutput query="rsConceptosEval"> 
								<option value="#ECcodigo#" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1 and rsActividad.ECcodigo EQ rsConceptosEval.ECcodigo>selected</cfif>>#ECnombre#</option>
								</cfoutput> 
							</select>
						</td>
					</tr>
					<tr id="trTabla" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 0><cfoutput>style="display: none"</cfoutput></cfif>> 
						<td valign="middle" align="right" nowrap><strong>Tipo de Evaluaci&oacute;n:</strong></td>
						<td nowrap> 
							<select name="EVTcodigo" id="EVTcodigo" onChange="javascript: crearNuevaTabla(this);">
								<option value="-1" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1 and rsActividad.EVTcodigo EQ "-1">selected</cfif>>-- 
								Digitar Nota --</option>
								<cfoutput query="rsTablasEval"> 
								<option value="#EVTcodigo#" <cfif modoDet NEQ "ALTA" and isdefined("Form.Tipo") and Form.Tipo EQ 1 and rsActividad.EVTcodigo EQ rsTablasEval.EVTcodigo>selected</cfif>>Usar 
								Tabla: #EVTnombre#</option>
								</cfoutput> 
								<option value="">-------------------</option>
								<option value="0">Crear Nueva Tabla ...</option>
							</select>
						</td>
					</tr>
					<tr> 
						<td valign="middle" align="right" nowrap><strong>Secuencia:</strong></td>
						<td nowrap> 
							<input name="Secuencia" type="text" id="Secuencia" size="10" maxlength="8" tabindex="2" style="text-align: right;" onBlur="javascript: fm(this,0);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsActividad.Secuencia#</cfoutput></cfif>">
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr align="center"><td colspan="2" nowrap><cf_botones modo="#modoDet#" Regresar="#Session.Edu.RegresarUrl#"></td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>
			
		</td></form>
  	</tr>
	<tr> 
    	<td width="40%" valign="top"> 
			<cfset navegacion = "">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Detalle=" & Form.Detalle>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pagina=" & Form.Pagina>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mconsecutivo=" & Form.Mconsecutivo>
			<cfif isdefined('form.Filtro_PEcodigo')>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_PEcodigo=" & Form.Filtro_PEcodigo>
			</cfif>
			<cfif isdefined('form.Filtro_Actividad') and LEN(TRIM(form.Filtro_Actividad))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Actividad=" & Form.Filtro_Actividad>
			</cfif>
			<cfif isdefined('form.Filtro_Leccion') and LEN(TRIM(form.Filtro_Leccion))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Leccion=" & Form.Filtro_Leccion>
			</cfif>
			<cfif isdefined('form.Filtro_Secuencia') and LEN(TRIM(form.Filtro_Secuencia))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Secuencia=" & Form.Filtro_Secuencia>
			</cfif>
			<cfif isdefined('form.Filtro_Mcodigo') and LEN(TRIM(form.Filtro_Mcodigo))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Mcodigo=" & Form.Filtro_Mcodigo>
			</cfif>
			<cfif isdefined('form.Filtro_MTdescripcion') and LEN(TRIM(form.Filtro_MTdescripcion))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_MTdescripcion=" & Form.Filtro_MTdescripcion>
			</cfif>
			<cfif isdefined('form.Filtro_Melectiva') and LEN(TRIM(form.Filtro_Melectiva))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Melectiva=" & Form.Filtro_Melectiva>
			</cfif>
			<cfif isdefined('form.Filtro_Mnombre') and LEN(TRIM(form.Filtro_Mnombre))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Mnombre=" & Form.Filtro_Mnombre>
			</cfif>
			<cfif isdefined('form.FNcodigoC') and LEN(TRIM(form.FNcodigoC))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FNcodigoC=" & Form.FNcodigoC>
			</cfif>
			<cfif isdefined('form.FGcodigoC') and LEN(TRIM(form.FGcodigoC))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FGcodigoC=" & Form.FGcodigoC>
			</cfif>
			<cfinvoke 
			 component="sif.rh.Componentes.pListas"
			 method="pListaquery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" 			value="#rsActividades#"/>
				<cfinvokeargument name="desplegar" 		value="Nombre, Leccion, Secuencia"/>
				<cfinvokeargument name="etiquetas" 		value="Actividad,Lecci&oacute;n,Secuencia"/>
				<cfinvokeargument name="formatos" 		value="S,I,I"/>
				<cfinvokeargument name="align" 			value="left,center,center"/>
				<cfinvokeargument name="navegacion" 	value="#navegacion#"/>
				<cfinvokeargument name="ajustar" 		value="N"/>
				<cfinvokeargument name="checkboxes" 	value="N"/>
				<cfinvokeargument name="irA" 			value="Materias.cfm"/>
				<cfinvokeargument name="keys" 			value="CodAct"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="PageIndex" 		value="2"/>
				<cfinvokeargument name="MaxRows"		value="#form.MaxRows#"/>
				<cfinvokeargument name="conexion" 		value="#session.Edu.DSN#"/>			
			</cfinvoke>
		</td>
  </tr>
	<tr><td colspan="2" valign="top">&nbsp;</td></tr>
</table> --->
	<form name="form3" action="MateriaDetalle.cfm" method="post">
		<input type="hidden" name="Mconsecutivo" value="<cfoutput>#Form.Mconsecutivo#</cfoutput>">
		<input name="Filtro_PEcodigo" type="hidden" value="<cfif isdefined('form.Filtro_PEcodigo')>#form.Filtro_PEcodigo#</cfif>">
		<input name="MaxRows" type="hidden" value="#form.MaxRows#">
	</form>
	<cf_qforms>
	<script language="JavaScript" type="text/javascript">

		<!---
		function __isPorcentajes() {
			if ((btnSelected("Alta", this.obj.form) || btnSelected("Cambio", this.obj.form)) && (this.obj.form.ECcodigo.value != "")) {
				if (new Number(this.value) > new Number(restante[this.obj.form.ECcodigo.value])) {
					this.error = "El porcentaje asignado supera el porcentaje disponible para el concepto de evaluación. El porcentaje disponible es de " + restante[this.obj.form.ECcodigo.value] + " %";
				}
			}
		}
		--->
		
		function __isPeriodo() {
			if (this.obj.form.Filtro_PEcodigo.value == "0") {
				this.error = "error";
			}
			if ((btnSelected("Alta", this.obj.form) || btnSelected("Cambio", this.obj.form)) && (this.obj.form.Filtro_PEcodigo.value == "0" || this.obj.form.Filtro_PEcodigo.value == "")) {
				this.error = "El Período de Evaluación es requerido";
			}
		}

		_addValidator("isPeriodo", __isPeriodo);
		<cfif modoDet EQ "ALTA">
	
		function habilitarCampos(control) {
			var tipo = control.value;
			var f = control.form;
			var a = document.getElementById("trContenido");
			var b = document.getElementById("trDuracion");
			var c = document.getElementById("trConcepto");
			var d = document.getElementById("trTabla");
			//var e = document.getElementById("trPorcentaje");
			if (tipo.indexOf("|") != -1) {
				var x = tipo.split("|");
				tipo = x[0];
				// Cargar Concepto de Evaluación
				for (var i=0; i<f.ECcodigo.length; i++) {
					if (f.ECcodigo.options[i].value == x[2]) {
						f.ECcodigo.selectedIndex = i;
						break;
					}
				}
				f.ECcodigo.disabled = true;
				// Cargar Tabla de Evaluacion
				for (var i=0; i<f.EVTcodigo.length; i++) {
					if (f.EVTcodigo.options[i].value == x[3]) {
						f.EVTcodigo.selectedIndex = i;
						break;
					}
				}
				f.EVTcodigo.disabled = true;
				// Cargar Porcentaje
				//f.EMporcentaje.value = x[5];
				// Cargar Nombre
				f.Nombre.value = x[6];
			} else {
				var x = tipo.split("-");
				tipo = x[0];
				f.MPdescripcion.value = "";
				f.MPduracion.value = "1.00";
				f.ECcodigo.selectedIndex = 0;
				f.ECcodigo.disabled = false;
				if (x[1] == "") {
					f.EVTcodigo.selectedIndex = 0;
				} else {
					for (var i=0; i<f.EVTcodigo.length; i++) {
						if (f.EVTcodigo.options[i].value == x[1]) {
							f.EVTcodigo.selectedIndex = i;
							break;
						}
					}
				}
				f.EVTcodigo.disabled = false;
				//f.EMporcentaje.value = "0.00";
				f.Nombre.value = "";
			}
			if (tipo == "0") {
				a.style.display = "";
				b.style.display = "";
				c.style.display = "none";
				d.style.display = "none";
				//e.style.display = "none";
				f.Leccion.value = f.LeccionTema.value;
				objForm.MPduracion.required = true;
				//objForm.EMporcentaje.required = false;
				objForm.ECcodigo.required = false;
			} else if (tipo == "1") {
				a.style.display = "none";
				b.style.display = "none";
				c.style.display = "";
				d.style.display = "";
				//e.style.display = "";
				f.Leccion.value = f.LeccionEval.value;
				objForm.MPduracion.required = false;
				//objForm.EMporcentaje.required = true;
				objForm.ECcodigo.required = true;
			} else {
				a.style.display = "none";
				b.style.display = "none";
				c.style.display = "none";
				d.style.display = "none";
				//e.style.display = "none";
				objForm.MPduracion.required = false;
				//objForm.EMporcentaje.required = false;
				objForm.ECcodigo.required = false;
			}
		}
	
		function refreshForm(c) {
			if (c.value != "") {
				habilitarCampos(c);
			}
			else {
				c.selectedIndex = 0;
				habilitarCampos(c);
			}
		}
	
		</cfif>

		<cfif modoDet EQ "ALTA">
			refreshForm(document.form1.Actividad);
		</cfif>
		
		function deshabilitarValidacion() {
			objForm.Leccion.required = false;
			objForm.Nombre.required = false;
			objForm.MPduracion.required = false;
			//objForm.EMporcentaje.required = false;
			objForm.ECcodigo.required = false;
		}

		<cfif modoDet EQ "ALTA">
			objForm.Actividad.obj.focus();
			objForm.Leccion.validatePeriodo();
			objForm.Leccion.required = true;
			objForm.Leccion.description = "Día";
			objForm.Nombre.required = true;
			objForm.Nombre.description = "Nombre";
			objForm.Actividad.required = true;
			objForm.Actividad.description = "Actividad";
			objForm.MPduracion.required = true;
			objForm.MPduracion.description = "Duración";
			/*
			objForm.EMporcentaje.required = true;
			objForm.EMporcentaje.description = "Porcentaje";
			objForm.EMporcentaje.validatePorcentajes();
			*/
			objForm.ECcodigo.required = true;
			objForm.ECcodigo.description = "Concepto de Evaluación";
		<cfelseif modoDet EQ "CAMBIO">
			objForm.Leccion.obj.focus();
			objForm.Leccion.validatePeriodo();
			objForm.Leccion.required = true;
			objForm.Leccion.description = "Día";
			objForm.Nombre.required = true;
			objForm.Nombre.description = "Nombre";
			<cfif Form.Tipo EQ 0>
			objForm.MPduracion.required = true;
			objForm.MPduracion.description = "Duración";
			<cfelseif Form.Tipo EQ 1>
			/*
			objForm.EMporcentaje.required = true;
			objForm.EMporcentaje.description = "Porcentaje";
			objForm.EMporcentaje.validatePorcentajes();
			*/
			objForm.ECcodigo.required = true;
			objForm.ECcodigo.description = "Concepto de Evaluación";
			</cfif>
		</cfif>

	</script>