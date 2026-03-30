<cfsetting requesttimeout="3600">
<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cf_dbfunction name='OP_concat' returnvariable='concat'>
<!---<cfset form.IDdocumento ="">--->
<cfif not isdefined('form.IDdocumento') and isdefined('url.IDdocumento')>
	<cfset form.IDdocumento = url.IDdocumento>
</cfif>
<!--- Function getTotal --->
<cffunction name="getTotal" returntype="query">
	<cfargument name="id" type="numeric" required="yes">

	<cfquery name="rsTotal" datasource="#session.DSN#">
		select coalesce(
                    sum(DDcantidad * DDpreciou)+
                    sum(DDcantidad * DDpreciou * Iporcentaje/100)
	            ,0) as total,
				coalesce(                  
                    sum(DDcantidad * DDpreciou * Iporcentaje/100)
	            ,0) as impuesto				
		from EDocumentosCxP a
			inner join DDocumentosCxP b
				on a.IDdocumento=b.IDdocumento
			inner join Impuestos c
				on a.Ecodigo=c.Ecodigo
				and b.Icodigo=c.Icodigo
		where a.IDdocumento = <cfqueryparam value="#id#" cfsqltype="cf_sql_numeric">
	</cfquery>	
<!---    <cf_dump var="#rsTotal#">--->
	<cfif rsTotal.RecordCount gt 0 and len(trim(rsTotal.total))>
		<cfreturn rsTotal>
	<cfelse>
		<cfreturn 0 >	
	</cfif>
	
</cffunction>

<!---=======AGREGAR============--->
<cfif isdefined('agregar')>


	<cfset arr 	   = ListToArray(form.VarSelecionados, ',', false)>
	<cfset LvarLen = ArrayLen(arr)>
	
	<!--- Tipo de cambio  --->	
	<cfset LvarTC = 1>
	
	<cfquery name="rsDatosEnc" datasource="#Session.DSN#">
		select EDfecha,SNcodigo,Ocodigo,CPTcodigo,Mcodigo  
			from EDocumentosCxP  
		where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">			   
	</cfquery>
	
	
<!----
	<cfif LvarMcodigoLocal neq  LvarMcodigoDocumento>
			<cfset LvarTC = rsDatosEnc.EStipocambio> 
	</cfif>		----->
	
    
	<!----MENSAJE DE ERROR EN CASO DE Q UN ARTICULO NO TENGA ALMACEN---->		
   	 <cfset LvarMensaje = "No se pudo agregar:\n">
	 <cfset ArticuloSinAlmacen= 0 >
	
 	<cfloop index="i" from="1" to="#LvarLen#">
			<cfset LvarLineaDet = "#ListGetAt(arr[i], 1 ,'|')#">  <!---Id de la linea de detalle --->	
			<cfset LvarIcodigo  = "#ListGetAt(arr[i], 2 ,'|')#">  <!---id impuesto --->	 	
        		   		   
			<cfinvoke component="sif.Componentes.PlanCompras" method="GetDetallePlanCompra"returnvariable="rsLineaPCMulti">
				<cfinvokeargument name="PCGDid" 	value="#LvarLineaDet#"/>
				<cfinvokeargument name="Ecodigo" 	value="#session.Ecodigo#"/>	
				<!---<cfinvokeargument name="Fecha"	 	value="#form.fechaFactura#"/> comentado a peticion de CONAVI para q use el now--->																								
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

			 
				<!---<cfset fecha = #form.fechaFactura#>comentado a peticion de CONAVI  para q use el now--->
				<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy')>
			
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
				
				<cfquery name="rsCcuenta" datasource="#session.DSN#">
				  select Ccuenta 
				      from CFinanciera 
					where Ecodigo = #session.ecodigo# 
				   and CFcuenta = #LvarCFcuenta#
				</cfquery>
								
				<!--------------   Si el tipo es de Articulo    ----------------->
				<cfset LvarAlm_Aid = "">
				<cfif form.Tipo eq 'A'>
				     <cfset LvarTipo = 'A'>
					 <cfquery name="rsDatosART" datasource="#session.DSN#" maxrows="1">
						  select Coalesce(Alm_Aid ,-1) as Alm_Aid
						  	from Existencias 
						  where Aid 	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.Aid#">	
						    and Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	    
					 </cfquery>
					 <cfset LvarAlm_Aid = #rsDatosART.Alm_Aid#>
					 <cfif rsDatosART.recordcount gt 0>
					 <cfquery name="rsConsultaDepto" datasource="#session.DSN#">
						select Dcodigo 
						from Almacen
						where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosART.Alm_Aid#">
					</cfquery>
					 </cfif>
					 
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
			<!------------------------------------------------------------------------------------------->
					    
				
				<!---<cfif not len(trim(rsDatosEnc.TRcodigo))>--->
					<cfif rsLineaMulti.PCsiGid gt 0 >                           <!-------- Si para el mismo ID existe registro en las dos tablas es q es ------->
						<!----Multiperiodo----->							  			   
						<cfif rsLineaPCMulti.PCGDxCantidad neq 1><!-------- Si no se maneja x cantidad ? --->         	
									 <cfset LvarCantidadMaxima = 1>
									 <cfset TotalSI = (rsLineaPCMulti.PCGDautorizado - rsLineaPCMulti.TotalConsumido)>
									 <cfset LvarMontoTotal = (TotalSI)/(1+LvarImpuesto/100)*100/100>									
									 <cfset LvarMontoTotal = LvarMontoTotal/LvarTC>										  							 
									 <cfset LvarMontoUnit  = LvarMontoTotal / LvarCantidadMaxima>									 
									 <cfset LvarModificable = 0> 									 							 			 					 					 
							 		
							 <cfelseif rsLineaPCMulti.PCGDxCantidad eq 1><!-------- Si se maneja cantidad ?--->
							         <cfset LvarCantidadMaxima = rsLineaPCMulti.MultiCantidad>
									 <cfset TotalSI = (rsLineaPCMulti.PCGDautorizado - rsLineaPCMulti.TotalConsumido )>
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
									 <cfset TotalSI = ( rsLineaPCMulti.PCGDautorizado - rsLineaPCMulti.TotalConsumido)> 									 
									 <cfset LvarMontoTotal = (TotalSI)/(1+LvarImpuesto/100)*100/100>
									 <cfset LvarMontoTotal = LvarMontoTotal/LvarTC>
									 <cfset LvarMontoUnit  = LvarMontoTotal / LvarCantidadMaxima>
									 <cfset LvarModificable = 1> 									
							 <cfelseif rsLineaPCMulti.PCGDxCantidad eq 1>                                   
							   <!----Si controla cantidad, calculo (Monto unitario x  cantidad )---->       
									  <cfset LvarCantidadMaxima = rsLineaPCMulti.PeriodoMCantidad>
									  <cfset TotalSI = (rsLineaPCMulti.PCGDautorizado - rsLineaPCMulti.TotalConsumido)>
									  <cfset LvarMontoTotal = (TotalSI)/(1+LvarImpuesto/100)*100/100>
									  <cfset LvarMontoTotal = LvarMontoTotal/LvarTC>
             						  <cfset LvarMontoUnit  = LvarMontoTotal / LvarCantidadMaxima>							 
									  <cfset LvarModificable = 2>									
							 </cfif>					 		
						</cfif>	
			<!---	<cfelse>
					  
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
				</cfif>	--->
				
		<!----Si el tipo no es A entra, o si es A  y se encontro un almacen para el articulo----> 							
	   <cfif form.Tipo neq 'A' or form.Tipo eq 'A' and rsDatosART.recordcount gt 0>	    
	  
	    <!--------Insercion de las lineas del PL.C en los detalles---------->
			<cftransaction>
			<cfquery name="rsInsertDDocCP" datasource="#session.DSN#">
				insert into DDocumentosCxP 
					(	IDdocumento,
						Aid,
						Cid,
						DDdescripcion,
						DDdescalterna,
						CFid,
						Alm_Aid,  Dcodigo,
						DDcantidad,
						DDpreciou, 
						DDdesclinea,
						DDporcdesclin, 
						DDtotallinea, 
						DDtipo, 
						Ccuenta,
						CFcuenta,
						Ecodigo, 
						OCTtipo,
						OCTtransporte,
						OCTfechaPartida,
						OCTobservaciones,
						OCCid,
						OCid,						
						Icodigo,
						PCGDid,
						FPAEid,
						CFComplemento,
						OBOid,
						BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">,
					<cfif  isDefined("Form.tipo") and  Form.tipo eq 'A'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.Aid#">
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					</cfif>,
					<cfif  isDefined("Form.tipo") and  Form.tipo eq 'S'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.Cid#">,
					<cfelse>	
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 
					</cfif>				
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineaPCMulti.DescripcionSolicitud#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.CFid#">,

					<cfif LvarAlm_Aid NEQ "">
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosART.Alm_Aid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsultaDepto.Dcodigo#">,
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
					</cfif>					
					<cf_jdbcquery_param cfsqltype="cf_sql_float" value="#LvarCantidadMaxima#">,
					#LvarOBJ_PrecioU.enCF(LvarMontoUnit)#,
					<cfqueryparam cfsqltype="cf_sql_money" value="0">,
					<cfqueryparam cfsqltype="cf_sql_float" value="0">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#numberFormat(LvarMontoTotal,"9.00")#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.tipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCcuenta.Ccuenta#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuenta#" null="#LvarCFcuenta EQ ""#">,
					 #Session.Ecodigo# ,
					<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
					<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
					<cfif Len(Trim(LvarIcodigo)) GT 0 > 
						<cfqueryparam cfsqltype="cf_sql_char" value="#LvarIcodigo#">,
					<cfelse>	
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
					</cfif>	
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaDet#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.FPAEid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineaPCMulti.CFComplemento#">,
					<cfif len(trim(rsLineaPCMulti.OBOid)) gt 0> 
    					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaPCMulti.OBOid#">,
					<cfelse>
					   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				) 
			</cfquery>
			
			</cftransaction>		 
			
		        <cfset DatosUpdate = getTotal(Form.IDdocumento) >	
				<cfquery name="update" datasource="#session.DSN#">
					update EDocumentosCxP 
					  set EDtotal	= <cfqueryparam value="#DatosUpdate.total#" 	cfsqltype="cf_sql_numeric" scale="2">,
					  	EDimpuesto =  <cfqueryparam value="#DatosUpdate.impuesto#" 	cfsqltype="cf_sql_numeric" scale="2">					
					where IDdocumento = <cfqueryparam value="#Form.IDdocumento#"  cfsqltype="cf_sql_numeric">
				</cfquery>	
		<cfelse>
		     <!---Si el articulo no tiene almacen guardo la descripcion para mostrarla al usuario que esos registros no se incluyeron ---> 		
            <cfset LvarMensaje = LvarMensaje & '#rsLineaPCMulti.DescripcionSolicitud#, ya que NO se encontro un almacen para el articulo'>
			 <cfset ArticuloSinAlmacen = 1 >
		</cfif>   			 
		 </cfloop><!----Termina el ciclo q ingresa las lineas al Detalle de la solicitud de Compra-------->
	  
     	 <cfif ArticuloSinAlmacen gt 0> 
	          <cfoutput>
    	       <cfthrow message = "#LvarMensaje#">
	          <script language="javascript1.2" type="text/javascript">
			      MensajeArt = <cfoutput>#LvarMensaje#</cfoutput>
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
	<cfquery name="rsCFuncional" datasource="#session.dsn#" maxrows="1"> <!---Me devuelve solo el primer Centro Funcional---->
	  select  CFid, CFcodigo, CFdescripcion
			from CFuncional 
				where Ecodigo = #session.Ecodigo#
	</cfquery>
	
		
    <cfset LvarTipo='A'>
	<cfif isdefined('form.tipo') and len(trim(form.tipo)) gt 0>
	   <cfset LvarTipo= form.tipo>
    <cfelseif  isdefined('url.tipo') and len(trim(form.tipo))> 	
	   <cfset LvarTipo= url.tipo>	
	   <cfset LvarTipoFil= url.tipo>       
	</cfif>
	

	<cfset LvarCFid=#rsCFuncional.CFid#>
	<cfset LvarCatFil ="">
	<cfif isdefined('form.CFid') and len(trim(form.CFid)) gt 0>
	   <cfset LvarCFid= form.CFid>
    <cfelseif isdefined('url.CFid') and len(trim(#url.CFid#))> 	
	   <cfset LvarCFid= url.CFid>
	   <cfset LvarCatFil = url.CFid> 	   
	</cfif>
	
	
	<cfset LvarDid= "">
	<cfif isdefined('form.IDdocumento') and len(trim(form.IDdocumento)) gt 0>
	     <cfset LvarDid= form.IDdocumento>
    <cfelseif isdefined('url.documento') and len(trim(url.documento))> 	
	     <cfset LvarDid= url.documento>	 
	</cfif>
	
	<cfif isdefined('form.fechaFactura') and len(trim(form.fechaFactura)) gt 0>
	     <cfset fechaFactura= form.fechaFactura>
    <cfelseif isdefined('url.fechaFactura') and len(trim(url.fechaFactura))> 	
	     <cfset fechaFactura= url.fechaFactura>	    
	</cfif>
		
	<cfif isdefined('form.tipo2') and len(trim(form.tipo2)) gt 0>
	   <cfset LvarTipoFil= form.tipo2>      
	</cfif>
	
	<cfquery name="rsCFuncionales" datasource="#session.dsn#"> 
	  select distinct CFid, CFcodigo, CFdescripcion
			from CFuncional 				
				where Ecodigo = #session.Ecodigo#
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


<form action="planComprasFactura.cfm" method="post" name="form1" onSubmit="javascript: return selecionarTodos();" >
	<table width="100%" border="0" align="center">
	<tr><td colspan="2">&nbsp;</td></tr>
		<tr>			
			<td nowrap="nowrap">						
			<cfif isdefined('LvarDid') and len(trim(#LvarDid#)) gt 0>
		        <input type="hidden" name="IDdocumento" value="<cfoutput>#LvarDid#</cfoutput>"/> 
			</cfif>
			<cfif isdefined('fechaFactura') and len(trim(#fechaFactura#)) gt 0>
		        <input type="hidden" name="fechaFactura" value="<cfoutput>#fechaFactura#</cfoutput>"/> 
			</cfif>
	     
				<strong>Centro Funcional:</strong>
				<select name="CFid" onchange="FuncSubmit();">
					<cfif rsCFuncionales.recordcount gt 0>
						<cfloop query="rsCFuncionales">
							<option <cfif LvarCFid eq rsCFuncionales.CFid>selected </cfif> value="<cfoutput>#rsCFuncionales.CFid#</cfoutput>"><cfoutput>#rsCFuncionales.CFdescripcion#</cfoutput></option> 
						</cfloop>
					</cfif>			  
				</select>									
				<strong> Tipo:</strong>		
				<select name="tipo" id="tipo"  onchange="FuncSubmit();">
						   <option value="A" <cfif #LvarTipo# eq 'A'>Selected</cfif>>Articulo</option>						
						   <option value="S"<cfif #LvarTipo# eq 'S'>Selected</cfif> >Servicio</option>						
						   <option value="F" <cfif #LvarTipo# eq 'F'>Selected</cfif>>Activo Fijo</option>						
						   <option value="P" <cfif #LvarTipo# eq 'P'>Selected</cfif>>Obras en Contrucción</option>
				</select>								
			</td>
		</tr>

		<cfinvoke component="sif.Componentes.PlanCompras" method="GetDetallePlanCompra" returnvariable="PlanComprasDet">
		 	<cfif len(trim(#LvarTipo#))>
			   <cfinvokeargument name="PCGDtipo" 	value="#LvarTipo#"/>
			</cfif> 
			<cfif len(trim(#LvarCFid#))>
			   <cfinvokeargument name="CFid" 		value="#LvarCFid#"/>
			</cfif>
			<cfinvokeargument name="Ecodigo" 	value="#session.Ecodigo#"/>	
			<cfif isdefined('form.Filtro_PCGDDescripcion') and len(trim(#form.Filtro_PCGDDescripcion#))>
			    <cfinvokeargument name="Descripcion"value="#form.Filtro_PCGDDescripcion#"/>
			</cfif>	
			<cfif isdefined('form.Filtro_CPFormato') and len(trim(#form.Filtro_CPFormato#))>
			    <cfinvokeargument name="CPFormato"value="#form.Filtro_CPFormato#"/>
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
			<!---<cfinvokeargument name="Fecha"	 			value="#fechaFactura#"/>comentado a peticion de CONAVI para q use el now--->											
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
					<!---<cfinvokeargument name="irA" 				value="solicitudD-compras.cfm?tipo=#LvarTipo#&CFid=#LvarCFid#"/>--->
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
<!---if(document.form1.tipo.value == 'A')
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
}--->

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
