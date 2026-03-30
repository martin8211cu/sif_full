<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Proceso_de_Pase_de_Presupuesto"
	Default="Proceso de Pase de Presupuesto"
	XmlFile="/rh/generales.xml"
	returnvariable="Proceso_de_Pase_de_Presupuesto"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTNCerrar"
	Default="Cerrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTNCerrar"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTNRegresar"
	Default="Regresar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTNRegresar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTEnviarPresupuesto"
	Default="Enviar a Presupuesto"
	XmlFile="/rh/generales.xml"
	returnvariable="BTEnviarPresupuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Proceso_de_Pase_de_Presupuesto"
	Default="Proceso de Pase de Presupuesto"
	XmlFile="/rh/generales.xml"
	returnvariable="Proceso_de_Pase_de_Presupuesto"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBDescripcion"
	Default="Descripcion"
	XmlFile="/rh/generales.xml"
	returnvariable="LBDescripcion"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBTotal"
	Default="Total"
	XmlFile="/rh/generales.xml"
	returnvariable="LBTotal"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBEgreso"
	Default="Egreso"
	XmlFile="/rh/generales.xml"
	returnvariable="LBEgreso"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBMonto"
	Default="Monto"
	XmlFile="/rh/generales.xml"
	returnvariable="LBMonto"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTContinuar"
	Default="Continuar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTContinuar"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBArticulo"
	Default="Articulo"
	XmlFile="/rh/generales.xml"
	returnvariable="LBArticulo"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBCambiarA"
	Default="Cambiar A"
	XmlFile="/rh/generales.xml"
	returnvariable="LBCambiarA"/>
	<style type="text/css">
  	body {
    font-family: Helvetica, Geneva, Arial,
         SunSans-Regular, sans-serif;
        font-size: 9;
    	}
 	 h1 {font-size:11px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   text-align:left; }
	.LBtitulo{font-size:11px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   font-weight:bold;
	   background-color: E6E6E6;
	    }
	.LBtitulo2{font-size:11px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   font-weight:bold;
	    }
    table {
	   font-size:10px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   text-align:left;}
	input {
	   font-size:10px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   text-align:left;}
	select {
	   font-size:10px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   text-align:left;}
	
  </style>
	

<cfif isdefined("form.Enviar")>
	
	<cfset num_interfase = 921>
	
	<!--- envio a presupuesto--->
	<cfquery datasource="#session.dsn#" name="rsNom">
		select CPmes as mes, CPperiodo as periodo
		from CalendarioPagos where CPid =<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RCNid#">
	</cfquery>
	<cfset vmes = rsNom.mes>
	<cfset vperiodo = rsNom.periodo>
	
	<cfquery datasource="#session.dsn#" name="rsERN">
		select ERNdescripcion as Observacion
		from ERNomina where RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RCNid#">
	</cfquery>
	<cfset vObs = rsERN.Observacion>
	
	<cfquery datasource="sifinterfaces" name="rsTotal">
		select sum(monto) as monto
		from PRE_INTERFAZ_PRESUPUESTO where RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RCNid#">
		and ID_PIP in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.incluir#">)
	</cfquery>
	
	<cftransaction>
		<!--- Encabezado--->
		<cfquery datasource="sifinterfaces" name="rsProcesoIn">
			Insert into E_Presupuesto_BNV(
				  NUMERO_INTERFASE,
				  REFERENCIA,
				  NUM_PERIODO,
				  NUM_MES,
				  OBS_SOLICITUD,
				  MTO_RESERVADO,
				  FECHAALTA,
				  BMUSUCODIGO
				  ) 
			values(
				#num_interfase#,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RCNid#">,
				'#vperiodo#',
				'#vmes#',
				'#vObs#',
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTotal.monto#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
				<!--- <cf_dbidentity1 datasource="sifinterfaces"> --->
		</cfquery>
		<!--- <cf_dbidentity2 datasource="sifinterfaces" name="rsProcesoIn"> --->
		<cfquery datasource="sifinterfaces" name="rsProcesoIn">
			select coalesce(max(id_proceso),1)as identity from E_PRESUPUESTO_BNV
		</cfquery>
		
		<cfset vId = rsProcesoIn.identity>
		
		<cfquery datasource="sifinterfaces">
			Insert into D_PRESUPUESTO_BNV(	
				ID_PROCESO,
				NUM_PERIODO,
				NUM_MES,
				ID_EGRESO,         <!---cuenta presupuestaria --->
				MONTO,
				<!---OBSERVACION,--->
				COD_ARTICULO,
				COD_PLANIFICACION,
				NUM_UNIDAD_EJEC,
				FECHAALTA,
				BMUSUCODIGO
			)
			select 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#vId#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#vperiodo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#vmes#">,
				a.cod_egreso,
				sum(a.monto),
				<!--- a.desc_articulo as descripcion,---->
				a.cod_articulo,
				a.cod_plan,
				a.oficina, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
			from PRE_INTERFAZ_PRESUPUESTO a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
			and ID_PIP in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.incluir#">)
			group by <cfqueryparam cfsqltype="cf_sql_numeric" value="#vId#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#vperiodo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#vmes#">,
				a.cod_egreso,
				<!---a.desc_articulo,--->
				a.cod_articulo,
				a.cod_plan,
				a.oficina, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		</cfquery>
		
		<!--- Actualiza la descripcion --->
		<cfquery datasource="sifinterfaces">
			update D_PRESUPUESTO_BNV  
			set OBSERVACION =  (Select a.DESC_ARTICULO from INTP_ARTICULOS_BNV a where a.cod_articulo = D_PRESUPUESTO_BNV.cod_articulo and a.cod_egreso = D_PRESUPUESTO_BNV.id_egreso)
			where ID_PROCESO = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vId#">
		</cfquery>
		<!--- Pone un contador de lineas --->
		<cfquery datasource="sifinterfaces" name="rsCont">
			select * from D_PRESUPUESTO_BNV  
			where ID_PROCESO = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vId#">
			order by cod_articulo
		</cfquery>
		
		<cfset cont = 1>
		<cfloop query="rsCont">
			<cfquery datasource="sifinterfaces">
				Update D_PRESUPUESTO_BNV  
				set contador=<cfqueryparam cfsqltype="cf_sql_numeric" value="#cont#">
				where ID_PROCESO = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vId#">
				and COD_ARTICULO = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCont.cod_articulo#">
				and id_egreso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCont.id_egreso#">
			</cfquery>
			<cfset cont = cont + 1>
		</cfloop>
		
	</cftransaction>
	
	<cfset mensaje ="">
	
	<!--- Procedimiento, actualiza el numero de asiento en caso de obtenerlo con exito--->
 	
		<CFSTOREDPROC PROCEDURE="sp_final" DATASOURCE="sifinterfaces">
		    <CFPROCPARAM TYPE="IN" CFSQLTYPE ="CF_SQL_INTERGER" VARIABLE ="id_proceso" VALUE="#vId#">
		    <CFPROCPARAM TYPE="IN" CFSQLTYPE ="CF_SQL_INTERGER" VARIABLE ="numero_interfase" VALUE="921"> 
		</CFSTOREDPROC> 
	
	<cfquery datasource="sifinterfaces" name="rsRead">
		Select NUMERO_SOLICITUD, MensajeErr from E_PRESUPUESTO_BNV where id_proceso = #vId#
	</cfquery>
	
	<cfif isdefined("rsRead.numero_solicitud") and len(trim(rsRead.numero_solicitud))>
		<cfset mensaje = 'Pase Realizado. N&uacute;mero de Asiento: #rsRead.numero_solicitud#'>
	</cfif>
	<cfif isdefined("rsRead.MensajeErr") and len(trim(rsRead.MensajeErr))>
		<cfset mensaje = mensaje & ' Pendiente por definir egresos y articulos válidos: <br> Se present&oacute; un error. #rsRead.MensajeErr#'>
	</cfif>
	<cfif not len(trim(mensaje))>
		<cfset mensaje = mensaje & 'Pendiente por definir egresos y articulos válidos: <br> El pase no se realiz&oacute;, no se tienen datos del error.'>
	</cfif>
			
	<table width="100%" height="100" cellpadding="2" cellspacing="0">
	<tr><td valign='midlle'>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="Proceso_de_Pase_a_Presupuesto"
			Default="Proceso de Pase a Presupuesto"
			XmlFile="/rh/generales.xml"
			returnvariable="Proceso_de_Pase_a_Presupuesto"/>
									
		<cf_web_portlet_start titulo="#Proceso_de_Pase_a_Presupuesto#" >
			<br>
			<cfoutput><center>
				#mensaje#
			</center></cfoutput>
			<br><br>
			<center><input type="button" value="Cerrar" name="Cerrar" onClick="javascript: window.close();"></center>
		<cf_web_portlet_end>
		
	</td></tr>
	</table>
	
<cfelseif isdefined("form.Continuar")>
	
	<cfif not isdefined("form.incluir") or not len(trim(form.incluir))>
		
		<cf_web_portlet_start titulo="#Proceso_de_Pase_de_Presupuesto#" >
		<br><br><br><br>	
		
		<cfoutput>
			<center>
			Debe seleccionar al menos un rubro para realizar el env&iacute;o a presupuesto
			<br><br>
			<input type="button" value="#BTNRegresar#" name="Regresar" onClick="javascript: document.location.href='http://#session.sitio.host#/cfmx/rh/pago/operacion/InterfazPresupuestoBNV.cfm?RCNid=#form.RCNid#&BTNRegresar=yes'">
			</center>
		</cfoutput>
		
		<cf_web_portlet_end>
		<cfabort>
	</cfif>
	
	
	<cfquery datasource="sifinterfaces" name="rsDatos">
		select * from PRE_INTERFAZ_PRESUPUESTO 
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
		and ID_PIP in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.incluir#">)
		order by ORDEN
	</cfquery>
	<cfloop query="rsDatos">
		<cfset eg = trim(evaluate('form.egreso#rsDatos.id_pip#'))>
		<cfset art = trim(evaluate('form.articulo#rsDatos.id_pip#'))>
		<cfset des = trim(evaluate('form.descripcion#rsDatos.id_pip#'))>
		
		<!--- ACTUALIZA LA TABLA TEMPORAL--->
		<cfquery datasource="sifinterfaces">
			update PRE_INTERFAZ_PRESUPUESTO
			set 
				oficina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oficina#">,
				cod_plan = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cod_plan#">,
				cod_egreso = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eg#">,
				cod_articulo =<cfqueryparam cfsqltype="cf_sql_varchar" value="#art#">,
				desc_articulo =<cfqueryparam cfsqltype="cf_sql_varchar" value="#des#">
			where id_pip = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.id_pip#">
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
		</cfquery>
	</cfloop>
	
	
	<cfquery datasource="sifinterfaces" name="rsTotal">
		select sum(monto) as monto from PRE_INTERFAZ_PRESUPUESTO 
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
		and ID_PIP in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.incluir#">)
		order by ORDEN
	</cfquery>
	
	<cfif isdefined("form.agrupar")>
		<cfquery datasource="sifinterfaces" name="rsDatosUnificados">
			select  
				COD_EGRESO,
			    COD_ARTICULO,
			    OFICINA,
			    COD_PLAN,
			    sum(MONTO) as monto
			from PRE_INTERFAZ_PRESUPUESTO 
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
			and ID_PIP in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.incluir#">)
			group by
				COD_EGRESO,
			    COD_ARTICULO,
			    OFICINA,
			    COD_PLAN
		</cfquery>
	<cfelse>
		<cfquery datasource="sifinterfaces"  name="rsDatosUnificados">
			select * from PRE_INTERFAZ_PRESUPUESTO
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
			and ID_PIP in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.incluir#">)
			order by cod_articulo
		</cfquery>
	
	</cfif>
		
	<cfquery datasource="sifinterfaces"  name="rsDatos">
		select * from PRE_INTERFAZ_PRESUPUESTO
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
		and ID_PIP in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.incluir#">)
	</cfquery>
	
	<cfquery datasource="sifinterfaces"  name="rsArtBNV">
		select * from INTP_ARTICULOS_BNV
	</cfquery>
	
	<cf_web_portlet_start titulo="#Proceso_de_Pase_de_Presupuesto#" >
	
	<cf_htmlReportsHeaders
		irA="InterfazPresupuestoBNV.cfm?RCNid=#form.RCNid#&BTNRegresar=yes"
		FileName="Presupuesto_BNV(#form.RCNid#).xls"
		title="Presupuesto_BNV">
	
	<br>
	
	<form name="form1" method="post" action="InterfazPresupuestoBNV_SQL.cfm">
	<cfoutput>	
	
	<input type="hidden" name="RCNid" value="#form.RCNid#">
	<input type="hidden" name="incluir" value="#form.incluir#">
	
	<table  height="100" cellpadding="0" cellspacing="0" border=0 align="center">
	<tr class="LBtitulo2"><td valign='midlle'>
	 <strong>Oficina</strong> #rsDatos.oficina#  <br>
	 <strong>C&oacute;digo de Planificaci&oacute;n </strong> #rsDatos.cod_plan# <td></tr>
	
	<tr><td valign='midlle'>
		<table border=0  cellpadding="0" cellspacing="0"><!--- align="center" --->
		<tr><td> 
			
			<table border=0 align="center" cellpadding="2" cellspacing="0">
			<tr class="LBtitulo"><td style="width:150">#LBDescripcion#</td>
				<td style="width:70">#LBArticulo#</td>
				<td style="width:70">#LBEgreso#</td>
				<td style="width:70">#LBMonto#</td>	
			</tr>	
			
			<cfset tip="">
			<cfloop query="rsDatosUnificados">
				<cfif not isdefined("form.agrupar")>
					<cfif trim(tip) neq trim(rsDatosUnificados.tipo)>
						<cfset tip = trim(rsDatosUnificados.tipo)>
						<cfif tip EQ 'C'>
							<tr class="LBtitulo"><td colspan="4">Cargas</td></tr>
						</cfif>
						<cfif tip EQ 'D'>
							<tr class="LBtitulo"><td colspan="4">Deducciones</td></tr>
						</cfif>
					</cfif>
				</cfif>
				<tr>
				<td  nowrap="nowrap">
					<cfif isdefined("form.agrupar")>
						<cfquery name="rsDesc" dbtype="query"> 	
							select desc_articulo from rsArtBNV 
							where cod_egreso = '#trim(rsDatosUnificados.cod_egreso)#'
							and  cod_articulo = '#trim(rsDatosUnificados.cod_articulo)#'
						</cfquery>
						#rsDesc.desc_articulo#
					<cfelse>
						#rsDatosUnificados.desc_articulo#
					</cfif>
					
				</td>
					
				<td>
					#rsDatosUnificados.cod_articulo#
				</td>
				<td nowrap="nowrap">
					#rsDatosUnificados.cod_egreso#
				</td>
					<td align="right">
						#LSNumberFormat(rsDatosUnificados.Monto,'9,999.99')#
					</td>
				</tr>
			</cfloop>
			
			<tr class="LBtitulo"><td style="width:150">#LBTotal#</td>
				<td style="width:70"></td>
				<td style="width:70"></td>
				<td style="width:70">#LSNumberFormat(rsTotal.Monto,'9,999.99')#</td>	
			</tr>		
		
			
			</table>
		</td></tr>
		<tr><td>
			<center>
				<input type="button" value="#BTNRegresar#" name="Regresar" onClick="javascript: document.location.href='http://#session.sitio.host#/cfmx/rh/pago/operacion/InterfazPresupuestoBNV.cfm?RCNid=#form.RCNid#&BTNRegresar=yes'">
				<input type="submit" value="#BTEnviarPresupuesto#" name="Enviar" 
				onClick="javascript: if(confirm('¿Esta seguro que desea realizar el pase a presupuesto?') == false)return false;">
			</center>
		</td></tr>
		
		</table>
	</cfoutput>
	</form>
	<cf_web_portlet_end>
	
	
</cfif>







