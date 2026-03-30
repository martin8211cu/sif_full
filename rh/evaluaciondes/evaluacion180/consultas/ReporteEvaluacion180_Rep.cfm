<cf_dump var="#form#">
<cfsilent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeEvaluacionDelDesempenoDeJefaturas"
	Default="Reporte de Evaluaci&oacute;n del Desempeño de Jefaturas"
	returnvariable="LB_ReporteDeEvaluacionDelDesempenoDeJefaturas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cedula"
	Default="C&eacute;dula"
	returnvariable="LB_Cedula"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NotaEvaluacion"
	Default="Nota Evaluaci&oacute;n"
	returnvariable="LB_NotaEvaluacion"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ResultadoEvaluacion"
	Default="Resultado Evaluaci&oacute;n"
	returnvariable="LB_ResultadoEvaluacion"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NotaIndicador"
	Default="Nota Indicador"
	returnvariable="LB_NotaIndicador"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ResultadoIndicador"
	Default="Resultado Indicador"
	returnvariable="LB_ResultadoIndicador"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NotaFinal"
	Default="Nota Final"
	returnvariable="LB_NotaFinal"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaNombramiento"
	Default="Fecha Nombramiento"
	returnvariable="LB_FechaNombramiento"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concepto"
	Default="Concepto"
	returnvariable="LB_Concepto"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Respuesta"
	Default="Respuesta"
	returnvariable="LB_Respuesta"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NotaRespuesta"
	Default="Nota Respuesta"
	returnvariable="LB_NotaRespuesta"/>			
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Peso"
	Default="Peso"
	returnvariable="LB_Peso"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nota"
	Default="Nota"
	returnvariable="LB_Nota"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NoSeHaDefinidoLasNotasDeIndicadoresPorCentroFuncional"
	Default="No se ha definido las Notas de Indicadores por Centro Funcional"
	returnvariable="LB_NoSeHaDefinidoLasNotasDeIndicadoresPorCentroFuncional"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NoSeHaDefinidoElParametroPesoDeIndicadoresDeEvaluacionDelDesempenoEnAdministracionDelSistema"
	Default="No se ha definido el par&aacute;metro <strong>Peso de Indicadores de Evaluaci&oacute;n del Desempe&ntilde;o</strong> en Administraci&oacute;n del Sistema"
	returnvariable="LB_NoSeHaDefinidoElParametroPesoDeIndicadoresDeEvaluacionDelDesempenoEnAdministracionDelSistema"/>		

<!--- FIN VARIABLES DE TRADUCCION --->

<!--- DEFINICION DE LAS VARIABLES DEL FORM --->
<cfparam name="centroF" default="">
<cfif isdefined('url.REid') and not isdefined('form.REid')>
	<cfset form.REid = url.REid>
</cfif>
<cfif isdefined('url.CFid') and not isdefined('form.CFid')>
	<cfset form.CFid = url.CFid>
</cfif>
<cfif isdefined('url.CFidG') and not isdefined('form.CFidG')>
	<cfset form.CFidG = url.CFidG>
</cfif>
<cfif isdefined('url.DEid') and not isdefined('form.DEid')>
	<cfset form.DEid = url.DEid>
</cfif>
<cfif isdefined('url.DEidG') and not isdefined('form.DEidG')>
	<cfset form.DEidG = url.DEidG>
</cfif>
<cfif isdefined('url.GREid') and not isdefined('form.GREid')>
	<cfset form.GREid = url.GREid>
</cfif>
<cfif isdefined('url.Tipo') and not isdefined('form.Tipo')>
	<cfset form.Tipo = url.Tipo>
</cfif>
<cfif isdefined('url.formato') and not isdefined('form.formato')>
	<cfset form.formato = url.formato>
</cfif>

<cfif isdefined('form.CFid') and  len(trim(form.CFid))>
	<cfset form.centroF = form.CFid>
</cfif>
<cfif isdefined('form.CFidG') and  len(trim(form.CFidG))>
	<cfset form.centroF = form.CFidG>
</cfif>
<cfif isdefined('form.DEid') and  len(trim(form.DEid))>
	<cfset form.empleado = form.DEid>
</cfif>
<cfif isdefined('form.DEidG') and  len(trim(form.DEidG))>
	<cfset form.empleado = forml.DEidG>
</cfif>

<!--- TRAE DE PARAMETROS DE RH EL PESO DEL INDICADOR DEFINIDO --->
<cfquery name="rsPesoIndicador" datasource="#session.DSN#">
select Pvalor as indicador
from RHParametros 
where Pcodigo = 620
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
</cfquery>
<cfif rsPesoIndicador.Recordcount EQ 0>
<cf_throw message="#LB_NoSeHaDefinidoElParametroPesoDeIndicadoresDeEvaluacionDelDesempenoEnAdministracionDelSistema#" errorcode="8040">
</cfif>
<!--- VERIFICA QUE LA TABLA DE NOTAS DE INDICADOR POR CENTRO FUNCIONAL, TENGA LOS DATOS PARA LA RELACION --->
<cfquery name="rsNotaIndicador" datasource="#session.DSN#">
select 1
from RHNotasIndicadoresCF
where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
</cfquery>
<cfif rsNotaIndicador.Recordcount EQ 0>
<cf_throw message="#LB_NoSeHaDefinidoLasNotasDeIndicadoresPorCentroFuncional#" errorcode="8045">
</cfif>
</cfsilent>

<cfsilent>
	<!--- TRAE LOS DATOS DE LA RELACION --->
	<cfquery name="rsRelacion" datasource="#session.DSN#">
		select REdescripcion,REdesde,REhasta
		from RHRegistroEvaluacion
		where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	
	<cfparam name="Evaluacion" default="0">
	<cfparam name="Indicador" default="0">
	<cfset Evaluacion = (100.00 - rsPesoIndicador.Indicador)/100.00>
	<cfset Indicador = rsPesoIndicador.Indicador/100.00>
		<cf_dbtemp name="datos" returnvariable="datos" datasource="#session.DSN#">
				<cf_dbtempcol name="DEid"						type="numeric"		mandatory="yes" > 
				<cf_dbtempcol name="DEidentificacion"			type="varchar(255)"	mandatory="yes" > 
				<cf_dbtempcol name="NombreEmp"					type="varchar(255)"	mandatory="yes" > 
				<cf_dbtempcol name="Concepto"					type="varchar(255)"	mandatory="yes" > 
				<cf_dbtempcol name="Respuesta"					type="varchar(255)"	mandatory="yes" > 
				<cf_dbtempcol name="Porcentaje_segun_respuesta"	type="float"		mandatory="yes" > 
				<cf_dbtempcol name="Peso"						type="numeric"		mandatory="yes" > 
				<cf_dbtempcol name="PesoJ"						type="numeric"		mandatory="yes" >
				<cf_dbtempcol name="IREevaluasubjefe"				type="numeric"		mandatory="yes" >
				<cf_dbtempcol name="FechaIngreso"				type="datetime"			mandatory="yes" > 	
				<cf_dbtempcol name="NotaIndicadorCF"			type="float"		mandatory="yes" > 
				<cf_dbtempcol name="TEcodigo"					type="numeric"		mandatory="yes" > 
			</cf_dbtemp>	
			<cfquery name="rsReporte" datasource="#session.DSN#">
				insert into #datos#
				select de.DEid,
					de.DEidentificacion, 
					{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as NombreEmp,
					(select i.IAEdescripcion from RHIndicadoresAEvaluar i where i.IAEid = c.IAEid) as concepto,
					coalesce(convert(char(5),b.CDERespuestaj),'') as Respuesta ,
					isnull((select e.TEVequivalente 
							from TablaEvaluacionValor e 
							where e.TEcodigo = c.TEcodigo 
							  and e.TEVvalor = convert(char(5),b.CDERespuestaj)),0) as Porcentaje_segun_respuesta,
					c.IREpesop as Valor_Emp, 
					c1.IREpesojefe as Valor_Jefe, 
					c.IREevaluasubjefe,
					(select EVfantig from EVacacionesEmpleado where DEid = a.DEid) as FechaIngreso,
					ni.Nota,
					c.TEcodigo
				from RHRegistroEvaluadoresE a
				inner join RHRegistroEvaluacion Rel
					on a.REid = Rel.REid
				inner join RHConceptosDelEvaluador b
					on a.REEid = b.REEid
				inner join RHIndicadoresRegistroE c
					on a.REid = c.REid
					and b.IREid = c.IREid
					and not (c.IREevaluasubjefe = 0 and
				 			 c.IREevaluajefe = 1)
					and c.TEcodigo is not null
				inner join RHIndicadoresRegistroE c1
					on a.REid = c1.REid
					and b.IREid = c1.IREid
					and c1.TEcodigo is not null
				inner join RHGruposRegistroE gr
					on gr.REid = a.REid
					<cfif isdefined('form.GREid') and LEN(TRIM(form.GREid))>
					and gr.GREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#"> 
					</cfif>
				inner join RHCFGruposRegistroE gcf
					on gcf.Ecodigo = gr.Ecodigo
					and gcf.GREid = gr.GREid
				<cfif isdefined('form.centroF') and LEN(TRIM(form.centroF))>				
					and gcf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.centroF#"> 
				</cfif>	
				 			
				inner join RHPlazas rhp
					on rhp.Ecodigo = gcf.Ecodigo
					and rhp.CFid = gcf.CFid
				inner join LineaTiempo lt
					on lt.Ecodigo = rhp.Ecodigo
					and lt.RHPid = rhp.RHPid
					and lt.DEid = a.DEid
					and Rel.REdesde between lt.LTdesde and lt.LThasta
				inner join RHPuestos rhpu
					on rhpu.Ecodigo = lt.Ecodigo
					and rhpu.RHPcodigo = lt.RHPcodigo
				inner join DatosEmpleado de
					on a.DEid = de.DEid
				inner join RHNotasIndicadoresCF ni
					on ni.REid = a.REid 
					and ni.CFid = rhp.CFid
				inner join RHEmpleadoRegistroE ere
					on ere.REid = a.REid
					and ere.DEid = a.DEid
					and ere.EREnojefe = 0
				where a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#"> 
				<cfif isdefined('form.empleado') and LEN(TRIM(form.empleado))>
				  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.empleado#"> 
				</cfif>
				order by de.DEidentificacion,c.TEcodigo
			</cfquery>
			<cfquery name="rsDatos" datasource="#session.DSN#">
				select distinct DEid
				from #datos#
			</cfquery>
	
			<cfloop query="rsDatos">
				<!--- VERIFICA SI ELEMPLEADO A EVALUAR ES JEFE Y DE ESTA MANERA ASIGNA EL PESO --->
				<cfquery name="rsEsJefe" datasource="#session.DSN#">
					select EREjefeEvaluador, DEid
					from RHEmpleadoRegistroE
					where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DEid#"> 
				</cfquery>
				<cfset esjefe = rsEsJefe.EREjefeEvaluador>
				<cfif esjefe>
					<!--- SI ES JEFE SE LIMPIA EL CAMPO Peso DE LA TABLA TEMPORAL, EL CUAL ALMACENA EL PESO PARA
						UN EMPLEADO QUE NO ES JEFE, DE MANERA QUE SE TRABAJA TOMANDO COMO REFERENCIA EL PESO DE EMPLEADO --->
					<cfquery datasource="#session.DSN#">
						update #datos#
						set Peso = 0
						where DEid = #rsEsJefe.DEid#
					</cfquery>
				<!--- <cfelse>
					<cfquery name="rsEvalJ" datasource="#session.DSN#">
						select 1
						from #datos#
						where DEid = #rsDatos.DEid#
						  and IREevaluasubjefe = 1
					</cfquery>
					<cfif rsEvalJ.RecordCount>
						<cfquery datasource="#session.DSN#">
							update #datos#
							set Peso = 0
							where DEid = #rsDatos.DEid#
						</cfquery>
					</cfif> --->
				</cfif>
			</cfloop>			
			<cfif isdefined('form.Tipo') and form.Tipo EQ 2>
				<!--- SI EL TIPO DE REPORTE ES DETALLADO --->
				<cfquery name="rsReporte" datasource="#session.DSN#">
					select DEid,DEidentificacion,NombreEmp,Concepto,
						Respuesta,Porcentaje_segun_respuesta,IREevaluasubjefe,FechaIngreso,
						case when (Peso > 0) and (PesoJ = 0) then Peso
							 when (Peso = 0) and (PesoJ > 0) then PesoJ
							 else Peso end as Peso
					from #datos#
					<cfif form.formato EQ 'T'>
					order by DEidentificacion,TEcodigo, Concepto
					<cfelse>
					order by Nota
					</cfif>
				</cfquery>
			<cfelse>
				<!--- SI EL TIPO DE REPORTE ES RESUMIDO --->
				<cfquery name="rsReporte" datasource="#session.DSN#">
					select 	sum(case when (Peso > 0) and (PesoJ = 0) then (Porcentaje_segun_respuesta*Peso)/100
							 when (Peso = 0) and (PesoJ > 0) then (Porcentaje_segun_respuesta*PesoJ)/100
							 else (Porcentaje_segun_respuesta*Peso)/100 end) as NotaEval,
							 sum(case when (Peso > 0) and (PesoJ = 0) then (Porcentaje_segun_respuesta*Peso)/100
							 when (Peso = 0) and (PesoJ > 0) then (Porcentaje_segun_respuesta*PesoJ)/100
							 else (Porcentaje_segun_respuesta*Peso)/100 end)*#Evaluacion# as ResultEval,
							(sum(case when (Peso > 0) and (PesoJ = 0) then (Porcentaje_segun_respuesta*Peso)/100
							 when (Peso = 0) and (PesoJ > 0) then (Porcentaje_segun_respuesta*PesoJ)/100
							 else (Porcentaje_segun_respuesta*Peso)/100 end)*#Evaluacion#)+(#Indicador#*NotaIndicadorCF) as Nota,
							convert(numeric,floor((sum(case when (Peso > 0) and (PesoJ = 0) then (Porcentaje_segun_respuesta*Peso)/100
							 when (Peso = 0) and (PesoJ > 0) then (Porcentaje_segun_respuesta*PesoJ)/100
							 else (Porcentaje_segun_respuesta*Peso)/100 end)*#Evaluacion#)+(#Indicador#*NotaIndicadorCF))) as Nota2,
							DEidentificacion,
							NombreEmp,
							FechaIngreso,
							NotaIndicadorCF,
							#Evaluacion# as Evaluacion,
							#Indicador# as Indicador
					from #datos#
					group by DEid,DEidentificacion,NombreEmp,FechaIngreso,NotaIndicadorCF
					<cfif form.formato EQ 'T'>
					order by DEidentificacion
					<cfelse>
					order by Nota
					</cfif>
				</cfquery>
			</cfif>

</cfsilent>
<cf_templatecss>
<cfif isdefined('form.formato') and form.formato EQ 'T'>
		<cf_htmlReportsHeaders 
			irA="ReporteEvaluacion180.cfm"
			FileName="ReporteEvaluacionDesempenno.xls"
			title="#LB_ReporteDeEvaluacionDelDesempenoDeJefaturas#">

	
		<cfif isdefined('form.Tipo') and form.Tipo EQ 1><!--- REPORTE RESUMIDO --->
			<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
				<cfoutput>
					<tr><td colspan="7" align="center"><strong>#Trim(Session.Enombre)#</strong></td></tr>
					<tr><td colspan="7" align="center"><strong><cf_translate key="LB_ReporteDeEvaluacionDelDesempe&ntilde;oDeJefaturasResumido">Reporte de Evaluaci&oacute;n del Desempe&ntilde;o de Jefaturas Resumido</cf_translate></strong></td></tr>
					</tr>	
						<td colspan="7" align="center" >
							<strong>
							#rsRelacion.REdescripcion#&nbsp;&nbsp;<cf_translate key="LB_Del">del</cf_translate>&nbsp;#lsdateformat(rsRelacion.REdesde,"DD/MM/YYYY")#&nbsp;&nbsp;<cf_translate key="LB_Al">al</cf_translate>&nbsp;#lsdateformat(rsRelacion.REhasta,"DD/MM/YYYY")#
							</strong>
						</td>
					</tr>
					<tr>	
						<td align="center" colspan="7">
							<strong><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:</strong>&nbsp;&nbsp;#lsdateformat(now(),"DD/MM/YYYY")# &nbsp;&nbsp;
					  	</td>
					</tr>
					<tr><td colspan="6">&nbsp;</td></tr>	
					<tr  height="26">
						<td  class="tituloListas" valign="top"><strong>#LB_Cedula#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="right"><strong>#LB_NotaEvaluacion#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="right"><strong>#LB_ResultadoEvaluacion#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="right"><strong>#LB_NotaIndicador#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="right"><strong>#LB_ResultadoIndicador#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="right"><strong>#LB_NotaFinal#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="right"><strong>#LB_FechaNombramiento#</strong>&nbsp;</td>
					</tr>
				</cfoutput>
				<cfoutput query="rsReporte">
					<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td nowrap>#DEidentificacion#&nbsp;&nbsp;</td>
						<td nowrap>#NombreEmp#</td>
						<td nowrap align="right">#LSNumberFormat(NotaEval,'999,999.99')#</td>
						<td nowrap align="right">#LSNumberFormat(ResultEval,'999,999.99')#</td>
						<td nowrap align="right">#LSNumberFormat(NotaIndicadorCF,'999,999.99')#</td>
						<td nowrap align="right">#LSNumberFormat(Indicador*NotaIndicadorCF,'999,999.99')#</td>
						<td nowrap align="right">#LSNumberFormat(Nota,'999,999.99')#</td>
						<td nowrap align="right">#lsdateformat(FechaIngreso,"DD/MM/YYYY")#</td>
					</tr>
				</cfoutput>
			</table>
		<cfelse><!--- REPORTE DETALLADO --->
			<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
				<cfoutput>
					<tr><td colspan="6" align="center"><strong>#Trim(Session.Enombre)#</strong></td></tr>
					<tr><td colspan="6" align="center"><strong><cf_translate key="LB_ReporteDeEvaluacionDelDesempenoDeJefaturasDetallado">Reporte Evaluaci&oacute;n Del Desempe&ntilde;o de Jefaturas Detallado</cf_translate></strong></td></tr>
					<tr>	
						<td colspan="6" align="center" >
							<strong>
							#rsRelacion.REdescripcion#&nbsp;&nbsp;<cf_translate key="LB_Del">del</cf_translate>&nbsp;#lsdateformat(rsRelacion.REdesde,"DD/MM/YYYY")#&nbsp;&nbsp;<cf_translate key="LB_Al">al</cf_translate>&nbsp;#lsdateformat(rsRelacion.REhasta,"DD/MM/YYYY")#
							</strong>
						</td>
					</tr>
					<tr>	
						<td align="center" colspan="6">
							<strong><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:</strong>&nbsp;&nbsp;#lsdateformat(now(),"DD/MM/YYYY")# &nbsp;&nbsp;
					  	</td>
					</tr>
					<tr><td colspan="6">&nbsp;</td></tr>	
					<tr>
						<td  class="tituloListas" valign="top"><strong>#LB_Concepto#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top"><strong>#LB_Respuesta#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="right"><strong>#LB_NotaRespuesta#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="right"><strong>#LB_Peso#</strong>&nbsp;</td>
						<td  class="tituloListas" valign="top" align="right"><strong>#LB_Nota#</strong>&nbsp;</td>
					</tr>
				</cfoutput>
				<cfoutput query="rsReporte" group="DEidentificacion">
					<tr><td colspan="6">&nbsp;</td></tr>	
					<tr height="26" class="tituloListas" >
						<td colspan="2" nowrap<strong>#DEidentificacion#</strong>&nbsp;&nbsp;&nbsp;<strong>#NombreEmp#</strong>&nbsp;</td>
						<td nowrap colspan="4" align="center"><strong>#LB_FechaNombramiento#</strong>&nbsp;<strong>#lsdateformat(FechaIngreso,"DD/MM/YYYY")#</strong>&nbsp;</td>
					</tr>	
					<cfoutput>
						<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td nowrap>#concepto#</td>
							<td nowrap>#Respuesta#</td>
							<td nowrap align="right">#LSNumberFormat(Porcentaje_segun_respuesta,'999,999.99')#</td>
							<td nowrap align="right">#LSNumberFormat(Peso,'999,999.99')#</td>
							<td nowrap align="right">#LSNumberFormat((Porcentaje_segun_respuesta*Peso)/100,'999,999.99')#</td>
							
						</tr>
					</cfoutput>	
				</cfoutput>
			</table>
		</cfif>
<cfelse>
	<cfinclude template="ReporteEvaluacion180_Grafico.cfm">
</cfif>
