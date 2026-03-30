<!---================FILTROS================--->
	<cf_dbfunction name="now" returnvariable="hoy">
	<cfif isdefined("form.AplacaINI") and len(trim(form.AplacaINI))> 
		<cfset form.AplacaINI_psql = form.AplacaINI>
		<cfset form.AdescripcionINI_psql = form.AdescripcionINI>
	</cfif>
	<cfif isdefined("form.DEid") and len(trim(form.DEid))> 
		<cfset form.DEid_psql = form.DEid>
		<cfset form.DEidentificacion_psql = form.DEidentificacion>
		<cfset form.DEnombrecompleto_psql = form.DEnombrecompleto>
	</cfif>
	<cfif isdefined("form.CFid") and len(trim(form.CFid))> 
		<cfset form.CFid_psql = form.CFid>
		<cfset form.CFcodigo_psql = form.CFcodigo>
		<cfset form.CFdescripcion_psql = form.CFdescripcion>
	</cfif>
	<cfif isdefined("form.CRCCidFT") and len(trim(form.CRCCidFT))> 
		<cfset form.CRCCidFT_psql = form.CRCCidFT>
	</cfif>
	<cfif isdefined("form.CRTDidFT") and len(trim(form.CRTDidFT))> 
		<cfset form.CRTDidFT_psql = form.CRTDidFT>
	</cfif>
	<cfif isdefined("form.Agregar") > 
		<cfset form.Agregar_psql = form.Agregar>
	</cfif>
	
<!---================AGREGAR================--->
<cfif isdefined("form.Agregar")>
	<cfset tabla = "
			AFResponsables a
			inner join Activos c
				on a.Aid	= c.Aid
				and a.Ecodigo = c.Ecodigo
		inner join DatosEmpleado  d
				on a.DEid 	= d.DEid 
				and a.Ecodigo = d.Ecodigo
			left outer join CRTipoDocumento e
				on  a.Ecodigo = e.Ecodigo
				and a.CRTDid =e.CRTDid
			left outer join CFuncional f
				on  a.Ecodigo = f.Ecodigo
				and a.CFid =f.CFid
			left outer join CRCentroCustodia g
				on  a.Ecodigo = g.Ecodigo
				and a.CRCCid  = g.CRCCid	
				">
														
	<cfset filtro = " a.Ecodigo = #Session.Ecodigo# "> 
	<cfif isdefined("form.AplacaINI") and len(trim(form.AplacaINI))>
		<cfset filtro = filtro &  " and c.Aplaca = '#form.AplacaINI#'">
	</cfif>
	<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		<cfset filtro = filtro &  " and a.DEid = #form.DEid#">
	</cfif>	
	<cfif isdefined("form.CFid") and len(trim(form.CFid))>
		<cfset filtro = filtro &  " and a.CFid = #form.CFid#">
	</cfif>
	<cfif isdefined("form.CRTDidFT") and len(trim(form.CRTDidFT)) and trim(form.CRTDidFT) NEQ "-1" >
		<cfset filtro = filtro &  " and a.CRTDid = #form.CRTDidFT#">					
	</cfif>
	<cfif isdefined("form.CRCCidFT") and len(trim(form.CRCCidFT))>
		<cfset filtro = filtro &  " and a.CRCCid = #form.CRCCidFT#">
	</cfif>						

	<cfset filtro = filtro &  "  and #hoy# between a.AFRfini and a.AFRffin ">
	<cfset filtro = filtro &  "and not exists (Select 1 
										from CRCRetiros Ret 
										where Ret.Ecodigo = c.Ecodigo 
								  		and Ret.Aid = c.Aid 
								  		and Ret.BMUsucodigo = #Session.Usucodigo#)">

	<cfset filtro = filtro &  " order by CRCCcodigo,DEidentificacion,Aplaca">
		
	<cfset qrysql = "INSERT into CRCRetiros(Ecodigo, Aid, AFRid, BMUsucodigo) ">
	<cfset qrysql = qrysql & " Select #session.Ecodigo# as Ecodigo,c.Aid, a.AFRid, #session.Usucodigo# as BMUsucodigo ">
	<cfset qrysql = qrysql & " from #tabla#" >
	<cfset qrysql = qrysql & " where not exists (Select 1 from ADTProceso ADT where ADT.Ecodigo = c.Ecodigo and ADT.Aid = c.Aid)">
	<cfset qrysql = qrysql & " and #filtro# ">
		
	<cfquery datasource="#Session.Dsn#">
	    #preservesinglequotes(qrysql)#
	</cfquery>
	
<!---================ELIMINAR================--->
<cfelseif isdefined("form.Eliminar")>
	<cfloop list="#chk#" delimiters="," index="chkval">
		<cfquery datasource="#Session.Dsn#">
			Delete from CRCRetiros
			where Ecodigo     =  #Session.Ecodigo# 
			  and AFRid       =  #chkval#	  
			  and BMUsucodigo =  #session.Usucodigo#  		  
		</cfquery>
	</cfloop>
	
<!---================IMPORTAR================--->	
<cfelseif isdefined("form.Importar")>
	<cflocation url="../../importar/CTR_importaRetiro.cfm">
	
<!---================ELIMINAR TODO================--->	
<cfelseif isdefined("form.EliminarT")>
	<cfquery datasource="#Session.Dsn#">
		Delete from CRCRetiros 
		 where BMUsucodigo = #session.Usucodigo#  
		   and Ecodigo     = #Session.Ecodigo# 
	</cfquery>
<!---================ELIMINAR ERROR================--->		

<cfelseif isdefined("url.EliminarError")>
	<cfif isdefined("url.errornum") and len(trim(url.errornum)) gt 0 and url.errornum gt 0>
		<cfquery datasource="#Session.Dsn#">
			Delete from CRCRetiros
			where exists( select 1 from 
			  AFResponsables a
			   inner join Activos c
				 on a.Aid	  = c.Aid
			  	and a.Ecodigo = c.Ecodigo	
			 where a.Ecodigo =  #Session.Ecodigo# 
			 and CRCRetiros.BMUsucodigo =  #session.Usucodigo#  			  			
			  	and a.Ecodigo = CRCRetiros.Ecodigo
			  	and a.Aid     = CRCRetiros.Aid

				<cfif url.errornum eq 1>
		  			and exists(	select 1 
								from CRDocumentoResponsabilidad  x
								where x.CRCCid = a.CRCCid
						  			and x.CRDRplaca = c.Aplaca )
				</cfif>
				<cfif url.errornum eq 2>
		  			and exists(	select 1 
								from AFTResponsables y
								where y.CRCCid = a.CRCCid
						  			and y.AFRid = a.AFRid )
				</cfif>
				<cfif url.errornum eq 3>
		  			and exists( select 1 
								from CRCRetiros z
								where z.Ecodigo = CRCRetiros.Ecodigo
						  			and z.Aid = CRCRetiros.Aid
						  			and z.BMUsucodigo != CRCRetiros.BMUsucodigo )
				</cfif>
				)
			</cfquery>
		</cfif>
<cfelse>
<!---================RETIRAR MARCADO O TODO================--->	
	<cfif isdefined("form.Retirar") or isdefined("form.RetirarT")>	
	<cftransaction>
		<!--- Obtiene el parÃ¡metro para identificar si AF esta abierto para recibir transacciones --->
		<cfquery datasource="#session.dsn#" name="RSParamTran">
			Select Pvalor 
			 from Parametros 
			where Pcodigo=970 
			  and Ecodigo =  #session.ecodigo# 
		</cfquery>
		
		<cfif RSParamTran.recordcount eq 0>
			<cfset Paramvalor = 0>		
		<cfelse>
			<cfset Paramvalor = RSParamTran.Pvalor>			
		</cfif>	
		
		<cfquery datasource="#session.dsn#" name="RSRetiros">
			select AFRdescripcion 
			 from AFRetiroCuentas
			where Ecodigo = #session.Ecodigo#
			  and AFRmotivo =<cfqueryparam cfsqltype="cf_sql_integer" value="#form.AFRmotivo#">
			order by AFRmotivo
		</cfquery>
		
		<cfset DescripRetiro = "Retiro Realizado desde control de responsables">
		<cfset MotivoRetiro = form.AFRmotivo>
		<cfif isdefined("form.RSJustificacion") and form.RSJustificacion neq "">
			<cfset Razon = form.RSJustificacion>
		<cfelse>
			<cfset Razon = RSRetiros.AFRdescripcion>
		</cfif>
			
		<cfif isdefined("form.RetirarT")>

			<!--- Retira todo sin importar si esta o no marcado --->
			<cfquery name="RSActivos" datasource="#session.DSN#">
				select A.Aid, cc.CRCCcodigo
				from AFResponsables A
					inner join Activos B
						on A.Aid = B.Aid
					inner join CRCRetiros Re
						on A.Ecodigo = Re.Ecodigo
				       and A.AFRid 	 = Re.AFRid
					inner join CRCentroCustodia cc
						on A.CRCCid = cc.CRCCid
				where A.Ecodigo = #Session.Ecodigo#
				  and Re.BMUsucodigo =  #Session.Usucodigo# 
				  and not exists (Select 1 
								  from CRDocumentoResponsabilidad  x
								  where x.CRCCid    = A.CRCCid
									and x.CRDRplaca = B.Aplaca)

				  and not exists (Select 1
								  from AFTResponsables y
								  where y.CRCCid = A.CRCCid
									and y.AFRid  = A.AFRid)

				  and not exists (Select 1
								  from CRCRetiros z
								  where z.Ecodigo     =  Re.Ecodigo
								    and z.Aid	      =  Re.Aid
									and z.BMUsucodigo != Re.BMUsucodigo)								
			</cfquery>
		
		<cfelse>
	
			<cfquery name="RSActivos" datasource="#session.DSN#">
				select Aid, cc.CRCCcodigo
				from AFResponsables a
						inner join CRCentroCustodia cc
							on cc.CRCCid = a.CRCCid
							
				where a.AFRid in(#form.chk#)
				  and a.Ecodigo =  #session.ecodigo# 
			</cfquery>
		
		</cfif>
		
		<!--- 
		Si el parÃ¡metro de cola esta activo, no se incluye la relacion en las tablas
		ADTProceso y AGTProceso, sino que se acumulan en la cola de procesos de Control 
		de Responsables
		--->
		
		<cfif Paramvalor eq 1 or Paramvalor eq 2>
		
			<cfquery name="rsNumRel" datasource="#session.dsn#">
				Select max(Relacion) as Final
				from CRColaTransacciones
				where Ecodigo =  #session.Ecodigo# 
			</cfquery>

			<cfif isdefined("rsNumRel") and rsNumRel.recordcount GT 0 and rsNumRel.Final neq "">
				<cfset Lvarnrel = rsNumRel.Final + 1>
			<cfelse>
				<cfset Lvarnrel = 1>
			</cfif>	
				
			
				<cfloop query="RSActivos">		
					<!--- VALIDACIONES--->
				
					<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" 	  Aid="#RSActivos.Aid#"/>
					<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Saldos" 	  Aid="#RSActivos.Aid#" validamontos="false"/>
					<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Revaluacion"  Aid="#RSActivos.Aid#"/> 
					<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Depreciacion" Aid="#RSActivos.Aid#"/> 
					<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Mejora" 	  Aid="#RSActivos.Aid#"/> 
					<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Retiro" 	  Aid="#RSActivos.Aid#"/> 
					<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CambioCatCls" Aid="#RSActivos.Aid#"/> 
					<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Traslado"     Aid="#RSActivos.Aid#"/> 
					<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Cola"         Aid="#RSActivos.Aid#"/> 
					<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Documentos"   Aid="#RSActivos.Aid#"/> 
					
					<cfquery datasource="#session.dsn#">
						INSERT into CRColaTransacciones (Ecodigo, Aid, Type, CRBid, Relacion)
						VALUES( #session.ecodigo# ,#RSActivos.Aid#,1,-1,#Lvarnrel#)
					</cfquery>
				</cfloop>	
					
		
		<cfelse>
		
			<!--- Se le agrega a la descripcion del Retiro el cÃ³digo del centro de custodia --->
			
			<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaRelacion" returnvariable="rsResultadosRA">
				<cfinvokeargument name="AGTPdescripcion"   value="#DescripRetiro#">
				<cfinvokeargument name="AFRmotivo"         value="#MotivoRetiro#">
				<cfinvokeargument name="AGTPrazon"         value="#Razon#">
				<cfinvokeargument name="RetiroCR"          value="true">	
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
			
			<cfloop query="RSActivos">
				
				<cfset RazonDet = #Razon# & " - CC: " & #RSActivos.CRCCcodigo#>
				
				<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaActivo" returnvariable="rsResultadosRA">
					<cfinvokeargument name="AGTPid"             value="#llave#">
					<cfinvokeargument name="ADTPrazon"          value="#RazonDet#">
					<cfinvokeargument name="Aid"       			value="#RSActivos.Aid#">
					<cfinvokeargument name="TransaccionActiva"  value="true">
					
				</cfinvoke>	
				<cfset llave2 = rsResultadosRA>
				
				<!---******* Aqui se hace el alta a la tabla de bitacoras ******--->
				
			</cfloop>
		
		</cfif>
		
		<cfif isdefined("form.RetirarT")>
			
		    <cfif Paramvalor eq 0>
				<cfquery name="rsTipoDocumento" datasource="#session.DSN#">
					select AFR.AFRid
					  from Activos B
						inner join CRCRetiros Re
							on B.Aid     = Re.Aid
						   and B.Ecodigo = Re.Ecodigo
						inner join AFResponsables AFR
							on Re.Ecodigo = AFR.Ecodigo
						   and Re.AFRid   = AFR.AFRid
					where B.Ecodigo      =  #session.ecodigo# 
					  and Re.BMUsucodigo =  #Session.Usucodigo# 
					  and not exists (Select 1 
										  from CRDocumentoResponsabilidad  x
										  where x.CRCCid    = AFR.CRCCid
											and x.CRDRplaca = B.Aplaca)
					  and not exists (Select 1
										  from AFTResponsables y
										  where y.CRCCid = AFR.CRCCid
											and y.AFRid  = AFR.AFRid)
					  and not exists (Select 1
										  from CRCRetiros z
										  where z.Ecodigo     =  Re.Ecodigo
											and z.Aid	      =  Re.Aid
											and z.BMUsucodigo != Re.BMUsucodigo)							
				</cfquery>			
				<cfloop query="rsTipoDocumento">
					<cfquery datasource="#session.DSN#">
						update AFResponsables
						  set AFRffin      = <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("d", -1, now())#">
						where AFRid = #rsTipoDocumento.AFRid#
					</cfquery>
				</cfloop>
			</cfif>		
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
					BMUsucodigo,
					AFRmotivo, 
					Razon, 
					CRCCcodigo)
				select
					 #Session.Ecodigo# ,
					 #Now()#,
					 #session.Usucodigo#,
					2,
					act.Aplaca,
					afr.AFRid,
					afr.Aid,
					 #session.Usucodigo#  ,
					
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#MotivoRetiro#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Razon#">,
					cc.CRCCcodigo
				from AFResponsables afr 
					inner join Activos act
						on act.Ecodigo = afr.Ecodigo
						and act.Aid    = afr.Aid
						
					inner join CRCRetiros Re	
					     on afr.Ecodigo = Re.Ecodigo
					    and afr.AFRid 	= Re.AFRid
						
					inner join CRCentroCustodia cc
						on cc.CRCCid = afr.CRCCid						
						
				where afr.Ecodigo =  #session.ecodigo# 				
				  and Re.BMUsucodigo =  #Session.Usucodigo# 

				  and not exists (Select 1 
									  from CRDocumentoResponsabilidad  x
									  where x.CRCCid    = afr.CRCCid
										and x.CRDRplaca = act.Aplaca)
	
				  and not exists (Select 1
									  from AFTResponsables y
									  where y.CRCCid = afr.CRCCid
										and y.AFRid  = afr.AFRid)
	
				  and not exists (Select 1
									  from CRCRetiros z
									  where z.Ecodigo     =  Re.Ecodigo
										and z.Aid	      =  Re.Aid
										and z.BMUsucodigo != Re.BMUsucodigo)
			</cfquery>
		
			<!---Para eliminar todo de la lista de acuerdo al usuario--->
			<cfquery datasource="#Session.Dsn#">
				Delete from CRCRetiros 
				where BMUsucodigo =  #session.Usucodigo#  
				  and Ecodigo 	  =  #Session.Ecodigo# 
			</cfquery>		
		
		<cfelse>
		 <cfif Paramvalor eq 0>
			<cfquery name="rsTipoDocumento" datasource="#session.DSN#">
				update AFResponsables
				set AFRffin      = <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("d", -1, now())#">
				where AFRid  in(#form.chk#)
				  and Ecodigo =  #session.ecodigo# 
			</cfquery>
		</cfif>
					
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
					BMUsucodigo,
					AFRmotivo, 
					Razon, 
					CRCCcodigo)
				select
					 #Session.Ecodigo#,
					 #Now()#,
					 #session.Usucodigo#,
					 2,
					 act.Aplaca,
					 afr.AFRid,
					 afr.Aid,
					 #session.Usucodigo#,
					 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#MotivoRetiro#">,
					 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Razon#">,
					 cc.CRCCcodigo
				from AFResponsables afr
					inner join Activos act
						on act.Ecodigo = afr.Ecodigo
						and act.Aid = afr.Aid
					inner join CRCentroCustodia cc
						on cc.CRCCid = afr.CRCCid			
				where afr.AFRid  in (#form.chk#)
			</cfquery>
			
		
			<!--- Elimina de la lista lo que se retirÃ³ --->
			<cfloop list="#chk#" delimiters="," index="chkval">
				<cfquery datasource="#Session.Dsn#">
					Delete from CRCRetiros
					where Ecodigo =  #Session.Ecodigo# 
					  and AFRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#chkval#">		  
					  and BMUsucodigo =  #session.Usucodigo#  		  
				</cfquery>
			</cfloop>
		
		</cfif>
		
		<!--- Se actualiza la cola con el ID de la Bitacora--->			
		<cfif Paramvalor eq 1 or Paramvalor eq 2>
			<cfquery datasource="#session.dsn#">
				Update CRColaTransacciones 
				set CRBid = (select a.CRBid
							   from CRBitacoraTran a				
							  where a.Aid = CRColaTransacciones.Aid
							    and a.Ecodigo= CRColaTransacciones.Ecodigo
								and a.CRBmotivo = 2
							)
				where Ecodigo  = #session.ecodigo# 
				  and Relacion = #Lvarnrel#
			</cfquery>
		</cfif>		
	</cftransaction>	
	</cfif>
	
</cfif> 
	<form action="retiros.cfm" method="post" name="sql">
	
	<cfoutput>
		<cfif isdefined("form.AplacaINI_psql") and len(trim(form.AplacaINI_psql))> 
			<input name="AplacaINI_sql" value="#form.AplacaINI_psql#" type="hidden">
			<input name="AdescripcionINI_sql" value="#form.AdescripcionINI_psql#" type="hidden">
		</cfif>				
		<cfif isdefined("form.DEid_psql") and len(trim(form.DEid_psql))>
			<input name="DEid_sql" value="#form.DEid#" type="hidden">
			<input name="DEidentificacion_sql" value="#form.DEidentificacion_psql#" type="hidden">
			<input name="DEnombrecompleto_sql" value="#form.DEnombrecompleto_psql#" type="hidden">
		</cfif>	
		<cfif isdefined("form.CFid_psql") and len(trim(form.CFid_psql))>
			<input name="CFid_sql" value="#form.CFid_psql#" type="hidden">
			<input name="CFcodigo_sql" value="#form.CFcodigo_psql#" type="hidden">
			<input name="CFdescripcion_sql" value="#form.CFdescripcion_psql#" type="hidden">
		</cfif>
		<cfif isdefined("form.CRCCidFT_psql") and len(trim(form.CRCCidFT_psql))>		
			<input name="CRCCidFT_sql" value="#form.CRCCidFT_psql#" type="hidden">
		</cfif>
		<cfif isdefined("form.CRTDidFT_psql") and len(trim(form.CRTDidFT_psql))>		
			<input name="CRTDidFT_sql" value="#form.CRTDidFT_psql#" type="hidden">
		</cfif>
		<cfif isdefined("form.Agregar_psql")>		
			<input name="Agregar_sql" value="#form.Agregar_psql#" type="hidden">
		</cfif>
		<input name="Filtrar" value="" type="hidden">
	</cfoutput>									
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
