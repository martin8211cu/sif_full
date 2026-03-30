<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_NoHayCompentenciasAsociadas" Default="No hay Compentencias Asociadas" returnvariable="MSG_NoHayCompentenciasAsociadas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NuevaNota" Default="Nueva Nota" returnvariable="LB_NuevaNota" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Nivel" Default="Nivel" returnvariable="LB_Nivel" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Peso" Default="Peso" returnvariable="LB_Peso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Minimo" Default="M&iacute;nimo" returnvariable="LB_Minimo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NotaAnterior" Default="Nota Ant." returnvariable="LB_NotaAnterior" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Habilidades" Default="Habilidades" returnvariable="LB_Habilidades" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Conocimientos" Default="Conocimientos" returnvariable="LB_Conocimientos" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="MSG_ErrorTodasLasNotasSonRequeridasCompleteLasNotasParaContinuar" Default="Error. Todas las notas son requeridas, complete las notas para continuar" returnvariable="MSG_ErrorTodasLasNotasSonRequeridasCompleteLasNotasParaContinuar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ErrorTodasLasNotasDebenSerMonoresA100CorrijaLasNotasParaContinuar" Default="Error. Todas las notas son requeridas, complete las notas para continuar" returnvariable="MSG_ErrorTodasLasNotasDebenSerMonoresA100CorrijaLasNotasParaContinuar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ElValorDebeEstarEntre0Y100" Default="El Valor debe estar entre 0 y 100" returnvariable="MSG_ElValorDebeEstarEntre0Y100" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_EstaCompentenciaSeEncuentraEvaluadaParaUnaFechaIgualOPosteriorALaFechaDeCorteDeLaRelacionLaEvaluacionPreviaSePerdera" Default="Este competencia se encuentra evaluada para una fecha igual o posterior a la fecha de corte de la Relación. La Evaluaci&oacute;n previa se perderá." returnvariable="MSG_EstaCompentenciaSeEncuentraEvaluadaParaUnaFechaIgualOPosteriorALaFechaDeCorteDeLaRelacionLaEvaluacionPreviaSePerdera"component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_HayNotasConValorEnCeroDeseaGuardar" Default="Hay notas con valor en Cero. Desea guardar?" returnvariable="MSG_HayNotasConValorEnCeroDeseaGuardarlas" component="sif.Componentes.Translate" method="Translate"/>	

<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("form.btnGuardar")>
	<cfquery name="rsCompetencias" datasource="#session.dsn#">
		select d.RHEClinea
		
			from RHHabilidadesPuesto a
		
			inner join RHEmpleadosCF c
			on c.Ecodigo = a.Ecodigo
			and c.RHPcodigo = a.RHPcodigo
			and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and c.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		
			inner join RHEvaluacionComp d
			on d.RHRCid = c.RHRCid
			and d.CFid = c.CFid
			and d.DEid = c.DEid
			and d.RHHid = a.RHHid
			
		UNION
		
		select d.RHEClinea
	
			from RHConocimientosPuesto a
			
			inner join RHEmpleadosCF c
			on c.Ecodigo = a.Ecodigo
			and c.RHPcodigo = a.RHPcodigo
			and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and c.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		
			inner join RHEvaluacionComp d
			on d.RHRCid = c.RHRCid
			and d.CFid = c.CFid
			and d.DEid = c.DEid
			and d.RHCid = a.RHCid

	</cfquery>
	<cfloop query="rsCompetencias">
		<cfif isdefined("form.nuevanota"&RHEClinea)>
			<cfquery datasource="#session.dsn#">
				update RHEvaluacionComp
				set nuevanota = <cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('form.nuevanota'&RHEClinea)#">
				where RHEClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHEClinea#">
			</cfquery>
		</cfif>
	</cfloop>
</cfif>

<!---
<cfset nuevanota="'<input type=''text'' name=''nuevanota'||convert(varchar(50),d.RHEClinea)||''' value='''||convert(varchar(50),d.nuevanota)||''' onfocus=''this.value=qf(this); this.select(); '' 
		onblur=''javascript: fm(this,2); valida(this);'' onkeyup=''if(snumber(this,event,2)){ if(Key(event)==13) {this.blur();}}'' size=''6'' maxlength=''6'' style=''text-align: right;''>'">
--->

<cfset nuevanota="{fn concat('<input type=''text'' name=''nuevanota',{fn concat(convert(varchar(50),d.RHEClinea),{fn concat(''' value=''',{fn concat(convert(varchar(50),d.nuevanota),''' onfocus=''this.value=qf(this); this.select(); '' 
		onblur=''javascript: fm(this,2); valida(this);'' onkeyup=''if(snumber(this,event,2)){ if(Key(event)==13) {this.blur();}}'' size=''6'' maxlength=''6'' style=''text-align: right;''>')})})})}">
		
<cfset admimg = "'<img border=''0'' tabindex=''-1'' src=''/cfmx/rh/imagenes/Excl16.gif'' alt=''"&MSG_EstaCompentenciaSeEncuentraEvaluadaParaUnaFechaIgualOPosteriorALaFechaDeCorteDeLaRelacionLaEvaluacionPreviaSePerdera&"''>'">
<cfquery name="rsCompetencias" datasource="#session.dsn#">
	select c.DEid, c.RHRCid, a.RHHid as id, b.RHHcodigo as codigo, b.RHHdescripcion as descripcion, coalesce(a.RHNnotamin,0)*100 as nota, a.RHHpeso as peso, n.RHNcodigo as nivel,
		d.RHEClinea, d.RHRCid, d.CFid, d.DEid, d.notaant, 1 as tipo, '#LB_Habilidades#' as corte,
		#PreserveSingleQuotes(nuevanota)# as nuevanota,
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
	
		inner join RHEvaluacionComp d
		on d.RHRCid = c.RHRCid
		and d.CFid = c.CFid
		and d.DEid = c.DEid
		and d.RHHid = a.RHHid
		
		inner join RHRelacionCalificacion e
		on e.RHRCid = c.RHRCid
		
	UNION
	
	select c.DEid, c.RHRCid, a.RHCid, b.RHCcodigo, b.RHCdescripcion, coalesce(a.RHCnotamin,0)*100 as nota, a.RHCpeso as peso, n.RHNcodigo as nivel,
		d.RHEClinea, d.RHRCid, d.CFid, d.DEid, d.notaant, 2 as tipo, '#LB_Conocimientos#' as corte, 
		#PreserveSingleQuotes(nuevanota)# as nuevanota, 
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
	
		inner join RHEvaluacionComp d
		on d.RHRCid = c.RHRCid
		and d.CFid = c.CFid
		and d.DEid = c.DEid
		and d.RHCid = a.RHCid

		inner join RHRelacionCalificacion e
		on e.RHRCid = c.RHRCid

	order by tipo, descripcion
</cfquery>

<cfif not isdefined("scriptmontodefinition")>
	<cfset scriptmontodefinition = 1>
	<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
</cfif>
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
</cfoutput>
<cfinvoke 
	component="rh.Componentes.pListas"
	method="pListaQuery"
	returnvariable="pLista">
		<cfinvokeargument name="query" value="#rsCompetencias#"/>
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
		<cfinvokeargument name="EmptyListMsg" value="#MSG_NoHayCompentenciasAsociadas#"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
</form>
<script language="javascript" type="text/javascript">
	function funcGuardar(){
		var cont = 0;
		<cfoutput query="rsCompetencias">
			if (document.lista.nuevanota#RHEClinea#.value==''){
				alert('<cfoutput>#MSG_ErrorTodasLasNotasSonRequeridasCompleteLasNotasParaContinuar#</cfoutput>');
				return false;
			}
			var valor = parseFloat(document.lista.nuevanota#RHEClinea#.value);
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