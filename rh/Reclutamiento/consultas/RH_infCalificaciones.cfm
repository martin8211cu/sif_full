
<!--- 
	Modificado por Gustavo Fonseca H.
	Fecha: 14-6-2005.
	Motivo: se filtra para que solo se muestren los registros con el peso del concurso mayor a cero.
	Pesos de: Pruebas,  Competencias y Áreas.
 --->

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Competencias"
	Default="Competencias"
	returnvariable="LB_Competencias"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilidades"
	Default="Habilidades"
	returnvariable="LB_Habilidades"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Interno"
	Default="Interno"
	returnvariable="LB_Interno"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Externo"
	Default="Externo"
	returnvariable="LB_Externo"/>

<!---*******************************  Captura de parametros   *******************************--->
<!--- <cfdump var="#form#"> <cfdump var="#url#"> --->
<cfif isdefined("form.RHCPid") and  not isdefined("url.RHCPid")>
	<cfset form.RHCPid = form.RHCPid>
</cfif>
<cfif not isdefined("form.RHCPid") and  isdefined("url.RHCPid")>
	<cfset form.RHCPid = url.RHCPid>
</cfif>
<cfif isdefined("form.RHCconcurso") and  not isdefined("url.RHCconcurso")>
	<cfset form.RHCconcurso = form.RHCconcurso>
</cfif>
<cfif not isdefined("form.RHCconcurso") and  isdefined("url.RHCconcurso")>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>

<cfset vparams ="">
<cfset vparams = vparams & "&RHCconcurso=" & form.RHCconcurso>
<cfset vparams = vparams & "&RHCPid=" & form.RHCPid>

<!---*******************************  Declaración de variables *******************************--->
<cfset sumConcurso = 0>
<cfset sumObtenido = 0>
<cfset NOTA = 0>
<cfset request.Lovarimprime =0>
<!---******************  Encabezado 				******************--->
<cf_translatedata tabla="Empresas" col="Edescripcion" name="get" returnvariable="LvarEdescripcion"/>
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select #LvarEdescripcion# as Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- <cfquery name="rsConsultaDE" datasource="#session.DSN#">
	select 1
	from RHConcursantes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Concursante#">
</cfquery>
<cfquery name="rsConsultaOE" datasource="#session.DSN#">
	select 1
	from RHConcursantes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and RHOid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Concursante#"> 
</cfquery>--->

<cfquery name="rsTipoOferente" datasource="#session.DSN#">
	select RHCPtipo, DEid, RHOid
	from RHConcursantes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
	and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
</cfquery>


<!---******************  Encabezado 				******************--->
<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
<cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
<cfquery name="RSEncabezado" datasource="#Session.DSN#">
	select a.RHCcodigo,#LvarRHCdescripcion# as RHCdescripcion,a.RHPcodigo,coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,#LvarRHPdescpuesto# as RHPdescpuesto,RHCPid, 
		<cfif isdefined("rsTipoOferente") and rsTipoOferente.RecordCount GT 0 and rsTipoOferente.RHCPtipo EQ 'I'>
		c.DEid, 
		{fn concat(d.DEnombre,{fn concat(' ',{fn concat(d.DEapellido1,{fn concat(' ',d.DEapellido2)})})})} as nombre,
		DEidentificacion as identificacion,
		DEdireccion as direccion,
		 DEemail as email,
		 DEtelefono1 as tel1,
		 DEtelefono2 as tel2
		<cfelseif isdefined("rsTipoOferente") and rsTipoOferente.RecordCount GT 0 and rsTipoOferente.RHCPtipo EQ 'E'>
		c.RHOid, 
		{fn concat(d.RHOnombre,{fn concat(' ',{fn concat(d.RHOapellido1,{fn concat(' ',d.RHOapellido2)})})})} as nombre,
		 RHOidentificacion as identificacion,
		 RHOdireccion as direccion,
		 RHOemail as email,
		 RHOtelefono1 as tel1,
		 RHOtelefono2 as tel2
		 </cfif> 
		,RHCPtipo
		from RHConcursos a inner join RHPuestos b
	  on a.RHPcodigo   = b.RHPcodigo and
		 a.Ecodigo     = b.Ecodigo inner join RHConcursantes c
	  on a.RHCconcurso = c.RHCconcurso inner join 
	  <cfif isdefined("rsTipoOferente") and rsTipoOferente.RecordCount GT 0 and rsTipoOferente.RHCPtipo EQ 'I'>
	  	DatosEmpleado d
	  on c.DEid        = d.DEid
	  <cfelseif isdefined("rsTipoOferente") and rsTipoOferente.RecordCount GT 0 and rsTipoOferente.RHCPtipo EQ 'E'>
	  	DatosOferentes d 
	  on c.RHOid       = d.RHOid
	  </cfif>
	where a.RHCconcurso  = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCconcurso#">
	  <cfif isdefined("rsTipoOferente") and rsTipoOferente.RecordCount GT 0 and rsTipoOferente.RHCPtipo EQ 'I'>
	  and c.DEid         = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoOferente.DEid#">
	  <cfelseif isdefined("rsTipoOferente") and rsTipoOferente.RecordCount GT 0 and rsTipoOferente.RHCPtipo EQ 'E'>
	  and c.RHOid        = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoOferente.RHOid#">
	  </cfif>
</cfquery>

<!---******************  Pruebas 					******************--->
<cf_translatedata name="get" tabla="RHPruebas" col="RHPdescripcionpr" returnvariable="LvarRHPdescripcionpr">
<cf_translatedata name="get" tabla="RHCompetencias" col="e.descripcion" returnvariable="Lvardescripcion">

<cfquery name="RSPruebas" datasource="#Session.DSN#">
	select f.RHPcodigopr, #LvarRHPdescripcionpr# as RHPdescripcionpr, e.codigo, 
			#Lvardescripcion# as descripcion, e.Tipo, b.RHCPCNota, a.Peso, round((b.RHCPCNota*a.Peso)/100.00,2) as PesoObt
	from  RHPruebasConcurso a
	inner join RHCalificaPrueConcursante b
	  on  a.RHPcodigopr = b.RHPcodigopr
	
	inner join RHPruebasCompetencia c
	  on  a.Ecodigo 	= c.Ecodigo and 
		  a.RHPcodigopr = c.RHPcodigopr
	
	inner join RHCompetenciasConcurso d
	  on a.RHCconcurso = d.RHCconcurso and 
	     c.id 		   = d.Idcompetencia and 
		 c.RHPCtipo    = d.tipocompetencia 

	inner join RHCompetencias e
	  on  a.Ecodigo  = e.Ecodigo  and
	      c.id 		 = e.id and
	      c.RHPCtipo = e.Tipo

	inner join RHPruebas f
	  on a.Ecodigo = f.Ecodigo and 
		 a.RHPcodigopr = f.RHPcodigopr
	where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCconcurso#">
	and a.Peso >0
	and b.RHCPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCPid#">
	order by  f.RHPcodigopr
</cfquery>
<!---******************  Calificación conocimientos ******************
<cf_dump var="#rsEncabezado#">--->

<cf_translatedata name="get" tabla="RHConocimientos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
<cf_translatedata name="get" tabla="RHHabilidades" col="RHHdescripcion" returnvariable="LvarRHHdescripcion">

<cfquery name="RSCompetencias" datasource="#Session.DSN#">
select  'C' as tipo, '#LB_Competencias#' as Encabezado, RHCcodigo as codigo, #LvarRHCdescripcion# as descripcion, 
			e.RHPcodigopr,  d.RHnotamin*100.00 as notamin, c.RHCCONota as notaobt, d.RHCPpeso as pesoconcurso, 
			((c.RHCCONota *d.RHCPpeso)/100) as pesoobt
	from RHConocimientosPuesto a 
	
	 inner join RHConocimientos b
	  on a.Ecodigo = b.Ecodigo  and
		  a.RHCid  = b.RHCid

	 left outer join RHCalificaCompPrueOfer c
	   on a.Ecodigo 		= c.Ecodigo  and
		  b.RHCid 		= c.Idcompetencia and
		  c.tipocompetencia = 'C'
		  
	 inner join  RHCompetenciasConcurso d
	   on a.Ecodigo 	= d.Ecodigo and 
		  a.RHCid 		= d.Idcompetencia and 
		  c.RHCconcurso = d.RHCconcurso
		  
	inner join RHPruebasCompetencia e
	   on e.RHPCtipo = d.tipocompetencia  and
		  e.id 		 = d.Idcompetencia 
		  
	where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#RSEncabezado.RHPcodigo#">
	  and d.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
	  and c.RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
	  and d.RHCPpeso > 0
	union

	select  'H' as tipo,'#LB_Habilidades#' as Encabezado,RHHcodigo as codigo, #LvarRHHdescripcion# as descripcion,  
			e.RHPcodigopr,d.RHnotamin*100.00 as notamin, c.RHCCONota as notaobt, d.RHCPpeso as pesoconcurso, 
			((c.RHCCONota *d.RHCPpeso)/100) as pesoobt
	from RHHabilidadesPuesto a inner join RHHabilidades b
	  on a.Ecodigo = b.Ecodigo and 
		 a.RHHid   = b.RHHid
	left outer join RHCalificaCompPrueOfer c
	  on b.RHHid 		   = c.Idcompetencia and 
	     c.tipocompetencia = 'H'
	
	inner join RHCompetenciasConcurso d
	   on a.Ecodigo 	 	= d.Ecodigo and 
		  a.RHHid   	 	= d.Idcompetencia and 
		  c.RHCconcurso  	= d.RHCconcurso and 
		  d.tipocompetencia = 'H' 
	
	inner join RHPruebasCompetencia e
	   on e.RHPCtipo = d.tipocompetencia and 
		  e.id 		 = d.Idcompetencia
		  
	where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#RSEncabezado.RHPcodigo#">
	  and d.RHCPpeso > 0
	  and d.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
	  and c.RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
	order by tipo, codigo
</cfquery>
<!---******************  Áreas de evaluación 		******************--->
<cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="a.RHEAdescripcion" returnvariable="LvarRHEAdescripcion">
<cf_translatedata name="get" tabla="RHDAreasEvaluacion" col="b.RHDAdescripcion" returnvariable="LvarRHDAdescripcion">

<cfquery name="RSAreas" datasource="#Session.DSN#">
	select c.RHCPid,a.RHEAid, #LvarRHEAdescripcion# as RHEAdescripcion, a.RHEApeso, 
		b.RHDAlinea, #LvarRHDAdescripcion# as RHDAdescripcion, b.RHDAnotamin, c.RHCAONota
	from RHAreasEvalConcurso z 
	
	inner join RHEAreasEvaluacion a
	  on z.Ecodigo = a.Ecodigo and
		 z.RHEAid  = a.RHEAid 
	
	inner join RHDAreasEvaluacion b
	  on z.Ecodigo = b.Ecodigo and 
		 a.RHEAid  = b.RHEAid 
	
	inner join RHCalificaAreaConcursante c
	  on z.Ecodigo = c.Ecodigo and 
		 c.RHCconcurso = z.RHCconcurso and 
		 b.RHDAlinea = c.RHDAlinea
	
	where z.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCconcurso#">
	  and c.RHCPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RSEncabezado.RHCPid#">
	  and a.RHEApeso >0
</cfquery>
<!---******************  Áreas de pintado 		    ******************--->
<!---******************  Encabezado 				******************--->
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">

	<cfoutput>
		<cfif not isdefined("url.imprimir")>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cf_rhimprime datos="/rh/Reclutamiento/Reportes/RH_infCalificaciones.cfm" paramsuri="#vparams#">
											
					</td>	
				</tr>
			</table>	
		</cfif>
	</cfoutput>

<cfoutput>
<table  width="100%"  align="center"border="0">
	<tr>
		<td  align="center" colspan="3"><font size="2"><strong>#rsEmpresa.Edescripcion#</strong></font></td>
	</tr>
	<tr>
		<td  align="center" colspan="3"><font size="2"><strong><cf_translate key="LB_ReporteDeClaificacionesPorConcursante">Reporte de Calificaciones por Concursante</cf_translate></strong></font></td>
	</tr>
	<tr>
		<td colspan="3" align="right"><cf_translate key="LB_Fecha">Fecha</cf_translate>: #LSDateFormat(Now(),"dd/mm/yyyy")#</td>
	</tr>
	<tr>
		<td width="5%"></td>
		<td width="21%" align="left" ><cf_translate key="LB_NConcurso">C&oacute;d. Concurso</cf_translate>:</td>
		<td width="74%"><strong>#RSEncabezado.RHCcodigo#</strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:</td>
		<td><strong>#RSEncabezado.RHCDESCRIPCION#</strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_Puesto">Puesto</cf_translate>:</td>
		<td><strong>#RSEncabezado.RHPCODIGOext# - #RSEncabezado.RHPDESCPUESTO#</strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_Nombre" XmlFile="/rh/generales.xml">Nombre</cf_translate>:</td>
		<td><strong>#RSEncabezado.nombre#</strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_Direccion" XmlFile="/rh/generales.xml">Direcci&oacute;n</cf_translate>:</td>
		<td><strong>#RSEncabezado.direccion#</strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_Email" XmlFile="/rh/generales.xml">E-mail</cf_translate>:</td>
		<td><strong>#RSEncabezado.email#</strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_Tel1" XmlFile="/rh/generales.xml">Tel&eacute;fono 1</cf_translate>:</td>
		<td><strong>#RSEncabezado.tel1#</strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_Tel2" XmlFile="/rh/generales.xml">Tel&eacute;fono 2</cf_translate>:</td>
		<td><strong>#RSEncabezado.tel2#</strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_Identificacion" XmlFile="/rh/generales.xml">Identificaci&oacute;n</cf_translate>:</td>
		<td><strong>#RSEncabezado.identificacion#</strong></td>
	</tr>
	<tr>
		<td></td>
		<td align="left"><cf_translate key="LB_TipoDeConcursante">Tipo de Concursante</cf_translate> :</td>
			<cfswitch expression="#RSEncabezado.RHCPtipo#">
				<cfcase value = "I">
					<td><strong>#LB_Interno#</strong></td>
				</cfcase>
				<cfcase value = "E">
					<td><strong>#LB_Externo#</strong></td>
				</cfcase>
			</cfswitch>
	</tr>
</table>
<!---******************  Pruebas 					******************--->
<table  width="100%"  align="center"border="0">
	<tr>
		<td width="55%"><strong><cf_translate key="LB_Pruebas">Pruebas</cf_translate></strong></td>
		<td align="right" width="15%"><strong><cf_translate key="LB_Nota">Nota % </cf_translate></strong></td>
		<td align="right" width="15%"><strong><cf_translate key="LB_PesoConcurso">Peso Concurso </cf_translate></strong></td>
		<td align="right" width="15%"><strong><cf_translate key="LB_PesoObtenido">Peso Obtenido </cf_translate></strong></td>
	</tr>
	<tr>
	<td  colspan="4" style="border-style:solid">
		<table  width="100%"  align="center"border="0">
			<cfif RSPRuebas.recordcount gt 0>
			   <cfset CORTE = "">
				<cfloop query="RSPRuebas">
					<cfif trim(RSPRuebas.RHPcodigopr) neq trim(CORTE)>
						<cfset CORTE = #trim(RSPRuebas.RHPcodigopr)#>
						<tr>  
							<td width="55%"><em><strong>#RSPRuebas.RHPcodigopr#-#RSPRuebas.RHPdescripcionpr#</strong></em></td>
							<td  align="right" width="15%">#LSNumberFormat(RSPRuebas.RHCPCNota,'____.__')#</td>
							<td  align="right" width="15%">#LSNumberFormat(RSPRuebas.Peso,'____.__')#</td>
							<td  align="right" width="15%">#LSNumberFormat(RSPRuebas.PesoObt,'____.__')#</td>
						</tr>
					</cfif>
					<tr>
						<td  colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;#RSPRuebas.descripcion#</td>
					</tr>
				</cfloop>
			<cfelse>	
				<tr>
					<td  colspan="4" align="center" ><strong><cf_translate key="LB_NoHayPruebasParaEsteConsurso">No hay pruebas para este concurso</cf_translate></strong></td>
				</tr>
			</cfif>
		</table>
	</td>
	</tr>
</table>

<!---******************  Calificación de competencias		******************--->

<table  width="100%"  align="center"border="0">
	<tr>
		<td width="25%"><strong><cf_translate key="LB_CalificacionDeCompetencias">Calificaci&oacute;n de Competencias</cf_translate></strong></td>
		<td align="right" width="15%"><strong><cf_translate key="LB_PruebasAplicadas">Pruebas Aplicadas</cf_translate></strong></td>
		<td align="right" width="15%"><strong><cf_translate key="LB_Nota">Nota %</cf_translate></strong></td>
		<td align="right" width="15%"><strong><cf_translate key="LB_NotaMinima">Nota M&iacute;nima</cf_translate></strong></td>
		<td align="right" width="15%"><strong><cf_translate key="LB_PesoConcurso">Peso Concurso </cf_translate></strong></td>
		<td align="right" width="15%"><strong><cf_translate key="LB_PesoObtenido">Peso Obtenido </cf_translate></strong></td>
	</tr>
	<tr>
	<td  colspan="6" style="border-style:solid">	  
	<table  width="100%"  align="center" border="0">
      <cfif RSCompetencias.recordcount gt 0>
        <cfset CORTE = "">
        <cfset CORTE2 = "">
        <cfloop query="RSCompetencias">
          <cfif trim(RSCompetencias.tipo) neq trim(CORTE)>
            <cfset CORTE = #trim(RSCompetencias.tipo)#>
            <tr>
              <td  colspan="6"><em><strong>#RSCompetencias.Encabezado#</strong></em></td>
            </tr>
          </cfif>
          <tr>
            <cfif trim(RSCompetencias.codigo) neq trim(CORTE2)>
              <cfset CORTE2 = #trim(RSCompetencias.codigo)#>
              <cfquery name="RSPruebasCompetencias"  dbtype="query">
          select distinct RHPcodigopr from RSCompetencias where codigo =
          <cfqueryparam cfsqltype="cf_sql_char" value="#RSCompetencias.codigo#">
          and tipo =
          <cfqueryparam cfsqltype="cf_sql_char" value="#RSCompetencias.tipo#">
              </cfquery>
              <cfset  PruebasCompetencias = "">
              <cfloop query="RSPruebasCompetencias">
                <cfset  PruebasCompetencias = PruebasCompetencias & RSPruebasCompetencias.RHPcodigopr & ' '>
              </cfloop>
              <td  width="25%">&nbsp;&nbsp;&nbsp;&nbsp;#RSCompetencias.descripcion#</td>
              <td  align="right" width="15%">#PruebasCompetencias#</td>
              <cfif RSCompetencias.notaobt lt RSCompetencias.notamin>
				  <td  align="right" style="color:FF0000 " width="15%">#LSNumberFormat(RSCompetencias.notaobt,'____.__')#</td>
				  <td  align="right" style="color:FF0000 " width="15%">#LSNumberFormat(RSCompetencias.notamin,'____.__')#</td>
			  <cfelse>  
				  <td  align="right" width="15%">#LSNumberFormat(RSCompetencias.notaobt,'____.__')#</td>
				  <td  align="right" width="15%">#LSNumberFormat(RSCompetencias.notamin,'____.__')#</td>				  
			  </cfif>  
              <td  align="right" width="15%">#LSNumberFormat(RSCompetencias.pesoconcurso,'____.__')#</td>
              <td  align="right" width="15%">#LSNumberFormat(RSCompetencias.pesoobt,'____.__')#</td>
			  <cfset sumObtenido = sumObtenido + RSCompetencias.pesoobt> 
			  <cfset sumConcurso = sumConcurso + RSCompetencias.pesoconcurso> <!--- OK!!! --->

            </cfif>
          </tr>
        </cfloop>
		<!--- <h1><cfdump var="#sumConcurso#"></h1> --->
        <cfelse>
        <tr>
          <td  colspan="6" align="center" ><strong><cf_translate key="LB_NoHayCompentenciasParaEsteConcurso">No hay competencias para este concurso</cf_translate></strong></td>
        </tr>
      </cfif>
    </table></td>
	</tr>
</table>
<!---******************  Áreas de evaluación 		******************--->
<table  width="100%"  align="center" border="0">
	<tr>
		<td width="40%"><strong><cf_translate key="LB_AreasDeEvaluacion">Áreas de evaluación</cf_translate></strong></td>
		<td align="right" width="13%"><strong><cf_translate key="LB_Nota">Nota %</cf_translate></strong></td>
		<td align="right" width="13%"><strong><cf_translate key="LB_NotaMinima">Nota M&iacute;nima</cf_translate></strong></td>
		<td align="right" width="13%"><strong><cf_translate key="LB_PesoConcurso">Peso Concurso </cf_translate></strong></td>
		<td align="right" width="13%"><strong><cf_translate key="LB_PesoObtenido">Peso Obtenido </cf_translate></strong></td>
	</tr>
	<tr>
	<td  colspan="6" style="border-style:solid">
		<table  width="100%"  align="center" border="0">
			<cfset CORTE = "">
			<cfif RSAreas.recordcount gt 0>
			<cfset contador = 0>
			<cfset areasm =0>
				<cfloop query="RSAreas">
					<cfif RSAreas.RHEAid neq CORTE>
						 <cfquery name="RSAreasTotal"  dbtype="query">
							select (sum(RHCAONota)/ count(RHCAONota)) as Pesototal,count(RHCAONota)
							from RSAreas
							where RHEAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RSAreas.RHEAid#">
						</cfquery>
						<cfset Peso_Obtenido = (RSAreasTotal.Pesototal * RSAreas.RHEApeso)/100>
						<cfset sumObtenido = sumObtenido + Peso_Obtenido> 
						<cfset CORTE = RSAreas.RHEAid>
						<tr>  
							<td width="25%"><em><strong>#RSAreas.RHEAdescripcion#</strong></em></td>
							<td align="left" width="7%"></td>
							<td align="left" width="7%"></td>
							<td align="center" width="7%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LSNumberFormat(RSAreas.RHEApeso,'____.__')#</td>
							<cfset sumConcurso = sumConcurso + RSAreas.RHEApeso>
							<td align="right" width="7%">#LSNumberFormat(Peso_Obtenido,'____.__')#</td>
						</tr>
					</cfif>
						<tr>
							<td  width="25%">&nbsp;&nbsp;&nbsp;&nbsp;#RSAreas.RHDAdescripcion#</td>
							<cfif RSAreas.RHCAONota lt RSAreas.RHDAnotamin>
								<td align="center"  style="color:FF0000 " width="7%"><strong>#LSNumberFormat(RSAreas.RHCAONota,'____.__')#</strong></td>
								<td align="center"  style="color:FF0000 " width="7%"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LSNumberFormat(RSAreas.RHDAnotamin,'____.__')#</strong></td>
							<cfelse>
								<td align="center" width="7%">#LSNumberFormat(RSAreas.RHCAONota,'____.__')#</td>
								<td align="center" width="7%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LSNumberFormat(RSAreas.RHDAnotamin,'____.__')#</td>
							</cfif>
							<td align="center" width="7%"></td>
							<td align="center" width="7%"></td>
							
						</tr>
						<!--- <cfset sumConcurso = sumConcurso + RSAreas.RHEApeso> ---> <!--- También esta bien? --->
						<!--- <cfset contador = contador +1>
						<cfset areasm = areasm + RSAreas.RHEApeso> --->
						
				</cfloop>
				<!--- <h1><cfdump var="#sumConcurso#"></h1>
				<h1><cfdump var="#areasm#"></h1>
				<h1><cfdump var="#contador#"></h1> --->
				
			<cfelse>	
				<tr>
					<td  colspan="6" align="center" ><strong><cf_translate key="LB_NoHayAreasDeEvaluacionParaEsteConcurso">No hay Áreas de evaluación para este concurso</cf_translate></strong></td>
				</tr>
			</cfif>
		</table>
	</td>
	</tr>
</table>
<cfif sumConcurso eq 0>
	<cfset sumConcurso = 1>
</cfif>
 <cfset NOTA = (sumObtenido/sumConcurso)*100>
<table width="100%" border="0">
  <tr>
	<td width="46%">&nbsp;</td>
  	<td align="center" width="29%" ><strong><cf_translate key="LB_PesoFinal">Peso Final</cf_translate></strong></td>
    <td align="center" width="13%"><strong><cf_translate key="LB_Concurso">Concurso</cf_translate></strong></td>
    <td align="right" width="12%"><strong><cf_translate key="LB_Obtenido">Obtenido</cf_translate></strong></td>

  </tr>
    <tr style="border-style:solid">
    <td>&nbsp;<strong>*&nbsp;<cf_translate key="LasNotasEnRojoEstanPorDebajoDeLaNotaMinima">Las notas en rojo están por debajo de la nota m&iacute;nima.</cf_translate>	</strong> </td>
	<td>&nbsp;</td>
    <td align="center">#LSNumberFormat(sumConcurso,'____.__')#</td>
    <td align="right">#LSNumberFormat(sumObtenido,'____.__')#</td>
    
  </tr>
    <tr>
    <td>&nbsp;</td>
    <td align="center"><strong><cf_translate key="LB_NotaDelParticipante">Nota del Participante</cf_translate></strong></td>
    <td>&nbsp;</td>
    <td align="right" valign="bottom"><font size="+1"><strong>#LSNumberFormat(NOTA,'____.__')#</strong></font></td>
  </tr>
  <cfoutput>
		<cfif not isdefined("url.imprimir")>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="right">
						<cfif not isdefined("url.eval")>
							<cfset regresa ="/cfmx/rh/Reclutamiento/operacion/RegistroEvalInforme.cfm?RHCconcurso=" & #RHCconcurso#>
							<cf_botones exclude= "Alta,Limpiar" regresar="#regresa#">				
						</cfif>
					</td>
				</tr>
			</table>	
		</cfif>
	</cfoutput>
</table>

<table width="100%" align="center">
	<cfif isdefined("url.imprimir")>
	  <tr align="center"> 
		<td> --------------------------- <cf_translate key="LB_FinDelReporte">Fin del Reporte</cf_translate> --------------------------- </td>
	  </tr>
	</cfif>
</table>
</cfoutput>
<cfif NOTA GT 0 >
	<cfquery datasource="#session.DSN#">
		update RHConcursantes
		set RHCPpromedio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NOTA#" scale="2">,
			RHCevaluado = 1
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCPid#">
	</cfquery>
</cfif>

<script language="javascript1.2" type="text/javascript">
	<!--
	<cfoutput>
	function imprimir() { alert ('Hola!');
		<cfset request.Lovarimprime = 1> alert (#request.Lovarimprime#);
		var BTN_IMG = document.getElementById("BTN_IMG");
		 BTN_IMG.style.display = 'none';
		<cfif  isdefined("form.DEid") and not isdefined("url.DEid")>
			var BTN_REG = document.getElementById("BTN_REG");
			BTN_REG.style.display = 'none';
		</cfif>
		window.print()	
        BTN_IMG.style.display = ''
		<cfif  isdefined("form.DEid") and not isdefined("url.DEid")>
			BTN_REG.style.display = '';
		</cfif>
	}
	function atras() {
		history.back();
	}
	
	
</cfoutput>
//-->
</script>
