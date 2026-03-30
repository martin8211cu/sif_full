<cfif isdefined("url.RCNid") and Len(Trim(url.RCNid))>
	
	<!--- Descripcion --->
	<cfquery name="rsERN" datasource="#session.DSN#">
		select Tcodigo,ERNdescripcion as descripcion 
		from ERNomina where RCNid=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.RCNid#">
	</cfquery>	
	<cfif rsERN.recordCount EQ 0>
		<cfquery name="rsERN" datasource="#session.DSN#">
			select Tcodigo,HERNdescripcion as descripcion 
			from HERNomina where RCNid=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.RCNid#">
		</cfquery>
	</cfif>
	<cfset descripcion = "Nomina: " & url.RCNid>	
	<cfif isdefined("rsERN.descripcion") and len(trim(rsERN.descripcion))>
		<cfset descripcion = rsERN.descripcion>		
	</cfif>
	
	<!--- Datos de las cuentas --->
	<!---<cfquery name="rsDatos" datasource="#session.DSN#">
		select rtrim(Cformato) as cuenta,
				sum(montores)as monto, 
				tipo, 
				'#descripcion#' as descripcion
		from RCuentasTipo
		where RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.RCNid#">
		group by Cformato, tipo, '#descripcion#'
		order by Cformato, tipo, '#descripcion#'
	</cfquery> --->
	
	<cftransaction>
		<cfinvoke component="rh.Componentes.RH_RepAsientos" method="GenerarDatosReporte" returnvariable="rsDatos">
			<cfinvokeargument name="RCNid" 			value="#url.RCNid#">
			<cfinvokeargument name="Ecodigo" 		value="#Session.Ecodigo#"/>
		</cfinvoke>
 	</cftransaction>
   
	<cfquery name="rsDatos" dbtype="query">
		select 
			CFformato as cuenta,
			sum(Credito) as credito,
			sum(Debito) as debito,
			tipo, 
			CalendarioDesc as descripcion
		from rsDatos
		group by CFformato, tipo,CalendarioDesc
		order by CFformato, tipo,CalendarioDesc
	</cfquery>
	<cftransaction>
 		
	<!--- Encabezado--->
    	<cfquery datasource="sifinterfaces" name="rsProcesoIn">
			Insert into E_CONTABILIDAD_BNV(numero_interfase,descripcion,referencia,Ecodigo,fechaalta,BMUsucodigo) 
			values(922,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#descripcion#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#url.RCNid#">,
			#now()#,
			#session.Usucodigo#
			)
			<!--- <cf_dbidentity1 datasource="sifinterfaces"> --->
		</cfquery>
		<!--- <cf_dbidentity2 datasource="sifinterfaces" name="rsProcesoIn"> --->
		
		<cfquery datasource="sifinterfaces" name="rsProcesoIn">
			select coalesce(max(id_proceso),1)as identity from E_CONTABILIDAD_BNV
		</cfquery>
		
		<cfset Lvarid = rsProcesoIn.identity>
		<!--- Detalle--->
		<cfloop query="rsdatos">
			<cfquery datasource="sifinterfaces">
				Insert into D_CONTABILIDAD_BNV(ID_PROCESO,NUMEROINTERFASE,RCNid,cuentaContable, monto,tipo,descripcion) 
				values(#Lvarid#,922,<cfqueryparam cfsqltype="cf_sql_integer" value="#url.RCNid#">,'#ReplaceNoCase(mid(rsdatos.cuenta,2,len(rsdatos.cuenta)),"-","","all")#',
				<cfif rsdatos.Credito GT 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.credito#">,
				<cfelse>
					#rsdatos.Debito#,
				</cfif>
				'#rsdatos.tipo#','#rsdatos.descripcion#')
			</cfquery>
			
		</cfloop>
		
		<!--- Procedimiento, actualiza el numero de asiento en caso de obtenerlo con exito--->
		<CFSTOREDPROC PROCEDURE="sp_final" DATASOURCE="sifinterfaces">
		    <CFPROCPARAM TYPE="IN" CFSQLTYPE ="CF_SQL_INTERGER" VARIABLE ="id_proceso" VALUE="#Lvarid#">
		    <CFPROCPARAM TYPE="IN" CFSQLTYPE ="CF_SQL_INTERGER" VARIABLE ="numero_interfase" VALUE="922"> 
		</CFSTOREDPROC> 
		
		<cfquery datasource="sifinterfaces" name="rsRead">
			Select numero_asiento, MensajeErr from E_CONTABILIDAD_BNV where id_proceso = #Lvarid#
		</cfquery>
		
		<cfif isdefined("rsRead.numero_asiento") and len(trim(rsRead.numero_asiento))>
			<cfset mensaje = 'Pase Realizado. N&uacute;mero de Asiento: #rsRead.numero_asiento#'>
		</cfif>
		<cfif isdefined("rsRead.MensajeErr") and len(trim(rsRead.MensajeErr))>
			<cfset mensaje = mensaje & '<br> Se present&oacute; el siguiente error: #rsRead.MensajeErr#'>
		</cfif>
		<cfif (not isdefined("rsRead.numero_asiento") or not len(trim(rsRead.numero_asiento))) and 
			(not isdefined("rsRead.MensajeErr") or not len(trim(rsRead.MensajeErr)))>
			<cfset mensaje = mensaje & '<br> El pase no se realiz&oacute;, no se tienen datos del error.'>
		</cfif>
		
	</cftransaction>
	
<cfelse>
	<cfset mensaje = 'No existe una nomina definida.'>
</cfif>

<table width="100%" height="100" cellpadding="2" cellspacing="0">
<tr><td valign='midlle'>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Proceso_de_Pase_de_Asientos_a_Contabilidad"
		Default="Proceso de Pase de Asientos a Contabilidad"
		XmlFile="/rh/generales.xml"
		returnvariable="Proceso_de_Pase_de_Asientos_a_Contabilidad"/>
								
	<cf_web_portlet_start titulo="#Proceso_de_Pase_de_Asientos_a_Contabilidad#" >
		<br>
		<cfoutput>
			#mensaje#
		</cfoutput>
		<br><br>
		<center><input type="button" value="Cerrar" name="Cerrar" onClick="javascript: window.close();"></center>
	<cf_web_portlet_end>
</td></tr>
</table>
		  