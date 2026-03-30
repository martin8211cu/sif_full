<cfset btnNameArriba = "">
<cfset btnValuesArriba= "">
<cfset btnNameAbajo = "">
<cfset btnValuesAbajo= "">

<!---Mensajes--->
	<cfif isdefined ('url.Mensaje')>
		<script language="javascript">
			alert("No se puede ingresar un monto mayor al Monto Solicitado o el Saldo de este");
		</script>
	</cfif>
	
	<cfif isdefined ('url.Mensaje1') and isdefined('url.Liqui')>
		<cfoutput>
			<script language="javascript">
				alert("Este anticipo fue utilizado en la Liquidacion #url.Liqui# y no ha sido aprobado por lo tanto no se puede utilizar");
			</script>
		</cfoutput>
	</cfif>

	<cfquery name="verifica" datasource="#session.dsn#">
		select count(1) as cantidad  from GEanticipo
		where TESBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.TESBid#">
	</cfquery>
	
	
	<cfquery name="seleccionaAnticipos" datasource="#session.dsn#">		
		select a.TESSPid, a.TESSPnumero,b.TESSPid, b.GEAnumero,b.GEAid ,b.TESBid
		from TESsolicitudPago a 
		inner join GEanticipo b 
		on a.TESSPid = b.TESSPid
		where a.TESSPtipoDocumento = 6 and a.TESSPestado=12
	</cfquery>
	<cfloop query="seleccionaAnticipos">
		<cfquery name="actualizaAnticipos" datasource="#session.dsn#">		
			update  GEanticipo
			set 
			GEAestado=4
			where GEAid=#seleccionaAnticipos.GEAid# 	
		</cfquery>
	</cfloop>
<!---Modos--->

<cfif isdefined('url.GEADid') and not isdefined('form.GEADid')>
	<cfparam name="form.GEADid" default="#url.GEADid#">
</cfif>
			
	<cfif isdefined('form.GEADid')>
			<cfset modoAnt = 'CAMBIO'>		
	<cfelse>
			<cfset modoAnt = 'ALTA'>
	</cfif>

<cfif modoAnt EQ 'CAMBIO'>	
	<cfquery datasource="#session.dsn#" name="rsForm">
		select 	a.CFcuenta,
				a.GEADid,
				a.GEAid,
				a.GECid,
				a.GEADmonto,
				a.GEADutilizado,
				a.TESDPaprobadopendiente,
				f.CFformato,
				b.GEAnumero,
				b.GEAdescripcion,
				b.GEAfechaSolicitud,
				b.GEAtotalOri,
				c.GECdescripcion,
				x.GELAtotal			 
			from 
				GEanticipoDet a
					inner join GEanticipo b
						inner join CFinanciera f
						on f.CFcuenta=b.CFcuenta
					on b.GEAid=a.GEAid
				inner join GEconceptoGasto c
				on a.GECid=c.GECid
				inner join GEliquidacionAnts x
				on x.GEADid=a.GEADid
			where 
			 a.GEADid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEADid#">
			and x.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			</cfquery>
</cfif>

<!---ANTICIPOS--->
<cfoutput>

<table width="85%" align="right" summary="Tabla de entrada" border="0">
<form method="post" name="form4" action="Tab1_Anticipos_sql.cfm?tipo=#LvarSAporEmpleadoSQL#"onSubmit="return validarAnt(this);" id="form4"/ >	
	
<!---**************************************************MODO_ALTA***************************************************************--->
<cfif modoAnt eq 'Alta' >

		<cfquery name="CompruebaAnticipos" datasource="#session.dsn#">
				select
				count(1) as cantidad 
				from
				GEanticipo
				where
				Ecodigo =#session.Ecodigo#
				and TESBid=(select TESBid from GEliquidacion where GELid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GELid#">)
				and GEAestado=4
	</cfquery>

	
<cfif CompruebaAnticipos.cantidad eq 0>
	<tr>
		<td align="center"><strong>***El empleado no tiene anticipos relacionados***</strong></td>
	</tr>
<cfelse>
<tr>
<input type="hidden" name="GELid" id="GELid" value="<cfif isdefined ("form.GELid")>#form.GELid#</cfif>"/>
<td align="center" valign="top" width="45%" class="tituloListas" >
	<div align="center">Lista de Anticipos disponibles para el empleado</div>	
		<!--- 
			Lista de Anticipos Liquidables:
				Todos los anticipos que todavÃ­a tengan lÃ­neas con saldo, que no estÃ©n en proceso de pago
		--->
	
		<cfquery datasource="#session.dsn#" name="ListaAnticipos">	
			select a.GEAid,a.GEAnumero,a.GEAfechaSolicitud,a.GEAdescripcion,a.GEAtotalOri,b.Mcodigo,a.Mcodigo,'AgregaAnticipo' as lista, coalesce (a.GEAviatico,'0') as viatico, 
				case 
                        when 
                             a.GEAviatico = '1'  
                        then 
                        	'<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
                        else
                            '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'
                        end as viaticoIco 
			  from GEliquidacion b
				inner join GEanticipo a
				 on a.Mcodigo		= b.Mcodigo
					and a.Ecodigo		= #session.Ecodigo#
					and a.TESBid		= b.TESBid
					and a.GEAestado	= 4  <!----- DEBE SER 4=Pagado--->
					<cfif LvarSAporComision>
						and a.GECid = b.GECid
					<cfelse>
						and
							case
								when b.CCHid is null then 0
								when (select CCHtipo from CCHica where CCHid = b.CCHid) = 2 then 0
								else b.CCHid
							end
							=
							case
								when a.CCHid is null then 0
								when (select CCHtipo from CCHica where CCHid = a.CCHid) = 2 then 0
								else a.CCHid
							end
							<!---
								Se puede volver a esta condición cuando la caja especial se guarde como GEAtipoP=1 y GELtipoP=1
								and a.GEAtipoP=b.GELtipoP
								and (a.GEAtipoP=1 or a.CCHid=b.CCHid)	
							--->
					</cfif>
				where b.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">			
				and (			<!---	-- Cuando todavia existan detalles que no estan por liquidar: cantidadXliquidar < cantidadAnticipoD--->
						(
							select count(1)
							  from GEliquidacionAnts d
								inner join GEliquidacion e
								 on e.GELid 		= d.GELid
								and e.GELestado 	in (0,1,2,3)
								<!-----and e.TESBid = b.TESBid--->
							 where d.GEAid = a.GEAid
						) <
						(
							select count(1)
							  from GEanticipoDet
							 where GEAid = a.GEAid
							   and GEADmonto - GEADutilizado - TESDPaprobadopendiente > 0
						) 
				)
			<!--- where b.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and (				<!----- Cuando todavia existan detalles que no estan por liquidar: cantidadXliquidar < cantidadAnticipoD--->
						(
							select count(1)
							  from GEliquidacionAnts d
								inner join GEliquidacion e
								 on e.GELid 		= d.GELid
								and e.GELestado 	in (0,1,2)
								<!-----and e.TESBid = b.TESBid--->
							 where d.GEAid = a.GEAid
						) <
						(
							select count(1)
							  from GEanticipoDet
							 where GEAid = a.GEAid
							   and GEADmonto - GEADutilizado - TESDPaprobadopendiente > 0
						) 
				)--->
		</cfquery>
		
		<cfif LvarSAporComision>
			<cfset LvarViatico1 = "">
			<cfset LvarViatico2 = "">
		<cfelse>
			<cfset LvarViatico1 = ",viaticoIco">
			<cfset LvarViatico2 = ",Viatico">
		</cfif>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
			query="#ListaAnticipos#"
			desplegar="GEAnumero,GEAfechaSolicitud,GEAdescripcion,GEAtotalOri#LvarViatico1#"
			etiquetas="Anticipo,Fecha,Descripci&oacute;n,Monto#LvarViatico2#"
			formatos="S,D,S,M,S"
			align="left,left,left,left,left"
			ira="Tab1_Anticipos_sql.cfm?Lista=lista&tipo=#LvarSAporEmpleadoSQL#"
			showEmptyListMsg="yes"
			keys="GEAid"
			maxRows="10"
			PageIndex="2"
			form_method="post"
			showLink="yes"
			formName="form4"
			incluyeForm="false"									
			navegacion="&GELid=#form.GELid#"
		/>
	</td>
</tr>
	</cfif>

</cfif>
<!---**************************************************************************************************************************--->
<!---**************************************************MODO_CAMBIO*************************************************************--->
<cfif modoAnt eq 'Cambio'>
	<input type="hidden" name="GELid" id="GELid" value="<cfif isdefined ("form.GELid")>#form.GELid#</cfif>"/>
	<input type="hidden" name="GEADid" id="GEADid" value="<cfif isdefined ("form.GEADid")>#form.GEADid#</cfif>"/>
	<input type="hidden" name="GEAid" id="GEAid" value="<cfif isdefined ("form.GEAid")>#form.GEAid#</cfif>"/>
	<!---<input type="hidden" name="viatico" id="viatico" value="#ListaAnticipos.viatico#"/>--->
	<!---NUMEROANT-FECHA--->	
			<tr>
				<td  nowrap="nowrap" align="right" valign="top"><strong>Anticipo:</strong></td>
				<td><input disabled="disabled" type="text" name="Ant" id="Ant" value="<cfif modoAnt neq 'Alta'>#rsForm.GEAnumero#</cfif>"/></td>
				<td  nowrap="nowrap" align="right" valign="top"><strong>Fecha:</strong></td>
				<td><input disabled="disabled" type="text" name="Fecha" id="Fecha" value="<cfif modoAnt neq 'Alta'>#DateFormat(rsForm.GEAfechaSolicitud,'DD/MM/YYYY')#</cfif>"/></td>
			</tr>
			
	<!---DESCRIPCION--->		
			<tr>
				<td  nowrap="nowrap" align="right" valign="top"><strong>Descripcion:</strong></td>
				<td nowrap="nowrap" colspan="3"><input disabled="disabled" type="text" size="55" name="Desc" id="Desc" value="<cfif modoAnt neq 'Alta'>#rsForm.GEAdescripcion#</cfif>"/></td>
			</tr>
	
	<!---CONCEPTO--->		
			<tr>
				<td  nowrap="nowrap" align="right" valign="top"><strong>Concepto Gasto:</strong></td>
				<td><input  disabled="disabled" type="text" name="Concepto" id="Concepto" value="<cfif modoAnt neq 'Alta'>#rsForm.GECdescripcion#</cfif>"/></td>
			</tr>
	
	<!---TOTAL--->
			<tr>
				<td  nowrap="nowrap" align="right" valign="top"><strong>Monto Anticipo:</strong></td>
				<td>
					<cfset valor_montoT = 0 >
					<cfset valor_montoT = LSNumberFormat(abs(rsForm.GEADmonto),"0.00") >		
					<cf_inputNumber name="MontoTotal" value="#valor_montoT#" size="15" enteros="13" decimales="2" readonly="true">
				</td>
			</tr>
			
	<!---MONTOSaldo--->
		<tr>
			<td width="173" align="right" valign="top"><strong>Saldo Anticipo:</strong></td>
			<td width="800"> 
				<cfif modoAnt EQ 'CAMBIO'>
					<cfquery name="busqueda" datasource="#session.dsn#">
							select 
								GEADmonto,
								GEADutilizado,
								TESDPaprobadopendiente				
							from 
								GEanticipoDet
							where 
								GEADid= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.GEADid#">
					</cfquery>
					<!---Operaciones--->
						<cfset saldo=0>
						<cfset monto=busqueda.GEADmonto>
						<cfif #busqueda.GEADutilizado# eq ''>
							<cfset utilizado=0>
						<cfelse>
							<cfset utilizado=busqueda.GEADutilizado>
						</cfif>
						<cfset aprobada=busqueda.TESDPaprobadopendiente>
						<cfset valor_montos = 0 >
						<cfset saldo=monto-utilizado-aprobada>
						<cfset valor_montos = LSNumberFormat(abs(saldo),"0.00")>
								<cf_inputNumber name="MontoSaldo" value="#valor_montos#" size="15" enteros="13" decimales="2" readonly="true">
				<cfelse>
					<cfset valor_montos = 0 >							
							<cf_inputNumber name="MontoSaldo" value="0.00" size="15" enteros="13" decimales="2" readonly="true">			
				</cfif>
			</td>
		</tr>
	
	<!---MONTOALIQUIDAR--->
		<tr>
				<td  nowrap="nowrap" align="right" valign="top"><strong>Monto a Liquidar:</strong></td>
				<td >
					<cfset valor_monto = 0 >
						<cfif modoAnt neq 'ALTA'>
							<cfset valor_monto = LSNumberFormat(abs(rsForm.GELAtotal),"0.00") >
						</cfif>
					<cf_inputNumber name="MontoAnticipo" value="#valor_monto#" size="15" enteros="13" decimales="2">
				</td>
			</tr>
	
	
	
	<!---BOTONES--->
	
	<tr>
		
			<tr><td colspan="4">			
				<cfset btnExcluirAbajo			="Cambio,Baja,Nuevo,Alta,Limpiar">
				<cfset btnNameAbajo				= btnNameAbajo&",BajaAnt">
				<cfset btnValuesAbajo			= btnValuesAbajo&",Eliminar">
				<cfset btnNameAbajo				= btnNameAbajo&",CambioAnt">
				<cfset btnValuesAbajo			= btnValuesAbajo&",Modificar">
				<cfset btnNameAbajo				= btnNameAbajo&",NuevoAnt">
				<cfset btnValuesAbajo			= btnValuesAbajo&",Nuevo">
				<cf_botones modoAnt="#modoAnt#" includevalues="#btnValuesAbajo#" include="#btnNameAbajo#" exclude="#btnExcluirAbajo#" >
			</td></tr>
	
</tr>
</cfif>
</form>	

</table>
</cfoutput>

<script type="text/javascript">
function funcBajaAnt(){

return confirm("Desea Eliminar el Registro?")

}


	function validarAnt(formulario)	{
		
		if (!btnSelected('NuevoAnt',document.form4)){
				var error_input = null;;
				var error_msg = '';
		
				
				if (formulario.MontoTotal.value == "") 
				{
					error_msg += "\n - El monto del anticipo en blanco.";
					if (error_input == null) error_input = formulario.MontoTotal;
				}
				else if (parseFloat(formulario.MontoTotal.value) <= 0)
				{
					error_msg += "\n - No se puede insertar un anticipo con monto menor o igual a 0.";
					if (error_input == null) error_input = formulario.MontoTotal;
				}
	
				if (error_msg.length != "") {
					alert("Por favor revise los siguiente datos:"+error_msg);
					try 
					{
						error_input.focus();
					} 
					catch(e) 
					{}
					
					return false;
					}
				
					formulario.MontoAnticipo.value=qf(formulario.MontoAnticipo);
				}
				}
	</script>

<script type="text/javascript">
function funcCargaMto(parametro){

document.form4.MontoTotal.value=parametro;
}
</script>




