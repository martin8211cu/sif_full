  <cfif  isdefined("form.sel")  and not isdefined("url.sel")>
  	<cfset Seleccion = form.sel>
  </cfif>
    <cfif  isdefined("url.sel")  and not isdefined("form.sel")>
  	<cfset Seleccion = url.sel>
  </cfif>
  <cfif  isdefined("url.RHPcodigo")  and not isdefined("form.RHPcodigo")>
  	<cfset form.RHPcodigo = url.RHPcodigo>
  </cfif>
  <cfif  not isdefined("CurrentPage")>
  	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
  </cfif>
  <cfif  not isdefined("Gpaso")>
  	<cfset Gpaso = 3>
  </cfif>

  <cfif  isdefined("Seleccion") >
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfset vsFiltro = ''>
	<cfif isdefined("form.paso") and Len(Trim(form.paso)) NEQ 0>
		<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "paso=" & form.paso>
	</cfif>	
	<cfif isdefined("Seleccion") and Len(Trim(Seleccion)) NEQ 0>
		<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "sel=" & Seleccion>
	</cfif>

	<cf_rhimprime datos="/rh/sucesion/operacion/PlanSucesion-paso3.cfm" paramsuri="&RHPcodigo=#form.RHPcodigo#&#vsFiltro#"> 
 </cfif>
<!---*******************************--->
<!---  inicialización de variables  --->
<!---*******************************--->
<cfset form.TIENE = "S">
<!---*******************************--->
<!---  área de consultas            --->
<!---*******************************--->
<cfquery name="rsPuesto" datasource="#session.DSN#">
	select coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigoext,a.RHPcodigo, a.RHPdescpuesto, b.PSporcreq
		from RHPuestos  a
		left outer join RHPlanSucesion b   
				on a.Ecodigo = b.Ecodigo
				and a.RHPcodigo = b.RHPcodigo
	where a.Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHPcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
</cfquery>

<cfquery name="habilidades_requeridas" datasource="#session.DSN#">
	select a.RHHid, b.RHHcodigo, b.RHHdescripcion, coalesce(a.RHNnotamin,0)*100 as nota, a.RHHpeso as peso
	from RHHabilidadesPuesto a
	
	inner join RHHabilidades b
	on a.Ecodigo=b.Ecodigo
	and a.RHHid=b.RHHid
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by b.RHHcodigo
</cfquery>

<cfquery name="conocimientos_requeridos" datasource="#session.DSN#">
	select a.RHCid, b.RHCcodigo, b.RHCdescripcion, coalesce(a.RHCnotamin,0)*100 as nota, a.RHCpeso as peso
	from RHConocimientosPuesto a
	
	inner join RHConocimientos b
	on a.Ecodigo=b.Ecodigo
	and a.RHCid=b.RHCid
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
   	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by b.RHCcodigo
</cfquery>
<cfset total_competencias = 0 >
<cfif habilidades_requeridas.recordcount gt 0>
	<cfoutput query="habilidades_requeridas">
		<cfset total_competencias = total_competencias + habilidades_requeridas.peso>
	</cfoutput>
</cfif>
<cfif conocimientos_requeridos.recordcount gt 0>
	<cfoutput query="conocimientos_requeridos">
		<cfset total_competencias = total_competencias + conocimientos_requeridos.peso>
	</cfoutput>
</cfif>

<cfquery name="rsLista" datasource="#session.DSN#">							
	select coalesce(p.RHPcodigoext,p.RHPcodigo) as RHPcodigoext,a.RHPcodigo,a.DEid,
	DEidentificacion as identificacion,
	<cf_dbfunction name="concat" args="b.DEnombre,' ',b.DEapellido1,' ',b.DEapellido2"> as NombreEmp,
	<cf_dbfunction name="concat" args="b.DEnombre,' ',b.DEapellido1"> as NombreEmp2,
	<!---{fn concat(b.DEnombre,{fn concat(b.DEapellido1,b.DEapellido2)})} as NombreEmp,
	{fn concat(b.DEnombre,b.DEapellido1)} as NombreEmp2,--->
	<cfif  isdefined("Seleccion") >1<cfelse>0</cfif>  as ext,
	 0 as calificacion, p.RHPdescpuesto as PuestoEmp,
	4 as paso
	from RHEmpleadosPlan a , DatosEmpleado b, LineaTiempo lt, RHPuestos p
	where  a.DEid  = b.DEid 
	and    a.RHPcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
	and    a.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and lt.DEid = b.DEid
	and lt.Ecodigo = b.Ecodigo
	and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.LTdesde and lt.LThasta
	and lt.Ecodigo = p.Ecodigo
	and lt.RHPcodigo = p.RHPcodigo
</cfquery>

<!---<cf_dump var="#rsLista#">--->

<!--- ////////  CALCULAR LAS CALIFICACIONES PARA CADA CANDIDATO, BUSCANDO LA ULTIMA EVALUACION PARA CADA HABILIDAD /////// --->
<!---
<cfloop query="rsLista">


	<cfinvoke component="home.Componentes.Seguridad" method="getUsuarioByRef" returnvariable="usu" referencia="#deid#" Ecodigo="#session.EcodigoSDC#" tabla="DatosEmpleado"></cfinvoke>
	<cfif not usu.RecordCount>
		<cfthrow message="Usuario no existe: #DeId#">
	</cfif>
	<cfinvoke component="home.Componentes.Seguridad" method="getUsuarioByCod" returnvariable="alu" Usucodigo="#usu.Usucodigo#" Ecodigo="#session.EcodigoSDC#" tabla="PersonaEducativo"></cfinvoke>
	<cfif not alu.RecordCount>
		<cfthrow message="Alumno no existe: #DeId#-#usu.Usucodigo#">
	</cfif>
		
	<cfquery name="hab" datasource="#session.DSN#">							
		select rhh.RHHdescripcion as descripcion, notas.RHCEdominio, hp.RHHpeso as peso, (hp.RHHpeso * notas.RHCEdominio) as resultado,
				m.Mnombre,
					(
						select count(1)
						from CursoAlumno ca join Curso cu on ca.Ccodigo = cu.Ccodigo
						where cu.Mcodigo = m.Mcodigo
						  and ca.Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#alu.llave#">
					) as llevado
			from RHHabilidadesPuesto hp
				left join RHCompetenciasEmpleado notas
				   on notas.idcompetencia = hp.RHHid
				   and notas.tipo  = 'H'
				   and notas.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#DEid#">
				   and notas.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				join RHHabilidades rhh
					on rhh.RHHid = hp.RHHid
				left join RHHabilidadesMaterias cm
					on cm.RHHid = rhh.RHHid
					and cm.Ecodigo = rhh.Ecodigo
				left join Materia m
					on cm.Mcodigo = m.Mcodigo
			where hp.RHPcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
			  and hp.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by descripcion, Mnombre, notas.RHCEfdesde desc
	</cfquery>

	<cfquery name="con" datasource="#session.DSN#">							
		select rhh.RHCdescripcion as descripcion, notas.RHCEdominio, hp.RHCpeso as peso, (hp.RHCpeso * notas.RHCEdominio) as resultado,
			m.Mnombre,
			(
				select count(1)
				from CursoAlumno ca join Curso cu on ca.Ccodigo = cu.Ccodigo
				where cu.Mcodigo = m.Mcodigo
				  and ca.Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#alu.llave#">
			) as llevado
		from RHConocimientosPuesto hp
			left join RHCompetenciasEmpleado notas
				on notas.idcompetencia =hp.RHCid
				and notas.tipo  = 'C'
				and notas.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#DEid#">
				and notas.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			join RHConocimientos rhh
				on rhh.RHCid = hp.RHCid
			left join RHConocimientosMaterias cm
				on cm.RHCid = rhh.RHCid
				and cm.Ecodigo = rhh.Ecodigo
			left join Materia m
				on cm.Mcodigo = m.Mcodigo
		where hp.RHPcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
		and hp.Ecodigo    =   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		order by descripcion, Mnombre, notas.RHCEfdesde desc
	</cfquery>
	
	<cfset NotaTotal_resultado = 0>
	<cfset NotaTotal_peso = 0>
	<cfoutput query="hab" group="descripcion"><!--- porque la primera que sale es la mas reciente --->
		<cfif Len(resultado)><cfset NotaTotal_resultado = NotaTotal_resultado + resultado></cfif>
		<cfif Len(peso)><cfset NotaTotal_peso = NotaTotal_peso + peso></cfif>
	</cfoutput>
	<cfoutput query="con" group="descripcion"><!--- porque la primera que sale es la mas reciente --->
		<cfif Len(resultado)><cfset NotaTotal_resultado = NotaTotal_resultado + resultado></cfif>
		<cfif Len(peso)><cfset NotaTotal_peso = NotaTotal_peso + peso></cfif>
	</cfoutput>
	<cfif NotaTotal_peso>
	<cfset rsLista.calificacion = NumberFormat(NotaTotal_resultado / NotaTotal_peso,',0.00')>
	<cfelse>
	<cfset rsLista.calificacion = '0.00'>
	</cfif>
</cfloop>
--->

<cfloop query="rsLista">

	<cfinvoke component="home.Componentes.Seguridad" method="getUsuarioByRef" returnvariable="usu" referencia="#deid#" Ecodigo="#session.EcodigoSDC#" tabla="DatosEmpleado"></cfinvoke>
	<cfif not usu.RecordCount>
		<cfthrow message="Usuario no existe: #DeId#">
	</cfif>
	<cfinvoke component="home.Componentes.Seguridad" method="getUsuarioByCod" returnvariable="alu" Usucodigo="#usu.Usucodigo#" Ecodigo="#session.EcodigoSDC#" tabla="PersonaEducativo"></cfinvoke>
	<cfif not alu.RecordCount>
		<cfthrow message="Alumno no existe: #DeId#-#usu.Usucodigo#">
	</cfif>
		
	<cfset NotaTotal_resultado = 0>
	<cfset NotaTotal_peso = 0>
	<cfquery name="habilidades_obtenidas_pct" datasource="#Session.DSN#">
		select coalesce(sum(b.RHCEdominio * a.RHHpeso / 100.0), 0.0) as nota
		from RHHabilidadesPuesto a
			inner join RHCompetenciasEmpleado b
				on b.idcompetencia = a.RHHid
				and b.Ecodigo = a.Ecodigo
				and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				and b.tipo = 'H'
				and b.RHCEfdesde >= (
									 select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
									 where c.DEid = b.DEid
									   and c.Ecodigo = b.Ecodigo 
									   and c.tipo = b.tipo
									   and c.idcompetencia = b.idcompetencia
									 )
	
		where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	
	<cfquery name="conocimientos_obtenidos_pct" datasource="#Session.DSN#">
		select coalesce(sum(b.RHCEdominio * a.RHCpeso / 100.0), 0.0) as nota
		from RHConocimientosPuesto a
			inner join RHCompetenciasEmpleado b
				on b.idcompetencia = a.RHCid
				and b.Ecodigo = a.Ecodigo
				and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				and b.tipo = 'C'
				and b.RHCEfdesde >= (
									 select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
									 where c.DEid = b.DEid
									   and c.Ecodigo = b.Ecodigo 
									   and c.tipo = b.tipo
									   and c.idcompetencia = b.idcompetencia
									 )
	
		where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfset total_competencias_obtenidas = habilidades_obtenidas_pct.nota + conocimientos_obtenidos_pct.nota>

	<cfset NotaTotal_resultado = total_competencias_obtenidas>
	<cfset NotaTotal_peso = total_competencias>
	
	<cfif NotaTotal_peso>
		<cfset rsLista.calificacion = NumberFormat((100.0 * NotaTotal_resultado) / NotaTotal_peso, '9.00')>
	<cfelse>
		<cfset rsLista.calificacion = '0.00'>
	</cfif>
</cfloop>

<!--- ////////// YA ESTA CALCULADO ////////// --->

<cfset varformat = 'flash'>
<!---*******************************--->
<!--- Información del Concurso      --->
<!---*******************************--->
<cf_sifHTML2Word>
 <cfif  isdefined("Seleccion")>
	<table  width="100%"  align="center"border="0">
		<tr>
			<td  align="center" colspan="5"><font size="2"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></font></td>
		</tr>
		<tr>
			<td  align="center" colspan="5"><font size="2"><strong><cf_translate key="LB_PlanDeSucesion">Plan de Sucesi&oacute;n</cf_translate></strong></font></td>
		</tr>
		<tr>
			<td  align="center" colspan="5"><font size="2"><strong><cfoutput>#rsPuesto.RHPdescpuesto#</cfoutput></strong></font></td>
		</tr>
		
			<tr>
				<td width="20%" align="left"><cf_translate key="LB_CodigoPuesto">C&oacute;d. Puesto</cf_translate>:</td>
				<td width="80%"><strong><cfoutput>#rsPuesto.RHPcodigoext#</cfoutput></strong></td>
			</tr>
			<tr>
				<td align="left"><cf_translate key="LB_PorcentajeRequerido">Porcentaje Requerido</cf_translate>:</td>
				<td><strong><cfoutput>#rsPuesto.PSporcreq#</cfoutput>&nbsp;%</strong></td>
			</tr>	
	</table>
<cfelse>
	<table  width="75%"  align="center"border="0">
		<tr>
			<td width="28%" align="left" ><cf_translate key="LB_CodigoPuesto">C&oacute;d. Puesto</cf_translate>:</td>
			<td width="72%"><strong><cfoutput>#rsPuesto.RHPcodigoext#</cfoutput></strong></td>
		</tr>
		<tr>
			<td align="left"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:</td>
			<td><strong><cfoutput>#rsPuesto.RHPdescpuesto#</cfoutput></strong></td>
		</tr>
		<tr>
			<td align="left"><cf_translate key="LB_PorcentajeRequerido">Porcentaje Requerido</cf_translate>:</td>
			<td><strong><cfoutput>#rsPuesto.PSporcreq#</cfoutput>&nbsp;%</strong></td>
		</tr>		
		
	</table>
</cfif>
<!---*******************************--->
<!--- aréa de pintado               --->
<!---*******************************--->
	
<!---*******************************--->
<!--- Información del botones       --->
<!---*******************************--->

<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
			
				<form action="<cfoutput>#CurrentPage#</cfoutput>" method="post" name="form1" >
					<input type="hidden" name="paso" value="<cfoutput>#Gpaso#</cfoutput>">
					<input type="hidden" name="RHPcodigo"  	
					value="<cfif isdefined("rsPuesto.RHPcodigo")and (rsPuesto.RHPcodigo GT 0)><cfoutput>#rsPuesto.RHPcodigo#</cfoutput></cfif>">

					<cfif not isdefined("Seleccion")>
					<input type="hidden" name="botonSel" value="">
					<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Anterior"
						Default="Anterior"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Anterior"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>

					<input type="submit" name="Anterior"
					value="<<&nbsp;<cfoutput>#BTN_Anterior#</cfoutput>" 
					onClick="javascript: this.form.botonSel.value = this.name; if (window.funcAnterior) return funcAnterior();" tabindex="1">
					<input type="reset" name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>" 
					onClick="javascript: this.form.botonSel.value = this.name; if (window.funcLimpiar) return funcLimpiar();" tabindex="1">
					</cfif>
				</form>
			
			</td>
		</tr>
	</table>
<!---*******************************--->
<!--- Lista de Concursante          --->
<!---*******************************--->
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td colspan="2" align="center">&nbsp;</td></tr>
			<td colspan="2"  align="center"   bgcolor="#CCCCCC" valign="top">
				
				<cf_translate key="LB_ListaDeCandidatosAlPuesto"><strong>Lista de Candidatos al puesto</strong></cf_translate><br>
				<cf_translate key="LB_SeleccioneUnCandidatoParaRevisarSuPerfil">Seleccione un candidato para revisar su perfil</cf_translate>
				
			</td>
		<tr>
			<td colspan="2">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Identificacion"
					Default="Identificaci&oacute;n"
					returnvariable="MSG_Identificacion"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Nombre"
					Default="Nombre"
					returnvariable="MSG_Nombre"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_PuestoActual"
					Default="Puesto Actual"
					returnvariable="MSG_PuestoActual"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Progreso"
					Default="Progreso"
					returnvariable="MSG_Progreso"/>

    			<cfinvoke
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"> 
					<cfinvokeargument name="query" value="#rsLista#"/> 
					<cfinvokeargument name="desplegar" value="identificacion,NombreEmp,PuestoEmp,calificacion"/> 
					<cfinvokeargument name="etiquetas" value="#MSG_Identificacion#,#MSG_Nombre#,#MSG_PuestoActual#,#MSG_Progreso#&nbsp;(%)"/> 
					<cfinvokeargument name="formatos" value="S,S,S,S"/> 
					<cfinvokeargument name="align" value="left,left,left,center"/> 
					<cfinvokeargument name="ajustar" value="N"/> 
					<cfinvokeargument name="checkboxes" value="N"/> 
					<cfif isdefined("Seleccion")>
						<cfinvokeargument name="irA" value="/cfmx/rh/sucesion/operacion/PlanSucesion-paso4IMP.cfm"/>
						<cfinvokeargument name="keys" value="RHPcodigo,DEid,paso,ext"/>
					<cfelse>	
						<cfinvokeargument name="irA" value="#CurrentPage#"/> 
						<cfinvokeargument name="keys" value="RHPcodigo,DEid,paso"/>
					</cfif>	
					<cfinvokeargument name="showEmptyListMsg" value="true"/>						
					<cfinvokeargument name="maxrows" value="10"/>
				</cfinvoke>
			</td>
		</tr>
		</cf_sifHTML2Word>
		<tr><td colspan="2"><hr></td></tr>
		<tr>
			<td colspan="2" align="center" valign="middle">

				<cfchart gridlines="0"
						 xaxistitle="" 
						 yaxistitle="Porcentaje" 
						 scalefrom="0"
						 scaleto="100"
						 show3d="yes"  
						 rotated="no"
						 showborder="no"  
						 showlegend="yes" 
						 chartwidth="400"
						 format="#varformat#">	
				<cfloop query="rsLista">
					<cfchartseries type="bar" serieslabel="#rsLista.NombreEmp#">
						<cfchartdata item=" " value="#rsLista.calificacion#">
					</cfchartseries>
				</cfloop>
				</cfchart>						 
				<!--- <cfchartdata> 		 --->			
				<!--- Query para graficos --->
				<cfset rsTotales = QueryNew("empresa,total")>						
				<!--- Inicializaci[on de los contadores para la linea de totales --->
				<cfset varTotEmplAct = 0>
				<cfset varTotTipNom = 0>
				<cfset varTotNomPag = 0>
				<cfset varTotPagado = 0>						
			</td>
		</tr>
	</table>
    
<!---*******************************--->
<!--- Lista de script               --->
<!---*******************************--->
<cf_qforms>

