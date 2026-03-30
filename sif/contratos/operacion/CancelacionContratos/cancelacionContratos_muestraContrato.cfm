<!--- <cf_dump var="#form#"> --->

<!--- JMRV. 12/08/2014. --->

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

	<!--- Trae el encabezado del contrato --->
	<cfquery name="rsContratoEncabezado" datasource="#Session.DSN#">
		select 	a.CTCnumContrato, a.CTContid, a.CTCdescripcion, a.CTPCid, 
				a.CTFLid, a.CTmonto, a.SNid,
				a.CTfechaFirma, a.CTfechaIniVig, a.CTfechaFinVig
				
		from 	CTContrato a
					
		where 	a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
		and      a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<cfif isdefined("rsContratoEncabezado.SNid") and rsContratoEncabezado.SNid neq "">
	<!--- Trae la descripcion del proveedor --->
		<cfquery name="rsProveedor" datasource="#Session.DSN#">
			select SNnombre 
			from SNegocios
			where   SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoEncabezado.SNid#">
			and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>
	
	<cfif isdefined("rsContratoEncabezado.CTFLid") and rsContratoEncabezado.CTFLid neq "">
		<!--- Trae la descripcion de Fundamento legal --->
		<cfquery name="rsFundamentoLegal" datasource="#Session.DSN#">
			select CTFLdescripcion
			from CTFundamentoLegal
			where CTFLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoEncabezado.CTFLid#">
			and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>
	
	<cfif isdefined("rsContratoEncabezado.CTPCid") and rsContratoEncabezado.CTPCid neq "">
		<!--- Trae la descripcion de Procedimiento de contratacion --->
		<cfquery name="rsProcedimientoContratacion" datasource="#Session.DSN#">
			select CTPCdescripcion
			from CTProcedimientoContratacion
			where CTPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoEncabezado.CTPCid#">
			and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>
     
  
 <!--- Impresion de datos en pantalla --->                  
	<cfoutput> 
		<tr><td nowrap>&nbsp;</td></tr>
		
		<form name="form1" id="form1">
		
			<table align="center" summary="Tabla de entrada" border="0">
				<tr>
					<td valign="top" align="right"><strong>Núm. Contrato:&nbsp;</strong></td>
					<td valign="top"><strong>#rsContratoEncabezado.CTCnumContrato#</strong></td>
				</tr>
				
				<tr>	
					<td valign="top" align="right"><strong>Descripción:&nbsp;</strong></td>
				<cfif isdefined("rsContratoEncabezado.CTCdescripcion") and rsContratoEncabezado.CTCdescripcion neq "">
					<td valign="top"><strong>#rsContratoEncabezado.CTCdescripcion#</strong></td>
				<cfelse>
					<td valign="top" align="right"><strong></strong></td>
				</cfif>
				</tr>
				
                 <tr>
					<td align="right"><strong>Procedimiento de Contratación:&nbsp;</strong></td>
				<cfif isdefined("rsProcedimientoContratacion.CTPCdescripcion") and rsProcedimientoContratacion.CTPCdescripcion neq "">
					<td colspan="3"><strong>#rsProcedimientoContratacion.CTPCdescripcion#</strong></td>
				<cfelse>
					<td valign="top" align="right"><strong></strong></td>
				</cfif>
				</tr>
               
				<tr>
					<td align="right"><strong>Fundamento Legal:&nbsp;</strong></td>
				<cfif isdefined("rsFundamentoLegal.CTFLdescripcion") and rsFundamentoLegal.CTFLdescripcion neq "">
					<td colspan="3"><strong>#rsFundamentoLegal.CTFLdescripcion#</strong></td>
				<cfelse>
					<td valign="top" align="right"><strong></strong></td>
				</cfif>
				</tr>
				
				<tr>
					<td align="right"><strong>Importe:&nbsp;</strong></td>
				<cfif isdefined("rsContratoEncabezado.CTmonto") and rsContratoEncabezado.CTmonto neq "">
					<td colspan="3"><strong>#rsContratoEncabezado.CTmonto#</strong></td>
				<cfelse>
					<td valign="top" align="right">0<strong></strong></td>
				</cfif>
				</tr>
				
				<tr>
					<td align="right"><strong>Proveedor:&nbsp;</strong></td>
				<cfif isdefined("rsProveedor.SNnombre") and rsProveedor.SNnombre neq "">
					<td colspan="3"><strong>#rsProveedor.SNnombre#</strong></td>
				<cfelse>
					<td valign="top" align="right"><strong></strong></td>
				</cfif>
				</tr>
				
				<tr>
					<td align="right"><strong>Fecha de Firma:&nbsp;</strong></td>
				<cfif isdefined("rsContratoEncabezado.CTfechaFirma") and rsContratoEncabezado.CTfechaFirma neq "">
					<td colspan="3"><strong>#LSDateFormat(rsContratoEncabezado.CTfechaFirma,'dd/mm/yyyy')#</strong></td>
				<cfelse>
					<td valign="top" align="right"><strong></strong></td>
				</cfif>
				</tr>
				
				<tr>
					<td align="right"><strong>Inicio de Vigencia:&nbsp;</strong></td>
				<cfif isdefined("rsContratoEncabezado.CTfechaIniVig") and rsContratoEncabezado.CTfechaIniVig neq "">
					<td colspan="3"><strong>#LSDateFormat(rsContratoEncabezado.CTfechaIniVig,'dd/mm/yyyy')#</strong></td>
				<cfelse>
					<td valign="top" align="right"><strong></strong></td>
				</cfif>
				</tr>
				
				<tr>
					<td align="right"><strong>Fin de Vigencia:&nbsp;</strong></td>
				<cfif isdefined("rsContratoEncabezado.CTfechaFinVig") and rsContratoEncabezado.CTfechaFinVig neq "">
					<td colspan="3"><strong>#LSDateFormat(rsContratoEncabezado.CTfechaFinVig,'dd/mm/yyyy')#</strong></td>
				<cfelse>
					<td valign="top" align="right"><strong></strong></td>
				</cfif>
				</tr>
                							
	</cfoutput>		

	<!--- Pintado de cada detalle --->
	<cfoutput>
			<tr><td nowrap>&nbsp;</td></tr>
			<tr><td nowrap>&nbsp;</td></tr>
			
			<cfset LvarTitulo = "Detalle del Contrato">
			<cf_web_portlet_start border="true" titulo="#LvarTitulo#" skin="#Session.Preferences.Skin#" width="80%">
								
			<!--- Query para pintar las lineas de detalle --->
				<cfquery datasource="#session.dsn#" name="listaDetCont">
				    select 	c.CPformato, a.CTDCdescripcion, d.CFcodigo,
							e.Miso4217, isnull(a.CTDCmontoTotal,0) as CTDCmontoTotal, 
							isnull(a.CTDCmontoConsumido,0) as CTDCmontoConsumido, dist.CPDCdescripcion,
							case
								when a.CMtipo = 'S' then 'Servicio'
								when a.CMtipo = 'F' then 'Activo Fijo'
								when a.CMtipo = 'C' then 'Clasificacion Inventario'
								else 'Otro'
							end as Item
					
					from 	CTDetContrato a
								
								inner join CTContrato b
								on a.CTContid = b.CTContid
								
								left join CPresupuesto c
								on a.CPcuenta = c.CPcuenta
								
								left join CFuncional d
								on a.CFid = d.CFid
								
								left join Monedas e
								on b.CTMcodigo = e.Mcodigo
								
								left join CPDistribucionCostos dist
								on a.CPDCid = dist.CPDCid
						
					where  a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
					and    b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
				<cfquery name="verificaDistribucion" datasource="#session.dsn#">
					select a.CTDCont
					from CTDetContrato a
					where  a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
					and    a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and    a.CPDCid is not null
				</cfquery>
                
                <cfif isdefined("verificaDistribucion") and verificaDistribucion.recordCount gt 0>
                	<cfset LvarDeplegar = "Item,CPDCdescripcion,CPformato,CTDCdescripcion,CFcodigo,Miso4217,CTDCmontoTotal,CTDCmontoConsumido">
					<cfset LvarEtiquetas = "Item, Distribución,Cuenta Presupuestal, Descripción, Centro Funcional, Moneda, Monto, Monto Consumido">
					<cfset LvarFormatos = "V,V,V,V,V,V,M,M">
					<cfset LvarAlign = "center,center,center,center,center,center,center,center">
					<cfset LvarAlinear = "S,S,S,S,S,S,S,S">
                <cfelse>
					<cfset LvarDeplegar = "Item,CPformato,CTDCdescripcion,CFcodigo,Miso4217,CTDCmontoTotal,CTDCmontoConsumido">
					<cfset LvarEtiquetas = "Item,Cuenta Presupuestal, Descripción, Centro Funcional, Moneda, Monto, Monto Consumido">
					<cfset LvarFormatos = "V,V,V,V,V,M,M">
					<cfset LvarAlign = "center,center,center,center,center,center,center">
					<cfset LvarAlinear = "S,S,S,S,S,S,S">
				</cfif>
				
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#listaDetCont#"
					desplegar	= "#LvarDeplegar#"
					etiquetas	= "#LvarEtiquetas#"
					formatos	= "#LvarFormatos#"
					align		= "#LvarAlign#"	 
					ajustar		= "#LvarAlinear#"
					fontsize	= "11"
					showEmptyListMsg="yes"
					incluyeForm="No"
					showLink="No"
					maxRows="10"
					width="100%"/>				     
												                              
			<cf_web_portlet_end>
            
            <input type="hidden" name="razonCancelacion">
            <input type="hidden" name="CTContid" value="#Form.CTContid#">
		</form>
		
		<tr><td nowrap>&nbsp;</td></tr>

         <table  align="center">         
		 	<tr>
          	<td> 
          		<input type= "button" class = "btnNormal" name="Cancelar" value="Cancelar" onclick="javascript:funcCancelar();" />
				<input type="submit" class = "btnAnterior" value="Regresar" name="Regresar" id="Regresar" onClick="javascript:history.back()" />
          	</td>
			</tr>      
		</table>           
  
	</cfoutput>
	
	<script type="text/javascript">
		
   function funcCancelar(){
			
				if (confirm('¿Desea Cancelar este Contrato?')){ 
					var vReason = prompt('<cfoutput> Debe digitar una razon de cancelación</cfoutput>!','');

					   if(vReason != null){
							if (vReason != ''){
							
								var CTContid = document.form1.CTContid.value;
	
								location.href = "cancelacionContratos_sql.cfm?CTContid="+CTContid+"&razonCancelacion="+vReason;								
								return true;
							}
					   }
						if (vReason==''){
							alert('<cfoutput>Debe digitar una razón de cancelación para poder eliminar el contrato.</cfoutput>!');
							return false;
						}	
				}
   }

	</script>

