<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeConcursosTerminados"
	Default="Lista de concursos terminados"
	returnvariable="LB_ListaDeConcursosTerminados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SeleccioneElCursoParaLaAdjudicacion"
	Default="Seleccione el curso para la adjudicación"
	returnvariable="MSG_SeleccioneElCursoParaLaAdjudicacion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AdjudicacionDePlazas"
	Default="Adjudicación de plazas"
	returnvariable="LB_AdjudicacionDePlazas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_RealiceLaReasignacionDePlazasAdjudicadas"
	Default="Realice la reasignación de plazas adjudicadas"
	returnvariable="MSG_RealiceLaReasignacionDePlazasAdjudicadas"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DatosDeLosConcursantes"
	Default="Datos de los concursantes"
	returnvariable="LB_DatosDeLosConcursantes"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_IngreseLosDatosDeLosConcursantes"
	Default="Ingrese los datos de los concursantes"
	returnvariable="MSG_IngreseLosDatosDeLosConcursantes"/>	

<!--- Pantalla --->
<cfset titulo = "">
<cfset indicacion = "">
<cfif form.Paso EQ 0>
	<cfset titulo = LB_ListaDeConcursosTerminados>
	<cfset indicacion = MSG_SeleccioneElCursoParaLaAdjudicacion>
<cfelseif form.Paso EQ 1>
	<cfset titulo = LB_AdjudicacionDePlazas>
	<cfset indicacion = MSG_RealiceLaReasignacionDePlazasAdjudicadas>
<cfelseif form.Paso EQ 2>
	<cfset titulo = LB_DatosDeLosConcursantes>
	<cfset indicacion = MSG_IngreseLosDatosDeLosConcursantes>
</cfif>
<cfif isdefined("form.RHCconcurso") and len(trim(form.RHCconcurso))>
	<cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
	<cfquery name="rsConcurso" datasource="#session.DSN#">
		select {fn concat(RHCcodigo,{fn concat('-',#LvarRHCdescripcion#)})} as concurso, 
		  a.RHPcodigo, 
		   #LvarRHPdescpuesto# as RHPdescpuesto
		from RHConcursos a
			inner join RHPuestos b
				on b.RHPcodigo = a.RHPcodigo
				and b.Ecodigo = a.Ecodigo
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
	</cfquery>
</cfif>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="4">
	  <tr>
			<cfif form.Paso NEQ 0>
				<td width="1%" align="right">
					<img border="0" src="/cfmx/rh/imagenes/number#form.Paso#_64.gif" align="absmiddle">
				</td>
			</cfif>
			<td style="padding-left: 10px;" valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
					<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>
					</tr>
					<cfif isdefined("rsConcurso") and rsConcurso.RecordCount NEQ 0>
						<tr>
							<td class="tituloPersona" align="left" style="text-align:left; font-size:13px" nowrap>
								<strong><cf_translate key="LB_Concuros">Concurso</cf_translate>: #rsConcurso.concurso#</strong>
							</td>
						</tr>
						<tr>
							<td class="tituloPersona" align="left" style="text-align:left;font-size:13px" nowrap>
								<strong><cf_translate key="LB_Puesto" xmlFile="generales.xml">Puesto</cf_translate>: #rsConcurso.RHPcodigo# - #rsConcurso.RHPdescpuesto#</strong>
							</td>
						</tr>
					</cfif>
				</table>
			</td>
	  </tr>
	</table>
</cfoutput>
