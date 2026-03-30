<cftransaction>
	<cfif isdefined('form.Alta')>
		<!--- INSERTA UNA NUEVA EXCEPCION PARA CALCULO DE CARGAS --->
		<cfquery name="InsertExecp" datasource="#session.DSN#">
			insert into DCTDeduccionExcluir(DClinea,CIid,BMfecha,BMUsucodigo)
			values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
		</cfquery>
	<cfelseif isdefined('form.Eliminar')>
		<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
		<cfinvokeargument  name="nombreTabla" value="DCTDeduccionExcluir">		
			<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
			<cfinvokeargument name="condicion" value="DClinea = #form.DClinea# and CIid = #form.CIidL#">
			<cfinvokeargument name="necesitaTransaccion" value="false">
		</cfinvoke>
		<!--- ELIMINA UNA EXCEPCION PARA CALCULO DE CARGAS --->
		<cfquery name="DeleteExcep" datasource="#session.DSN#">
			delete from DCTDeduccionExcluir
			where DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
			  and CIid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIidL#">
		</cfquery>
	</cfif>
</cftransaction>
<!--- Parámetros para volver a la pantalla principal --->
<cflocation url="Provisiones.cfm?ECid=#Form.ECid#&DClinea=#Form.DClinea#">
