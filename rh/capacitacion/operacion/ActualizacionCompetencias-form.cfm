<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LB_Aprobar = t.Translate('LB_Aprobar','Aprobar','/rh/generales.xml')>
<cfset LB_Rechazar = t.Translate('LB_Rechazar','Rechazar','/rh/generales.xml')>
<cfset LB_Regresar = t.Translate('LB_Regresar','Regresar','/rh/generales.xml')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_Desde = t.Translate('Fdesde','Desde','/rh/generales.xml')>
<cfset LB_Hasta = t.Translate('Fhasta','Hasta','/rh/generales.xml')>
<cfset LB_Estado = t.Translate('LB_Estado','Estado','/rh/generales.xml')>
<cfset LB_NivelPuesto = t.Translate('LB_NivelPuesto','Nivel (Puesto)','/rh/capacitacion/expediente/expediente.xml')>
<cfset LB_NivelEmpleado = t.Translate('LB_NivelEmpleado','Nivel (Empleado)','/rh/capacitacion/expediente/expediente.xml')>
<cfset LB_Dominio = t.Translate('LB_Dominio','Dominio','/rh/capacitacion/expediente/expediente.xml')>
<cfset LB_Aprobado = t.Translate('LB_Aprobado','Aprobado','/rh/generales.xml')>

<cfif isdefined("fromAprobacionCV")>
	<style type="text/css">
		.btnAnterior{display:none;}
	</style>
</cfif>
<!---20140718 - ljimenez parametro para que solo captura del aNo en el registro de competencias--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2658" default="0" returnvariable="lvarSoloAnnoCompetencia"/>
<cfset lvarSoloAnnoCompetencia=0>
<cf_dbfunction name="op_concat" returnvariable="_cat">

<cfquery name="puesto" datasource="#session.DSN#">
	select coalesce(ltrim(rtrim(p.RHPcodigoext)),ltrim(rtrim(p.RHPcodigo))) as RHPcodigo, p.RHPdescpuesto
	from LineaTiempo lt
	
	inner join RHPuestos p
	on lt.Ecodigo=p.Ecodigo
	and lt.RHPcodigo=p.RHPcodigo
	
	where lt.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
</cfquery>

<cf_translatedata name="get" tabla="RHHabilidades" col="RHHdescripcion" returnvariable="LvarRHHdescripcion">
<cf_translatedata name="get" tabla="RHConocimientos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">

<cf_translatedata name="get" tabla="RHNiveles" col="d.RHNdescripcion" returnvariable="LvarRHNdescripcionD">
<cf_translatedata name="get" tabla="RHNiveles" col="rhn.RHNdescripcion" returnvariable="LvarRHNdescripcionDRHN">


<cf_dbfunction name="date_part" args="YYYY°a.RHCEfhasta" returnvariable="Lvarfechahasta" delimiters="°">
<cf_dbfunction name="to_char" args="#Lvarfechahasta#" returnvariable="LvarfechahastaChar">
<cfquery name="rsCompetencias" datasource="#session.dsn#">
	select a.DEid
			,RHCEid
			,tipo
			,idcompetencia
			,RHCEdominio
			<cfif tipo eq 'H'>
				,RHHcodigo as Cod
				,#LvarRHHdescripcion# as descripcion
			<cfelse><!---- conocimientos---->
				,RHCcodigo as Cod
				,#LvarRHCdescripcion# as descripcion
			</cfif>
			,coalesce(d.RHNcodigo#_cat#' - '#_cat#  #LvarRHNdescripcionD#,'---') as RHNcodigo
			,a.RHNid
			,coalesce(rhn.RHNcodigo#_cat#' - '#_cat# #LvarRHNdescripcionDRHN#,'---') as RHNcodigoUser
            
            ,<cf_dbfunction name="date_part" args="YYYY,a.RHCEfdesde"> as RHCEfdesde

            <cfif not lvarSoloAnnoCompetencia>
            	, case when #Lvarfechahasta# = 6100 then '-' else
            			#LvarfechahastaChar# end as RHCEfhasta
            </cfif>
            ,a.RHCestado
            ,case when a.RHCestado = 1 then 'X' else '' end as estado
	from RHCompetenciasEmpleado  a
		<cfif tipo eq 'H'>
			inner join RHHabilidades  b
				on a.idcompetencia = b.RHHid
				and a.Ecodigo = b.Ecodigo
				and coalesce(b.RHHinactivo,0) = 0
			<cfif isdefined("DEid") and len(trim(DEid))>
				left outer join RHHabilidadesPuesto c
					on b.RHHid = c.RHHid
					and b.Ecodigo = c.Ecodigo
					and c.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#puesto.RHPcodigo#">
					left outer join RHNiveles d
						on c.RHNid = d.RHNid
			</cfif>	
		<cfelse><!----- en el caso que sea por conocimientos---->
			inner join RHConocimientos  b
				on a.idcompetencia = b.RHCid
				and a.Ecodigo = b.Ecodigo
				and coalesce(b.RHCinactivo,0) = 0
			<cfif isdefined("DEid") and len(trim(DEid))>
				left outer join RHConocimientosPuesto c
					on b.RHCid = c.RHCid
					and b.Ecodigo = c.Ecodigo
					and c.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#puesto.RHPcodigo#">
					left outer join RHNiveles d
						on c.RHNid = d.RHNid
			</cfif>	
		</cfif>	
		left join RHNiveles rhn
					on a.RHNid = rhn.RHNid
			
	<cfif isdefined("RHOid") and len(trim(RHOid))>
		where RHOid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#"> 
	<cfelse>
		where DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
	</cfif>
		and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  tipo = '#tipo#'
		and a.RHCEfdesde >= (
								select max(B.RHCEfdesde) from RHCompetenciasEmpleado B 
								<cfif isdefined("RHOid") and len(trim(RHOid))>
									where B.RHOid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#"> 
								<cfelse>
									where B.DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
								</cfif>
								and   B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and   B.Ecodigo = a.Ecodigo 
								and   B.tipo = '#tipo#' 
								and   B.idcompetencia = a.idcompetencia
							) 	
	order by a.RHCEfdesde,7
</cfquery>


<cf_navegacion name="RHCEid"/>
<cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
	<cfset destino = "AprobacionCV-sql.cfm" >	
	<cfif tipo eq 'C'>
		<cfset self="AprobacionCV.cfm?tab=1">	
	<cfelse>	
		<cfset self="AprobacionCV.cfm?tab=2">	
	</cfif>
<cfelse>
	<cfset destino = "ActualizacionEstudiosR-sql.cfm" >	
	<cfset self="ActualizacionEstudiosR.cfm">
</cfif>

<cfif not isDefined("fromAprobacionCV")>
	<table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td colspan="2"><cfinclude template="../expediente/info-empleado.cfm"></td>
		</tr>
	</table>
</cfif>
<cf_dbfunction name="op_concat" returnvariable="concat">
 

<table width="100%" cellpadding="0" cellspacing="0" align="center">
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td width="50%" valign="top">
			<cfset LvarFormatData = 'dd/mm/yyyy'>
			<cfif findNoCase("en", session.idioma)>
				<cfset LvarFormatData = 'mm/dd/yyyy'>
			</cfif>

			<cfset LvarFecha='RHCEfdesde'>
			<cfset LvarFormatos='V'>
			<cfset LvarAlign='left'>
			<cfset LvarFechaDesde=LB_Desde>
			<cfif not lvarSoloAnnoCompetencia>
				<cfset LvarFecha='RHCEfdesde,RHCEfhasta'>
				<cfset LvarFechaDesde&=','&LB_Hasta>
				<cfset LvarFormatos&=',V'>
				<cfset LvarAlign&=',left'>
			</cfif>
			<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsCompetencias#"/>
				<cfinvokeargument name="desplegar" value="descripcion,#LvarFecha#, RHNcodigo,RHNcodigoUser,RHCEDominio,estado"/>
				<cfinvokeargument name="etiquetas" value="#LB_Descripcion#,#LvarFechaDesde#,#LB_NivelPuesto#,#LB_NivelEmpleado#,#LB_Dominio#,#LB_Aprobado#"/>
				<cfinvokeargument name="formatos" value="V,V,V,V,V,#LvarFormatos#,V"/>
				<cfinvokeargument name="align" value="left,left,left,left,#LvarAlign#,center"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="RHCEid,DEid"/>
				<cfinvokeargument name="irA" value="#self#"/>
				<cfinvokeargument name="formName" value="formCompetenciasLista"/>
			</cfinvoke>
		</td>
		<cfif isDefined("form.RHCEid") and len(trim(form.RHCEid))>
			<cfquery dbtype="query" name="data">
				select * from rsCompetencias where RHCEid = #form.RHCEid#
			</cfquery>
		</cfif>
		<td width="50%" valign="top">
			
			<cfoutput>
			<form name="formCompetencias" action="#destino#" method="post">
				<input type="hidden" name="DEid" value="#form.DEid#">
				<input type="hidden" name="RHCEid" value="<cfif isdefined('data')>#data.RHCEid#</cfif>">
				<cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
					<cfif tipo eq 'C'>
						<input type="hidden" name="tab" value="1">	
					<cfelse>	
						<input type="hidden" name="tab" value="2">
					</cfif>
				</cfif>
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td width="20%" align="right"><strong>#LB_Descripcion#:&nbsp;</strong></td>
						<td width="32%"><cfif isdefined("data")>#data.descripcion#</cfif></td>
					</tr>
					<tr>
						<td align="right" nowrap><strong>#LB_Desde#:&nbsp;</strong></td>
						<td><cfif isdefined("data")>#data.RHCEfdesde#</cfif></td>
					</tr>
					<tr>
						<td align="right" nowrap><strong>#LB_Hasta#:&nbsp;</strong></td>
						<td><cfif isdefined("data")>#data.RHCEfhasta#</cfif></td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_NivelPuesto#:&nbsp;</strong></td>
						<td><cfif isdefined("data")>#data.RHNcodigo#</cfif></td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_NivelEmpleado#:&nbsp;</strong></td>
						<td><cfif isdefined("data")>#data.RHNcodigoUser#</cfif></td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_Dominio#:&nbsp;</strong></td>
						<td><cfif isdefined("data")>#data.RHCEDominio#</cfif></td>
					</tr>
					<tr>
						<td align="right">&nbsp;</td> 
					</tr>

					<tr>
						<td colspan="4" align="center">
							<cfif isdefined("data")>
								<cfif data.RHCestado eq 1>
									<cf_botones values="#LB_Rechazar#" names="btnRechazar">
								<cfelse>
									<cf_botones values="#LB_Aprobar#" names="btnAprobar">
								</cfif>
							</cfif>		
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>
			</form>
			</cfoutput>
			
		</td>
	</tr>
</table>