<!---

	Cuando el módulo es utilizado por el Administrator (Cuando Session.Params.ModoDespliegue EQ 1)
	Este módulo es incluido desde dos pantallas: desde el expediente del empleado y como pantalla independiente para registro de acciones de personal
	Para saber desde donde se esta llamando se pregunta por una variable que se llama tabChoice la cual únicamente está presenta cuando se incluye el módulo desde esas pantallas
	Cuando se está trabajando desde el expediente hay que asegurarse de reenviar los parámetros de o, sel y DEid los cuales son necesarios para esa pantalla
--->

<!--- VARIABLES DE TRADUCCION --->
<!---=================== TRADUCCION ============================---->
<!---Boton Eliminar ---->
<cfinvoke key="BTN_Eliminar" default="Eliminar" returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<!----Boton Nuevo ---->
<cfinvoke key="BTN_Nuevo" default="Nuevo" returnvariable="BTN_Nuevo" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<!----Boton Guardar ---->
<cfinvoke key="BTN_Guardar" default="Guardar" returnvariable="BTN_Guardar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<!---Boton de aplicar ---->
<cfinvoke key="BTN_Aplicar" default="Aplicar"	 xmlfile="/rh/generales.xml" returnvariable="BTN_Aplicar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ExistenVacacionesPosterioresALaFechaRigeDeLaTransaccionDeCeseEstaSeguroDeQueDeseaContinuarConLaAplicacion" default="Existen vacaciones posteriores a la fecha rige de la transacción de cese. ¿Está seguro de que desea continuar con la aplicación?"	 returnvariable="MSG_VacacionesPosteriores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Desea_eliminar_la_Accion_de_Personal" default="¿Desea eliminar la Acción de Personal?"	 returnvariable="MSG_EliminarAccion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_No_puede_ser_cero" default="no puede ser cero"	 returnvariable="MSG_NoPuedeSerCero" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_La_Fecha_Vence_no_puede_ser_menor_que_la_Fecha_Rige" default="La Fecha Vence no puede ser menor que la Fecha Rige"	 returnvariable="MSG_FechaVenceMenor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Regimen_de_Vacaciones" default="Régimen de Vacaciones"	 returnvariable="MSG_Regimen_de_Vacaciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Tipo_de_Nomina" default="Tipo de Nómina"	 returnvariable="MSG_Tipo_de_Nomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Oficina" default="Oficina"	 returnvariable="MSG_Oficina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Departamento" default="Departamento"	 returnvariable="MSG_Departamento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Plaza" default="Plaza"	 returnvariable="MSG_Plaza" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Puesto" default="Puesto"	 returnvariable="MSG_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Porcentaje_de_Plaza" default="Porcentaje de Plaza" returnvariable="MSG_Porcentaje_de_Plaza"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Porcentaje_de_Salario_Fijo" default="Porcentaje de Salario Fijo"	 returnvariable="MSG_Porcentaje_de_Salario_Fijo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Jornada" default="Jornada"	 returnvariable="MSG_Jornada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Vacaciones_Disfrutadas" default="Vacaciones Disfrutadas" returnvariable="MSG_Vacaciones_Disfrutadas"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Cantidad_de" default="Cantidad de"	 returnvariable="MSG_Cantidad_de" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Monto_de" default="Monto de"	 returnvariable="MSG_Monto_de" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Empleado" default="Empleado"	 returnvariable="MSG_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Tipo_de_Accion" default="Tipo de Acción"	 returnvariable="MSG_Tipo_de_Accion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Fecha_Rige" default="Fecha Rige"	 returnvariable="MSG_Fecha_Rige" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Fecha_Vence" default="Fecha Vence"	 returnvariable="MSG_Fecha_Vence" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Nueva_Empresa" default="Nueva Empresa"	 returnvariable="MSG_Nueva_Empresa" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ListaDeEmpleados" default="Lista de Empleados" returnvariable="LB_ListaDeEmpleados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_LaDiferenciaDeDiasEntreFechaRigeYFechaVenceNoPuedeSerMayorA" default="La diferencia de días entre Fecha Rige y Fecha Vence no puede ser mayor a "	 returnvariable="MSG_LaDiferenciaDeDiasEntreFechaRigeYFechaVenceNoPuedeSerMayorA" component="sif.Componentes.Translate"method="Translate"/>
<cfinvoke key="MSG_Dias" default=" días"	 returnvariable="MSG_Dias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ElValorDelCampo" default="El valor del campo "	 returnvariable="MSG_ElValorDelCampo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DebeSerMayorA" default="debe ser mayor a"	 returnvariable="MSG_DebeSerMayorA" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_YMenorOIgualA" default="y menor o igual a"	 returnvariable="MSG_YMenorOIgualA" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NoSeEncontraronRegistros" default="No se encontraron Registros"	 returnvariable="MSG_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_EVfantig_prop" default="Fecha de antiguedad"	 returnvariable="MSG_EVfantig_prop" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_RHAtipo" default="Tipo"	 returnvariable="MSG_RHAtipo" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MSG_RHAdescripcion" default="Texto"	 returnvariable="MSG_RHAdescripcion" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="MSG_DebeDigitarUnPorcentajeEntre0Y100" default="Debe digitar un porcentaje entre 0 y 100%" returnvariable="MSG_DebeDigitarUnPorcentajeEntre0Y100" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Tipo_de_Tabla3" default="Tipo de Tabla"	 returnvariable="MSG_Tipo_de_Tabla3" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Categoria3" default="Categoría"	 returnvariable="MSG_Categoria3" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Puesto3" default="Puesto"	 returnvariable="MSG_Puesto3" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Tipo_de_Tabla4" default="Tipo de Tabla para Categoría Propuesta"	 returnvariable="MSG_Tipo_de_Tabla4" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Categoria4" default="Categoría  para Categoría Propuesta"	 returnvariable="MSG_Categoria4" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Puesto4" default="Puesto  para Categoría Propuesta"	 returnvariable="MSG_Puesto4" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfinclude template="/rh/Utiles/funciones.cfm">
<cfif isdefined("Form.Cambio")>  
  <cfset modo="CAMBIO">
<cfelse>  
  <cfif not isdefined("Form.modo")>    
    <cfset modo="ALTA">
  <cfelseif Form.modo EQ "CAMBIO">
    <cfset modo="CAMBIO">
  <cfelse>
    <cfset modo="ALTA">
  </cfif>  
</cfif>

<cfset RHTespecial  = 0>

<cfquery name="rsEmpresasCuenta" datasource="asp">
	select Ereferencia as Ecodigo, Enombre
	from Empresa
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and Ecodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	and Cid = (
		select Cid
		from Empresa
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	)
	order by Enombre
</cfquery>

	<cfquery name="rsEmpleadoIndenti" datasource="#Session.DSN#">
		select RHAid,DEid,DLffin, * from RHAcciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>



<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" 
	ecodigo="#session.Ecodigo#" pvalor="2025" default="" returnvariable="UsaSBC"/>
<cfif #UsaSBC# EQ 1>
	<cfquery name="rsTipoRiesgo" datasource="sifcontrol">
		select *
		from RHItiporiesgo
		order by RHIcodigo
	</cfquery>
	
	<cfquery name="rsConsecuencia" datasource="sifcontrol">
		select *
		from RHIconsecuencia
		order by RHIcodigo
	</cfquery>
	
	<cfquery name="rsControlIncapacidad" datasource="sifcontrol">
		select *
		from RHIcontrolincapacidad
		order by RHIcodigo
	</cfquery>
</cfif>

<cfif modo EQ "CAMBIO">
	<!--- Averiguar si el comportamiento del Tipo de Acción es un cambio de empresa --->
	<cfquery name="rsTipoAccionComp" datasource="#Session.DSN#">
		select coalesce(b.RHTporc, 100) as RHTporc,coalesce(b.RHTporcsal,100) as  RHTporcsal,
		a.EcodigoRef, b.RHTcomportam, b.RHTcempresa, b.RHTnoveriplaza,b.RHTespecial, coalesce(RHTNoMuestraCS,0) as RHTNoMuestraCS,
		RHTcsalariofijo, coalesce(RHTporcPlazaCHK, 0) as RHTporcPlazaCHK, b.RHTsubcomportam ,b.RHCatParcial,a.RHAccionRecargo
		from RHAcciones a, RHTipoAccion b
		where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.RHTid = b.RHTid
	</cfquery>
	<cfset RHTespecial      = rsTipoAccionComp.RHTespecial>
	<cfset RHTcomportam     = rsTipoAccionComp.RHTcomportam>
	<cfset RHTsubcomportam  = rsTipoAccionComp.RHTsubcomportam>
	<cfset RHTNoMuestraCS   = rsTipoAccionComp.RHTNoMuestraCS>
	<cfset RHTporcPlazaCHK  = rsTipoAccionComp.RHTporcPlazaCHK>
	<cfset RHTcsalariofijo  = rsTipoAccionComp.RHTcsalariofijo>
	<cfset RHTporcsal 		= rsTipoAccionComp.RHTporcsal>
    <cfset form.LTidRecargo = rsTipoAccionComp.RHAccionRecargo>

	
	
	<!--- Averiguar si hay que utilizar la tabla salarial --->
	<cfquery name="rsTipoTabla" datasource="#Session.DSN#">
		select CSusatabla
		from ComponentesSalariales
		<!--- Cambio de Empresa --->
		<cfif rsTipoAccionComp.RHTcomportam EQ 9 and rsTipoAccionComp.RHTcempresa EQ 1 and isdefined("rsTipoAccionComp.EcodigoRef") and Len(Trim(rsTipoAccionComp.EcodigoRef))>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoAccionComp.EcodigoRef#">
		<cfelse>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfif>
		and CSsalariobase = 1
	</cfquery>
	<cfif rsTipoTabla.recordCount GT 0>
		<cfset usaEstructuraSalarial = rsTipoTabla.CSusatabla>
	<cfelse>
		<cfset usaEstructuraSalarial = 0>
	</cfif>
</cfif>

<cfif isdefined('form.LTidRecargo') and form.LTidRecargo GT 0>
	<cfinclude template="AccionesRecargos-queries.cfm">
<cfelse>
	<cfinclude template="Acciones-queries.cfm">
</cfif>
<!--- VERIFICA SI TIENE RECARGOS --->
<cfif isdefined('rsAccion.DEid')>
	<cfquery name="rsRecargos" datasource="#session.DSN#">
		select 1
		from LineaTiempoR
		where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  <!--- and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#"> between LTdesde and LThasta --->
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DEid#">
	</cfquery>
    <!--- <cf_dump var="#rsRecargos#"> --->
</cfif>
<cfset Lvar_Recargos = 0>
<cfif isdefined('rsRecargos') and rsRecargos.RecordCount>
<cfset Lvar_Recargos = 1>
</cfif>
<cfinclude template="Acciones-queries.cfm">
	<cfif isdefined ('rsAccion.RHTid') and len(trim(rsAccion.RHTid)) gt 0>
	<cfquery name="rsAccionesVal" datasource="#session.dsn#">
		select RHCatParcial from RHTipoAccion where RHTid=#rsAccion.RHTid#
	</cfquery>
	</cfif>
<!--- VARIABLE PARA DEFINIR PERMISO PARA MODIFICAR LA ACCION 
	SE DEFINE ACTIVA PARA LAS ACCIONES NORMALES --->
<cfset Lvar_Modifica = 1>
<!--- 
	ROL DEFINIDO PARA HENKEL PARA PERMITIR MODIFICAR ACCIONES REGISTRADAS DESDE INTERFAZ
	VERIFICA SI EL USUARIO TIENE EL ROL
--->
<cfquery name="rsRolAccionesInterfaz" datasource="asp">
	select 1
	from UsuarioRol
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	  and SScodigo = 'RH'
	  and SRcodigo = 'ADMAINT'
	  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>
<!--- VERIFICA SI HAY UNA ACCION REGISTRADA --->
<cfif isdefined('rsAccion')>
	<!--- VERIFICA SI LA ACCION VIENE DE INTERFAZ Y ADEMÁS SI TIENE EL ROL PARA MODIFICAR
		SI CUMPLE AMBAS CONDICIONES ENTONCES LA VARIABLE SE ASIGNA UN 1 --->
	<cfif rsAccion.IDInterfaz GT 0 and rsRolAccionesInterfaz.RecordCount GT 0>
		<cfset Lvar_Modifica = 1>
	<cfelseif rsAccion.IDInterfaz GT 0 and rsRolAccionesInterfaz.RecordCount EQ 0>
		<cfset Lvar_Modifica = 0>
	</cfif> 
</cfif>

<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
	<cfquery name="rsEmpresaReferencia" datasource="asp">
		select Enombre
		from Empresa
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAccion.EcodigoRef#">
	</cfquery>
</cfif>

<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 5 and rsAccion.RHTsubcomportam GT 0 and #UsaSBC# EQ 1>

	<cfquery name="rsTipoRiesgo" datasource="sifcontrol">
		select *
		from RHItiporiesgo
		where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAccion.RHItiporiesgo#">
	</cfquery>
	
	<cfquery name="rsConsecuencia" datasource="sifcontrol">
		select *
		from RHIconsecuencia
		where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAccion.RHIconsecuencia#">
	</cfquery>
	
	<cfquery name="rsControlIncapacidad" datasource="sifcontrol">
		select *
		from RHIcontrolincapacidad
		where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAccion.RHIcontrolincapacidad#">
	</cfquery>
</cfif>


<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
   function fnValidacionCeros() <!---SML. Funcion para no agregar Componentes Salariales en cero--->
   {
	alert("Hay Componentes Salariales que estan en Ceros!");	
	}


	function Lista() {
		location.href = "Acciones-lista.cfm";
	}
	function validaForm(f) {

	

		<cfif RHTespecial neq 1> <!--- Funciones para acciones normales --->
			// funcion para quitar las comas de los números al realizar submit	
			
				<cfif modo NEQ "ALTA">
				<cfoutput>
				<cfloop query="rsComponentesAccion">
					f.obj.RHDAunidad_#rsComponentesAccion.currentRow#.value = qf(f.obj.RHDAunidad_#rsComponentesAccion.currentRow#.value);
					f.obj.RHDAmontobase_#rsComponentesAccion.currentRow#.value = qf(f.obj.RHDAmontobase_#rsComponentesAccion.currentRow#.value);
					f.obj.RHDAmontores_#rsComponentesAccion.currentRow#.value = qf(f.obj.RHDAmontores_#rsComponentesAccion.currentRow#.value);
				</cfloop>
				</cfoutput>
				</cfif>
		</cfif>

	
		var DEid = document.getElementById("DEid").value;
		var RHTid = document.getElementsByName("RHTid")[0].value;
		var DLfvigencia = document.getElementById("DLfvigencia").value;
		var isSubmit = true;
	
		$.ajax({
         type: "POST",
         url: "AccionesExcepcion.cfc?method=getListaErr",
         data: {'DEid' :DEid,'RHTid':RHTid,'DLfvigencia': DLfvigencia },
         async: false,
              success: function(result)
              {
              	var obj = JSON.parse(result);
          

	               if(obj != "CONTINUA")
	               {
	               		isSubmit = false;
	               		alert(obj+'');
	               }

              },
              error: function(XMLHttpRequest, textStatus, errorThrown) {
                     alert("Status: " + textStatus); alert("Error: " + errorThrown);
                 }
       });

		if(isSubmit == false)
		{
			return false;

		}
		
		return true;
	}

</script>
<cfoutput>

<form name="form1" method="post" action="/cfmx/rh/nomina/operacion/Acciones-sql.cfm" onsubmit="javascript: return validaForm(this);">
	<!--- Campos ocultos utilizados cuando se invoca desde pantallas de expediente --->
	<cfif isdefined("tabChoice") and isdefined("Form.DEid") and isdefined("Form.o")>
		<input type="hidden" name="o" value="#Form.o#">
		<input type="hidden" name="DEid" value="#Form.DEid#">
	</cfif>
	<cfif isdefined("Form.sel")>
		<input type="hidden" name="sel" value="#Form.sel#">
	</cfif>
	<cfif isdefined('form.Jefe')><!--- SI ESTOY EN AUTOGESTION - TRAMITES PARA SUBORDINADOS --->
		<input name="Jefe" type="hidden" value="#form.Jefe#">
		<input name="CentroF" type="hidden" value="#form.CentroF#">
	</cfif>
    <!--- Indicador para recargo--->
    <input name="indicaRecargo" type="hidden" value="<cfif modo NEQ 'ALTA'>#rsAccion.RHAccionRecargo#</cfif>"/>
    <!--- Si es una accion para recargo --->
    <input name="RHTcomportam" type="hidden" value="<cfif modo NEQ 'ALTA'>#rsAccion.RHTcomportam#</cfif>">
    <input name="LTidRecargo" type="hidden" value="<cfif isdefined('form.LTidRecargo')>#form.LTidRecargo#</cfif>" />
    <input name="CambioAccion" type="hidden" value="0" />
    <table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
	<!--- Se solicita el empleado solamente cuando NO se invoca desde el Expediente --->
	<cfif not isdefined("tabChoice")>
      <tr> 
        <td width="10%" align="right" nowrap class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</td>
        <td colspan="5" nowrap> 
				<cfif modo NEQ "ALTA">
					<input type="hidden" name="DEid" value="#rsAccion.DEid#" tabindex="-1">
					#HtmlEditFormat(rsAccion.NombreEmp)# &nbsp;&nbsp;<b>#HtmlEditFormat(rsAccion.NTIdescripcion)#:</b> #HtmlEditFormat(rsAccion.DEidentificacion)#
				<cfelse>
					<cf_rhempleado size="80" tabindex="1"> 
				</cfif> 
		</td>
      </tr>
	</cfif>
	<!--- SI ESTOY EN AUTOGESTION - TRAMITES PARA SUBORDINADOS --->
	<!--- SI ES AUTOGESTION SE VA A VER EL CONJUNTO DE EMPLEADOS SI EL USUARIO ES JEFE DE UN CENTRO FUNCIONAL --->
	<cfif isdefined('form.Jefe') and form.Jefe>
		<!--- DEPENDENCIAS DEL CENTRO FUNCIONAL --->
		<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaSubOrd" 
			deid = "#form.Jefe#"
			fecha = "#Now()#"
			returnvariable="Subordinados"/>
		<cfset Empleados = ValueList(Subordinados.DEid)>
		<cfif LEN(Empleados)>
			<cfset queryEmpleados = "and de.DEid in(#Empleados#)">
		<cfelse>
			<cfset queryEmpleados = "and de.DEid in(0)">
		</cfif>
		<cfset Lvar_valuesArray = ''>
		<cfset form.Fecha = Now()>
		<tr>
			<td align="right" class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</td>
			<td>
				<cfif modo EQ "CAMBIO">
					<cfquery name="rsEmpleado" datasource="#session.DSN#">
						select DEid as DEidSub,
								DEidentificacion,
								{fn concat({fn concat({fn concat({ fn concat(DEapellido1 , ' ') },DEapellido2)}, ' ')},DEnombre) } as NombreCompleto
						from DatosEmpleado
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEidSub#">
					</cfquery>
					<input name="DEidSub" type="hidden" value="#rsEmpleado.DeidSub#" tabindex="-1">
					#rsEmpleado.DEidentificacion# - #rsEmpleado.NombreCompleto#
					
				<cfelse>
				<cf_dbfunction name="concat" args="DEapellido1,DEapellido2,DEnombre" returnvariable="filtrar_por" >
				<cf_conlis 
					title="#LB_ListaDeEmpleados#"
					campos = "DEidSub,DEidentificacion,NombreCompleto" 
					id="DEid"
					desplegables = "N,S,S" 
					modificables = "N,S,N"
					size = "0,15,40"
					valuesarray="#Lvar_valuesArray#" 
					tabla="DatosEmpleado de
					inner join LineaTiempo lt
					   on de.DEid = lt.DEid
					  and de.Ecodigo = lt.Ecodigo
					  and #Fecha# between lt.LTdesde and lt.LThasta 
					inner join RHPlazas p
					   on p.Ecodigo = lt.Ecodigo
					  and p.RHPid = lt.RHPid
					inner join CFuncional cf
					   on cf.Ecodigo = p.Ecodigo
					  and cf.CFid = p.CFid
					inner join RHPuestos pp
					   on p.Ecodigo = pp.Ecodigo
					  and p.RHPpuesto = pp.RHPcodigo"
					columnas="cf.CFid,cf.CFcodigo, cf.CFdescripcion,
								pp.RHPcodigo as Puesto,pp.RHPdescpuesto,
								p.RHPcodigo as Plaza,p.RHPdescripcion, 
								de.DEid  as DEidSub,
								de.DEidentificacion,
								{fn concat({fn concat({fn concat({ fn concat(DEapellido1 , ' ') },DEapellido2)}, ' ')},DEnombre) } as NombreCompleto
"
					filtro="de.Ecodigo = #Session.Ecodigo# #queryEmpleados# 
						group by cf.CFid,cf.CFcodigo, cf.CFdescripcion,
						pp.RHPcodigo,pp.RHPdescpuesto,
						p.RHPcodigo,p.RHPdescripcion, 
						de.DEid,
						de.DEidentificacion,	
						{fn concat({fn concat({fn concat({ fn concat(DEapellido1 , ' ') },DEapellido2)}, ' ')},DEnombre) }

					order by cf.CFid"
					desplegar="DEidentificacion,NombreCompleto"
					etiquetas="#LB_Codigo#, #LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					cortes="CFdescripcion"
					asignar="DEidSub,DEidentificacion,NombreCompleto"
					asignarformatos="S,S,S"
					height= "400"
					width="500"
					tabindex="1"
					showEmptyListMsg="true"
					filtrar_por="DEidentificacion,#filtrar_por#"
					EmptyListMsg="#MSG_NoSeEncontraronRegistros#" >

				</cfif>
			
			</td>
		</tr>
	</cfif>
    <tr> 
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Tipo_de_Accion">Tipo de Acci&oacute;n</cf_translate>:</td>
        <td nowrap>
			<!--- No modificable desde modo cambio --->
			<cfif modo NEQ "ALTA">
				<input type="hidden" id="RHTid" name="RHTid" value="#rsAccion.RHTid#">
				<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 5 and rsAccion.RHTsubcomportam GT 0 and #UsaSBC# EQ 1>
					<input type="hidden" name="RHTsubcomportam" value="<cfif modo NEQ "ALTA">#rsAccion.RHTsubcomportam#<cfelse>0</cfif>">
				</cfif>
				<input type="hidden" name="RHTpmax" value="<cfif modo NEQ "ALTA">#rsAccion.RHTpmax#<cfelse>0</cfif>">
            	#HtmlEditFormat(rsAccion.RHTcodigo)# - #HtmlEditFormat(rsAccion.RHTdesc)#
			<!--- Carga Tipo de Accion por defecto cuando viene --->
            <cfelseif isdefined("rsTipoAccionDef") and not isdefined("tabChoice")>
				<cfif isdefined("UsaSBC") and UsaSBC eq 1>
                    <cf_rhtipoaccion query="#rsTipoAccionDef#" hidectls="tdFfinetq,tdFfintxt,trEmpresa,trIncapacidad,trIncapacidadFolio" combo="true" tabindex="1"> 
                <cfelse>
                     <cf_rhtipoaccion query="#rsTipoAccionDef#" hidectls="tdFfinetq,tdFfintxt,trEmpresa,trIncapacidad,trIncapacidadFolio" combo="false" tabindex="1"> 
                </cfif>
			<!--- Modo Alta --->
            <cfelse>
				<!--- Pantallas desde el Administrador --->
				<cfif Session.Params.ModoDespliegue EQ 1>
                	<cfif isdefined("UsaSBC") and UsaSBC eq 1>
						<cf_rhtipoaccion hidectls="tdFfinetq,tdFfintxt,trEmpresa,trIncapacidad,trIncapacidadFolio" combo="true" tabindex="1">
                    <cfelse>
	                    <cf_rhtipoaccion hidectls="tdFfinetq,tdFfintxt,trEmpresa,trIncapacidad,trIncapacidadFolio" combo="false" tabindex="1">
                    </cfif>
				<!--- Acceso restringido de Tipos de acciones desde autogestion --->
				<cfelseif Session.Params.ModoDespliegue EQ 0>
                	<cfif isdefined("UsaSBC") and UsaSBC eq 1>
                    	<cf_rhtipoaccion hidectls="tdFfinetq,tdFfintxt,trEmpresa,trIncapacidad,trIncapacidadFolio" combo="true" autogestion="true" tabindex="1">
                    <cfelse>
						<cf_rhtipoaccion hidectls="tdFfinetq,tdFfintxt,trEmpresa,trIncapacidad,trIncapacidadFolio" combo="false" autogestion="true" tabindex="1">
                    </cfif>
				</cfif>
			</cfif> 
		</td>
        <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Rige">Fecha Rige</cf_translate>:</td>
        <td nowrap>
			<cfif modo NEQ "ALTA">
				#LSDateFormat(rsAccion.DLfvigencia, 'DD/MM/YYYY')#
				<input type="hidden" name="DLfvigencia" value="#LSDateFormat(rsAccion.DLfvigencia, 'DD/MM/YYYY')#">
            <cfelse>
				<cfset fecha = LSDateFormat(Now(), 'DD/MM/YYYY')>
				<cf_sifcalendario form="form1" value="#fecha#" name="DLfvigencia" tabindex="3">	
          	</cfif> 
        </td>
        <td align="right" nowrap class="fileLabel"><cfif not (modo EQ "CAMBIO" and rsAccion.RHTpfijo EQ 0)><div id="tdFfinetq" style=""><cf_translate key="LB_Fecha_Vence">Fecha Vence:</cf_translate></div></cfif></td>
        <td nowrap>
			<cfif not (modo EQ "CAMBIO" and rsAccion.RHTpfijo EQ 0)>
				<cfif modo NEQ "ALTA">
					#LSDateFormat(rsAccion.DLffin, 'DD/MM/YYYY')#
					<input type="hidden" name="DLffin" value="#LSDateFormat(rsAccion.DLffin, 'DD/MM/YYYY')#">
				<cfelse>
					<div id="tdFfintxt" style="">
					<cf_sifcalendario form="form1" value="" name="DLffin" tabindex="4">
					</div>
				</cfif>
			</cfif>
        </td>
  </tr>
	  
      <tr id="trEmpresa" <cfif not (modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1)> style="display: none;"</cfif>> 
        <td width="10%" align="right" nowrap class="fileLabel"><cf_translate key="LB_Nueva_Empresa">Nueva Empresa</cf_translate>:</td>
        <td colspan="5" nowrap>
			<cfif modo EQ "ALTA">
				<select name="EcodigoRef" tabindex="5">
				<cfloop query="rsEmpresasCuenta">
					<option value="#rsEmpresasCuenta.Ecodigo#"<cfif modo EQ 'CAMBIO' and rsAccion.EcodigoRef EQ rsEmpresasCuenta.Ecodigo> selected</cfif>>#HtmlEditFormat(rsEmpresasCuenta.Enombre)#</option>
				</cfloop>
				</select>
			<cfelse>
				<input type="hidden" name="EcodigoRef" value="#rsAccion.EcodigoRef#">
				<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
					#HtmlEditFormat(rsEmpresaReferencia.Enombre)#
				</cfif>
			</cfif>
		</td>
      </tr>
	  
<!---20100320 ljimenez se pintan nuevas opciones de detalle en la accion de personal tipo incapacidad Legislacion MEXICO --->
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" 
		ecodigo="#session.Ecodigo#" pvalor="2025" default="" returnvariable="UsaSBC"/>
		
	<cfif #UsaSBC# EQ 1>
		<tr><td colspan="6">
		<table  border="0"id="trIncapacidad" <cfif not (modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 5 and rsAccion.RHTsubcomportam GT 0)>style="display: none;"</cfif>>
		  <tr> 
			<td width="10%" align="right" nowrap class="fileLabel"><cf_translate key="LB_Tipo_Riesgo">Tipo Riesgo</cf_translate>:</td>
			<td>
				<cfif modo EQ "ALTA">
					<span id="contenedor_Riesgos">
						<select name="TipoRiesgo"  id="TipoRiesgo" onchange="ajaxFunction1_ComboConsecuencia();">
							<cfloop query="rsTipoRiesgo">
								<option value="#rsTipoRiesgo.RHIcodigo#"<cfif modo EQ 'CAMBIO' and rsAccion.RHTsubcomportam EQ rsTipoRiesgo.RHIcodigo> selected</cfif>>#HtmlEditFormat(rsTipoRiesgo.RHIdescripcion)#</option>
							</cfloop>
						</select>
					</span>
				<cfelse>
					<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 5 and rsAccion.RHTsubcomportam GT 0 and #UsaSBC# EQ 1>
						<input type="hidden" name="TipoRiesgo" value="#rsAccion.RHItiporiesgo#">
					</cfif>
					
					<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 5 and rsAccion.RHTsubcomportam GT 0>
						#HtmlEditFormat(rsTipoRiesgo.RHIdescripcion)#
					</cfif>
				</cfif>
			</td>
			
			<td width="10%" align="right" nowrap class="fileLabel"><cf_translate key="LB_Consecuencia">Consecuencia</cf_translate>:</td>
			<td>
			<cfif modo EQ "ALTA">
				
				<span id="contenedor_Consecuencia">
					<select name="Consecuencia" id="Consecuencia"  onchange="ajaxFunction1_ComboControlIncapacidad();">
						<cfloop query="rsConsecuencia">
							<option value="#rsConsecuencia.RHIcodigo#"<cfif modo EQ 'CAMBIO' and rsAccion.RHTsubcomportam EQ rsConsecuencia.RHIcodigo> selected</cfif>>#HtmlEditFormat(rsConsecuencia.RHIdescripcion)#</option>
						</cfloop>
					</select>
				</span>
			<cfelse>
				<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 5 and rsAccion.RHTsubcomportam GT 0 and #UsaSBC# EQ 1>
					<input type="hidden" name="Consecuencia" value="#rsAccion.RHIconsecuencia#">
				</cfif>
				<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 5 and rsAccion.RHTsubcomportam GT 0>
					#HtmlEditFormat(rsConsecuencia.RHIdescripcion)#
				</cfif>
			</cfif>
		</td>

	    <td width="10%" align="right" nowrap class="fileLabel"><cf_translate key="LB_Controlincapacidad">Control Incapacidad</cf_translate>:</td>
        <td>
			<cfif modo EQ "ALTA">
				<span id="contenedor_ControlIncapacidad">
					<select name="ControlIncapacidad"  id="ControlIncapacidad" >
						<cfloop query="rsControlIncapacidad">
							<option value="#rsControlIncapacidad.RHIcodigo#"<cfif modo EQ 'CAMBIO' and rsAccion.RHTsubcomportam EQ rsControlIncapacidad.RHIcodigo> selected</cfif>>#HtmlEditFormat(rsControlIncapacidad.RHIdescripcion)#</option>
						</cfloop>
					</select>
				</span>
			<cfelse>
				<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 5 and rsAccion.RHTsubcomportam GT 0 and #UsaSBC# EQ 1>
					<input type="hidden" name="ControlIncapacidad" value="#rsAccion.RHIcontrolincapacidad#">
				</cfif>
				
				
				<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 5 and rsAccion.RHTsubcomportam GT 0>
					#HtmlEditFormat(rsControlIncapacidad.RHIdescripcion)#
				</cfif>
			</cfif>
		</td>
      </tr>

		<tr> 
			<td width="10%" align="right" nowrap class="fileLabel"><cf_translate key="LB_folioIncap">Folio Incapacidad</cf_translate>:</td>
				<td>
				<cfif modo EQ "ALTA">
					<input type="text" name="Folio" 
						value="<cfif isdefined("rsAccion.RHfolio") and len(trim(rsAccion.RHfolio)) gt 0 >
									<cfoutput>#rsAccion.RHfolio#</cfoutput>
							   </cfif>" 
						size="10" 
						maxlength="8" 
						onfocus="javascript:this.select();" >
				
				<cfelse>
					<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 5 and rsAccion.RHTsubcomportam GT 0 and #UsaSBC# EQ 1>
						<input type="hidden" name="Folio" value="#rsAccion.RHfolio#">
						#HtmlEditFormat(rsAccion.RHfolio)#
					</cfif>
				</cfif>
			</td>
			
			<td width="10%" align="right" nowrap class="fileLabel"><cf_translate key="LB_porcentajepagoIMSS">Porcentaje pago IMSS</cf_translate>:</td>
				<td>
				<cfif modo EQ "ALTA">
					<input  name="PorcImss" onfocus="this.select();" 
						onFocus="this.value=qf(this); this.select();" 
						onBlur="javascript: fm(this,2);"  <!--- no lleva decimales --->
						onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						style="text-align: right;" 
						type="text"
						value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsAccion.RHporcimss,'none')#<cfelse>0.00</cfif>" size="8" maxlength="6"/>
				<cfelse>
					<cfif modo EQ "CAMBIO" and rsAccion.RHTcomportam EQ 5 and rsAccion.RHTsubcomportam GT 0 and #UsaSBC# EQ 1>
						<input type="hidden" name="PorcImss" value="#rsAccion.RHporcimss#">
						#HtmlEditFormat(rsAccion.RHporcimss)#%
					</cfif>
						
				</cfif>
		  </td>
		
			</td>
		</tr> 
	</table>
	</td>
	</tr>
	  
	 	<!--- <cfif isdefined("rsForm.RHFOrden") and len(trim(rsForm.RHFOrden)) gt 0 >#rsForm.RHFOrden#</cfif>--->
  </cfif>

<!---ljimenez FIN DE CAMBIO--->
	  
      <tr> 
        <td width="10%" align="right" nowrap class="fileLabel"><cf_translate key="LB_Observaciones">Observaciones</cf_translate>:</td>
        <td colspan="5" nowrap>
			<cfif isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1>
				<cfif modo NEQ "ALTA">#HtmlEditFormat(rsAccion.DLobs)#</cfif>
			<cfelse>
				<input type="text" name="DLobs" size="130" maxlength="255" value="<cfif modo NEQ "ALTA">#HtmlEditFormat(rsAccion.DLobs)#</cfif>" tabindex="6">
			</cfif>
		</td>
      </tr>

      <!--- Vacaciones 3--->
	  <!--- Permiso 4--->
	  <!--- Cambio 5--->
	  <!--- Incapacidades 6--->
	  <cfif modo NEQ "ALTA" 
	  		and (rsTipoAccionComp.RHTcomportam EQ 3 
				or rsTipoAccionComp.RHTcomportam EQ 4
				or rsTipoAccionComp.RHTcomportam EQ 5
				or rsTipoAccionComp.RHTcomportam EQ 6 ) 
			and usaEstructuraSalarial EQ 1 
			and (form.LTidRecargo EQ 0 or LEN(TRIM(form.LTidRecargo)) EQ 0)>
      	<tr> 
        
		<td width="10%" align="right" nowrap class="fileLabel"><input name="chkTipoAplicacion" type="checkbox" <cfif rsAccion.RHTipoAplicacion EQ 1>checked</cfif>  /></td>
        
		<cfif rsTipoAccionComp.RHTcomportam EQ 3 
				or rsTipoAccionComp.RHTcomportam EQ 4
				or rsTipoAccionComp.RHTcomportam EQ 5
				or rsTipoAccionComp.RHTcomportam EQ 6 >
			<td colspan="5" nowrap><strong><cf_translate key="CHK_Aplica_plazas">Aplica para todas las plazas</cf_translate></strong></td>
		<cfelse>
			<td colspan="5" nowrap><strong><cf_translate key="CHK_TipoAplicacion">Modificar solo Componentes Salariales</cf_translate></strong></td>
		</cfif>
		
      </tr>
      </cfif>
      <tr> 
        <td colspan="6" align="center">
			<cfif modo EQ "ALTA">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="BTN_Agregar"
				default="Agregar"
				xmlfile="/rh/generales.xml"
				returnvariable="BTN_Agregar"/>

				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="BTN_ListaDeAcciones"
				default="Lista de Acciones"
				returnvariable="BTN_ListaDeAcciones"/>				
			
				<input name="btnAgregar" type="submit" value="<cfoutput>#BTN_Agregar#</cfoutput>" tabindex="7">
				<cfif not isdefined("tabChoice")>
				<input type="button" name="Regresar" value="<cfoutput>#BTN_ListaDeAcciones#</cfoutput>" onclick="javascript:Lista();" tabindex="8">
				</cfif>
            <cfelse>
            </cfif>
		</td>
      </tr>
	  <cfif modo NEQ "ALTA">
		  <!--- Bloque que se oculta cuando se esta en modo consulta y la accion no se ha terminado de definir --->
		  <cfset sololectura = true>
		  <cfif isdefined("Request.ConsultaAcciones") and RHTespecial eq 1>
		  	<tr>
        		<td colspan="6">
						  <table width="100%" border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td width="45%" valign="top">
								<cfinclude template="AccionesSP-form-sitact.cfm">
							</td>
							<td width="55%" valign="top">
								  <cfinclude template="AccionesSP-form-sitpos.cfm">  
							</td>
						  </tr>
						</table>
				</td>
      		</tr>

		  <cfelseif not (isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1 and Len(Trim(rsAccion.Tcodigo)) EQ 0)>
		  	<tr>
        		<td colspan="6">
					 <cfset sololectura = false>
					 <cfif  RHTespecial eq 1>
						<!--- Acciones Especiales --->
						<table width="100%" border="0" cellspacing="0" cellpadding="2">
						  	<tr><td width="45%" valign="top">
									<cfinclude template="AccionesSP-form-sitact.cfm">
							  	</td>
								<td width="55%" valign="top">
								  <cfinclude template="AccionesSP-form-sitpos.cfm">  
								</td>
						  	</tr>
						</table>
		 			<cfelse>
						<!--- Acciones Normales --->
						<table width="100%" border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td width="45%" valign="top">
								<cfinclude template="Acciones-form-sitact.cfm">
							</td>
							<td width="55%" valign="top">
							  <cfinclude template="Acciones-form-sitpos.cfm">
							</td>
						  </tr>
						  <cfif Lvar_Recargos>
							<cfset Lvar_FechaActRecI = rsAccion.DLfvigencia>
                            <cfset Lvar_FechaActRecF = rsAccion.DLffin>
						   <tr>
							<td valign="top" colspan="2">
								<cfinclude template="AccionesRecargos-form-recargact.cfm"><!---recargos actuales--->
							</td>
						  </tr>
						  </cfif>
						  <tr <cfif modo EQ "CAMBIO" and RHTNoMuestraCS eq 1 >style="display:none"</cfif>>
							<td valign="top">
								<cfinclude template="Acciones-form-compact.cfm">
							</td>
							<td valign="top">
                            	<!---<cf_dump var = "#rsComponentesAccion#">--->
								<cfinclude template="Acciones-form-comppos.cfm">
							</td>
						  </tr>
						</table>
				 </cfif>
			</td>
      	</tr>
	 	 <!--- Solo se muestra el mensaje una vez guardada la acción --->
		<cfif RHTespecial neq 1><!--- solo aparece en acciones normales --->
		  <tr <cfif modo EQ "CAMBIO" and RHTNoMuestraCS eq 1 >style="display:none"</cfif>>
			<td colspan="6" align="center" style="color: ##FF0000 " class="sectionTitle" >
				<cf_translate key="LB_Los_componentes_que_aparecen_en_color_rojo_se_pagan_en_forma_incidente">Los componentes que aparecen en color rojo se pagan en forma incidente.</cf_translate>
			</td>
		  </tr>
		</cfif>
	  
		<!--- Mensaje que aparece cuando el tipo de acción es de cese y cuando hay vacaciones posteriores a esa fecha --->
		<cfif rsAccion.RHTcomportam EQ 2>
		  <cfquery name="rsVacacionesPosteriores" datasource="#Session.DSN#">
			select count(1) as cant
			from DVacacionesEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DEid#">
			and DVEfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#">
		  </cfquery>
		  <cfif rsVacacionesPosteriores.cant GT 0>
		  <tr> 
			<td colspan="6" align="center" class="sectionTitle">
				<font color="##FF0000"><b>
					<cf_translate key="LB_Existen_vacaciones_posteriores_a_la_fecha_rige_de_la_transaccion_de_cese">Existen vacaciones posteriores a la fecha rige de la transacci&oacute;n de cese.</cf_translate>
				</b></font>
			</td>
		  </tr>
		  </cfif>
</cfif>	
			<cfif isdefined("rsConceptosPago") and rsConceptosPago.recordCount GT 0 and rsAccion.RHTNoMuestraCS eq 0>
			  <tr>
				<td colspan="6">
					<cfinclude template="Acciones-form-conceptos.cfm">
				</td>
			  </tr>
			</cfif>
	  </cfif> <!--- Bloque que se oculta cuando se esta en modo consulta y la accion no se ha terminado de definir --->
      
     <!--- SML.Validacion para calcular el Fondo de Ahorro--->
     
     <cfif isdefined('rsComponentesAccion') and rsComponentesAccion.RecordCount GT 0>
     	<cfquery name ="rsFOACeros" dbtype="query">
        	select * from rsComponentesAccion 
            where RHDAmontores = 0
            <!---and CSsalariobase <> 1--->
     	</cfquery>
     </cfif>
	  
	  <cfif rsAccion.Tcodigo EQ "" and RHTespecial neq 1>
      <tr> 
        <td colspan="6" align="center" class="sectionTitle">
			<font color="##FF0000"><b>
			<cfif RHTespecial eq 0 and isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1>
				<cf_translate key="MSG_La_accion_no_ha_sido_registrada_totalmente">¡La acci&oacute;n no ha sido registrada totalmente!</cf_translate>
			<cfelse>
				<cf_translate key="MSG_Para_terminar_de_definir_la_Situacion_Propuesta_debe_guardar_los_cambios">Para terminar de definir la Situaci&oacute;n Propuesta debe guardar los cambios</cf_translate>
			</cfif>
			</b></font>
		</td>
	  </tr>
	  <cfelseif RHTespecial eq 1 and len(trim(rsAccion.EVfantig)) EQ 0 and RHTcomportam eq 11 >
	  <tr> 
        <td colspan="6" align="center" class="sectionTitle">
			<font color="##FF0000"><b>
				<cf_translate key="MSG_Para_terminar_de_definir_la_Situacion_Propuesta_debe_guardar_los_cambios">Para terminar de definir la Situaci&oacute;n Propuesta debe guardar los cambios</cf_translate>
			</b></font>
		</td>
	  </tr>
	  <cfelseif RHTespecial eq 1 and rsAccion.RHAtipo EQ "" and  rsAccion.RHAdescripcion EQ "" and RHTcomportam eq 10 >
	  <tr> 
        <td colspan="6" align="center" class="sectionTitle">
			<font color="##FF0000"><b>
				<cf_translate key="MSG_Para_terminar_de_definir_la_Situacion_Propuesta_debe_guardar_los_cambios">Para terminar de definir la Situaci&oacute;n Propuesta debe guardar los cambios</cf_translate>
			</b></font>
		</td>
	  </tr>	 
      <cfelseif isdefined('rsFOACeros') and rsFOACeros.RecordCount GT 0> <!---SML. Validacion no agregar Componentes Salariales en cero--->
      <tr> 
        <td colspan="6" align="center" class="sectionTitle">
			<font color="##FF0000"><b>
				<cf_translate key="MSG_Para_terminar_de_definir_la_Situacion_Propuesta_debe_guardar_los_cambios">Para terminar de definir la Situaci&oacute;n Propuesta debe guardar los cambios</cf_translate>
			</b></font>
		</td>
	  </tr>	
	  </cfif>
      <tr>
        <td colspan="6" align="center">
			<cfif isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1>
				<cfif isdefined('Lvar_Tramite')>
					<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							key="BTN_Regresar"
							default="Regresar"
							xmlfile="/sif/generales.xml"
							returnvariable="BTN_Regresar"
					/>	
					<cfif isdefined("url.from") and url.from NEQ "">
						<input type="button" name="btnRegresar" onclick="location.href = '/cfmx/sif/tr/consultas/#url.from#.cfm';" value="&lt;&lt; #BTN_Regresar#">
					<cfelse>
						<input type="button" name="btnRegresar" onclick="history.back()" value="&lt;&lt; #BTN_Regresar#">
					</cfif>
				<cfelse>
					<input type="button" name="btnRegresar" value="Regresar" onclick="javascript: atras();">
				</cfif>
			<cfelse>
				<input type="hidden" name="botonSel" value="">
				<input type="submit" name="Cambio" value="#BTN_Guardar#" tabindex="1" onclick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); this.form.action = '/cfmx/rh/nomina/operacion/Acciones-sql.cfm';">
				<cfif Lvar_Modifica>
				<input type="submit" name="Baja" value="#BTN_Eliminar#" tabindex="1" onclick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); this.form.action = '/cfmx/rh/nomina/operacion/Acciones-sql.cfm'; return confirm('#MSG_EliminarAccion#');">
				</cfif>
				<input type="submit" name="Nuevo" value="#BTN_Nuevo#" tabindex="1" onclick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); this.form.action = '/cfmx/rh/nomina/operacion/Acciones-sql.cfm';">
				<!--- Esto es para aplicar dentro de la pantalla de acciones --->
				<cfif rsAccion.Tcodigo NEQ "" or rsAccion.EVfantig NEQ "" or rsAccion.RHAtipo NEQ "" or rsAccion.RHAdescripcion NEQ "" >
				<input type="hidden" name="chk" value="">
				<input type="hidden" name="posteoAccion" value="1">
  			    <input type="hidden" name="RHTespecial" value="#RHTespecial#">

				<input type="submit" name="btnAplicar" value="#BTN_Aplicar#" tabindex="1" onclick="javascript: 
					<cfif rsAccion.RHTcomportam EQ 2 and rsVacacionesPosteriores.cant GT 0>
					if (confirm('#MSG_VacacionesPosteriores#')) {
					</cfif>
						this.form.chk.value = '#rsAccion.RHAlinea#'; this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); this.form.action = '/cfmx/rh/nomina/operacion/Acciones-sql-save-apply.cfm';
					<cfif rsAccion.RHTcomportam EQ 2 and rsVacacionesPosteriores.cant GT 0>
					} else {
						return false;
					}
					</cfif>
                    <cfif isdefined('rsFOACeros') and rsFOACeros.RecordCount GT 0> <!---SML. Validacion para no agregar Componentes Salariales en cero--->
							fnValidacionCeros();
                            return false;
                    </cfif>
					">
				</cfif>
			</cfif>
		</td>
      </tr>
	  </cfif>
    </table>
    <cfset ts = "">
	<cfif modo NEQ "ALTA">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsAccion.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	</cfif>
	<cfif modo NEQ "ALTA">
	<input type="hidden" name="RHAlinea" value="#rsAccion.RHAlinea#">
	<input type="hidden" name="reloadPage" value="0">
	</cfif>
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
</form>
</cfoutput>

<!--- Bloque que se oculta cuando se esta en modo consulta y la accion no se ha terminado de definir --->
<cfif isdefined("Request.ConsultaAcciones") and RHTespecial eq 1>
	<script language="JavaScript">
		function atras(){
			<cfif isdefined('form.atrasAccRech')>
				document.location.href='<cfoutput>#form.atrasAccRech#</cfoutput>';
			<cfelse>
				history.back();
			</cfif>
		}	
	</script>
<cfelseif not (isdefined("Request.ConsultaAcciones") and Request.ConsultaAcciones EQ 1 and rsAccion.Tcodigo EQ "")>
<script language="JavaScript">
	<cfif RHTespecial neq 1><!--- Funciones para acciones normales --->
		// Valida el rango en caso de que el tipo de concepto de incidencia sea de días y horas

		
		function __isNotCero() {
			if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
				<cfoutput>this.error = this.description + ' ' +"#MSG_NoPuedeSerCero#";</cfoutput>
			}
		}
	
		// Valida que sea un porcentaje válido
		function __isPorcentaje() {
			if (this.required && (new Number(qf(this.value)) > 100.00)) {
				<cfoutput>this.error = this.description + ' ' +"#MSG_NoPuedeSerCero#";</cfoutput>
			}
		}
		
		function __isPorcentajeIMSS() {
		if (objForm.PorcImss.value < 0 || objForm.PorcImss.value > 100 ){
				this.error = "<cfoutput>#MSG_DebeDigitarUnPorcentajeEntre0Y100#</cfoutput>"
			}
		}	
		
		// Valida el rango entre la fecha de inicio y la fecha de fin de la accion y valida que la fecha fin sea mayor a la inicial
		function __isRangoFechas() {
			if (this.required) {
				var tope = new Number(qf(this.obj.form.RHTpmax.value));
				var a = this.obj.form.DLfvigencia.value.split("/");
				var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
				var b = this.obj.form.DLffin.value.split("/");
				var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
				var dif = ((fin-ini)/86400000.0)+1;	// diferencia en días
				if (new Number(dif) <= 0) {
					<cfoutput>this.error = "#MSG_FechaVenceMenor#"</cfoutput>;
				} else if (new Number(dif) > tope) {
					this.error = "<cfoutput>#MSG_LaDiferenciaDeDiasEntreFechaRigeYFechaVenceNoPuedeSerMayorA#</cfoutput> " + tope + "<cfoutput>#MSG_Dias#</cfoutput>";
				}
			}
		}
		
		// Valida que los días disfrutados para vacaciones sean los correctos
		function __isVacaciones() {
			if (this.required && (new Number(qf(this.value)) < 0 || new Number(qf(this.value)) > new Number(qf(this.obj.form.vacadias.value)))) {
				this.error = "<cfoutput>#MSG_ElValorDelCampo#</cfoutput> " + this.description + " <cfoutput>#MSG_DebeSerMayorA#</cfoutput> 0 <cfoutput>#MSG_YMenorOIgualA#</cfoutput> " + parseFloat(this.obj.form.vacadias.value);
			}
		}
	</cfif>
	<cfif modo NEQ "ALTA">
	function habilitarValidacion() {
		<cfif RHTespecial neq 1> <!--- Funciones para acciones normales --->
			//========================================================		
			objForm.Tcodigo.required = true;
			objForm.RVid.required = true;
			objForm.Ocodigo.required = true;
			objForm.Dcodigo.required = true;
			if (objForm.CodPlaza) objForm.CodPlaza.required = true;
			objForm.RHPcodigo.required = true;
			objForm.LTporcplaza.required = true;
			objForm.LTporcsal.required = true;
			objForm.RHJid.required = true;
			<cfif rsAccion.RHTcomportam EQ 3>
			objForm.RHAvdisf.required = true;
			</cfif>
			<cfif usaEstructuraSalarial EQ 1 and rsTipoAccionComp.RHCatParcial EQ 1>
				objForm.RHTTid4.required = true;
				objForm.RHCid4.required = true;
				objForm.RHMPPid4.required = true;
			<cfelseif usaEstructuraSalarial EQ 1>
				objForm.RHTTid3.required = true;
				objForm.RHCid3.required = true;
				objForm.RHMPPid3.required = true;
			</cfif>
			<cfoutput>
			<!---<cf_dump var = "#rsComponentesAccion#">--->
			<cfloop query="rsComponentesAccion">
				<!---<cfif #rsComponentesAccion.RHDAmontores# EQ 0>--->
				objForm.RHDAunidad_#rsComponentesAccion.currentRow#.required = true;
				objForm.RHDAmontores_#rsComponentesAccion.currentRow#.required = true;
				<!---</cfif>--->
			</cfloop>
			</cfoutput>
		<cfelse><!--- Funciones para acciones especiales  --->
		
			<cfif modo EQ "CAMBIO" and rsTipoAccionComp.RHTcomportam EQ 10>
				objForm.RHAtipo.required 	    = true;
				objForm.RHAdescripcion.required = true;
			<cfelseif modo EQ "CAMBIO" and rsTipoAccionComp.RHTcomportam EQ 11>
				objForm.EVfantig_prop.required = true;
			</cfif>
		</cfif>
	}
	function deshabilitarValidacion() {
		<cfif RHTespecial neq 1> <!--- Funciones para acciones normales --->
			//Habilitar campos
			//========================================================		
			
			objForm.Tcodigo.required = false;
			objForm.RVid.required = false;
			objForm.Ocodigo.required = false;
			objForm.Dcodigo.required = false;
			if (objForm.CodPlaza) objForm.CodPlaza.required = false;
			objForm.RHPcodigo.required = false;
			objForm.LTporcplaza.required = false;
			objForm.LTporcsal.required = false;
			objForm.RHJid.required = false;
			<cfif rsAccion.RHTcomportam EQ 3>
			objForm.RHAvdisf.required = false;
			</cfif>
			
			<cfif usaEstructuraSalarial EQ 1 and rsAccionesVal.RHCatParcial eq 0>
				objForm.RHTTid1.required = false;
				objForm.RHCid1.required = false;
				objForm.RHMPPid1.required = false;
			</cfif> 
			<cfif usaEstructuraSalarial EQ 1 and rsTipoAccionComp.RHCatParcial EQ 1>
				objForm.RHTTid4.required = false;
				objForm.RHCid4.required = false;
				objForm.RHMPPid4.required = false;
			</cfif>
			
			<cfoutput>
			<cfloop query="rsComponentesAccion">
				objForm.RHDAunidad_#rsComponentesAccion.currentRow#.required = false;
				objForm.RHDAmontores_#rsComponentesAccion.currentRow#.required = false;
			</cfloop>
			</cfoutput>
		<cfelse><!--- Funciones para acciones especiales  --->

			<cfif modo EQ "CAMBIO" and rsTipoAccionComp.RHTcomportam EQ 10>
				objForm.RHAtipo.required 	    = false;
				objForm.RHAdescripcion.required = false;
			<cfelseif modo EQ "CAMBIO" and rsTipoAccionComp.RHTcomportam EQ 11>
				objForm.EVfantig_prop.required = false;
			</cfif>
		</cfif>
	}
	</cfif>

	// Funcion que ejecuta el Tag de Tipos de Accion para pedir la fecha de vencimiento y empresa nueva cuando sean requeridos
	
    <cfif RHTespecial neq 1> <!--- Funciones para acciones normales --->
		function validateControls(val) {
			
	
			var a = document.getElementById("tdFfintxt");
			if (a.style.display == "") {
				objForm.DLffin.required = true;
			} else {
				objForm.DLffin.required = false;
				document.form1.DLffin.value ="";
			}
	
			var b = document.getElementById("trEmpresa");
			
			if (b.style.display == "") {
				objForm.EcodigoRef.required = true;
			} else {
				objForm.EcodigoRef.required = false;
			}
			<cfif #UsaSBC# EQ 1>
			var c = document.getElementById("trIncapacidad");
			if (c.style.display == "") {
				<!---objForm.TipoRiesgo.required = true;--->
				objForm.Folio.required = true;
				objForm.PorcImss.required = true;
			} else {
				objForm.TipoRiesgo.required = false;
				objForm.Folio.required = false;
				objForm.PorcImss.required = false;
				 objForm.PorcImss.validatePorcentajeIMSS();	
			}
	
			</cfif>
		}
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
    <cfif RHTespecial neq 1> <!--- Funciones para acciones normales --->
		_addValidator("isNotCero", __isNotCero);
		_addValidator("isPorcentaje", __isPorcentaje);
		_addValidator("isRangoFechas", __isRangoFechas);
		_addValidator("isVacaciones", __isVacaciones);
		_addValidator("isPorcentajeIMSS", __isPorcentajeIMSS);
		
	</cfif>

	<cfoutput>
	<cfif modo NEQ "ALTA">
		 <cfif RHTespecial neq 1> <!--- Funciones para acciones normales --->
			objForm.Tcodigo.required = true;
			objForm.Tcodigo.description = "#MSG_Tipo_de_Nomina#";
			objForm.RVid.required = true;
			objForm.RVid.description = "#MSG_Regimen_de_Vacaciones#";
			objForm.Ocodigo.required = true;
			objForm.Ocodigo.description = "#MSG_Oficina#";
			objForm.Dcodigo.required = true;
			objForm.Dcodigo.description = "#MSG_Departamento#";
			if (objForm.CodPlaza) {
				objForm.CodPlaza.required = true;
				objForm.CodPlaza.description = "#MSG_Plaza#";
			}
			objForm.RHPcodigo.required = true;
			objForm.RHPcodigo.description = "#MSG_Puesto#";
			objForm.LTporcplaza.required = true;
			objForm.LTporcplaza.description = "#MSG_Porcentaje_de_Plaza#";
			objForm.LTporcplaza.validateNotCero();
			objForm.LTporcplaza.validatePorcentaje();
			objForm.LTporcsal.required = true;
			objForm.LTporcsal.description = "#MSG_Porcentaje_de_Salario_Fijo#";
			objForm.LTporcsal.validateNotCero();
			objForm.LTporcsal.validatePorcentaje();
			objForm.RHJid.required = true;
			objForm.RHJid.description = "#MSG_Jornada#";
			<cfif rsAccion.RHTcomportam EQ 3>
			objForm.RHAvdisf.required = true;
			objForm.RHAvdisf.description = "#MSG_Vacaciones_Disfrutadas#";
			objForm.RHAvdisf.validateVacaciones();
			</cfif>
			<cfif usaEstructuraSalarial EQ 1>
				objForm.RHTTid3.description = "#MSG_Tipo_de_Tabla3#";
				objForm.RHCid3.description = "#MSG_Categoria3#";
				objForm.RHMPPid3.description = "#MSG_Puesto3#";
				<cfif rsTipoAccionComp.RHCatParcial EQ 1>
					objForm.RHTTid4.required = true;
					objForm.RHCid4.required = true;
					objForm.RHMPPid4.required = true;
					objForm.RHTTid4.description = "#MSG_Tipo_de_Tabla4#";
					objForm.RHCid4.description = "#MSG_Categoria4#";
					objForm.RHMPPid4.description = "#MSG_Puesto4#";
				</cfif>
				
			</cfif> 

			<cfloop query="rsComponentesAccion">
				objForm.RHDAunidad_#rsComponentesAccion.currentRow#.required = true;
				objForm.RHDAunidad_#rsComponentesAccion.currentRow#.description = '#MSG_Cantidad_de#' + ' ' +'#rsComponentesAccion.CSdescripcion#';
				objForm.RHDAmontores_#rsComponentesAccion.currentRow#.required = true;
				objForm.RHDAmontores_#rsComponentesAccion.currentRow#.description = '#MSG_Monto_de#'+' '+ "#rsComponentesAccion.CSdescripcion#";
			</cfloop>
			<cfelse><!--- Funciones para acciones especiales  --->

			<cfif modo EQ "CAMBIO" and rsTipoAccionComp.RHTcomportam EQ 10>
				objForm.RHAtipo.description = "#MSG_RHAtipo#";
				objForm.RHAdescripcion.description = "#MSG_RHAdescripcion#";
				objForm.RHAtipo.required 	    = true;
				objForm.RHAdescripcion.required = true;
			<cfelseif modo EQ "CAMBIO" and rsTipoAccionComp.RHTcomportam EQ 11>
				objForm.EVfantig_prop.description = "#MSG_EVfantig_prop#";
				objForm.EVfantig_prop.required = true;
			</cfif>
		</cfif>
	<cfelse>
		<cfif not isdefined("tabChoice")>
		objForm.DEidentificacion.required = true;
		objForm.DEidentificacion.description = "#MSG_Empleado#";
		</cfif>
		<cfif isdefined("form.Jefe")>
		objForm.DEidSub.required = true;
		objForm.DEidSub.description = "#MSG_Empleado#";
		</cfif>
		objForm.RHTcodigo.required = true;
		objForm.RHTcodigo.description = "#MSG_Tipo_de_Accion#";
		objForm.DLfvigencia.required = true;
		objForm.DLfvigencia.description = "#MSG_Fecha_Rige#";
		objForm.DLffin.description = "#MSG_Fecha_Vence#";
		objForm.DLffin.validateRangoFechas();
		objForm.EcodigoRef.description = "#MSG_Nueva_Empresa#";
	</cfif>
	</cfoutput>

	<!--- Carga de un tipo de acción por defecto cuando se esta en la pantalla de Registro de Acciones --->
	<cfif modo EQ "ALTA" and isdefined("rsTipoAccionDef") and not isdefined("tabChoice")>
		hideControls("<cfoutput>#rsTipoAccionDef.RHTpfijo#</cfoutput>", 1, 2);
	<cfelseif modo EQ "ALTA">
		var arrayparams, plazofijo, comportam, cambioempr,riesgo;
		arrayparams = document.form1.RHTcodigo.value.split("|");
		plazofijo   = arrayparams[2];
		comportam   = arrayparams[3];
		cambioempr  = arrayparams[4];
		riesgo 		= arrayparams[5];


		hideControls(plazofijo, 1, 2);
		<!--- SI NO ES CAMBIO DE EMPRESA se oculta el campo de Empresa --->
		<!---if (comportam != '9') {
			hideControls('0', 3);
		} else {
			hideControls(cambioempr, 3);
		}
		if (comportam != '5') {
			hideControls('0', 3);
		} else {
			hideControls(riesgo, 3);
		}--->
		
		<!---2010-03-17
ljimenez se cambion un if por el case ya que se incorporo un nuevo combo 
que se debe de pintar deacuerdo a subcomportamiento de la la accion de incapacidad--->
		switch (comportam)
			{
			case '9':{
				hideControls(cambioempr, 3);
				hideControls('0', 4);
				}
			break;
			case '5':{
				hideControls(riesgo, 4);
				hideControls('0', 3);
				}
			break;
			default:{
				hideControls('0', 3);
				hideControls('0', 4);
				}
			} 


		document.form1.RHTcodigo.value = ""; <!--- para que tome el plazo para la primer accion si es necesario (danim/5/feb/2004) --->
	</cfif>

	<cfif isdefined("form.previo")>
		if(document.form1.DEid){document.form1.DEid.value ="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>"};
		if(document.form1.DEidentificacion){document.form1.DEidentificacion.value ="<cfif isdefined("form.DEidentificacion")><cfoutput>#form.DEidentificacion#</cfoutput></cfif>"};
		if(document.form1.DLffin){document.form1.DLffin.value ="<cfif isdefined("form.DLffin")><cfoutput>#form.DLffin#</cfoutput></cfif>"};
		if(document.form1.DLfvigencia){document.form1.DLfvigencia.value ="<cfif isdefined("form.DLfvigencia")><cfoutput>#form.DLfvigencia#</cfoutput></cfif>"};
		if(document.form1.DLobs){document.form1.DLobs.value ="<cfif isdefined("form.DLobs")><cfoutput>#form.DLobs#</cfoutput></cfif>"};
		if(document.form1.EcodigoRef){document.form1.EcodigoRef.value ="<cfif isdefined("form.EcodigoRef")><cfoutput>#form.EcodigoRef#</cfoutput></cfif>"};
		if(document.form1.NombreEmp){document.form1.NombreEmp.value ="<cfif isdefined("form.NombreEmp")><cfoutput>#form.NombreEmp#</cfoutput></cfif>"};
		if(document.form1.NTIcodigo){document.form1.NTIcodigo.value ="<cfif isdefined("form.NTIcodigo")><cfoutput>#form.NTIcodigo#</cfoutput></cfif>"};
		if(document.form1.RHTcodigo){document.form1.RHTcodigo.value ="<cfif isdefined("form.RHTcodigo")><cfoutput>#form.RHTcodigo#</cfoutput></cfif>"};
		if(document.form1.RHTid){document.form1.RHTid.value ="<cfif isdefined("form.RHTid")><cfoutput>#form.RHTid#</cfoutput></cfif>"};
		if(document.form1.RHTpmax){document.form1.RHTpmax.value ="<cfif isdefined("form.RHTpmax")><cfoutput>#form.RHTpmax#</cfoutput></cfif>"};
		if(document.form1.RHTsubcomportam){document.form1.RHTsubcomportam.value ="<cfif isdefined("form.RHTsubcomportam")><cfoutput>#form.RHTsubcomportam#</cfoutput></cfif>"};
		Asignar(document.form1.RHTcodigo);
	</cfif>
	
/**************************************************************************/


/* ljimenez **************************************************************************/

function ajaxFunction1_ComboRiesgo(){
	var ajaxRequest1;  // The variable that makes Ajax possible!
	var vTipoRiesgo ='';
	var vmodoD 		='';
	vRHTsubcomportam 	=document.form1.RHTsubcomportam.value;
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
	
	ajaxRequest1.open("GET", '/cfmx/rh/nomina/operacion/ComboRiesgo.cfm?xRHTsubcomportam='+vRHTsubcomportam, false);
	ajaxRequest1.send(null);
	document.getElementById("contenedor_Riesgos").innerHTML = ajaxRequest1.responseText;
}
/**************************************************************************/

function ajaxFunction1_ComboConsecuencia(){
	var ajaxRequest1;  // The variable that makes Ajax possible!
	var vTipoRiesgo ='';
	var vmodoD 		='';
	vTipoRiesgo 		= document.form1.TipoRiesgo.value;
	vRHTsubcomportam 	= document.form1.RHTsubcomportam.value;
	
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

	ajaxRequest1.open("GET", '/cfmx/rh/nomina/operacion/ComboConsecuencia.cfm?xTipoRiesgo='+vTipoRiesgo+'&xRHTsubcomportam='+vRHTsubcomportam, false);
	ajaxRequest1.send(null);
	document.getElementById("contenedor_Consecuencia").innerHTML = ajaxRequest1.responseText;
}

/**************************************************************************/



function ajaxFunction1_ComboControlIncapacidad(){
	var ajaxRequest1;  // The variable that makes Ajax possible!
	var vTipoRiesgo ='';
	var vmodoD 		='';
	vConsecuencia 		= document.form1.Consecuencia.value;
	vTipoRiesgo 		= document.form1.TipoRiesgo.value;
	vRHTsubcomportam 	= document.form1.RHTsubcomportam.value;

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

	ajaxRequest1.open("GET", '/cfmx/rh/nomina/operacion/ComboControlInacapacidad.cfm?xConsecuencia='+vConsecuencia+'&xTipoRiesgo='+vTipoRiesgo+'&xRHTsubcomportam='+vRHTsubcomportam, false);
	ajaxRequest1.send(null);
	document.getElementById("contenedor_ControlIncapacidad").innerHTML = ajaxRequest1.responseText;
}


</script>
</cfif>