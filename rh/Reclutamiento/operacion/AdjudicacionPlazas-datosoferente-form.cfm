<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_IngresoDeDatosDelOferente"
	Default="Ingreso de datos del oferente"
	returnvariable="LB_IngresoDeDatosDelOferente"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SalarioBase"
	Default="SalarioBase"
	returnvariable="LB_SalarioBase"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Categoria"
	Default="Categoría"
	returnvariable="LB_Categoria"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaRige"
	Default="Fecha Rige"
	returnvariable="LB_FechaRige"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SelectTipoAccion"
	Default="Seleccione el tipo de Acción"
	returnvariable="LB_SelectTipoAccion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoDeAccion"
	Default="Tipo de Acción"
	returnvariable="LB_TipoDeAccion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SelectTipoTabla"
	Default="Seleccione el tipo de tabla"
	returnvariable="LB_SelectTipoTabla"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SelectPuesto"
	Default="Seleccione el puesto"
	returnvariable="LB_SelectPuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SelectCategoria"
	Default="Seleccione la categoría"
	returnvariable="LB_SelectCategoria"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoDeTabla"
	Default="Tipo de Tabla"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_TipoDeTabla"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puestos"
	Default="Puestos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Puestos"/>


<cfif isdefined("url.RHAlinea") and len(trim(url.RHAlinea))>
	<cfset form.RHAlinea = url.RHAlinea>
</cfif>
<cfif isdefined("url.RHCconcurso") and len(trim(url.RHCconcurso))>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>

<cf_translatedata name="get" tabla="RHTipoAccion" col="RHTdesc" returnvariable="LvarRHTdesc">
<cfquery name="rsAcciones" datasource="#session.dsn#">
	select RHTid,RHTcodigo,#LvarRHTdesc# as RHTdesc,	RHTpfijo as RHTtiponomb
	from RHTipoAccion
	where RHTcomportam in (1,6)
	and Ecodigo=#session.Ecodigo#
</cfquery>

<!----/////////// Update del mantenimiento ////////////////----->
<cfif isdefined("form.Cambio")>
        <cfif isdefined('form.RHTTid')>

           <!---Actualiza la tabla de adjudicaciones con la categoría seleccionada--->
           <cfquery name="rsUpdateCategoria" datasource="#session.dsn#">
                Update RHAdjudicacion
                	set RHCid = #form.RHCid#
                where RHAlinea = #form.RHAlinea#
           </cfquery>

		   <!---Actualiza la linea del tiempo de la plaza en caso de utilizarse tablas salariales--->
           <cfquery name="rsUpdateCategoria" datasource="#session.dsn#">
                Update RHLineaTiempoPlaza
                	set RHCid = #form.RHCid#,
                    	RHTTid = #form.RHTTid#
                where RHPid=(select RHPid from RHAdjudicacion where RHAlinea=#form.RHAlinea#)
           </cfquery>

            <cfquery name="rsSalario" datasource="#session.dsn#">
                select max(coalesce(b.RHMCmonto,0)) as SB
                from RHLineaTiempoPlaza lp
                        inner join RHMontosCategoria b
                        on lp.RHCid=b.RHCid
                        inner join RHVigenciasTabla c
                        on c.RHVTid = b.RHVTid
                        and c.RHVTestado='A'
                        and  #LSParseDateTime(form.DLfvigencia)# between RHVTfecharige and RHVTfechahasta
                where lp.RHPid=(select RHPid from RHAdjudicacion where RHAlinea=#form.RHAlinea#)
                and c.RHTTid=#form.RHTTid#
            </cfquery>

        </cfif>

		<cfif isdefined('rsSalario') and rsSalario.RecordCount GT 0 and Trim(rsSalario.SB) neq ''>
       <!--- len(trim(rsSalario.SB)) eq 0--->
	     	<cfset LvarS=#rsSalario.SB#>
		<cfelse>
    		<cfset LvarS= #replace(form.DLsalario,",","","all")#>
		</cfif>

		<!---				select max(coalesce(b.RHMCmonto,0)) as SB
						from RHCategoriasPuesto a
						inner join RHPlazaPresupuestaria p
							inner join RHPlazas z
							on z.RHPPid=p.RHPPid
							and z.RHPid=
						on p.RHMPPid=a.RHMPPid
						inner join RHMontosCategoria b
						on b.RHCid = a.RHCid
						inner join RHVigenciasTabla c
						on c.Ecodigo = a.Ecodigo
						and c.RHVTid = b.RHVTid
						and c.RHTTid = a.RHTTid
						where a.Ecodigo = 1
						and RHVTestado = 'A'--->
<!---	<cfquery name="rsSalario" datasource="#session.dsn#">
		select max(coalesce(b.RHMCmonto,0)) as SB
		from RHCategoriasPuesto a
		inner join RHPlazaPresupuestaria p
			inner join RHPlazas z
			on z.RHPPid=p.RHPPid
			and z.RHPid= (select RHPid from RHAdjudicacion where RHAlinea=#form.RHAlinea#)
		on p.RHMPPid=a.RHMPPid
		inner join RHMontosCategoria b
		on b.RHCid = a.RHCid
		inner join RHVigenciasTabla c
		on c.Ecodigo = a.Ecodigo
		and c.RHVTid = b.RHVTid
		and c.RHTTid = a.RHTTid
		where a.Ecodigo = 1
		and RHVTestado = 'A'
		and #LSParseDateTime(form.DLfvigencia)# between RHVTfecharige and RHVTfechahasta
	</cfquery>

	<cfif isdefined('rsSalario') and len(trim(rsSalario.SB)) eq 0>
		<cfset LvarS=0>
	<cfelse>
		<cfset LvarS=#rsSalario.SB#>
	</cfif>--->

	<!---<cf_dbtimestamp datasource="#session.dsn#"
		table="RHAdjudicacion"
		redirect="Adjudicacion-datosoferente-form.cfm"
		timestamp="#form.ts_rversion#"
		field1="Ecodigo"
		type1="integer"
		value1="#session.Ecodigo#"
		field2="RHAlinea"
		type2="numeric"
		value2="#form.RHAlinea#">	--->

	<!---Update sobre RHAdjudicacion---->

	<cfquery datasource="#session.DSN#" name="rsTipoAccion">
		select  count(1) as valor
		from RHTipoAccion
		where RHTcomportam in (1,6)
		and Ecodigo=#session.Ecodigo#
		and RHTtiponomb = 0
		and RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update RHAdjudicacion
		set RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RVid#">,
			Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">,
			RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">,
			RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">,
			DLfvigencia = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DLfvigencia)#">,
			<cfif rsTipoAccion.valor eq 1>
				DLffin = null
			<cfelse>
				<cfif isdefined("form.DLffin") and len(trim(form.DLffin))>
					DLffin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.DLffin)#">
				<cfelse>
					DLffin = <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,1,1)#">
				</cfif>
			</cfif>,
			RHAporc = <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHAporc#">,
			RHAporcsal = <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHAporcsal#">,
			DLsalario = <cfqueryparam cfsqltype="cf_sql_money" value="#LvarS#">
			<cfif isdefined('form.RHTTid')>
	            ,RHTTid=#form.RHTTid#
           	</cfif>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAlinea#">
	</cfquery>



	<cfif isdefined("form.bntIndicador") ><!---UPDATE SOBRE RHParametros--->
		<cfif isdefined("form.tipo") and form.tipo EQ 'I'>
			<cfquery datasource="#session.DSN#">
				update RHParametros
				set Pvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHTid#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and Pcodigo =  470
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.DSN#">
				update RHParametros
				set Pvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHTid#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and Pcodigo =  460
			</cfquery>
		</cfif>
	</cfif>
	<cflocation url="AdjudicacionPlazas-datosoferente-form.cfm?RHAlinea=#form.RHAlinea#">
</cfif>
<!----////////// Fin Update //////////////////////////////----->
<!---/////////// Querys de combos ///////////----->
<!---Tipos de accion de nombramiento--->
<cf_translatedata name="get" tabla="RHTipoAccion" col="RHTdesc" returnvariable="LvarRHTdesc">
<cfquery name="rstAccionNomb" datasource="#session.DSN#">
	select RHTcodigo,#LvarRHTdesc# as RHTdesc,RHTid
	from RHTipoAccion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHTcomportam = 1
	order by RHTcodigo,RHTdesc
</cfquery>
<!---Tipos de accion de cambio--->
<cfquery name="rstAccionCamb" datasource="#session.DSN#">
	select RHTcodigo,#LvarRHTdesc# as RHTdesc,RHTid
	from RHTipoAccion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHTcomportam = 6
	order by RHTcodigo,RHTdesc
</cfquery>
<!---Tipos de nomina--->
<cf_translatedata name="get" tabla="TiposNomina" col="Tdescripcion" returnvariable="LvarTdescripcion">
<cfquery name="rstNomina" datasource="#session.DSN#">
	select  Tcodigo,#LvarTdescripcion# as Tdescripcion
	from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	Order by Tcodigo,Tdescripcion
</cfquery>
<!----Tipos de regimen de vacaciones--->
<cf_translatedata name="get" tabla="RegimenVacaciones" col="Descripcion" returnvariable="LvarDescripcion">
<cfquery name="rstRegimen" datasource="#session.DSN#">
	select RVid,RVcodigo,#LvarDescripcion# as Descripcion
	from RegimenVacaciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	Order by RVcodigo,Descripcion
</cfquery>
<!---Jornadas---->
<cf_translatedata name="get" tabla="RHJornadas" col="RHJdescripcion" returnvariable="LvarRHJdescripcion">
<cfquery name="rstJornadas" datasource="#session.DSN#">
	select RHJid,RHJcodigo,#LvarRHJdescripcion# as RHJdescripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	Order by RHJcodigo,RHJdescripcion
</cfquery>

<cf_translatedata name="get" tabla="RHPlazas" col="c.RHPdescripcion" returnvariable="LvarRHPdescripcion">
<cf_translatedata name="get" tabla="Departamentos" col="e.Ddescripcion" returnvariable="LvarDdescripcion">
<cf_translatedata name="get" tabla="Oficinas" col="f.Odescripcion" returnvariable="LvarOdescripcion">
<cf_translatedata name="get" tabla="CFuncional" col="cf.CFdescripcion" returnvariable="LvarCFdescripcion">
<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	a.RVid,
			a.Tcodigo,
			a.RHTid,
			a.RHJid,
			a.DLfvigencia,
			a.DLffin,
			a.DLsalario,
			a.RHAporc,
			a.RHAporcsal,
			a.ts_rversion,
			c.RHPcodigo,
			c.RHPdescripcion,
			d.RHPcodigo as PuestoCodigo,
			#LvarRHPdescripcion# as RHPdescpuesto,
			a.RHCconcurso,
			e.Deptocodigo,
			#LvarDdescripcion# as Ddescripcion,
			f.Oficodigo,
			a.RHTTid,
            a.RHPid,
			#LvarOdescripcion# as Odescripcion,
			case  when a.DEid is not null then 'I'
			else 'E' end as tipo,
            a.RHCid,
            cf.CFcodigo,
            #LvarCFdescripcion# as CFdescripcion,
            c.RHPsalarionegociado

	from RHAdjudicacion a
		inner join RHPlazasConcurso b
			on a.Ecodigo = b.Ecodigo
			and a.RHCconcurso = b.RHCconcurso
			and a.RHPid = b.RHPid

			inner join RHPlazas c
				on b.Ecodigo = c.Ecodigo
				and b.RHPid = c.RHPid

				inner join RHPuestos d
					on c.Ecodigo = d.Ecodigo
					and c.RHPpuesto = d.RHPcodigo

				inner join Departamentos e
					on c.Ecodigo = e.Ecodigo
					and c.Dcodigo = e.Dcodigo

				inner join Oficinas f
					on c.Ecodigo = f.Ecodigo
					and c.Ocodigo = f.Ocodigo
                inner join CFuncional cf
                   on c.Ecodigo = cf.Ecodigo
                  and c.CFid = cf.CFid

		where	a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and	a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAlinea#">
</cfquery>

<!---////////Parametro de tipo de accion //////////////---->
<cfif isdefined("rsDatos") and rsDatos.tipo EQ 'E'>
	<cfquery name="rsParam" datasource="#session.DSN#">
		select Pvalor,RHTcodigo,RHTdesc,RHTid
		from RHParametros a
			left outer join RHTipoAccion b
				on a.Ecodigo = b.Ecodigo
				and a.Pvalor = <cf_dbfunction name="to_char" args="b.RHTid">
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 460
	</cfquery>
<cfelseif isdefined("rsDatos") and rsDatos.tipo EQ 'I'>
	<cfquery name="rsParam" datasource="#session.DSN#">
		select Pvalor,RHTcodigo,RHTdesc,RHTid
		from RHParametros a
			left outer join RHTipoAccion b
				on a.Ecodigo = b.Ecodigo
				and a.Pvalor = <cf_dbfunction name="to_char" args="b.RHTid">
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 470
	</cfquery>
</cfif>

<cfquery name="rsDatosTiposNomina" datasource="#Session.DSN#">
	select * from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	 <cfif isdefined("rsDatos.Tcodigo") and len(trim(rsDatos.Tcodigo))>
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsDatos.Tcodigo)#">
	<cfelse>
		and 1=0
	</cfif>
</cfquery>

<cf_templatecss>

<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//-->
</script>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cf_translate key="LB_IngresoDeDatosOferentes">Ingreso de datos de oferentes</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
	<cfoutput>
		<form name="formDatos" method="post" action=""><!---action="AdjudicacionPlazas-datosoferente-sql.cfm"---->
			<input name="RHCconcurso" type="hidden" value="#rsDatos.RHCconcurso#">
			<input type="hidden" name="RHAlinea" value="#form.RHAlinea#">
			<input type="hidden" name="tipo" value="#rsDatos.tipo#">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsDatos.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">

			<cf_web_portlet_start titulo='#LB_IngresoDeDatosDelOferente#'>
				<table width="100%" cellpadding="2" cellspacing="0" align="center">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" style="font-size:11px"><strong><cf_translate key="LB_Plaza">Plaza</cf_translate>:&nbsp;</strong></td>
						<td style="font-size:11px"><strong>#rsDatos.RHPcodigo# - #rsDatos.RHPdescripcion#</strong></td>
					</tr>
					<tr>
                    <tr>
						<td align="right" style="font-size:11px"><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;</strong></td>
						<td style="font-size:11px"><strong>#rsDatos.PuestoCodigo# - #rsDatos.RHPdescpuesto#</strong></td>
					</tr>
					<tr>
						<td align="right" style=" border-bottom:9px; font-size:11px"><strong><cf_translate key="LB_Oficina">Oficina</cf_translate>:&nbsp;</strong></td>
						<td style="font-size:11px"><strong>#rsDatos.Oficodigo# - #rsDatos.Odescripcion#</strong></td>
					</tr>
					<tr>
						<td align="right" style="font-size:11px"><strong><cf_translate key="LB_Departamento">Departamento</cf_translate>:&nbsp;</strong></td>
						<td style="font-size:11px"><strong>#rsDatos.Deptocodigo# - #rsDatos.Ddescripcion#</strong></td>
					</tr>
                    <tr>
						<td align="right" style="font-size:11px"><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>
						<td style="font-size:11px"><strong>#rsDatos.CFcodigo# - #rsDatos.CFdescripcion#</strong></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td class="fileLabel" height="25" nowrap align="right"><strong>#LB_TipoDeAccion#:</strong></td>
						<td height="25" nowrap>
							<select name="RHTid" id="RHTid" onchange="javascript:MostrarFechaHasta()" >
								<option value=""> #LB_SelectTipoAccion# </option>
								<cfloop query="rsAcciones">
									<option title="#rsAcciones.RHTtiponomb#" value="#rsAcciones.RHTid#" <cfif isdefined('rsDatos') and rsDatos.RHTid eq rsAcciones.RHTid>selected="selected"</cfif> >#rsAcciones.RHTcodigo#-#rsAcciones.RHTdesc#</option>
								</cfloop>
							</select>
						</td>
					</tr>

					<!--- Averiguar si hay que utilizar la tabla salarial --->
					<cfquery name="rsTipoTabla" datasource="#Session.DSN#">
						select CSusatabla
						from ComponentesSalariales
						where
							Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and CSsalariobase = 1
					</cfquery>
					<cfif rsTipoTabla.recordCount GT 0>
						<cfset usaEstructuraSalarial = rsTipoTabla.CSusatabla>
					<cfelse>
						<cfset usaEstructuraSalarial = 0>
					</cfif>

					<cfif usaEstructuraSalarial EQ 1>
						<cf_translatedata name="get" tabla="RHCategoria" col="f.RHCdescripcion" returnvariable="LvarRHCdescripcion">
						<cf_translatedata name="get" tabla="RHPuestos" col="pp.RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
						<cf_translatedata name="get" tabla="RHTTablaSalarial" col="RHTTdescripcion" returnvariable="LvarRHTTdescripcion">
	                    <cfquery name="rsTablasCategorias" datasource="#Session.DSN#">
							select distinct tt.RHTTid, rtrim(RHTTcodigo) as RHTTcodigo, #LvarRHTTdescripcion# as RHTTdescripcion,
	                        	f.RHCid, f.RHCcodigo,#LvarRHCdescripcion# as RHCdescripcion, pp.RHPcodigo, #LvarRHPdescpuesto# as RHPdescpuesto
								from RHPlazas rhp
								inner join RHPuestos pp
									on rhp.Ecodigo = pp.Ecodigo
									and rhp.RHPpuesto = pp.RHPcodigo

								inner join RHMaestroPuestoP b
									on b.RHMPPid = pp.RHMPPid
									and b.Ecodigo =pp.Ecodigo

								inner join RHCategoriasPuesto c
									on c.RHMPPid = b.RHMPPid
									and c.Ecodigo = b.Ecodigo

	                            inner join RHCategoria f
									on c.RHCid = f.RHCid

								inner join RHTTablaSalarial   tt
									on tt.RHTTid = c.RHTTid

								inner join RHVigenciasTabla v
									on tt.RHTTid = v.RHTTid
							where tt.Ecodigo = #session.Ecodigo#
							and rhp.RHPid = #rsDatos.RHPid#
							--order by tt.RHTTcodigo
	                    </cfquery>

	                    <cfquery name="rsTablas" dbtype="query">
							select distinct RHTTid,  RHTTcodigo, RHTTdescripcion
	                        from rsTablasCategorias
	                    </cfquery>

	                    <cfquery name="rsCategorias" dbtype="query">
							select distinct RHCid,RHCcodigo,RHCdescripcion
	                        from rsTablasCategorias
	                    </cfquery>

	                    <cfquery name="rsPuestos" dbtype="query">
							select distinct RHPcodigo, RHPdescpuesto
	                        from rsTablasCategorias
	                    </cfquery>

						<tr>
							<td align="right"><strong>#LB_TipoDeTabla#:</strong></td>
	                        <td>
								<select name="RHTTid">
									<option value=""> #LB_SelectTipoTabla# </option>
									<cfloop query="rsTablas">
										<option value="#rsTablas.RHTTid#"<cfif isdefined("rsDatos") and rsDatos.RHTTid EQ rsTablas.RHTTid>
										selected</cfif>>#rsTablas.RHTTcodigo# - #rsTablas.RHTTdescripcion#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right"><strong>#LB_Puestos#:</strong></td>
	                        <td>
	                        	<select name="RHPcodigo">
	                        		<option value=""> #LB_SelectPuesto# </option>
									<cfloop query="rsPuestos">
										<option value=""> --- <cf_translate key="LB_Seleccione" xmlfile="/rh/generales.xml">Seleccione</cf_translate> --- </option>
	                                    <option value="#rsPuestos.RHPcodigo#" <cfif isdefined("rsDatos") and trim(rsDatos.PuestoCodigo) EQ trim(rsPuestos.RHPcodigo)> selected </cfif>
	                                    >#rsPuestos.RHPcodigo# - #rsPuestos.RHPdescpuesto#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right"><strong><cf_translate key="LB_Categoria" xmlfile="/rh/generales.xml">Categoría</cf_translate>:</strong></td>
	                        <td>
								<select name="RHCid">
									<option value=""> #LB_SelectCategoria# </option>
									<cfloop query="rsCategorias">
										<option value=""> --- <cf_translate key="LB_Seleccione" xmlfile="/rh/generales.xml">Seleccione</cf_translate> --- </option>
	                                    <option value="#rsCategorias.RHCid#" <cfif isdefined("rsDatos") and rsDatos.RHCid EQ rsCategorias.RHCid>
										selected</cfif>>#rsCategorias.RHCcodigo# - #rsCategorias.RHCdescripcion#</option>
									</cfloop>
								</select>
							</td>
						</tr>
	                </cfif>

                    <!---<cfif isdefined('rsTablas') and rsTablas.RecordCount GT 0>
					<tr>
						<td align="right"><strong><cf_translate key="LB_TipoDeTabla" xmlfile="/rh/generales.xml">Tipo de Tabla</cf_translate>:</strong></td>
                        <td>
							<select name="RHTTid">
								<cfloop query="rsTablas">
									<option value="#rsTablas.RHTTid#"<cfif isdefined("rsDatos") and rsDatos.RHTTid EQ rsTablas.RHTTid>
									selected</cfif>>#rsTablas.RHTTcodigo# - #rsTablas.RHTTdescripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
                    </cfif>
                     <cfif isdefined('rsTablas') and rsTablas.RecordCount GT 0>
					<tr>
						<td align="right"><strong><cf_translate key="LB_TipoDeNomina">Tipo de n&oacute;mina</cf_translate>:&nbsp;</strong></td>
						<td>
							<select name="RHCid">
								<cfloop query="rsCategorias">
									<option value=""> --- <cf_translate key="LB_Seleccione" xmlfile="/rh/generales.xml">Seleccione</cf_translate> --- </option>
                                    <option value="#rsCategorias.RHCid#" <cfif isdefined("rsDatos") and rsDatos.RHCid EQ rsCategorias.RHCid>
									selected</cfif>>#rsCategorias.RHCcodigo# - #rsCategorias.RHCdescripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
                    </cfif>
                    <cfif isdefined('rsPuestos') and rsPuestos.RecordCount GT 0>
					<tr>
						<td align="right"><strong><cf_translate key="LB_Puestos" xmlfile="/rh/generales.xml">Puestos</cf_translate>:</strong></td>
                        <td><select name="RHPcodigo">
								<cfloop query="rsPuestos">
									<option value=""> --- <cf_translate key="LB_Seleccione" xmlfile="/rh/generales.xml">Seleccione</cf_translate> --- </option>
                                    <option value="#rsPuestos.RHPcodigo#" <cfif isdefined("rsDatos") and trim(rsDatos.PuestoCodigo) EQ trim(rsPuestos.RHPcodigo)> selected </cfif>
                                    >#rsPuestos.RHPcodigo# - #rsPuestos.RHPdescpuesto#</option>
								</cfloop>
							</select>
						</td>
					</tr>
                    </cfif>--->

					<tr>
						<td align="right"><strong><cf_translate key="LB_TipoDeNomina">Tipo de n&oacute;mina</cf_translate>:&nbsp;</strong></td>
						<td align="left">
							<cf_rhtiponominaCombo index="0" form="formDatos" query="#rsDatosTiposNomina#" todas="False">
							<!---<select name="Tcodigo" id="Tcodigo">
								<cfloop query="rstNomina">
									<option value="#rstNomina.Tcodigo#" <cfif isdefined("rsDatos") and len(trim(rsDatos.Tcodigo)) and rsDatos.Tcodigo EQ rstNomina.Tcodigo>selected</cfif>>#rstNomina.Tcodigo# - #rstNomina.Tdescripcion#</option>
								</cfloop>
							</select>--->
						</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key="LB_FechaRige">Fecha rige</cf_translate>:&nbsp;</strong></td>
						<td align="left">
							<cfif isdefined("rsDatos") and len(trim(rsDatos.RHAporc))>
								<cf_sifcalendario conexion="#session.DSN#" form="formDatos" name="DLfvigencia" value="#LSDateformat(rsDatos.DLfvigencia,'dd/mm/yyyy')#">
							<cfelse>
								<cf_sifcalendario conexion="#session.DSN#" form="formDatos" name="DLfvigencia" value="#LSDateFormat(Now(), 'dd/mm/yyyy')#">
							</cfif>
						</td>
					</tr>
					<div id="divFechaHasta">
					<tr>
						<td align="right">
							<div id="tdFfintxt1" style="display:none;">
								<strong><cf_translate key="LB_FechaRige">Fecha hasta</cf_translate>:&nbsp;</strong></td>
							</div>
						<td align="left">
							<div id="tdFfintxt2" style="display:none;">
								<cfif isdefined("rsDatos") and len(trim(rsDatos.RHAporc))>
									<cf_sifcalendario conexion="#session.DSN#" form="formDatos" name="DLffin" value="#LSDateformat(rsDatos.DLffin,'dd/mm/yyyy')#">
								<cfelse>
									<cf_sifcalendario conexion="#session.DSN#" form="formDatos" name="DLffin" value="#LSDateFormat(Now(), 'dd/mm/yyyy')#">
								</cfif>
							</div>
						</td>
					</tr>
					</div>
					<tr>
						<td align="right"><strong><cf_translate key="LB_RegimenDeVacaciones">R&eacute;gimen de vacaciones</cf_translate>:&nbsp;</strong></td>
						<td>
							<select name="RVid" id="RVid">
								<cfloop query="rstRegimen">
									<option value="#rstRegimen.RVid#" <cfif isdefined("rsDatos") and len(trim(rsDatos.RVid)) and rsDatos.RVid EQ rstRegimen.RVid>selected</cfif>>#rstRegimen.RVcodigo# - #rstRegimen.Descripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key="LB_ProcentajeOcupacion">Porcentaje Ocupaci&oacute;n</cf_translate>:&nbsp;</strong></td>
						<td><input name="RHAporc" type="text" size="10" maxlength="8" value="<cfif isdefined("rsDatos") and len(trim(rsDatos.RHAporc))>#LSNumberFormat(rsDatos.RHAporc, ',9.00')#<cfelse>100.00</cfif>" onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align:right">%</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key="PorcentajeSalarioFijo">Porcentaje Salario Fijo</cf_translate>:&nbsp;</strong></td>
						<td><input name="RHAporcsal" type="text" size="10" maxlength="8" value="<cfif isdefined("rsDatos") and len(trim(rsDatos.RHAporcsal))>#LSNumberFormat(rsDatos.RHAporcsal, ',9.00')#<cfelse>100.00</cfif>" onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align:right">%</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key="LB_Jornada">Jornada</cf_translate>:&nbsp;</strong></td>
						<td>
							<select name="RHJid" id="RHJid">
								<cfloop query="rstJornadas">
									<option value="#rstJornadas.RHJid#" <cfif isdefined("rsDatos") and len(trim(rsDatos.RHJid)) and rsDatos.RHJid EQ rstJornadas.RHJid>selected</cfif>>#rstJornadas.RHJcodigo# - #rstJornadas.RHJdescripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key="LB_SalarioBase">Salario base</cf_translate>:&nbsp;</strong></td>
						<td><input name="DLsalario" type="text"  size="20" maxlength="18" value="<cfif isdefined("rsDatos") and len(trim(rsDatos.DLsalario))>#LSNumberFormat(rsDatos.DLsalario,',9.00')#</cfif>" onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" <cfif usaEstructuraSalarial EQ 1 and rsDatos.RHPsalarionegociado eq 0 > readonly </cfif>></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="center" colspan="2">
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Modificar"
								Default="Modificar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Modificar"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Cerrar"
								Default="Cerrar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Cerrar"/>
							<input type="submit" name="Cambio" value="#BTN_Modificar#" onClick="habilitarValidacion();">&nbsp;
							<input type="button" name="btnCerrar" value="#BTN_Cerrar#" onClick="javascript: window.close();">
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			<cf_web_portlet_end>
			 <input type="hidden" name="usarFechaFin" id="usarFechaFin" value="0">
		</form>
	</cfoutput>
	<script language="JavaScript" type="text/javascript">
		qFormAPI.errorColor = "#FFFFCC";
		objForm8 = new qForm("formDatos");

		objForm8.DLsalario.disabled= false;
		<cfif usaEstructuraSalarial EQ 1 >
			objForm8.RHCid.disabled= false;
		</cfif>

		<cfoutput>
	        objForm8.DLsalario.required= true;
	        objForm8.DLsalario.description="#LB_SalarioBase#";
	        objForm8.DLfvigencia.required= true;
        	objForm8.DLfvigencia.description="#LB_FechaRige#";
        	objForm8.RHTid.required= true;
        	objForm8.RHTid.description="#LB_TipoDeAccion#";
        	<cfif usaEstructuraSalarial EQ 1 >
        		objForm8.RHTTid.description="#LB_TipoDeTabla#";
        		objForm8.RHPcodigo.description="#LB_Puestos#";
        		objForm8.RHCid.description="#LB_Categoria#";
        	</cfif>
	    </cfoutput>

		function habilitarValidacion(){
			document.formDatos.DLsalario.disabled= false;
			document.formDatos.DLfvigencia.disabled= false;
			objForm8.DLsalario.required= true;
			objForm8.DLfvigencia.required= true;
			<cfif usaEstructuraSalarial EQ 1 >
				objForm8.RHTTid.required= true;
				objForm8.RHPcodigo.required= true;
				objForm8.RHCid.required= true;
			</cfif>
		}

		function MostrarFechaHasta(){
		var miOpcion=document.getElementById("RHTid");
		var usarFechaFin=document.getElementById("usarFechaFin");

		var casillaFecha1 = document.getElementById("tdFfintxt1");
		var casillaFecha2 = document.getElementById("tdFfintxt2");
		var opcion = miOpcion.options[miOpcion.selectedIndex].title;

		if(opcion != 0){
			casillaFecha1.style.display = "";
			casillaFecha2.style.display = "";
			usarFechaFin.value="1";
		}
		else{
			casillaFecha1.style.display = "none";
			casillaFecha2.style.display = "none";
			usarFechaFin.value="0";
		}


		}

		MostrarFechaHasta();
	</script>


</body>
</html>

