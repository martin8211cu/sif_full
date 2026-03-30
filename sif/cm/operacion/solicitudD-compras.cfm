<cfsetting requesttimeout="3600">
<cf_dbfunction name='OP_concat' returnvariable='concat'>
<cfif not isdefined('form.Sid') and isdefined('url.Sid')>
	<cfset form.Sid = url.Sid>
</cfif>
<!--- Function getTotal --->
<cffunction name="getTotal" returntype="numeric">
	<cfargument name="id" type="numeric" required="yes">

	<cfquery name="rsTotal" datasource="#session.DSN#">
		select coalesce(
                    sum(DScant*DSmontoest)+
                    sum(DScant*DSmontoest * Iporcentaje/100)
	            ,0) as total
		from ESolicitudCompraCM a
			inner join DSolicitudCompraCM b
				on a.ESidsolicitud=b.ESidsolicitud
			inner join Impuestos c
				on a.Ecodigo=c.Ecodigo
				and b.Icodigo=c.Icodigo
		where a.ESidsolicitud = <cfqueryparam value="#id#" cfsqltype="cf_sql_numeric">
	</cfquery>	
	<cfif rsTotal.RecordCount gt 0 and len(trim(rsTotal.total))>
		<cfreturn rsTotal.total>
	<cfelse>
		<cfreturn 0 >	
	</cfif>
	
</cffunction>

<!---=======AGREGAR============--->
<cfif isdefined('agregar')>
	<cfset arr 	   = ListToArray(form.VarSelecionados, ',', false)>
	<cfset LvarLen = ArrayLen(arr)>
	
	<!---- Moneda Local----->
	 <cfquery name="rsSQL" datasource="#session.dsn#"> 
		Select Mcodigo 
		  from Empresas
		 where Ecodigo	= <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	 
	</cfquery>
	<cfset LvarMcodigoLocal = rsSQL.Mcodigo>
	
	<!--- Moneda del Documento --->		
	<cfset LvarMcodigoDocumento = #form.Mcodigo#>
	
	<!--- Tipo de cambio  --->	
	<cfset LvarTC = 1>
	<cfquery name="rsDatosEnc" datasource="#Session.DSN#">
		select EStipocambio, TRcodigo , ESfecha  
			from ESolicitudCompraCM  
		where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Sid#">			   
	</cfquery>
	<cfif LvarMcodigoLocal neq  LvarMcodigoDocumento>
			<cfset LvarTC = rsDatosEnc.EStipocambio> 
	</cfif>		
    
	<!----MENSAJE DE ERROR EN CASO DE Q UN ARTICULO NO TENGA ALMACEN---->		
   	 <cfset LvarMensaje = "No se pudo agregar:\n">
	 <cfset ArticuloSinAlmacen= 0 >
	
 	<cfloop index="i" from="1" to="#LvarLen#">
			<cfset LvarLineaDet = "#ListGetAt(arr[i], 1 ,'|')#">  <!---Id de la linea de detalle --->	
			<cfset LvarIcodigo  = "#ListGetAt(arr[i], 2 ,'|')#">  <!---id impuesto --->	 	

			<cfinvoke component="sif.Componentes.PlanCompras" method="GetDetallePlanCompra"returnvariable="rsLineaPCMulti">
				<cfinvokeargument name="PCGDid" 	value="#LvarLineaDet#"/>
				<cfinvokeargument name="Ecodigo" 	value="#session.Ecodigo#"/>	
                <cfinvokeargument name="Fecha" 		value="#rsDatosEnc.ESfecha#"/>																								
			</cfinvoke>
			
			<cfif ListFind('P',rsLineaPCMulti.PCGDtipo) AND NOT LEN(TRIM(rsLineaPCMulti.OBOid))>
				<cfthrow message="Línea del Plan de Compras Inconsistente." detail="<br>Esta Definida como Obras en Construcción, pero la misma no esta configurada">
			</cfif>
			
			<!--- Ontener el porcentaje de impuesto --->
			<cfquery name="rsImpuesto" datasource="#session.DSN#">
				Select Iporcentaje, Icompuesto 
					from Impuestos  
				where Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	 
				  and Icodigo = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#LvarIcodigo#"> 
			</cfquery>		
			<cfset LvarImpuesto = rsImpuesto.Iporcentaje>	
			
			<cfif isdefined('rsImpuesto.Icompuesto') and  rsImpuesto.Icompuesto eq 1>
				  <cfquery name="rsImpuestoComp" datasource="#session.DSN#">
					 select sum(di.DIporcentaje) as Iporcentaje
						  from Impuestos i
							inner join DImpuestos di
							 on di.Ecodigo   = i.Ecodigo
							and di.Icodigo    = i.Icodigo
					   where i. Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						 and i.Icodigo  = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#LvarIcodigo#">
				  </cfquery>
			  <cfset LvarImpuesto = rsImpuestoComp.Iporcentaje>
			</cfif>

			<cfquery name="rsLineaMulti" datasource="#session.DSN#"> <!----OBTENGO EL ID DE LA TABLA DE MULTIPERIODOS------>
			   Select count(PCGDid) as PCsiGid 
			   	from PCGDplanComprasMultiperiodo 
				where PCGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaDet#"> 
			</cfquery>

		   <!----Estados para campos modificables
			   LvarModificable = 0    No permite cambiar ni monto ni cantidad
			   LvarModificable = 1    Permite cambiar Monto 
			   LvarModificable = 2    permite cambiar Cantidad
			   LvarModificable = 3    permite cambiar monto y Cantidad 	
			   ---->
			   
			<cfset  LvarCantidadExistente = 0>	 
			<cfif isdefined('form.AplicaCantidad') and form.AplicaCantidad eq 'on' and form.Tipo eq 'A'>
				<cfquery name="rsExistencias" datasource="#session.DSN#">
					select Eexistencia 
						from Existencias 
					   where Aid 	 = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.Aid#" >	
						 and Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	    
				</cfquery>	
					
				<cfif rsExistencias.recordcount gt 0 and len(trim(rsExistencias.Eexistencia)) gt 0>
						<cfset  LvarCantidadExistente = rsExistencias.Eexistencia>						 
				</cfif>				
			</cfif>				 
				<cfset fecha = rsDatosEnc.ESfecha>
			    <!-----Obtengo el CFormato a partir del PCGcuenta ----->
                <cfquery name="rsCFormato" datasource="#session.DSN#">
					select CFformato
					from PCGcuentas
					where PCGcuenta = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.PCGcuenta#" >
					  and Ecodigo   = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	 
				</cfquery>
		
				<!------Obtengo el CFcuenta a partir del CFormato---------->
				 <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="rsCta">
						<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>
						<cfinvokeargument name="Lprm_CFformato" value="#rsCFormato.CFformato#"/>
						<cfinvokeargument name="Lprm_fecha" 	value="#fecha#"/>
				</cfinvoke>
				<cfif NOT listfind('OLD,NEW', rsCta)>
					<cfthrow message="#rsCta#">
				</cfif>
				<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnObtieneCFcuenta" returnvariable="rsCta">
						<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>
						<cfinvokeargument name="Lprm_CFformato" value="#rsCFormato.CFformato#"/>
						<cfinvokeargument name="Lprm_fecha" 	value="#fecha#"/>
				</cfinvoke>
				
				<cfset LvarCFcuenta = rsCta.CFcuenta> <!---   CFcuenta  --->
							
    			<!--------------   Si el tipo es de Articulo    ----------------->
				<cfif form.Tipo eq 'A'>
				     <cfset LvarTipo = 'A'>
					 <cfquery name="rsDatosART" datasource="#session.DSN#" maxrows="1">
						  select Coalesce(Alm_Aid ,-1) Alm_Aid
						  	from Existencias 
						  where Aid 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.Aid#">	
						    and Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	    
					 </cfquery>
				</cfif>			
			     <!------------   Si el tipo es de Activos fijos   ------------->
				<cfif form.Tipo eq 'F'>
				    <cfset LvarTipo = 'F'>
					 <cfquery name="rsDatosAF" datasource="#session.DSN#">
						 select b.ACcodigo,b.ACid 
						 	from FPCatConcepto a 	
								inner join AClasificacion b 
									on b.AClaId = a.FPCCTablaC 
						where a.FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.FPCCid#">
						and a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">						
					 </cfquery>	 
				</cfif>
				 <!------------   Si el tipo es de Servicio   ------------->
				<cfif form.Tipo eq 'S'>
				    <cfset LvarTipo = 'S'>
				</cfif>				    
				
				<cfif not len(trim(rsDatosEnc.TRcodigo))>
					<cfif rsLineaMulti.PCsiGid gt 0 >                           <!-------- Si para el mismo ID existe registro en las dos tablas es q es ------->
						<!----Multiperiodo----->							  			   
						<cfif rsLineaPCMulti.PCGDxCantidad neq 1><!-------- Si no se maneja x cantidad ? --->         	
									 <cfset LvarCantidadMaxima = 1>
									 <cfset TotalSI = (LvarCantidadMaxima * rsLineaPCMulti.MultiMUnit)>
									 <cfset LvarMontoTotal = (TotalSI)/(1+LvarImpuesto/100)*100/100>									
									 <cfset LvarMontoTotal = LvarMontoTotal/LvarTC>										  							 
									 <cfset LvarMontoUnit  = LvarMontoTotal / LvarCantidadMaxima>									 
									 <cfset LvarModificable = 0>  							 					 					 
							 		
							 <cfelseif rsLineaPCMulti.PCGDxCantidad eq 1><!-------- Si se maneja cantidad ?--->
							         <cfset LvarCantidadMaxima = rsLineaPCMulti.MultiCantidad - LvarCantidadExistente>
									 <cfif LvarCantidadMaxima eq 0>
									     <cfthrow message="La cantidad máxima a consumir para el periodo ya fue alcanzada">
									 </cfif>
									 <cfset TotalSI = (LvarCantidadMaxima * rsLineaPCMulti.MultiMUnit)>
									 <cfset LvarMontoTotal = (TotalSI)/(1+LvarImpuesto/100)*100/100>
									 <cfset LvarMontoTotal = LvarMontoTotal/LvarTC>
									 <cfset LvarMontoUnit  = LvarMontoTotal / LvarCantidadMaxima>
									 <cfset LvarModificable = 0>                                          	
							 </cfif>					 				 
						<cfelse>
						<!----Periodo sencillo----->						
							 <cfif rsLineaPCMulti.PCGDxCantidad neq 1>      
							         <cfset LvarCantidadMaxima = 1>
									 <cfset LvarCantidad = 1>
									 <cfset TotalSI = (LvarCantidadMaxima * rsLineaPCMulti.PeriodoMUnit)> 
									 <cfset LvarMontoTotal = (TotalSI)/(1+LvarImpuesto/100)*100/100>
									 <cfset LvarMontoTotal = LvarMontoTotal/LvarTC>
									 <cfset LvarMontoUnit  = LvarMontoTotal / LvarCantidadMaxima>
									 <cfset LvarModificable = 1>                                            
							 
							 <cfelseif rsLineaPCMulti.PCGDxCantidad eq 1>                                   
							   <!----Si controla cantidad, calculo (Monto unitario x  cantidad )---->       
									  <cfset LvarCantidadMaxima = rsLineaPCMulti.PeriodoMCantidad - LvarCantidadExistente>
									  <cfif LvarCantidadMaxima eq 0>
									     <cfthrow message="La cantidad máxima a consumir para el periodo ya fue alcanzada">
									  </cfif>
									  <cfset TotalSI = (LvarCantidadMaxima * rsLineaPCMulti.PCGDcostoUori)>
									  <cfset LvarMontoTotal = (TotalSI)/(1+LvarImpuesto/100)*100/100>
									  <cfset LvarMontoTotal = LvarMontoTotal/LvarTC>
             						  <cfset LvarMontoUnit  = LvarMontoTotal / LvarCantidadMaxima>							 
									  <cfset LvarModificable = 2>  									  								  						  
							 </cfif>					 		
						</cfif>	
				<cfelse>
					  
					   <cfquery name="rsCostoU" datasource="#session.DSN#">
						  select Ecostou 
						  	 from Existencias 
							where Aid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.Aid#" >
						  and Alm_Aid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsDatosART.Alm_Aid#">	
						  and Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	    
						</cfquery>	
										 
					  <cfset LvarCantidadMaxima = rsLineaPCMulti.MaxReqCant>
					  <cfset LvarMontoUnit  	= rsCostoU.Ecostou>
					  <cfset LvarMontoTotal 	= LvarCantidadMaxima * LvarMontoUnit >							 
					  <cfset LvarModificable 	= 2>						
				</cfif>	
				
		<!----Si el tipo no es A entra, o si es A  y se encontro un almacen para el articulo----> 							
	   <cfif  form.Tipo neq 'A' or ( form.Tipo eq 'A'and rsDatosART.recordcount gt 0)>	    
             <!--------Insercion de las lineas del PL.C en los detalles---------->
		    <cfinvoke component="sif.Componentes.CM_SolicitudCompra" method="AltaDetalleSolicitud" returnvariable="insertDPC">
					<cfinvokeargument name="Ecodigo" 			value="#session.Ecodigo#">
					<cfinvokeargument name="ESidsolicitud" 		value="#form.Sid#">
					<cfinvokeargument name="ESnumero" 			value="#form.ESnumero#">
					<cfinvokeargument name="DStipo" 			value="#form.Tipo#">
					<cfinvokeargument name="DSdescripcion" 		value="#rsLineaPCMulti.DescripcionSolicitud#">
					<cfinvokeargument name="DSobservacion" 		value="">
					<cfinvokeargument name="DSdescalterna" 		value="">
					<cfinvokeargument name="DScant" 			value="#LvarCantidadMaxima#">
					<cfinvokeargument name="DSmontoest" 		value="#LvarMontoUnit#">
					<cfinvokeargument name="DStotallinest" 		value="#LvarMontoTotal#">
					<cfinvokeargument name="Ucodigo" 			value="#trim(rsLineaPCMulti.Ucodigo)#">
					<cfinvokeargument name="CFcuenta" 	 		value="#LvarCFcuenta#">
					<cfinvokeargument name="CFid" 				value="#rsLineaPCMulti.CFid#">
					<cfinvokeargument name="DSespecificacuenta" value="0">
					<!---<cfinvokeargument name="DSformatocuenta" 	value="#rsCFormato.CFformato#">,--->
					<cfinvokeargument name="FPAEid" 			value="#rsLineaPCMulti.FPAEid#">
					<cfinvokeargument name="PCGDid" 			value="#LvarLineaDet#">
					<cfinvokeargument name="DSmodificable" 		value="#LvarModificable#">
					<cfinvokeargument name="CFComplemento" 		value="#rsLineaPCMulti.CFComplemento#">	
						
				<cfif ListFind('A',form.Tipo)>
					<cfinvokeargument name="Aid" 				value="#rsLineaPCMulti.Aid#">
					<cfif rsDatosART.recordcount GT 0>
						<cfinvokeargument name="Alm_Aid" 			value="#rsDatosART.Alm_Aid#">
					</cfif>
				</cfif>
				<cfif ListFind('S,P',form.Tipo)>
					<cfinvokeargument name="Cid" 				value="#rsLineaPCMulti.Cid#">
				</cfif>
				<cfif ListFind('P',form.Tipo)>
					<cfinvokeargument name="OBOid" 				value="#rsLineaPCMulti.OBOid#">
				</cfif>
				<cfif ListFind('F',form.Tipo)>
					<cfinvokeargument name="ACcodigo" 			value="#rsDatosAF.ACcodigo#">
					<cfinvokeargument name="ACid" 				value="#rsDatosAF.ACid#">
				</cfif>	
				<cfif LEN(TRIM(LvarIcodigo))>
					<cfinvokeargument name="Icodigo" 			value="#LvarIcodigo#">
				</cfif>
				<cfinvokeargument name="DScontrolCantidad" 		value="#rsLineaPCMulti.PCGDxCantidad#">
			</cfinvoke>		
			
		       <cfset total = getTotal(form.Sid) >	
				<cfquery name="update" datasource="#session.DSN#">
					update ESolicitudCompraCM 
					  set EStotalest	= <cfqueryparam value="#total#" 	cfsqltype="cf_sql_numeric" scale="2">						
					where ESidsolicitud = <cfqueryparam value="#form.Sid#"  cfsqltype="cf_sql_numeric">
				</cfquery>	
		<cfelse>
		     <!---Si el articulo no tiene almacen guardo la descripcion para mostrarla al usuario que esos registros no se incluyeron ---> 		
            <cfset LvarMensaje &= '#rsLineaPCMulti.DescripcionSolicitud#\n'>
			 <cfset ArticuloSinAlmacen = 1 >
		</cfif>   			 
		 </cfloop><!----Termina el ciclo q ingresa las lineas al Detalle de la solicitud de Compra-------->
	  
     	 <cfif ArticuloSinAlmacen gt 0> 
	          <cfoutput>
    	       <script language="javascript1.2" type="text/javascript">
			      MensajeArt = '<cfoutput>#LvarMensaje#</cfoutput>';
		         alert(MensajeArt);
		       </script>
	    	 </cfoutput>
	     </cfif>  
	<script language="javascript1.2" type="text/javascript">  		
		window.opener.location.reload();
		window.close();
	</script>
</cfif>
<cfif isdefined('form.tipo') and isdefined('form.Categoria') >      
	  <cfset LvarTipoFil= #form.tipo#>
      <cfset LvarCatFil= #form.tipo#>
</cfif>
<title>Plan de Compras</title>
	<cfif isdefined('form.tipo') and len(trim(form.tipo)) gt 0>
	   <cfset LvarTipo= form.tipo>
    <cfelse> 	
	   <cfset LvarTipo= url.tipo>	
	   <cfset LvarTipoFil= url.tipo>       
	</cfif>
	<cfif isdefined('url.CMTS') and len(trim(#url.CMTS#)) gt 0>
	   <cfset LvarCMTS = url.CMTS>
	<cfelse>   
	    <cfset LvarCMTS = form.CMTS>
	</cfif>	
		<cfif isdefined('url.Mcodigo') and len(trim(#url.Mcodigo#)) gt 0>
	   <cfset LvarMcodigo = url.Mcodigo>
	<cfelseif  isdefined('form.Mcodigo') and len(trim(#form.Mcodigo#)) gt 0 >   
	    <cfset LvarMcodigo = form.Mcodigo>
	</cfif>	
	<cfif isdefined('form.CFid') and len(trim(form.CFid)) gt 0>
	   <cfset LvarCFid= form.CFid>
    <cfelse> 	
	   <cfset LvarCFid= url.CFid>
	   <cfset LvarCatFil = url.CFid> 	   
	</cfif>
	<cfif isdefined('form.Sid') and len(trim(form.Sid)) gt 0>
	   <cfset LvarSid= form.Sid>
    <cfelse> 	
	   <cfset LvarSid= url.Sid>	   	   
	</cfif>
	
	<cfif isdefined('form.ESnumero') and len(trim(form.ESnumero)) gt 0>
	   <cfset LvarESnumero= form.ESnumero>
    <cfelse> 	
	   <cfset LvarESnumero= url.ESnumero>	     
	</cfif>
	
	<cfif isdefined('form.tipo2') and len(trim(form.tipo2)) gt 0>
	   <cfset LvarTipoFil= form.tipo2>      
	</cfif>
	<cfif isdefined('form.TRcodigo') and len(trim(form.TRcodigo)) gt 0>
	   <cfset LvarTRcodigo= form.TRcodigo>
	<cfelseif isdefined('url.TRcodigo') and len(trim(url.TRcodigo)) gt 0>
	   <cfset LvarTRcodigo= url.TRcodigo>       
	</cfif>
		
	<cfquery name="rsSolicitanteXCfunc" datasource="#session.dsn#"> <!---Centros funcionales por solicitante---->
		  select a.CFid, a.CFcodigo, a.CFdescripcion
			from CFuncional a
			inner join CMSolicitantesCF b
				on b.CFid = a.CFid
			inner join CMTSolicitudCF c
			     on a.CFid = c.CFid
			inner join CMTiposSolicitud d
			      on d.CMTScodigo = c.CMTScodigo         	 
				where
				b.CMSid = #session.compras.solicitante#
				and a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		
				and d.CMTScodigo =<cfqueryparam  cfsqltype="cf_sql_varchar" value="#LvarCMTS#">
				and d.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		
		    order by a.CFdescripcion
	</cfquery>
	<cfquery name="rsListaCategorias" datasource="#session.dsn#"> <!---Categorias---->
		  select  
		    b.CFid,
			a.CMTScodigo,
			a.CMTSdescripcion,
			a.CMTStarticulo,
            a.CMTSservicio,
            a.CMTSactivofijo, 
			a.CMTSobras
		  from  CMTiposSolicitud a 
       inner join  CMTSolicitudCF b
         on a.CMTScodigo =  b.CMTScodigo
		where b.CFid 		= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarCFid#">
		  and a.Ecodigo		= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and a.CMTScodigo	= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#LvarCMTS#">
	</cfquery>	
<cfif isdefined ('form.lista')>
  <cfset ids = "">
  <cfset desc = "">
	<cfloop list="#form.CHK#" delimiters="," index="i">		
    	 <cfset lista = ListChangeDelims(i, '',',') >
		 <cfset ids &= ListGetAt(i,7,'|') & ','>
		 <cfset desc&= ListGetAt(i,6,'|') & ','>	 			  
	</cfloop>		
</cfif>
<form action="solicitudD-compras.cfm" method="post" name="form1" onSubmit="javascript: return selecionarTodos();" >
	<table width="100%" border="0" align="center">
	<tr><td colspan="2">&nbsp;</td></tr>
		<tr>			
			<td nowrap="nowrap"> 			
			<cfif isdefined('LvarSid') and len(trim(#LvarSid#)) gt 0>
		        <input type="hidden" name="Sid" value="<cfoutput>#LvarSid#</cfoutput>"/> 
			</cfif>
	
	   		<cfif isdefined('LvarESnumero') and len(trim(#LvarESnumero#)) gt 0>
			    <input type="hidden" name="ESnumero" value="<cfoutput>#LvarESnumero#</cfoutput>"/> 
			</cfif>
					
			<cfif isdefined('LvarMcodigo') and len(trim(#LvarMcodigo#)) gt 0>
			   <input type="hidden" name="Mcodigo" value="<cfoutput>#LvarMcodigo#</cfoutput>"/> 
		 	</cfif>
			
			<cfif isdefined('LvarTRcodigo') and len(trim(#LvarTRcodigo#)) gt 0>
		        <input type="hidden" name="TRcodigo" value="<cfoutput>#LvarTRcodigo#</cfoutput>"/> 
			</cfif>
			
			<cfif isdefined('LvarCMTS') and len(trim(#LvarCMTS#)) gt 0>
			   <input type="hidden" name="CMTS" value="<cfoutput>#LvarCMTS#</cfoutput>"/> 
			</cfif>
				
			<cfif isdefined('LvarTipoFil') and len(trim(#LvarTipoFil#)) gt 0>
			   <input type="hidden" name="tipo2" value="<cfoutput>#LvarTipoFil#</cfoutput>"/> 
			</cfif>
			
			<cfif isdefined('LvarCatFil') and len(trim(#LvarCatFil#)) gt 0>
			   <input type="hidden" name="Cat2" value="<cfoutput>#LvarCatFil#</cfoutput>" />
			</cfif>	
			      
				<strong>Centro Funcional:</strong>
				<select name="CFid" onchange="FuncSubmit();">
					<cfif rsSolicitanteXCfunc.recordcount gt 0>
						<cfloop query="rsSolicitanteXCfunc">
							<option <cfif LvarCFid eq rsSolicitanteXCfunc.CFid>selected </cfif> value="<cfoutput>#rsSolicitanteXCfunc.CFid#</cfoutput>"><cfoutput>#rsSolicitanteXCfunc.CFdescripcion#</cfoutput></option> 
						</cfloop>
					</cfif>			  
				</select>								
				<strong> Tipo:</strong>				
				<select name="tipo" id="tipo" <cfif rsListaCategorias.CMTStarticulo eq 1 or rsListaCategorias.CMTSservicio eq 1 or rsListaCategorias.CMTSactivofijo eq 1 > onchange="FuncSubmit();" </cfif>>	
				<cfif isdefined('LvarTRcodigo') and len(trim(LvarTRcodigo)) gt 0>				     
					   <option value="A" <cfif #LvarTipo# eq 'A'>Selected</cfif> >Articulo</option>				
				<cfelse> 
        			 <cfif rsListaCategorias.CMTStarticulo eq 1>
					   <option value="A" <cfif #LvarTipo# eq 'A'>Selected</cfif> >Articulo</option>
					 </cfif> 
				    <cfif rsListaCategorias.CMTSservicio eq 1>
            		   <option value="S" <cfif #LvarTipo# eq 'S'>Selected</cfif>>Servicio</option>
					 </cfif>  
				    <cfif rsListaCategorias.CMTSactivofijo eq 1>
				        <option value="F" <cfif #LvarTipo# eq 'F'>Selected</cfif>>Activo Fijo</option>
					</cfif>	
					<cfif rsListaCategorias.CMTSobras eq 1>
				        <option value="P" <cfif #LvarTipo# eq 'P'>Selected</cfif>>Obras en Contrucción</option>
					</cfif>	
				</cfif>	  							  
				</select>								
			</td>
		</tr>
		<tr align="center">	
		   <td align="center" bgcolor="#CCCCCC">
		     <div id="AplicaCant">			 	 
				<input type='checkbox' name='AplicaCantidad' id='AplicaCantidad' />		
				<strong>Considera cantidad de artículos existentes</strong>		  
			 </div>			 
		  </td>		
		</tr>
		<cfinvoke component="sif.Componentes.CM_SolicitudCompra" method="GetEncabezadoSolicitud"returnvariable="rsEncabezadoSoli">
			<cfinvokeargument name="ESidsolicitud" 	 value="#form.Sid#"/>
			<cfinvokeargument name="Ecodigo" 	     value="#session.Ecodigo#"/>																									
		</cfinvoke> 
			
		<cfinvoke component="sif.Componentes.PlanCompras" method="GetDetallePlanCompra" returnvariable="PlanComprasDet">
			<cfinvokeargument name="PCGDtipo" 	value="#LvarTipo#"/>
			<cfinvokeargument name="CFid" 		value="#LvarCFid#"/>
			<cfinvokeargument name="Ecodigo" 	value="#session.Ecodigo#"/>		
			<cfinvokeargument name="Fecha" 		value="#rsEncabezadoSoli.ESfecha#"/>
		<!---	<cfinvokeargument name="Mcodigo" 	value="#rsEncabezadoSoli.Mcodigo#"/>	--->
			<cfif isdefined('form.Filtro_PCGDDescripcion') and len(trim(#form.Filtro_PCGDDescripcion#))>
			    <cfinvokeargument name="Descripcion"value="#form.Filtro_PCGDDescripcion#"/>
			</cfif>	
			<cfif isdefined('form.Filtro_CPformato') and len(trim(#form.Filtro_CPformato#))>
			    <cfinvokeargument name="CPformato"value="#form.Filtro_CPformato#"/>
			</cfif>			
			<cfif isdefined('form.Filtro_OBPcodigo') and len(trim(#form.Filtro_OBPcodigo#))>
			    <cfinvokeargument name="Proyecto"value="#form.Filtro_OBPcodigo#"/>
			</cfif>
			<cfif isdefined('form.Filtro_OBPdescripcion') and len(trim(#form.Filtro_OBPdescripcion#))>
			    <cfinvokeargument name="ProyectoDes"value="#form.Filtro_OBPdescripcion#"/>
			</cfif>
			<cfif isdefined('form.Filtro_OBOcodigo') and len(trim(#form.Filtro_OBOcodigo#))>
			    <cfinvokeargument name="Obra"value="#form.Filtro_OBOcodigo#"/>
			</cfif>	
			<cfif isdefined('form.Filtro_OBOdescripcion') and len(trim(#form.Filtro_OBOdescripcion#))>
			    <cfinvokeargument name="ObraDes"value="#form.Filtro_OBOdescripcion#"/>
			</cfif>											
		</cfinvoke>					 
		 <cfif PlanComprasDet.recordcount gt 0>
		   <cfset navegacion = PlanComprasDet.PCGDid>
		<cfelse>
		   <cfset navegacion = 1>
		</cfif>
		<tr>			
			<td align="center" width="50%">
				<strong> Lista del Plan de Compras</strong>
			</td>
			<td align="center"><strong>Lista de Impuestos </strong></td> 			
		</tr>
		<tr>		
		<cfif isdefined('form.Tipo')>
		     <cfset LvarTipoSol = #form.Tipo#>
		<cfelse>
		     <cfset LvarTipoSol = ''> 
		</cfif>
		<cfif	PlanComprasDet.PCGDtipo eq 'P' or LvarTipoSol eq 'P' >
			 <cfset LvarDesplegar= "PCGDdescripcion ,OBPcodigo,OBPdescripcion,OBOcodigo,OBOdescripcion, PCGDcantidadTotal, PCGDcantidad, PCGDcantidadCompras, PCGDautorizadoTotal, PCGDautorizado,Disponible, TotalConsumido">
			 <cfset LvarEtiqueta= "Descripción, Código Proyecto,Proyecto Descr.,Código Obra, Obra Descr., Cantidad total, Cantidad del periodo Actual, Cantidad Consumida, Autorizado Total, Autorizado del periodo,Disponible, Consumido">
			 <cfset LvarFormato= "S,S,S,S,S,UM, UM, UM, UM, UM, UM,US">		 
			 <cfset LvarAlign= "left,left,left,left,left,right, right, right, right, right, right, right">
		<cfelse>
		     <cfset LvarDesplegar= "PCGDdescripcion ,CPFormato, PCGDcantidadTotal, PCGDcantidad, PCGDcantidadCompras, PCGDautorizadoTotal, PCGDautorizado,Disponible, TotalConsumido">
			 <cfset LvarEtiqueta= "Descripción, Actividad, Cantidad total, Cantidad del periodo Actual, Cantidad Consumida, Autorizado Total, Autorizado del periodo,Disponible, Consumido">
			 <cfset LvarFormato= "S,S,UM,UM, UM, UM, UM, UM, UM, UM, US">		 
			 <cfset LvarAlign= "left,left,right,right,right, right, right, right, right, right, right">
		</cfif>		
			<td align="center"  valign="top">
    				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
					<cfinvokeargument name="query" 				value="#PlanComprasDet#"/>
					<cfinvokeargument name="desplegar" 			value="#LvarDesplegar#"/>
					<cfinvokeargument name="etiquetas" 			value="#LvarEtiqueta#"/>
					<cfinvokeargument name="formatos" 			value="#LvarFormato#"/>
					<cfinvokeargument name="align" 				value="#LvarAlign#"/>
				
					<cfinvokeargument name="ajustar" 			value="N"/>
					<cfinvokeargument name="key" 				value="PCGDid" />
					<cfinvokeargument name="irA" 				value="solicitudD-compras.cfm?tipo=#LvarTipo#&CFid=#LvarCFid#"/>
					<cfinvokeargument name="showEmptyListMsg" 	value="false"/>
					<cfinvokeargument name="mostrar_filtro"     value="true"/>
					<cfinvokeargument name="MaxRows" 			value="20"/>
					<cfinvokeargument name="conexion" 			value="#session.dsn#"/>
					<cfinvokeargument name="usaAJAX" 			value="yes"/>
					<cfinvokeargument name="funcion" 			value="fnAsignarLista"/>
					<cfinvokeargument name="fparams" 			value="PCGDid,PCGDdescripciona"/>
					<cfinvokeargument name="formname" 			value="form1"/>
					<cfinvokeargument name="incluyeform" 		value="false"/>
				<cfif	PlanComprasDet.PCGDtipo eq 'A'>
					<cfinvokeargument name="botones"            value="Todos"/>		
				</cfif>					
				</cfinvoke>
			</td>
			<td align="center" valign="top" >
				<cfquery name="rsImpuestos" datasource="#Session.DSN#">
					select Icodigo, Idescripcion, 1 as ord, case when Icodigo = 'EI' then 1 else 0 end Impdefault
					from Impuestos
					where Ecodigo= #session.Ecodigo#
				</cfquery>
				<select name='listaImpuestos' id='listaImpuestos'>
					<cfloop query="rsImpuestos">
						<cfoutput><option value='#Icodigo#' <cfif #Impdefault# EQ "1">selected</cfif>>#Icodigo#-#Idescripcion#</option></cfoutput>
					</cfloop>
				</select>
			</td>			
		</tr>			
		<tr>  
		   		<td  align="center">
					<select size="8" name="listaSugerida"  id="listaSugerida" multiple="multiple"  ondblclick="fnDesasignarLista(this)">
					</select>
					<label id="msg">No se han selecionado lineas</label>					
				</td>									
		</tr>	
		<tr>
	    	<td align="center" height="30px"><input name="agregar" value="Agregar" type="submit" disabled="disabled" /></td>
			<td align="center" colspan="3"><strong>* Nota: Para eliminar las líneas seleccionadas, hacer doble clic sobre la línea a eliminar.</strong></td>
		</tr>
	</table>
    <input name="VarSelecionados" id="VarSelecionados" value="" type="hidden" />
</form>
<script language="javascript1.2" type="text/javascript">
//Obtiene la descripción con base al código
if(document.form1.tipo.value == 'A')
	   { 
		  document.getElementById("AplicaCant").style.display = "";		 
	   }
	   else
	   { 
		 document.getElementById("AplicaCant").style.display = "none";		
	   }
function validaCant()
{
	if(document.form1.tipo.value == 'A')
	   { 
		 document.getElementById("AplicaCant").style.display = "";
	   }
	   else
	   { 
		
		 document.getElementById("AplicaCant").style.display = "none";
	   }
}

	function TraeCFuncional(dato) {
		var params ="";
		params = "&CMSid=<cfoutput>#session.compras.solicitante#</cfoutput>&id=CFid&name=CFcodigo&desc=CFdescripcion";
		if (dato.value != "") {
			document.getElementById("fr").src="/cfmx/sif/cm/operacion/cfuncionalquery.cfm?dato="+dato.value+"&form=form1"+params;
		}
		else{
			document.form1.CFid.value = "";
			document.form1.CFcodigo.value = "";
			document.form1.CFdescripcion.value = "";
		}
		return;
	}
	

</script>
 <script language="javascript1.2" type="text/javascript">
 function FuncSubmit()
  {
     document.form1.submit();
	 validaCant();
	
  }
</script>
<script language="javascript1.2" type="text/javascript">

  <cfif isdefined('form.btnTodos')>
  	lista = document.getElementById("listaSugerida");
	listaImp = document.form1.listaImpuestos;
  	<cfoutput query="PlanComprasDet">
		option = document.createElement("option");
		option.value = "#PCGDid#|" + listaImp.value;
		if("#PCGDtipo#" == 'A')
  		{  option.title = '#ADescripcion#';  }
		else
		{  option.title = '#Descripcion#';   }

		option.innerHTML = '#PCGDdescripciona# -' + listaImp[listaImp.selectedIndex].text;
		lista.appendChild(option);
	</cfoutput>

  </cfif>
  
  function fnAsignarLista(id,descripcion)
  {
  	lista = document.getElementById("listaSugerida");
	listaImp = document.form1.listaImpuestos;
	for(i = 0; i < lista.length; i++){
		if(lista.options[i].value == id +'|'+listaImp[listaImp.selectedIndex].value)			 
			return false;
	}
	if(parseInt(listaImp.value) <= 0)
	   {  
	      alert("Primero elija un impuesto"); 		    
		  return false;
		}
	else{
		option = document.createElement("option");
		option.value = id +"|"+ listaImp[listaImp.selectedIndex].value;
		option.innerHTML = descripcion + " - " + listaImp[listaImp.selectedIndex].text;
		lista.appendChild(option);
		fnEdicion(lista);
	}
  }
   
    function fnDesasignarLista(obj)
  {
	lista = document.getElementById("listaSugerida");
	lista.removeChild(obj.options[obj.selectedIndex]);
	fnEdicion(lista);
  }
  
  function selecionarTodos(){
	sel   = document.getElementById("VarSelecionados");
	lista = document.getElementById("listaSugerida");
	t = "";
	for(i = 0; i < lista.length; i++){
			t+=lista[i].value+",";
	}
	sel.value=t;
	return true;
  }
 
   function fnEdicion(lista){
		boton = document.form1.agregar;
		boton.disabled = (lista.length > 0 ? "" : "disabled") ;
		if(lista.length > 0)
		lista.style.display = "";
		else
		  lista.style.display = "none";
		  
		document.getElementById("msg").style.display = (lista.length > 0 ? "none" : "") ;
		
  }  

  fnEdicion( document.form1.listaSugerida);
 
function funcTodos()
 {
   listaImp = document.form1.listaImpuestos;
	if(parseInt(listaImp.value) <= 0)
	   {  
	      alert("Primero elija un impuesto"); 		    
		  return false;
		}
 }
</script>
