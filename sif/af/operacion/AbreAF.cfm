<!--- Abre de nuevo AF --->
<cfquery datasource="#Session.DSN#">
UPDATE Parametros
set Pvalor = 0
where Pcodigo=970 
  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">	
</cfquery>


<!--- Cambia el estado del parámetro al valor contrario --->
<cfquery datasource="#Session.DSN#" name="ValorParam">
Select Pvalor 
from Parametros 
where Pcodigo=970 
  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
</cfquery>

<cfif ValorParam.recordcount gt 0>

	<!--- Si el parámetro existe y es cero debe dispararse la cola --->

	<cfset nuevo_valor = ValorParam.Pvalor>
	
	<!--- Si el parámetro se pone en 0, es porque el usuario decidió abrir 
		  AF de nuevo por lo tanto se activa el procesamiento de la cola de 
		  procesos
	--->
	<cfif nuevo_valor eq 0>
	
		<!--- Consulta la cola --->
		<cfquery name="rsProcesaCola" datasource="#session.dsn#">
		Select a.CRCTid, b.AFRmotivo, b.Razon, a.Relacion, b.CRCCcodigo, a.Aid, a.Type, a.CRBid
		from CRColaTransacciones a
				inner join CRBitacoraTran b
					 on a.CRBid = b.CRBid
					and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		Order by CRCTid
		</cfquery>
		
		<cfset llaves_borrar = "">
		<cfloop query="rsProcesaCola">
			<cfif llaves_borrar eq "">
				<cfset llaves_borrar = rsProcesaCola.CRCTid>
			<cfelse>
				<cfset llaves_borrar = llaves_borrar & "," & rsProcesaCola.CRCTid>
			</cfif>
		</cfloop>
		
		<cfloop query="rsProcesaCola">
		
			<!--- Retiros --->
			<cfif rsProcesaCola.Type eq 1>
			
			
				<!--- Se le agrega a la descripcion del Retiro el código del centro de custodia --->
				<cfset DescripRetiro = "Retiro Realizado desde control de responsables">
				<cfset Nrel="">
				
					<cfif Nrel neq rsProcesaCola.Relacion>
				
						<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaRelacion"
								returnvariable="rsResultadosRA">
							<cfinvokeargument name="AGTPdescripcion" value="#DescripRetiro#">
							<cfinvokeargument name="AFRmotivo" value="#rsProcesaCola.AFRmotivo#">
							<cfinvokeargument name="AGTPrazon" value="#rsProcesaCola.Razon#">
							<cfinvokeargument name="RetiroCR" value="true">
							<cfinvokeargument name="TransaccionActiva" value="true">
						</cfinvoke>	
						
						<cfset llave = rsResultadosRA>
					
						<!--- Se marca la relacion para que cuando el retiro llegue a AF, se vea como que viene de un sistema externo --->	
						<cfquery name="valida1" datasource="#session.dsn#">
							Update AGTProceso 
							set AGTPexterno = 1
							where Ecodigo = #session.Ecodigo# 
							  and AGTPid = #llave#
						</cfquery>	
						
						<cfset Nrel = rsProcesaCola.Relacion>
					
					</cfif>
							
					<cfset RazonDet = #Razon# & " - CC: " & #rsProcesaCola.CRCCcodigo#>
					
					<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaActivo"
							returnvariable="rsResultadosRA">
						<cfinvokeargument name="AGTPid" value="#llave#">
						<cfinvokeargument name="ADTPrazon" value="#RazonDet#">
						<cfinvokeargument name="Aid" value="#rsProcesaCola.Aid#">
						<cfinvokeargument name="TransaccionActiva" value="true">
					</cfinvoke>	
					<cfset llave2 = rsResultadosRA>
				
			
	
			<cfelseif rsProcesaCola.Type eq 2>
			
				<!--- Traslados --->			
				<cfinvoke component="sif.Componentes.AF_CambioResponsable" method="SoloContabilizar"
						returnvariable="rsResultadosRA">
					<cfinvokeargument name="CRBid" value="#rsProcesaCola.CRBid#">
					<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
					<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
					<cfinvokeargument name="Conexion" value="#Session.Dsn#">
				</cfinvoke>
			
			</cfif>
		
		</cfloop>
		
		<cfif llaves_borrar neq "">
		
			<cfquery name="rsBorraCola" datasource="#session.dsn#">
			Delete from CRColaTransacciones where CRCTid in (#llaves_borrar#)
			</cfquery>
		
		</cfif>
	
	</cfif>

</cfif>
