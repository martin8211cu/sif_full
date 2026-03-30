<cfif isdefined("url.DEid") and len(trim(url.DEid))><cfset Form.DEid = Url.DEid></cfif>
<cfif isdefined("url.DClinea") and len(trim(url.DClinea))><cfset Form.DClinea = Url.DClinea></cfif>
<cfparam name="Form.DEid" default="0">
<cfparam name="Form.DClinea" default="0">
<cfset Filtro="">
<cfif Form.DEid GT 0><cfset Filtro = Filtro & " and de.DEid = " & Form.DEid></cfif>
<cfif Form.DClinea GT 0><cfset Filtro = Filtro & " and dc.DClinea = " & Form.DClinea></cfif>
<form action="CaculoInteresesCesantia.cfm" method="post" name="form1">
	<cfoutput>
	<table align="center" border="0" cellpadding="0" cellspacing="0" class="" id="tbl_filter" width="100%">
		<tr><td class="TituloListas">#LB_Detalle_Carga#:</td><td class="TituloListas">
			<cf_conlis
				campos="DClinea,DCcodigo,DCdescripcion"
				desplegables="N,S,S"
				modificables="N,S,N"
				size="0,14,53"
				traerInicial="#Form.DClinea GT 0#"
				traerFiltro="DClinea = #Form.DClinea#"
				title="Lista De Detalles de Carga"
				tabla="DCargas"
				columnas="DClinea,DCcodigo,DCdescripcion"
				filtro="Ecodigo = #Session.Ecodigo#"
				desplegar="DCcodigo,DCdescripcion"
				etiquetas="C&oacute;digo,Descripci&oacute;"
				align="left,left"
				formatos="S,S"
				asignar="DClinea,DCcodigo,DCdescripcion"
				asignarformatos="I,S,S"
				
				>
		</td></tr>
		<tr><td class="TituloListas">#LB_Empleado#:</td><td class="TituloListas"><cf_rhempleado idempleado="#Form.DEid#"></td></tr>
		<tr><td class="TituloListas" colspan="2"><cf_botones values="Cerrar_Mes,Recalcular_Desde"></td></tr>
	</table>
	</cfoutput>
	<cf_dbfunction name="to_char" args="cs.RHCSmes" returnvariable="to_char_RHCSmes">
	<cfquery name="rsPeriodo" datasource="#session.dsn#">
		select -1 as value, 'Todos' as description union
		select RHCSperiodo as value, <cf_dbfunction name="to_char" args="RHCSperiodo"> as description from RHCesantiaSaldos
		order by 1
	</cfquery>
	<cfquery name="rsMes" datasource="#session.dsn#">
		select -1 as value, 'Todos' as description union
		select <cf_dbfunction name="to_number" args="vs.VSvalor"> as value, vs.VSdesc as description
		from VSidioma vs
			inner join Idiomas i
			on i.Iid = vs.Iid
			and i.Icodigo = '#session.idioma#'
		where VSgrupo = 1
		order by 1
	</cfquery>
	<cfinvoke 
		component="rh.Componentes.pListas" method="pListaRH"
		columnas="(DCdescripcion) as Detalle_Carga,
			({fn concat(DEidentificacion, 
				{fn concat( ' ' , 
					{fn concat( DEapellido1 , 
						{fn concat( ' ' , 
							{fn concat( DEapellido2 , 
								{fn concat( ' ' , DEnombre
								)}
							)}
						)}
					)}
				)}
			)}) as Nombre_Completo,
			RHCSperiodo as Periodo,
			RHCSmes as MesInt,
			(select vs.VSdesc
				from VSidioma vs
					inner join Idiomas i
					on i.Iid = vs.Iid
					and i.Icodigo = '#session.idioma#'
				where VSgrupo = 1
				and VSvalor = #to_char_RHCSmes# 
			) as Mes,
			RHCSsaldoInicial as Saldo_Inicial,
			RHCSmontoMes as Aportes_Mes,
			RHCSsaldoInicialInt as Saldo_Inicial_Intereses,
			RHCSmontoMesInt as AportesMesIntereses,
			(RHCSsaldoInicial + RHCSmontoMes + RHCSsaldoInicialInt + RHCSmontoMesInt) as Total, '' as esp"
		filtrar_por="RHCSperiodo,RHCSmes,RHCSsaldoInicial,RHCSmontoMes,RHCSsaldoInicialInt,RHCSmontoMesInt,(RHCSsaldoInicial+RHCSmontoMes+RHCSsaldoInicialInt+RHCSmontoMesInt),''"
		cortes="Detalle_Carga,Nombre_Completo"
		tabla="RHCesantiaSaldos cs
			inner join DCargas dc
			on dc.DClinea = cs.DClinea
			inner join DatosEmpleado de
			on de.DEid = cs.DEid"
		filtro="de.Ecodigo = #session.Ecodigo# #filtro# order by 1,2,3,4"
		desplegar="Periodo,Mes,Saldo_Inicial,Aportes_Mes,Saldo_Inicial_Intereses,AportesMesIntereses,Total,esp"
		etiquetas="#LB_Periodo#,#LB_Mes#,#LB_Saldo_Inicial#,#LB_Aportes_Mes#,#LB_Saldo_Inicial_Intereses#,#LB_Aportes_Mes_Intereses#,#LB_Total#, "
		formatos="S,S,M,M,M,M,M,U"
		align="left,left,right,right,right,right,right,left"
		irA="CaculoInteresesCesantia.cfm"
		checkboxes="N"
		mostrar_filtro="true"
		filtrar_automatico="true" 
		incluyeForm="false" 
		showLink="false"
		formName="form1"
		debug="N" 
		rsPeriodo="#rsPeriodo#"
		rsMes="#rsMes#"
	/>
	<table align="center" border="0" cellpadding="0" cellspacing="0" class="" id="tbl_filter" width="100%">
		<tr><td class="TituloListas"><cf_botones values="Cerrar_Mes,Recalcular_Desde"></td></tr>
	</table>
</form>
<!---***********************************************************************--->
<!---****** OJO SI SE TOCA ESTA CONSULTA REPLICAR EL CAMBIO EN EL SQL ******--->
<cfquery name="rsFirsOpenMonth" datasource="#session.dsn#" maxrows="1">
	select distinct RHCSperiodo as Periodo, RHCSmes as MesInt, VSdesc as Mes
	from RHCesantiaSaldos cs, DatosEmpleado de, VSidioma vs, Idiomas i
	where cs.RHCScerrado = 0
		and de.DEid = cs.DEid
		and de.Ecodigo = #Session.Ecodigo#
		and vs.VSgrupo = 1
		and vs.VSvalor = #to_char_RHCSmes#
		and i.Iid = vs.Iid
		and i.Icodigo = '#session.idioma#'
	order by 1,2
</cfquery>
<!---****** OJO SI SE TOCA ESTA CONSULTA REPLICAR EL CAMBIO EN EL SQL ******--->
<!---***********************************************************************--->
<cfoutput><script language="javascript">
	function funcChangeFormAction(){
		document.form1.action="CaculoInteresesCesantia-sql.cfm";
	}
	function funcCerrar_Mes(){
		if(!confirm("Desea Cerrar El Mes #rsFirsOpenMonth.Mes# del Periodo #rsFirsOpenMonth.Periodo#?")) return false;
		funcChangeFormAction();
		return true;
	}
	function funcRecalcular_Desde(){
		if(!confirm("Desea Recalcular Intereses con los datos del Filtro (Periodo\\Mes\\Empleado) ?")) return false;
		funcChangeFormAction();
		return true;
	}
</script></cfoutput>