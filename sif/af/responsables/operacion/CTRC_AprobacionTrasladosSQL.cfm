<cfif isDefined("form.Aprobar")>
	<cfif isdefined("form.CHK") and len(trim(form.CHK))>
	<cftransaction>
		<!--- Tipo1 --->
		<cfloop list="#form.CHK#" index="item">
			<cfinvoke component="sif.Componentes.AF_CambioResponsable" method="Aplicar">
				<cfinvokeargument name="AFTRid" 		  value="#item#"/>
				<cfinvokeargument name="AbrirTransaccion" value="false"/>
			</cfinvoke>
		</cfloop>
		<!--- Tipo2 --->
		<!--- *********** PASO 1 GUARDAR BITACORA  				***********--->
		 <cfquery name="rsBITACORA" datasource="#session.DSN#">
			insert into AFTBResponsables (AFTRid,AFRid,DEid,Aid,CRCCid,
										  Usucodigo,Ulocalizacion,AFTRfini,
										  AFTRestado,AFTRtipo,BMUsucodigo,CRCCidanterior,Usucodigoaplica)
			select a.AFTRid,a.AFRid,a.DEid,a.Aid,a.CRCCid,
			a.Usucodigo,a.Ulocalizacion,a.AFTRfini,
			a.AFTRestado,a.AFTRtipo,#Session.Usucodigo#,b.CRCCid,#Session.Usucodigo#
			from AFTResponsables a
			  inner join AFResponsables b
		        on a.AFRid 	 = b.AFRid 
			  inner join CRCCUsuarios c
				on a.CRCCid  = c.CRCCid
			where b.Ecodigo	 =  #Session.Ecodigo# 
			and a.AFTRtipo 	 = 2
			and a.AFTRestado = 40
			and c.Usucodigo  =  #session.Usucodigo# 
			and a.AFTRid in (#form.CHK#) 
		 </cfquery>
		<!--- *********** PASO 2 CAMBIAR CENTRO CE CUSTODIA  	***********--->
		<cfquery name="PRErsCAMBIOCC" datasource="#session.DSN#">
			select d.AFRid
					from AFTResponsables b
					   inner join CRCCUsuarios c 
						 on b.CRCCid = c.CRCCid
					    inner join AFResponsables d
							on d.AFRid = b.AFRid
					where d.Ecodigo= #Session.Ecodigo# 
					  and b.AFTRtipo = 2
					  and b.AFTRestado = 40
					  and c.Usucodigo =  #session.Usucodigo# 	
					  and b.AFTRid in (#form.CHK#) 
		
		</cfquery>
		<cfloop query="PRErsCAMBIOCC">
			 <cfquery name="rsCAMBIOCC" datasource="#session.DSN#">
				update AFResponsables
					set CRCCid    = (select min(b.CRCCid) from AFTResponsables b where b.AFRid =  AFResponsables.AFRid)
				where AFRid = #PRErsCAMBIOCC.AFRid#
			 </cfquery>
		</cfloop>
		 
		<!---******* Aqui se hace el alta a la tabla de bitacoras ******--->
		<cfquery datasource="#session.dsn#" name="rsinsertabitacora">
			insert into CRBitacoraTran(
				Ecodigo, 
				CRBfecha,
				Usucodigo,
				CRBmotivo,
				CRBPlaca,  
				AFRid,         
				Aid,               
				BMUsucodigo)
			select
				 #Session.Ecodigo# ,
				<cf_dbfunction name="now">,
				 #session.Usucodigo# ,
				4,
				act.Aplaca,
				afr.AFRid,
				afr.Aid,
				 #session.Usucodigo#  
			from AFTResponsables b
				inner join AFResponsables afr
					on b.AFRid = afr.AFRid
				inner join Activos act
					on afr.Aid = act.Aid
				 inner join CRCCUsuarios c 
					on b.CRCCid = c.CRCCid
				where afr.Ecodigo= #Session.Ecodigo# 
					  and b.AFTRtipo = 2
					  and b.AFTRestado = 40
					  and c.Usucodigo =  #session.Usucodigo# 	
					  and b.AFTRid in (#form.CHK#) 	 
		</cfquery>
		 
		 <!--- *********** PASO 3 BORRAR TABLA DE TRABAJO  		***********--->
		<cfquery name="rsdeleteT" datasource="#session.DSN#">
			delete from AFTResponsables 
			  where (select count(1)
						from CRCCUsuarios c 
						where AFTResponsables.CRCCid = c.CRCCid
						  and AFTResponsables.AFTRestado = 40
						  and AFTResponsables.AFTRtipo = 2
						  and c.Usucodigo =  #session.Usucodigo# 	
						  and AFTResponsables.AFTRid in (#form.CHK#) 
				      ) > 0
		</cfquery>
		</cftransaction>
		<cfset Salida = "Aprobación realizada exitosamente">
	<cfelse>
		<cfset Salida = "Error- Tiene que seleccionar al menos un documento">
	</cfif>
<cfelseif isDefined("form.Rechazar")>
	<cfif isdefined("form.CHK") and len(trim(form.CHK))>
		 <cftransaction>
		 
			 <cfquery name="rsCAMBIOCC" datasource="#session.DSN#">
				update  AFTResponsables
				  set AFTRestado = 50
				where ( select count(1)
						   from CRCCUsuarios c 
						where AFTResponsables.CRCCid = c.CRCCid
						  and AFTResponsables.AFTRestado in (10,40)
						  and c.Usucodigo =  #session.Usucodigo# 	
						  and AFTResponsables.AFTRid in (#form.CHK#) 
						) > 0
			 </cfquery>
			 
			<!--- Tipo1 --->
				<cfinvoke component="sif.Componentes.AF_CambioResponsable" method="Rechazar">
					<cfinvokeargument name="AFTRidlist" 		  value="#form.chk#"/>
					<cfinvokeargument name="AbrirTransaccion" value="false"/>
				</cfinvoke>
			<!--- Tipo2 --->
			 
			<cfquery datasource="#session.dsn#">
				insert into AFTBResponsables 
				(AFTRid, AFRid, DEid, Aid, CRCCid, Usucodigo, Ulocalizacion, AFTRfini, AFTRestado, AFTRtipo, BMUsucodigo, CRCCidanterior, 
				  AFTRCFid1, AFTRCFid2, AFTRaprobado1, AFTRaprobado2, AFTRfaprobado1, AFTRfaprobado2, Usucodigoaplica, AFTRazon , AFTRechazado)
				select a.AFTRid, a.AFRid, a.DEid, a.Aid, a.CRCCid, a.Usucodigo, a.Ulocalizacion, a.AFTRfini, a.AFTRestado, a.AFTRtipo, a.BMUsucodigo, b.CRCCid, 
				  AFTRCFid1, AFTRCFid2, AFTRaprobado1, AFTRaprobado2, AFTRfaprobado1, AFTRfaprobado2,#session.Usucodigo#,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPDEmsgrechazo#">,  1
				from AFTResponsables a
					 inner join AFResponsables b
					on a.AFRid = b.AFRid
				where AFTRid in (#form.CHK#) 
			</cfquery>
			
			<cfquery datasource="#session.dsn#">
				delete from AFTResponsables
				where AFTRid in (#form.CHK#) 
				and AFTRtipo = 2
				and AFTRestado in (0,20,30,50)
			</cfquery>
		  <cfset Salida = "Rechazo realizado exitosamente">
		 </cftransaction>
	<cfelse>
		<cfset Salida = "Error- Tiene que seleccionar al menos un documento">
	</cfif>
</cfif>
<form action="CTRC_AprobacionTraslados.cfm" method="post" name="sql">
	<cfoutput>
		<input type="hidden" name="Salida" value="<cfif isdefined("Salida") and len(trim(Salida))>#Salida#</cfif>">
		<input type="hidden" name="CRCCid" value="<cfif isdefined("form.CRCCID") and len(trim(form.CRCCID))>#form.CRCCID#</cfif>">
	</cfoutput>
</form>
<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>