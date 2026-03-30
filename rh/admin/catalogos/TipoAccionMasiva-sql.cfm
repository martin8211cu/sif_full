<cfif not isdefined("form.btnNuevo")>
	<!--- Inserción a la tabla RHTAccionMasiva --->
	<cfif isdefined("form.Alta")>
		<cftransaction>
		
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into RHTAccionMasiva ( RHTid, RHTAcodigo, PCid, RHTAdescripcion, Ecodigo, RHTAcomportamiento, 
										RHTAaplicaauto, RHTAcempresa, RHTActiponomina, RHTAcregimenv, RHTAcoficina, RHTAcdepto, 
										RHTAcplaza, RHTAcpuesto, RHTAccomp, RHTAcsalariofijo, RHTAccatpaso, RHTAcjornada, RHTAidliquida, 
										RHTAevaluacion, RHTAnotaminima, RHTAperiodos, RHTAfutilizap, BMUsucodigo,RHTArespetarLT,RHTAanualidad)
				values ( <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#form.RHTAcodigo#" cfsqltype="cf_sql_varchar">,
						 <cfif isdefined("form.RHTAevaluacion") and isdefined("form.PCid") and len(trim(form.PCid))>
						 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
						 <cfelse>
							null
						 </cfif>,
						 <cfqueryparam value="#form.RHTAdescripcion#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfif isdefined("Form.RHTAcomportamiento") and Len(Trim(Form.RHTAcomportamiento))>
							 <cfqueryparam value="#form.RHTAcomportamiento#" cfsqltype="cf_sql_numeric">,
						 <cfelse>
						 	 null,
						 </cfif>
						 <cfif isdefined("form.RHTAaplicaauto")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAcempresa")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTActiponomina")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAcregimenv")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAcoficina")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAcdepto")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAcpuesto")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAcpuesto")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAccomp")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAcsalariofijo")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAccatpaso")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAcjornada")>1<cfelse>0</cfif>,		
						 <cfif isdefined("form.RHTAidliquida")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAevaluacion")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAevaluacion") and isdefined("form.RHTAnotaminima")>
							 <cfqueryparam value="#form.RHTAnotaminima#" cfsqltype="cf_sql_integer">
						 <cfelse>
							 0
						 </cfif>,
						 <cfif isdefined("form.RHTAperiodos")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.RHTAperiodos") and isdefined("form.RHTAfutilizap")>
							 <cfqueryparam value="#form.RHTAfutilizap#" cfsqltype="cf_sql_integer">
						 <cfelse>
							 0
						 </cfif>,
						 <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
						 <cfif isdefined("form.RHTArespetarLT")>1<cfelse>0</cfif> ,
						<cfif isdefined("form.RHTAanualidad")>1<cfelse>0</cfif> 
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 name="rsInsert" datasource="#Session.DSN#">
			<cfset Form.RHTAid = rsInsert.identity>
		</cftransaction>
	
	<cfelseif isdefined("form.Cambio") and isdefined("Form.RHTAid") and Len(Trim(Form.RHTAid))>
		<cfif not isdefined("form.RHTAccomp")>
			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
				<cfinvokeargument  name="nombreTabla" value="RHComponentesTAccionM">		
				<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
				<cfinvokeargument name="condicion" value="RHTAid = #Form.RHTAid#">
			</cfinvoke>
			
			<cfquery name="rsDel" datasource="#Session.DSN#">
				delete from RHComponentesTAccionM
				where RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">
			</cfquery>
		</cfif>
		
		<cfquery name="rsUpd" datasource="#Session.DSN#">
			update RHTAccionMasiva set
				 RHTid = <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric">,
				 RHTAcodigo = <cfqueryparam value="#form.RHTAcodigo#" cfsqltype="cf_sql_varchar">,
				 <cfif isdefined("form.RHTAevaluacion") and isdefined("form.PCid") and len(trim(form.PCid))>
					PCid = <cfqueryparam value="#form.PCid#" cfsqltype="cf_sql_numeric">
				 <cfelse>
					PCid = null
				 </cfif>,
				 RHTAdescripcion = <cfqueryparam value="#form.RHTAdescripcion#" cfsqltype="cf_sql_varchar">,
				 <cfif isdefined("Form.RHTAcomportamiento") and Len(Trim(Form.RHTAcomportamiento))>
					 RHTAcomportamiento = <cfqueryparam value="#form.RHTAcomportamiento#" cfsqltype="cf_sql_numeric">,
				 <cfelse>
				 	 RHTAcomportamiento = null,
				 </cfif>
				 <!---
				 <cfif isdefined("rsComportamCambio.RHTcomportam") and rsComportamCambio.RHTcomportam EQ 8>
				 	RHTAaplicaauto = 1
				 <cfelse>
				 	RHTAaplicaauto = <cfif isdefined("form.RHTAaplicaauto")>1<cfelse>0</cfif>
				 </cfif>,			
				 --->
				 RHTAaplicaauto = <cfif isdefined("form.RHTAaplicaauto")>1<cfelse>0</cfif>,
				 RHTAcempresa = <cfif isdefined("form.RHTAcempresa")>1<cfelse>0</cfif>,
				 RHTActiponomina = <cfif isdefined("form.RHTActiponomina")>1<cfelse>0</cfif>,
				 RHTAcregimenv = <cfif isdefined("form.RHTAcregimenv")>1<cfelse>0</cfif>,
				 RHTAcoficina = <cfif isdefined("form.RHTAcoficina")>1<cfelse>0</cfif>,
				 RHTAcdepto = <cfif isdefined("form.RHTAcdepto")>1<cfelse>0</cfif>,
				 RHTAcplaza = <cfif isdefined("form.RHTAcpuesto")>1<cfelse>0</cfif>,
				 RHTAcpuesto = <cfif isdefined("form.RHTAcpuesto")>1<cfelse>0</cfif>,
				 RHTAccomp = <cfif isdefined("form.RHTAccomp")>1<cfelse>0</cfif>,
				 RHTAcsalariofijo = <cfif isdefined("form.RHTAcsalariofijo")>1<cfelse>0</cfif>,
				 RHTAccatpaso = <cfif isdefined("form.RHTAccatpaso")>1<cfelse>0</cfif>,
				 RHTAcjornada = <cfif isdefined("form.RHTAcjornada")>1<cfelse>0</cfif>,		
				 RHTAidliquida = <cfif isdefined("form.RHTAidliquida")>1<cfelse>0</cfif>,
				 RHTAevaluacion = <cfif isdefined("form.RHTAevaluacion")>1<cfelse>0</cfif>,
				 RHTAanualidad=<cfif isdefined("form.RHTAanualidad")>1<cfelse>0</cfif> ,
				 <cfif isdefined("form.RHTAevaluacion") and isdefined("form.RHTAnotaminima")>
					 RHTAnotaminima = <cfqueryparam value="#form.RHTAnotaminima#" cfsqltype="cf_sql_integer">
				 <cfelse>
					 RHTAnotaminima = 0
				 </cfif>,
				 RHTAperiodos = <cfif isdefined("form.RHTAperiodos")>1<cfelse>0</cfif>,
				 <cfif isdefined("form.RHTAperiodos") and isdefined("form.RHTAfutilizap")>
					 RHTAfutilizap = <cfqueryparam value="#form.RHTAfutilizap#" cfsqltype="cf_sql_integer">
				 <cfelse>
					 RHTAfutilizap = 0
				 </cfif>,
				 BMUsucodigo = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
				 RHTArespetarLT = <cfif isdefined("form.RHTArespetarLT")>1<cfelse>0</cfif>
			where RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">
		</cfquery>
	
	<cfelseif isdefined("Form.Baja") and isdefined("Form.RHTAid") and Len(Trim(Form.RHTAid))>
	
		<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
			<cfinvokeargument  name="nombreTabla" value="RHComponentesTAccionM">		
			<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
			<cfinvokeargument name="condicion" value="RHTAid = #Form.RHTAid#">
		</cfinvoke>
			
		<cfquery name="rsDel" datasource="#Session.DSN#">
			delete from RHComponentesTAccionM
			where RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">
		</cfquery>
		
		<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
			<cfinvokeargument  name="nombreTabla" value="RHTAccionMasiva">		
			<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
			<cfinvokeargument name="condicion" value="RHTAid = #Form.RHTAid#">
		</cfinvoke>

		<cfquery name="rsDel" datasource="#Session.DSN#">
			delete from RHTAccionMasiva
			where RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">
		</cfquery>
	
	<!--- ALTA y BAJA DE COMPONENTES --->
	<cfelseif isdefined("Form.RHTAid") and Len(Trim(Form.RHTAid)) and isdefined("Form.CTAMAccion")>
		<!--- Alta de Componentes Salariales --->
		<cfif Form.CTAMAccion EQ "ALTA">
			<cfif isdefined("form.RHTAccomp")>
				<cfquery name="updComponente" datasource="#Session.DSN#">
					update RHTAccionMasiva set
					RHTAccomp = 1
					where RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">
				</cfquery>
			</cfif>
			
			<cfquery name="insComponente" datasource="#Session.DSN#">
				insert into RHComponentesTAccionM (RHTAid, CSid, RHTCAMagregam, RHTCAMelimina, Ecodigo, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">, 
					<cfif Form.RHTCAMaccion EQ 1>1<cfelse>0</cfif>, 
					<cfif Form.RHTCAMaccion EQ 2>1<cfelse>0</cfif>, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>
			
		<cfelseif Form.CTAMAccion EQ "BAJA" and isdefined("Form.RHTCAMid") and Len(Trim(Form.RHTCAMid))>

			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
				<cfinvokeargument  name="nombreTabla" value="RHComponentesTAccionM">		
				<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
				<cfinvokeargument name="condicion" value="RHTAid = #Form.RHTAid#">
			</cfinvoke>
			
			<cfquery name="delComponente" datasource="#Session.DSN#">
				delete from RHComponentesTAccionM
				where RHTCAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTCAMid#">
				and RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTAid#">
			</cfquery>
		</cfif>
		
	</cfif>
</cfif>

<cfset params = "">
<cfif isdefined("Form.RHTAid") and Len(Trim(Form.RHTAid)) and not isdefined("Form.Baja") and not isdefined("Form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "RHTAid=" & Form.RHTAid>
</cfif>
<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum_lista>
</cfif>
<cfif isdefined("form.fRHTAcodigo") and len(trim(form.fRHTAcodigo))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "fRHTAcodigo=" & Form.fRHTAcodigo>
</cfif>
<cfif isdefined("form.fRHTAdescripcion") and len(trim(form.fRHTAdescripcion))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "fRHTAdescripcion=" & Form.fRHTAdescripcion>
</cfif>
<cflocation url="TipoAccionMasiva.cfm#params#">
