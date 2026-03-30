<cfif isdefined("Form.Alta")>
	<cfparam name="Form.CSid" type="numeric">
	<cfparam name="Form.PAGENUM" type="numeric" default="1">
	<cfparam name="Form.RHMCfecharige" type="string">
	<cfparam name="Form.RHMCcomportamiento" type="numeric">
	<cfparam name="Form.RHMCtopeporc" type="numeric">
	<cfparam name="Form.RHMCindicador" type="string">
	<cfparam name="Form.RHMCvalor" type="numeric" default="0.00">
	<cfparam name="Form.RHPcodigo" type="string" default="">
<cfelseif isdefined("Form.Cambio")>
	<cfparam name="Form.RHMCid" type="numeric">
	<cfparam name="Form.CSid" type="numeric">
	<cfparam name="Form.PAGENUM" type="numeric" default="1">
	<cfparam name="Form.PageNum_data" type="numeric" default="1">
	<cfparam name="Form.RHMCfecharige" type="string">
	<cfparam name="Form.RHMCcomportamiento" type="numeric">
	<cfparam name="Form.RHMCtopeporc" type="numeric">
	<cfparam name="Form.RHMCindicador" type="string">
	<cfparam name="Form.RHMCvalor" type="numeric" default="0.00">
	<cfparam name="Form.RHPcodigo" type="string" default="">
	<cfparam name="Form.ts_rversion" type="string">
<cfelseif isdefined("Form.Aplicar") or isdefined("Form.Duplicar")>
	<cfparam name="Form.RHMCid" type="numeric">
	<cfparam name="Form.CSid" type="numeric">
	<cfparam name="Form.PAGENUM" type="numeric" default="1">
	<cfparam name="Form.PageNum_data" type="numeric" default="1">
<cfelseif isdefined("Form.Baja")>
	<cfparam name="Form.RHMCid" type="numeric">
	<cfparam name="Form.CSid" type="numeric">
	<cfparam name="Form.PAGENUM" type="numeric" default="1">
</cfif>

<cfif isdefined("Form.Alta") or isdefined("Form.Cambio")>
	<!--- Categoría Puesto --->
	<cfif isdefined('Form.RHTTid') and Len(Trim(Form.RHTTid)) NEQ 0 and isdefined('Form.RHCid') and Len(Trim(Form.RHCid)) NEQ 0 and isdefined('Form.RHMPPid') and Len(Trim(Form.RHMPPid)) NEQ 0>
		<cfquery name="rsCatPaso" datasource="#Session.DSN#">
			select RHCPlinea
			from RHCategoriasPuesto
			where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
			and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCid#">
			and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMPPid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif Len(Trim(rsCatPaso.RHCPlinea))>
			<cfset Form.RHCPlinea = rsCatPaso.RHCPlinea>
		</cfif>
	</cfif>
</cfif>

<!--- Consulta --->
<cfif not isdefined("form.Nuevo")>

	<cfif isdefined("form.Alta")>
		<cfquery name="ABC_PlazasSelect" datasource="#session.DSN#">				
			select coalesce(max(<cf_dbfunction name='to_number' args='RHMCcodigo' >),0)+1 as RHMCcodigo
			from RHMetodosCalculo 
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset RHMCcodigo = ABC_PlazasSelect.RHMCcodigo>

		<cftransaction>
			<cfquery name="ABC_MetodoInsert" datasource="#session.DSN#">				
				insert into RHMetodosCalculo (Ecodigo, RHMCcodigo, RHMCdescripcion, CSid, RHMCfecharige, RHMCfechahasta, RHMCcomportamiento, RHMCtopeporc, RHMCestadometodo, RHMCindicador, RHMCvalor, RHCPlinea, RHPcodigo, BMUsucodigo, RHMCdiferenciasal, RHMCplazaporc)
				values(
					 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
					 <cf_dbfunction name='to_char' args='#RHMCCodigo#' >, ' ', 
					 <cfqueryparam value="#form.CSid#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#LSParseDateTime(form.RHMCfecharige)#" cfsqltype= "cf_sql_timestamp">,
					 <cfqueryparam value="#CreateDate(6100, 01, 01)#" cfsqltype= "cf_sql_timestamp">,
					 <cfqueryparam value="#form.RHMCcomportamiento#" cfsqltype="cf_sql_integer">,
					 <cfqueryparam value="#form.RHMCtopeporc#" cfsqltype="cf_sql_money">,
					 0,
					 <cfqueryparam value="#Trim(form.RHMCindicador)#" cfsqltype="cf_sql_char">,	
					 <cfqueryparam value="#form.RHMCvalor#" cfsqltype="cf_sql_numeric" scale="6">,
					 <cfif isdefined("Form.chkOtraCat") and isdefined("Form.RHCPlinea") and Len(Trim(Form.RHCPlinea))>
						 <cfqueryparam value="#form.RHCPlinea#" cfsqltype="cf_sql_numeric">,
					 <cfelse>
						 null,
					 </cfif>
					 <cfqueryparam value="#Trim(form.RHPcodigo)#" cfsqltype="cf_sql_char" null="#len(trim(form.RHPcodigo)) eq 0#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					 <cfif isdefined("Form.chkOtraCat") and isdefined("Form.RHCPlinea") and Len(Trim(Form.RHCPlinea)) and isdefined("Form.RHMCdiferenciasal")>
						 1
					 <cfelse>
					 	 0
					 </cfif>
					  <cfif isdefined("Form.RHMCplazaporc") and Len(Trim(Form.RHMCplazaporc))>
					  	,#form.RHMCplazaporc#
					  <cfelse>
					  	,null
					  </cfif>
					  
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 name="ABC_MetodoInsert" datasource="#Session.DSN#">
	
			<cfquery name="ABC_ComponentesCalculo" datasource="#Session.DSN#">
				insert into RHComponentesCalculo (RHMCid, CSid, BMUsucodigo)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_MetodoInsert.identity#">, 
					b.CSid, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				from ComponentesSalariales a
					inner join ComponentesSalariales b
						on b.Ecodigo = a.Ecodigo
						and b.CSsalariobase = 1
						and b.CSorden < a.CSorden
				where a.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">
			</cfquery>
			
		</cftransaction>

	<cfelseif isdefined("form.Duplicar")>
		<cfquery name="ABC_PlazasSelect" datasource="#session.DSN#">				
			select coalesce(max(<cf_dbfunction name='to_number' args='RHMCcodigo' >),0)+1 as RHMCcodigo
			from RHMetodosCalculo 
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset RHMCcodigo = ABC_PlazasSelect.RHMCcodigo>

		<cftransaction>
			<cfquery name="ABC_MetodoInsert" datasource="#session.DSN#">				
				insert into RHMetodosCalculo (Ecodigo, RHMCcodigo, RHMCdescripcion, CSid, RHMCfecharige, RHMCfechahasta, RHMCcomportamiento, RHMCtopeporc, RHMCestadometodo, RHMCindicador, RHMCvalor, RHCPlinea, RHPcodigo, BMUsucodigo, RHMCdiferenciasal,RHMCplazaporc)
				select a.Ecodigo, <cf_dbfunction name='to_char' args='#RHMCCodigo#'>, a.RHMCdescripcion, a.CSid, 
					   <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					   <cfqueryparam value="#CreateDate(6100, 01, 01)#" cfsqltype="cf_sql_timestamp">,
					   a.RHMCcomportamiento, 
					   a.RHMCtopeporc, 
					   0, 
					   a.RHMCindicador, 
					   a.RHMCvalor, 
					   a.RHCPlinea, 
					   a.RHPcodigo,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					   RHMCdiferenciasal
					   ,a.RHMCplazaporc
				from RHMetodosCalculo a
				where a.RHMCid = <cfqueryparam value="#Form.RHMCid#" cfsqltype="cf_sql_numeric">
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 name="ABC_MetodoInsert" datasource="#Session.DSN#">
			
			<cfquery name="ABC_ComponentesCalculo" datasource="#Session.DSN#">
				insert into RHComponentesCalculo (RHMCid, CSid, BMUsucodigo)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_MetodoInsert.identity#">, 
					CSid, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				from RHComponentesCalculo
				where RHMCid = <cfqueryparam value="#Form.RHMCid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			
		</cftransaction>

	<cfelseif isdefined("form.Cambio")>
	
		<cftransaction>
			<cf_dbtimestamp
				datasource="#session.DSN#"
				table="RHMetodosCalculo"
				redirect="formMetodos.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHMCid" type1="numeric" value1="#Form.RHMCid#"
				field2="RHMCestadometodo" type2="numeric" value2="0">

			<!--- Si el comportamiento no es de tipo porcentaje o se basa en otra categoria / puesto --->
			<cfif (form.RHMCcomportamiento NEQ 2) or (isdefined("Form.chkOtraCat") and isdefined("Form.RHCPlinea") and Len(Trim(Form.RHCPlinea)))>
				<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="RHComponentesCalculo">		
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="RHMCid = #Form.RHMCid# and not exists (select 1 from ComponentesSalariales x where x.CSid = RHComponentesCalculo.CSid	and x.CSsalariobase = 1)">
						<cfinvokeargument name="necesitaTransaccion" value="false">
				</cfinvoke>			
				<cfquery datasource="#Session.DSN#">
					delete from RHComponentesCalculo
					where RHMCid = <cfqueryparam value="#Form.RHMCid#" cfsqltype="cf_sql_numeric">
					and not exists (
						select 1
						from ComponentesSalariales x
						where x.CSid = RHComponentesCalculo.CSid
						and x.CSsalariobase = 1
					)
				</cfquery>
			</cfif>
			
			<cfquery name="ABC_PlazasUpdate" datasource="#session.DSN#">		
				update RHMetodosCalculo
				set CSid = <cfqueryparam value="#form.CSid#" cfsqltype="cf_sql_numeric">, 
					RHMCfecharige = <cfqueryparam value="#LSParseDateTime(form.RHMCfecharige)#" cfsqltype="cf_sql_timestamp">, 
					RHMCcomportamiento = <cfqueryparam value="#form.RHMCcomportamiento#" cfsqltype="cf_sql_integer">, 
					RHMCtopeporc = <cfqueryparam value="#form.RHMCtopeporc#" cfsqltype="cf_sql_money">, 
					RHMCindicador = <cfqueryparam value="#Trim(form.RHMCindicador)#" cfsqltype="cf_sql_char">, 
					RHMCvalor = <cfqueryparam value="#form.RHMCvalor#" cfsqltype="cf_sql_numeric" scale="6">,
					<cfif form.RHMCcomportamiento EQ 2 and isdefined("Form.chkOtraCat") and isdefined("Form.RHCPlinea") and Len(Trim(Form.RHCPlinea))>
						RHCPlinea = <cfqueryparam value="#form.RHCPlinea#" cfsqltype="cf_sql_numeric">,
					<cfelse>
						RHCPlinea = null,
					</cfif>
					RHPcodigo = <cfqueryparam value="#Trim(form.RHPcodigo)#" cfsqltype="cf_sql_char" null="#len(trim(form.RHPcodigo)) eq 0#">,
					<cfif form.RHMCcomportamiento EQ 2 and isdefined("Form.chkOtraCat") and isdefined("Form.RHCPlinea") and Len(Trim(Form.RHCPlinea)) and isdefined("Form.RHMCdiferenciasal")>
						RHMCdiferenciasal = 1
					<cfelse>
						RHMCdiferenciasal = 0
					</cfif>
					 <cfif isdefined("Form.RHMCplazaporc") and Len(Trim(Form.RHMCplazaporc))>
					  ,RHMCplazaporc = #form.RHMCplazaporc#
				  	<cfelse>
					  ,RHMCplazaporc = null
				  	</cfif>
				where RHMCid = <cfqueryparam value="#Form.RHMCid#" cfsqltype="cf_sql_numeric">
				and RHMCestadometodo = 0
			</cfquery>
		</cftransaction>
	<cfelseif isdefined("form.Baja")>
		<cftransaction>
			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
					<cfinvokeargument  name="nombreTabla" value="RHComponentesCalculo">		
					<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
					<cfinvokeargument name="condicion" value="RHMCid = #Form.RHMCid#">
					<cfinvokeargument name="necesitaTransaccion" value="false">
			</cfinvoke>		
			<cfquery name="ABC_ComponentesDelete" datasource="#session.DSN#">				
				delete from RHComponentesCalculo
				where RHMCid = <cfqueryparam value="#Form.RHMCid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
					<cfinvokeargument  name="nombreTabla" value="RHMetodosCalculo">		
					<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
					<cfinvokeargument name="condicion" value="RHMCid = #Form.RHMCid# and RHMCestadometodo = 0">
					<cfinvokeargument name="necesitaTransaccion" value="false">
			</cfinvoke>	
			<cfquery name="ABC_PlazasDelete" datasource="#session.DSN#">				
				delete from RHMetodosCalculo
				where RHMCid = <cfqueryparam value="#Form.RHMCid#" cfsqltype="cf_sql_numeric">
				and RHMCestadometodo = 0
			</cfquery>
		</cftransaction>
		
	<cfelseif isdefined("form.Aplicar")>
		<cftransaction>
			<cfquery name="ABC_PlazasUpdate1" datasource="#session.DSN#">								
				update RHMetodosCalculo
				set RHMCfechahasta = <cfqueryparam value="#dateadd('d',-1,LSParseDateTime(form.RHMCfecharige))#" cfsqltype="cf_sql_timestamp">
				where RHMCestadometodo = 1
				and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">
				and coalesce(RHMCfechahasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">
			</cfquery>
			
			<cfquery name="ABC_PlazasUpdate2" datasource="#session.DSN#">											
				update RHMetodosCalculo
				set RHMCestadometodo = 1
				where RHMCid = <cfqueryparam value="#Form.RHMCid#" cfsqltype="cf_sql_numeric">
				and RHMCestadometodo = 0
			</cfquery>
		</cftransaction>
	
	<!--- Agregar los componentes de Calculo --->
	<cfelseif isdefined("Form.AgregarCompCalc")>
		<cfquery name="ABC_ComponentesCalculo" datasource="#Session.DSN#">
			insert into RHComponentesCalculo (RHMCid, CSid, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMCid#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid_Comp#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
		</cfquery>
	
	<!--- Eliminar el Componente de Calculo --->
	<cfelseif isdefined("Form.COMPCALCULO") and Len(Trim(Form.COMPCALCULO))>
		<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
			<cfinvokeargument  name="nombreTabla" value="RHComponentesCalculo">		
			<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
			<cfinvokeargument name="condicion" value="RHMCid = #Form.RHMCid# and CSid = #Form.CompCalculo#">
			<cfinvokeargument name="necesitaTransaccion" value="false">
		</cfinvoke>	
		<cfquery name="ABC_ComponentesCalculo" datasource="#Session.DSN#">
			delete from RHComponentesCalculo 
			where RHMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMCid#">
			and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CompCalculo#">
		</cfquery>
	
	</cfif>
</cfif>	
<!--- Parámetros para volver a la pantalla principal --->
<cfset params = "?RHCAid=#Form.RHCAid#&PAGENUMABUELO=#Form.PAGENUMABUELO#&CSid=#Form.CSid#&PAGENUMPADRE=#Form.PAGENUMPADRE#">
<cfif isdefined("Form.RHMCid") and Len(Trim(Form.RHMCid)) and not isdefined("Form.Baja") and not isdefined("form.Nuevo")>
	<cfset params = params & "&RHMCid=#Form.RHMCid#">
</cfif>
<cfif isdefined("Form.PAGENUM") and Len(Trim(Form.PAGENUM))>
	<cfset params = params & "&PAGENUM=#Form.PAGENUM#">
</cfif>

<cflocation url="Metodos.cfm#params#">
