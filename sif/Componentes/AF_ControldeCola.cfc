<!---
Estados del Parámetro 970 - Control de Transacciones provenientes de AF.
	0. Control Desactivado => Indica que las transacciones de CR se aplicarán directo a AF y Conta.
	1. Control Activado    => Indica que las transacciones de CR se quedaran en cola
	2. Cola procesado      => Indica que hay transaccioens en cola en proceso de aplicación a AF y Conta
	No Existe.             => AF Abierto (Las transacciones que vienen desde CR se aplican)

Se procesa la cola de transacciones de activos, originadas en Control de Responsables cuando el control de transacciones esta activado.
			1. Se verifica el parametro 970 (Control de Transacciones)
			2. Si el parámetro es 2 (Procesar Cola) se inicia el procesamiento
			3. Si el parámetro es 1 (AF Cerrado) o 0 (AF Abierto) no se hace nada
--->
<cfcomponent> 
<cffunction name="ProcesarCola" access="public" returntype="numeric" output="yes">
	<cfargument name="Ecodigo"   type="numeric" required="no"    default="#Session.Ecodigo#">
	<cfargument name="DSN" 		 type="string"  required="false" default="#Session.Dsn#">
	<cfargument name="Usucodigo" type="numeric" required="no"	 default="0" >
	<cfargument name="Debug" 	 type="boolean" required="no"	 default="false">		
	
	<cfset res=0> 
	<cfquery datasource="#Arguments.DSN#" name="ValorParam">
		Select Pvalor 
		   from Parametros 
		where Pcodigo = 970 
		  and Ecodigo = #Arguments.Ecodigo#
	</cfquery>
	
	<cfif ValorParam.recordcount gt 0 and ValorParam.Pvalor eq 2>
		<!--- Validacion para ver si la cola se esta procesando en este momento --->
		<cfquery name="rsColaEnProceso" datasource="#Arguments.DSN#">
			Select count(1) as total
			 from CRColaTransacciones
			where Ecodigo = #Arguments.Ecodigo#
			  and CRCestado = 1
		</cfquery>
		
		<cfif rsColaEnProceso.total gt 0>
			<cf_errorCode	code = "50931" msg = "La Cola se encuentra procesando transacciones en este momento. Proceso Cancelado">
		</cfif>
		
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="LvarPeriodo"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux" 	returnvariable="LvarMes"/>

		<!---<cflock name="BanderaProcesarColaAF#arguments.Ecodigo#" timeout="5" type="exclusive">	
			<cfif not isdefined("Application.BanderaProcesarColaAF#arguments.Ecodigo#")>
				<cfset Application.BanderaProcesarColaAF#arguments.Ecodigo# = false>
			</cfif>
			<cfif Application.BanderaProcesarColaAF#arguments.Ecodigo#>
				<cfreturn false>
			</cfif>
			<cfset Application.BanderaProcesarColaAF#arguments.Ecodigo# = true>	
		</cflock>--->
	
		<cfset res=ProcesarColaPrivate(Arguments.Ecodigo, Arguments.DSN, Arguments.Usucodigo, Arguments.Debug, LvarPeriodo, LvarMes)>

		<cfif res>
			<cfset Msg="El Control de Transacciones de Activos Fijos se ha Desactivado con Exito">
			
			<cfquery datasource="#Arguments.DSN#">
				UPDATE Parametros 
				set Pvalor = '0'
				where Pcodigo=970 
				  and Ecodigo = #Arguments.Ecodigo#	
				  and Pvalor = '2'
			</cfquery>
			<script language="javascript" type="text/javascript">
				<cfoutput>alert("#Msg#");</cfoutput>
			</script>
		</cfif>
	</cfif>
	<!---<cflock name="ProcesaColaAF#arguments.ecodigo#" timeout="5" type="exclusive">	
		<cfset application.BanderaProcesarColaAF#arguments.ecodigo# = false>	
	</cflock>--->

	<cfreturn res>
</cffunction>

<cffunction name="ProcesarColaPrivate" access="private" returntype="numeric" output="no">
	<cfargument name="Ecodigo" default="#Session.Ecodigo#" required="no" type="numeric">
	<cfargument name="DSN" 			type="string" 	required="false" default="#Session.Dsn#">
	<cfargument name="Usucodigo" 	type="numeric" 	required="no"	 default="0" >
	<cfargument name="Debug" 		type="boolean"	required="no"	  default="false"  >
	<cfargument name="Periodo" 		type="numeric" 	required="yes">
	<cfargument name="Mes"     		type="numeric"  required="yes">
		
	<!--- 
		Ordenamiento en la cola de transacciones a procesar.  
			Primero deben de procesarse los traslados para evitar errores de Traslado - Retiro
			Una vez procesdos los traslados (Type = 2) se procesan los Retiros (Type = 1) en orden de la Relacion
	--->
	
	<cfquery name="rsProcesarCola" datasource="#Arguments.DSN#">
		Select a.CRCTid, a.Relacion, a.Aid, a.Type, a.CRBid, a.CRCestado
		from CRColaTransacciones a
		where a.Ecodigo = #Arguments.Ecodigo#
		order by a.Type desc, a.Relacion, a.CRCTid
	</cfquery>
	<cfset Nrel   =  0>
	<cfset llave  = -1>
	<cfset LvarPeriodo = Arguments.Periodo>
	<cfset LvarMes     = Arguments.Mes>

	<cfloop query="rsProcesarCola">

		<cfset LvarResultado = 0>
		<cfset LvarTipoError = 0>

		<cfset LvarCRCTid    = rsProcesarCola.CRCTid>
		<cfset LvarCRBid     = rsProcesarCola.CRBid>
		<cfset LvarRelacion  = rsProcesarCola.Relacion>
		<cfset LvarAid       = rsProcesarCola.Aid>
		<cfset LvarType      = rsProcesarCola.Type>
		
<!---			<cfset LvarCRCestado = rsProcesarCola.CRCestado> --->
	
				
		<!--- Validar los posibles errores en la columna CRCestado correspondiente.  Si se presenta un error, no se procesa el registro de la cola y se continúa con los siguientes:
			Los posibles errores son:
				2:              No existen Saldos al momento de aplicación
				3:              No se Encuentra en la bitácora
				4:              El Activo está retirado 
				8:              No Existe el Vale a la fecha
				5:   (2+3)      No hay Saldos y no hay Bitácora
				6:   (2+4)      No Hay Saldos y el Activo está retirado
				7:   (3+4)      No se encuentra en la bitácora y está retirado
				9:   (2+3+4)    No hay Saldos, No hay bitácora, está retirado
				10:  (2+8)      No hay Saldos, no hay vale
				11:  (3+8)      No se encuentra en la bitácora y no existe vale a la fecha
				12:  (4+8)      El Activo está retirado y no existe vale a la fecha
				13:  (2+3+8)    No hay Saldos, no está en la bitácora y no existe el vale
				15:  (3+4+8)    No existe vale, El activo está retirado y no se encontro registro en la bitácora
				17:  (2+3+4+8)  No existe saldo, no existe bitácora, está retirado y no hay vale a la fecha
				18:   			Error al realizar el retiro
				19:				Error al realizar el traslado
		--->

		<cfquery name="rsVerificaSaldos" datasource="#Arguments.DSN#">
			select AFSvaladq, AFSvalmej, AFSvalrev
			from AFSaldos
			where Aid        = #LvarAid#
			  and AFSperiodo = #LvarPeriodo#
			  and AFSmes     = #LvarMes#
		</cfquery>

		<cfquery name="rsBitacora" datasource="#Arguments.DSN#">
			select b.AFRmotivo, b.Razon, b.CRCCcodigo
			from CRBitacoraTran b
			where b.CRBid   = #LvarCRBid#
			  and b.Ecodigo = #Arguments.Ecodigo#
		</cfquery>

		<cfquery name="rsVerificaRetiro" datasource="#Arguments.DSN#">
			select Astatus
			from Activos
			where Aid = #LvarAid#
		</cfquery>
	
		<cfquery name="rsVerificaVale" datasource="#Arguments.DSN#">
			select count(1) as Cantidad
			from AFResponsables
			where Aid     = #LvarAid#
			  and Ecodigo = #Arguments.Ecodigo#
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between AFRfini and AFRffin
		</cfquery>

		<cfif rsVerificaSaldos.recordcount NEQ 1 or (rsVerificaSaldos.AFSvaladq EQ 0 and rsVerificaSaldos.AFSvalmej EQ 0 and rsVerificaSaldos.AFSvalrev EQ 0)>
			<cfset LvarTipoError = LvarTipoError + 2>
			<cfset LvarType      = -1> 
		</cfif>
				
		<cfif rsBitacora.recordcount NEQ 1>
			<cfset LvarTipoError = LvarTipoError + 3>
			<cfset LvarType      = -1>
		</cfif>

		<cfif rsVerificaRetiro.recordcount NEQ 1 or rsVerificaRetiro.Astatus EQ 60>
			<cfset LvarTipoError = LvarTipoError + 4> 
			<cfset LvarType      = -1>
		</cfif>

		<cfif rsVerificaVale.Cantidad NEQ 1>
			<cfset LvarTipoError = LvarTipoError + 8>
			<cfset LvarType      = -1> 
		</cfif>

		<cfif rsBitacora.recordcount EQ 1>
			<cfset LvarAFRmotivo  = rsBitacora.AFRmotivo>
			<cfset LvarRazon      = rsBitacora.Razon>
			<cfset LvarCRCCcodigo = rsBitacora.CRCCcodigo>
		</cfif>

		<cfif LvarTipoError EQ 0>
			<!--- Indicar que el activo está siendo procesado:  LvarTipoError es 1 --->
			<cfset LvarTipoError = 1>
		</cfif>

		<cfset fnMarcaTipoError (Arguments.Ecodigo, LvarCRCTid, Arguments.DSN, LvarTipoError)>

		<cfif LvarType eq 1 and (Nrel neq LvarRelacion or llave eq -1)>
			<!--- Retiros: Se le agrega a la descripcion del Retiro el código del centro de custodia --->
			<cfset Nrel = LvarRelacion>
			<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaRelacion" returnvariable="llave">
				<cfinvokeargument name="AGTPdescripcion" value="Retiros de Activos por Control de Responsables">
				<cfinvokeargument name="AFRmotivo" value="#LvarAFRmotivo#">
				<cfinvokeargument name="AGTPrazon" value="#LvarRazon#">
				<cfinvokeargument name="RetiroCR"  value="true">
				<cfinvokeargument name="TransaccionActiva" value="true">
				<cfinvokeargument name="Conexion"  value="#Arguments.DSN#">
				<cfinvokeargument name="Ecodigo"   value="#Arguments.Ecodigo#">
				<cfinvokeargument name="Usucodigo" value="#Arguments.Usucodigo#">
			</cfinvoke>	
			<!--- Se marca la relacion para que cuando el retiro llegue a AF, se vea como que viene de un sistema externo --->	
			<cfquery name="valida1" datasource="#Arguments.DSN#">
				Update AGTProceso 
				set AGTPexterno = 1
				where Ecodigo = #Arguments.Ecodigo# 
				  and AGTPid = #llave#
			</cfquery>
		</cfif>

		<cfif LvarType GT 0>

				<cfif LvarType eq 1>   <!--- Retiros --->
					<cfset RazonDet = #LvarRazon# & " - CC: " & #LvarCRCCcodigo#>
					<cftry>
						<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaActivo" returnvariable="LvarResultado">
							<cfinvokeargument name="AGTPid" 		   value="#llave#">
							<cfinvokeargument name="ADTPrazon" 		   value="#RazonDet#">
							<cfinvokeargument name="Aid" 			   value="#LvarAid#">
							<cfinvokeargument name="TransaccionActiva" value="false">
							<cfinvokeargument name="Conexion"          value="#Arguments.DSN#">
							<cfinvokeargument name="Ecodigo"           value="#Arguments.Ecodigo#">
							<cfinvokeargument name="Usucodigo"         value="#Arguments.Usucodigo#">
							<cfinvokeargument name="CRCTid"            value="#LvarCRCTid#">
						</cfinvoke>
						<cfcatch type="any">
							<cfset fnMarcaTipoError (Arguments.Ecodigo, LvarCRCTid, Arguments.DSN, 18)>
						</cfcatch>	
					</cftry>	
				</cfif>

				<cfif LvarType eq 2>   <!--- Traslados --->
					<cftry>
						<cfinvoke component="sif.Componentes.AF_CambioResponsable" method="SoloContabilizar" returnvariable="LvarResultado">
							<cfinvokeargument name="CRBid" value="#LvarCRBid#">
							<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#">
							<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
							<cfinvokeargument name="Conexion" value="#Arguments.DSN#">				
						</cfinvoke>
						<cfcatch type="any">
							<cfset fnMarcaTipoError (Arguments.Ecodigo, LvarCRCTid, Arguments.DSN, 19)>
						</cfcatch>	
					</cftry>		
				</cfif>

				<!--- Solo se borran los registros si el tipo de error indicado es 1, para dejar en la cola los registros con error --->
				<cfquery datasource="#Arguments.DSN#">
					delete from CRColaTransacciones
					where CRCTid    = #LvarCRCTid#
					  and Ecodigo   = #Arguments.Ecodigo#
					  and CRCestado = 1
				</cfquery>
				

		</cfif>
	</cfloop>
	<cfreturn true>
</cffunction>

<cffunction name="fnMarcaTipoError" output="no" access="private">
	<cfargument name="Ecodigo"    type="numeric" required="yes">
	<cfargument name="CRCTid"     type="numeric" required="yes">
	<cfargument name="DSN"        type="string"  required="yes">
	<cfargument name="TipoError"  type="numeric" required="yes">
	
	<!--- 
		Marca el registro a procesar en status de error ( segun el tipo ) para que lo pueda reprocesar posteriormente, 
		ya que no hay transaccion en este punto del proceso 
	--->
	<cfquery datasource="#Arguments.DSN#">
		UPDATE CRColaTransacciones
		set CRCestado = #Arguments.TipoError#
		where CRCTid  = #Arguments.CRCTid#
		  and Ecodigo = #Arguments.Ecodigo#
	</cfquery>
</cffunction>


</cfcomponent>


