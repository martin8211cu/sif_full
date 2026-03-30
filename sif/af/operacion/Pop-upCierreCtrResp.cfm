<!---				
	2:              No existen Saldos al momento de aplicación
	3:              No se Encuentra en la bitácora
	4:              El Activo está retirado 
	8:              No Existe el Vale a la fecha
	5:   (2+3)      No hay Saldos y no hay Bitácora
	6:   (2+4)      No Hay Saldos y el Activo está retirado
	7:   (3+4)      No se encuentra en la bitácora y está retirado
	8:    			No Existe el Documento de Responsabilidad a la fecha
	9:   (2+3+4)    No hay Saldos, No hay bitácora, está retirado
	10:  (2+8)      No hay Saldos, no hay vale
	11:  (3+8)      No se encuentra en la bitácora y no existe vale a la fecha
	12:  (4+8)      El Activo está retirado y no existe vale a la fecha
	13:  (2+3+8)    No hay Saldos, no está en la bitácora y no existe el vale, No Existe el Vale a la fecha
	14:  (2+4+8)    No existen Saldos al momento de aplicación, El Activo está retirado, 
	15:  (3+4+8)    No existe vale, El activo está retirado y no se encontro registro en la bitácora
	17:  (2+3+4+8)  No existe saldo, no existe bitácora, está retirado y no hay vale a la fecha
	18:   			Error al realizar el retiro
	19:				Error al realizar el traslado
--->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Error en Control de Transacciones'>
<cfquery name="rssql" datasource="#session.dsn#">
	select a.CRCTid, a.CRBid,a.Ecodigo,a.Type,  a.Aid, a.CRCestado, 
	  (select b.Aplaca #_Cat# b.Adescripcion  from Activos b where b.Aid = a.Aid ) Activo
	from CRColaTransacciones a
	where a.CRCTid = #url.CRCTid#
</cfquery>
<cfset error= "">
<cfif ListFind('2,5,6,9,10,13,14,17', rssql.CRCestado)>
	<cfset error= error & "No existen Saldos al momento de aplicación<br>">
</cfif>
<cfif ListFind('3,3,9,11,13,15', rssql.CRCestado)>
	<cfset error= error & "No se Encuentra en la bitácora de transacciones<br>">
</cfif>
<cfif ListFind('4,6,7,9,12,14,15,17', rssql.CRCestado)>
	<cfset error= error & " El Activo está retirado <br>">
</cfif>
<cfif ListFind('8,10,11,12,13,14,15,17', rssql.CRCestado)>
	<cfset error= error & "No Existe el Documento de Responsabilidad a la fecha<br>">
</cfif>
<cfif rssql.CRCestado EQ 18 and rssql.Type EQ 1>
	<cftransaction> 
		<cftry>
			<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaRelacion" returnvariable="llave">
					<cfinvokeargument name="AGTPdescripcion"   value="Retiros de Activos por Control de Responsables">
					<cfinvokeargument name="RetiroCR"          value="true">
					<cfinvokeargument name="TransaccionActiva" value="true">
			</cfinvoke>	
			<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaActivo" returnvariable="LvarResultado">
					<cfinvokeargument name="AGTPid" 		   value="#llave#">
					<cfinvokeargument name="Aid"    		   value="#rssql.Aid#">
					<cfinvokeargument name="TransaccionActiva" value="true">
					<cfinvokeargument name="CRCTid" 		   value="#rssql.CRCTid#">
			</cfinvoke>
				<cfcatch type="any">
				<cfset error= error & "#cfcatch.Message#<br> #cfcatch.detail#<br>">
			</cfcatch>
		</cftry>
	<cftransaction action="rollback">
	</cftransaction>
</cfif>
<cfif rssql.CRCestado EQ 19 and rssql.Type EQ 2>
			<cftry>	
				<cfinvoke component="sif.Componentes.AF_CambioResponsable" method="SoloContabilizar">
					<cfinvokeargument name="CRBid" 		value="#rssql.CRBid#">
					<cfinvokeargument name="Ecodigo" 	value="#rssql.Ecodigo#">
					<cfinvokeargument name="Usucodigo" 	value="#session.Usucodigo#">
					<cfinvokeargument name="Conexion" 	value="#session.DSN#">
					<cfinvokeargument name="Debug" 		value="true">		
				</cfinvoke>
				<cfcatch type="any">
					<cfset error= error & "#cfcatch.Message#<br>#cfcatch.detail#<br>">
				</cfcatch>	
			</cftry>
</cfif>
<cfif error EQ "">
	<cfset error= error & "El Activo no Posse Errores Controlados">
</cfif>

<cfoutput>
  <div align="center"><strong>#rssql.Activo#</strong><br /></div>
  <div align="left"><strong>Errores:</strong><br/></div>
  <div align="left">#error#</div>
</cfoutput>
<cf_web_portlet_end>

<table align="center">
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><input type="button" name="btnclose" class="btnNormal" value="Cerrar" onClick="javascript:window.close()"></td></tr>
</table>
