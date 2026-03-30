<cfinclude template="../../Utiles/sifConcat.cfm">
<cfset LvarTipoDocumento = 8>
<form action="TransaccionCustodiaP_sql.cfm" name="form1" method="post" >
<cfoutput>
<cfif isdefined ('form.tipo')>
	<input name="tipo" type="hidden" value="#form.tipo#" />
</cfif> 
</cfoutput>
<cfif isdefined('url.GELid') and len(trim(url.GELid)) gt 0>
	<cfset form.id=#url.GELid#>
		<cfset modo = 'CAMBIO'>
</cfif>
<cfif isdefined ('form.GELid') and  len(trim(form.GELid)) gt 0>
	<cfset form.id=#form.GELid#>
		<cfset modo = 'CAMBIO'>
</cfif>
<cfif isdefined('url.GEAid') and not isdefined ('form.GEAid')>
	<cfset form.GEAid=#url.GEAid#>
		<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined('url.tipo') and not isdefined ('form.tipo')>
	<cfset form.tipo=#url.tipo#>
	<cfoutput>
	<input name="tipo" type="hidden" value="#form.tipo#" />
		<cfset modo = 'CAMBIO'>
</cfoutput>
</cfif>

<cfif isdefined('form.tipo') and #form.tipo# neq 'ANTICIPO'>
	<cfset GELid=#id#>
		<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset GEAid=#id#>
		<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined('id')>
   <cfset llave=#id#>
<cfset modo = 'CAMBIO'>

<cfif isdefined ('form.tipo') and form.tipo eq 'GASTOS' or isdefined ('form.GELid')>
		<cfquery datasource="#session.dsn#" name="encaLiqui">
			select 	
			ant.GELid,
			ant.CFid,
			ant.GELnumero as numero,
			ant.GELfecha as fecha,
			ant.GELdescripcion as descripcion,
			ant.GELreembolso,
			
			(
				select  min(us.Usulogin)	
				from STransaccionesProceso a
					inner join Usuario us
						on a.BMUsucodigo=us.Usucodigo
				where a.CCHTrelacionada= #id#
				and a.CCHTestado='POR CONFIRMAR'
			) as usuario,
						
			
				( select min(rtrim(cf.CFcodigo) #_Cat# '-' #_Cat# cf.CFdescripcion)
					from CFuncional cf 
					where cf.CFid = ant.CFid
				) as CentroFuncional,
				
				(select min(Em.DEnombre #_Cat# ' ' #_Cat# Em.DEapellido1 #_Cat# ' ' #_Cat# Em.DEapellido2)
					from DatosEmpleado Em,TESbeneficiario te
					where ant.TESBid=te.TESBid and   Em.DEid=te.DEid  
				) as Empleado,	
						
				(select min(Ca.CCHcodigo)
					from CCHica Ca
					where ant.CCHid=Ca.CCHid  
				) as CCHcodigo,		
				
				(select min(CP.CCHTtipo)
					from CCHTransaccionesCProceso CP
					where ant.GELid=CP.CCHTCrelacionada
					and ant.CCHTid=CP.CCHTid  
				) as CCHTtipo,	
				
				(select min(Mo.Mnombre)
					from Monedas Mo
					where ant.Mcodigo=Mo.Mcodigo
				)as Moneda,													
				coalesce(ant.GELtotalGastos,0) as GELtotalGastos,
				ant.GELtipoCambio as Cambio,
				coalesce(ant.GELtotalAnticipos,0) as GELtotalAnticipos,
				coalesce(ant.GELtotalDepositos,0) as GELtotalDepositos,
				coalesce(ant.GELtotalDevoluciones,0) as GELtotalDevoluciones,
				ant.GELdescripcion,ant.GELmsgRechazo, ant.TESid		
			from GEliquidacion ant 				
			where GELid = #id#
	</cfquery>

	<cfset neto=#encaLiqui.GELtotalAnticipos#-(#encaLiqui.GELtotalGastos#+#encaLiqui.GELtotalDevoluciones#)>
<cfelseif isdefined ('form.tipo') and form.tipo neq 'GASTOS'>

<cfquery datasource="#session.dsn#" name="encaLiqui">

			select 
			ant.CFid,
			ant.GEAnumero as numero,
			ant.GEAfechaPagar as fecha,
			ant.GEAdescripcion as descripcion,
			ant.GEAtotalOri as anticipo,
			b.GECdescripcion,
			c.GEADmonto,

			(
				select  min(us.Usulogin)	
				from STransaccionesProceso a
					inner join Usuario us
						on a.BMUsucodigo=us.Usucodigo
				where a.CCHTrelacionada= <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#" >
				and a.CCHTestado='POR CONFIRMAR'
			) as usuario,
			
				( select min(rtrim(cf.CFcodigo) #_Cat# '-' #_Cat# cf.CFdescripcion)
					from CFuncional cf 
					where cf.CFid = ant.CFid
				) as CentroFuncional,
				
				(select min(Em.DEnombre #_Cat# ' ' #_Cat# Em.DEapellido1 #_Cat# ' ' #_Cat# Em.DEapellido2)
					from DatosEmpleado Em,TESbeneficiario te
					where ant.TESBid=te.TESBid and   Em.DEid=te.DEid  
				) as Empleado,	
						
				(select min(Ca.CCHcodigo)
					from CCHica Ca
					where ant.CCHid=Ca.CCHid  
				) as CCHcodigo,		
				
				(select min(g.GETdescripcion)
					from GEtipoGasto g
					where b.GETid=g.GETid
				)as TipoGasto,
				
				(select min(CP.CCHTtipo)
					from CCHTransaccionesCProceso CP
					where ant.GEAid=CP.CCHTCrelacionada  
				) as CCHTtipo,			
						
				(select min(Mo.Mnombre)
					from Monedas Mo
					where ant.Mcodigo=Mo.Mcodigo
				)as Moneda,		
				ant.GEAmanual as Cambio,
									
				ant.GEAdescripcion	
			from GEanticipo ant 		
				inner join GEanticipoDet c
				on c.GEAid=ant.GEAid		
				inner join GEconceptoGasto b
				on  b.GECid=c.GECid	
			where ant.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#" >
		</cfquery>
		<cfquery name="detAnt" datasource="#session.dsn#">
			select a.GECid ,b.GECdescripcion, c.GETdescripcion,a.GEADmonto
			from GEanticipoDet a
				inner join GEconceptoGasto b
					inner join GEtipoGasto c
					on c.GETid=b.GETid
				on a.GECid =b.GECid
			where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#id#" >
		</cfquery>
	</cfif>
</cfif>

<!---Total Anticipos --->
<cfquery name="totalAntic" datasource="#session.dsn#">
	select coalesce(sum(GELAtotal),0) as totalAnticipos 
	from GEliquidacionAnts 
	where GELid=1
</cfquery>

<cfoutput>
<script language="javascript" type="text/javascript">
	function funcImprime(){
		var PARAM  = "Recibo_Dinero.cfm?id=#id#"
		window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=600,height=400')
		return false;
		}
		
	function funcRechazar(){
		<cfif isdefined ("encaLiqui.GELid")>	
			var vReason = prompt('¿Desea RECHAZAR la Transacción <cfoutput>#encaLiqui.numero#</cfoutput>?, Debe digitar una razón de rechazo!','');
			if (vReason && vReason != ''){
				document.form1.CCHTCRechazo.value = vReason;
				return true;
			}
			if (vReason=='')
				alert('Debe digitar una razón de rechazo!');
			return false;
		</cfif>
		}
		
</script>	
	<table align="center" summary="Tabla de entrada"  width="90%" border="0">
	<input name="id" type="hidden" <cfif isdefined ('form.id')>value="#form.id#"</cfif> />
	<input type="hidden" name="CCHTCRechazo" value="" />
		<tr>
			<td valign="top" align="right" width="160" nowrap="nowrap"><strong>N&uacute;m. Transacci&oacute;n:</strong></td>
			
			<td width="170" valign="top">#encaLiqui.numero#</td>						
			<td width="201" align="right" valign="top"><strong>Fecha Transacci&oacute;n:</strong></td>
			<td width="319" valign="top">#LSDateFormat(encaLiqui.fecha,"DD/MM/YYYY")#</td>
		</tr>
		<tr>
			<td align="right"><strong>Centro&nbsp;Funcional:</strong></td>
			<td colspan="1">#encaLiqui.CentroFuncional#</td>
		</tr>								
		<tr>
		  <td valign="top" align="right"></td>
		  <td valign="top"></td>
		  <td rowspan="6" valign="top" align="right" nowrap>
		   
		    <p><strong>Descripci&oacute;n:</strong></p></td>
		  <td rowspan="6" valign="top" align="left">
		    <textarea name="GELdescripcion" onkeypress="return false;" cols="50" rows="4" MAXLENGTH=20>#encaLiqui.descripcion#
			</textarea>		 </td>
   		</tr>
		<tr>
			<td align="right" nowrap="nowrap"> <strong>Empleado Liquidante:</strong></td>
			<td width="170" valign="top" nowrap="nowrap"><cfif #id# NEQ "">#encaLiqui.Empleado#</cfif>	</td>
		</tr>		
		<tr>
			<td valign="top" align="right"><strong> Moneda:</strong></td>
			<td valign="top">#encaLiqui.Moneda#</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong>Tipo de Cambio:</strong></td>
			<td valign="top">#encaLiqui.Cambio#</td>
		</tr>
		<tr>
		  <td>
		  <td colspan="3">		  </td>
		</tr>
		<tr>
		  <td valign="top" align="right"><div align="right"><strong>Caja:</strong></div></td>
		  <td valign="top">#encaLiqui.CCHcodigo#</font></td>
		  <td width="1" align="right" valign="top" nowrap>&nbsp;</td>
		  <td width="1" valign="top">&nbsp;</td>
		</tr>
		<tr>
		  <td valign="top" align="right"><div align="right"><strong>Tipo de Transacci&oacute;n: </strong></div></td>
		  <td valign="top">#encaLiqui.CCHTtipo#</font></td>
		  <td valign="top" align="right" nowrap><strong>Autorizado por:</strong></td>
		  <td valign="top">#encaLiqui.usuario#</font></td>
		</tr>
		<tr>
		<td valign="top" align="right">&nbsp;</td>
		  <td valign="top">&nbsp;</td>
<cfif isdefined ('form.tipo') and #form.tipo# eq 'GASTOS' or isdefined ('form.GELid')>
		  <td valign="top" align="right" nowrap><strong>Total Anticipos:</strong></td>
		  <td valign="top">
<!---Monto en Anticipos--->
			<cfif #encaLiqui.GELtotalAnticipos# LT 0>
				<span class="style3">ERROR: Monto es menor 0 </span>
				
			  <cfelseif #encaLiqui.GELtotalAnticipos#  GT 0>
				#NumberFormat(encaLiqui.GELtotalAnticipos ,"0.00")#
			<cfelse>
				<span class="style2">No hay anticipos Asociados</span>
			</cfif>			</td>
		<cfelse>
		  <td valign="top" align="right" nowrap><strong>Monto Aprobado:</strong></td>
		  <td valign="top">#NumberFormat(encaLiqui.anticipo,"0.00")#</font></td>
		 </cfif>
    	</tr>		
		<tr>
			<td valign="top" align="right">&nbsp;</td>
		 	<td valign="top">&nbsp;</td>
<cfif  isdefined ('form.tipo') and #form.tipo# eq 'GASTOS' or isdefined ('form.GELid')>
			<td valign="top" align="right" nowrap><strong>Total de Gastos:</strong></td>
			<td valign="top">
<!---Monto en Doc Liquidantes--->
			<cfif encaLiqui.GELtotalGastos LT 0>
			  <span class="style3">	Monto en Facturas menor a 0</span>
			  <cfelseif encaLiqui.GELtotalGastos GT 0>
				#NumberFormat(encaLiqui.GELtotalGastos,"0.00")#
			<cfelse>
				<span class="style2">No hay Facturas</span>
			</cfif>			</td>
		<cfelse>
			<cfif isdefined ('form.tipo') and form.tipo neq 'GASTOS'>
			  <td colspan="5" align="right">
			  <fieldset><legend><strong>Detalles del Anticipo</strong></legend>
			  	<table border="1" align="center" width="50%" bordercolor="999999" bordercolordark="333333" cellpadding="0" cellspacing="0">
					<tr>
					  <td nowrap="nowrap" align="center"><strong>&nbsp;&nbsp;Tipo de Gasto&nbsp;&nbsp;</strong></td>
					  <td nowrap="nowrap" align="center"><strong>&nbsp;&nbsp;Concepto de Gasto&nbsp;&nbsp;</strong></td>
					  <td nowrap="nowrap" align="center"><strong>&nbsp;&nbsp;Monto&nbsp;&nbsp;</strong></td>
					</tr>
					<cfloop query="detAnt">
					  <tr>
						<td>#detAnt.GETdescripcion#</td>
						<td>#detAnt.GECdescripcion#</td>
						<td>#detAnt.GEADmonto#</td>
					  </tr>
					</cfloop>
              </table>
			  </fieldset>
			  </td>
			<cfelse>
				<td valign="top" align="right"><div align="right"><strong>Tipo de Gasto: </strong></div></td>
				<td valign="top">#encaLiqui.TipoGasto#</font></td>		
			</cfif>
		</cfif>
   		</tr>
		<tr>
			<td valign="top" align="right" width="160"><strong></strong></td>
			<td width="170" valign="top"></td>		
<cfif  isdefined ('form.tipo') and #form.tipo# eq 'GASTOS' or isdefined ('form.GELid')>
			<td valign="top">			</td>
		<cfelse>
			<cfif isdefined ('form.tipo') and form.tipo neq 'GASTOS'>
			<cfelse>
			<td valign="top" align="right"><div align="right"><strong>Concepto de Gasto: </strong></div></td>
		  <td valign="top">#encaLiqui.GECdescripcion#</font></td>		
		  </cfif>
		</cfif>		
    	</tr>
		<tr>
			<td valign="top" align="right" width="160"><strong></strong></td>
			<td width="170" valign="top"></td>	
		<cfif isdefined ('form.id') and isdefined ('form.tipo') and #form.tipo# eq 'GASTOS' or isdefined ('form.GELid')>
			<td valign="top" align="right" nowrap><strong>Total Devoluciones:</strong></td>
			<td valign="top">
			<cfset devoluciones=0>
			<cfif #encaLiqui.GELtotalDevoluciones# LT 0>
			  <span class="style3">	Monto en Devoluciones menor a 0	</span>
			 <cfelseif #encaLiqui.GELtotalDevoluciones# GT 0>
				#NumberFormat(encaLiqui.GELtotalDevoluciones,"0.00")#
			<cfelse>
				<span class="style2">No hay Devoluciones</span>
			</cfif>			</td>
		</cfif>
    	</tr>
		<tr>
			<td valign="top" align="right" width="160"><strong></strong></td>
			<td width="170" valign="top"></td>	
			<td valign="top" align="right" nowrap><strong>Monto Neto:</strong></td>
			<td>#neto#</td>
		</tr>
		<tr>
			<td valign="top" align="right" width="160"><strong></strong></td>
			<td width="170" valign="top"></td>					
			<td valign="top" align="right" nowrap>		   </td>
		</tr>
		<tr>
		  <td colspan="4" class="formButtons" align="center">
		  
		<cfif  isdefined ('form.tipo') and form.tipo eq 'GASTOS' and isdefined('encaliqui.GELtotalGastos') and #encaliqui.GELtotalGastos# neq 0 or isdefined ('form.GELid') and isdefined('encaliqui.GELtotalGastos') and #encaliqui.GELtotalGastos# neq 0>
			<cfset btnNameArriba 	= "IrLista">
			<cfset btnValuesArriba	= "Lista Liquidaciones">
			<cf_botones modo='Cambio' tabindex="1" 
				include="#btnNameArriba#,Rechazar,Imprime" 
				includevalues="#btnValuesArriba#,Rechazar,Imprime"
				exclude="Cambio,Baja,Nuevo,Alta,Limpiar">
				
		<cfelseif isdefined ('form.id') and isdefined ('form.tipo') and form.tipo eq 'GASTOS' or isdefined ('form.GELid')>
	        <cfset btnNameArriba 	= "IrLista">
			<cfset btnValuesArriba	= "Lista Gastos">
			<cf_botones modo='Cambio' tabindex="1" 
				include="#btnNameArriba#,Imprime" 
				includevalues="#btnValuesArriba#,Imprime"
				exclude="Cambio,Baja,Nuevo,Alta,Limpiar">
		<cfelse>
			<cfset btnNameArriba 	= "IrLista">
			<cfset btnValuesArriba	= "Lista Liquidaciones">
			
			<cf_botones modo='Cambio' tabindex="1" 
				include="#btnNameArriba#" 
				includevalues="#btnValuesArriba#"
				exclude="Cambio,Baja,Nuevo,Alta,Limpiar">
		</cfif>
			
		<cfif  isdefined('encaLiqui.GELtotalAnticipos') and #encaLiqui.GELtotalAnticipos# neq 0  and isdefined('encaLiqui.GELtotalGastos') and #encaLiqui.GELtotalGastos# neq 0 and #encaLiqui.GELtotalGastos#  lt #encaLiqui.GELtotalAnticipos# or isdefined ('form.tipo') and #form.tipo# eq 'ANTICIPO'>
			<cfinclude template="CCHbtn_erdoc.cfm">  
		</cfif>		
		</tr>
		<tr>
			<cf_botones values="Aplicar" name="Aplicar" tabindex="1">
		</tr>
	</table>
  </form>
</cfoutput>

<!---TAP--->
<cfif isdefined ('form.id') and isdefined ('form.tipo') and form.tipo eq 'GASTOS' or isdefined ('form.GELid')>

<cf_templatecss>
			<cfif not isdefined("form.tab") and isdefined("url.tab") >

               <cfset form.tab = url.tab >
    		 </cfif>
			 <cfif not ( isdefined("form.tab") and ListContains('1,2,3', form.tab) )>

               <cfset form.tab = 1 >
    		</cfif>
          <br />
	 <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_DatosGenerales"
    Default="Anticipos"
    returnvariable="LB_Anticipos"/>
    
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Cuentas"
    Default="Gastos Empleado"
    returnvariable="LB_Gastos"/>    

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Depositos"
	Default="Devoluciones"
	returnvariable="LB_Depositos"/>
	
	<!---  	<cf_tabs width="99%">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_DatosGenerales"
			Default="Anticipos"
			returnvariable="X"/>
			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Cuentas"
				Default="Gastos Empleado"
				returnvariable="y"/>

				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Devoluciones"
				Default="Devoluciones"
				returnvariable="LB_Devoluciones"/> 

			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Depositos"
				Default="Depositos"
				returnvariable=""/>	--->
					
			<!---	<cf_tab text="Anticipos" selected="#form.tab eq 1#">
				<cfdump var="a">
					<cfinclude template="tap_Anticipos.cfm">	
				</cf_tab>
				
				<cf_tab text="Gastos" selected="#form.tab eq 2#">
				<cfdump var="b">
					<cfinclude template="tap_liquidacionesCP.cfm">
				</cf_tab>
  			
				<cf_tab text="Devoluciones" selected="#form.tab eq 3#">
				<cfdump var="c">
					<cfinclude template="tap_Devoluciones.cfm">
				</cf_tab>

			</cf_tabs>--->
			<cf_tabs width="100%">

				<cf_tab text="#LB_Anticipos#" selected="#form.tab eq 1#">
				<cfinclude template="tap_Anticipos.cfm">
					</cf_tab>
				
				<cf_tab text="#LB_Gastos#" selected="#form.tab eq 2#">
				  <cfinclude template="tap_liquidacionesCP.cfm">
				</cf_tab>
				
				<cf_tab text="#LB_Depositos#" selected="#form.tab eq 3#">
					<cfinclude template="tap_Devoluciones.cfm">
				</cf_tab>
		</cf_tabs>
</cfif>
		<cf_web_portlet_end>
        </td>
      </tr>
    </table>

	
	

