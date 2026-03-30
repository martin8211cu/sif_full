<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_NoHayPlanesDeSucesionAsociados" Default="No hay Planes de Suceci&oacute;n Asociados" returnvariable="MSG_NoHayPlanesDeSucesionAsociados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NuevaNota" Default="Nueva Nota" returnvariable="LB_NuevaNota" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Nivel" Default="Nivel" returnvariable="LB_Nivel" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Peso" Default="Peso" returnvariable="LB_Peso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Minimo" Default="M&iacute;nimo" returnvariable="LB_Minimo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NotaAnterior" Default="Nota Ant." returnvariable="LB_NotaAnterior" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Habilidades" Default="Habilidades" returnvariable="LB_Habilidades" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Conocimientos" Default="Conocimientos" returnvariable="LB_Conocimientos" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="MSG_ElValorDebeEstarEntre0Y100" Default="El Valor debe estar entre 0 y 100" returnvariable="MSG_ElValorDebeEstarEntre0Y100" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_EstaHabilidadSeEncuentraEvaluadaParaUnaFechaIgualOPosteriorALaFechaDeCorteDeLaRelacionLaEvaluacionPreviaSePerdera" Default="Esta habilidad se encuentra evaluada para una fecha igual o posterior a la fecha de corte de la Relación. La Evaluación previa se perderá." returnvariable="MSG_EstaHabilidadSeEncuentraEvaluadaParaUnaFechaIgualOPosteriorALaFechaDeCorteDeLaRelacionLaEvaluacionPreviaSePerdera" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ErrorTodasLasNotasSonRequeridasCompleteLasNotasParaContinuar" Default="Error. Todas las notas son requeridas, complete las notas para continuar" returnvariable="MSG_ErrorTodasLasNotasSonRequeridasCompleteLasNotasParaContinuar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ErrorTodasLasNotasDebenSerMonoresA100CorrijaLasNotasParaContinuar" Default="Error. Todas las notas son requeridas, complete las notas para continuar" returnvariable="MSG_ErrorTodasLasNotasDebenSerMonoresA100CorrijaLasNotasParaContinuar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ElValorDebeEstarEntre0Y100" Default="El Valor debe estar entre 0 y 100" returnvariable="MSG_ElValorDebeEstarEntre0Y100" component="sif.Componentes.Translate" method="Translate"/>	

<cfinvoke Key="MSG_HayNotasConValorEnCeroDeseaGuardar" Default="Hay notas con valor en Cero. Desea guardar?" returnvariable="MSG_HayNotasConValorEnCeroDeseaGuardarlas" component="sif.Componentes.Translate" method="Translate"/>	
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("form.btnGuardar")>
	<cfquery name="rsPS" datasource="#session.dsn#">
		select d.RHEPSlinea
		
			from RHHabilidadesPuesto a
			
			inner join RHEmpleadosCF c
			on c.Ecodigo = a.Ecodigo
			and c.RHPcodigo = a.RHPcodigo
			and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and c.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		
			inner join RHEvalPlanSucesion d
			on d.RHHid = a.RHHid
			and d.RHRCid = c.RHRCid
			and d.DEid = c.DEid
			and d.RHPcodigo = 
			<cfif isdefined("form.RHPcodigo")>
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
			<cfelse>
				(select min (RHPcodigo) from RHEvalPlanSucesion dd
					where dd.RHHid = a.RHHid
					and dd.RHRCid = c.RHRCid
					and dd.DEid = c.DEid)
			</cfif>
			
		UNION
		
		select d.RHEPSlinea
			
			from RHConocimientosPuesto a
			
			inner join RHEmpleadosCF c
			on c.Ecodigo = a.Ecodigo
			and c.RHPcodigo = a.RHPcodigo
			and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and c.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		
			inner join RHEvalPlanSucesion d
			on d.RHCid = a.RHCid
			and d.RHRCid = c.RHRCid
			and d.DEid = c.DEid
			and d.RHPcodigo = 
			<cfif isdefined("form.RHPcodigo")>
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
			<cfelse>
				(select min (RHPcodigo) from RHEvalPlanSucesion dd
					where dd.RHCid = a.RHCid
					and dd.RHRCid = c.RHRCid
					and dd.DEid = c.DEid)
			</cfif>
	</cfquery>
	<cfloop query="rsPS">
		<cfif isdefined("form.nuevanota"&RHEPSlinea)>
			<cfquery datasource="#session.dsn#">
				update RHEvalPlanSucesion
				set nuevanota = <cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('form.nuevanota'&RHEPSlinea)#">
				where RHEPSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHEPSlinea#">
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<cfquery name="rsP" datasource="#session.dsn#">
	select distinct coalesce(e.RHPcodigoext,e.RHPcodigo) as RHPcodigoext, e.RHPcodigo, e.RHPdescpuesto
	
	from RHEvalPlanSucesion d
		
	inner join RHPuestos e
		on e.Ecodigo = d.Ecodigo
		and e.RHPcodigo = d.RHPcodigo
	
	where d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and d.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
</cfquery>
<!---
<cfset nuevanota="'<input type=''text'' name=''nuevanota'||convert(varchar(50),d.RHEPSlinea)||''' value='''||convert(varchar(50),d.nuevanota)||''' onfocus=''this.value=qf(this); this.select();'' 
		onblur=''javascript: fm(this,2);valida(this);'' onkeyup=''if(snumber(this,event,2)){ if(Key(event)==13) {this.blur();}}'' size=''6'' maxlength=''6'' style=''text-align: right;''>'">
--->

<cfset nuevanota="{fn concat('<input type=''text'' name=''nuevanota',{fn concat(convert(varchar(50),d.RHEPSlinea),{fn concat(''' value=''',
{fn concat(convert(varchar(50),d.nuevanota),''' onfocus=''this.value=qf(this); this.select();'' 
		onblur=''javascript: fm(this,2);valida(this);'' onkeyup=''if(snumber(this,event,2)){ if(Key(event)==13) 
		{this.blur();}}'' size=''6'' maxlength=''6'' style=''text-align: right;''>')})})})}">


		
<cfset admimg = "'<img border=''0'' tabindex=''-1'' src=''/cfmx/rh/imagenes/Excl16.gif'' alt=''"&MSG_EstaHabilidadSeEncuentraEvaluadaParaUnaFechaIgualOPosteriorALaFechaDeCorteDeLaRelacionLaEvaluacionPreviaSePerdera&"''>'">
<cfquery name="rsPS" datasource="#session.dsn#">
	select a.RHHid as id, b.RHHcodigo as codigo, b.RHHdescripcion as descripcion, coalesce(a.RHNnotamin,0)*100 as nota, a.RHHpeso as peso, n.RHNcodigo as nivel,
		d.RHEPSlinea, d.RHRCid, d.CFid, d.DEid, d.notaant, 1 as tipo, '#LB_Habilidades#' as corte,
		#PreserveSingleQuotes(nuevanota)#	as nuevanota,
		case 
		(
			select count(1) 
			from RHCompetenciasEmpleado
			where RHCompetenciasEmpleado.DEid = c.DEid
				and RHCompetenciasEmpleado.idcompetencia = a.RHHid
				and RHCompetenciasEmpleado.tipo = 'H'
				and RHCompetenciasEmpleado.RHCEfdesde >= e.RHRCfcorte
		) 
		when 0 then '' else #PreserveSingleQuotes(admimg)# end as msg
	
		from RHHabilidadesPuesto a
		
		inner join RHHabilidades b
		on a.Ecodigo=b.Ecodigo
		and a.RHHid=b.RHHid
	
		inner join RHNiveles n
		on n.Ecodigo = a.Ecodigo
		and n.RHNid = a.RHNid
	
		inner join RHEmpleadosCF c
		on c.Ecodigo = a.Ecodigo
		and c.RHPcodigo = a.RHPcodigo
		and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and c.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	
		inner join RHEvalPlanSucesion d
		on d.RHHid = a.RHHid
		and d.RHRCid = c.RHRCid
		and d.DEid = c.DEid
		and d.RHPcodigo = 
		<cfif isdefined("form.RHPcodigo")>
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		<cfelse>
			(select min (RHPcodigo) from RHEvalPlanSucesion dd
				where dd.RHHid = a.RHHid
				and dd.RHRCid = c.RHRCid
				and dd.DEid = c.DEid)
		</cfif>
		
		inner join RHRelacionCalificacion e
		on e.RHRCid = c.RHRCid
		
	UNION
	
	select a.RHCid, b.RHCcodigo, b.RHCdescripcion, coalesce(a.RHCnotamin,0)*100 as nota, a.RHCpeso as peso, n.RHNcodigo as nivel,
		d.RHEPSlinea, d.RHRCid, d.CFid, d.DEid, d.notaant, 2 as tipo, '#LB_Conocimientos#' as corte,
		#PreserveSingleQuotes(nuevanota)#	as nuevanota,
		case 
		(
			select count(1) 
			from RHCompetenciasEmpleado
			where RHCompetenciasEmpleado.DEid = c.DEid
				and RHCompetenciasEmpleado.idcompetencia = a.RHCid
				and RHCompetenciasEmpleado.tipo = 'C'
				and RHCompetenciasEmpleado.RHCEfdesde >= e.RHRCfcorte
		) 
		when 0 then '' else #PreserveSingleQuotes(admimg)# end as msg
		
		from RHConocimientosPuesto a
		
		inner join RHConocimientos b
		on a.Ecodigo=b.Ecodigo
		and a.RHCid=b.RHCid
		
		inner join RHNiveles n
		on n.Ecodigo = a.Ecodigo
		and n.RHNid = a.RHNid
		
		inner join RHEmpleadosCF c
		on c.Ecodigo = a.Ecodigo
		and c.RHPcodigo = a.RHPcodigo
		and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and c.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	
		inner join RHEvalPlanSucesion d
		on d.RHCid = a.RHCid
		and d.RHRCid = c.RHRCid
		and d.DEid = c.DEid
		and d.RHPcodigo = 
		<cfif isdefined("form.RHPcodigo")>
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		<cfelse>
			(select min (RHPcodigo) from RHEvalPlanSucesion dd
				where dd.RHCid = a.RHCid
				and dd.RHRCid = c.RHRCid
				and dd.DEid = c.DEid)
		</cfif>
		
		inner join RHRelacionCalificacion e
		on e.RHRCid = c.RHRCid

	order by tipo, descripcion
</cfquery>
<cfif not isdefined("scriptmontodefinition")>
	<cfset scriptmontodefinition = 1>
	<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
</cfif>
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="TituloListas"><tr><td align="right">
<form action="evaluacion.cfm" method="post" name="form_filtro_puesto" style="margin:0px;">
	<input type="hidden" name="RHRCid" value="#form.RHRCid#">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<input type="hidden" name="tab" value="2">
	<select name="RHPcodigo" onChange="document.form_filtro_puesto.submit();" >
		<cfloop query="rsP">
			<option value="#rsP.RHPcodigo#" <cfif isdefined("form.RHPcodigo") and form.RHPcodigo eq rsP.RHPcodigo>selected</cfif>>#rsP.RHPdescpuesto#</option>
		</cfloop>
	</select>
</form>
</td></tr><tr><td>
</cfoutput>
<form name="lista" method="post" action="evaluacion.cfm" style="margin:0px;">
<cfoutput>
	<!--- VARIABLES PARA  MANTENER LE FILTRO DE LA LISTA DE EMPLEADOS --->
	<cfif isdefined('form.Filtro_Estado') and LEN(TRIM(form.Filtro_Estado))>
	<input type="hidden" name="Filtro_Estado" value="#form.Filtro_Estado#">
	<input type="hidden" name="HFiltro_Estado" value="#form.Filtro_Estado#">
	</cfif>
	<cfif isdefined('form.Filtro_DEidentificacion') and LEN(TRIM(form.Filtro_DEidentificacion))>
	<input type="hidden" name="Filtro_DEidentificacion" value="#form.Filtro_DEidentificacion#">
	<input type="hidden" name="HFiltro_DEidentificacion" value="#form.Filtro_DEidentificacion#">
	</cfif>
	<cfif isdefined('form.Filtro_DENombreCompleto') and LEN(TRIM(form.Filtro_DENombreCompleto))>
	<input type="hidden" name="Filtro_DENombreCompleto" value="#form.Filtro_DENombreCompleto#">
	<input type="hidden" name="HFiltro_DENombreCompleto" value="#form.Filtro_DENombreCompleto#">
	</cfif>
	<input type="hidden" name="RHRCid" value="#form.RHRCid#">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<input type="hidden" name="tab" value="2">
	<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
		<input type="hidden" name="RHPcodigo" value="#form.RHPcodigo#">
	</cfif>
</cfoutput>
<cfinvoke 
	component="rh.Componentes.pListas"
	method="pListaQuery"
	returnvariable="pLista">
		<cfinvokeargument name="query" value="#rsPS#"/>
		<cfinvokeargument name="desplegar" value="descripcion,nivel,peso,nota,notaant,nuevanota,msg"/>
		<cfinvokeargument name="cortes" value="corte"/>
		<cfinvokeargument name="etiquetas" value="#LB_Descripcion#,#LB_Nivel#,#LB_Peso#,#LB_Minimo#,#LB_NotaAnterior#,#LB_NuevaNota#, "/>
		<cfinvokeargument name="formatos" value="S,S,I,P,M,S,S"/>
		<cfinvokeargument name="align" value="left, right, right, right, right, right, right"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="maxrows" value="0"/>
		<cfinvokeargument name="irA" value="evaluacion.cfm"/>
		<cfinvokeargument name="showLink" value="#false#"/>
		<cfinvokeargument name="PageIndex" value="3"/>
		<cfinvokeargument name="incluyeForm" value="#false#"/>
		<cfinvokeargument name="formName" value="lista"/>
		<cfinvokeargument name="Botones" value="Guardar,Regresar"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="EmptyListMsg" value="#MSG_NoHayPlanesDeSucesionAsociados#"/>
</cfinvoke>
</form>
<script language="javascript" type="text/javascript">
	function funcGuardar(){
		var cont = 0;
		<cfoutput query="rsPS">
			if (document.lista.nuevanota#RHEPSlinea#.value==''){
				alert('<cfoutput>#MSG_ErrorTodasLasNotasSonRequeridasCompleteLasNotasParaContinuar#</cfoutput>');
				return false;
			}
			var valor = parseFloat(document.lista.nuevanota#RHEPSlinea#.value);
			if (valor>100){
				alert('<cfoutput>#MSG_ErrorTodasLasNotasDebenSerMonoresA100CorrijaLasNotasParaContinuar#</cfoutput>');
				return false;
			}
			if (valor <= 0) cont = 1;
		</cfoutput>
		if (cont == 1){
			if (!confirm('<cfoutput>#MSG_HayNotasConValorEnCeroDeseaGuardarlas#</cfoutput>')){
				return false;
			}
		}
		return true;
	}
	function valida(n){
		if (n.value < 0 || n.value > 100){
			alert('<cfoutput>#MSG_ElValorDebeEstarEntre0Y100#</cfoutput>');
			n.focus();
		}
	}
	function funcRegresar(){
		document.lista.DEid.value ='';
		return true; 
	}
</script>
<br>
</td></tr></table>