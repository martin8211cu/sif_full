<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

<cf_templatecss>
	<cf_htmlReportsHeaders
		irA="consultaPlazasDisponibles.cfm"
		FileName="Consulta_Plazas_Disponibles_#DateFormat(now(), "dd-mmm-yyyy")#.xls"
		title="Consulta Plazas Disponibles">
		
				<cfinvoke key="CentroFuncional" default="<b>Centro Funcional</b>" returnvariable="CentroFuncional" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="Plaza" default="<b>Plaza</b>" returnvariable="Plaza" component="sif.Componentes.Translate"  method="Translate"/>
				
				<cfinvoke key="CFtodos" default="Todos las Centros Funcionales desde RAIZ" returnvariable="CFtodos" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="PTodos" default="Todos los puestos" returnvariable="PTodos" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="CF" default="Centro Funcional:&nbsp;" returnvariable="CF" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="CFDepend" default=" (Incluyendo Dependencias)" returnvariable="CFDepend" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="CodPu" default="C&oacute;digo Puesto:&nbsp" returnvariable="CodPu" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="CentrosFaltantesSegunParametros" default="<b>Seg&uacute;n par&aacute;metros, los siguientes Centros Funcionales no presentan plazas disponibles:</b>  " returnvariable="CentrosFaltantesSegunParametros" component="sif.Componentes.Translate"  method="Translate"/>

				<cfinvoke key="LB_ConsultaPlazasDisponibles" default="Consulta Plazas Disponibles" returnvariable="LB_ConsultaPlazasDisponibles" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="LB_CentroFuncional" default="Centro Funcional" returnvariable="LB_CentroFuncional" xmlfile="/rh/generales.xml" component="sif.Componentes.Translate"   method="Translate"/>
				<cfinvoke key="LB_FechaDesde" default="Fecha Desde" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate"   method="Translate"/>
				<cfinvoke key="LB_FechaHasta" default="Fecha Hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate"   method="Translate"/>
				<cfinvoke key="LB_CodigoPlaza" default="Código Plaza" returnvariable="LB_CodigoPlaza" component="sif.Componentes.Translate" xmlfile="/rh/generales.xml"  method="Translate"/>
				<cfinvoke key="LB_CodigoPuesto" default="Código Puesto" returnvariable="LB_CodigoPuesto" component="sif.Componentes.Translate" xmlfile="/rh/generales.xml"  method="Translate"/>
				<cfinvoke key="LB_DescripcionPlaza" default="Descripción Plaza" returnvariable="LB_DescripcionPlaza" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="LB_DescripcionPuesto" default="Descripción Puesto" returnvariable="LB_DescripcionPuesto" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="LB_Disponibilidad" default="Disponibilidad" returnvariable="LB_Disponibilidad" component="sif.Componentes.Translate" xmlfile="/rh/generales.xml"  method="Translate"/>
				<cfinvoke key="LB_Codigo" default="Código" returnvariable="LB_Codigo" component="sif.Componentes.Translate" xmlfile="/rh/generales.xml"  method="Translate"/>
				<cfinvoke key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" xmlfile="/rh/generales.xml"  method="Translate"/>

<cfoutput>
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>

				
			<!--- Pintando encabezado---->
									
						<cfset centroFun="<b>#CentroFuncional#:&nbsp;</b>"&"#CFtodos#">
						<cfset puesto="<b>#CodPu#:&nbsp;</b>"&"#PTodos#">
						
						<cfif isdefined("form.CFid") and Len(Trim(form.CFid)) >
								<cfset centroFun ="<b>#CF#</b>"&"#form.CFdescripcion#" >
						</cfif>
						
			
						<cfif isdefined('form.dependencias')>	
							<cfset centroFun =centroFun & "#CFDepend#">
						</cfif>
						
						<cfif isdefined("form.RHPpuesto") and Len(Trim(form.RHPpuesto))>
							<cfset puesto="<b>#CodPu#</b>"&"#form.RHPpuesto#">
						</cfif>
						
						<cfset fechasD="<b>#LB_FechaDesde#:</b>#form.FechaDesde#">
						<cfset fechasH="<b>#LB_FechaHasta#:</b>#form.FechaHasta#">
						
						
					<cf_EncReporte
					Titulo="#LB_ConsultaPlazasDisponibles#"
					Color="##E3EDEF"
					filtro1="#centroFun#"
					filtro2="#puesto#"
					filtro3="#fechasD#"
					filtro4="#fechasH#"
					Cols= 11>
			<!--- fin de Pintando encabezado---->
			</td>
		</tr>
	</table>
</cfoutput>
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2114" default="" returnvariable="LvarNota"/>


<!--- Este codigo define la opcion de INCLUIR DEPENDENCIAS --->
<cfset Centros ="#form.CFid#">

<cfif isdefined("form.CFid") and Len(Trim(form.CFid)) and isdefined('form.dependencias')>
			<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
					CFid = "#form.CFid#"
					Nivel = 5
					returnvariable="Dependencias"/>
				<cfset Centros = ValueList(Dependencias.CFid)>
</cfif>
<cfif not isdefined("form.CFid") or not Len(Trim(form.CFid))>
	<cfquery name="getRaiz" datasource="#session.DSN#">
	select CFid
	from CFuncional
	where Ecodigo=#session.Ecodigo#
	and CFpath=<cfqueryparam cfsqltype="cf_sql_varchar" value="RAIZ">
	</cfquery>
			<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
		CFid = "#getRaiz.CFid#"
		Nivel = 5
		returnvariable="DependenciasR"/>
	<cfset Centros = ValueList(DependenciasR.CFid)>
</cfif>
<!--- FIN codigo define la opcion de INCLUIR DEPENDENCIAS --->



<!--- Pintando el Reporte --->
<cfset Faltantes="<br><table  align='left' width='100%' cellpadding='2' cellspacing='5'><tr><td width='5%'><strong>#LB_Codigo#</strong></td><td width='35%'><strong>#LB_Descripcion#</strong></td>">
<!--- variable con los centros faltantes que no tienen plazas segun los filtros--->	
<cfloop list="#Centros#" index="CFid" delimiters=",">
	<cf_dbtemp name="temp_plazas" returnvariable="tbPlazas" datasource="#session.dsn#">
		<cf_dbtempcol name="RHPid"				type="numeric"  	mandatory="no">
		<cf_dbtempcol name="CFcodigo"			type="char(10)"  	mandatory="no">
		<cf_dbtempcol name="CFdescripcion"		type="varchar(255)"  	mandatory="no">
		<cf_dbtempcol name="codPlazas"			type="varchar(10)"		mandatory="no">
		<cf_dbtempcol name="RHPdescripcion"		type="varchar(255)"		mandatory="no">
		<cf_dbtempcol name="puesto"		        type="char(10)"		mandatory="no">
		<cf_dbtempcol name="RHPdescpuesto"		type="varchar(255)"	    mandatory="no">
		<cf_dbtempcol name="disponible"			type="numeric"	    mandatory="no">
	</cf_dbtemp>


	<cf_translatedata tabla="CFuncional" col="CFdescripcion" name="get" returnvariable="LvarCFdescripcion"/>
	<cf_translatedata tabla="RHPlazas" col="RHPdescripcion" name="get" returnvariable="LvarRHPdescripcion"/>
	<cf_translatedata tabla="RHPuestos" col="RHPdescpuesto" name="get" returnvariable="LvarRHPdescpuesto"/>
	<!--- consulta los centros funcionales con plazas libres-------------------------------------->
	<cfquery name="RsCFPlazas" datasource="#session.DSN#">
		insert into #tbPlazas#(RHPid, CFcodigo, CFdescripcion, codPlazas, RHPdescripcion, puesto, RHPdescpuesto, disponible)
	
				Select pz.RHPid,cf.CFcodigo, #LvarCFdescripcion# as CFdescripcion,
		   pz.RHPcodigo as codPlazas, #LvarRHPdescripcion# as RHPdescripcion,
		   pu.RHPcodigo as puesto, #LvarRHPdescpuesto# as RHPdescpuesto,
		   (select coalesce(sum(zr.LTporcplaza), 0.00) 
							from LineaTiempo zr 
							where pz.RHPid = zr.RHPid 
							and pz.Ecodigo = zr.Ecodigo
							<!--- filtro de fechas--->
							 <cfif isdefined('form.FechaHasta') and len(trim(form.FechaHasta)) gt 0>
								and  LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
							</cfif>  
							<cfif isdefined('form.FechaDesde') and len(trim(form.FechaDesde)) gt 0>
								and LThasta >= 	<cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">	 
							</cfif>
							)  as ocupacion 
		from CFuncional cf
			 inner join RHPlazas pz
				  on cf.CFid=pz.CFid
			 inner join RHPuestos pu
				  on pz.RHPpuesto=pu.RHPcodigo
				  and pz.Ecodigo=pu.Ecodigo
		Where cf.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and (Select count(1)
			 from LineaTiempo lt
			 Where pz.RHPid=lt.RHPid
			 	<!--- filtro de fechas--->
				 <cfif isdefined('form.FechaHasta') and len(trim(form.FechaHasta)) gt 0>
					and  LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
				</cfif>  
				<cfif isdefined('form.FechaDesde') and len(trim(form.FechaDesde)) gt 0>
					and LThasta >= 	<cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">	 
				</cfif>
			 having coalesce(sum(lt.LTporcplaza), 0) <= 100 )  = 0
	
		and pz.RHPactiva = 1
		<cfif isdefined("form.CFid") and Len(Trim(form.CFid))>
			AND cf.CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CFid#">
		</cfif>

		<cfif isdefined("form.RHPpuesto") and Len(Trim(form.RHPpuesto))>
			and pu.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPpuesto#">
		</cfif>
	</cfquery>

<!--- 	<cf_dumptable var="#tbPlazas#"> --->
	
	
	<!--- consulta plazas en recargo----------->
	
	
	<cfquery name="RsCFPlazasR" datasource="#session.DSN#">
		insert into #tbPlazas#(RHPid, CFcodigo, CFdescripcion, codPlazas, RHPdescripcion, puesto, RHPdescpuesto, disponible)
			Select pz.RHPid,cf.CFcodigo, #LvarCFdescripcion# as CFdescripcion,
				pz.RHPcodigo as codPlazas, #LvarRHPdescripcion# as RHPdescripcion,
				pu.RHPcodigo as puesto,  #LvarRHPdescpuesto# as RHPdescpuesto,
				(select  coalesce(sum(zr.LTporcplaza), 0.00) 
							from LineaTiempoR zr 
							where pz.RHPid = zr.RHPid 
							and pz.Ecodigo = zr.Ecodigo
							<!--- filtro de fechas--->
							 <cfif isdefined('form.FechaHasta') and len(trim(form.FechaHasta)) gt 0>
								and  LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
							</cfif>  
							<cfif isdefined('form.FechaDesde') and len(trim(form.FechaDesde)) gt 0>
								and LThasta >= 	<cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">	 
							</cfif>
							)  as ocupacion 
			from CFuncional cf
				 inner join RHPlazas pz
					  on cf.CFid=pz.CFid
				 inner join RHPuestos pu
					  on pz.RHPpuesto=pu.RHPcodigo
					  and pz.Ecodigo=pu.Ecodigo
			Where cf.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and (Select count(1)
				 from LineaTiempo lt
				 Where pz.RHPid=lt.RHPid
				 	<!--- filtro de fechas--->
					 <cfif isdefined('form.FechaHasta') and len(trim(form.FechaHasta)) gt 0>
						and  LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
					</cfif>  
					<cfif isdefined('form.FechaDesde') and len(trim(form.FechaDesde)) gt 0>
						and LThasta >= 	<cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">	 
					</cfif>
				 having coalesce(sum(lt.LTporcplaza), 0) <= 100 ) = 0
			and pz.RHPactiva = 1
	
			<cfif isdefined("form.RHPpuesto") and Len(Trim(form.RHPpuesto))>
				AND cf.CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CFid#">
			</cfif>

			<cfif isdefined("form.RHPpuesto") and Len(Trim(form.RHPpuesto))>
				and pu.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPpuesto#">
			</cfif>

	</cfquery>
	
	<cfquery name="rsDisponibles" datasource="#session.DSN#">
		select RHPid, CFcodigo, CFdescripcion, codPlazas, RHPdescripcion, puesto, RHPdescpuesto,coalesce(100-sum(disponible),0) as DISPONIBLE 
		from #tbPlazas# 
		group by codPlazas,RHPid, CFcodigo, CFdescripcion, codPlazas, RHPdescripcion, puesto, RHPdescpuesto
	</cfquery>

	
		
	<!--- FIN consulta los centros funcionales con plazas Disponibles-------------------------------------->
					
	<cfif rsDisponibles.RecordCount GT 0> <!--- Pinta aquellas que realmente tienen plazas en la dependencia--->
					<cfoutput>	
					<table bordercolor="000000"  align="center" width="100%" cellpadding="2" cellspacing="5">
							<tr>
						<cfoutput><td colspan="5" bgcolor="859998"><strong>#LB_CentroFuncional#:&nbsp;</strong>#rsDisponibles.CFCODIGO# - #rsDisponibles.CFDESCRIPCION#</td></cfoutput>
					</tr>	
				
							<tr>
								<td width="10%"><strong>#LB_CodigoPlaza#</strong></td>	
								<td width="20%"><strong>#LB_DescripcionPlaza#</strong></td>
								<td width="10%"><strong>#LB_CodigoPuesto#</strong></td>	
								<td width="30%"><strong>#LB_DescripcionPuesto#</strong></td>
								<td width="10%"><strong>#LB_Disponibilidad#</strong></td>
							</tr>
									
							<tr>
						
						<cfloop query="rsDisponibles">
							</tr>			
								<td>#CODPLAZAS#</td>
								<td>#RHPDESCRIPCION#</td>
								<td>#PUESTO#</td>	
								<td>#RHPDESCPUESTO#</td>				
								<td>#DISPONIBLE#%</td>
							</td>
						</cfloop>
							
							</tr>	
					</table>
						</cfoutput>
				<!--- Fin del if para mostrar---->
	<cfelse>
	<cfquery name="rsNoDispobles" datasource="#session.DSN#">
		select CFcodigo as cod,CFdescripcion as nombre
			from CFuncional
			where Ecodigo=#session.Ecodigo#
			and CFid=#CFid#
	</cfquery>
				<cfset Faltantes=Faltantes & "<TR><TD>#rsNoDispobles.cod#</TD><TD>#rsNoDispobles.nombre#</TD></TR>">
	</cfif >		
		<!--- FIN consulta los centros funcionales con plazas libres-------------------------------------->

</cfloop><!--- fin del recorrido de la lista que posee los id de los centros--->	
				
<cfset Faltantes=Faltantes&"</table>">
<cfif Len(Trim(Faltantes))>
	<cfoutput><br>#CentrosFaltantesSegunParametros# #Faltantes#</cfoutput>
</cfif>
		

<cfoutput>
	<b><br /><center>-------------- <cf_translate key="LB_FINDELACONSULTA">FIN DE LA CONSULTA</cf_translate> ---------------</center></b>
</cfoutput> 


<!--- --->


<!--- fin de pintar el reporte--->