<cfif isdefined('agregar')>
	<cfset arr = ListToArray(#form.VarSelecionados#, ',', false)>
	<cfset LvarLen = ArrayLen(#arr#)>
	 
 <cfloop index="i" from="1" to="#LvarLen#">
	 
			<cfset LvarLineaDet = "#ListGetAt(arr[i], 1 ,'/')#">  <!---Id de la linea de detalle --->	
			<cfset LvarIcodigo  = "#ListGetAt(arr[i], 2 ,'/')#">  <!---id impuesto --->	 	
		   
			<cfquery name="rsSQL" datasource="#session.dsn#"> <!---- Moneda de la empresa ----->
				Select Mcodigo 
				  from Empresas
				 where Ecodigo	= <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	 
			</cfquery>
			
			<cfset LvarMcodigoLocal = rsSQL.Mcodigo>
			<cfset LvarMcodigoDocumento = #form.Mcodigo#>
			<cfset LvarTC = 1>
	
			<cfif LvarMcodigoLocal neq  LvarMcodigoDocumento> <!------Si la moneda del documento es diferente a la moneda de la empresa -------->
					<cfquery name="rsTC" datasource="#Session.DSN#">
						select EDtipocambio       
						  from EDocumentosCxP  
						  where Mcodigo = <cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">			   
						  and IDdocumento =<cfqueryparam value="#form.Sid#" cfsqltype="cf_sql_numeric">			   
					</cfquery>
						<cfset LvarTC = rsTC.EDtipocambio> 
			</cfif>
			
			<cfquery name="rsEncabezado" datasource="#Session.DSN#">
					select EDfecha      
					  from EDocumentosCxP  
					  where IDdocumento =<cfqueryparam value="#form.Sid#" cfsqltype="cf_sql_numeric">			   
			</cfquery>
			
			<cfset LvarImpuesto = 0>
			<cfquery name="rsImpuesto" datasource="#session.DSN#">
				Select Iporcentaje, Icompuesto from Impuestos  where Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	 
				and Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarIcodigo#"> 
			</cfquery>		
				
			<cfset LvarImpuesto = rsImpuesto.Iporcentaje>	
			<cfif isdefined('rsImpuesto.Icompuesto') and  rsImpuesto.Icompuesto eq 1>
			  <cfquery name="rsImpuestoComp" datasource="#session.DSN#">
                 select sum(di.DIporcentaje) as Iporcentaje
                      from Impuestos i
                        inner join DImpuestos di
                         on di.Ecodigo   = i.Ecodigo
                        and di.Icodigo    = i.Icodigo
                   where i. Ecodigo =<cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                      and i.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarIcodigo#">
			  </cfquery>
			  <cfset LvarImpuesto = rsImpuestoComp.Iporcentaje>
			</cfif>
			
			<cfquery name="rsLineaDet" datasource="#session.DSN#"> <!----OBTENGO EL ID DE LA TABLA DE PERIODOS SENCILLOS------>
			   Select count(PCGDid) as PCsiGid from PCGDplanCompras where PCGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaDet#">   and Ecodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		 
			</cfquery>
		   
			<cfquery name="rsLineaMulti" datasource="#session.DSN#"> <!----OBTENGO EL ID DE LA TABLA DE MULTIPERIODOS------>
			   Select count(PCGDid) as PCsiGid from PCGDplanComprasMultiperiodo where PCGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaDet#"> 
			</cfquery>

		   <cfinvoke 
				component="sif.Componentes.PlanCompras"
				method="GetDetallePlanCompra"
				returnvariable="rsLineaPCMulti">
					<cfinvokeargument name="PCGDid" value="#LvarLineaDet#"/>
					<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>							
			</cfinvoke>
					
		   <!----Estados para campos modificables
			   LvarModificable = 0    No permite cambiar ni monto ni cantidad
			   LvarModificable = 1    Permite cambiar Monto 
			   LvarModificable = 2    permite cambiar Cantidad 
			---->			
				   
			<cfif rsLineaDet.PCsiGid gt 0 and rsLineaMulti.PCsiGid gt 0 >                           <!-------- Si para el mismo ID existe registro en las dos tablas es q es ------->
			  
				<!----Multiperiodo----->					   
				<cfif rsLineaPCMulti.PCGDxCantidad neq 1>                                           <!-------- Si no se maneja x cantidad ? --->                	
							                                      							 
							 <cfset LvarCantidadMaxima = 1>
							 <cfset LvarMontoTotal =  round (( LvarCantidadMaxima * rsLineaPCMulti.MultiMUnit)/(1+LvarImpuesto/100)*100)/100>	
							 <cfset LvarMontoTotal = LvarMontoTotal/LvarTC>
							 <cfset LvarMontoUnit  = LvarMontoTotal / LvarCantidadMaxima>
							 <cfset LvarModificable = 0>  							 					 					 
				     
					 <cfelseif rsLineaPCMulti.PCGDxCantidad eq 1>                                   <!-------- Si se maneja cantidad ?--->
				     
							 <cfset LvarCantidadMaxima = rsLineaPCMulti.MultiCantidad>
							 <cfset LvarMontoTotal =  round ((LvarCantidadMaxima * rsLineaPCMulti.MultiMUnit)/(1+LvarImpuesto/100)*100)/100>
							 <cfset LvarMontoTotal = LvarMontoTotal/LvarTC>
							 <cfset LvarMontoUnit  = LvarMontoTotal / LvarCantidadMaxima>
							 <cfset LvarModificable = 0>                                          	
				     </cfif>					 				 
		        <cfelse>
         		<!----Periodo sencillo----->
				     <cfif rsLineaPCMulti.PCGDxCantidad neq 1>                                      
							 <cfset LvarCantidad = 1>
							 <cfset LvarMontoTotal = round ((LvarCantidadMaxima *rsLineaPCMulti.PeriodoMUnit)/(1+LvarImpuesto/100)*100)/100>
							 <cfset LvarMontoTotal = LvarMontoTotal/LvarTC>
							 <cfset LvarMontoUnit  = LvarMontoTotal / LvarCantidadMaxima>
							 <cfset LvarModificable = 1>                                            
				     
					 <cfelseif rsLineaPCMulti.PCGDxCantidad eq 1>                                   
							 <cfset  LvarCantidadMaxima = rsLineaPCMulti.PeriodoMCantidad>
							  <cfset LvarMontoTotal = round ((LvarCantidadMaxima * rsLineaPCMulti.PeriodoMUnit)/(1+LvarImpuesto/100)*100)/100>
							  <cfset LvarMontoTotal = LvarMontoTotal/LvarTC>
							  <cfset LvarMontoUnit  = LvarMontoTotal / LvarCantidadMaxima>							 
					          <cfset LvarModificable = 2>   
				     </cfif>					 		
			    </cfif>						
				
				<cfset linea = 1 >
				
				<!---- Plan Compras -----  Sol.Compras  ----->
				<!---- Articulos = A          A         ----->
				<!---- Servicios = S          S         ----->
				<!---- Act Fijos = F          F         -----> 
			    
				<!--------------   Si el tipo es de Articulo    ----------------->
				<cfif form.Tipo eq 'A'>
				     <cfset LvarTipo = 'A'>
					 <cfquery name="rsDatosART" datasource="#session.DSN#">
						  select top 1 *  from Existencias where Aid = <cfqueryparam value="#rsLineaPCMulti.Aid#" cfsqltype="cf_sql_numeric">	
						  and Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	    
					 </cfquery>
				</cfif>			
			     <!------------   Si el tipo es de Activos fijos   ------------->
				<cfif form.Tipo eq 'F'>
				    <cfset LvarTipo = 'F'>
					 <cfquery name="rsDatosAF" datasource="#session.DSN#">
						 select b.ACcodigo,b.ACid from FPCatConcepto a 	inner join AClasificacion b 
							on b.ACid = a.FPCCTablaC and a.Ecodigo = b.Ecodigo
						where a.FPCCid = <cfqueryparam value="#rsLineaPCMulti.FPCCid#" cfsqltype="cf_sql_numeric">
						and a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">						
					 </cfquery>
				</cfif>
				 <!------------   Si el tipo es de Servicio   ------------->
				<cfif form.Tipo eq 'S'>
				    <cfset LvarTipo = 'S'>
				</cfif>	
				<cfif form.Tipo eq 'P'>
				    <cfset LvarTipo = 'P'>
				</cfif>	
			    
				<!-----Obtengo el CFormato a partir del PCGcuenta ----->
				<cfquery name="rsCFormato" datasource="#session.DSN#">
					select CFformato
					from PCGcuentas
					where PCGcuenta = <cfqueryparam value="#rsLineaPCMulti.PCGcuenta#" cfsqltype="cf_sql_numeric">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				
				<cfset fecha = rsEncabezado.EDfecha>
				<!------Obtengo el CFcuenta a partir del CFormato---------->
							
				 <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" 
				 method="fnGeneraCuentaFinanciera" returnvariable="rsCta">
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
								

				<!---------    Obtengo el formato de la cuenta      ---------->
				<cfquery name="rsFormatoCuenta" datasource="#session.DSN#">
					 select CFformato from CFinanciera where Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					 and CFcuenta = <cfqueryparam value="#LvarCFcuenta#" cfsqltype="cf_sql_numeric">	 
				</cfquery>
			
			    <!---------  Obtengo el complemento de la actividad   --------->
				<cfquery name="rsActividad" datasource="#session.DSN#">
					 select b.CFComplemento from  FPActividadE a  inner join FPDEstimacion b on a.FPAEid = b.FPAEid 
					  where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and b.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and a.FPAEid = <cfqueryparam value="#rsLineaPCMulti.FPAEid#" cfsqltype="cf_sql_numeric">	 
				</cfquery>					
				
	<!--------Insercion de las lineas del PL.C en los detalles---------->
		   <cfquery name="insertd" datasource="#session.DSN#" >
					insert into DDocumentosCxP     ( Ecodigo,
					                                 IDdocumento, 
													 <!---ESnumero,--->
													 <!---DSconsecutivo,--->
													 DDtipo,
													 Aid,
													 Alm_Aid, 
													 Cid,
													 <!---ACcodigo,
													 ACid,--->
													 DDdescripcion,  
													 <!---DSobservacion,--->
													<!--- DSdescalterna,--->
													 Icodigo,
                    								 DDcantidad,
													 DDpreciou,
													 DDtotallinea,
													 DDdesclinea,
													 DDporcdesclin,
													 DDtransito,
													 Ucodigo,
													 <!---CFcuenta, preguntar si se ocupa y si solo Ccuenta o CFcuenta--->
													 <!---DSfechareq,--->
													 CFid,
													 <!---DSespecificacuenta,--->
													 <!---CFidespecifica,--->
													 <!---DSformatocuenta,--->
													 <!---FPAEid, el campo no existe...preguntar si tengo q crearlo--->
													 <!---CFComplemento,--->
													 <!---DSmodificable,--->
													 PCGDid 
													 )
						values (
						        
								<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
								<cfqueryparam value="#form.Sid#" cfsqltype="cf_sql_numeric">, 
								<!---<cfqueryparam value="#form.ESnumero#" cfsqltype="cf_sql_integer">, --->
								<!---<cfqueryparam value="#linea#" cfsqltype="cf_sql_integer">, --->
								<cfqueryparam value="#LvarTipo#" cfsqltype="cf_sql_char">, 
								
								<cfif form.Tipo eq 'A' ><cfqueryparam value="#rsLineaPCMulti.Aid#" cfsqltype="cf_sql_numeric"><cfelse><cf_jdbcquery_param value="null" cfsqltype="cf_sql_numeric"></cfif>, 
								<cfif form.Tipo eq 'A' ><cfqueryparam value="#rsDatosART.Alm_Aid#" cfsqltype="cf_sql_numeric"><cfelse><cf_jdbcquery_param value="null" cfsqltype="cf_sql_numeric"></cfif>, 
								
								<cfif form.Tipo eq 'S' ><cfqueryparam value="#rsLineaPCMulti.Cid#" cfsqltype="cf_sql_numeric"><cfelse><cf_jdbcquery_param value="null" cfsqltype="cf_sql_numeric"></cfif>, 
								
								<!---<cfif form.Tipo eq 'A'><cfqueryparam value="#rsDatosAF.ACcodigo#" cfsqltype="cf_sql_integer"><cfelse><cf_jdbcquery_param value="null" cfsqltype="cf_sql_integer"></cfif>, 
								<cfif form.Tipo eq 'A'><cfqueryparam value="#rsDatosAF.ACid#" cfsqltype="cf_sql_integer"><cfelse><cf_jdbcquery_param value="null" cfsqltype="cf_sql_integer"></cfif>, --->
								
								<cfqueryparam value="#rsLineaPCMulti.PCGDdescripcion#" cfsqltype="cf_sql_varchar">, 
								<!---<cf_jdbcquery_param value="null" cfsqltype="cf_sql_varchar">,--->
								<!---<cf_jdbcquery_param value="null" cfsqltype="cf_sql_longvarchar">,--->
								<cfif len(trim(LvarIcodigo)) gt 0><cfqueryparam value="#LvarIcodigo#" cfsqltype="cf_sql_varchar"><cfelse><cf_jdbcquery_param value="null" cfsqltype="cf_sql_varchar"></cfif>,

								<cfqueryparam value="#LvarCantidadMaxima#" cfsqltype="cf_sql_float">, 
								#LvarMontoUnit#,
								round(#LvarMontoTotal#,2),
								0,
								0,
								0,
								<cfqueryparam value="#trim(rsLineaPCMulti.Ucodigo)#" cfsqltype="cf_sql_varchar">,
								<!---<cfqueryparam value="#trim(rsLineaPCMulti.CFcuenta)#" cfsqltype="cf_sql_numeric">,--->
								<!---<cf_jdbcquery_param value="null" cfsqltype="cf_sql_timestamp">,--->
								<cfqueryparam value="#rsLineaPCMulti.CFid#" cfsqltype="cf_sql_numeric">,
								<!---1,--->
								<!---<cfqueryparam value="#rsLineaPCMulti.CFcuenta#" cfsqltype="cf_sql_numeric">,--->
								<!---<cfqueryparam value="#rsFormatoCuenta.CFformato#" cfsqltype="cf_sql_varchar">,--->
								<!---<cfqueryparam value="#rsLineaPCMulti.FPAEid#" cfsqltype="cf_sql_numeric">,--->
								<!---<cfqueryparam value="#rsActividad.CFComplemento#" cfsqltype="cf_sql_varchar">,--->
								<!---<cfqueryparam value="#LvarModificable#" cfsqltype="cf_sql_char">,--->
								<cfqueryparam value="#LvarLineaDet#" cfsqltype="cf_sql_numeric">
								)						 
				</cfquery>
		   
 </cfloop><!----Termina el ciclo q ingresa las lineas al Detalle de la solicitud de Compra-------->
	
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
	<!---<cfif isdefined('url.CMTS') and len(trim(#url.CMTS#)) gt 0>
	   <cfset LvarCMTS = url.CMTS>
	<cfelse>   
	    <cfset LvarCMTS = form.CMTS>
	</cfif>	--->
		<cfif isdefined('url.Mcodigo') and len(trim(#url.Mcodigo#)) gt 0>
	   <cfset LvarMcodigo = url.Mcodigo>
	<cfelse>   
	    <cfset LvarMcodigo = form.Mcodigo>
	</cfif>	
	<!---<cfif isdefined('form.CFid') and len(trim(form.CFid)) gt 0>
	   <cfset LvarCFid= form.CFid>
    <cfelse> 	
	   <cfset LvarCFid= url.CFid>
	   <cfset LvarCatFil = url.CFid> 	   
	</cfif>--->
	<cfif isdefined('form.Sid') and len(trim(form.Sid)) gt 0>
	   <cfset LvarSid= form.Sid>
    <cfelse> 	
	   <cfset LvarSid= url.Sid>	   	   
	</cfif>
	
	<!---<cfif isdefined('form.ESnumero') and len(trim(form.ESnumero)) gt 0>
	   <cfset LvarESnumero= form.ESnumero>
    <cfelse> 	
	   <cfset LvarESnumero= url.ESnumero>	     
	</cfif>--->
	
	<cfif isdefined('form.tipo2') and len(trim(form.tipo2)) gt 0>
	   <cfset LvarTipoFil= form.tipo2>      
	</cfif>
		
	<!---<cfquery name="rsSolicitanteXCfunc" datasource="#session.dsn#"> Centros funcionales por solicitante
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
	</cfquery>--->
	<!---<cfquery name="rsListaCategorias" datasource="#session.dsn#">  Categorias
		  select  
		    b.CFid,
			a.CMTScodigo,
			a.CMTSdescripcion,
			a.CMTStarticulo,
            a.CMTSservicio,
            a.CMTSactivofijo  
		  from  CMTiposSolicitud a 
       inner join  CMTSolicitudCF b
         on a.CMTScodigo =  b.CMTScodigo
		where 			
		    b.CFid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#LvarCFid#">
			and a.Ecodigo= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and a.CMTScodigo= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#LvarCMTS#">
	</cfquery>	--->
<cfif isdefined ('form.lista')>
  <cfset ids = "">
  <cfset desc = "">
	<cfloop list="#form.CHK#" delimiters="," index="i">		
    	 <cfset lista = ListChangeDelims(i, '',',') >
		 <cfset ids &= ListGetAt(i,7,'|') & ','>
		 <cfset desc&= ListGetAt(i,6,'|') & ','>	 			  
	</cfloop>		
</cfif>
<form action="popUp-PlanComprasCP.cfm" method="post" name="form1" onSubmit="javascript: return selecionarTodos();" >
	<table width="100%" border="0" align="center">
	<tr><td colspan="2">&nbsp;</td></tr>
		<tr>			
			<td> 			
			<cfif isdefined('LvarSid') and len(trim(#LvarSid#)) gt 0>
		        <input type="hidden" name="Sid" value="<cfoutput>#LvarSid#</cfoutput>"/> 
			</cfif>
	
	   		<cfif isdefined('LvarESnumero') and len(trim(#LvarESnumero#)) gt 0>
			    <input type="hidden" name="ESnumero" value="<cfoutput>#LvarESnumero#</cfoutput>"/> 
			</cfif>
					
			<cfif isdefined('LvarMcodigo') and len(trim(#LvarMcodigo#)) gt 0>
			   <input type="hidden" name="Mcodigo" value="<cfoutput>#LvarMcodigo#</cfoutput>"/> 
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
			      
				<!---<strong>Centro Funcional:</strong>
				<select name="CFid" onchange="FuncSubmit();">
					<cfif rsSolicitanteXCfunc.recordcount gt 0>
						<cfloop query="rsSolicitanteXCfunc">
							<option <cfif LvarCFid eq rsSolicitanteXCfunc.CFid>selected </cfif> value="<cfoutput>#rsSolicitanteXCfunc.CFid#</cfoutput>"><cfoutput>#rsSolicitanteXCfunc.CFdescripcion#</cfoutput></option> 
						</cfloop>
					</cfif>			  
				</select>	--->							
				<strong> Tipo:</strong>				
				<select name="tipo" id="tipo"  onchange="FuncSubmit();" >	
					 <!---<cfif rsListaCategorias.CMTStarticulo eq 1>--->
           			   <option value="A" <cfif #LvarTipo# eq 'A'>Selected</cfif> >Articulo</option>
					<!--- </cfif> 
				     <cfif rsListaCategorias.CMTSservicio eq 1>--->
            		   <option value="S" <cfif #LvarTipo# eq 'S'>Selected</cfif>>Servicio</option>
					 <!---</cfif>  
				    <cfif rsListaCategorias.CMTSactivofijo eq 1>--->
				        <option value="F" <cfif #LvarTipo# eq 'F'>Selected</cfif>>Activo Fijo</option>
					<!---</cfif>	 ---> 	
					 <option value="P" <cfif #LvarTipo# eq 'P'>Selected</cfif>>Obras</option>						  
				</select>					
			</td>			
		</tr>
		
		
		<cfinvoke 
			component="sif.Componentes.PlanCompras"
			method="GetDetallePlanCompra"
			returnvariable="PlanComprasDet">
				<cfinvokeargument name="PCGDtipo" value="#LvarTipo#"/>
				<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>							
		</cfinvoke>						  
		 <!---<cfinvokeargument name="CFid" value="#LvarCFid#"/>--->
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
			<td align="center"  valign="top">
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#PlanComprasDet#"/>
					<cfinvokeargument name="desplegar" value="PCGDdescripcion, PCGDcantidadTotal, PCGDcantidad, PCGDcantidadCompras, PCGDautorizadoTotal, PCGDautorizado, TotalConsumido"/>
					<cfinvokeargument name="etiquetas" value="Descripción, Cantidad total, Cantidad del periodo Actual, Cantidad Consumida, Autorizado Total, Autorizado del periodo, Consumido"/>
					<cfinvokeargument name="formatos" value="S, M, M, M, M, M, M, S"/>
					<cfinvokeargument name="align" value="center, center, center, center, center, center, center, center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="key" value="PCGDid" />
					<cfinvokeargument name="irA" value="popUp-PlanComprasCP.cfm?tipo=#LvarTipo#"/>
					<cfinvokeargument name="showEmptyListMsg" value="false"/>
					<cfinvokeargument name="MaxRows" value="3"/>
					<cfinvokeargument name="conexion" value="#session.dsn#"/>
					<cfinvokeargument name="usaAJAX" value="yes"/>
					<cfinvokeargument name="funcion" value="fnAsignarLista"/>
					<cfinvokeargument name="fparams" value="PCGDid,PCGDdescripcion"/>
					<cfinvokeargument name="formname" value="form3"/>
					<cfinvokeargument name="incluyeform" value="false"/>	
				</cfinvoke>
			</td>
			<td align="center" valign="top" >
				<cfquery name="rsImpuestos" datasource="#Session.DSN#">
					select Icodigo, Idescripcion, 1 as ord
					from Impuestos
					where Ecodigo= #session.Ecodigo#
					union
					 select '-1' as Icodigo,'-- Seleccione impuesto --' as Idescripcion, 0 as ord from dual
					 order by ord,Idescripcion
				</cfquery>
				<select name='listaImpuestos' id='listaImpuestos'>
					<cfloop query="rsImpuestos">
						<cfoutput><option value='#Icodigo#'>#Icodigo#-#Idescripcion#</option></cfoutput>
					</cfloop>
				</select>
			</td>			
		</tr>			
		<tr>  
		   		<td  align="center">
					<select size="8" name="listaSugerida"  id="listaSugerida" multiple="multiple">
					</select>
					<label id="msg">No se han selecionado lineas</label>					
				</td>									
		</tr>	
		<tr>
	    	<td align="center" height="30px"><input name="agregar" value="Agregar" type="submit" disabled="disabled"/></td>
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

  var ids = new Array();
  
  function fnAsignarLista(id,descripcion)
  {
  	
  	lista = document.getElementById("listaSugerida");
	for(i = 0; i < lista.length; i++){
		if(listaSugerida.options[i].value == id)			 
			return false;
	}
	listaImp = document.form1.listaImpuestos;
	if(parseInt(listaImp.value) <= 0)
	   {  
	      alert("Primero elija un impuesto"); 		    
		  return false;
		}
	else{
		i = listaImp.selectedIndex;
		option = document.createElement("option");
		option.value = id;
		option.ondblclick = function(){fnDesasignarLista(this);}
		option.innerHTML = descripcion + " - " + listaImp[i].text;
		lista.appendChild(option);
		fnEdicion(lista);
		ids[lista.length - 1] = [id,listaImp.value]
	}
  }
    function fnDesasignarLista(obj)
  {
  	lista = document.getElementById("listaSugerida");
	idSeleccionado = lista.selectedIndex;
	lista.removeChild(obj);
	fnEdicion(lista);
	l = document.form1.listaSugerida;
	ids[idSeleccionado] = [null,null]
  }
  
  function selecionarTodos(){
	sel = document.getElementById("VarSelecionados");
	t = "";
	for(i = 0; i < ids.length; i++){
		if(ids[i][0]!= null)
			t+=ids[i][0]+"/"+ids[i][1]+",";
	}
	sel.value=t;
	return true;
  }
  
   function fnEdicion(lista){
		boton = document.form1.agregar;
		boton.disabled = (lista.length > 0 ? "" : "disabled") ;
		listaSugerida.style.display = (lista.length > 0 ? "" : "none") ;
		 document.getElementById("msg").style.display = (lista.length > 0 ? "none" : "") ;
		
  }
  fnEdicion( document.form1.listaSugerida);
</script>
