<!---VARIABLES GENERALES--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ListaEmpleados" default = "Lista Empleados" returnvariable="LB_ListaEmpleados" 
xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Identificacion" default = "Identificaci&oacute;n" returnvariable="LB_Identificacion" 
xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Nombre" default = "Nombre" returnvariable="LB_Nombre" 
xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ApellidoPaterno" default = "Apellido Paterno" returnvariable="LB_ApellidoPaterno" 
xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ApellidoMaterno" default = "Apellido Materno" returnvariable="LB_ApellidoMaterno" 
xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ListaCentroFuncional" default = "Lista Centros Funcionales"
returnvariable="LB_ListaCentroFuncional" xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Codigo" default = "C&oacute;digo" returnvariable="LB_Codigo" 
xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default = "Descripci&oacute;n" returnvariable="LB_Descripcion" 
xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Itinerario" default = "Itinerario" returnvariable="BTN_Itinerario" 
xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_RevisaDatos" default = "Por favor revise los siguiente datos" returnvariable="LB_RevisaDatos" xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DescEmpleado" default = "La descripción del empleado no puede quedar en blanco." returnvariable="LB_DescEmpleado" xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CampoDescripcion" default = "La descripción no puede quedar en blanco." 
returnvariable="LB_CampoDescripcion" xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CampoCentroFuncional" default = "El Centro Funcional no puede quedar en blanco." 
returnvariable="LB_CampoCentroFuncional" xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CampoMontoSolicitado" default = "El monto solicitado debe ser mayor que cero." 
returnvariable="LB_CampoMontoSolicitado" xmlfile = "solicitudesAnticipo_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CampoDestino" default = "El Destino no puede quedar en blanco." 
returnvariable="LB_CampoDestino" xmlfile = "solicitudesAnticipo_form.xml"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "Msg_GECcomplemento" default = "El GECcomplemento que contiene ese concepto no concuerda con ninguna cuenta financiera" returnvariable="Msg_GECcomplemento" 
xmlfile = "solicitudesAnticipo_form.xml"/>




<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfset LvarTipoDocumento = 6>
<cfset msjRechazo="">
<cfset GEAestado="0">
<cfset btnNameCalcular="CalcularViaticos">
<cfset btnValueCalcular= "Calcular Viaticos">
<cfset btnExcluirAbajo="Cambio,Baja,Nuevo,Alta,Limpiar">	
<cfset btnNameTC="CalcularTC">
<cfset btnValueTC= "Tipos de Cambio">
<cfset LvarParametroPlanCom=1> <!---1 equivale a plan de compras en parametros generales--->
<cfparam name="LvarSAporComision" default="false">
<cfif isdefined('url.mensaje')>
<cfoutput>
	<script language="javascript">
		alert("#Msg_GECcomplemento#");
	</script>
</cfoutput>
</cfif>

<!--- Tipo Gasto--->
<cfquery datasource="#Session.DSN#" name="rsID_tipo_gasto">
	select 
			GETdescripcion,
			GETid
	from GEtipoGasto
	where Ecodigo = #session.Ecodigo#
</cfquery>

<!---Formulado por--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarConPlanCompras = (rsUsaPlanCuentas.Pvalor EQ 1)>

<!---Categorias destino--->
<cfquery name="rsCategoriasDestino" datasource="#Session.DSN#">
	SELECT 
                GECDid          
                ,GECDcodigo
                ,GECDdescripcion 
                ,GECDmonto         
    FROM GEcategoriaDestino
    WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- SQL selecciona el concepto asociado a una liquidacion--->

<cfquery datasource="#Session.DSN#" name="rsID_concepto_gasto">
	select 
		c.GECdescripcion,
		c.GECid,
		c.GETid,
		c.GECcomplemento
	from 
		GEconceptoGasto c
			inner join GEtipoGasto t
			on  c.GETid = t.GETid
	where Ecodigo = #session.Ecodigo#
	and c.GETid= (
					select 
					min(GETid)
					from 
					GEtipoGasto
					where 
					Ecodigo = #session.Ecodigo#
				)
</cfquery>
<!--- FIN Querry--->



<!---ID del parmetro de la cuanta financiera destinada a los gastos de Empleado si es cambiado, debera cambiarse tambien en la configuracion de ParametrosGE.cfm--->
<cfif LvarSAporComision>
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 1210
	</cfquery>
	<cfif rsSQL.Pvalor EQ "">
		<cfthrow type="toUser" message="Falta definir la Cuenta por Cobrar a Empleados para Comisiones Nacionales en la opción Parámetros de Gastos de Empleado">
	</cfif>
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 1211
	</cfquery>
	<cfif rsSQL.Pvalor EQ "">
		<cfthrow type="toUser" message="Falta definir la Cuenta por Cobrar a Empleados para Comisiones Extranjeras en la opción Parámetros de Gastos de Empleado">
	</cfif>
<cfelse>
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 1200
	</cfquery>
	<cfif rsSQL.Pvalor EQ "">
		<cf_errorCode	code = "50746" msg = "Falta definir la Cuenta por Cobrar para la gestión de Anticipos a Empleados en la opción Parámetros de Gastos de Empleado">
	</cfif>
</cfif>

<!---

<cfquery name="CxC_Anticipo" datasource="#Session.DSN#">
	select CFcuenta, CFdescripcion, CFformato
	  from CFinanciera
	 where CFcuenta = #rsSQL.Pvalor#
</cfquery>--->

<cfif isdefined('url.GEAid') and not isdefined('form.GEAid')>
	<cfparam name="form.GEAid" default="#url.GEAid#">
</cfif>

<cfif isdefined('form.GEAid') and len(trim(form.GEAid)) AND GEAid NEQ "0">
	<cfset modo = 'CAMBIO'>
	<cfquery datasource="#session.dsn#" name="rsFormAntD">
		select 
			GEAid,
			CFcuenta,
			GEADmonto
		from GEanticipoDet
		where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
	</cfquery>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsForm">
		select
				b.GECid as GECid_comision, b.GECnumero, b.GECtipo, b.GECfechaSolicitud, 
				b.GECobservaciones, b.GECobservacionesArrend, GECusaTCE, 
				b.GECautomovil, b.GEChotel, b.GECavion,b.GEInternet,
				b.GECdestino, b.GECDid,

				a.GEAid,
				a.TESBid,
				a.CFid,
				a.GEAdescripcion,
				a.GEAfechaSolicitud,
				a.GEAfechaPagar,
				a.GEAdesde,
				a.GEAhasta,
				a.GEAhoraini,
				a.GEAhorafin,

				a.TESid,
				a.Ecodigo,
				a.GEAnumero,
				a.GEAtipo,
				a.TESSPid,
				a.CCHid,
				a.GEAestado,
				a.Mcodigo as McodigoOri, a.Mcodigo, m.Miso4217,
				a.GEAmanual,
				a.GEAtotalOri,
				a.UsucodigoSolicitud,
				a.GEAidDuplicado,
				a.CFcuenta,
				a.BMUsucodigo,
				a.ts_rversion,
				a.GEAmsgRechazo,
				a.GEAtipoP,
				a.GEAviatico,
				a.GEAtipoviatico
				
		  from GEanticipo a	
		  	inner join Monedas m
				on m.Mcodigo = a.Mcodigo
		  	left join GEcomision b
				on b.GECid = a.GECid
		 where a.Ecodigo		= #session.Ecodigo#
		   and a.GEAid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
		   and a.GEAtipo		=#LvarTipoDocumento#
	</cfquery>
	<cfif rsForm.GEAtipoP EQ 1 and rsForm.CCHid eq "">
		<cfset VCCHid=0>
	<cfelse>
		<cfset VCCHid=#rsForm.CCHid#>
	</cfif>
	
	<cfset form.GECid_comision = rsForm.GECid_comision>
</cfif>

<cfset modoC = modo>
<cfif LvarSAporComision and modo EQ "ALTA">
	<cfif isdefined('url.GECid_comision') and not isdefined('form.GECid_comision')>
		<cfparam name="form.GECid_comision" default="#url.GECid_comision#">
	</cfif>
	
	<cfif isdefined('form.GECid_comision') and len(trim(form.GECid_comision))>
		<cfset modoC = 'CAMBIO'>
	</cfif>
</cfif>

<cfif modoC NEQ 'ALTA' AND modo EQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsForm">
		select
				GECobservaciones, GECobservacionesArrend, 
				GECtipo, GECusaTCE, 
				GECdestino, GECDid,
				GECestado,
				GECid, GECnumero, GECfechaSolicitud, 
				GECautomovil, GEChotel, GECavion,GEInternet,

				TESBid,
				CFid,
				GECdescripcion as GEAdescripcion,
				GECfechaPagar as GEAfechaPagar,
				coalesce(GECdesde, GECdesdePlan) as GEAdesde,
				coalesce(GEChasta, GEChastaPlan) as GEAhasta,
				GEChoraini as GEAhoraini,
				GEChorafin as GEAhorafin,

				TESid,
				Ecodigo,
				BMUsucodigo,
				0 as GEATOTALORI,
				ts_rversion
		  from GEcomision
		 where Ecodigo		= #session.Ecodigo#
		   and GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECid_comision#">
	</cfquery>
</cfif>

<cfif modoC NEQ 'ALTA'>
	<cf_cboCFid query="#rsForm#" soloInicializar="true">	
	<cfquery datasource="#session.dsn#" name="Benef">
		select 	DEid as emple 
		from TESbeneficiario 
		where TESBid=<cfqueryparam cfsqltype="cf_sql_numeric" value= "#rsForm.TESBid#">
	</cfquery>
	<!--- Querry que determina si el Usuario es Aprobador de Tesoria--->
	<cfquery name="rsSPaprobador" datasource="#session.dsn#">
		Select TESUSPmontoMax, TESUSPcambiarTES
		from TESusuarioSP
		where CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
		and Usucodigo	= #session.Usucodigo#
		and TESUSPaprobador = 1
	</cfquery>
	<cfset LvarEsAprobadorSP = (rsSPaprobador.RecordCount GT 0) AND NOT LvarSAporComision>
	<!--- Querry que determina si el Usuario es Aprobador de Tesoria--->
</cfif>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select 	<cf_dbfunction name="to_char" args="Mcodigo"> as Mcodigo 
	from Empresas
	where Ecodigo = #session.Ecodigo# 	
</cfquery>


<!---AJAX--->
<script language="javascript" type="text/javascript">
<!-- 
//Browser Support Code
	<!---function ajaxFunction_ComboConcepto(){
			var ajaxRequest;  // The variable that makes Ajax possible!
			var vID_tipo_gasto ='';
			var vmodoD ='';
			vID_tipo_gasto = document.form1.Tipo.value;
			vmodoD = document.form1.modo.value;
		try{
		// Opera 8.0+, Firefox, Safari
			ajaxRequest = new XMLHttpRequest();
		} 
		catch (e){
		// Internet Explorer Browsers
			try{
				ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
			} 
			catch (e) {
				try{
					ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
				} 
				catch (e){
					// Something went wrong
					alert("Your browser broke!");
					return false;
				}
			}	
		}		
		<cfif  modo NEQ 'ALTA'>
			<cfset LvarGEAid = "GEAid=#form.GEAid#&">
		<cfelse>
			<cfset LvarGEAid = "">
		</cfif>
		ajaxRequest.open("GET", '/cfmx/sif/tesoreria/GestionEmpleados/ComboConcepto.cfm?#LvarGEAid#GETid='+vID_tipo_gasto+'&modoD='+vmodoD, false);
		ajaxRequest.send(null);
		<!---alert(ajaxRequest.responseText);--->
		document.getElementById("contenedor_Concepto").innerHTML = ajaxRequest.responseText;
		<!---appendChild(ComboConcepto.cfm)--->
	}		--->
//-->

	
	
	function fnAjxCargarFormaPago(){
		<cfif modo NEQ 'ALTA'>
		var ajaxRequest1;  // The variable that makes Ajax possible!
		var LvarCFid		= document.form1.CFid.value;
		var LvarMcodigoOri	= document.form1.McodigoOri.value;
		var LvarCCHid		= document.form1.CCHid.value;
	/*	vmodoD1 		= document.modo.value;*/
		try{
			// Opera 8.0+, Firefox, Safari
			ajaxRequest1 = new XMLHttpRequest();
		} catch (e){
			// Internet Explorer Browsers
			try{
				ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try{
					ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e){
					// Something went wrong
					alert("Your browser broke!");
					return false;
				}
			}
		}

		ajaxRequest1.open("GET", '/cfmx/sif/tesoreria/GestionEmpleados/ComboFormaPago.cfm?CFid='+LvarCFid+'&McodigoOri='+LvarMcodigoOri+'&CCHid='+LvarCCHid, false);
		ajaxRequest1.send(null);
		document.getElementById("contenedor_ComboFormaPago").innerHTML = ajaxRequest1.responseText;
		</cfif>
	}

</script>

<cfoutput>
	<form action="solicitudesAnticipo_sql.cfm?tipo=#LvarSAporEmpleadoSQL#" onSubmit="return validar(this);" method="post" name="form1" id="form1" style=" margin: 0;">
    <!---<input type="hidden" name="CxC_Anticipo" value="#CxC_Anticipo.CFcuenta#" id="CxC_Anticipo" />--->
		<input name="modo" type="hidden" value="#modo#" />
		<table width="100%" align="center" summary="Tabla de entrada" border="0">
		<!--- IZQUIERDA --->
		<tr><td valign="top"><table border="0" width="100%" style="border-collapse:collapse">
		<!---solicitud--->		
		<cfif LvarSAporComision>
			<tr>
				<td  align="right" valign="top" ><strong><cf_translate key=LB_Numcomision>Num. Comisión</cf_translate>:&nbsp;</strong></td>
				<td  align="left" valign="top" nowrap="nowrap">
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td  align="left" valign="top" nowrap="nowrap">
							<cfif modoC NEQ 'ALTA'>
								<input type="hidden" name="GECid_comision" value="#Form.GECid_comision#" />
								#rsForm.GECnumero#
								<input type="hidden" name="GECnumero" value="#rsForm.GECnumero#" />
							<cfelse>
								<input type="hidden" name="GECid_comision" value="0" />
								&nbsp;&nbsp; -- <cf_translate key=LB_NuevaComisionViaticos>Nueva Comisión de Viáticos</cf_translate> --
							</cfif>
						</td>
						<!---Fecha Solicitud--->
						<td  align="right" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>:&nbsp;&nbsp;</strong>
							<cfif modoC NEQ 'ALTA'>
								#LSDateFormat(rsForm.GECfechaSolicitud,"DD/MM/YYYY")#
							<cfelse>
								#LSDateFormat(now(),"DD/MM/YYYY")#
							</cfif>
						</td>
					</tr></table>
				</td>			
			</tr>
		<cfelse>
			#fnNumeroSolicitud()#				
		</cfif>
			<!---Empleado--->
			<tr>
				<td align="right"><strong><cf_translate key=LB_Empleado>Empleado</cf_translate>:&nbsp;</strong></td>
				<td valign="top" nowrap="nowrap">
					<cfif modoC NEQ 'ALTA'>
		  <cfif isdefined("LvarSAporEmpleado") OR rsForm.GEAtotalOri NEQ 0>
							<cfset LvarModificable = 'N'>
						<cfelse>
							<cfset LvarModificable = 'S'>
						</cfif>	
							<cfset LvarDEid = Benef.emple>
					<cfelse>
						<cfif isdefined("LvarSAporEmpleado")>
							<cfquery name="rsSQL" datasource="#session.dsn#">
								select llave as DEid
								from UsuarioReferencia
								where Usucodigo= #session.Usucodigo#
								and Ecodigo	= #session.EcodigoSDC#
								and STabla	= 'DatosEmpleado'
							</cfquery>
							<cfif rsSQL.recordCount EQ 0>
								<cf_errorCode	code = "50740" msg = "<cf_translate key=LB_EmpleadoNoRegistrado>El usuario no ha sido registrado como Empleado de la Empresa</cf_translate">
							</cfif>
							
							<cfset LvarDEid = rsSQL.DEid>
							<cfset LvarModificable = 'N'>
							
						<cfelse>
							<cfset LvarDEid = "">
							<cfset LvarModificable = 'S'>
						</cfif>
					</cfif>
				
					<cf_conlis title="#LB_ListaEmpleados#"
					campos = "DEid, DEidentificacion, DEnombreTodo" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,15,34"
					asignar="DEid, DEidentificacion, DEnombreTodo"
					asignarformatos="S,S,S"
					tabla="DatosEmpleado"
					columnas="DEid, DEidentificacion, DEnombre #LvarCNCT#' '#LvarCNCT# DEapellido1 #LvarCNCT#' '#LvarCNCT# DEapellido2 as DEnombreTodo,DEnombre,DEapellido1,DEapellido2"
					filtro="Ecodigo = #Session.Ecodigo#"
					desplegar="DEidentificacion, DEnombre,DEapellido1,DEapellido2"
					etiquetas="#LB_Identificacion#,#LB_Nombre#,#LB_ApellidoPaterno#,#LB_ApellidoMaterno#"
					formatos="S,S,S,S"
					align="left,left,left,left"
					showEmptyListMsg="true"
					EmptyListMsg=""
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="DEidentificacion,DEnombre,DEapellido1,DEapellido2"
					index="1"			
					traerInicial="#LvarDEID NEQ ''#"
					traerFiltro="DEid=#LvarDEid#"
					readonly="#LvarModificable EQ 'N'#"
					funcion="funcCambiaDEid"
					fparams="DEid"
					/>        
				  <script language="javascript">
						var GvarDEid = '#LvarDEid#';
							function funcCambiaDEid(DEid)
							{
								if (GvarDEid != DEid)
								{
									GvarDEid = DEid;
									document.form1.CFid.value = '';
									document.form1.CFcodigo.value='';
									document.form1.CFdescripcion.value='';
								}
							}
					</script>
				</td>
			</tr>
			
			<!---Centro Funcional--->
			<tr>
				<td align="right"><strong><cf_translate key=LB_CentroFuncional>Centro&nbsp;Funcional</cf_translate>:&nbsp;</strong></td>
				<td align="left">
	    <cfif isdefined("LvarSAporEmpleado")>
						<cfset LvarUsuCodigos = "= #session.Usucodigo#">
					<cfelse>
						<cfset LvarUsuCodigos = "in (#session.Usucodigo#,
							(
								select Usucodigo
								from UsuarioReferencia
								where llave = $DEid,varchar$
								and Ecodigo = #session.EcodigoSDC#
								and STabla = 'DatosEmpleado'
							)
						)">
					</cfif>
					<cfset valuesArraySN = ArrayNew(1)>
					<cfif isdefined("rsForm.CFid") and len(trim(rsForm.CFid))>
						<cfquery datasource="#Session.DSN#" name="rsSN">
							select 
							CFid,
							CFcodigo,
							CFdescripcion
							from CFuncional			
							where Ecodigo = #session.Ecodigo#
							and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
						</cfquery>
						
						<cfset ArrayAppend(valuesArraySN, rsSN.CFid)>
						<cfset ArrayAppend(valuesArraySN, rsSN.CFcodigo)>
						<cfset ArrayAppend(valuesArraySN, rsSN.CFdescripcion)>
						
					</cfif>   
					<cf_conlis
						Campos="CFid,CFcodigo,CFdescripcion"
						valuesArray="#valuesArraySN#"
						Desplegables="N,S,S"
						Modificables="N,S,N"
						Size="0,10,40"
						tabindex="5"
						Title="#LB_ListaCentroFuncional#"
						Tabla="CFuncional cf 
						inner join Oficinas o 
						on o.Ecodigo=cf.Ecodigo 
						and o.Ocodigo=cf.Ocodigo
						inner join TESusuarioSP tu
						on tu.CFid                 = cf.CFid
						
						and tu.Ecodigo            = #session.Ecodigo#
						and tu.TESUSPsolicitante = 1"
						Columnas="distinct cf.CFid,cf.CFcodigo,cf.CFdescripcion #LvarCNCT# ' (Oficina: ' #LvarCNCT# rtrim(o.Oficodigo) #LvarCNCT# ')' as CFdescripcion"
						Filtro=" cf.Ecodigo = #Session.Ecodigo#  and tu.Usucodigo        #LvarUsuCodigos# order by cf.CFcodigo"
						Desplegar="CFcodigo,CFdescripcion"
						Etiquetas="#LB_Codigo#,#LB_Descripcion#"
						filtrar_por="cf.CFcodigo,CFdescripcion"
						Formatos="S,S"
						Align="left,left"
						form="form1"
						Asignar="CFid,CFcodigo,CFdescripcion"
						Asignarformatos="S,S,S,S"
						funcion="fnAjxCargarFormaPago()"
						funcionValorEnBlanco="fnAjxCargarFormaPago()"
						onblur="this.value=this.value.toUpperCase();"
					/> 
				</td>
	  <cfif  modo NEQ 'ALTA'>
					<cfset LvarCFid=#CFid#>
				</cfif>
			</tr>
			
		<cfif LvarSAporComision>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3" style="border-top:solid 1px ##CCCCCC">&nbsp;</td>
				<td style="border-top:solid 1px ##CCCCCC">&nbsp;</td>
				<td rowspan="20" style="border-left:solid 1px ##CCCCCC">&nbsp;</td>
			</tr>
			#fnNumeroSolicitud()#				
		</cfif>
			<!---Moneda--->
			<tr>
				<td valign="top" align="right"><strong><cf_translate key=LB_Moneda>Moneda</cf_translate>:&nbsp;</strong></td>
				<td valign="top">
					<cfif  modo NEQ 'ALTA'>
						<cfquery name="rsMoneda" datasource="#session.DSN#">
							select 
									Mcodigo
									, Mnombre
							from Monedas
							where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.McodigoOri#">
							and Ecodigo=#session.Ecodigo#
						</cfquery>
						
						<cfset LvarMnombreSP = rsMoneda.Mnombre>
						
						<cfif rsForm.GEAtotalOri GT 0>
							<cf_sifmonedas onChange="fnAjxCargarFormaPago();asignaTC();" valueTC="#rsForm.GEAmanual#" form="form1" Mcodigo="McodigoOri" query="#rsMoneda#" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1" habilita="S">
						<cfelse>
							<cf_sifmonedas onChange="fnAjxCargarFormaPago();asignaTC();" valueTC="#rsForm.GEAmanual#" form="form1" Mcodigo="McodigoOri" query="#rsMoneda#" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1">
						</cfif>
					<cfelse>
						<cf_sifmonedas onChange="fnAjxCargarFormaPago();asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" form="form1" Mcodigo="McodigoOri"  tabindex="1">
					</cfif>   
				</td>
			</tr>
			
			<!---Tipo de cambio--->

			<tr>
				<td valign="top" align="right"><strong><cf_translate key=LB_TipoCambio>Tipo de Cambio</cf_translate>:&nbsp;</strong></td>
				<td valign="top">
					<input name="GEAmanual" 
						id="GEAmanual"
						maxlength="10" disabled="S"
						value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.GEAmanual,",0.00")#</cfif>"
						style="text-align:right;" 
						onfocus="this.value=qf(this); this.select();" 
						tabindex="1" />
				</td>
			</tr>	
			<!---Total de pago solicitado--->
			<tr>
				<td align="right" valign="top" nowrap><strong><cf_translate key=LB_TotalPagoSolicitado>Total Pago Solicitado</cf_translate>:&nbsp;</strong></td>
				<td valign="top" nowrap="nowrap" align="left">
					<input type="text"
						name="GEAtotalOri" readonly
						id="GEAtotalOri"
						value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.GEAtotalOri,",0.00")#<cfelse>0.00</cfif>"
						style="text-align:right; border:solid 1px ##CCCCCC;"
						tabindex="-1"/> 
				</td>
			</tr>
            
			<cfset fnFormaPago()>
            
		<!--- Tipo-Gasto--->

		<cfif modo eq 'ALTA' AND NOT LvarConPlanCompras>
			<tr>
				<td width="33%" align="right" nowrap="nowrap" ><strong><cf_translate key=LB_TipoGasto>Tipo Gasto</cf_translate>: </strong> </td>
				<td width="67%" colspan="8" align="left" nowrap="nowrap">
					<select name="Tipo" size="0" onchange="LimpiaConcepto();">  
						<cfif rsID_tipo_gasto.RecordCount>
							<cfloop query="rsID_tipo_gasto">
								<option value="#rsID_tipo_gasto.GETid#"<cfif modo neq "ALTA" and rsID_tipo_gasto.GETid  eq rsID_tipo_gasto.GETid>selected="selected"</cfif>>#rsID_tipo_gasto.GETdescripcion#</option>
							</cfloop>
						</cfif>
				  </select>
			  	</td>
			
			</tr>
			
			<!---Concepto_gasto--->
			<tr>
				<td nowrap="nowrap" align="right"><strong><cf_translate key=LB_ConceptoGasto>Concepto de Gasto</cf_translate>:</strong> </td>
				<td colspan="8" nowrap="nowrap" align="left">
					<div id="contenedor_Concepto">
						 <cf_conlis      
                                campos = "Concepto,GECdescripcion"
                                desplegables = "N,S"
                                modificables = "N,N"
                                size = "4,20"
                                title="Conceptos de Gastos"
                                tabla="GEconceptoGasto c
                            inner join GEtipoGasto t
                                  on  c.GETid = t.GETid"                                       
                                columnas=" c.GECdescripcion,
                                           c.GECid as Concepto,
                                           c.GETid,
                                           c.GECcomplemento"               
                                filtro="Ecodigo = #session.Ecodigo#
                                        and c.GETid = $Tipo,numeric$"                                                           
                                desplegar="GECdescripcion"
                                etiquetas=""
                                formatos="S"
                                align="left,left"
                                asignar="Concepto,GECdescripcion"
                                showEmptyListMsg="true"
                                EmptyListMsg="-- No existen Conceptos para el Tipo de Gasto --"
                                tabindex="3"
                                top="100"
                                left="200"
                                width="300"
                                height="200"
                                asignarformatos="S"> 
                  </div>
				</td>
			</tr>
			<!--- Actividad Empresarial --->
            <cfquery name="rsActividad" datasource="#session.DSN#">
                Select Coalesce(Pvalor,'N') as Pvalor 
                  from Parametros 
                 where Pcodigo = 2200 
                   and Mcodigo = 'CG'
                   and Ecodigo = #session.Ecodigo# 
            </cfquery>
            <cfif rsActividad.Pvalor eq 'S'<!--- and rsFormularPor.Pvalor eq 0--->>
                <cfset idActividad = "">
                <cfset valores = "">
                <cfset lvarReadonly = false>
            <cfif modo NEQ "ALTA">
                    <cfset idActividad = rsFormAntD.FPAEid>
                    <cfset valores = rsFormAntD.CFComplemento>
                    <cfset lvarReadonly = true>
                </cfif>
                <tr>
                <td valign="top" align="right"><strong><cf_translate key=ActividadEmpresarial>Actividad Empresarial</cf_translate>:&nbsp;</strong></td>
                <td valign="top"><cf_ActividadEmpresa etiqueta="" idActividad="#idActividad#" valores="#valores#" name="CFComplemento" nameId="FPAEid" formname="form1" Readonly="#lvarReadonly#"></td>
                </tr>
            </cfif>	
			<!---Monto--->			
			<tr>
				<td nowrap="nowrap" align="right"><strong><cf_translate key=LB_Monto>Monto</cf_translate>:</strong> </td>
				<td>
					<cfset valor_monto = 0 >
		  <cfif modo neq 'ALTA'>
						<cfset valor_monto = LSNumberFormat(abs(rsFormAntD.GEADmonto),"0.00") >
					</cfif>
					<cf_inputNumber name="MontoDetA" value="#valor_monto#" size="15" enteros="13" decimales="2" onChange="verificaConcep(this.value)">
				</td>
			</tr>
		<cfelse>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		</cfif>	
			<!---Rechazo--->
			<tr>
				<td valign="top" nowrap align="right">
			<cfif modo NEQ "ALTA">
						<cfif #rsForm.GEAestado# EQ 3>
							<strong>Motivo Cancelacion:&nbsp;</strong>
						<cfelseif #rsForm.GEAestado# eq 23>
							<strong>Motivo Rechazo Anterior:&nbsp;</strong>
						</cfif>
				</td>
				<td colspan="4" valign="top">
					<font style="color:##FF0000; font-weight:bold;">
					<cfquery datasource="#session.dsn#" name="Cancela">
						select TESSPmsgRechazo 
						from TESsolicitudPago a
							inner join GEanticipo b
								on a.TESSPid=b.TESSPid
						where b.GEAid=#rsForm.GEAid#
					</cfquery>
					#rsForm.GEAmsgRechazo#
					#Cancela.TESSPmsgRechazo#
					</font>
				</td>
			</cfif>
				
			</tr>
		</table></td>
		<!--- DERECHA --->
		<td valign="top"><table>
			<tr>
				<!---Observaciones--->
				<td  ><p align="right"><strong>&nbsp;<cf_translate key=LB_Descripcion>Descripción:&nbsp;</cf_translate></p></td>
				<td  valign="top" >
					<input type="text" name="GEAdescripcion" maxlength="35" size="44" id="GEAdescripcion" tabindex= "0" style="border-spacing:inherit" value="<cfif modoC NEQ 'ALTA'>#trim(rsForm.GEAdescripcion)#</cfif>" />
					<cfset LvarModificable = (modo EQ 'ALTA' OR rsForm.GEAtotalOri EQ 0)>
				</td>
			</tr>
			
			<tr>
				<!---Fecha de pago solicitado--->
				<td align="right"><strong><cf_translate key=LB_FechaPago>Fecha Pago</cf_translate>:&nbsp;</strong></td>
				<td valign="top" nowrap="nowrap" align="left">
					<cfset fechadoc = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cfif modoC NEQ 'ALTA'>
							<cfset fechadoc = LSDateFormat(rsForm.GEAfechaPagar,'dd/mm/yyyy') >
						</cfif>
						<cf_sifcalendario form="form1" value="#fechadoc#" name="GEAfechaPagar" tabindex="1">
					<input type="hidden" name="Documento"  			value="<cfif modo eq 'Cambio'>#rsForm.GEAtipo#</cfif>" id="Documento" />
				</td>
			</tr>
			
			<tr>
				<!---Fechas--->
				<td align="right"><strong><cf_translate key=LB_Fecha>Fechas</cf_translate>:</strong></td>
				<td>
					<table border="0">
						<tr>
							<td><cf_translate key=LB_Desde>Desde</cf_translate>:</td> 
								<cfset fechadesde=DateFormat(Now(),'DD/MM/YYYY')>
								<cfif modoC NEQ 'ALTA'>
									<cfset fechadesde = DateFormat(rsForm.GEAdesde,'DD/MM/YYYY') >
								</cfif>
							<td><cf_sifcalendario form="form1" value="#fechadesde#" name="GEAdesde" tabindex="1"></td> 
							
							<td ><cf_translate key=LB_Hasta>Hasta</cf_translate>:</td>
								<cfset fechahasta=DateFormat(Now(),'DD/MM/YYYY')>
								<cfif modoC NEQ 'ALTA'>
									<cfset fechahasta = DateFormat(rsForm.GEAhasta,'DD/MM/YYYY') >
								</cfif>
							<td><cf_sifcalendario form="form1" value="#fechahasta#" name="GEAhasta" tabindex="1"></td>	
						</tr>	
					</table>
				</td>		
			</tr>
			
			<tr>
				<!---Horas--->
				<td align="right"><strong><cf_translate key=LB_Horas>Horas</cf_translate>:</strong></td>
				<td>
					<table border="0">
						<tr>
							<td><cf_translate key=LB_Inicio>Inicio</cf_translate>:&nbsp;&nbsp;</td> 
							<td>
							<cfset GEAhoraini='00:00'>
								<cfif modoC NEQ 'ALTA'>
									<cfset GEAhoraini = #rsForm.GEAhoraini# >
								</cfif>
								<cf_hora name="GEAhoraini" form="form1" value="#GEAhoraini#">
							</td> 
							<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							Final:</td>
							<td>
							<cfset GEAhorafin='00:00'>
								<cfif modoC NEQ 'ALTA'>
									<cfset GEAhorafin = #rsForm.GEAhorafin# >
								</cfif>
								<cf_hora name="GEAhorafin" form="form1" value="#GEAhorafin#">
							</td>	
						</tr>	
					</table>
				</td>		
			</tr>	
		<cfif LvarSAporComision>
			<tr>
				<!--- Nacional o Extranjero --->
				<td align="right" valign="top" nowrap><strong><cf_translate key=LB_Tipo>Tipo</cf_translate>:</strong></td>
				<td nowrap="nowrap" align="left" valign="top" >	
					<select name="GECtipo">
						<option value="1" <cfif modoC NEQ "ALTA" AND rsForm.GECtipo EQ 1>selected</cfif>><cf_translate key=LB_Nacional>Nacional</cf_translate></option>
						<option value="2" <cfif modoC NEQ "ALTA" AND rsForm.GECtipo EQ 2>selected</cfif>><cf_translate key=LB_Exterior>Exterior</cf_translate></option>
					</select>
					&nbsp;&nbsp;
					<strong><cf_translate key=LB_UtilizaTCE>Utiliza TCE</cf_translate>:</strong>
					<cfparam name="rsForm.GECusaTCE"		default="0">
					<input type="checkbox" name="GECusaTCE" <cfif rsForm.GECusaTCE EQ "1">checked</cfif> value="1"/>
				</td>	
			</tr>
			<tr>
				<!---Adicionales--->
				<td align="right" valign="top" nowrap></td>
				<td nowrap="nowrap" align="left" valign="top" >	
					<strong><cf_translate key=LB_Auto>Automóvil</cf_translate>:</strong>
					<cfparam name="rsForm.GECautomovil"	default="0">
					<cfparam name="rsForm.GEChotel"		default="0">
					<cfparam name="rsForm.GECavion"		default="0">
                     <cfparam name="rsForm.GEInternet"	default="0">
					<input type="checkbox" name="GECautomovil" <cfif rsForm.GECautomovil EQ "1">checked</cfif> value="1"/>
					&nbsp;&nbsp;&nbsp;<strong>Hotel:</strong>
					<input type="checkbox" name="GEChotel" <cfif rsForm.GEChotel EQ "1">checked</cfif> value="1"/>
					&nbsp;&nbsp;&nbsp;<strong><cf_translate key=LB_Avion>Avión</cf_translate>:</strong>
					<input type="checkbox" name="GECavion" <cfif rsForm.GECavion EQ "1">checked</cfif> value="1"/>
                    &nbsp;&nbsp;&nbsp;<strong><cf_translate key=LB_PaqDatosMov>Paquete de Datos Moviles</cf_translate>:</strong>
                    <input type="checkbox" name="GEInternet" <cfif rsForm.GEInternet EQ "1">checked</cfif> value="1"/>
					<input type="checkbox" id="GEAviatico" name="GEAviatico" style="display:none" />
					<input type="radio"  name="GEAtipoviatico" id="GEAtipoviatico1" style="display:none" />
					<input type="radio"  name="GEAtipoviatico" id="GEAtipoviatico2" style="display:none" />
				</td>	
			</tr>
			<tr>
				<!---Destino--->
				<td align="right" valign="top" nowrap="nowrap">
					<strong><cf_translate key=LB_Destino>Destino</cf_translate>:&nbsp;</strong>
				</td>
				<td align="left" valign="top" nowrap="nowrap">
					<input type="text" name="GECdestino" maxlength="50" size="25" id="GECdestino" tabindex= "0" style="border-spacing:inherit" value="<cfif modoC NEQ 'ALTA'>#trim(rsForm.GECdestino)#</cfif>" />
					<select name="GECDid" name="GECDid" style="width:150px">
                        <option value="">(<cf_translate key=LB_CategoriaDestino>Categoría Destino</cf_translate>)</option>
						<cfif rsCategoriasDestino.recordcount>
							<cfloop query="rsCategoriasDestino">
                                <option value="#rsCategoriasDestino.GECDid#"<cfif modoC neq "ALTA" and rsCategoriasDestino.GECDid  eq rsForm.GECDid>selected="selected"</cfif>>#rsCategoriasDestino.GECDdescripcion#</option>
                            </cfloop>
                        </cfif>                                                    
					</select>
				</td>
			</tr>
			<tr>
				<!---Observaciones--->
				<td align="right" valign="top" nowrap="nowrap">
					<strong><cf_translate key=LB_Observaciones>Observaciones</cf_translate>:&nbsp;</strong>
				</td>
				<td align="right" valign="top" nowrap="nowrap">
					<textarea name="GECobservaciones" cols="50" rows="2"><cfif modoC NEQ "ALTA">#rsForm.GECobservaciones#</cfif></textarea>
				</td>
			</tr>
			<tr>
				<!---Arrendamiento--->
				<td align="right" valign="top" nowrap="nowrap">
					<strong><cf_translate key=LB_Arrendamiento>Arrendamiento</cf_translate>:&nbsp;</strong>
				</td>
				<td align="right" valign="top" nowrap="nowrap">
					<textarea name="GECobservacionesArrend" cols="50" rows="2"><cfif modoC NEQ "ALTA">#rsForm.GECobservacionesArrend#</cfif></textarea>
				</td>
			</tr>
			<tr>
				<!---Itinerario--->
				<td align="left" valign="top" nowrap="nowrap">&nbsp;
					
				</td>
				<td align="left" valign="top" nowrap="nowrap">
                <cfif modoC NEQ "ALTA">
					<input type="button" value="#BTN_Itinerario#" name="Itinerario" onclick="funcItinerario();" />
                </cfif>    
				</td>
			</tr>
		<cfelse>
			<tr>
				<!---Si es Viatico--->
				<td align="right" valign="top" nowrap><strong><cf_translate key=LB_Viatico>Vi&aacute;tico</cf_translate>:&nbsp;</strong></td>
				<td>
					<input type="checkbox" id="GEAviatico" name="GEAviatico" tabindex="1" onchange="cambiaUsoCuenta();"     <cfif modo NEQ "ALTA" and #rsForm.GEAviatico# EQ 1>checked="checked" disabled="disabled" </cfif>  value="1"  />
				</td>
			</tr>
			<tr>
				<!---Tipo de Viatico--->
				<td align="right"><strong><cf_translate key=LB_Tipo>Tipo</cf_translate>:&nbsp;</strong></td>
				<td nowrap="nowrap" align="left">		
					<input type="radio"  disabled="disabled" name="GEAtipoviatico" id="GEAtipoviatico1" value="1" tabindex="1" <cfif modo neq "ALTA" and #rsForm.GEAtipoviatico# EQ 1> checked=" checked " </cfif>checked >
						<label for="tipoResumen1" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key=LB_Nacional>Nacional</cf_translate></label>
					 <input type="radio"  disabled="disabled" name="GEAtipoviatico" id="GEAtipoviatico2" value="2"  tabindex="1"<cfif modo neq "ALTA" and #rsForm.GEAtipoviatico# EQ 2>  checked="checked"  </cfif> >
						<label for="tipoResumen2" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key=LB_Exterior>Exterior</cf_translate></label>					
				</td>	
			</tr>
		</cfif>
		</table></td></tr>
			<cfif isdefined ("rsForm.GEAviatico") and rsForm.GEAviatico EQ 1>
			<tr> 
				<td colspan="5" class="formButtons" align="center">
					<input name="LvarSAporEmpleadoCFM" id="LvarSAporEmpleadoCFM" value="#LvarSAporEmpleadoCFM#" type="hidden" />
					<cf_botones modo="#modo#" includevalues="#btnValueCalcular#,#btnValueTC#" align="center"  	include="#btnNameCalcular#,#btnNameTC#" exclude="#btnExcluirAbajo#">
				</td>
			</tr>	
	    </cfif>

			<!---Botones--->
			<tr>
				<td colspan="5" class="formButtons" align="center">
					<cfif modo NEQ 'ALTA'>
						<input type="hidden" name="GEAid" value="#HTMLEditFormat(rsForm.GEAid)#" />
						<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm.BMUsucodigo)#" />
						<cfset ts = "">
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts"> </cfinvoke>
						<input type="hidden" name="ts_rvesion" value="#ts#" />
			    </cfif>

				 <!---	<cfinclude template="../Solicitudes/TESbtn_Aprobar.cfm">--->
                   <cfif (isdefined ("rsForm.GECestado") and rsForm.GECestado NEQ 6 and (modo NEQ 'ALTA' or modo EQ 'ALTA')) or 
						 (not isdefined ("rsForm.GECestado") and (modo NEQ 'ALTA' or modo EQ 'ALTA'))>
                          <cfinclude template="GEbtn_soliAnti.cfm">
					</cfif>
				</td>
			</tr>
		</table>
	</form>		  

<iframe name="verifica_Concepto" id="verifC" marginheight="0" marginwidth="0" frameborder="" height="0" width="0" scrolling="auto"></iframe>

<script language="javascript">
	function verificaConcep(monto){
		var Cid= document.form1.Concepto.value
		var tc=document.form1.GEAmanual.value
		
		document.getElementById('verifC').src = 'verificaConcepto.cfm?Concepto='+Cid+'&monto='+monto+'&dir='+1+'&tc='+tc+'';
	}
</script>
	<!---ValidacionesFormulario--->
	
	<script type="text/javascript">
	var LvarCambiado = false;
	<!--

function cambiaUsoCuenta(){
	if(document.form1.GEAviatico.checked) 
	{
	//	document.getElementById("trDatosCuenta").style.display = '';
		 SiViatico ();
	}
	else
	{
	//	document.getElementById("trDatosCuenta").style.display = 'none';
	}
}


	
	function SiViatico ()
	{
		var estado=document.form1.GEAviatico.checked;
		
		
		if(!estado){
			disabled="disabled";
			document.form1.GEAtipoviatico1.disabled=disabled;
			document.form1.GEAtipoviatico2.disabled=disabled;
		}else{
			var disabled="";
			document.form1.GEAtipoviatico1.disabled=disabled;
			document.form1.GEAtipoviatico2.disabled=disabled;
		}
	
	}
	
	function fnFechaYYYYMMDD (LvarFecha)
	{
		return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
	}

	function validar(formulario)
	{
		if (btnSelected('Nuevo',formulario) || btnSelected('Baja',formulario) || btnSelected('IrLista',formulario))
		  return true;

		var error_input;
		var error_msg = '';
		
		if (fnFechaYYYYMMDD(formulario.GEAdesde.value) > fnFechaYYYYMMDD(formulario.GEAhasta.value))
			{
				alert ("La Fecha de Inicio debe ser menor a la Fecha Final");
				return false;
			}		
	<cfif modo NEQ 'ALTA' and LvarEsAprobadorSP>
		if (btnSelected('Aprobar',formulario)) 
		{
			if (formulario.FormaPago.value == "") 
			{
				alert("Debe seleccionar una forma de Pago");
				return false;
			}
			if (formulario.McodigoOri.value == "") 
			{
				alert("Debe seleccionar una Moneda");
				return false;
			}
			if (formulario.McodigoOri.value != '#rsForm.McodigoOri#')
			{
				alert("Se modifico la Moneda primero debe presionar <Modificar>");
				return false;
			}
			if (formulario.FormaPago.value != '#VCCHid#')
			{
				alert("Se modifico la Forma de Pago primero debe presionar <Modificar>");
				return false;
			}
		}
	</cfif>
		
		if (formulario.DEid.value == "") {
			error_msg += "\n - #LB_DescEmpleado#";
			error_input = formulario.DEid;
		}	
		if (formulario.GEAfechaPagar.value == "") {
			error_msg += "\n - La Fecha a Pagar no puede quedar en blanco.";
			error_input = formulario.TESSPfechaPagar;
		}		
		if (formulario.McodigoOri.value == "") {
			error_msg += "\n - La Moneda no puede quedar en blanco.";
			error_input = formulario.McodigoOri;
		}			
		if (formulario.GEAtotalOri.value == "") {<!---RVD Verificar--->
			error_msg += "\n - El Monto Total a Pagar no puede quedar en blanco.";
			error_input = formulario.GEAtotalOri;
		}
		

		if (formulario.GEAdescripcion.value == "") {
			error_msg += "\n - #LB_CampoDescripcion#.";
			error_input = formulario.GEAdescripcion;
		}	
		if (formulario.GEAdesde.value == "") {
			error_msg += "\n - La Fecha Desde no puede quedar en blanco.";
			error_input = formulario.GEAdesde;
		}	
		if (formulario.GEAhasta.value == "") {
			error_msg += "\n - La Fecha Hasta no puede quedar en blanco.";
			error_input = formulario.GEAhasta;
		}					
		
		if (formulario.GECdestino && formulario.GECdestino.value == "") {
			error_msg += "\n - #LB_CampoDestino#.";
			error_input = formulario.GECdestino;
		}	
		
		if (formulario.CFid.value == "") {
			error_msg += "\n - #LB_CampoCentroFuncional#.";
			error_input = formulario.CFid;
		}				
		<!---if (formulario.CxC_Anticipo.value == "") {
			error_msg += "\n - La Cuenta Financiera no a sido configurada, para configurarla valla a Parametrizacion de Tesorera,Parmetros de gastos de Empleado.";
			error_input = formulario.CxC_Anticipo;
		}--->
	<cfif modo eq 'Alta'>
		if ((formulario.botonSel.value != "AltaC") && (formulario.botonSel.value != "CambioC") && (formulario.botonSel.value != "CancelarC") && (formulario.botonSel.value != "ImprimirC" && formulario.botonSel.value != "FinalizarC"))
		{
			if (formulario.MontoDetA.value == "") {
				error_msg += "\n - El Monto del anticipo no puede ir en blanco.";
				error_input = formulario.MontoDetA;
			}	
			else if (parseFloat(formulario.MontoDetA.value) = 0)
			{
				error_msg += "\n - #LB_CampoMontoSolicitado#.";
				if (error_input == null) error_input = formulario.MontoDetA;
			}
			formulario.MontoDetA.value = qf(formulario.MontoDetA);
		}
		else if (formulario.botonSel.value == "CancelarC")
		{
			if (! confirm('Confirme que la Comisión no se realizó'))
				return false;
		}
		else if (formulario.botonSel.value == "FinalizarC")
		{
			if (! confirm('Realmente desea finalizar la Comisión'))
				return false;
		}
	<cfelse>
		if (formulario.botonSel.value == "FinalizarC")
		{
			if (! confirm('Realmente desea finalizar la Comisión'))
				return false;
		}
		if (btnSelected('Aprobar',formulario)) 
		{
			if (! confirm('Desea APROBAR el Anticipo ## #rsForm.GEAnumero# para pago por ' + formulario.FormaPago.options[formulario.FormaPago.selectedIndex].text))
				return false;
		}
	</cfif>
	
		// Validacion terminada
		if (error_msg.length != "") {
			alert("#LB_RevisaDatos#:"+error_msg);
			return false;
		}

		formulario.GEAmanual.disabled = false;
		document.form1.GEAviatico.disabled=false;
		document.form1.GEAtipoviatico1.disabled=false;
		document.form1.GEAtipoviatico2.disabled=false;
	}
	
	
	/* aqu asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
	function asignaTC() {	
		if (document.form1.McodigoOri.value == "#rsMonedaLocal.Mcodigo#") {		
			formatCurrency(document.form1.TC,2);
			document.form1.GEAmanual.disabled = true;
		}
		else
			document.form1.GEAmanual.disabled = false;							
		var estado = document.form1.GEAmanual.disabled;
		document.form1.GEAmanual.disabled = false;
		document.form1.GEAmanual.value = fm(document.form1.TC.value,2);
        document.form1.GEAmanual.disabled = estado;
	}
	document.form1.GEAmanual.value='1.00';					
	asignaTC();
	
	
	
	
	//Llama el conlis
	function funcItinerario() { 
	
		var params ="";
		var GECid_comision=document.form1.GECid_comision.value;

		popUpWindowIns("/cfmx/sif/tesoreria/GestionEmpleados/catalogoItinerarioComision.cfm?GECid="+GECid_comision,window.screen.width*0.05 ,window.screen.height*0.05,window.screen.width*0.90 ,window.screen.height*0.90);
		return false;
	}
	
	var popUpWinIns = 0;
	function popUpWindowIns(URLStr, left, top, width, height){
		if(popUpWinIns){
			if(!popUpWinIns.closed) popUpWinIns.close();
		}
		popUpWinIns = open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
     
      function LimpiaConcepto()
      {
		 document.form1.GECdescripcion.value= '';    
		 document.form1.Concepto.value= '';    
	  }
	
	//-->
	</script>
	

</cfoutput>
<!---DETALLE--->
<cfif modoC neq "ALTA">			
	<cfinclude template="solicitudesAnticipoDet_form.cfm">	
</cfif>

<!--- Pinta Numero Anticipo --->
<cffunction name="fnNumeroSolicitud" output="yes">
	<tr>
		<td  align="right" valign="top" ><strong><cf_translate key=LB_NumAnticipo> Num. Anticipo</cf_translate>:&nbsp;</strong></td>
		<td  align="left" valign="top" >
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td  align="left" valign="top" nowrap="nowrap">
					<cfif modo NEQ 'ALTA'>
						#rsForm.GEAnumero#
						<input type="hidden" name="GEAnumero" value="#rsForm.GEAnumero#" />
						<input type="hidden" name="hdGEAtotalOri" value="#rsForm.GEAtotalOri#" />
						<input type="hidden" name="CCHid" value="#rsForm.CCHid#" />
					<cfelse>
						&nbsp;&nbsp; -- <cf_translate key=LB_NuevoAnticipo>Nuevo Anticipo</cf_translate> --
					</cfif>
				</td>
				<!---Fecha Solicitud--->
				<td  align="right" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_FechaSolicitud>Fecha Solicitud</cf_translate>:&nbsp;&nbsp;</strong>
					<cfif modo NEQ 'ALTA'>
						#LSDateFormat(rsForm.GEAfechaSolicitud,"DD/MM/YYYY")#
					<cfelse>
						#LSDateFormat(now(),"DD/MM/YYYY")#
					</cfif>
				</td>
			</tr></table>
		</td>			
	</tr>
</cffunction>
<!--- Pinta combo que selecciona si el anticipo se va a ir por Caja Chica o por Tesoreria--->
<cffunction name="fnFormaPago" output="yes">
	<cfif modo NEQ 'ALTA' AND LvarEsAprobadorSP>	
		<cfquery  name="rsCajaChica" datasource="#session.dsn#">
			select 	distinct
					c.CCHtipo,
					c.CCHid,
					c.CCHdescripcion,
					c.CCHcodigo
			from CCHica c
				inner join CCHicaCF cf
				on cf.CCHid=c.CCHid
			where c.Ecodigo=#session.Ecodigo#
			  and c.CCHestado='ACTIVA'
			  and c.Mcodigo=#rsForm.McodigoOri#
			  and cf.CFid =#rsForm.CFid#
		<cfif LvarSAporComision>
			  and c.CCHtipo = 2   <!--- Por comisión solo se permite Cajas Especiales --->
		<cfelse>
			  and c.CCHtipo <> 3   <!--- Por comisión solo se permite Cajas Especiales --->
		</cfif>
			order by c.CCHtipo desc
		</cfquery>
		<tr>
			  <td valign="middle" align="right" nowrap="nowrap">
				 <strong><cf_translate key=LB_FormaPago>Forma de Pago</cf_translate>:&nbsp; </strong>
	      </td>
			   
			   <td valign="middle" align="left" nowrap="nowrap">
				
					<select name="FormaPago" id="FormaPago">
						<option value="" >(<cf_translate key=LB_SeleccionFormaPago>Seleccionar Forma de Pago</cf_translate>)</option>
						<optgroup label="<cf_translate key=LB_Tesoreria>Por Tesorería</cf_translate>">
						<option value="0" <cfif VCCHid EQ 0> selected= "selected" </cfif>><cf_translate key=LB_Cheque>Cheque o TEF</cf_translate></option>
							<cfif rsCajaChica.RecordCount>
								<cfoutput query="rsCajaChica" group="CCHtipo">
									<cfif CCHtipo EQ 1>
										<optgroup label="Por Caja Chica">
									<cfelse>
										<optgroup label="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Con Efectivo por Caja Especial">
									</cfif>
									<cfoutput>
									<option value="#rsCajaChica.CCHid#" <cfif modo neq "ALTA" and rsCajaChica.CCHid  eq rsForm.CCHid> selected="selected" </cfif>>#rsCajaChica.CCHcodigo#-#rsCajaChica.CCHdescripcion#</option>									
									</cfoutput>
								</cfoutput>
								</optgroup>
							</cfif>                       
					</select>					                             
			  </td>
	  </tr>
	</cfif>
</cffunction>
