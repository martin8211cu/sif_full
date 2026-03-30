<!---- Aumenta o disminuye el presupuesto del periodo o del multiperiodo ----->
<cfcomponent>	
	<cffunction name="VariacionPresupuestal"    access="public"   returntype="string"> <!----	ok ---->
		
		<cfargument name="NumeroVariaciacion" type="string"  	required="yes">
		<cfargument name="ESidsolicitud" 	  type="numeric" 	required="yes">


        <cfif not isdefined('Arguments.ESidsolicitud') or not len(trim(Arguments.ESidsolicitud))>
				<cfthrow message="Requiere el  ID de la solicitud">
		</cfif>
		<cfif not isdefined('Arguments.NumeroVariaciacion') or not len(trim(Arguments.NumeroVariaciacion))>
				<cfthrow message="No se ha definido un ID como linea de la variación">
		</cfif>
		
		
<!---		<!--- Crea la tabla de trabajo --->
		<cf_dbtemp name="NAPespejo" returnvariable="NAPespejo" datasource="#session.dsn#">
			<cf_dbtempcol name="Ecodigo" 	     type="numeric"		      mandatory="no">
			<cf_dbtempcol name="CPNAPnum" 	     type="numeric"		      mandatory="no">
			<cf_dbtempcol name="CPPid" 	         type="numeric"		      mandatory="no">
			<cf_dbtempcol name="CPCano" 	     type="numeric"		      mandatory="no">
			<cf_dbtempcol name="CPCmes" 	     type="numeric"		      mandatory="no">
			<cf_dbtempcol name="CPNAPfecha" 	 type="datetime"		  mandatory="no">
			<cf_dbtempcol name="CPNAPmoduloOri"  type="char"	     	  mandatory="no">
			<cf_dbtempcol name="CPNAPdocumentoOri" 	     type="varchar"	  mandatory="no">
			<cf_dbtempcol name="CPNAPreferenciaOri" 	 type="varchar"	  mandatory="no">
			<cf_dbtempcol name="CPNAPfechaOri" 	 type="numeric"		      mandatory="no">
			<cf_dbtempcol name="UsucodigoOri" 	 type="numeric"		      mandatory="no">
			<cf_dbtempcol name="UsucodigoAutoriza" 	     type="numeric"	  mandatory="no">
			<cf_dbtempcol name="CPOid" 	         type="numeric"	          mandatory="no">
			<cf_dbtempcol name="CPNAPnumReversado " 	 type="numeric"	  mandatory="no">
			<cf_dbtempcol name="CPNAPnumModificado" 	 type="numeric"	  mandatory="no">
			<cf_dbtempcol name="CFid" 	         type="numeric"		      mandatory="no">
			<cf_dbtempcol name="CPNAPcongelado"  type="numeric"		      mandatory="no">
			<cf_dbtempcol name="BMUsucodigo" 	 type="numeric"		      mandatory="no">			
			<cf_dbtempcol name="EcodigoOri" 	 type="numeric"		      mandatory="no">					
		</cf_dbtemp>
		<cf_dbtemp name="NAPespejoDet" returnvariable="NAPespejoDet" datasource="#session.dsn#">
			<cf_dbtempcol name="Ecodigo" 	     type="integer"		      mandatory="no">
			<cf_dbtempcol name="CPNAPnum" 	     type="numeric"		      mandatory="no">
			<cf_dbtempcol name="CPNAPDlinea"     type="integer"		      mandatory="no">
			<cf_dbtempcol name="CFcuenta" 	     type="numeric"		      mandatory="no">
			<cf_dbtempcol name="CPPid"   	     type="numeric"		      mandatory="no">			
			<cf_dbtempcol name="CPCano" 	     type="integer"	    	  mandatory="no">
			<cf_dbtempcol name="CPCmes" 	     type="integer"	    	  mandatory="no">
			<cf_dbtempcol name="CPcuenta" 	     type="numeric"	    	  mandatory="no">
			<cf_dbtempcol name="Ocodigo" 	     type="integer"	    	  mandatory="no">
			<cf_dbtempcol name="CPNAPDtipoMov" 	 type="char"	    	  mandatory="no">						
			<cf_dbtempcol name="Mcodigo" 	     type="numeric"	    	  mandatory="no">	
			<cf_dbtempcol name="CPNAPDmontoOri"  type="money"	    	  mandatory="no">
			<cf_dbtempcol name="CPNAPDtipoCambio"    type="float"	      mandatory="no">
			<cf_dbtempcol name="CPNAPDmonto"         type="money"   	  mandatory="no">	
			<cf_dbtempcol name="CPNAPDsigno"         type="integer"   	  mandatory="no">	
			<cf_dbtempcol name="CPCPtipoControl"     type="integer"	   	  mandatory="no">
			<cf_dbtempcol name="CPCPcalculoControl"  type="integer"	   	  mandatory="no">
			<cf_dbtempcol name="CPNAPDdisponibleAntes"    type="money"    mandatory="no">
			<cf_dbtempcol name="CPNAPDconExceso"     type="bit"           mandatory="no">
			<cf_dbtempcol name="CPNAPnumRef"         type="numeric"       mandatory="no">
			<cf_dbtempcol name="CPNAPDlineaRef"      type="integer"       mandatory="no">
			<cf_dbtempcol name="CPPidLiquidacion"    type="numeric"       mandatory="no">
			<cf_dbtempcol name="CPNAPDreferenciado"  type="bit"           mandatory="no">
			<cf_dbtempcol name="CPNAPDutilizado"     type="money"         mandatory="no">
			<cf_dbtempcol name="BMUsucodigo"         type="numeric"       mandatory="no">
			<cf_dbtempcol name="PCGDid"              type="numeric"       mandatory="no">
			<cf_dbtempcol name="PCGDcantidad"        type="float"         mandatory="no">
			<cf_dbtempcol name="PCGDcantidadAntes"   type="float"         mandatory="no">
			<cf_dbtempcol name="PCGDdisponibleAntes" type="money"         mandatory="no">								
		</cf_dbtemp>--->
		
		<!---*****Consulto la Solicitud de Compra***********--->
		<cfquery name="rsSC" datasource="#Session.DSN#">
		     select count(1) cantidad  from DSolicitudCompraCM where ESidsolicitud = #argument.ESidsolicitud#
		</cfquery>
			
		<cfif rsSC.cantidad eq 0 >		
		   <cfthrow message="No existe una Solicitud de Compra asociada al argumento que se paso">
		</cfif>
			
			<cfquery name="rsDetalleSC" datasource="#session.dsn#"> <!---Obtengo el numero de NAP y el id del P.C de la solicitud----->
			   Select 
			     a.NAP, 
				 b.PCGDid
				 from ESolicitudCompraCM a
				   inner join DSolicitudCompraCM b
				      on a.ESidsolicitud = b.ESidsolicitud
				 where a.Ecodigo = #session.dsn#
				 and  a.ESidsolicitud = #argument.ESidsolicitud#      
			</cfquery>
		<cfif rsDetalleSC.recordcount eq 0>
		  <cfthrow message="No existen lineas para la solicitud">
		</cfif>	
		<cfif len(trim(rsDetalleSC.NAP)) eq 0>
		  <cfthrow message="La solicitud #argument.ESidsolicitud#  no tiene un NAP asociado">		
		</cfif>	
		<cfif len(trim(rsDetalleSC.PCGDid)) eq 0>
		  <cfthrow message="La solicitud #argument.ESidsolicitud#  no tiene lineas del plan de compras asociada">		
		</cfif>	
		
		<!----Genero un numero de NAP para la solicitud----->
	    <cfinvoke component="sif.Componentes.PRES_Presupuesto" method="fnSiguienteCPNAPnum" returnvariable="NuevoNAPSC">
			<cfinvokeargument name="Ecodigo" 			value="#session.Ecodigo#">
			<cfinvokeargument name="Conexion" 	    	value="#session.dsn#">	
		</cfinvoke>		
				
	    <cfif len(trim(NuevoNAP)) eq  0 >
		    <cfthrow message="No se pudo generar el nuevo NAP. Operacion cancelada">       
		</cfif>
		
	<cftransaction>
		  <!---Inserto Nuevo NAP de la SC con los algunos detalles del NAP anterior----->	  
		  <cfquery name="rsNAPS" datasource="#session.dsn#"> 
		    insert into CPNAP
			(
			        Ecodigo,
					CPNAPnum,
					CPPid,
					CPCano,
					CPCmes,
					CPNAPfecha,
					CPNAPmoduloOri,
					CPNAPdocumentoOri,
					CPNAPreferenciaOri,
					CPNAPfechaOri,
					UsucodigoOri,
					UsucodigoAutoriza,
					CPOid,
					CPNAPnumReversado,
					CPNAPnumModificado,
					CFid,
					CPNAPcongelado,
					BMUsucodigo,					
					EcodigoOri
			)			   
			select      
		            Ecodigo,
					#NuevoNAPSC#,
					CPPid,
					CPCano,
					CPCmes,
					CPNAPfecha,
					CPNAPmoduloOri,
					CPNAPdocumentoOri,
					#NumeroVariaciacion#,
					CPNAPfechaOri,
					UsucodigoOri,
					UsucodigoAutoriza,
					CPOid,
					CPNAPnumReversado,
					CPNAPnumModificado,
					CFid,
					CPNAPcongelado,
					BMUsucodigo,					
					EcodigoOri
			from CPNAP n
				inner join CPNAPdetalle d
					 on d.Ecodigo	= n.Ecodigo
					and d.CPNAPnum	= n.CPNAPnum
			where n.Ecodigo		= #session.Ecodigo#
			  and n.CPNAPnum	= #rsDetalleSC.NAP#
		</cfquery>
		
		<!---- Cancelo las lineas del NAP de la SC ------>
		<cfquery name="rsCPNAPdetalleCancela" datasource="#session.dsn#">
		 Insert into CPNAPdetalle
		    (
			  Ecodigo,
				CPNAPnum,
				CPNAPDlinea,
				CFcuenta, 
				CPPid ,
				CPCano, 
				CPCmes, 
				CPcuenta, 
				Ocodigo, 
				CPNAPDtipoMov, 
				Mcodigo, 
				CPNAPDmontoOri, 
				CPNAPDtipoCambio, 
				CPNAPDmonto, 
				CPNAPDsigno,
				CPCPtipoControl,
				CPCPcalculoControl,
				CPNAPDdisponibleAntes,
				CPNAPDconExceso,
				CPNAPnumRef,
				CPNAPDlineaRef,
				CPPidLiquidacion,
				CPNAPDreferenciado,
				CPNAPDutilizado,
				BMUsucodigo,
				PCGDid,
				PCGDcantidad,
				PCGDcantidadAntes,
				PCGDdisponibleAntes
			)
			select 
				Ecodigo,
				CPNAPnum,
				CPNAPDlinea,
				CFcuenta, 
				CPPid ,
				CPCano, 
				CPCmes, 
				CPcuenta, 
				Ocodigo, 
				CPNAPDtipoMov, 
				Mcodigo, 
				-CPNAPDmontoOri, 
				CPNAPDtipoCambio, 
				-CPNAPDmonto, 
				CPNAPDsigno,
				CPCPtipoControl,
				CPCPcalculoControl,
				-CPNAPDdisponibleAntes,
				CPNAPDconExceso,
				CPNAPnumRef,
				CPNAPDlineaRef,
				CPPidLiquidacion,
				CPNAPDreferenciado,
				CPNAPDutilizado,
				BMUsucodigo,				
				PCGDid,
				PCGDcantidad,
				PCGDcantidadAntes,
				-PCGDdisponibleAntes
			from CPNAPdetalle
				where Ecodigo	= #session.Ecodigo#
			    and CPNAPnum	= #rsDetalleSC.NAP# 
		</cfquery>
		
	<cfloop query="rsDetalleSC">
 
        <cfquery name="rsPlanCM" datasource="#session.dsn#">
		 Select 
		   PCGDautorizado		   
		    from PCGDplanComprasMultiperiodo
		   where PCGDid = #rsDetalleSC.PCGDid#
		</cfquery>
        <cfif len(trim(rsPlanCM.PCGDautorizado)) eq 0>
		  <cfthrow message="No existe un plan de compras asociado al Id  de la solicitud">
		</cfif>	
 
 
		<!-----Vuelvo a insertar las lineas del Detalle del NAP pero con los nuevos valores------>
		<cfquery name="rsCPNAPdetalleNuevo" datasource="#session.dsn#">
		 Insert into CPNAPdetalle
		    (
			  Ecodigo,
				CPNAPnum,
				CPNAPDlinea,
				CFcuenta, 
				CPPid ,
				CPCano, 
				CPCmes, 
				CPcuenta, 
				Ocodigo, 
				CPNAPDtipoMov, 
				Mcodigo, 
				CPNAPDmontoOri, 
				CPNAPDtipoCambio, 
				CPNAPDmonto, 
				CPNAPDsigno,
				CPCPtipoControl,
				CPCPcalculoControl,
				CPNAPDdisponibleAntes,
				CPNAPDconExceso,
				CPNAPnumRef,
				CPNAPDlineaRef,
				CPPidLiquidacion,
				CPNAPDreferenciado,
				CPNAPDutilizado,
				BMUsucodigo,
				PCGDid,
				PCGDcantidad,
				PCGDcantidadAntes,
				PCGDdisponibleAntes
			)
			select 
				Ecodigo,
				#NuevoNAPSC#,
				CPNAPDlinea,
				CFcuenta, 
				CPPid ,
				CPCano, 
				CPCmes, 
				CPcuenta, 
				Ocodigo, 
				CPNAPDtipoMov, 
				Mcodigo, 
				#rsPlanCM.PCGDautorizado#, 
				CPNAPDtipoCambio, 
				#rsPlanCM.PCGDautorizado#, 
				CPNAPDsigno,
				CPCPtipoControl,
				CPCPcalculoControl,
				#rsPlanCM.PCGDautorizado#,
				CPNAPDconExceso,
				CPNAPnumRef,
				CPNAPDlineaRef,
				CPPidLiquidacion,
				#NumeroVariaciacion#,
				CPNAPDutilizado,
				BMUsucodigo,				
				PCGDid,
				PCGDcantidad,
				PCGDcantidadAntes,
				#rsPlanCM.PCGDautorizado#
			from CPNAPdetalle
				where Ecodigo	= #session.Ecodigo#
			    and CPNAPnum	= #rsOrdenCM.NAP# 
		</cfquery>
		
		</cfloop>
		
	    <!------- Actualizo la SC con referencia al nuevo NAP ------->
		<cfquery name="rsUpdateNapSC" datasource="#session.dsn#">
		   update ESolicitudCompraCM set NAP = #NuevoNAPSC#
		     where Ecodigo = #session.dsn#
				 and  ESidsolicitud = #argument.ESidsolicitud#      
		</cfquery>
		
		<!------  Genero un nuevo numero de NAP para la OC ------->
		<cfinvoke component="sif.Componentes.PRES_Presupuesto" method="fnSiguienteCPNAPnum" returnvariable="NuevoNAPOC">
			<cfinvokeargument name="Ecodigo" 			value="#session.Ecodigo#">
			<cfinvokeargument name="Conexion" 	    	value="#session.dsn#">	
		</cfinvoke>
			
		<!---- Obtengo informacion de la OC asociada a las SC ------>
		<cfquery name="rsOrdenCM" datasource="#Session.dsn#">
    	select 
            a.PCGDID,
            b.NAP,
		    a.EOidorden,
			a.DOlinea,
			a.EOnumero,
		    a.Icodigo
          from DOrdenCM a
            inner join EOrdenCM b
                on a.EOidorden = b.EOIDORDEN
        where 
		    b.Ecodigo = #session.Ecodigo#
		    and ESidsolicitud=  #argument.ESidsolicitud# 
            and b.EOestado = 10			
		</cfquery>		
		<cfif len(trim(rsOrdenCM.EOidorden)) gt 0 >  
		
		<!------ Crea un nuevo NAP para la OC -------->
		 <cfquery name="rsNAPS" datasource="#session.dsn#"> 
		    insert into CPNAP
			(
			        Ecodigo,
					CPNAPnum,
					CPPid,
					CPCano,
					CPCmes,
					CPNAPfecha,
					CPNAPmoduloOri,
					CPNAPdocumentoOri,
					CPNAPreferenciaOri,
					CPNAPfechaOri,
					UsucodigoOri,
					UsucodigoAutoriza,
					CPOid,
					CPNAPnumReversado,
					CPNAPnumModificado,
					CFid,
					CPNAPcongelado,
					BMUsucodigo,					
					EcodigoOri
			)			   
			select      
		            Ecodigo,
					#NuevoNAPOC#,
					CPPid,
					CPCano,
					CPCmes,
					CPNAPfecha,
					CPNAPmoduloOri,
					CPNAPdocumentoOri,
					#NumeroVariaciacion#,
					CPNAPfechaOri,
					UsucodigoOri,
					UsucodigoAutoriza,
					CPOid,
					CPNAPnumReversado,
					CPNAPnumModificado,
					CFid,
					CPNAPcongelado,
					BMUsucodigo,					
					EcodigoOri
			from CPNAP n
				inner join CPNAPdetalle d
					 on d.Ecodigo	= n.Ecodigo
					and d.CPNAPnum	= n.CPNAPnum
			where n.Ecodigo		= #session.Ecodigo#
			  and n.CPNAPnum	= #rsOrdenCM.NAP#
		</cfquery>
		<!----- Cancela los detalles del NAP de la OC------>
		<cfquery name="rsCPNAPdetalleCancela" datasource="#session.dsn#">
		 Insert into CPNAPdetalle
		    (
			  Ecodigo,
				CPNAPnum,
				CPNAPDlinea,
				CFcuenta, 
				CPPid ,
				CPCano, 
				CPCmes, 
				CPcuenta, 
				Ocodigo, 
				CPNAPDtipoMov, 
				Mcodigo, 
				CPNAPDmontoOri, 
				CPNAPDtipoCambio, 
				CPNAPDmonto, 
				CPNAPDsigno,
				CPCPtipoControl,
				CPCPcalculoControl,
				CPNAPDdisponibleAntes,
				CPNAPDconExceso,
				CPNAPnumRef,
				CPNAPDlineaRef,
				CPPidLiquidacion,
				CPNAPDreferenciado,
				CPNAPDutilizado,
				BMUsucodigo,
				PCGDid,
				PCGDcantidad,
				PCGDcantidadAntes,
				PCGDdisponibleAntes
			)
			select 
				Ecodigo,
				CPNAPnum,
				CPNAPDlinea,
				CFcuenta, 
				CPPid ,
				CPCano, 
				CPCmes, 
				CPcuenta, 
				Ocodigo, 
				CPNAPDtipoMov, 
				Mcodigo, 
				-CPNAPDmontoOri, 
				CPNAPDtipoCambio, 
				-CPNAPDmonto, 
				CPNAPDsigno,
				CPCPtipoControl,
				CPCPcalculoControl,
				-CPNAPDdisponibleAntes,
				CPNAPDconExceso,
				CPNAPnumRef,
				CPNAPDlineaRef,
				CPPidLiquidacion,
				CPNAPDreferenciado,
				CPNAPDutilizado,
				BMUsucodigo,				
				PCGDid,
				PCGDcantidad,
				PCGDcantidadAntes,
				-PCGDdisponibleAntes
			from CPNAPdetalle
				where Ecodigo	= #session.Ecodigo#
			    and CPNAPnum	= #rsOrdenCM.NAP# 
		</cfquery>
		
		<cfset montoOCHija = 0>
		<cfloop query="rsOrdenCM"><!---Para cada linea de la orden se consulta el monto autorizado ----->
				
		<cfquery name="rsPlanCM" datasource="#session.dsn#">
		 Select 
		   PCGDautorizado		   
		    from PCGDplanComprasMultiperiodo
		   where PCGDid = #rsOrdenCM.PCGDid#
		</cfquery>
        <cfif len(trim(rsPlanCM.PCGDautorizado)) eq 0>
		  <cfthrow message="No existe un plan de compras asociado al Id  de la Orden de Compra">
		</cfif>	
 
		<cfset montoOCHija =  montoOCHija + rsPlanCM.PCGDautorizado>
		
		
		<cfset impuesto = 0>
		
		<cfquery name="rsPorc" datasource="#session.dsn#">
		select Iporcentaje 
		from Impuestos 
		  where Ecodigo = #session.Ecodigo#
		   and Icodigo  =  #rsOrdenCM.Icodigo#
		</cfquery>
		
		
		<cfset impuesto = rsPlanCM.PCGDautorizado* (100/rsPorc.Iporcentaje)>
		<cfquery name="rsUpdateMonto" datasource="#session.dsn#">
		  update DOrdenCM set DOtotal = rsPlanCM.PCGDautorizado, DOpreciou = rsPlanCM.PCGDautorizado,
		  DOimpuestoCosto =  impuesto
			 where Ecodigo = #session.dsn#				 
			   and DOlinea = #rsOrdenCM.DOlinea#			   			       
		</cfquery>
				
		<!---Inserta los nuevos detalles del NAP detalle con el monto correspondiente, asociada con el nuevo numero de NAP de la OC ----->
		<cfquery name="rsCPNAPdetalleNuevo" datasource="#session.dsn#">
		 Insert into CPNAPdetalle
		    (
			  Ecodigo,
				CPNAPnum,
				CPNAPDlinea,
				CFcuenta, 
				CPPid ,
				CPCano, 
				CPCmes, 
				CPcuenta, 
				Ocodigo, 
				CPNAPDtipoMov, 
				Mcodigo, 
				CPNAPDmontoOri, 
				CPNAPDtipoCambio, 
				CPNAPDmonto, 
				CPNAPDsigno,
				CPCPtipoControl,
				CPCPcalculoControl,
				CPNAPDdisponibleAntes,
				CPNAPDconExceso,
				CPNAPnumRef,
				CPNAPDlineaRef,
				CPPidLiquidacion,
				CPNAPDreferenciado,
				CPNAPDutilizado,
				BMUsucodigo,
				PCGDid,
				PCGDcantidad,
				PCGDcantidadAntes,
				PCGDdisponibleAntes
			)
			select 
				Ecodigo,
				#NuevoNAPOC#,
				CPNAPDlinea,
				CFcuenta, 
				CPPid ,
				CPCano, 
				CPCmes, 
				CPcuenta, 
				Ocodigo, 
				CPNAPDtipoMov, 
				Mcodigo, 
				#rsPlanCM.PCGDautorizado#, 
				CPNAPDtipoCambio, 
				#rsPlanCM.PCGDautorizado#, 
				CPNAPDsigno,
				CPCPtipoControl,
				CPCPcalculoControl,
				#rsPlanCM.PCGDautorizado#,
				CPNAPDconExceso,
				CPNAPnumRef,
				CPNAPDlineaRef,
				CPPidLiquidacion,
				#NumeroVariaciacion#,
				CPNAPDutilizado,
				BMUsucodigo,				
				PCGDid,
				PCGDcantidad,
				PCGDcantidadAntes,
				#rsPlanCM.PCGDautorizado#
			from CPNAPdetalle
				where Ecodigo	= #session.Ecodigo#
			    and CPNAPnum	= #rsOrdenCM.NAP# 
		</cfquery>
		
		</cfloop> <!---Fin detalles de la OC  ----->
		
		<cfquery name="rsTotales" datasource="#session.dsn#">
		 Select 
		  sum(DOtotal) as total,
		  sum(DOimpuestoCosto) as impuesto
		 from DOrdenCM where 
		 Ecodigo= #session.Ecodigo#
		 and  EOnumero= #rsOrdenCM.EOnumero#
		 and EOestado= 10	 
		</cfquery>
		
		<!---- Cambia el NAP en el encabezado de la Orden de Compra ----->
		<cfquery name="rsUpdateNapEOC" datasource="#session.dsn#">
		   update EOrdenCM set NAP = #NuevoNAPOC#,
		   		EOtotal= #rsTotales.total#,
				IMpuesto =   #rsTotales.impuesto#          
				where Ecodigo = #session.dsn#					 
				 and EOnumero= #rsOrdenCM.EOnumero#
				 and EOestado= 10				       
		</cfquery>
				
		<cfquery name="rsUpdateNapSC" datasource="#session.dsn#">
		update CPNAPdetalle set CPNAPnumRef = #NuevoNAPSC# 
		        where Ecodigo = #session.dsn#
				 <!---and  ESidsolicitud = #argument.ESidsolicitud#--->
				 and CPNAPnum	= #rsOrdenCM.NAP# 
				 and CPNAPDtipoMov= 'CC'				       
		</cfquery>
		
		</cfif><!---Validacion si existe OC----> 
		
		<cfset detalle = "ok">
		 
		</cftransaction>		
                 
		<cfreturn detalle>
	</cffunction>
</cfcomponent>