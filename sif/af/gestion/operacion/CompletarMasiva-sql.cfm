<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CompletarMasiva"
		Default="Completar Masivo"
		returnvariable="LB_CompletarMasiva"/>
		<cfoutput>#LB_CompletarMasiva#</cfoutput>
</title>
<cf_templatecss>
<cf_web_portlet_start titulo="#LB_CompletarMasiva#">
<cfif isdefined("form.btnCompletar")>
	<cfquery name="rsMeses" datasource="#session.dsn#">
		select 	<cf_dbfunction name="to_number" args="VSvalor"> as value, 
				VSdesc as description
		from VSidioma vs
			inner join Idiomas id
			on id.Iid = vs.Iid
			and id.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#">
			AND  <cf_dbfunction name="to_number" args="VSvalor">  =   <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATmes#">
		where VSgrupo = 1
		order by 1
	</cfquery>
	
	<cfquery name="rsConceptos" datasource="#session.dsn#">
		select Cconcepto as value, Cdescripcion as description, 0 as orden
		from ConceptoContableE
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		AND Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">
		order by 3,2
	</cfquery>


	<!---**************************************************
	*****Extrae los documentos que tengan *****************
	*****al menos un registro que tenga un vale ***********
	*****desde donde se pueda completar la informacion ****
	***************************************************--->
	<cfquery name="rsCompletar" datasource="#session.dsn#">
		select distinct a.Ecodigo,a.GATperiodo,a.GATmes,a.Edocumento,a.Cconcepto
		from GATransacciones a
		where a.Ecodigo  =  #session.ecodigo# 
		and a.GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATperiodo#">
		and a.GATmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATmes#">
		and a.Cconcepto  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">
		and a.Edocumento=  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Documento#">
		and a.Cconcepto is not null
		Order by Cconcepto, Edocumento
	</cfquery>
	
	<form action="CompletarMasiva.cfm" method="post" name="form1">
		<table width="100%" border="0">
			<cfif rsCompletar.recordcount gt 0>
				<tr>
					<td colspan="2" align="right">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Regresar"
						Default="Regresar"
						returnvariable="BTN_Regresar"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Cerrar"
						Default="Cerrar"
						returnvariable="BTN_Cerrar"/>
						
						<input name="btnRegresarUP" type="submit" value="<cfoutput>#BTN_Regresar#</cfoutput>" tabindex="1">
						<input name="btnCerrarUP" type="button" value="<cfoutput>#BTN_Cerrar#</cfoutput>" onClick="javascript:cerrar();" tabindex="1">
					</td>
				</tr>
				<tr>
					<td colspan="2" >&nbsp;</td>
				</tr>
			</cfif>
			
			<tr>
				<td colspan="2" align="center"><strong>Resultado del proceso de completar en forma masiva</strong></td>
			</tr>
			<tr>
				<td width="10%"><strong>Periodo:&nbsp;&nbsp;</strong></td>
				<td width="90%"><cfoutput>#Form.GATperiodo#</cfoutput></td>
			</tr>
			<tr>
				<td><strong>Mes:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#rsMeses.description#</cfoutput></td>
			</tr>
			<tr>
				<td><strong>Concepto:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#rsConceptos.description#</cfoutput></td>
			</tr>	
			<tr>
			<td colspan="2"><hr></td>
			</tr>		
		<cfif rsCompletar.recordcount lt 1>
			<cfoutput>
			<tr>
				<td colspan="2"  align="center"><font color="##FF0000">No hay informacin que cumpla con estos filtros, o no existen vales digitados para los activos de los documentos del periodo: #Form.GATperiodo# mes: #rsMeses.description# concepto: #rsConceptos.description#</font></td>
			</tr>
			</cfoutput>
		</cfif>
		
		<cfset docantes = "">
		<cfloop query="rsCompletar">
			
			<cfset todobien = true>
			<cfset GATperiodo = rsCompletar.GATperiodo>
			<cfset GATmes = rsCompletar.GATmes>
			<cfset Cconcepto = rsCompletar.Cconcepto>
			<cfset Edocumento = rsCompletar.Edocumento>
			<cfset docantes = rsCompletar.Edocumento>
									
			<cfif docantes neq "">
				<tr>
				<td colspan="2">&nbsp;</td>
				</tr>				
			</cfif>
			<tr>
			<td colspan="2" bgcolor="#CCCCCC"><strong>Documento</strong>: <cfoutput>#Edocumento#</cfoutput></td>
			</tr>			

			<!---*******************************************
			*****Inicia Proceso de Conciliacion*************
			*****no requiere transaccin********************
			********************************************--->
			<cfif todobien>
			
				<!--- Meses para calcular Fecha de Inicio de Depresiacion --->			
				<cfquery name="rsMesesDep" datasource="#Session.Dsn#">
					Select Pvalor as Mdep
					from Parametros
					where Pcodigo = 940
				</cfquery>
				
				<cfset MesesDep = 0>
				<cfif rsMesesDep.recordcount gt 0 and rsMesesDep.Mdep neq "">
					<cfset MesesDep = rsMesesDep.Mdep>
				</cfif>
				
				<!--- Meses para calcular Fecha de Inicio de Revaluacion --->							
				<cfquery name="rsMesesRev" datasource="#Session.Dsn#">
					Select Pvalor as Mrev
					from Parametros
					where Pcodigo = 950
				</cfquery>
				
				<cfset MesesRev = 0>
				<cfif rsMesesRev.recordcount gt 0 and rsMesesRev.Mrev neq "">
					<cfset MesesRev = rsMesesRev.Mrev>
				</cfif>
				
				<!--- Pone todas las columnas que esten conciliadas en estado incompleto 
				<cfquery name="rsCompletarEst" datasource="#Session.Dsn#">
					UPDATE GATransacciones 
					set GATestado = 0
					where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
				      and GATperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GATperiodo#">
				      and GATmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GATmes#">
				      and Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Cconcepto#">
				      and Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Edocumento#">					  
					  and GATestado = 2
				</cfquery>--->
				
				<!--- Se actualiza el campo de oficina anterior con el valor de la oficina actual--->
				<cfquery name="rsOficinasAnteriores" datasource="#Session.Dsn#">
				UPDATE GATransacciones
				 set OcodigoAnt = GATransacciones.Ocodigo
				where OcodigoAnt is null
				  and GATransacciones.GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
				  and GATransacciones.GATmes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
				  and GATransacciones.Cconcepto  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
				  and GATransacciones.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">				
				  and GATransacciones.Ecodigo    = #session.ecodigo# 
				</cfquery>
				
				<!--- Actualiza la informacin del Activo con la informacin de los vales en transito --->
				<cfquery name="porActualizar" datasource="#Session.Dsn#">
					select b.ID, a.ACid,a.ACcodigo,a.AFMid,a.AFMMid,a.CRDRserie,a.CFid,a.AFCcodigo,a.DEid,a.CRTDid,a.CRCCid,a.CFid, a.Ecodigo
					from CRDocumentoResponsabilidad a
					  inner join GATransacciones b
						on b.GATplaca = a.CRDRplaca
					   and b.Ecodigo = a.Ecodigo
					where b.GATperiodo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
					  and b.GATmes      = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
					  and b.Cconcepto   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
					  and b.Edocumento  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">				
					  and b.Ecodigo     =  #session.ecodigo# 
					  and a.CRDRestado  = 10
				</cfquery>
				<cfloop query="porActualizar">
					<cfquery name="rsCompletaInfo" datasource="#Session.Dsn#">
						UPDATE GATransacciones
						  set ACid     =  #porActualizar.ACid#,
						     ACcodigo  =  #porActualizar.ACcodigo#,
						  	 AFMid 	   =  #porActualizar.AFMid#,
							 AFMMid    =  #porActualizar.AFMMid#,
							 GATserie  =  '#porActualizar.CRDRserie#',
							 CFid 	   =  #porActualizar.CFid#,
							 AFCcodigo =  #porActualizar.AFCcodigo#,
							 DEid      =  #porActualizar.DEid#,
							 CRTDid    =  #porActualizar.CRTDid#,
							 CRCCid    =  #porActualizar.CRCCid#,
							 Ocodigo   = (Select Min(cf1.Ocodigo)
											from CFuncional cf1
											where cf1.CFid    = #porActualizar.CFid#
											  and cf1.Ecodigo = #porActualizar.Ecodigo#)
						<cfif MesesDep neq 0>
							,GATfechainidep  = <cf_dbfunction name="dateaddm" args="#MesesDep#, GATfecha">
						</cfif>
						<cfif MesesRev neq 0>
							,GATfechainirev	=  <cf_dbfunction name="dateaddm" args="#MesesRev#, GATfecha">
						</cfif>
					where ID = #porActualizar.ID#
					</cfquery>
				</cfloop>
				
				<!--- Actualiza la informacin del Activo con la informacin de los vales --->
				<cfquery name="PorActulizarAFR" datasource="#Session.Dsn#">
					select c.ID,b.ACid,b.ACcodigo,b.AFMid,b.AFMMid,b.Aserie,a.CFid,b.AFCcodigo,a.DEid,a.CRTDid,a.CRCCid,a.Ecodigo,b.Afechainidep,b.Afechainirev
					from AFResponsables a
					 inner join Activos b
					    on a.Aid    = b.Aid
					  and a.Ecodigo = b.Ecodigo	
					 inner join GATransacciones c
					 	on c.GATplaca = b.Aplaca
					  and c.Ecodigo   = b.Ecodigo
					where <cf_dbfunction name="now"> between a.AFRfini and a.AFRffin
					  and b.Ecodigo     =  #session.ecodigo# 
					  and c.GATperiodo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
					  and c.GATmes      = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
					  and c.Cconcepto   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
					  and c.Edocumento  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">				
				</cfquery>
				<cfloop query="PorActulizarAFR">
					<cfquery name="rsCompletaInfo" datasource="#Session.Dsn#">
					  UPDATE GATransacciones
					    set ACid 	  = #PorActulizarAFR.ACid#,
						    ACcodigo  = #PorActulizarAFR.ACcodigo#,
						    AFMid 	  = #PorActulizarAFR.AFMid#,
						    AFMMid 	  = #PorActulizarAFR.AFMMid#,
						    GATserie  = '#PorActulizarAFR.Aserie#',
						    CFid 	  = #PorActulizarAFR.CFid#,
							AFCcodigo = #PorActulizarAFR.AFCcodigo#,
							DEid      = #PorActulizarAFR.DEid#,
							CRTDid    = #PorActulizarAFR.CRTDid#,
							CRCCid    = #PorActulizarAFR.CRCCid#,
							Ocodigo	  = (Select Min(cf1.Ocodigo)
										  from CFuncional cf1
										 where cf1.CFid    = #PorActulizarAFR.CFid#
										   and cf1.Ecodigo = #PorActulizarAFR.Ecodigo#),						
						GATfechainidep  = <cfqueryparam cfsqltype="cf_sql_timestamp"  value="#PorActulizarAFR.Afechainidep#">,
						GATfechainirev	=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#PorActulizarAFR.Afechainirev#">
					 where ID = #PorActulizarAFR.ID#
				   </cfquery>
				</cfloop>
					
				<!--- Se actualiza el campo de oficina anterior con valor nulo en caso de quedar igual al actual --->
				<cfquery name="rsOficinasAnteriores" datasource="#Session.Dsn#">
					UPDATE GATransacciones
					set OcodigoAnt = null
					where GATransacciones.OcodigoAnt = GATransacciones.Ocodigo
					  and GATransacciones.GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
					  and GATransacciones.GATmes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
					  and GATransacciones.Cconcepto  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
					  and GATransacciones.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">				
					  and GATransacciones.Ecodigo    =  #session.ecodigo# 
				</cfquery>						
													
				<!--- Pone en estado completo todos los activos que cumplen con no tener nulos los campos especificados --->
				<cfquery name="rsCompletarEst" datasource="#Session.Dsn#">
					UPDATE GATransacciones 
					set GATestado = 1
					where Cconcepto is not null
					  and GATperiodo is not null
					  and GATmes is not null
					  and GATfecha is not null
					  and CFid is not null
					  and ACid is not null
					  and ACcodigo is not null
					  and GATplaca is not null
					  and GATdescripcion is not null
					  and AFMid is not null
					  and AFMMid is not null
					  and AFCcodigo is not null
					  and Ocodigo is not null
					  and GATfechainidep is not null
					  and GATfechainirev is not null
					  and GATmonto is not null
					  and CFcuenta is not null
					  and DEid is not null
					  and CRCCid is not null
					  and CRTDid is not null
					  and Ecodigo  =  #session.ecodigo# 
				      and GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
				      and GATmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
				      and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
				      and Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">					  
					  and GATestado = 0
				</cfquery>
				
				<!--- Reporta por nmero de lineas, cuales son completas, incompletas y conciliadas --->
				<cfquery name="rsVerificacion" datasource="#Session.Dsn#">
					select 1
					from GATransacciones
					where GATestado = 0
					  and Ecodigo  =  #session.ecodigo#  					
					  and GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
					  and GATmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
					  and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
					  and Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">				
				</cfquery>
				<cfquery name="rsVerificacion1" datasource="#Session.Dsn#">
					select 1
					from GATransacciones
					where GATestado = 1
					  and Ecodigo  =  #session.ecodigo#  					
					  and GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
					  and GATmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
					  and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
					  and Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">				
				</cfquery>
				<cfquery name="rsVerificacion2" datasource="#Session.Dsn#">
					select 1
					from GATransacciones
					where GATestado = 2
					  and Ecodigo  =  #session.ecodigo#  					
					  and GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
					  and GATmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
					  and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
					  and Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">				
				</cfquery>				
				<cfset Lncomp = rsVerificacion1.recordcount>
				<cfset LnIncomp = rsVerificacion.recordcount>				
				<cfset Lnconc = rsVerificacion2.recordcount>
				<tr>
				  <td colspan="2" >					
					<font color="black">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfoutput>#Lncomp#</cfoutput> lineas completas.<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfoutput>#LnIncomp#</cfoutput> lineas incompletas.<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfoutput>#Lnconc#</cfoutput> lineas conciliadas.
					</font>
				  </td> 
				</tr>
				<cfif LnIncomp eq 0>
					<tr>
					  <td colspan="2" >					
						<font color="navy">
						El documento fue completado satisfactoriamente
						</font>
					  </td> 
					</tr>
				<cfelse>
					<tr>
					  <td colspan="2" >
						<font color="##FF0000">
						El documento no fue completado. Es posible que algunos activos no tengan un vale ya digitado.
						</font>
					  </td>
					</tr>				
				</cfif>
				
			<cfelse>
				<tr>
					<td colspan="2" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="##FF0000">Proceso de completar datos cancelado!</font></td>
				</tr>
			</cfif>

		</cfloop>
		<!---*******************************************
		*****Termina Proceso de Conciliacion************
		********************************************--->
	<tr>
		<td colspan="2" align="center">--- Ultima lnea ---</td>
	</tr>	
	<tr>
		<td colspan="2" >&nbsp;</td>
	</tr>
	<tr>	
		<td colspan="2" align="right">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Regresar"
			Default="Regresar"
			returnvariable="BTN_Regresar"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Cerrar"
			Default="Cerrar"
			returnvariable="BTN_Cerrar"/>		
			<cfoutput>
				<input name="btnRegresarDOWN" type="submit" value="#BTN_Regresar#" tabindex="2">
				<input name="btnCerrarDOWN" type="button" value="#BTN_Cerrar#" onClick="javascript:cerrar();" tabindex="2">
			</cfoutput>
		</td>
	</tr>
	</table>
</form>
<script language="javascript" type="text/javascript">
	function cerrar(){
		window.close();
		window.opener.location.reload();
	}
</script>
<cfelse>
<cfoutput>
	<form action="CompletarMasiva.cfm" method="post" name="form1">
		<cfif isdefined("form.GATPeriodo") and len(trim(form.GATPeriodo))> 
			<input name="GATPeriodo" value="#form.GATPeriodo#" type="hidden">
		</cfif>				
		<cfif isdefined("form.GATMes") and len(trim(form.GATMes))>
			<input name="GATMes" value="#form.GATMes#" type="hidden">
		</cfif>	
		<cfif isdefined("form.Cconcepto") and len(trim(form.Cconcepto))>
			<input name="Cconcepto" value="#form.Cconcepto#" type="hidden">
		</cfif>
		<cfif isdefined("form.Documento") and len(trim(form.Documento))>		
			<input name="Documento" value="#form.Documento#" type="hidden">
		</cfif>
	</form>

<html><head></head><body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body></html>
</cfoutput>
</cfif>
<cf_web_portlet_end>
