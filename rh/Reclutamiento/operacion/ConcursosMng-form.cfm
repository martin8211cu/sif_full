<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EnProceso"
	Default="En Proceso"
	returnvariable="LB_EnProceso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Solicitado"
	Default="Solicitado"
	returnvariable="LB_Solicitado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desierto"
	Default="Desierto"
	returnvariable="LB_Desierto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cerrado"
	Default="Cerrado"
	returnvariable="LB_Cerrado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Verificado"
	Default="Verificado"
	returnvariable="LB_Verificado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EnRevision"
	Default="En Revisión"
	returnvariable="LB_EnRevision"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Publicado"
	Default="Publicado"
	returnvariable="LB_Publicado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Evaluando"
	Default="Evaluando"
	returnvariable="LB_Evaluando"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Terminado"
	Default="Terminado"
	returnvariable="LB_Terminado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Listado_de_Concursos"
	Default="Listado de Concursos"
	returnvariable="LB_Listado_de_Concursos"/>

<cfinclude template="ConcursosMng-config.cfm">

    <cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
<cfquery name="rsListaConcursos" datasource="#session.DSN#">
	select a.RHCconcurso,
		   a.RHCcodigo as codigo,
		   #LvarRHCdescripcion# as descripcion,
		   a.RHCfapertura as fechaapertura,
		   a.RHCfcierre as fechacierre,
		   a.RHCcantplazas as cantidadplazas,
		   a.RHPcodigo,
		   #LvarRHPdescpuesto# as RHPdescpuesto,
		   case a.RHCestado
		        when 0	then '#LB_EnProceso#'
				when 10	then '#LB_Solicitado#'
				when 20 then '#LB_Desierto#'
				when 30 then '#LB_Cerrado#'
				when 15 then '#LB_Verificado#'
				when 40 then '#LB_EnRevision#'
				when 50 then '#LB_Publicado#'
				when 60 then '#LB_Evaluando#'
				when 70 then '#LB_Terminado#'
				else ''
		   end as Estado,
		   c.CFdescripcion,
		   {fn concat(dp.Pnombre,{fn concat(' ',{fn concat(dp.Papellido1,{fn concat(' ',dp.Papellido2)})})})}  as solicitante
	from RHConcursos a

		inner join RHPuestos b
			on b.RHPcodigo = a.RHPcodigo
			and b.Ecodigo = a.Ecodigo

		inner join CFuncional c
			on c.CFid = a.CFid
			and c.Ecodigo = a.Ecodigo

		left outer join Usuario u
			on u.Usucodigo = a.Usucodigo

		left outer join DatosPersonales dp
			on dp.datos_personales = u.datos_personales

	where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHCestado in (10, 15, 40, 50, 60)
	<cfif isdefined("form.flag")>
	  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfif>
	<cfif isdefined("form.fRHCcodigo") and len(trim(form.fRHCcodigo)) gt 0>
	  and upper(a.RHCcodigo) like '%#Ucase(trim(form.fRHCcodigo))#%'
	</cfif>
	<cfif isdefined("form.fRHCdescripcion") and len(trim(form.fRHCdescripcion)) gt 0>
	  and upper(#LvarRHCdescripcion#) like '%#Ucase(trim(form.fRHCdescripcion))#%'
	</cfif>
	<cfif isdefined("form.fCFid") and len(trim(form.fCFid)) gt 0>
	  and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCFid#">
	</cfif>
	<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0>
	  and upper(a.RHPcodigo) like '%#Ucase(trim(form.fRHPcodigo))#%'
	</cfif>
	<cfif isdefined("Form.fRHCfapertura") and Len(Trim(Form.fRHCfapertura))>
	  and a.RHCfapertura >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fRHCfapertura)#">
	</cfif>
	<cfif isdefined("Form.fRHCfcierre") and Len(Trim(Form.fRHCfcierre))>
	  and a.RHCfcierre <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fRHCfcierre)#">
	</cfif>
	<cfif isdefined("Form.fsolicitante") and Len(Trim(Form.fsolicitante)) and Form.fsolicitante NEQ -1>
	  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fsolicitante#">
	</cfif>
	order by fechacierre desc, fechaapertura
</cfquery>

<!--- Solicitantes que han ingresado concursos --->
<cfquery name="rsSolicitantes" datasource="#Session.DSN#">
	select distinct a.Usucodigo as Codigo,
			{fn concat(c.Papellido1,{fn concat(' ',{fn concat(c.Papellido2,{fn concat(', ',c.Pnombre)})})})} as Nombre
	from RHConcursos a
		inner join Usuario b
			on b.Usucodigo = a.Usucodigo
		inner join DatosPersonales c
			on c.datos_personales = b.datos_personales
	where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHCestado in (10, 15, 40, 50, 60)
</cfquery>

<script language="javascript" type="text/javascript">
	function NuevoConcurso() {
		location.replace('<cfoutput>#currentPage#</cfoutput>');
	}

	function goSelected(v) {
		document.formConcursos.RHCconcurso.value = v;
		document.formConcursos.submit();
	}

	function showSearchBox() {
		location.href = 'ConcursoMng-lista.cfm';
	}
</script>

<cfoutput>

	<form name="formConcursos" method="post" action="#currentPage#" style="margin: 0;">
		<cfinclude template="ConcursosMng-hiddens.cfm">
	</form>

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">

	  <!--- SECCION DE ADMINISTRACION DE CONCURSOS --->
	  <tr id="trAdmConcursos">
		<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td style="background-color:##CCCCCC;font-size:14px; font-weight:bold;">
					&nbsp;<cf_translate key="LB_Concurso">Concurso</cf_translate>:&nbsp;
					<cfif modoAdmConcursos EQ "CAMBIO">
						#rsRHConcursos.RHCcodigo# &nbsp; #rsRHConcursos.RHCdescripcion#
					</cfif>
				</td>
				<td align="right" style="color:##333333; background-color:##CCCCCC; font-family:'Times New Roman', Times, serif; font-variant:small-caps; font-size:14px; font-weight:bold;">
					<a href="javascript: showSearchBox();" style="font-size:12px;">
						<img src="/cfmx/rh/imagenes/back.png" border="0" title="Regresar" align="absmiddle">[<cf_translate key="LB_Listado_de_Concursos">Listado de Concursos</cf_translate>]</strong></a>&nbsp;
				</td>
			  </tr>
			  <tr>
				<td colspan="2">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="2">
					<cf_tabs width="98%">
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_DatosDelConcurso"
							Default="Datos del Concurso"
							returnvariable="LB_DatosDelConcurso"/>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_NuevoConcurso"
							Default="Nuevo Concurso"
							returnvariable="LB_NuevoConcurso"/>
						<cfif modoAdmConcursos EQ "CAMBIO">
							<cfset tituloTab1 = LB_DatosDelConcurso>
						<cfelse>
							<cfset tituloTab1 = LB_NuevoConcurso>
						</cfif>
						<cf_tab text="#tituloTab1#" selected="#Form.tab EQ 1#">
							<cfif Form.tab EQ 1>
								<cfinclude template="ConcursosMng-tab1.cfm">
							</cfif>
						</cf_tab>
						<!--- Estos tabs solo aparecen en modo cambio --->
						<cfif modoAdmConcursos EQ "CAMBIO">
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Plazas"
							Default="Plazas"
							returnvariable="LB_Plazas"/>
						<cf_tab text="#LB_Plazas#" selected="#Form.tab EQ 2#">
							<cfif Form.tab EQ 2>
								<cfinclude template="ConcursosMng-tab2.cfm">
							</cfif>
						</cf_tab>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_Aplica_para"
                            Default="Aplica para"
                            returnvariable="LB_Aplica_para"/>
                        <cf_tab text="#LB_Aplica_para#" selected="#Form.tab EQ 3#">
							<cfif Form.tab EQ 3>
								<cfinclude template="ConcursosMng-tab_Aplica_para.cfm">
							</cfif>
						</cf_tab>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_CriteriosDeEvaluacion"
							Default="Criterios de Evaluaci&oacute;n"
							returnvariable="LB_CriteriosDeEvaluacion"/>

						<cf_tab text="#LB_CriteriosDeEvaluacion#" selected="#Form.tab EQ 4#">
							<cfif Form.tab EQ 4>
								<cfinclude template="ConcursosMng-tab3.cfm">
							</cfif>
						</cf_tab>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Concursantes"
							Default="Concursantes"
							returnvariable="LB_Concursantes"/>

						<cf_tab text="#LB_Concursantes#" selected="#Form.tab EQ 5#">
							<cfif Form.tab EQ 5>
								<cfinclude template="ConcursosMng-tab4.cfm">
							</cfif>
						</cf_tab>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_CambiarEstado"
							Default="Cambiar Estado"
							returnvariable="LB_CambiarEstado"/>

						<cf_tab text="#LB_CambiarEstado#" selected="#Form.tab EQ 6#">
							<cfif Form.tab EQ 6>
								<cfinclude template="ConcursosMng-tab5.cfm">
							</cfif>
						</cf_tab>
						</cfif>
					</cf_tabs>
				</td>
			  </tr>
			  <tr>
				<td colspan="2">&nbsp;</td>
			  </tr>
			</table>
		</td>
	  </tr>
	</table>

</cfoutput>